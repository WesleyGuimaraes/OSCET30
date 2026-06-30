/* Montagem da sessão: papel do host/guest, fila de estações, modos e avanço. */

import {
  state, isEvaluator, getCases, CASE,
  isCasesReady, getCasesError, setSetupNotice,
} from "./store.js";
import { $, shuffle, makeCode, setStatus } from "./util.js";
import { MODE_LABEL } from "./config.js";
import { sendMsg, hostCreateRoom, guestJoinRoom } from "./connection.js";
import { startStation, showSummary } from "./station.js";

// ---------- HOST: escolha de modo ----------
export function startHost() {
  state.role = "host";
  // avisa logo se ainda está carregando ou não há casos publicados
  if (!isCasesReady()) setSetupNotice("Carregando casos…");
  else if (!getCases().length)
    setSetupNotice(
      getCasesError() ||
        "Ainda não há casos publicados. Cadastre e publique casos no painel administrativo."
    );
  else setSetupNotice("");
}

// ---------- HOST: montar sessão + criar sala ----------
function buildQueue(mode, tags) {
  const all = getCases().map((c) => c.id);
  if (mode === "conteudos") {
    return shuffle(getCases().filter((c) => c.conteudos.some((t) => tags.includes(t))).map((c) => c.id));
  }
  if (mode === "infinito") return shuffle(all);
  return []; // aleatoria: sorteio a cada estação
}

// tempoMin: tempo da estação escolhido no setup (minutos). Sobrescreve o
// tempo próprio de cada caso; null mantém o tempo definido no caso.
export function startSession(mode, tags, tempoMin) {
  const queue = buildQueue(mode, tags);
  const alternate = false; // alternância de papéis fica desligada por padrão
  const tempo = tempoMin ? tempoMin * 60 : null;
  state.session = { mode, queue, index: 0, lastId: null, count: 0, results: [], alternate, tempo };

  // info exibida ao host
  $("#modeLabel").textContent = MODE_LABEL[mode]
    + (tempo ? ` · ${tempoMin} min` : "");
  const info = `${queue.length} estaç${queue.length === 1 ? "ão" : "ões"}`;
  $("#queueInfo").textContent = info;

  // cria a sala (assina o canal Realtime) e mostra código/link quando pronto
  const code = makeCode();
  state.roomCode = code;
  hostCreateRoom(code, () => {
    $("#roomCode").textContent = code;
    const link = location.origin + location.pathname + "?sala=" + code;
    const a = $("#inviteLink");
    a.textContent = link;
    a.href = link;
    $("#cfgForm").classList.add("hidden");
    $("#roomShare").classList.remove("hidden");
    setStatus("aguardando estudante", "wait");
  });
}

// ---------- HOST: avançar na fila ----------
function nextStation() {
  const s = state.session;
  if (s.mode === "aleatoria") {
    let pool = getCases().map((c) => c.id);
    if (pool.length > 1 && s.lastId) pool = pool.filter((id) => id !== s.lastId);
    const id = pool[Math.floor(Math.random() * pool.length)];
    s.count++;
    return { id, n: s.count, total: null };
  }
  if (s.index >= s.queue.length) return null;
  const id = s.queue[s.index];
  s.index++;
  return { id, n: s.index, total: s.queue.length };
}

// roleMode: undefined/"auto" (segue o toggle "alternar a cada estação" do
// setup), "toggle" (força trocar quem é avaliador) ou "keep" (força manter)
export function hostStartNext(roleMode) {
  const nx = nextStation();
  if (!nx) { hostEndSession(); return; }
  const wasAvaliadorIsHost = isEvaluator(); // papel do host na estação que está terminando
  state.ready = { host: false, guest: false, self: false };
  state.caseObj = CASE(nx.id);
  state.session.lastId = nx.id;
  state.prog = { n: nx.n, total: nx.total };
  state.timer.remaining = state.session.tempo || state.caseObj.tempo;
  state.scores = {};
  let avaliadorIsHost;
  if (roleMode === "toggle") avaliadorIsHost = !wasAvaliadorIsHost;
  else if (roleMode === "keep") avaliadorIsHost = wasAvaliadorIsHost;
  // automático: host começa como avaliador; se "alternar", troca a cada estação
  else avaliadorIsHost = !(state.session.alternate && nx.n % 2 === 0);
  state.playRole = avaliadorIsHost ? "avaliador" : "estudante";
  sendMsg({ t: "case", id: nx.id, prog: state.prog, avaliadorIsHost });
  startStation();
}

export function checkAdvance() {
  if (state.role === "host" && state.ready.host && state.ready.guest) {
    hostStartNext();
  }
}

export function hostEndSession() {
  state.ended = true;
  sendMsg({ t: "sessionEnd", summary: state.session.results });
  showSummary(state.session.results);
}

// ---------- GUEST ----------
export function startGuest(code) {
  state.role = "guest";
  state.roomCode = code;
  $("#lobbyMsg").textContent = "";
  guestJoinRoom(code);
}
