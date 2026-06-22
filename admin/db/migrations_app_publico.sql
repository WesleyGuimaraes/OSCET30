-- =====================================================================
--  OSCET30 — RLS para o APP DE TREINO (público / chave anon)
--
--  O app de treino (sem login) lê os casos diretamente do Supabase com a
--  chave publishable/anon. Estas políticas liberam leitura pública APENAS
--  do que pertence a casos com status = 'publicado' — rascunhos e itens de
--  casos não publicados continuam invisíveis para o público.
--
--  Rode no SQL Editor depois de schema.sql + migrations.sql. Idempotente.
-- =====================================================================

-- casos: a policy pública (status = 'publicado') já vem do schema.sql.

-- vínculo caso<->conteúdo, só de casos publicados
drop policy if exists "publico le caso_conteudo publicado" on caso_conteudo;
create policy "publico le caso_conteudo publicado" on caso_conteudo
  for select using (
    exists (select 1 from casos c where c.id = caso_conteudo.caso_id and c.status = 'publicado')
  );

-- checklist do caso, só de casos publicados
drop policy if exists "publico le checklist publicado" on caso_checklist_itens;
create policy "publico le checklist publicado" on caso_checklist_itens
  for select using (
    exists (select 1 from casos c where c.id = caso_checklist_itens.caso_id and c.status = 'publicado')
  );

-- nomes dos conteúdos (categorias) — não são sensíveis, leitura pública
drop policy if exists "publico le conteudos" on conteudos;
create policy "publico le conteudos" on conteudos
  for select using (true);

-- textos dos itens de checklist reutilizáveis (genéricos) — leitura pública,
-- necessária para resolver o texto de itens que referenciam o banco base
drop policy if exists "publico le checklist_base" on checklist_itens_base;
create policy "publico le checklist_base" on checklist_itens_base
  for select using (true);
