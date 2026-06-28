/* Transporte da sessão via Supabase Realtime (Broadcast + Presence).
   Substitui o WebRTC/PeerJS: as mensagens do jogo viajam pelo mesmo
   WebSocket/HTTPS que já carrega os casos, então funcionam em redes
   restritas (faculdade) sem STUN/TURN. A reconexão é automática (o cliente
   Realtime reconecta o socket; a Presence re-sincroniza os participantes). */

import { state, isEvaluator, CASE, casesReadyPromise } from "./store.js";
import { $, setStatus } from "./util.js";
import { SALA_PREFIX, SUPABASE_URL, SUPABASE_ANON_KEY } from "./config.js";
import { startStation, broadcastTimer, renderTimer, studentTimerSync, storeAndShow, showSummary } from "./station.js";
import { hostStartNext, checkAdvance } from "./session.js";

// cliente Realtime dedicado (separado do client de leitura em db.js)
let sb = null;
function client() {
  if (!sb) sb = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
  return sb;
}

// envia uma mensagem do jogo para o outro lado (broadcast no canal da sala)
export function sendMsg(obj) {
  if (state.channel) {
    state.channel.send({ type: "broadcast", event: "msg", payload: obj });
  }
}

function handleMsg(m) {
  switch (m.t) {
    case "case":
      // o guest pode receber a estação antes de seus casos terminarem de
      // carregar; espera o carregamento e então monta a tela
      casesReadyPromise.then(() => {
        state.caseObj = CASE(m.id);
        if (!state.caseObj) {
          setStatus("caso indisponível", "off");
          return;
        }
        state.sessionStarted = true;
        state.prog = m.prog || { n: 0, total: null };
        // o host informa quem é o avaliador nesta estação; o guest é o oposto
        state.playRole = m.avaliadorIsHost ? "estudante" : "avaliador";
        state.scores = {};
        startStation();
      });
      break;
    case "timer":
      // o ESTUDANTE sincroniza o tempo e o estado (rodando/pausado) com o avaliador
      state.timer.remaining = m.remaining;
      state.timer.running = m.running;
      renderTimer();
      if (!isEvaluator()) studentTimerSync();
      break;
    case "finish":
      clearInterval(state.timer.intervalId);
      storeAndShow(m.total, m.max, m.items);
      break;
    case "ready": // só o host recebe (estudante ficou pronto)
      state.ready.guest = true;
      checkAdvance();
      break;
    case "sessionEnd":
      state.ended = true; // encerramento intencional
      showSummary(m.summary);
      break;
  }
}

// ---------- HOST: cria a sala (assina o canal) ----------
// onReady() é chamado quando o canal está pronto (mostra código/link).
export function hostCreateRoom(code, onReady) {
  const channel = client().channel(SALA_PREFIX + code, {
    config: { broadcast: { self: false }, presence: { key: "host" } },
  });
  state.channel = channel;

  channel.on("broadcast", { event: "msg" }, ({ payload }) => handleMsg(payload));

  // edge-triggered: detecta o estudante entrar/sair via 'sync' (robusto à
  // ordem — funciona mesmo se o estudante entrar antes do avaliador criar)
  let guestHere = false;
  channel.on("presence", { event: "sync" }, () => {
    const pres = channel.presenceState();
    const present = !!(pres.guest && pres.guest.length);
    if (present && !guestHere) {
      guestHere = true;
      onGuestPresent();
    } else if (!present && guestHere) {
      guestHere = false;
      if (!state.ended) setStatus("estudante caiu — aguardando reconexão…", "wait");
    }
  });

  channel.subscribe((status) => {
    if (status === "SUBSCRIBED") {
      channel.track({ role: "host" });
      onReady();
    } else if (status === "CHANNEL_ERROR" || status === "TIMED_OUT") {
      $("#waitMsg").textContent =
        "Não foi possível criar a sala (conexão de tempo real). Recarregue e tente de novo.";
    }
  });
}

// estudante apareceu na sala (presence join): inicia ou re-sincroniza.
function onGuestPresent() {
  clearTimeout(state.connectTimer);
  setStatus("conectado", "on");
  $("#waitMsg").textContent = "Estudante conectado! Iniciando…";
  if (!state.sessionStarted) {
    state.sessionStarted = true;
    hostStartNext();
  } else if (state.caseObj) {
    // reconexão do estudante: reenvia a estação atual + timer, sem avançar
    sendMsg({ t: "case", id: state.caseObj.id, prog: state.prog, avaliadorIsHost: isEvaluator() });
    broadcastTimer();
  }
}

// ---------- GUEST: entra na sala (assina o canal) ----------
export function guestJoinRoom(code) {
  const channel = client().channel(SALA_PREFIX + code, {
    config: { broadcast: { self: false }, presence: { key: "guest" } },
  });
  state.channel = channel;
  setStatus("conectando…", "wait");

  channel.on("broadcast", { event: "msg" }, ({ payload }) => handleMsg(payload));

  let hostSeen = false;
  channel.on("presence", { event: "sync" }, () => {
    const pres = channel.presenceState();
    if (pres.host && pres.host.length && !hostSeen) {
      hostSeen = true;
      clearTimeout(state.connectTimer);
      setStatus("conectado", "on");
      $("#lobbyMsg").textContent = "";
    }
  });

  channel.subscribe((status) => {
    if (status === "SUBSCRIBED") {
      channel.track({ role: "guest" });
      // se em ~12s nenhum avaliador aparecer, o código provavelmente está errado
      state.connectTimer = setTimeout(() => {
        if (!hostSeen) {
          setStatus("desconectado", "off");
          $("#lobbyMsg").textContent =
            "Sala não encontrada (ou o avaliador ainda não criou). Confira o código com ele.";
        }
      }, 12000);
    } else if (status === "CHANNEL_ERROR" || status === "TIMED_OUT") {
      $("#lobbyMsg").textContent =
        "Falha na conexão de tempo real. Verifique a internet e tente de novo.";
    }
  });
}

// teste de diagnóstico: o Realtime do Supabase está acessível nesta rede?
export function testRealtime(onResult) {
  const ch = client().channel("teste-" + Math.random().toString(36).slice(2));
  let done = false;
  const finish = (ok) => {
    if (done) return;
    done = true;
    clearTimeout(t);
    try { client().removeChannel(ch); } catch (e) {}
    onResult(ok);
  };
  const t = setTimeout(() => finish(false), 10000);
  ch.subscribe((status) => {
    if (status === "SUBSCRIBED") finish(true);
    else if (status === "CHANNEL_ERROR" || status === "TIMED_OUT") finish(false);
  });
}
