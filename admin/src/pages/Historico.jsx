import { useEffect, useState } from "react";
import { ACAO_META, fetchHistorico, fmtData } from "../lib/data.js";

export default function Historico({ casoId, casoTitulo, onBack }) {
  const [eventos, setEventos] = useState([]);
  const [carregando, setCarregando] = useState(true);
  const [erro, setErro] = useState("");

  useEffect(() => {
    let ativo = true;
    setCarregando(true);
    setErro("");
    fetchHistorico(casoId)
      .then((ev) => ativo && setEventos(ev))
      .catch((err) => ativo && setErro(err.message || "Erro ao carregar histórico."))
      .finally(() => ativo && setCarregando(false));
    return () => {
      ativo = false;
    };
  }, [casoId]);

  return (
    <main style={{ maxWidth: 760, margin: "0 auto", padding: "28px 28px 80px" }}>
      <div style={{ display: "flex", alignItems: "center", gap: 12, marginBottom: 6 }}>
        <button className="btn btn-ghost" onClick={onBack}>
          ← Voltar
        </button>
        <h1 style={{ margin: 0, fontSize: "1.4rem", fontWeight: 800 }}>Histórico</h1>
      </div>
      <p style={{ margin: "0 0 24px 0", color: "var(--c-muted)", fontSize: "0.92rem", paddingLeft: 2 }}>{casoTitulo}</p>

      {carregando && <div style={{ padding: 24, textAlign: "center", color: "var(--c-muted)" }}>Carregando…</div>}
      {erro && <div style={{ padding: 24, textAlign: "center", color: "var(--c-danger)" }}>{erro}</div>}

      {!carregando && !erro && (
        <div style={{ position: "relative", paddingLeft: 30 }}>
          <div style={{ position: "absolute", left: 9, top: 6, bottom: 6, width: 2, background: "var(--c-line)" }} />
          {eventos.map((e) => {
            const m = ACAO_META[e.acao] || { label: e.acao, icon: "•", color: "#8aa0b3" };
            return (
              <div key={e.id} style={{ position: "relative", paddingBottom: 22 }}>
                <div
                  style={{
                    position: "absolute",
                    left: -30,
                    top: 14,
                    width: 14,
                    height: 14,
                    borderRadius: "50%",
                    background: m.color,
                    border: "3px solid var(--c-bg)",
                    boxShadow: `0 0 0 1px ${m.color}`,
                  }}
                />
                <div className="card" style={{ padding: "14px 16px" }}>
                  <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", gap: 10, marginBottom: 3, flexWrap: "wrap" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
                      <span style={{ fontSize: "0.95rem" }}>{m.icon}</span>
                      <span style={{ fontWeight: 700, fontSize: "0.95rem" }}>{m.label}</span>
                    </div>
                    <span style={{ fontSize: "0.78rem", color: "var(--c-muted)" }}>{fmtData(e.quando)}</span>
                  </div>
                  <div style={{ fontSize: "0.85rem", color: "var(--c-muted)" }}>
                    por <span style={{ color: "var(--c-text)" }}>{e.quem}</span>
                  </div>
                  {e.obs && e.obs.trim() && (
                    <div
                      style={{
                        marginTop: 9,
                        padding: "9px 12px",
                        background: "var(--c-panel-2)",
                        borderLeft: "3px solid var(--c-warn)",
                        borderRadius: 6,
                        fontSize: "0.85rem",
                        lineHeight: 1.45,
                      }}
                    >
                      {e.obs}
                    </div>
                  )}
                </div>
              </div>
            );
          })}
          {eventos.length === 0 && <div style={{ color: "var(--c-muted)", fontSize: "0.9rem" }}>Sem eventos registrados ainda.</div>}
        </div>
      )}
    </main>
  );
}
