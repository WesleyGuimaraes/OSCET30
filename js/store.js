/* Estado compartilhado da sessão + acesso aos casos publicados (Supabase).
   É o singleton que os demais módulos leem/escrevem. */

import { $ } from "./util.js";

export const state = {
  role: null,            // papel de CONEXÃO: 'host' (criou a sala) | 'guest'
  playRole: "avaliador", // papel NA ESTAÇÃO: 'avaliador' | 'estudante' (pode alternar)
  peer: null,
  conn: null,
  connectTimer: null,
  caseObj: null,
  prog: { n: 0, total: null },
  timer: { remaining: 0, running: false, intervalId: null },
  scores: {},
  ready: { host: false, guest: false, self: false },
  pendingMode: null,     // modo escolhido antes de confirmar conteúdos
  session: null,         // { mode, queue, index, lastId, count, results }
  // --- robustez de conexão ---
  roomCode: null,        // código da sala (host criou / guest entrou) — p/ reconectar
  sessionStarted: false, // já começou a 1ª estação? (distingue conexão inicial de reconexão)
  ended: false,          // sessão encerrada de propósito (não tentar reconectar)
  reconnect: { tries: 0, timer: null },
};

// sou o avaliador (paciente) nesta estação?
export function isEvaluator() {
  return state.playRole === "avaliador";
}

// ---------- casos publicados (db.js -> window.loadOsceCases) ----------
let CASES = [];
let casesReady = false;
let casesErrorMsg = "";
let _resolveCases;
export const casesReadyPromise = new Promise((r) => (_resolveCases = r));

export const getCases = () => CASES;
export const isCasesReady = () => casesReady;
export const getCasesError = () => casesErrorMsg;
export const CASE = (id) => CASES.find((c) => c.id === id);

export async function loadCases() {
  try {
    CASES = await window.loadOsceCases();
  } catch (e) {
    CASES = [];
    casesErrorMsg = "Não foi possível carregar os casos do servidor. Tente recarregar a página.";
    // eslint-disable-next-line no-console
    console.error(e);
  }
  casesReady = true;
  _resolveCases();
}

// mostra/limpa o aviso no setup (carregando / sem casos / erro)
export function setSetupNotice(text) {
  const el = $("#setupNotice");
  if (!el) return;
  el.textContent = text || "";
  el.classList.toggle("hidden", !text);
}

// garante que há casos antes de iniciar um modo; senão avisa e bloqueia
export function casesGuard() {
  if (!casesReady) {
    setSetupNotice("Carregando casos… aguarde um instante e tente de novo.");
    return false;
  }
  if (!CASES.length) {
    setSetupNotice(
      casesErrorMsg ||
        "Ainda não há casos publicados. Cadastre e publique casos no painel administrativo."
    );
    return false;
  }
  setSetupNotice("");
  return true;
}
