/* OSCE Online — conexão P2P (PeerJS), sessão com fila de estações e modos.
   host  = paciente/avaliador (monta a sessão, controla timer, avalia)
   guest = estudante (atende)

   Modos:
   - conteudos : só estações das áreas selecionadas (sem ver o texto)
   - aleatoria : 1 estação sorteada por vez, sem fim (host encerra)
   - infinito  : todas as estações, sem repetir, até acabarem
   - osce      : 4 estações aleatórias, uma após a outra
*/
(() => {
  const $ = (s) => document.querySelector(s);
  const $$ = (s) => document.querySelectorAll(s);
  const CASES = window.OSCE_CASES;
  const CASE = (id) => CASES.find((c) => c.id === id);

  const MODE_LABEL = {
    conteudos: "Conteúdos selecionados",
    aleatoria: "Aleatória",
    infinito: "Infinito",
    osce: "Modo OSCE",
  };

  const state = {
    role: null,
    peer: null,
    conn: null,
    connectTimer: null,
    caseObj: null,
    prog: { n: 0, total: null },
    timer: { remaining: 0, running: false, intervalId: null },
    scores: {},
    ready: { host: false, guest: false, self: false },
    pendingMode: null, // modo escolhido antes de confirmar conteúdos
    chatOn: true,      // true = à distância (com chat); false = presencial
    session: null,     // { mode, queue, index, lastId, count, results }
  };

  // ---------- navegação ----------
  function show(id) {
    $$(".screen").forEach((s) => s.classList.remove("active"));
    $("#" + id).classList.add("active");
  }
  function setStatus(text, cls) {
    const el = $("#status");
    el.textContent = text;
    el.className = "status " + cls;
  }

  // ---------- util ----------
  function shuffle(arr) {
    const a = arr.slice();
    for (let i = a.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [a[i], a[j]] = [a[j], a[i]];
    }
    return a;
  }
  function nl(s) { return escapeHtml(s).replace(/\n/g, "<br>"); }
  function escapeHtml(s) {
    return String(s).replace(/[&<>"']/g, (m) =>
      ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[m]));
  }

  // ---------- código de sala ----------
  function makeCode() {
    const c = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    let s = "";
    for (let i = 0; i < 5; i++) s += c[Math.floor(Math.random() * c.length)];
    return s;
  }
  const PREFIX = "osce-ped-";

  // ICE servers: STUN (descobre IP público) + TURN (retransmite quando o NAT
  // bloqueia a conexão direta — essencial entre redes/dados móveis diferentes).
  const PEER_OPTS = {
    config: {
      iceServers: [
        { urls: "stun:stun.l.google.com:19302" },
        { urls: "stun:stun1.l.google.com:19302" },
        {
          urls: [
            "turn:openrelay.metered.ca:80",
            "turn:openrelay.metered.ca:443",
            "turn:openrelay.metered.ca:443?transport=tcp",
          ],
          username: "openrelayproject",
          credential: "openrelayproject",
        },
      ],
    },
  };

  // ---------- mensagens P2P ----------
  function sendMsg(obj) {
    if (state.conn && state.conn.open) state.conn.send(obj);
  }
  function handleMsg(m) {
    switch (m.t) {
      case "case":
        state.caseObj = CASE(m.id);
        state.prog = m.prog || { n: 0, total: null };
        state.chatOn = m.chatOn !== false;
        state.scores = {};
        startStation();
        break;
      case "chat":
        addBubble(m.text, "them", m.who);
        break;
      case "timer":
        state.timer.remaining = m.remaining;
        state.timer.running = m.running;
        renderTimer();
        break;
      case "finish":
        showStationResult(m.total, m.max, m.items);
        break;
      case "ready": // só o host recebe (estudante ficou pronto)
        state.ready.guest = true;
        checkAdvance();
        break;
      case "sessionEnd":
        showSummary(m.summary);
        break;
    }
  }

  // ---------- conexão ----------
  function wireConn(conn) {
    state.conn = conn;
    conn.on("open", () => {
      clearTimeout(state.connectTimer);
      $("#lobbyMsg").textContent = "";
      setStatus("conectado", "on");
      if (state.role === "host") {
        $("#waitMsg").textContent = "Estudante conectado! Iniciando…";
        hostStartNext();
      }
    });
    conn.on("data", handleMsg);
    conn.on("close", () => setStatus("desconectado", "off"));
    conn.on("error", () => setStatus("erro de conexão", "off"));
  }

  // ---------- HOST: escolha de modo ----------
  function startHost() {
    state.role = "host";
    show("hostSetup");
  }

  // escolha de proximidade (com/sem chat)
  $$(".prox-card").forEach((card) => {
    card.onclick = () => {
      $$(".prox-card").forEach((c) => c.classList.remove("sel"));
      card.classList.add("sel");
      state.chatOn = card.dataset.prox === "remoto";
    };
  });

  $$(".mode-card").forEach((card) => {
    card.onclick = () => {
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

  function renderTagPicker() {
    const tags = [...new Set(CASES.flatMap((c) => c.conteudos))].sort();
    const box = $("#tagList");
    box.innerHTML = "";
    tags.forEach((t) => {
      const el = document.createElement("label");
      el.className = "tag";
      el.innerHTML = `<input type="checkbox" value="${t}">${t}`;
      el.querySelector("input").onchange = (e) =>
        el.classList.toggle("sel", e.target.checked);
      box.appendChild(el);
    });
  }
  $("#btnTagStart").onclick = () => {
    const sel = [...$$("#tagList input:checked")].map((i) => i.value);
    if (!sel.length) { $("#tagMsg").textContent = "Selecione ao menos um conteúdo."; return; }
    const match = CASES.filter((c) => c.conteudos.some((t) => sel.includes(t)));
    if (!match.length) { $("#tagMsg").textContent = "Nenhuma estação para esses conteúdos."; return; }
    startSession("conteudos", sel);
  };

  // ---------- HOST: montar sessão + criar sala ----------
  function buildQueue(mode, tags) {
    const all = CASES.map((c) => c.id);
    if (mode === "conteudos") {
      return shuffle(CASES.filter((c) => c.conteudos.some((t) => tags.includes(t))).map((c) => c.id));
    }
    if (mode === "infinito") return shuffle(all);
    if (mode === "osce") return shuffle(all).slice(0, 4);
    return []; // aleatoria: sorteio a cada estação
  }

  function startSession(mode, tags) {
    const queue = buildQueue(mode, tags);
    state.session = { mode, queue, index: 0, lastId: null, count: 0, results: [] };

    // info exibida ao host
    $("#modeLabel").textContent = MODE_LABEL[mode] + (state.chatOn ? " · com chat" : " · presencial");
    let info;
    if (mode === "aleatoria") info = "estações ilimitadas";
    else if (mode === "osce")
      info = `${queue.length} estações` + (queue.length < 4 ? ` (só ${queue.length} disponíveis)` : "");
    else info = `${queue.length} estaç${queue.length === 1 ? "ão" : "ões"}`;
    $("#queueInfo").textContent = info;

    // cria o Peer/sala
    const code = makeCode();
    state.peer = new Peer(PREFIX + code, PEER_OPTS);
    state.peer.on("open", () => {
      $("#roomCode").textContent = code;
      const link = location.origin + location.pathname + "?sala=" + code;
      const a = $("#inviteLink");
      a.textContent = link;
      a.href = link;
      $("#tagPanel").classList.add("hidden");
      $("#roomShare").classList.remove("hidden");
      setStatus("aguardando estudante", "wait");
    });
    state.peer.on("connection", (conn) => wireConn(conn));
    state.peer.on("error", (e) => {
      $("#waitMsg").textContent = "Erro ao criar sala: " + e.type + ". Recarregue e tente de novo.";
    });
  }

  // ---------- HOST: avançar na fila ----------
  function nextStation() {
    const s = state.session;
    if (s.mode === "aleatoria") {
      let pool = CASES.map((c) => c.id);
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

  function hostStartNext() {
    const nx = nextStation();
    if (!nx) { hostEndSession(); return; }
    state.ready = { host: false, guest: false, self: false };
    state.caseObj = CASE(nx.id);
    state.session.lastId = nx.id;
    state.prog = { n: nx.n, total: nx.total };
    state.timer.remaining = state.caseObj.tempo;
    state.scores = {};
    sendMsg({ t: "case", id: nx.id, prog: state.prog, chatOn: state.chatOn });
    startStation();
  }

  function checkAdvance() {
    if (state.role === "host" && state.ready.host && state.ready.guest) {
      hostStartNext();
    }
  }

  function hostEndSession() {
    sendMsg({ t: "sessionEnd", summary: state.session.results });
    showSummary(state.session.results);
  }

  // ---------- GUEST ----------
  function startGuest(code) {
    state.role = "guest";
    setStatus("conectando…", "wait");
    $("#lobbyMsg").textContent = "";
    state.peer = new Peer(undefined, PEER_OPTS);

    // se não conectar em ~25s, avisa (provável bloqueio de rede/firewall)
    state.connectTimer = setTimeout(() => {
      if (!(state.conn && state.conn.open)) {
        setStatus("desconectado", "off");
        $("#lobbyMsg").textContent =
          "Não foi possível conectar. Verifique o código e a internet; " +
          "redes corporativas/escolares podem bloquear a conexão.";
      }
    }, 25000);

    state.peer.on("open", () => {
      const conn = state.peer.connect(PREFIX + code, { reliable: true });
      wireConn(conn);
    });
    state.peer.on("error", (e) => {
      if (e.type === "peer-unavailable") {
        clearTimeout(state.connectTimer);
        setStatus("desconectado", "off");
        $("#lobbyMsg").textContent = "Sala não encontrada. Confira o código com o avaliador.";
      } else if (!(state.conn && state.conn.open)) {
        $("#lobbyMsg").textContent = "Tentando conectar… (" + e.type + ")";
      }
    });
  }

  // ---------- ESTAÇÃO ----------
  function startStation() {
    const c = state.caseObj;
    $("#stProgress").textContent = state.prog.total
      ? `Estação ${state.prog.n} de ${state.prog.total}`
      : `Estação ${state.prog.n}`;
    $("#stCaseTitle").textContent = c.titulo;
    $("#stCaseSub").textContent = c.especialidade;
    if (!state.timer.remaining) state.timer.remaining = c.tempo;
    renderTimer();

    // layout conforme proximidade (com/sem chat)
    const chatOn = state.chatOn;
    const isHost = state.role === "host";
    const showSideChecklist = !chatOn && isHost;
    $("#chatPanel").classList.toggle("hidden", !chatOn);
    $("#sideChecklistPanel").classList.toggle("hidden", !showSideChecklist);
    // guest presencial fica sem coluna direita → grade em coluna única
    $(".station-grid").classList.toggle("single", !chatOn && !isHost);

    renderRolePanel();
    if (chatOn) {
      $("#chatLog").innerHTML = "";
      addSys(isHost
        ? "Você é o PACIENTE/AVALIADOR. Siga o roteiro e marque o checklist."
        : "Você é o ESTUDANTE. Conduza a anamnese e a orientação pelo chat.");
    }
    $("#timerCtrls").style.display = isHost ? "flex" : "none";
    $("#btnFinish").classList.toggle("hidden", !isHost);
    show("station");
  }

  function renderRolePanel() {
    const c = state.caseObj;
    const p = $("#rolePanel");
    const chatOn = state.chatOn;
    if (state.role === "guest") {
      const dica = chatOn
        ? "Conduza pelo chat: apresente-se, colha a história, levante hipóteses e oriente."
        : "Conduza pessoalmente com o avaliador: apresente-se, colha a história, levante hipóteses e oriente.";
      p.innerHTML = `<h3>Instruções ao estudante</h3>
        <div class="block">${nl(c.resumo)}</div>
        <div class="block"><div class="label">Dica</div>${dica}</div>`;
    } else {
      const pac = c.paciente;
      // no modo presencial, o checklist vai para o painel ao lado (não inline)
      const checklistInline = chatOn
        ? `<div class="block"><div class="label">Checklist de avaliação</div>
             <div id="checklist"></div></div>`
        : "";
      p.innerHTML = `<h3>Roteiro do paciente — confidencial</h3>
        <div class="block"><div class="label">Personagem</div>${pac.personagem}<br>${nl(pac.contexto)}</div>
        <div class="block"><div class="label">O que revelar (conforme perguntado)</div>
          <ul>${pac.roteiro.map((r) => `<li>${escapeHtml(r)}</li>`).join("")}</ul></div>
        <div class="block"><div class="label">Achados de exame (se solicitado)</div>
          <div class="achados">${escapeHtml(pac.examesAchados)}</div></div>
        ${checklistInline}`;
      renderChecklist(chatOn ? "#checklist" : "#sideChecklist");
    }
  }

  function renderChecklist(targetSel) {
    const box = $(targetSel);
    if (!box) return;
    box.innerHTML = "";
    state.caseObj.checklist.forEach((item, i) => {
      const row = document.createElement("div");
      row.className = "chk";
      row.innerHTML = `<input type="checkbox" id="chk${i}">
        <label for="chk${i}">${escapeHtml(item.item)}</label>
        <span class="pts">${item.peso} pt</span>`;
      row.querySelector("input").onchange = (e) => { state.scores[i] = e.target.checked; };
      box.appendChild(row);
    });
  }

  // ---------- timer ----------
  function renderTimer() {
    const t = state.timer.remaining;
    const m = String(Math.floor(t / 60)).padStart(2, "0");
    const s = String(t % 60).padStart(2, "0");
    const el = $("#timer");
    el.textContent = `${m}:${s}`;
    el.classList.toggle("low", t <= 60);
  }
  function tick() {
    if (state.timer.remaining > 0) {
      state.timer.remaining--;
      renderTimer();
      broadcastTimer();
      if (state.timer.remaining === 0) pauseTimer();
    }
  }
  function broadcastTimer() {
    sendMsg({ t: "timer", remaining: state.timer.remaining, running: state.timer.running });
  }
  function startTimer() {
    if (state.timer.running) return;
    state.timer.running = true;
    state.timer.intervalId = setInterval(tick, 1000);
    broadcastTimer();
  }
  function pauseTimer() {
    state.timer.running = false;
    clearInterval(state.timer.intervalId);
    broadcastTimer();
  }
  function resetTimer() {
    pauseTimer();
    state.timer.remaining = state.caseObj.tempo;
    renderTimer();
    broadcastTimer();
  }

  // ---------- chat ----------
  function addBubble(text, who, label) {
    const div = document.createElement("div");
    div.className = "bubble " + who;
    div.innerHTML = `<span class="who">${escapeHtml(label)}</span>${escapeHtml(text)}`;
    const log = $("#chatLog");
    log.appendChild(div);
    log.scrollTop = log.scrollHeight;
  }
  function addSys(text) {
    const div = document.createElement("div");
    div.className = "sys";
    div.textContent = text;
    $("#chatLog").appendChild(div);
  }
  function myLabel() { return state.role === "host" ? "Paciente" : "Estudante"; }

  // ---------- resultado da estação ----------
  function computeResult() {
    const items = state.caseObj.checklist.map((it, i) => ({
      item: it.item, peso: it.peso, ok: !!state.scores[i],
    }));
    const max = items.reduce((a, b) => a + b.peso, 0);
    const total = items.reduce((a, b) => a + (b.ok ? b.peso : 0), 0);
    return { items, max, total };
  }
  function veredito(pct) {
    return pct >= 70 ? "Aprovado" : pct >= 50 ? "Limítrofe" : "Insuficiente";
  }
  function showStationResult(total, max, items) {
    const pct = max ? Math.round((total / max) * 100) : 0;
    $("#resultBody").innerHTML =
      `<div class="score-big">${total}/${max} <span style="font-size:1.1rem;color:var(--muted)">(${pct}%) — ${veredito(pct)}</span></div>
       <div style="margin-top:14px">` +
      items.map((it) =>
        `<div class="res-row"><span>${escapeHtml(it.item)}</span>
         <span class="${it.ok ? "ok" : "no"}">${it.ok ? "✓ " + it.peso : "✗ 0"}</span></div>`).join("") +
      `</div>`;

    // prepara o handshake de "pronto"
    state.ready.self = false;
    const box = document.querySelector(".ready-box");
    box.classList.remove("done");
    $("#btnReady").disabled = false;
    $("#readyMsg").textContent = "";
    $("#btnRestart").classList.toggle("hidden", state.role !== "host");
    show("result");
  }

  // ---------- resumo da sessão ----------
  function showSummary(results) {
    const body = $("#summaryBody");
    if (!results || !results.length) {
      body.innerHTML = "<p>Nenhuma estação concluída.</p>";
    } else {
      const total = results.reduce((a, r) => a + r.total, 0);
      const max = results.reduce((a, r) => a + r.max, 0);
      const pct = max ? Math.round((total / max) * 100) : 0;
      body.innerHTML =
        results.map((r, i) => {
          const p = r.max ? Math.round((r.total / r.max) * 100) : 0;
          return `<div class="sum-row"><span>${i + 1}. ${escapeHtml(r.titulo)}</span>
            <span class="sum-score">${r.total}/${r.max} (${p}%)</span></div>`;
        }).join("") +
        `<div class="sum-total">Total: ${total}/${max} (${pct}%) — ${veredito(pct)}</div>`;
    }
    show("summary");
  }

  // ---------- eventos de UI ----------
  $("#btnHost").onclick = startHost;
  $("#btnJoin").onclick = () => {
    const code = $("#joinCode").value.trim().toUpperCase();
    if (code.length < 4) { $("#lobbyMsg").textContent = "Digite o código da sala."; return; }
    startGuest(code);
  };
  $("#joinCode").addEventListener("keydown", (e) => { if (e.key === "Enter") $("#btnJoin").click(); });

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

  $("#btnStart").onclick = startTimer;
  $("#btnPause").onclick = pauseTimer;
  $("#btnReset").onclick = resetTimer;

  $("#chatForm").addEventListener("submit", (e) => {
    e.preventDefault();
    const text = $("#chatInput").value.trim();
    if (!text) return;
    addBubble(text, "me", myLabel());
    sendMsg({ t: "chat", text, who: myLabel() });
    $("#chatInput").value = "";
  });

  $("#btnFinish").onclick = () => {
    pauseTimer();
    const r = computeResult();
    state.session.results.push({ titulo: state.caseObj.titulo, total: r.total, max: r.max });
    sendMsg({ t: "finish", total: r.total, max: r.max, items: r.items });
    showStationResult(r.total, r.max, r.items);
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
})();
