import { useState } from "react";
import { fmtData, fmtTempo, mudarStatus, devolverCaso } from "../lib/data.js";

function DevolverModal({ caso, onCancel, onConfirm }) {
  const [obs, setObs] = useState("");
  const [enviando, setEnviando] = useState(false);
  return (
    <div
      onClick={onCancel}
      style={{
        position: "fixed",
        inset: 0,
        zIndex: 50,
        background: "rgba(8,12,16,0.66)",
        backdropFilter: "blur(3px)",
        display: "grid",
        placeItems: "center",
        padding: 20,
      }}
    >
      <div onClick={(e) => e.stopPropagation()} className="card" style={{ width: 480, maxWidth: "100%" }}>
        <h2 style={{ margin: "0 0 6px", fontSize: "1.2rem", fontWeight: 800 }}>Devolver para rascunho</h2>
        <p style={{ margin: "0 0 16px", fontSize: "0.88rem", color: "var(--c-muted)", lineHeight: 1.5 }}>
          "{caso.titulo}" voltará para <strong style={{ color: "var(--c-text)" }}>rascunho</strong>. Deixe uma observação para o autor.
        </p>
        <textarea
          className="input"
          rows={4}
          value={obs}
          onChange={(e) => setObs(e.target.value)}
          placeholder="O que precisa ser ajustado…"
          style={{ marginBottom: 16, lineHeight: 1.5 }}
        />
        <div style={{ display: "flex", justifyContent: "flex-end", gap: 9 }}>
          <button className="btn btn-ghost" onClick={onCancel} disabled={enviando}>
            Cancelar
          </button>
          <button
            className="btn btn-danger"
            disabled={enviando}
            onClick={async () => {
              setEnviando(true);
              try {
                await onConfirm(obs);
              } finally {
                setEnviando(false);
              }
            }}
          >
            ↩ Devolver
          </button>
        </div>
      </div>
    </div>
  );
}

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
                <div style={{ flex: 1, minWidth: 240 }}>
                  <div style={{ display: "flex", alignItems: "center", gap: 9, marginBottom: 5 }}>
                    <span style={{ fontSize: "1.05rem", fontWeight: 700 }}>{c.titulo}</span>
                    <span style={{ background: "var(--c-warn-fill)", color: "var(--c-warn)", borderRadius: 20, padding: "2px 9px", fontSize: "0.72rem", fontWeight: 700 }}>
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
                <div style={{ display: "flex", gap: 8, alignItems: "center" }}>
                  <button className="btn btn-ghost" onClick={() => onPreview(c.id)}>
                    ▶ Preview
                  </button>
                  <button
                    className="btn btn-ghost"
                    disabled={!isPriv}
                    style={!isPriv ? { color: "#5d6e7d", cursor: "not-allowed" } : undefined}
                    onClick={() => isPriv && setDevolverAlvo(c)}
                  >
                    ↩ Devolver
                  </button>
                  <button
                    className="btn btn-primary"
                    disabled={!isPriv}
                    style={!isPriv ? { background: "var(--c-panel-2)", color: "#5d6e7d", cursor: "not-allowed" } : undefined}
                    onClick={() => isPriv && publicar(c.id)}
                  >
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
