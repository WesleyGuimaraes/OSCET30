import { supabase } from "../supabaseClient.js";

// taxonomia completa: disciplinas > períodos > conteúdos, já achatada
// pra facilitar filtros e exibição (espelha o que o prototype fazia com
// a lista mockada this.CONTEUDOS).
export async function fetchTaxonomia() {
  const { data, error } = await supabase
    .from("conteudos")
    .select(
      `id, nome, slug, ordem, ativo,
       disciplina_periodo:disciplina_periodo_id (
         id,
         disciplina:disciplina_id ( id, nome, slug ),
         periodo:periodo_id ( id, numero, nome )
       )`
    )
    .eq("ativo", true)
    .order("ordem");
  if (error) throw error;
  return (data || []).map((c) => ({
    id: c.id,
    nome: c.nome,
    disciplinaId: c.disciplina_periodo?.disciplina?.id,
    disciplina: c.disciplina_periodo?.disciplina?.nome,
    periodoId: c.disciplina_periodo?.periodo?.id,
    periodo: c.disciplina_periodo?.periodo?.numero,
  }));
}

export async function fetchUsuariosAdmin() {
  const { data, error } = await supabase
    .from("usuarios_admin")
    .select("id, nome, role")
    .eq("ativo", true);
  if (error) throw error;
  return data || [];
}

// casos + conteúdos associados (N:N) + autor (criado_por).
// Status: por padrão a RLS já restringe o que cada papel pode ver
// (público só publicado; editor/revisor/owner autenticados veem tudo).
export async function fetchCasos() {
  const { data, error } = await supabase
    .from("casos")
    .select(
      `id, titulo, especialidade, subtipo, tempo_segundos, queixa_principal,
       status, criado_por, atualizado_em, publicado_em,
       autor:criado_por ( id, nome ),
       caso_conteudo (
         principal,
         conteudo:conteudo_id ( id, nome,
           disciplina_periodo:disciplina_periodo_id (
             disciplina:disciplina_id ( nome ),
             periodo:periodo_id ( numero )
           )
         )
       )`
    )
    .order("atualizado_em", { ascending: false });
  if (error) throw error;
  return (data || []).map(normalizeCaso);
}

function normalizeCaso(c) {
  const conteudos = (c.caso_conteudo || [])
    .map((cc) => ({
      id: cc.conteudo?.id,
      nome: cc.conteudo?.nome,
      disciplina: cc.conteudo?.disciplina_periodo?.disciplina?.nome,
      periodo: cc.conteudo?.disciplina_periodo?.periodo?.numero,
      principal: cc.principal,
    }))
    .filter((x) => x.id);
  return {
    id: c.id,
    titulo: c.titulo,
    especialidade: c.especialidade,
    subtipo: c.subtipo,
    tempoSegundos: c.tempo_segundos,
    queixaPrincipal: c.queixa_principal,
    status: c.status,
    autor: c.autor?.nome || "—",
    autorId: c.criado_por,
    atualizadoEm: c.atualizado_em,
    publicadoEm: c.publicado_em,
    conteudos,
  };
}

export function fmtTempo(seg) {
  const m = Math.floor((seg || 0) / 60);
  const s = (seg || 0) % 60;
  return `${String(m).padStart(2, "0")}:${String(s).padStart(2, "0")}`;
}

export function fmtData(iso) {
  if (!iso) return "—";
  const d = new Date(iso);
  const dd = String(d.getDate()).padStart(2, "0");
  const mm = String(d.getMonth() + 1).padStart(2, "0");
  const hh = String(d.getHours()).padStart(2, "0");
  const mi = String(d.getMinutes()).padStart(2, "0");
  return `${dd}/${mm}/${d.getFullYear()} ${hh}:${mi}`;
}

export const STATUS_META = {
  rascunho: { label: "Rascunho", bg: "#1b2530", fg: "#8aa0b3" },
  em_revisao: { label: "Em revisão", bg: "#2a2418", fg: "#e0a24a" },
  publicado: { label: "Publicado", bg: "#16291f", fg: "#48c78e" },
  arquivado: { label: "Arquivado", bg: "#241c1c", fg: "#c08a8a" },
};

// normaliza gravidades (1–5) → pesos inteiros somando exatamente 100
// (mesmo algoritmo do protótipo: floor + maior resto)
export function normalizar(checklist) {
  const grav = checklist.map((i) => Math.max(1, Math.min(5, i.gravidade || 1)));
  const soma = grav.reduce((a, b) => a + b, 0);
  if (!soma) return checklist.map(() => 0);
  const raw = grav.map((g) => (g / soma) * 100);
  const floor = raw.map((r) => Math.floor(r));
  let resto = 100 - floor.reduce((a, b) => a + b, 0);
  const ordem = raw
    .map((r, idx) => ({ idx, frac: r - Math.floor(r) }))
    .sort((a, b) => b.frac - a.frac);
  const pesos = floor.slice();
  for (let k = 0; k < resto; k++) pesos[ordem[k % ordem.length].idx]++;
  return pesos;
}

