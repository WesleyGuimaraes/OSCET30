import { useEffect, useMemo, useState } from "react";
import { STATUS_META, fmtData, fmtTempo, mudarStatus, duplicarCaso } from "../lib/data.js";

const COLS = "34px 2.4fr 1.6fr 1fr 1.1fr 0.9fr 112px";

function Select({ label, value, onChange, options }) {
  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 5 }}>
      <label className="label">{label}</label>
      <select className="input" style={{ padding: "9px 10px", cursor: "pointer" }} value={value} onChange={onChange}>
        {options.map((o) => (
          <option key={o.val} value={o.val}>{o.label}</option>
        ))}
      </select>
    </div>
  );
}

// cor estável do avatar a partir do nome
const AVATAR_CORES = ["#2d8d82", "#4a8bdf", "#c08a8a", "#9c7bd0", "#c79a4a", "#5aa6a0"];
function avatarCor(nome) {
  let h = 0;
  for (let i = 0; i < (nome || "").length; i++) h = (h * 31 + nome.charCodeAt(i)) >>> 0;
  return AVATAR_CORES[h % AVATAR_CORES.length];
}

function IconBtn({ title, onClick, children }) {
  return (
    <button
      title={title}
      onClick={onClick}
      style={{ width: 30, height: 30, display: "grid", placeItems: "center", background: "transparent", border: "1px solid var(--c-line)", borderRadius: 8, color: "var(--c-muted)", cursor: "pointer" }}
    >
      {children}
    </button>
  );
}

