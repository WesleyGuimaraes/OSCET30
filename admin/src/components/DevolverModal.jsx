import { useEffect, useRef, useState } from "react";

// Modal de "devolver para rascunho" com observação ao autor.
// Compartilhado entre a Fila de revisão e o Preview.
export default function DevolverModal({ caso, onCancel, onConfirm }) {
  const [obs, setObs] = useState("");
  const [enviando, setEnviando] = useState(false);
  const textareaRef = useRef(null);

  // foco no campo ao abrir + fechar com Esc (usabilidade/teclado)
  useEffect(() => {
    textareaRef.current?.focus();
    const onKey = (e) => {
      if (e.key === "Escape" && !enviando) onCancel();
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [enviando, onCancel]);

  return (
    <div
      onClick={onCancel}
      role="dialog"
      aria-modal="true"
      aria-label="Devolver para rascunho"
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
          ref={textareaRef}
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
            {enviando ? "Devolvendo…" : "↩ Devolver"}
          </button>
        </div>
      </div>
    </div>
  );
}
