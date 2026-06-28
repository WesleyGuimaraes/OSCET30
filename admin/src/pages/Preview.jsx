import { useEffect, useState } from "react";
import { fetchCasoCompleto, fmtTempo, normalizar, STATUS_META, mudarStatus, devolverCaso } from "../lib/data.js";
import DevolverModal from "../components/DevolverModal.jsx";

const segBtnStyle = (active) => ({
  border: "none",
  borderRadius: 18,
  padding: "6px 14px",
  cursor: "pointer",
  fontSize: "0.82rem",
  fontWeight: 600,
  background: active ? "var(--c-teal)" : "transparent",
  color: active ? "var(--c-teal-ink)" : "var(--c-muted)",
});

export default function Preview({ casoId, admin, onBack, onRecarregar }) {
  const [caso, setCaso] = useState(null);
  const [carregando, setCarregando] = useState(true);
  const [erro, setErro] = useState("");
  const [modo, setModo] = useState("split"); // split | estudante | avaliador
  const [acaoErro, setAcaoErro] = useState("");
  const [enviando, setEnviando] = useState(false);
  const [devolverOpen, setDevolverOpen] = useState(false);

  const isPriv = !!admin && (admin.role === "owner" || admin.role === "revisor");

  useEffect(() => {
    let ativo = true;
    setCarregando(true);
    setErro("");
    fetchCasoCompleto(casoId)
      .then((c) => ativo && setCaso(c))
      .catch((err) => ativo && setErro(err.message || "Erro ao carregar caso."))
      .finally(() => ativo && setCarregando(false));
    return () => {
      ativo = false;
    };
  }, [casoId]);

  async function publicar() {
    setAcaoErro("");
    setEnviando(true);
    try {
      await mudarStatus(caso.id, "publicado");
      onRecarregar?.();
      onBack();
    } catch (err) {
      setAcaoErro(err.message || "Erro ao publicar.");
      setEnviando(false);
    }
  }

  async function confirmarDevolver(obs) {
    setAcaoErro("");
    try {
      await devolverCaso(caso.id, obs, admin.id);
      onRecarregar?.();
      onBack();
    } catch (err) {
      setAcaoErro(err.message || "Erro ao devolver.");
      setDevolverOpen(false);
    }
  }

  if (carregando) return <div style={{ padding: 48, textAlign: "center", color: "var(--c-muted)" }}>Carregando…</div>;
  if (erro) return <div style={{ padding: 48, textAlign: "center", color: "var(--c-danger)" }}>{erro}</div>;
  if (!caso) return null;

  const pesos = normalizar(caso.checklist);
  const checklistTotal = pesos.reduce((a, b) => a + b, 0);
  const conteudosLabel = caso.conteudos.map((c) => c.nome).join(" · ") || "—";
  const sm = STATUS_META[caso.status] || STATUS_META.rascunho;
  const emRevisao = caso.status === "em_revisao";
  const showEstudante = modo === "split" || modo === "estudante";
  const showAvaliador = modo === "split" || modo === "avaliador";
  // avaliador agora é sempre 2 colunas próprias (roteiro | checklist)
  const numColunas = (showEstudante ? 1 : 0) + (showAvaliador ? 2 : 0);

  return (
    <main style={{ maxWidth: 1180, margin: "0 auto", padding: "22px 28px 80px" }}>
      <div style={{ display: "flex", alignItems: "center", gap: 12, marginBottom: 20, flexWrap: "wrap" }}>
        <button className="btn btn-ghost" onClick={onBack}>
          ← Voltar
        </button>
        <div style={{ flex: 1, minWidth: 0, display: "flex", alignItems: "center", gap: 10 }}>
          <h1 style={{ margin: 0, fontSize: "1.3rem", fontWeight: 800, whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>
            Preview · {caso.titulo || "(sem título)"}
          </h1>
          <span style={{ background: sm.bg, color: sm.fg, borderRadius: 20, padding: "3px 11px", fontSize: "0.72rem", fontWeight: 700, whiteSpace: "nowrap" }}>
            {sm.label}
          </span>
        </div>
        <div style={{ display: "flex", background: "var(--c-panel-2)", border: "1px solid var(--c-line)", borderRadius: 20, padding: 3, gap: 2 }}>
          <button style={segBtnStyle(modo === "split")} onClick={() => setModo("split")}>
            Lado a lado
          </button>
          <button style={segBtnStyle(modo === "estudante")} onClick={() => setModo("estudante")}>
            🎓 Estudante
          </button>
          <button style={segBtnStyle(modo === "avaliador")} onClick={() => setModo("avaliador")}>
            👤 Avaliador
          </button>
        </div>
      </div>

      <div className="preview-grid" style={{ display: "grid", gridTemplateColumns: `repeat(${numColunas}, 1fr)`, gap: 18, alignItems: "start" }}>
        {showEstudante && (
          <section className="card" style={{ padding: 0, overflow: "hidden" }}>
            <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", padding: "14px 20px", borderBottom: "1px solid var(--c-line)", background: "rgba(63,182,168,0.06)" }}>
              <div style={{ display: "flex", alignItems: "center", gap: 8, fontWeight: 700 }}>🎓 Visão do estudante</div>
              <span style={{ fontSize: "0.7rem", textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--c-muted)" }}>só instruções</span>
            </div>
            <div style={{ padding: 22 }}>
              <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 16 }}>
                <div style={{ fontSize: "1.9rem", fontWeight: 800, letterSpacing: "-1px" }}>{fmtTempo(caso.tempo_segundos)}</div>
                <div style={{ fontSize: "0.78rem", color: "var(--c-muted)" }}>
                  {caso.especialidade || "—"}
                  <br />
                  {conteudosLabel}
                </div>
              </div>
              <div style={{ fontSize: "0.7rem", textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--c-muted)", fontWeight: 700, marginBottom: 6 }}>
                Queixa principal
              </div>
              <p style={{ margin: "0 0 18px", fontSize: "1.05rem", fontWeight: 600 }}>{caso.queixa_principal || "—"}</p>
              <div style={{ fontSize: "0.7rem", textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--c-muted)", fontWeight: 700, marginBottom: 6 }}>
                Instruções
              </div>
              <p style={{ margin: 0, fontSize: "0.98rem", lineHeight: 1.6, whiteSpace: "pre-wrap" }}>{caso.resumo || "—"}</p>
            </div>
          </section>
        )}

        {showAvaliador && (
          <section className="card" style={{ padding: 0, overflow: "hidden" }}>
            <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", padding: "14px 20px", borderBottom: "1px solid var(--c-line)", background: "rgba(224,162,74,0.07)" }}>
              <div style={{ display: "flex", alignItems: "center", gap: 8, fontWeight: 700 }}>👤 Avaliador · Roteiro</div>
              <span style={{ fontSize: "0.7rem", textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--c-warn)" }}>confidencial</span>
            </div>
            <div style={{ padding: 22 }}>
              <div className="form-grid-2" style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 14, marginBottom: 18 }}>
                <div>
                  <div style={{ fontSize: "0.7rem", textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--c-muted)", fontWeight: 700, marginBottom: 5 }}>
                    Personagem
                  </div>
                  <p style={{ margin: 0, fontSize: "0.9rem", lineHeight: 1.5, whiteSpace: "pre-wrap" }}>{caso.personagem || "—"}</p>
                </div>
                <div>
                  <div style={{ fontSize: "0.7rem", textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--c-muted)", fontWeight: 700, marginBottom: 5 }}>
                    Contexto / atitude
                  </div>
                  <p style={{ margin: 0, fontSize: "0.9rem", lineHeight: 1.5, whiteSpace: "pre-wrap" }}>{caso.contexto || "—"}</p>
                </div>
              </div>

              <div style={{ fontSize: "0.7rem", textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--c-muted)", fontWeight: 700, marginBottom: 8 }}>
                🗒️ Roteiro confidencial
              </div>
              <div style={{ display: "flex", flexDirection: "column", gap: 6, marginBottom: 18 }}>
                {caso.roteiro.map((t, i) => (
                  <div key={i} style={{ display: "flex", gap: 9, padding: "9px 12px", background: "var(--c-panel-2)", border: "1px solid var(--c-line)", borderRadius: 9 }}>
                    <span style={{ color: "var(--c-teal)", fontWeight: 700, fontSize: "0.8rem" }}>{i + 1}</span>
                    <span style={{ fontSize: "0.9rem", lineHeight: 1.45 }}>{t}</span>
                  </div>
                ))}
                {caso.roteiro.length === 0 && <span style={{ fontSize: "0.85rem", color: "var(--c-muted)" }}>Nenhuma fala cadastrada.</span>}
              </div>

              <div style={{ display: "flex", alignItems: "center", gap: 8, margin: "0 0 10px", padding: "10px 12px", background: "rgba(74,139,223,0.08)", borderLeft: "3px solid var(--c-blue)", borderRadius: 6 }}>
                <span style={{ fontSize: "0.7rem", textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--c-blue)", fontWeight: 700 }}>Exames e achados</span>
              </div>
              <p style={{ margin: 0, fontSize: "0.9rem", lineHeight: 1.55, whiteSpace: "pre-wrap" }}>{caso.exames_achados || "—"}</p>
            </div>
          </section>
        )}

        {showAvaliador && (
          <section className="card" style={{ padding: 0, overflow: "hidden" }}>
            <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", padding: "14px 20px", borderBottom: "1px solid var(--c-line)", background: "rgba(224,162,74,0.07)" }}>
              <div style={{ display: "flex", alignItems: "center", gap: 8, fontWeight: 700 }}>✓ Checklist de avaliação</div>
              <div style={{ fontSize: "0.9rem", fontWeight: 800, color: "var(--c-teal)" }}>{checklistTotal} pts</div>
            </div>
            <div style={{ padding: 22 }}>
              <div style={{ border: "1px solid var(--c-line)", borderRadius: 10, padding: "4px 14px" }}>
                {caso.checklist.map((c, i) => (
                  <div key={i} style={{ display: "flex", alignItems: "flex-start", gap: 10, padding: "9px 0", borderBottom: "1px solid var(--c-line)" }}>
                    <input type="checkbox" style={{ marginTop: 3, accentColor: "var(--c-teal)" }} disabled />
                    <span style={{ flex: 1, fontSize: "0.9rem" }}>{c.texto}</span>
                    <span style={{ color: "var(--c-muted)", fontSize: "0.82rem", whiteSpace: "nowrap" }}>{pesos[i]} pt</span>
                  </div>
                ))}
                {caso.checklist.length === 0 && (
                  <div style={{ padding: "12px 0", color: "var(--c-muted)", fontSize: "0.85rem" }}>Checklist vazio.</div>
                )}
              </div>
            </div>
          </section>
        )}
      </div>

      {emRevisao && (
        <div
          className="preview-actionbar"
          style={{
            position: "sticky",
            bottom: 16,
            marginTop: 22,
            display: "flex",
            alignItems: "center",
            gap: 12,
            flexWrap: "wrap",
            padding: "13px 18px",
            background: "rgba(15,23,32,0.95)",
            backdropFilter: "blur(8px)",
            border: "1px solid var(--c-line)",
            borderRadius: "var(--radius-card)",
            boxShadow: "0 6px 24px rgba(0,0,0,0.35)",
          }}
        >
          <div style={{ display: "flex", alignItems: "center", gap: 10, flex: 1, minWidth: 200 }}>
            <span style={{ fontSize: "0.88rem", color: "var(--c-muted)" }}>
              {isPriv ? "Revise as três visões e decida:" : "Este caso está em revisão."}
            </span>
            {acaoErro && <span style={{ fontSize: "0.85rem", color: "var(--c-danger)" }}>⚠️ {acaoErro}</span>}
          </div>
          {isPriv ? (
            <div style={{ display: "flex", gap: 9 }}>
              <button className="btn btn-ghost" disabled={enviando} onClick={() => setDevolverOpen(true)}>
                ↩ Devolver
              </button>
              <button className="btn btn-primary" disabled={enviando} onClick={publicar}>
                {enviando ? "Publicando…" : "✅ Publicar"}
              </button>
            </div>
          ) : (
            <span style={{ fontSize: "0.82rem", color: "var(--c-muted)" }}>
              Apenas owner/revisor podem publicar ou devolver.
            </span>
          )}
        </div>
      )}

      {devolverOpen && (
        <DevolverModal caso={caso} onCancel={() => setDevolverOpen(false)} onConfirm={confirmarDevolver} />
      )}
    </main>
  );
}
