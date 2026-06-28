import { useEffect, useMemo, useState } from "react";
import {
  STATUS_META,
  fetchCasoCompleto,
  fetchChecklistBanco,
  gravLabel,
  normalizar,
  novoCasoVazio,
  mudarStatus,
  salvarCaso,
  apagarCaso,
} from "../lib/data.js";

const upBtnStyle = (can) => ({
  width: 24,
  height: 18,
  display: "grid",
  placeItems: "center",
  background: "transparent",
  border: "1px solid var(--c-line)",
  borderRadius: 5,
  color: can ? "var(--c-muted)" : "#33404d",
  cursor: can ? "pointer" : "default",
  fontSize: "0.6rem",
});

const palette = ["#3fb6a8", "#4a8bdf", "#e0a24a", "#48c78e", "#c08ad9", "#e07a8a", "#7ac0a0", "#d9b06a"];

export default function CaseEditor({ casoId, admin, taxonomia, onBack, onSalvo, onPreview, onHist }) {
  const isPriv = admin.role === "owner" || admin.role === "revisor";
  const [draft, setDraft] = useState(null);
  const [carregando, setCarregando] = useState(true);
  const [erroCarga, setErroCarga] = useState("");
  const [salvando, setSalvando] = useState(false);
  const [msg, setMsg] = useState(null); // {type:'ok'|'warn', text}
  const [banco, setBanco] = useState([]);
  const [bankOpen, setBankOpen] = useState(false);
  const [dirty, setDirty] = useState(false); // há alterações não salvas?

  // avisa o navegador antes de fechar/recarregar a aba com mudanças pendentes
  useEffect(() => {
    function handler(e) {
      if (!dirty) return;
      e.preventDefault();
      e.returnValue = "";
    }
    window.addEventListener("beforeunload", handler);
    return () => window.removeEventListener("beforeunload", handler);
  }, [dirty]);

  function sair() {
    if (dirty && !window.confirm("Você tem alterações não salvas. Sair mesmo assim?")) return;
    onBack();
  }

  const disciplinas = useMemo(() => [...new Set(taxonomia.map((c) => c.disciplina).filter(Boolean))], [taxonomia]);
  const periodos = useMemo(
    () => [...new Set(taxonomia.map((c) => c.periodo).filter(Boolean))].sort((a, b) => a - b),
    [taxonomia]
  );
  const [edDisc, setEdDisc] = useState("");
  const [edPer, setEdPer] = useState("");

  useEffect(() => {
    let ativo = true;
    setCarregando(true);
    setErroCarga("");
    const carregar = casoId ? fetchCasoCompleto(casoId) : Promise.resolve(novoCasoVazio());
    Promise.all([carregar, fetchChecklistBanco()])
      .then(([c, b]) => {
        if (!ativo) return;
        setDraft(c);
        setBanco(b);
        setDirty(false);
        const principal = c.conteudos.find((x) => x.principal) || c.conteudos[0];
        setEdDisc(principal?.disciplina || disciplinas[0] || "");
        setEdPer(principal ? String(principal.periodo) : periodos[0] ? String(periodos[0]) : "");
      })
      .catch((err) => ativo && setErroCarga(err.message || "Erro ao carregar caso."))
      .finally(() => ativo && setCarregando(false));
    return () => {
      ativo = false;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [casoId]);

  function patch(fn) {
    setDraft((d) => {
      const nd = { ...d };
      fn(nd);
      return nd;
    });
    setDirty(true);
    setMsg(null);
  }
  const setField = (k) => (e) => {
    const v = e.target.value;
    patch((d) => {
      d[k] = v;
    });
  };
  const setTempoMin = (e) => {
    const m = Math.max(0, parseInt(e.target.value, 10) || 0);
    patch((d) => {
      d.tempo_segundos = m * 60 + (d.tempo_segundos % 60);
    });
  };
  const setTempoSeg = (e) => {
    const s = Math.max(0, Math.min(59, parseInt(e.target.value, 10) || 0));
    patch((d) => {
      d.tempo_segundos = Math.floor(d.tempo_segundos / 60) * 60 + s;
    });
  };

  // roteiro
  const addRoteiro = () => patch((d) => (d.roteiro = [...d.roteiro, ""]));
  const setRoteiro = (i) => (e) => {
    const v = e.target.value;
    patch((d) => {
      d.roteiro = d.roteiro.slice();
      d.roteiro[i] = v;
    });
  };
  const delRoteiro = (i) => () => patch((d) => (d.roteiro = d.roteiro.filter((_, k) => k !== i)));
  const moveRoteiro = (i, dir) => () =>
    patch((d) => {
      const arr = d.roteiro.slice();
      const j = i + dir;
      if (j < 0 || j >= arr.length) return;
      [arr[i], arr[j]] = [arr[j], arr[i]];
      d.roteiro = arr;
    });

  // conteúdos
  const toggleConteudo = (c) => () =>
    patch((d) => {
      const exists = d.conteudos.find((x) => x.id === c.id);
      if (exists) d.conteudos = d.conteudos.filter((x) => x.id !== c.id);
      else d.conteudos = [...d.conteudos, { ...c, principal: d.conteudos.length === 0 }];
      if (!d.conteudos.some((x) => x.principal) && d.conteudos.length) d.conteudos[0].principal = true;
    });
  const setPrincipal = (id) => () =>
    patch((d) => {
      d.conteudos = d.conteudos.map((c) => ({ ...c, principal: c.id === id }));
    });
  const removeConteudo = (id) => () =>
    patch((d) => {
      const wasPrincipal = d.conteudos.find((c) => c.id === id)?.principal;
      d.conteudos = d.conteudos.filter((c) => c.id !== id);
      if (wasPrincipal && d.conteudos.length) d.conteudos[0].principal = true;
    });

  // checklist
  const addChecklist = () => patch((d) => (d.checklist = [...d.checklist, { texto: "", gravidade: 3, itemBaseId: null }]));
  const addFromBank = (item) => () =>
    patch((d) => (d.checklist = [...d.checklist, { texto: item.texto, gravidade: item.gravidade_padrao || 3, itemBaseId: item.id }]));
  const setChkTexto = (i) => (e) => {
    const v = e.target.value;
    patch((d) => {
      d.checklist = d.checklist.slice();
      d.checklist[i] = { ...d.checklist[i], texto: v, itemBaseId: null }; // editar desvincula do banco
    });
  };
  const setChkGrav = (i, g) => () =>
    patch((d) => {
      d.checklist = d.checklist.slice();
      d.checklist[i] = { ...d.checklist[i], gravidade: g };
    });
  const delChk = (i) => () => patch((d) => (d.checklist = d.checklist.filter((_, k) => k !== i)));
  const moveChk = (i, dir) => () =>
    patch((d) => {
      const arr = d.checklist.slice();
      const j = i + dir;
      if (j < 0 || j >= arr.length) return;
      [arr[i], arr[j]] = [arr[j], arr[i]];
      d.checklist = arr;
    });

  function validar(d) {
    if (!d.titulo?.trim()) return "Informe um título.";
    if (!d.resumo?.trim()) return "Preencha as instruções ao estudante (resumo).";
    if (!d.conteudos.length) return "Associe ao menos um conteúdo.";
    if (!d.checklist.length) return "Adicione ao menos um item ao checklist.";
    return null;
  }

  async function salvar() {
    if (!draft.titulo?.trim()) {
      setMsg({ type: "warn", text: "Dê um título ao caso antes de salvar." });
      return;
    }
    setSalvando(true);
    try {
      const id = await salvarCaso(draft, admin.id);
      patch((d) => (d.id = id));
      setDirty(false);
      setMsg({ type: "ok", text: "Alterações salvas." });
      onSalvo?.();
    } catch (err) {
      setMsg({ type: "warn", text: err.message || "Erro ao salvar." });
    } finally {
      setSalvando(false);
    }
  }

  async function enviarRevisao() {
    const prob = validar(draft);
    if (prob) {
      setMsg({ type: "warn", text: prob });
      return;
    }
    setSalvando(true);
    try {
      const id = await salvarCaso(draft, admin.id);
      await mudarStatus(id, "em_revisao");
      patch((d) => {
        d.id = id;
        d.status = "em_revisao";
      });
      setDirty(false);
      setMsg({ type: "ok", text: "Caso enviado para revisão." });
      onSalvo?.();
    } catch (err) {
      setMsg({ type: "warn", text: err.message || "Erro ao enviar para revisão." });
    } finally {
      setSalvando(false);
    }
  }

  async function transicionar(novoStatus, textoOk) {
    if (!isPriv) return;
    setSalvando(true);
    try {
      await mudarStatus(draft.id, novoStatus);
      patch((d) => (d.status = novoStatus));
      setMsg({ type: "ok", text: textoOk });
      onSalvo?.();
    } catch (err) {
      setMsg({ type: "warn", text: err.message || "Erro ao mudar status." });
    } finally {
      setSalvando(false);
    }
  }

  async function apagar() {
    if (admin.role !== "owner" || !draft.id) return;
    if (!window.confirm(`Apagar definitivamente "${draft.titulo || "(sem título)"}"? Essa ação não pode ser desfeita.`)) {
      return;
    }
    setSalvando(true);
    try {
      await apagarCaso(draft.id);
      onSalvo?.();
      onBack();
    } catch (err) {
      setMsg({ type: "warn", text: err.message || "Erro ao apagar caso." });
      setSalvando(false);
    }
  }

  if (carregando) {
    return <div style={{ padding: 48, textAlign: "center", color: "var(--c-muted)" }}>Carregando caso…</div>;
  }
  if (erroCarga) {
    return <div style={{ padding: 48, textAlign: "center", color: "var(--c-danger)" }}>{erroCarga}</div>;
  }

  const d = draft;
  const sm = STATUS_META[d.status] || STATUS_META.rascunho;
  const pesos = normalizar(d.checklist);
  const soma = pesos.reduce((a, b) => a + b, 0);
  const availConteudos = taxonomia.filter((c) => c.disciplina === edDisc && String(c.periodo) === edPer);

  // navegação de seções + preenchimento (mostra na faixa de navegação e na barra de salvar)
  const secList = [
    { id: "sec-ident", label: "Identificação", ok: !!(d.titulo?.trim() && d.resumo?.trim()) },
    { id: "sec-cont", label: "Conteúdos", ok: d.conteudos.length > 0 },
    { id: "sec-rot", label: "Roteiro do paciente", ok: !!(d.personagem?.trim() && d.roteiro.length > 0) },
    { id: "sec-ach", label: "Achados de exame", ok: !!d.exames_achados?.trim() },
    { id: "sec-chk", label: "Checklist", ok: d.checklist.length > 0 },
  ];
  const secDone = secList.filter((s) => s.ok).length;
  const irPara = (id) => document.getElementById(id)?.scrollIntoView({ behavior: "smooth", block: "start" });

  return (
    <main style={{ maxWidth: 1180, margin: "0 auto", padding: "22px 28px 100px" }}>
      <div style={{ display: "flex", alignItems: "center", gap: 12, marginBottom: 20, flexWrap: "wrap" }}>
        <button className="btn btn-ghost" onClick={sair}>
          ← Casos
        </button>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
            <h1 style={{ margin: 0, fontSize: "1.4rem", fontWeight: 800, whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>
              {d.titulo?.trim() || (d.id ? "(sem título)" : "Novo caso")}
            </h1>
            <span style={{ background: sm.bg, color: sm.fg, borderRadius: 20, padding: "3px 11px", fontSize: "0.74rem", fontWeight: 700 }}>
              {sm.label}
            </span>
            {dirty && (
              <span style={{ color: "var(--c-warn)", fontSize: "0.78rem", fontWeight: 600, whiteSpace: "nowrap" }}>
                • não salvo
              </span>
            )}
          </div>
        </div>
        {d.id && (
          <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
            <button className="btn btn-ghost" onClick={() => onHist(d.id)}>🕘 Histórico</button>
            <button className="btn btn-ghost" onClick={() => onPreview(d.id)}>▶ Preview</button>
          </div>
        )}
      </div>

      {/* navegação de seções + preenchimento */}
      <div className="card editor-secnav" style={{ display: "flex", alignItems: "center", gap: 8, flexWrap: "wrap", padding: "10px 14px", marginBottom: 16 }}>
        {secList.map((s) => (
          <button
            key={s.id}
            onClick={() => irPara(s.id)}
            style={{
              display: "inline-flex", alignItems: "center", gap: 6, padding: "6px 11px", borderRadius: 9,
              background: "transparent", border: `1px solid ${s.ok ? "var(--c-line)" : "#4a4024"}`,
              color: "var(--c-text)", cursor: "pointer", fontSize: "0.82rem", fontWeight: 600,
            }}
          >
            <span style={{ color: s.ok ? "var(--c-good)" : "var(--c-warn)" }}>{s.ok ? "✓" : "○"}</span>
            {s.label}
          </button>
        ))}
        <div style={{ flex: 1 }} />
        <div style={{ display: "flex", alignItems: "center", gap: 9, minWidth: 150 }}>
          <span style={{ fontSize: "0.78rem", color: "var(--c-muted)", whiteSpace: "nowrap" }}>{secDone}/{secList.length} preenchidas</span>
          <div style={{ width: 80, height: 7, borderRadius: 5, background: "var(--c-panel-2)", overflow: "hidden" }}>
            <div style={{ width: `${(secDone / secList.length) * 100}%`, height: "100%", background: "var(--c-teal)", transition: "width 0.2s var(--ease)" }} />
          </div>
        </div>
      </div>

      {msg && (
        <div
          style={{
            marginBottom: 16,
            padding: "10px 14px",
            background: msg.type === "ok" ? "var(--c-ok-fill)" : "var(--c-warn-fill)",
            border: `1px solid ${msg.type === "ok" ? "#244a39" : "#4a4024"}`,
            borderRadius: 10,
            color: msg.type === "ok" ? "var(--c-good)" : "var(--c-warn)",
            fontSize: "0.88rem",
          }}
        >
          {msg.type === "ok" ? "✓ " : "⚠️ "}
          {msg.text}
        </div>
      )}
      {d.status === "em_revisao" && !isPriv && (
        <div
          style={{
            marginBottom: 16,
            padding: "10px 14px",
            background: "var(--c-warn-fill)",
            border: "1px solid #4a4024",
            borderRadius: 10,
            color: "var(--c-warn)",
            fontSize: "0.88rem",
          }}
        >
          ⚠️ Este caso está em revisão. Apenas owner ou revisor podem publicar ou devolver.
        </div>
      )}

      <div className="editor-grid" style={{ display: "grid", gridTemplateColumns: "1.55fr 1fr", gap: 18, alignItems: "start" }}>
        {/* COLUNA ESQUERDA */}
        <div style={{ display: "flex", flexDirection: "column", gap: 18 }}>
          <section id="sec-ident" className="card">
            <div style={{ fontSize: "0.78rem", textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--c-teal)", fontWeight: 700, marginBottom: 16 }}>
              Identificação
            </div>
            <div style={{ display: "flex", flexDirection: "column", gap: 6, marginBottom: 14 }}>
              <label className="label">Título</label>
              <input
                className="input"
                value={d.titulo}
                onChange={setField("titulo")}
                placeholder="Ex.: Lactente com tosse e febre há 3 dias"
              />
            </div>
            <div className="form-grid-2" style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12, marginBottom: 14 }}>
              <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
                <label className="label">Especialidade</label>
                <input className="input" value={d.especialidade || ""} onChange={setField("especialidade")} placeholder="Ex.: Pediatria" />
              </div>
              <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
                <label className="label">
                  Subtipo <span style={{ color: "#5d6e7d", fontWeight: 400 }}>(opcional)</span>
                </label>
                <input
                  className="input"
                  value={d.subtipo || ""}
                  onChange={setField("subtipo")}
                  placeholder="Ex.: Anamnese + exame físico"
                />
              </div>
            </div>
            <div style={{ display: "grid", gridTemplateColumns: "auto 1fr", gap: 12, alignItems: "end" }}>
              <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
                <label className="label">Tempo da estação</label>
                <div style={{ display: "flex", alignItems: "center", gap: 7 }}>
                  <input
                    className="input"
                    style={{ width: 64, textAlign: "center", fontWeight: 700 }}
                    value={Math.floor(d.tempo_segundos / 60)}
                    onChange={setTempoMin}
                    inputMode="numeric"
                  />
                  <span style={{ color: "var(--c-muted)", fontWeight: 700 }}>min</span>
                  <input
                    className="input"
                    style={{ width: 64, textAlign: "center", fontWeight: 700 }}
                    value={d.tempo_segundos % 60}
                    onChange={setTempoSeg}
                    inputMode="numeric"
                  />
                  <span style={{ color: "var(--c-muted)", fontWeight: 700 }}>seg</span>
                </div>
              </div>
              <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
                <label className="label">Queixa principal</label>
                <input className="input" value={d.queixa_principal || ""} onChange={setField("queixa_principal")} placeholder="Ex.: Tosse e febre" />
              </div>
            </div>
          </section>

          <section className="card">
            <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 14 }}>
              <span style={{ fontSize: "0.78rem", textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--c-teal)", fontWeight: 700 }}>
                🎓 Instruções ao estudante
              </span>
              <span style={{ fontSize: "0.78rem", color: "var(--c-muted)" }}>— o que o estudante lê antes de iniciar</span>
            </div>
            <textarea
              className="input"
              rows={4}
              value={d.resumo || ""}
              onChange={setField("resumo")}
              placeholder="Resumo / instruções visíveis ao estudante…"
              style={{ lineHeight: 1.5 }}
            />
          </section>

          <section className="card">
            <div style={{ fontSize: "0.78rem", textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--c-teal)", fontWeight: 700, marginBottom: 14 }}>
              👤 Ator / paciente simulado
            </div>
            <div className="form-grid-2" style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
              <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
                <label className="label">Personagem</label>
                <textarea className="input" rows={3} value={d.personagem || ""} onChange={setField("personagem")} placeholder="Quem o ator interpreta…" style={{ lineHeight: 1.45 }} />
              </div>
              <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
                <label className="label">Contexto / atitude</label>
                <textarea className="input" rows={3} value={d.contexto || ""} onChange={setField("contexto")} placeholder="Tom e atitude do ator…" style={{ lineHeight: 1.45 }} />
              </div>
            </div>
          </section>

          <section id="sec-rot" className="card">
            <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 14 }}>
              <div>
                <span style={{ fontSize: "0.78rem", textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--c-teal)", fontWeight: 700 }}>
                  🗒️ Roteiro confidencial
                </span>
                <span style={{ fontSize: "0.78rem", color: "var(--c-muted)", marginLeft: 6 }}>falas/fatos que o ator pode revelar</span>
              </div>
              <button className="btn btn-ghost" style={{ padding: "7px 12px", fontSize: "0.85rem" }} onClick={addRoteiro}>
                + Adicionar fala
              </button>
            </div>
            <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
              {d.roteiro.map((texto, i) => (
                <div key={i} style={{ display: "flex", alignItems: "flex-start", gap: 8 }}>
                  <div style={{ display: "flex", flexDirection: "column", gap: 2, paddingTop: 2 }}>
                    <button onClick={moveRoteiro(i, -1)} disabled={i === 0} style={upBtnStyle(i > 0)}>
                      ▲
                    </button>
                    <button onClick={moveRoteiro(i, 1)} disabled={i === d.roteiro.length - 1} style={upBtnStyle(i < d.roteiro.length - 1)}>
                      ▼
                    </button>
                  </div>
                  <span style={{ width: 22, textAlign: "center", paddingTop: 10, color: "var(--c-muted)", fontSize: "0.8rem", fontWeight: 700 }}>
                    {i + 1}
                  </span>
                  <textarea
                    className="input"
                    rows={2}
                    value={texto}
                    onChange={setRoteiro(i)}
                    placeholder="Fato ou fala que o ator revela quando perguntado…"
                    style={{ flex: 1, fontSize: "0.9rem", lineHeight: 1.45 }}
                  />
                  <button
                    title="Remover"
                    onClick={delRoteiro(i)}
                    style={{ width: 32, height: 32, flex: "none", marginTop: 2, display: "grid", placeItems: "center", background: "transparent", border: "1px solid var(--c-line)", borderRadius: 8, color: "var(--c-muted)", cursor: "pointer" }}
                  >
                    ✕
                  </button>
                </div>
              ))}
              {d.roteiro.length === 0 && (
                <div style={{ padding: 18, textAlign: "center", color: "var(--c-muted)", fontSize: "0.88rem", border: "1px dashed var(--c-line)", borderRadius: 10 }}>
                  Nenhuma fala ainda. Adicione fatos que o ator revela durante a estação.
                </div>
              )}
            </div>
          </section>

          <section id="sec-ach" className="card">
            <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 12 }}>
              <span style={{ display: "inline-block", width: 3, height: 16, background: "var(--c-blue)", borderRadius: 2 }} />
              <span style={{ fontSize: "0.78rem", textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--c-blue)", fontWeight: 700 }}>
                Exames e achados
              </span>
            </div>
            <textarea
              className="input"
              rows={4}
              value={d.exames_achados || ""}
              onChange={setField("exames_achados")}
              placeholder="Resultados de exame físico, sinais vitais, exames complementares que o avaliador libera quando solicitados…"
              style={{ lineHeight: 1.5 }}
            />
          </section>
        </div>

        {/* COLUNA DIREITA */}
        <div style={{ display: "flex", flexDirection: "column", gap: 18, position: "sticky", top: 78 }}>
          <section id="sec-cont" className="card" style={{ padding: 20 }}>
            <div style={{ fontSize: "0.78rem", textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--c-teal)", fontWeight: 700, marginBottom: 6 }}>
              🎯 Conteúdos
            </div>
            <p style={{ margin: "0 0 12px", fontSize: "0.8rem", color: "var(--c-muted)" }}>Associe a um ou mais conteúdos. Marque a ⭐ no principal.</p>
            <div style={{ display: "flex", gap: 8, marginBottom: 12 }}>
              <select className="input" style={{ flex: 1, padding: "8px 9px", fontSize: "0.85rem", cursor: "pointer" }} value={edDisc} onChange={(e) => setEdDisc(e.target.value)}>
                {disciplinas.map((dn) => (
                  <option key={dn} value={dn}>
                    {dn}
                  </option>
                ))}
              </select>
              <select className="input" style={{ width: 84, padding: "8px 9px", fontSize: "0.85rem", cursor: "pointer" }} value={edPer} onChange={(e) => setEdPer(e.target.value)}>
                {periodos.map((p) => (
                  <option key={p} value={String(p)}>
                    {p}°
                  </option>
                ))}
              </select>
            </div>
            <div style={{ display: "flex", flexWrap: "wrap", gap: 7, marginBottom: 14 }}>
              {availConteudos.map((c) => {
                const sel = d.conteudos.some((x) => x.id === c.id);
                return (
                  <button
                    key={c.id}
                    onClick={toggleConteudo(c)}
                    style={{
                      background: sel ? "var(--c-teal-deep)" : "var(--c-panel-2)",
                      border: `1px solid ${sel ? "var(--c-teal)" : "var(--c-line)"}`,
                      color: sel ? "#fff" : "var(--c-text)",
                      borderRadius: 18,
                      padding: "6px 12px",
                      fontSize: "0.82rem",
                      cursor: "pointer",
                    }}
                  >
                    {sel ? "✓ " : "+ "}
                    {c.nome}
                  </button>
                );
              })}
              {availConteudos.length === 0 && <span style={{ fontSize: "0.82rem", color: "var(--c-muted)" }}>Sem conteúdos nessa combinação.</span>}
            </div>
            <div style={{ borderTop: "1px solid var(--c-line)", paddingTop: 12 }}>
              <div style={{ fontSize: "0.7rem", textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--c-muted)", fontWeight: 700, marginBottom: 8 }}>
                Selecionados ({d.conteudos.length})
              </div>
              <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
                {d.conteudos.map((c) => (
                  <div key={c.id} style={{ display: "flex", alignItems: "center", gap: 8, padding: "7px 10px", background: "var(--c-panel-2)", border: "1px solid var(--c-line)", borderRadius: 9 }}>
                    <button
                      title="Marcar como principal"
                      onClick={setPrincipal(c.id)}
                      style={{ width: 28, height: 28, flex: "none", display: "grid", placeItems: "center", background: "transparent", border: "none", cursor: "pointer", fontSize: "1rem", color: c.principal ? "var(--c-teal)" : "#5d6e7d" }}
                    >
                      {c.principal ? "⭐" : "☆"}
                    </button>
                    <div style={{ flex: 1, minWidth: 0 }}>
                      <div style={{ fontSize: "0.88rem", whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>{c.nome}</div>
                      <div style={{ fontSize: "0.72rem", color: "var(--c-muted)" }}>
                        {c.disciplina} · {c.periodo}°
                      </div>
                    </div>
                    <button
                      onClick={removeConteudo(c.id)}
                      style={{ width: 26, height: 26, flex: "none", display: "grid", placeItems: "center", background: "transparent", border: "1px solid var(--c-line)", borderRadius: 7, color: "var(--c-muted)", cursor: "pointer", fontSize: "0.8rem" }}
                    >
                      ✕
                    </button>
                  </div>
                ))}
                {d.conteudos.length === 0 && <span style={{ fontSize: "0.82rem", color: "var(--c-muted)" }}>Nenhum conteúdo associado ainda.</span>}
              </div>
            </div>
          </section>

          <section id="sec-chk" className="card" style={{ padding: 20 }}>
            <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 4 }}>
              <span style={{ fontSize: "0.78rem", textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--c-teal)", fontWeight: 700 }}>✓ Checklist de avaliação</span>
              <div style={{ display: "flex", alignItems: "baseline", gap: 5 }}>
                <span style={{ fontSize: "1.3rem", fontWeight: 800, color: d.checklist.length ? "var(--c-teal)" : "var(--c-muted)" }}>{soma}</span>
                <span style={{ fontSize: "0.75rem", color: "var(--c-muted)" }}>/ 100 pts</span>
              </div>
            </div>
            <p style={{ margin: "0 0 14px", fontSize: "0.8rem", color: "var(--c-muted)" }}>
              O peso de cada item é calculado pela <strong style={{ color: "var(--c-text)" }}>gravidade (1–5)</strong> e normalizado para somar 100.
            </p>

            <div style={{ display: "flex", height: 8, borderRadius: 5, overflow: "hidden", background: "var(--c-panel-2)", marginBottom: 16 }}>
              {d.checklist.map((it, i) => (
                <div key={i} title={it.texto} style={{ width: `${pesos[i]}%`, background: palette[i % palette.length] }} />
              ))}
            </div>

            <div style={{ display: "flex", flexDirection: "column", gap: 9, marginBottom: 14 }}>
              {d.checklist.map((it, i) => (
                <div key={i} style={{ background: "var(--c-panel-2)", border: "1px solid var(--c-line)", borderRadius: 10, padding: "10px 11px" }}>
                  <div style={{ display: "flex", alignItems: "flex-start", gap: 8 }}>
                    <div style={{ display: "flex", flexDirection: "column", gap: 2, paddingTop: 1 }}>
                      <button onClick={moveChk(i, -1)} disabled={i === 0} style={upBtnStyle(i > 0)}>
                        ▲
                      </button>
                      <button onClick={moveChk(i, 1)} disabled={i === d.checklist.length - 1} style={upBtnStyle(i < d.checklist.length - 1)}>
                        ▼
                      </button>
                    </div>
                    <textarea
                      rows={2}
                      value={it.texto}
                      onChange={setChkTexto(i)}
                      placeholder="Critério avaliado…"
                      style={{ flex: 1, padding: "7px 10px", borderRadius: 8, border: "1px solid var(--c-line)", background: "var(--c-panel)", color: "var(--c-text)", fontSize: "0.88rem", lineHeight: 1.4 }}
                    />
                    <div style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 3, flex: "none", width: 54 }}>
                      <span style={{ fontSize: "1.05rem", fontWeight: 800, color: "var(--c-teal)" }}>{pesos[i]}</span>
                      <span style={{ fontSize: "0.62rem", color: "var(--c-muted)", textTransform: "uppercase" }}>pts</span>
                    </div>
                    <button
                      title="Remover"
                      onClick={delChk(i)}
                      style={{ width: 28, height: 28, flex: "none", display: "grid", placeItems: "center", background: "transparent", border: "1px solid var(--c-line)", borderRadius: 7, color: "var(--c-muted)", cursor: "pointer", fontSize: "0.78rem" }}
                    >
                      ✕
                    </button>
                  </div>
                  <div style={{ display: "flex", alignItems: "center", gap: 9, marginTop: 9, paddingLeft: 30 }}>
                    <span style={{ fontSize: "0.7rem", textTransform: "uppercase", letterSpacing: "0.4px", color: "var(--c-muted)", fontWeight: 600 }}>Gravidade</span>
                    <div style={{ display: "flex", gap: 4 }}>
                      {[1, 2, 3, 4, 5].map((g) => (
                        <button
                          key={g}
                          title={`Gravidade ${g}`}
                          onClick={setChkGrav(i, g)}
                          style={{
                            width: 26,
                            height: 26,
                            borderRadius: 7,
                            cursor: "pointer",
                            fontSize: "0.78rem",
                            fontWeight: 700,
                            border: `1px solid ${g <= it.gravidade ? "var(--c-teal)" : "var(--c-line)"}`,
                            background: g <= it.gravidade ? "var(--c-teal)" : "transparent",
                            color: g <= it.gravidade ? "var(--c-teal-ink)" : "var(--c-muted)",
                          }}
                        >
                          {g}
                        </button>
                      ))}
                    </div>
                    <span style={{ fontSize: "0.72rem", color: "var(--c-muted)", marginLeft: "auto" }}>{gravLabel(it.gravidade)}</span>
                  </div>
                </div>
              ))}
              {d.checklist.length === 0 && (
                <div style={{ padding: 18, textAlign: "center", color: "var(--c-muted)", fontSize: "0.85rem", border: "1px dashed var(--c-line)", borderRadius: 10 }}>
                  Checklist vazio. Adicione itens abaixo.
                </div>
              )}
            </div>

            <div style={{ display: "flex", gap: 8 }}>
              <button className="btn btn-primary" style={{ flex: 1 }} onClick={addChecklist}>
                + Item específico
              </button>
              <button className="btn btn-ghost" style={{ flex: 1 }} onClick={() => setBankOpen((v) => !v)}>
                {bankOpen ? "✕ Fechar banco" : "📚 Banco de itens"}
              </button>
            </div>

            {bankOpen && (
              <div style={{ marginTop: 12, border: "1px solid var(--c-line)", borderRadius: 10, padding: 12, background: "var(--c-panel-2)" }}>
                <div style={{ fontSize: "0.7rem", textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--c-muted)", fontWeight: 700, marginBottom: 9 }}>
                  Banco de itens reutilizáveis
                </div>
                <div style={{ display: "flex", flexDirection: "column", gap: 6, maxHeight: 240, overflowY: "auto" }}>
                  {banco.map((b) => {
                    const usado = d.checklist.some((c) => c.itemBaseId === b.id);
                    return (
                      <button
                        key={b.id}
                        onClick={usado ? undefined : addFromBank(b)}
                        style={{
                          display: "flex",
                          alignItems: "center",
                          gap: 10,
                          width: "100%",
                          textAlign: "left",
                          background: usado ? "rgba(72,199,142,0.06)" : "var(--c-panel)",
                          border: "1px solid var(--c-line)",
                          borderRadius: 8,
                          padding: "8px 11px",
                          color: usado ? "var(--c-muted)" : "var(--c-text)",
                          cursor: usado ? "default" : "pointer",
                          fontSize: "0.85rem",
                          lineHeight: 1.35,
                        }}
                      >
                        <span style={{ flex: 1 }}>{b.texto}</span>
                        <span
                          style={{
                            flex: "none",
                            fontSize: "0.7rem",
                            fontWeight: 700,
                            padding: "2px 8px",
                            borderRadius: 12,
                            background: usado ? "transparent" : "var(--c-panel)",
                            color: usado ? "var(--c-good)" : "var(--c-teal)",
                            border: usado ? "none" : "1px solid var(--c-line)",
                          }}
                        >
                          {usado ? "adicionado" : "+ usar"}
                        </span>
                      </button>
                    );
                  })}
                </div>
              </div>
            )}
          </section>
        </div>
      </div>

      {/* barra de salvar fixa no rodapé */}
      <div className="editor-savebar">
        <span style={{ fontSize: "0.85rem", color: dirty ? "var(--c-warn)" : "var(--c-muted)", whiteSpace: "nowrap" }}>
          {dirty ? "• Alterações não salvas" : "Tudo salvo"}
        </span>
        <div className="editor-savebar-spacer" style={{ flex: 1 }} />
        {d.status === "publicado" && isPriv && (
          <button className="btn btn-danger" onClick={() => transicionar("arquivado", "Caso arquivado.")} disabled={salvando}>🗄️ Arquivar</button>
        )}
        {d.status === "arquivado" && isPriv && (
          <button className="btn btn-ghost" onClick={() => transicionar("rascunho", "Caso restaurado para rascunho.")} disabled={salvando}>↩ Restaurar</button>
        )}
        {d.id && admin.role === "owner" && (
          <button className="btn btn-danger" onClick={apagar} disabled={salvando}>🗑️ Apagar</button>
        )}
        <button className="btn btn-ghost" style={{ borderColor: "var(--c-teal)", color: "var(--c-teal)" }} onClick={salvar} disabled={salvando}>Salvar rascunho</button>
        {d.status === "rascunho" && (
          <button className="btn btn-primary" onClick={enviarRevisao} disabled={salvando}>📤 Enviar para revisão</button>
        )}
        {d.status === "em_revisao" && isPriv && (
          <button className="btn btn-primary" onClick={() => transicionar("publicado", "Caso publicado.")} disabled={salvando}>✅ Publicar</button>
        )}
      </div>
    </main>
  );
}