export default function Lista({ casos, taxonomia, filtroConteudoId, admin, onNovoCaso, onOpenCaso, onPreview, onHist, onDuplicar, onRecarregar }) {
  const [busca, setBusca] = useState("");
  const [fDisciplina, setFDisciplina] = useState("");
  const [fPeriodo, setFPeriodo] = useState("");
  const [fConteudo, setFConteudo] = useState("");
  const [fStatus, setFStatus] = useState("");
  const [fAutor, setFAutor] = useState("");
  const [sel, setSel] = useState(() => new Set());
  const [bulkMsg, setBulkMsg] = useState("");
  const [bulkBusy, setBulkBusy] = useState(false);

  const isPriv = admin && (admin.role === "owner" || admin.role === "revisor");

  useEffect(() => {
    setFConteudo(filtroConteudoId || "");
    if (filtroConteudoId) {
      setFDisciplina("");
      setFPeriodo("");
    }
  }, [filtroConteudoId]);

  const disciplinas = useMemo(() => [...new Set(taxonomia.map((c) => c.disciplina).filter(Boolean))], [taxonomia]);
  const periodos = useMemo(() => [...new Set(taxonomia.map((c) => c.periodo).filter(Boolean))].sort((a, b) => a - b), [taxonomia]);
  const conteudoOpts = useMemo(() => {
    const filtrados = taxonomia.filter((c) => (!fDisciplina || c.disciplina === fDisciplina) && (!fPeriodo || String(c.periodo) === fPeriodo));
    return filtrados.map((c) => ({ val: c.id, label: c.nome }));
  }, [taxonomia, fDisciplina, fPeriodo]);
  const autores = useMemo(() => [...new Set(casos.map((c) => c.autor).filter((a) => a && a !== "—"))], [casos]);

  const rows = useMemo(() => {
    return casos
      .filter((c) => {
        if (busca && !c.titulo?.toLowerCase().includes(busca.toLowerCase())) return false;
        if (fDisciplina && !c.conteudos.some((x) => x.disciplina === fDisciplina)) return false;
        if (fPeriodo && !c.conteudos.some((x) => String(x.periodo) === fPeriodo)) return false;
        if (fConteudo && !c.conteudos.some((x) => x.id === fConteudo)) return false;
        if (fStatus && c.status !== fStatus) return false;
        if (fAutor && c.autor !== fAutor) return false;
        return true;
      })
      .sort((a, b) => new Date(b.atualizadoEm) - new Date(a.atualizadoEm));
  }, [casos, busca, fDisciplina, fPeriodo, fConteudo, fStatus, fAutor]);

  const publicados = casos.filter((c) => c.status === "publicado").length;
  const emRevisao = casos.filter((c) => c.status === "em_revisao").length;
  const rascunhos = casos.filter((c) => c.status === "rascunho").length;
  const temFiltro = busca || fDisciplina || fPeriodo || fConteudo || fStatus || fAutor;

  function limparFiltros() {
    setBusca(""); setFDisciplina(""); setFPeriodo(""); setFConteudo(""); setFStatus(""); setFAutor("");
  }

  // seleção
  const visiveisIds = rows.map((r) => r.id);
  const todosSel = visiveisIds.length > 0 && visiveisIds.every((id) => sel.has(id));
  function toggle(id) {
    setSel((s) => {
      const n = new Set(s);
      n.has(id) ? n.delete(id) : n.add(id);
      return n;
    });
  }
  function toggleTodos() {
    setSel((s) => {
      if (visiveisIds.every((id) => s.has(id))) return new Set();
      return new Set(visiveisIds);
    });
  }

  async function bulk(fn, okVerb) {
    setBulkMsg(""); setBulkBusy(true);
    const ids = [...sel];
    try {
      for (const id of ids) await fn(id);
      setSel(new Set());
      onRecarregar?.();
      setBulkMsg(`${ids.length} ${ids.length === 1 ? "caso" : "casos"} ${okVerb}.`);
    } catch (err) {
      setBulkMsg(err.message || "Erro na ação em lote.");
    } finally {
      setBulkBusy(false);
    }
  }
  const bulkEnviar = () => bulk((id) => mudarStatus(id, "em_revisao"), "enviados para revisão");
  const bulkArquivar = () => bulk((id) => mudarStatus(id, "arquivado"), "arquivados");
  const bulkDuplicar = () => bulk((id) => duplicarCaso(id, admin.id), "duplicados");

  return (
    <main style={{ maxWidth: 1180, margin: "0 auto", padding: "24px 28px 80px" }}>
      <div style={{ display: "flex", alignItems: "flex-end", justifyContent: "space-between", gap: 16, marginBottom: 18, flexWrap: "wrap" }}>
        <div>
          <h1 style={{ margin: 0, fontSize: "1.6rem", fontWeight: 800 }}>Casos clínicos</h1>
          <p style={{ margin: "6px 0 0", color: "var(--c-muted)", fontSize: "0.9rem" }}>
            {casos.length} casos · <span style={{ color: "var(--c-good)" }}>{publicados} publicados</span> · <span style={{ color: "var(--c-warn)" }}>{emRevisao} em revisão</span> · <span style={{ color: STATUS_META.rascunho.fg }}>{rascunhos} rascunhos</span>
          </p>
        </div>
        <button className="btn btn-primary" onClick={onNovoCaso}>+ Novo caso</button>
      </div>

      {/* filtros */}
      <div className="card lista-filtros" style={{ padding: "14px 16px", marginBottom: 14 }}>
        <div style={{ display: "flex", flexDirection: "column", gap: 5 }}>
          <label className="label">Buscar por título</label>
          <input className="input" style={{ padding: "9px 12px" }} value={busca} onChange={(e) => setBusca(e.target.value)} placeholder="Digite um título…" />
        </div>
        <Select label="Disciplina" value={fDisciplina} onChange={(e) => { setFDisciplina(e.target.value); setFConteudo(""); }} options={[{ val: "", label: "Todas" }, ...disciplinas.map((d) => ({ val: d, label: d }))]} />
        <Select label="Período" value={fPeriodo} onChange={(e) => { setFPeriodo(e.target.value); setFConteudo(""); }} options={[{ val: "", label: "Todos" }, ...periodos.map((p) => ({ val: String(p), label: p + "° período" }))]} />
        <Select label="Conteúdo" value={fConteudo} onChange={(e) => setFConteudo(e.target.value)} options={[{ val: "", label: "Todos" }, ...conteudoOpts]} />
        <Select label="Status" value={fStatus} onChange={(e) => setFStatus(e.target.value)} options={[{ val: "", label: "Todos" }, ...Object.keys(STATUS_META).map((k) => ({ val: k, label: STATUS_META[k].label }))]} />
        <Select label="Autor" value={fAutor} onChange={(e) => setFAutor(e.target.value)} options={[{ val: "", label: "Todos" }, ...autores.map((a) => ({ val: a, label: a }))]} />
        <button className="btn btn-ghost" style={{ alignSelf: "end", padding: "9px 14px", opacity: temFiltro ? 1 : 0.5 }} disabled={!temFiltro} onClick={limparFiltros}>Limpar</button>
      </div>

      {/* barra de ações em massa */}
      {sel.size > 0 && (
        <div style={{ display: "flex", alignItems: "center", gap: 14, flexWrap: "wrap", background: "var(--c-ok-fill)", border: "1px solid var(--c-teal-deep)", borderRadius: 11, padding: "10px 16px", marginBottom: 12 }}>
          <span style={{ fontWeight: 700, fontSize: "0.85rem", color: "var(--c-teal)" }}>{sel.size} {sel.size === 1 ? "caso selecionado" : "casos selecionados"}</span>
          <div style={{ width: 1, height: 18, background: "var(--c-line)" }} />
          <button className="linkact" disabled={bulkBusy} onClick={bulkEnviar}>📤 Enviar p/ revisão</button>
          <button className="linkact" disabled={bulkBusy} onClick={bulkDuplicar}>⧉ Duplicar</button>
          {isPriv && <button className="linkact" disabled={bulkBusy} onClick={bulkArquivar}>🗄️ Arquivar</button>}
          {bulkMsg && <span style={{ fontSize: "0.82rem", color: "var(--c-muted)" }}>{bulkMsg}</span>}
          <div style={{ flex: 1 }} />
          <button className="linkact" style={{ color: "var(--c-muted)" }} onClick={() => setSel(new Set())}>Limpar seleção ✕</button>
        </div>
      )}

      {/* tabela */}
      <div className="card lista-tabela" style={{ padding: 0, overflow: "hidden" }}>
        <div className="lt-head" style={{ display: "grid", gridTemplateColumns: COLS, gap: 14, padding: "11px 18px", borderBottom: "1px solid var(--c-line)", fontSize: "0.7rem", textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--c-muted)", fontWeight: 700 }}>
          <div style={{ display: "flex", alignItems: "center" }}>
            <input type="checkbox" checked={todosSel} onChange={toggleTodos} style={{ accentColor: "var(--c-teal)", cursor: "pointer" }} />
          </div>
          <div>Título</div><div>Conteúdos</div><div>Status</div><div>Autor</div><div>Atualizado</div><div></div>
        </div>

        {rows.map((row) => {
          const sm = STATUS_META[row.status] || STATUS_META.rascunho;
          const per = row.conteudos[0]?.periodo;
          const marcado = sel.has(row.id);
          return (
            <div
              key={row.id}
              className="lt-row"
              onClick={() => onOpenCaso(row.id)}
              style={{ display: "grid", gridTemplateColumns: COLS, gap: 14, padding: "13px 18px", borderBottom: "1px solid var(--c-line)", alignItems: "center", cursor: "pointer", background: marcado ? "var(--c-ok-fill)" : "transparent" }}
            >
              <div onClick={(e) => e.stopPropagation()} style={{ display: "flex", alignItems: "center" }}>
                <input type="checkbox" checked={marcado} onChange={() => toggle(row.id)} style={{ accentColor: "var(--c-teal)", cursor: "pointer" }} />
              </div>
              <div style={{ minWidth: 0 }}>
                <div style={{ fontWeight: 600, fontSize: "0.93rem", whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>{row.titulo || "(sem título)"}</div>
                <div style={{ fontSize: "0.76rem", color: "var(--c-muted)", marginTop: 2 }}>{row.especialidade || "—"} · {per ? per + "° período" : "—"} · {fmtTempo(row.tempoSegundos)}</div>
              </div>
              <div style={{ display: "flex", flexWrap: "wrap", gap: 5, minWidth: 0 }}>
                {row.conteudos.slice(0, 3).map((c, i) => (
                  <span key={i} style={{ background: "var(--c-panel-2)", border: `1px solid ${c.principal ? "var(--c-teal)" : "var(--c-line)"}`, color: c.principal ? "var(--c-teal)" : "var(--c-muted)", borderRadius: 14, padding: "2px 8px", fontSize: "0.72rem", whiteSpace: "nowrap", maxWidth: 150, overflow: "hidden", textOverflow: "ellipsis" }}>
                    {c.principal ? "⭐ " : ""}{c.nome}
                  </span>
                ))}
              </div>
              <div>
                <span style={{ background: sm.bg, color: sm.fg, borderRadius: 20, padding: "3px 11px", fontSize: "0.74rem", fontWeight: 700, whiteSpace: "nowrap" }}>{sm.label}</span>
              </div>
              <div style={{ display: "flex", alignItems: "center", gap: 7, minWidth: 0 }}>
                <span style={{ width: 22, height: 22, flexShrink: 0, borderRadius: "50%", background: avatarCor(row.autor), color: "#fff", display: "grid", placeItems: "center", fontSize: "0.68rem", fontWeight: 700 }}>
                  {(row.autor || "?").charAt(0).toUpperCase()}
                </span>
                <span style={{ fontSize: "0.83rem", whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>{row.autor}</span>
              </div>
              <div style={{ fontSize: "0.8rem", color: "var(--c-muted)", whiteSpace: "nowrap" }}>{fmtData(row.atualizadoEm)}</div>
              <div style={{ display: "flex", gap: 4, justifyContent: "flex-end" }}>
                <IconBtn title="Preview" onClick={(e) => { e.stopPropagation(); onPreview(row.id); }}>▶</IconBtn>
                <IconBtn title="Histórico" onClick={(e) => { e.stopPropagation(); onHist(row.id); }}>🕘</IconBtn>
                <IconBtn title="Duplicar" onClick={(e) => { e.stopPropagation(); onDuplicar?.(row.id); }}>⧉</IconBtn>
              </div>
            </div>
          );
        })}

        {rows.length === 0 && (
          <div style={{ padding: 48, textAlign: "center", color: "var(--c-muted)", fontSize: "0.95rem" }}>Nenhum caso encontrado com esses filtros.</div>
        )}
      </div>
    </main>
  );
}
