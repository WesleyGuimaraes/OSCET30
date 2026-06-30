import { useEffect, useRef, useState } from "react";
import { supabase } from "../supabaseClient.js";

const ROLE_META = {
  owner: { emoji: "👑", label: "Owner" },
  revisor: { emoji: "🔎", label: "Revisor" },
  editor: { emoji: "✏️", label: "Editor" },
};

function navBtnStyle(active) {
  return {
    display: "inline-flex",
    alignItems: "center",
    gap: 6,
    background: active ? "var(--c-panel-2)" : "transparent",
    border: `1px solid ${active ? "var(--c-line)" : "transparent"}`,
    borderRadius: 9,
    padding: "8px 13px",
    color: active ? "var(--c-text)" : "var(--c-muted)",
    cursor: "pointer",
    fontSize: "0.92rem",
    fontWeight: 600,
  };
}

export default function Topbar({ screen, onGoDashboard, onGoCasos, onGoFila, onBuscar, filaCount, admin }) {
  const meta = ROLE_META[admin.role] || ROLE_META.editor;
  const [q, setQ] = useState("");
  const inputRef = useRef(null);

  // atalho "/" foca a busca (quando não se está digitando em outro campo)
  useEffect(() => {
    function onKey(e) {
      if (e.key !== "/") return;
      const t = e.target;
      if (t && (t.tagName === "INPUT" || t.tagName === "TEXTAREA" || t.isContentEditable)) return;
      e.preventDefault();
      inputRef.current?.focus();
    }
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, []);

  return (
    <header
      className="topbar-header"
      style={{
        position: "sticky",
        top: 0,
        zIndex: 30,
        display: "flex",
        alignItems: "center",
        gap: 18,
        padding: "12px 28px",
        background: "rgba(15,23,32,0.92)",
        backdropFilter: "blur(8px)",
        borderBottom: "1px solid var(--c-line)",
      }}
    >
      <div className="topbar-logo" style={{ display: "flex", alignItems: "center", gap: 9, fontSize: "1.15rem", fontWeight: 800 }}>
        <span>🩺</span>
        <span>Próxima Estação</span>
        <span style={{ color: "var(--c-teal)", fontWeight: 500 }}>Painel</span>
      </div>
      <nav className="topbar-nav" style={{ display: "flex", gap: 4, marginLeft: 14 }}>
        <button onClick={onGoDashboard} style={navBtnStyle(screen === "dashboard")}>
          Visão geral
        </button>
        <button onClick={onGoCasos} style={navBtnStyle(screen === "lista" || screen === "editor")}>
          Casos
        </button>
        <button onClick={onGoFila} style={navBtnStyle(screen === "fila")}>
          Fila de revisão{" "}
          <span
            style={{
              display: "inline-grid",
              placeItems: "center",
              minWidth: 18,
              height: 18,
              padding: "0 5px",
              background: "var(--c-warn-fill)",
              color: "var(--c-warn)",
              borderRadius: 9,
              fontSize: "0.68rem",
              fontWeight: 800,
            }}
          >
            {filaCount}
          </span>
        </button>
      </nav>
      <div style={{ flex: 1 }} />
      <div className="topbar-busca" style={{ display: "flex", alignItems: "center", gap: 8, background: "var(--c-bg)", border: "1px solid var(--c-line)", borderRadius: 9, padding: "6px 10px", width: 230 }}>
        <span style={{ color: "var(--c-muted)", fontSize: "0.82rem" }}>🔎</span>
        <input
          ref={inputRef}
          value={q}
          onChange={(e) => setQ(e.target.value)}
          onKeyDown={(e) => { if (e.key === "Enter" && onBuscar) onBuscar(q.trim()); }}
          placeholder="Buscar caso…"
          style={{ flex: 1, minWidth: 0, background: "transparent", border: "none", outline: "none", color: "var(--c-text)", fontSize: "0.82rem", padding: 0, margin: 0 }}
        />
        <span style={{ fontSize: "0.68rem", border: "1px solid var(--c-line)", borderRadius: 5, padding: "1px 5px", color: "var(--c-muted)" }}>/</span>
      </div>
      <div className="topbar-quem-full" style={{ display: "flex", alignItems: "center", gap: 10 }}>
        <span style={{ fontSize: "0.85rem", color: "var(--c-text)", whiteSpace: "nowrap" }}>
          {meta.emoji} {admin.nome} <span style={{ color: "var(--c-muted)" }}>· {meta.label}</span>
        </span>
        <button className="btn btn-ghost" style={{ padding: "6px 12px", fontSize: "0.8rem" }} onClick={() => supabase.auth.signOut()}>
          Sair
        </button>
      </div>
      {/* mobile: avatar (emoji do papel) substitui nome/papel/Sair; toque para sair */}
      <button
        className="topbar-avatar-mobile"
        title={`${admin.nome} · ${meta.label} — tocar para sair`}
        onClick={() => supabase.auth.signOut()}
      >
        {meta.emoji}
      </button>
    </header>
  );
}
