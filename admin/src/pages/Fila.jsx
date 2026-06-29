import { useState } from "react";
import { fmtData, fmtTempo, mudarStatus, devolverCaso } from "../lib/data.js";
import DevolverModal from "../components/DevolverModal.jsx";

export default function Fila({ casosEmRevisao, admin, onPreview, onRecarregar }) {
  const isPriv = admin.role === "owner" || admin.role === "revisor";
  const [devolverAlvo, setDevolverAlvo] = useState(null); // caso ou null
  const [erro, setErro] = useState("");

  async function publicar(id) {
    setErro("");
    try {
      await mudarStatus(id, "publicado");
      onRecarregar();
    } catch (err) {
      setErro(err.message || "Erro ao publicar.");
    }
  }

  async function confirmarDevolver(obs) {
    setErro("");
    try {
      await devolverCaso(devolverAlvo.id, obs, admin.id);
      setDevolverAlvo(null);
      onRecarregar();
    } catch (err) {
      setErro(err.message || "Erro ao devolver.");
    }
  }

  const rows = casosEmRevisao.slice().sort((a, b) => new Date(b.atualizadoEm) - new Date(a.atualizadoEm));

  return (
    <main style={{ maxWidth: 1080, margin: "0 auto", padding: "28px 28px 80px" }}>
      <div style={{ marginBottom: 6, display: "flex", alignItems: "center", gap: 10 }}>
        <h1 style={{ margin: 0, fontSize: "1.6rem", fontWeight: 800 }}>Fila de revisão</h1>
        <span style={{ background: "var(--c-warn-fill)", color: "var(--c-warn)", borderRadius: 20, padding: "3px 11px", fontSize: "0.8rem", fontWeight: 700 }}>
          {rows.length}
        </span>
      </div>
      <p style={{ margin: "0 0 22px", color: "var(--c-muted)", fontSize: "0.9rem" }}>
        {rows.length === 0
          ? "Tudo em dia."
          : isPriv
          ? "Casos aguardando sua revisão. Publique ou devolva com observação."
          : "Você está como editor — apenas owner/revisor podem publicar ou devolver."}
      </p>

      {erro && (
        <div style={{ marginBottom: 16, padding: "10px 14px", background: "var(--c-bad-fill)", border: "1px solid #4a2424", borderRadius: 10, color: "var(--c-danger)", fontSize: "0.88rem" }}>
          {erro}
        </div>
      )}

      <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
        {rows.map((c) => {
          return (
            <div key={c.id} className="card" style={{ padding: "18px 20px" }}>
              <div style={{ display: "flex", alignItems: "flex-start", gap: 16, flexWrap: "wrap" }}>
                <div className="fila-main" style={{ flex: 1, minWidth: 240 }}>
                  <div style={{ display: "flex", alignItems: "center", gap: 9, marginBottom: 5 }}>
                    <span style={{ fontSize: "1.05rem", fontWeight: 700 }}>{c.titulo}</span>
                    <span className="status-badge" style={{ background: "var(--c-warn-fill)", color: "var(--c-warn)" }}>
                      Em revisão
                    </span>
                  </div>
                  <div style={{ fontSize: "0.82rem", color: "var(--c-muted)", marginBottom: 8 }}>
                    {c.especialidade || "—"} · {c.conteudos.map((x) => x.nome).join(" · ") || "—"} · {fmtTempo(c.tempoSegundos)}
                  </div>
                  <div style={{ display: "flex", gap: 18, fontSize: "0.82rem", color: "var(--c-muted)" }}>
                    <span>
                      Autor: <span style={{ color: "var(--c-text)" }}>{c.autor}</span>
                    </span>
                    <span>
                      Enviado: <span style={{ color: "var(--c-text)" }}>{fmtData(c.atualizadoEm)}</span>
                    </span>
                  </div>
                </div>
                <div className="fila-actions" style={{ display: "flex", gap: 8, alignItems: "center", flexWrap: "wrap" }}>
                  <button className="btn btn-ghost" onClick={() => onPreview(c.id)}>
                    ▶ Preview
                  </button>
                  <button className="btn btn-ghost" disabled={!isPriv} onClick={() => isPriv && setDevolverAlvo(c)}>
                    ↩ Devolver
                  </button>
                  <button className="btn btn-primary" disabled={!isPriv} onClick={() => isPriv && publicar(c.id)}>
                    ✅ Publicar
                  </button>
                </div>
              </div>
            </div>
          );
        })}
        {rows.length === 0 && (
          <div style={{ padding: 60, textAlign: "center", color: "var(--c-muted)", background: "var(--c-panel)", border: "1px solid var(--c-line)", borderRadius: 14 }}>
            <div style={{ fontSize: "2rem", marginBottom: 10 }}>✓</div>
            Nenhum caso aguardando revisão.
          </div>
        )}
      </div>

      {devolverAlvo && (
        <DevolverModal caso={devolverAlvo} onCancel={() => setDevolverAlvo(null)} onConfirm={confirmarDevolver} />
      )}
    </main>
  );
}
