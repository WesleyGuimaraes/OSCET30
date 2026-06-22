/* OSCE Online — fonte de dados: casos PUBLICADOS do Supabase.
   Expõe window.loadOsceCases() -> Promise<Array> no formato que o app.js usa
   (mesmo shape do antigo cases.js / window.OSCE_CASES).

   A chave publishable/anon é pública por design — quem protege os dados é a
   RLS no Supabase (o público só lê casos com status = 'publicado'). */
(() => {
  const SUPABASE_URL = "https://goykvxbtabrheakybgvd.supabase.co";
  // chave PUBLISHABLE/anon (nunca a secret). Se for rotacionada, atualize aqui.
  const SUPABASE_ANON_KEY = "sb_publishable_JLPOZYZjs6aqVa3eZF_e_w_sw6w5SRl";

  // normaliza gravidades (1–5) -> pesos inteiros somando exatamente 100
  // (mesmo algoritmo do painel admin, p/ o checklist bater com a Preview).
  function normalizar(items) {
    const grav = items.map((i) => Math.max(1, Math.min(5, i.gravidade || 1)));
    const soma = grav.reduce((a, b) => a + b, 0);
    if (!soma) return items.map(() => 0);
    const raw = grav.map((g) => (g / soma) * 100);
    const floor = raw.map((r) => Math.floor(r));
    const resto = 100 - floor.reduce((a, b) => a + b, 0);
    const ordem = raw
      .map((r, idx) => ({ idx, frac: r - Math.floor(r) }))
      .sort((a, b) => b.frac - a.frac);
    const pesos = floor.slice();
    for (let k = 0; k < resto; k++) pesos[ordem[k % ordem.length].idx]++;
    return pesos;
  }

  function mapCaso(c) {
    // conteúdos como nomes, principal primeiro (o app usa conteudos[0] como tag)
    const conteudos = (c.caso_conteudo || [])
      .slice()
      .sort((a, b) => (b.principal ? 1 : 0) - (a.principal ? 1 : 0))
      .map((cc) => cc.conteudo && cc.conteudo.nome)
      .filter(Boolean);

    const ck = (c.caso_checklist_itens || [])
      .slice()
      .sort((a, b) => (a.ordem || 0) - (b.ordem || 0));
    const pesos = normalizar(ck);
    const checklist = ck.map((it, i) => ({
      item: (it.item_base && it.item_base.texto) || it.texto_especifico || "",
      peso: pesos[i],
    }));

    return {
      id: c.id,
      titulo: c.titulo,
      especialidade: c.especialidade || "",
      conteudos,
      tempo: c.tempo_segundos || 300,
      queixaPrincipal: c.queixa_principal || "",
      resumo: c.resumo || "",
      paciente: {
        personagem: c.personagem || "",
        contexto: c.contexto || "",
        roteiro: Array.isArray(c.roteiro) ? c.roteiro : [],
        examesAchados: c.exames_achados || "",
      },
      checklist,
    };
  }

  window.loadOsceCases = async function () {
    if (!window.supabase || !window.supabase.createClient) {
      throw new Error("supabase-js não carregou (verifique a conexão).");
    }
    const sb = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
    const { data, error } = await sb
      .from("casos")
      .select(
        `id, titulo, especialidade, tempo_segundos, queixa_principal, resumo,
         personagem, contexto, roteiro, exames_achados,
         caso_conteudo ( principal, conteudo:conteudo_id ( nome ) ),
         caso_checklist_itens ( gravidade, ordem, texto_especifico, item_base:item_base_id ( texto ) )`
      )
      .eq("status", "publicado");
    if (error) throw error;
    return (data || []).map(mapCaso);
  };
})();