export function gravLabel(g) {
  return ["", "Mínima", "Baixa", "Média", "Alta", "Crítica"][g] || "Média";
}

// caso completo (form + conteúdos + checklist) pra abrir no Editor
export async function fetchCasoCompleto(id) {
  const { data: caso, error: e1 } = await supabase
    .from("casos")
    .select(
      `id, titulo, especialidade, subtipo, tempo_segundos, queixa_principal,
       resumo, personagem, contexto, roteiro, exames_achados,
       status, criado_por, atualizado_em, publicado_em`
    )
    .eq("id", id)
    .single();
  if (e1) throw e1;

  const { data: cc, error: e2 } = await supabase
    .from("caso_conteudo")
    .select(
      `principal,
       conteudo:conteudo_id ( id, nome,
         disciplina_periodo:disciplina_periodo_id (
           disciplina:disciplina_id ( nome ),
           periodo:periodo_id ( numero )
         )
       )`
    )
    .eq("caso_id", id);
  if (e2) throw e2;

  const { data: ck, error: e3 } = await supabase
    .from("caso_checklist_itens")
    .select(`id, item_base_id, texto_especifico, gravidade, ordem, item_base:item_base_id ( texto )`)
    .eq("caso_id", id)
    .order("ordem");
  if (e3) throw e3;

  return {
    ...caso,
    roteiro: caso.roteiro || [],
    conteudos: (cc || [])
      .map((x) => ({
        id: x.conteudo?.id,
        nome: x.conteudo?.nome,
        disciplina: x.conteudo?.disciplina_periodo?.disciplina?.nome,
        periodo: x.conteudo?.disciplina_periodo?.periodo?.numero,
        principal: x.principal,
      }))
      .filter((x) => x.id),
    checklist: (ck || []).map((x) => ({
      id: x.id,
      itemBaseId: x.item_base_id,
      texto: x.item_base?.texto ?? x.texto_especifico ?? "",
      gravidade: x.gravidade,
      ordem: x.ordem,
    })),
  };
}

export function novoCasoVazio() {
  return {
    id: null,
    titulo: "",
    especialidade: "",
    subtipo: "",
    tempo_segundos: 300,
    queixa_principal: "",
    resumo: "",
    personagem: "",
    contexto: "",
    roteiro: [],
    exames_achados: "",
    status: "rascunho",
    conteudos: [],
    checklist: [],
  };
}

export async function fetchChecklistBanco() {
  const { data, error } = await supabase
    .from("checklist_itens_base")
    .select("id, texto, categoria, gravidade_padrao, usos")
    .order("usos", { ascending: false });
  if (error) throw error;
  return data || [];
}

// grava o caso (insert ou update) + sincroniza conteúdos e checklist
// (estratégia: apaga e reinsere as linhas N:N — simples e correto pro
// volume esperado de itens por caso).
export async function salvarCaso(draft, userId) {
  const isNew = !draft.id;
  const payloadCaso = {
    titulo: draft.titulo,
    especialidade: draft.especialidade,
    subtipo: draft.subtipo || null,
    tempo_segundos: draft.tempo_segundos,
    queixa_principal: draft.queixa_principal,
    resumo: draft.resumo,
    personagem: draft.personagem,
    contexto: draft.contexto,
    roteiro: draft.roteiro,
    exames_achados: draft.exames_achados,
  };

  let casoId = draft.id;
  if (isNew) {
    const { data, error } = await supabase
      .from("casos")
      .insert({ ...payloadCaso, criado_por: userId, status: "rascunho" })
      .select("id, status")
      .single();
    if (error) throw error;
    casoId = data.id;
  } else {
    const { error } = await supabase.from("casos").update(payloadCaso).eq("id", casoId);
    if (error) throw error;
  }

  // conteúdos: apaga e reinsere
  await supabase.from("caso_conteudo").delete().eq("caso_id", casoId);
  if (draft.conteudos.length) {
    const rows = draft.conteudos.map((c) => ({
      caso_id: casoId,
      conteudo_id: c.id,
      principal: !!c.principal,
    }));
    const { error } = await supabase.from("caso_conteudo").insert(rows);
    if (error) throw error;
  }

  // checklist: apaga e reinsere
  await supabase.from("caso_checklist_itens").delete().eq("caso_id", casoId);
  if (draft.checklist.length) {
    const rows = draft.checklist.map((it, i) => ({
      caso_id: casoId,
      item_base_id: it.itemBaseId || null,
      texto_especifico: it.itemBaseId ? null : it.texto,
      gravidade: it.gravidade,
      ordem: i,
    }));
    const { error } = await supabase.from("caso_checklist_itens").insert(rows);
    if (error) throw error;
  }

  return casoId;
}

