import { useMemo, useState } from "react";
import { STATUS_META } from "../lib/data.js";

const META_POR_CONTEUDO = 10; // meta de casos por conteúdo (HANDOFF: ~10–15)

function StatCard({ label, valor, cor, topo }) {
  return (
    <div className="card" style={{ padding: "16px 18px", borderTop: `3px solid ${topo}` }}>
      <div style={{ fontSize: "1.9rem", fontWeight: 800, color: cor || "var(--c-text)", lineHeight: 1, fontVariantNumeric: "tabular-nums" }}>
        {valor}
      </div>
      <div style={{ fontSize: "0.8rem", color: "var(--c-muted)", marginTop: 7 }}>{label}</div>
    </div>
  );
}

function Barra({ valor, max, cor }) {
  const pct = max ? Math.min(100, (valor / max) * 100) : 0;
  return (
    <div style={{ flex: 1, height: 8, borderRadius: 5, background: "var(--c-panel-2)", overflow: "hidden" }}>
      <div style={{ width: `${pct}%`, height: "100%", background: cor, transition: "width 0.3s var(--ease)" }} />
    </div>
  );
}

export default function Dashboard({ casos, taxonomia, onIrParaConteudo, onNovoCaso }) {
  const [discAberta, setDiscAberta] = useState(null);

  const stats = useMemo(() => {
    const porStatus = { rascunho: 0, em_revisao: 0, publicado: 0, arquivado: 0 };
    casos.forEach((c) => {
      if (porStatus[c.status] !== undefined) porStatus[c.status]++;
    });
    return { total: casos.length, ...porStatus };
  }, [casos]);

  // contagem de casos por conteúdo (conta cada vínculo, principal ou não)
  const contagemPorConteudo = useMemo(() => {
    const m = {};
    casos.forEach((c) => {
      c.conteudos.forEach((ct) => {
        m[ct.id] = (m[ct.id] || 0) + 1;
      });
    });
    return m;
  }, [casos]);

  // agrupa a taxonomia por disciplina → período → conteúdos, com contagem
  const grupos = useMemo(() => {
    const porDisc = {};
    taxonomia.forEach((ct) => {
      const dkey = ct.disciplina || "—";
      if (!porDisc[dkey]) porDisc[dkey] = { disciplina: dkey, conteudos: [], total: 0, comAlgum: 0 };
      const n = contagemPorConteudo[ct.id] || 0;
      porDisc[dkey].conteudos.push({ ...ct, n });
      porDisc[dkey].total += n;
      if (n > 0) porDisc[dkey].comAlgum++;
    });
    return Object.values(porDisc).sort((a, b) => b.total - a.total || a.disciplina.localeCompare(b.disciplina));
  }, [taxonomia, contagemPorConteudo]);

  const maxDisc = Math.max(1, ...grupos.map((g) => g.total));
  const conteudosVazios = useMemo(
    () => taxonomia.filter((ct) => !(contagemPorConteudo[ct.id] > 0)).length,
    [taxonomia, contagemPorConteudo]
  );

  return (
    <main style={{ maxWidth: 1080, margin: "0 auto", padding: "26px 28px 80px" }}>
      <div style={{ display: "flex", alignItems: "flex-end", justifyContent: "space-between", gap: 16, marginBottom: 20, flexWrap: "wrap" }}>
        <div>
          <h1 style={{ margin: 0, fontSize: "1.62rem", fontWeight: 800 }}>Visão geral</h1>
          <p style={{ margin: "6px 0 0", color: "var(--c-muted)", fontSize: "0.9rem" }}>
            Produção de casos por status e por conteúdo · meta sugerida de {META_POR_CONTEUDO} casos por conteúdo.
          </p>
        </div>
        {onNovoCaso && (
          <button className="btn btn-primary" onClick={onNovoCaso}>+ Novo caso</button>
        )}
      </div>

      {/* cards de status */}
      <div className="dash-stats" style={{ marginBottom: 24 }}>
        <StatCard label="Total de casos" valor={stats.total} topo="var(--c-teal)" />
        <StatCard label="Rascunhos" valor={stats.rascunho} cor={STATUS_META.rascunho.fg} topo={STATUS_META.rascunho.fg} />
        <StatCard label="Em revisão" valor={stats.em_revisao} cor={STATUS_META.em_revisao.fg} topo={STATUS_META.em_revisao.fg} />
        <StatCard label="Publicados" valor={stats.publicado} cor={STATUS_META.publicado.fg} topo={STATUS_META.publicado.fg} />
        <StatCard label="Arquivados" valor={stats.arquivado} cor={STATUS_META.arquivado.fg} topo={STATUS_META.arquivado.fg} />
      </div>

      <div className="dash-cols">
        {/* casos por disciplina */}
        <div>
          <h2 style={{ margin: "0 0 12px", fontSize: "1.05rem", fontWeight: 700 }}>Casos por disciplina</h2>
          <div className="card" style={{ display: "flex", flexDirection: "column", gap: 13 }}>
            {grupos.map((g) => (
              <div key={g.disciplina} style={{ display: "flex", alignItems: "center", gap: 14 }}>
                <div style={{ width: 150, fontSize: "0.85rem", fontWeight: 600, whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>
                  {g.disciplina}
                </div>
                <Barra valor={g.total} max={maxDisc} cor="var(--c-teal)" />
                <div style={{ width: 56, textAlign: "right", fontSize: "0.82rem", color: "var(--c-muted)", fontVariantNumeric: "tabular-nums", fontWeight: 600 }}>
                  {g.total}
                </div>
              </div>
            ))}
            {grupos.length === 0 && <div style={{ color: "var(--c-muted)", fontSize: "0.9rem" }}>Sem taxonomia carregada.</div>}
          </div>
        </div>

        {/* progresso por conteúdo */}
        <div>
          <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", gap: 10, margin: "0 0 12px", flexWrap: "wrap" }}>
            <h2 style={{ margin: 0, fontSize: "1.05rem", fontWeight: 700 }}>Progresso por conteúdo</h2>
            {conteudosVazios > 0 && (
              <span style={{ fontSize: "0.75rem", color: "var(--c-danger)", background: "var(--c-bad-fill)", border: "1px solid #3a2222", borderRadius: 20, padding: "3px 10px", fontWeight: 600 }}>
                {conteudosVazios} {conteudosVazios === 1 ? "conteúdo sem nenhum caso" : "conteúdos sem nenhum caso"}
              </span>
            )}
          </div>
          <div style={{ display: "flex", flexDirection: "column", gap: 9 }}>
            {grupos.map((g) => {
              const aberta = discAberta === g.disciplina;
              const totalConteudos = g.conteudos.length;
              return (
                <div key={g.disciplina} className="card" style={{ padding: 0, overflow: "hidden" }}>
                  <button
                    onClick={() => setDiscAberta(aberta ? null : g.disciplina)}
                    style={{ width: "100%", display: "flex", alignItems: "center", justifyContent: "space-between", gap: 12, padding: "13px 16px", background: "transparent", border: "none", cursor: "pointer", color: "var(--c-text)" }}
                  >
                    <span style={{ fontWeight: 700, fontSize: "0.92rem" }}>{aberta ? "▾" : "▸"} {g.disciplina}</span>
                    <span style={{ fontSize: "0.8rem", color: "var(--c-muted)" }}>{g.comAlgum}/{totalConteudos} conteúdos iniciados</span>
                  </button>
                  {aberta && (
                    <div style={{ borderTop: "1px solid var(--c-line)", padding: "8px 16px 14px" }}>
                      {g.conteudos
                        .slice()
                        .sort((a, b) => (a.periodo || 0) - (b.periodo || 0) || a.nome.localeCompare(b.nome))
                        .map((ct, idx, arr) => {
                          const atingiu = ct.n >= META_POR_CONTEUDO;
                          const cor = ct.n === 0 ? "var(--c-danger)" : atingiu ? "var(--c-good)" : "var(--c-warn)";
                          return (
                            <div
                              key={ct.id}
                              onClick={() => onIrParaConteudo?.(ct)}
                              title="Ver casos deste conteúdo"
                              style={{ display: "flex", alignItems: "center", gap: 12, padding: "8px 0", borderBottom: idx < arr.length - 1 ? "1px solid var(--c-line)" : "none", cursor: "pointer" }}
                            >
                              <div style={{ width: 22, fontSize: "0.72rem", color: "var(--c-muted)" }}>{ct.periodo}°</div>
                              <div style={{ flex: 1, minWidth: 0, fontSize: "0.85rem", whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>{ct.nome}</div>
                              <div style={{ width: 90 }}><Barra valor={ct.n} max={META_POR_CONTEUDO} cor={cor} /></div>
                              <div style={{ width: 48, textAlign: "right", fontSize: "0.8rem", color: cor, fontWeight: 700, fontVariantNumeric: "tabular-nums" }}>{ct.n}/{META_POR_CONTEUDO}</div>
                            </div>
                          );
                        })}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </main>
  );
}
