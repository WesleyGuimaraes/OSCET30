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

export default function Topbar({ screen, onGoDashboard, onGoCasos, onGoFila, filaCount, admin }) {
  const meta = ROLE_META[admin.role] || ROLE_META.editor;
  return (
    <header
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
      <div style={{ display: "flex", alignItems: "center", gap: 9, fontSize: "1.15rem", fontWeight: 800 }}>
        <span>🩺</span>
        <span>OSCE T30</span>
        <span style={{ color: "var(--c-teal)", fontWeight: 500 }}>Painel</span>
      </div>
      <nav style={{ display: "flex", gap: 4, marginLeft: 14 }}>
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
      <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
        <span style={{ fontSize: "0.85rem", color: "var(--c-text)" }}>
          {meta.emoji} {admin.nome} <span style={{ color: "var(--c-muted)" }}>· {meta.label}</span>
        </span>
        <button className="btn btn-ghost" style={{ padding: "6px 12px", fontSize: "0.8rem" }} onClick={() => supabase.auth.signOut()}>
          Sair
        </button>
      </div>
    </header>
  );
}
