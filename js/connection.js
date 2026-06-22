/* Camada P2P (PeerJS): envio/recepção de mensagens, fiação da conexão e
   reconexão automática quando a sessão já começou e a conexão cai. */

import { state, isEvaluator, CASE, casesReadyPromise } from "./store.js";
import { $, setStatus } from "./util.js";
import { PREFIX, PEER_OPTS } from "./config.js";
import { startStation, broadcastTimer, renderTimer, studentTimerSync, storeAndShow, showSummary } from "./station.js";
import { hostStartNext, checkAdvance } from "./session.js";

export function sendMsg(obj) {
  if (state.conn && state.conn.open) state.conn.send(obj);
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
        state.sessionStarted = true;       // a partir daqui, quedas tentam reconectar
        state.reconnect.tries = 0;
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
      state.ended = true; // encerramento intencional — não reconectar
      showSummary(m.summary);
      break;
  }
}

export function wireConn(conn) {
  state.conn = conn;
  conn.on("open", () => {
    clearTimeout(state.connectTimer);
    clearTimeout(state.reconnect.timer);
    state.reconnect.tries = 0;
    $("#lobbyMsg").textContent = "";
    setStatus("conectado", "on");
    if (state.role === "host") {
      if (!state.sessionStarted) {
        state.sessionStarted = true;
        $("#waitMsg").textContent = "Estudante conectado! Iniciando…";
        hostStartNext();
      } else {
        // reconexão do estudante: re-sincroniza a estação atual sem avançar
        resendCurrentStation();
      }
    }
  });
  conn.on("data", handleMsg);
  conn.on("close", onConnClose);
  conn.on("error", () => setStatus("erro de conexão", "off"));
}

// queda de conexão: se a sessão já estava em andamento e não foi encerrada de
// propósito, tenta reconectar (guest) ou aguarda o estudante voltar (host).
function onConnClose() {
  if (state.ended || !state.sessionStarted) {
    setStatus("desconectado", "off");
    return;
  }
  if (state.role === "guest") {
    scheduleGuestReconnect();
  } else {
    setStatus("estudante caiu — aguardando reconexão…", "wait");
  }
}

// HOST: ao estudante reconectar, reenvia a estação atual + estado do timer,
// para o guest remontar a tela exatamente onde parou (sem avançar a fila).
function resendCurrentStation() {
  setStatus("conectado", "on");
  if (!state.caseObj) return;
  sendMsg({ t: "case", id: state.caseObj.id, prog: state.prog, avaliadorIsHost: isEvaluator() });
  broadcastTimer();
}

// GUEST: tenta reconectar à mesma sala, recriando o Peer se necessário.
function scheduleGuestReconnect() {
  if (state.ended) return;
  if (state.reconnect.tries >= 6) {
    setStatus("desconectado", "off");
    $("#lobbyMsg").textContent = "Conexão perdida. Recarregue a página e entre de novo com o código.";
    return;
  }
  state.reconnect.tries++;
  setStatus("reconectando… (" + state.reconnect.tries + ")", "wait");
  clearTimeout(state.reconnect.timer);
  state.reconnect.timer = setTimeout(() => {
    try {
      if (!state.peer || state.peer.destroyed) {
        state.peer = new Peer(undefined, PEER_OPTS);
        state.peer.on("open", () => connectGuest());
        state.peer.on("error", () => scheduleGuestReconnect());
      } else {
        connectGuest();
      }
    } catch (e) {
      scheduleGuestReconnect();
    }
  }, 3000);
}

function connectGuest() {
  const conn = state.peer.connect(PREFIX + state.roomCode, { reliable: true });
  wireConn(conn);
  // watchdog: se esta tentativa não abrir, agenda a próxima
  setTimeout(() => {
    if (!(state.conn && state.conn.open) && !state.ended) scheduleGuestReconnect();
  }, 8000);
}