export async function mudarStatus(casoId, novoStatus) {
  const { error } = await supabase.from("casos").update({ status: novoStatus }).eq("id", casoId);
  if (error) throw error;
}

// clona um caso como novo rascunho (título + " (cópia)"), copiando
// conteúdos e checklist. Reaproveita salvarCaso.
export async function duplicarCaso(casoId, userId) {
  const c = await fetchCasoCompleto(casoId);
  const copia = {
    id: null,
    titulo: `${c.titulo || "(sem título)"} (cópia)`,
    especialidade: c.especialidade,
    subtipo: c.subtipo,
    tempo_segundos: c.tempo_segundos,
    queixa_principal: c.queixa_principal,
    resumo: c.resumo,
    personagem: c.personagem,
    contexto: c.contexto,
    roteiro: c.roteiro,
    exames_achados: c.exames_achados,
    status: "rascunho",
    conteudos: c.conteudos,
    checklist: c.checklist.map((it) => ({ ...it, id: undefined })),
  };
  return await salvarCaso(copia, userId);
}

export async function fetchCasosEmRevisao() {
  return (await fetchCasos()).filter((c) => c.status === "em_revisao");
}

// apaga o caso e os registros dependentes. Restrito a owner pela RLS
// (ver db/migrations.sql) — chamar só atrás de um gate de admin.role no front.
export async function apagarCaso(casoId) {
  await supabase.from("caso_checklist_itens").delete().eq("caso_id", casoId);
  await supabase.from("caso_conteudo").delete().eq("caso_id", casoId);
  await supabase.from("casos_historico").delete().eq("caso_id", casoId);
  const { error } = await supabase.from("casos").delete().eq("id", casoId);
  if (error) throw error;
}

// devolve pra rascunho registrando a observação do revisor (linha extra no
// histórico, além da automática "devolvido_para_rascunho" que o trigger cria).
// A inserção da observação é "best-effort": se a coluna obs / a policy ainda
// não estiverem migradas, a devolução em si (mudança de status) não é abortada.
export async function devolverCaso(casoId, obs, userId) {
  if (obs && obs.trim()) {
    const { error } = await supabase.from("casos_historico").insert({
      caso_id: casoId,
      usuario_id: userId,
      snapshot: {},
      acao: "devolveu",
      obs: obs.trim(),
    });
    if (error) {
      // não bloqueia a devolução; só registra no console p/ diagnóstico
      // eslint-disable-next-line no-console
      console.warn("Não foi possível gravar a observação no histórico:", error.message);
    }
  }
  await mudarStatus(casoId, "rascunho");
}

export const ACAO_META = {
  criado: { label: "Caso criado", icon: "✨", color: "#8aa0b3" },
  editado: { label: "Caso editado", icon: "✏️", color: "#4a8bdf" },
  enviado_para_revisao: { label: "Enviado para revisão", icon: "📤", color: "#e0a24a" },
  publicado: { label: "Publicado", icon: "✅", color: "#48c78e" },
  devolveu: { label: "Devolvido com observação", icon: "↩️", color: "#e05a5a" },
  devolvido_para_rascunho: { label: "Devolvido para rascunho", icon: "↩️", color: "#e05a5a" },
  arquivado: { label: "Arquivado", icon: "🗄️", color: "#c08a8a" },
};

export async function fetchHistorico(casoId) {
  const map = (data) =>
    (data || []).map((e) => ({
      id: e.id,
      acao: e.acao,
      obs: e.obs ?? null,
      quando: e.criado_em,
      quem: e.usuario?.nome || "—",
    }));

  // tenta com a coluna obs; se ela ainda não foi migrada, refaz sem ela
  let { data, error } = await supabase
    .from("casos_historico")
    .select("id, acao, obs, criado_em, usuario:usuario_id ( nome )")
    .eq("caso_id", casoId)
    .order("criado_em", { ascending: false });
  if (error) {
    const r = await supabase
      .from("casos_historico")
      .select("id, acao, criado_em, usuario:usuario_id ( nome )")
      .eq("caso_id", casoId)
      .order("criado_em", { ascending: false });
    if (r.error) throw r.error;
    return map(r.data);
  }
  return map(data);
}
