// Barra de navegação inferior — só visível no celular (ver .bottom-nav no CSS).
// Substitui a nav do topo nesse tamanho de tela.
const ITEMS = [
  { key: "dashboard", icon: "📊", label: "Visão geral" },
  { key: "lista", icon: "📋", label: "Casos" },
  { key: "fila", icon: "✅", label: "Fila" },
];

export default function BottomNav({ screen, onGoDashboard, onGoCasos, onGoFila, filaCount }) {
  const onGo = { dashboard: onGoDashboard, lista: onGoCasos, fila: onGoFila };
  const ativoDe = (key) => (key === "lista" ? screen === "lista" || screen === "editor" : screen === key);

  return (
    <nav className="bottom-nav" aria-label="Navegação principal">
      {ITEMS.map((it) => {
        const ativo = ativoDe(it.key);
        return (
          <button key={it.key} className="bn-item" onClick={onGo[it.key]} style={{ borderTopColor: ativo ? "var(--c-teal)" : "transparent" }}>
            <span className="bn-ico" style={{ opacity: ativo ? 1 : 0.7 }}>{it.icon}</span>
            <span className="bn-lbl" style={{ color: ativo ? "var(--c-teal)" : "var(--c-muted)", fontWeight: ativo ? 600 : 500 }}>
              {it.label}
              {it.key === "fila" && filaCount > 0 && <span className="bn-count"> {filaCount}</span>}
            </span>
          </button>
        );
      })}
    </nav>
  );
}
