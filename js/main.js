/* Ponto de entrada: carrega os casos, fia os eventos da UI e o diagnóstico
   de conexão. Importa os módulos do jogo (sessão, estação, conexão). */

import { state, loadCases, casesGuard, isEvaluator } from "./store.js";
import { $, $$, show } from "./util.js";
import {
  startHost, renderTagPicker, startSession, startGuest,
  hostStartNext, hostEndSession, checkAdvance,
} from "./session.js";
import { startTimer, pauseTimer, resetTimer, computeResult, storeAndShow } from "./station.js";
import { sendMsg, testRealtime } from "./connection.js";

// começa a carregar os casos publicados do Supabase logo de cara
loadCases();

// ---------- HOST: escolha de modo ----------
$("#btnHost").onclick = () => { startHost(); show("hostSetup"); };

$$(".mode-card").forEach((card) => {
  card.onclick = () => {
    if (!casesGuard()) return;
    const mode = card.dataset.mode;
    $$(".mode-card").forEach((c) => c.classList.remove("sel"));
    card.classList.add("sel");
    if (mode === "conteudos") {
      state.pendingMode = "conteudos";
      renderTagPicker();
      $("#tagPanel").classList.remove("hidden");
    } else {
      $("#tagPanel").classList.add("hidden");
      startSession(mode, null);
    }
  };
});

$("#btnTagStart").onclick = () => {
  const sel = [...$$("#tagList input:checked")].map((i) => i.value);
  if (!sel.length) { $("#tagMsg").textContent = "Selecione ao menos um conteúdo."; return; }
  startSession("conteudos", sel);
};

// ---------- lobby: entrar como estudante ----------
$("#btnJoin").onclick = () => {
  const code = $("#joinCode").value.trim().toUpperCase();
  if (code.length < 4) { $("#lobbyMsg").textContent = "Digite o código da sala."; return; }
  startGuest(code);
};
$("#joinCode").addEventListener("keydown", (e) => { if (e.key === "Enter") $("#btnJoin").click(); });

// ---------- copiar código / link ----------
$("#btnCopy").onclick = () => {
  navigator.clipboard.writeText($("#roomCode").textContent);
  $("#btnCopy").textContent = "copiado!";
  setTimeout(() => ($("#btnCopy").textContent = "copiar"), 1500);
};
$("#btnCopyLink").onclick = () => {
  navigator.clipboard.writeText($("#inviteLink").href);
  $("#btnCopyLink").textContent = "copiado!";
  setTimeout(() => ($("#btnCopyLink").textContent = "copiar link"), 1500);
};

// abriu via link de convite (?sala=CODE): pré-preenche o código para o estudante
(() => {
  const code = new URLSearchParams(location.search).get("sala");
  if (code) {
    $("#joinCode").value = code.toUpperCase();
    $("#lobbyMsg").textContent = "Código preenchido — toque em \"Entrar\" para conectar.";
    $("#joinCode").scrollIntoView({ behavior: "smooth", block: "center" });
  }
})();

// ---------- timer (avaliador) ----------
$("#btnStart").onclick = startTimer;
$("#btnPause").onclick = pauseTimer;
$("#btnReset").onclick = resetTimer;

// ---------- encerrar e avaliar ----------
$("#btnFinish").onclick = () => {
  if (!isEvaluator()) return;
  pauseTimer();
  const r = computeResult();
  sendMsg({ t: "finish", total: r.total, max: r.max, items: r.items });
  storeAndShow(r.total, r.max, r.items); // host guarda; guest só mostra
};

// host pula a estação atual sem aguardar avaliação/"prontos" dos dois lados
$("#btnSkipKeep").onclick = () => {
  if (state.role !== "host") return;
  hostStartNext("keep");
};
$("#btnSkipAlt").onclick = () => {
  if (state.role !== "host") return;
  hostStartNext("toggle");
};

// "pronto para a próxima"
$("#btnReady").onclick = () => {
  $("#btnReady").disabled = true;
  document.querySelector(".ready-box").classList.add("done");
  if (state.role === "host") {
    state.ready.host = true;
    $("#readyMsg").textContent = state.ready.guest ? "Iniciando…" : "Aguardando o estudante…";
    checkAdvance();
  } else {
    state.ready.self = true;
    $("#readyMsg").textContent = "Aguardando o avaliador iniciar a próxima…";
    sendMsg({ t: "ready" });
  }
};

// host encerra a sessão manualmente (sobretudo no modo aleatório)
$("#btnRestart").onclick = () => hostEndSession();
$("#btnNewSession").onclick = () => location.reload();

// ---------- diagnóstico de conexão ----------
// Verifica se o Realtime do Supabase (o transporte da sessão) está acessível
// nesta rede — é o que precisa funcionar na faculdade.
function testConnection() {
  const out = $("#connResult");
  out.className = "conn-result show";
  out.innerHTML = "⏳ Testando conexão… (uns segundos)";
  testRealtime((ok) => {
    out.className = "conn-result show " + (ok ? "ok" : "bad");
    out.innerHTML = ok
      ? "✅ <b>Conexão OK</b> — o servidor de tempo real está acessível nesta rede. O jogo deve funcionar normalmente."
      : "❌ <b>Esta rede está bloqueando a conexão</b> com o servidor. Tente os dados móveis (4G/5G) do celular ou outra rede.";
  });
}
$("#btnTestConn").onclick = testConnection;
