/* Ponto de entrada: carrega os casos, fia os eventos da UI e o diagnóstico
   de conexão. Importa os módulos do jogo (sessão, estação, conexão). */

import { state, loadCases, casesGuard, isEvaluator } from "./store.js";
import { $, $$, show } from "./util.js";
import { PEER_OPTS } from "./config.js";
import {
  startHost, renderTagPicker, startSession, startGuest,
  hostStartNext, hostEndSession, checkAdvance,
} from "./session.js";
import { startTimer, pauseTimer, resetTimer, computeResult, storeAndShow } from "./station.js";
import { sendMsg } from "./connection.js";

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
// Verifica (1) se o servidor de sinalização do PeerJS é alcançável e
// (2) se a rede permite obter um candidato TURN (relay) — necessário em
// redes restritas como Wi-Fi/5G de faculdade.
function testConnection() {
  const out = $("#connResult");
  out.className = "conn-result show";
  out.innerHTML = "⏳ Testando… (uns 10 segundos)";

  let signalingOk = false, gotRelay = false, gotSrflx = false, doneSig = false;

  // (1) sinalização PeerJS
  const p = new Peer(undefined, PEER_OPTS);
  const sigTimer = setTimeout(() => finishSig(), 9000);
  p.on("open", () => { signalingOk = true; finishSig(); });
  p.on("error", () => finishSig());
  function finishSig() {
    if (doneSig) return;
    doneSig = true;
    clearTimeout(sigTimer);
    try { p.destroy(); } catch (e) {}
  }

  // (2) ICE/TURN
  const pc = new RTCPeerConnection(PEER_OPTS.config);
  pc.createDataChannel("t");
  pc.onicecandidate = (e) => {
    if (!e.candidate) return;
    const c = e.candidate.candidate || "";
    if (c.includes(" typ relay")) gotRelay = true;
    if (c.includes(" typ srflx")) gotSrflx = true;
  };
  pc.createOffer().then((o) => pc.setLocalDescription(o)).catch(() => {});

  setTimeout(() => {
    try { pc.close(); } catch (e) {}
    render();
  }, 10000);

  function render() {
    let cls, msg;
    if (signalingOk && gotRelay) {
      cls = "ok";
      msg = "✅ <b>Conexão OK</b> — funciona mesmo em redes restritas (TURN disponível).";
    } else if (signalingOk && gotSrflx) {
      cls = "warn";
      msg = "⚠️ <b>Conexão limitada</b> — deve funcionar em redes comuns, mas pode falhar em redes muito restritas (não obtive TURN). Se não conectar, tente o 4G/5G do celular.";
    } else if (signalingOk) {
      cls = "warn";
      msg = "⚠️ <b>Servidor acessível, mas a rede bloqueia o vídeo/áudio P2P</b> (sem STUN/TURN). Provável bloqueio de firewall — use outra rede (ex.: dados móveis do celular).";
    } else {
      cls = "bad";
      msg = "❌ <b>Esta rede bloqueia a conexão</b> (servidor de sinalização inacessível). Redes de faculdade/empresa costumam bloquear. Use o 4G/5G do celular ou outra rede.";
    }
    out.className = "conn-result show " + cls;
    out.innerHTML = msg;
  }
}
$("#btnTestConn").onclick = testConnection;
