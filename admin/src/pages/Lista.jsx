import { useEffect, useMemo, useState } from "react";
import { STATUS_META, fmtData, fmtTempo } from "../lib/data.js";

function Select({ label, value, onChange, options }) {
  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 5 }}>
      <label className="label">{label}</label>
      <select
        className="input"
        style={{ padding: "9px 10px", cursor: "pointer" }}
        value={value}
        onChange={onChange}
      >
        {options.map((o) => (
          <option key={o.val} value={o.val}>
            {o.label}
          </option>
        ))}
      </select>
    </div>
  );
}

export default function Lista({ casos, taxonomia, filtroConteudoId, onNovoCaso, onOpenCaso, onPreview, onHist }) {
  const [busca, setBusca] = useState("");
  const [fDisciplina, setFDisciplina] = useState("");
  const [fPeriodo, setFPeriodo] = useState("");
  const [fConteudo, setFConteudo] = useState("");
  const [fStatus, setFStatus] = useState("");
  const [fAutor, setFAutor] = useState("");

  // pré-filtro vindo do Dashboard (clicar num conteúdo abre a lista já filtrada).
  // Quando volta vazio (ex.: clicou em "Casos" no topo), limpa o filtro.
  useEffect(() => {
    setFConteudo(filtroConteudoId || "");
    if (filtroConteudoId) {
      setFDisciplina("");
      setFPeriodo("");
    }
  }, [filtroConteudoId]);

  const disciplinas = useMemo(
    () => [...new Set(taxonomia.map((c) => c.disciplina).filter(Boolean))],
    [taxonomia]
  );
  const periodos = useMemo(
    () => [...new Set(taxonomia.map((c) => c.periodo).filter(Boolean))].sort((a, b) => a - b),
    [taxonomia]
  );
  const conteudoOpts = useMemo(() => {
    const filtrados = taxonomia.filter(
      (c) => (!fDisciplina || c.disciplina === fDisciplina) && (!fPeriodo || String(c.periodo) === fPeriodo)
    );
    return filtrados.map((c) => ({ val: c.id, label: c.nome }));
  }, [taxonomia, fDisciplina, fPeriodo]);
  const autores = useMemo(
    () => [...new Set(casos.map((c) => c.autor).filter((a) => a && a !== "—"))],
    [casos]
  );

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

  return (
    <main style={{ maxWidth: 1180, margin: "0 auto", padding: "28px 28px 80px" }}>
      <div style={{ display: "flex", alignItems: "flex-end", justifyContent: "space-between", gap: 16, marginBottom: 22 }}>
        <div>
          <h1 style={{ margin: 0, fontSize: "1.6rem", fontWeight: 800 }}>Casos clínicos</h1>
          <p style={{ margin: "6px 0 0", color: "var(--c-muted)", fontSize: "0.9rem" }}>
            {rows.length} {rows.length === 1 ? "caso" : "casos"} · {publicados} publicados · {emRevisao} em revisão
          </p>
        </div>
        <button className="btn btn-primary" onClick={onNovoCaso}>
          + Novo caso
        </button>
      </div>

      <div
        className="card"
        style={{
          padding: 16,
          marginBottom: 18,
          display: "grid",
          gridTemplateColumns: "1.6fr repeat(5, 1fr)",
          gap: 10,
        }}
      >
        <div style={{ display: "flex", flexDirection: "column", gap: 5 }}>
          <label className="label">Buscar por título</label>
          <input
            className="input"
            style={{ padding: "9px 12px" }}
            value={busca}
            onChange={(e) => setBusca(e.target.value)}
            placeholder="Digite um título…"
          />
        </div>
        <Select
          label="Disciplina"
          value={fDisciplina}
          onChange={(e) => {
            setFDisciplina(e.target.value);
            setFConteudo("");
          }}
          options={[{ val: "", label: "Todas" }, ...disciplinas.map((d) => ({ val: d, label: d }))]}
        />
        <Select
          label="Período"
          value={fPeriodo}
          onChange={(e) => {
            setFPeriodo(e.target.value);
            setFConteudo("");
          }}
          options={[{ val: "", label: "Todos" }, ...periodos.map((p) => ({ val: String(p), label: p + "° período" }))]}
        />
        <Select
          label="Conteúdo"
          value={fConteudo}
          onChange={(e) => setFConteudo(e.target.value)}
          options={[{ val: "", label: "Todos" }, ...conteudoOpts]}
        />
        <Select
          label="Status"
          value={fStatus}
          onChange={(e) => setFStatus(e.target.value)}
          options={[{ val: "", label: "Todos" }, ...Object.keys(STATUS_META).map((k) => ({ val: k, label: STATUS_META[k].label }))]}
        />
        <Select
          label="Autor"
          value={fAutor}
          onChange={(e) => setFAutor(e.target.value)}
          options={[{ val: "", label: "Todos" }, ...autores.map((a) => ({ val: a, label: a }))]}
        />
      </div>

      <div className="card" style={{ padding: 0, overflow: "hidden" }}>
        <div
          style={{
            display: "grid",
            gridTemplateColumns: "2.4fr 1.6fr 1fr 1.1fr 0.9fr 128px",
            gap: 14,
            padding: "12px 18px",
            borderBottom: "1px solid var(--c-line)",
            fontSize: "0.7rem",
            textTransform: "uppercase",
            letterSpacing: "0.5px",
            color: "var(--c-muted)",
            fontWeight: 700,
          }}
        >
          <div>Título</div>
          <div>Conteúdos</div>
          <div>Status</div>
          <div>Autor</div>
          <div>Atualizado</div>
          <div></div>
        </div>

        {rows.map((row) => {
          const sm = STATUS_META[row.status] || STATUS_META.rascunho;
          const per = row.conteudos[0]?.periodo;
          return (
            <div
              key={row.id}
              onClick={() => onOpenCaso(row.id)}
              style={{
                display: "grid",
                gridTemplateColumns: "2.4fr 1.6fr 1fr 1.1fr 0.9fr 128px",
                gap: 14,
                padding: "14px 18px",
                borderBottom: "1px solid var(--c-line)",
                alignItems: "center",
                cursor: "pointer",
              }}
            >
              <div style={{ minWidth: 0 }}>
                <div style={{ fontWeight: 600, fontSize: "0.95rem", whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>
                  {row.titulo || "(sem título)"}
                </div>
                <div style={{ fontSize: "0.78rem", color: "var(--c-muted)", marginTop: 2 }}>
                  {row.especialidade || "—"} · {per ? per + "° período" : "—"} · {fmtTempo(row.tempoSegundos)}
                </div>
              </div>
              <div style={{ display: "flex", flexWrap: "wrap", gap: 5, minWidth: 0 }}>
                {row.conteudos.slice(0, 3).map((c, i) => (
                  <span
                    key={i}
                    style={{
                      display: "inline-block",
                      background: "var(--c-panel-2)",
                      border: `1px solid ${c.principal ? "var(--c-teal)" : "var(--c-line)"}`,
                      color: c.principal ? "var(--c-teal)" : "var(--c-muted)",
                      borderRadius: 14,
                      padding: "2px 8px",
                      fontSize: "0.72rem",
                      whiteSpace: "nowrap",
                      maxWidth: 150,
                      overflow: "hidden",
                      textOverflow: "ellipsis",
                    }}
                  >
                    {c.principal ? "⭐ " : ""}
                    {c.nome}
                  </span>
                ))}
              </div>
              <div>
                <span
                  style={{
                    display: "inline-block",
                    background: sm.bg,
                    color: sm.fg,
                    borderRadius: 20,
                    padding: "3px 11px",
                    fontSize: "0.74rem",
                    fontWeight: 700,
                    whiteSpace: "nowrap",
                  }}
                >
                  {sm.label}
                </span>
              </div>
              <div style={{ fontSize: "0.85rem", whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>{row.autor}</div>
              <div style={{ fontSize: "0.82rem", color: "var(--c-muted)", whiteSpace: "nowrap" }}>{fmtData(row.atualizadoEm)}</div>
              <div style={{ display: "flex", gap: 4, justifyContent: "flex-end" }}>
                <button
                  title="Preview"
                  onClick={(e) => {
                    e.stopPropagation();
                    onPreview(row.id);
                  }}
                  style={{
                    width: 30,
                    height: 30,
                    display: "grid",
                    placeItems: "center",
                    background: "transparent",
                    border: "1px solid var(--c-line)",
                    borderRadius: 8,
                    color: "var(--c-muted)",
                    cursor: "pointer",
                  }}
                >
                  ▶
                </button>
                <button
                  title="Histórico"
                  onClick={(e) => {
                    e.stopPropagation();
                    onHist(row.id);
                  }}
                  style={{
                    width: 30,
                    height: 30,
                    display: "grid",
                    placeItems: "center",
                    background: "transparent",
                    border: "1px solid var(--c-line)",
                    borderRadius: 8,
                    color: "var(--c-muted)",
                    cursor: "pointer",
                  }}
                >
                  🕘
                </button>
                <button
                  title="Duplicar"
                  onClick={(e) => {
                    e.stopPropagation();
                    onDuplicar(row.id);
                  }}
                  style={{
                    width: 30,
                    height: 30,
                    display: "grid",
                    placeItems: "center",
                    background: "transparent",
                    border: "1px solid var(--c-line)",
                    borderRadius: 8,
                    color: "var(--c-muted)",
                    cursor: "pointer",
                  }}
                >
                  ⧉
                </button>
              </div>
            </div>
          );
        })}

        {rows.length === 0 && (
          <div style={{ padding: 48, textAlign: "center", color: "var(--c-muted)", fontSize: "0.95rem" }}>
            Nenhum caso encontrado com esses filtros.
          </div>
        )}
      </div>
    </main>
  );
}
