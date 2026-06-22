-- =====================================================================
--  OSCET30 — Migrações aplicadas SOBRE o schema.sql original
--
--  Estas correções foram necessárias para o painel admin funcionar com
--  a chave pública (anon/publishable) respeitando RLS. Rode TUDO isto no
--  SQL Editor do Supabase DEPOIS de schema.sql + seed_taxonomia.sql.
--
--  É idempotente (usa "drop policy if exists" / "if not exists"), então
--  pode ser rodado de novo sem erro.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. LEITURA da taxonomia (qualquer usuário autenticado)
--    Sem isto, os seletores de disciplina/período/conteúdo ficam vazios.
-- ---------------------------------------------------------------------
drop policy if exists "autenticados leem disciplinas" on disciplinas;
create policy "autenticados leem disciplinas" on disciplinas
  for select using (auth.role() = 'authenticated');

drop policy if exists "autenticados leem periodos" on periodos;
create policy "autenticados leem periodos" on periodos
  for select using (auth.role() = 'authenticated');

drop policy if exists "autenticados leem disciplina_periodo" on disciplina_periodo;
create policy "autenticados leem disciplina_periodo" on disciplina_periodo
  for select using (auth.role() = 'authenticated');

drop policy if exists "autenticados leem conteudos" on conteudos;
create policy "autenticados leem conteudos" on conteudos
  for select using (auth.role() = 'authenticated');

-- ---------------------------------------------------------------------
-- 2. usuarios_admin: cada usuário precisa ler a própria linha (para o app
--    descobrir o papel) e os nomes dos demais (autor/quem fez o quê).
-- ---------------------------------------------------------------------
drop policy if exists "autenticados leem usuarios_admin" on usuarios_admin;
create policy "autenticados leem usuarios_admin" on usuarios_admin
  for select using (auth.role() = 'authenticated');

-- ---------------------------------------------------------------------
-- 3. Vínculo N:N caso<->conteúdo (leitura + escrita por admin autenticado)
-- ---------------------------------------------------------------------
drop policy if exists "autenticados leem caso_conteudo" on caso_conteudo;
create policy "autenticados leem caso_conteudo" on caso_conteudo
  for select using (auth.role() = 'authenticated');

drop policy if exists "autenticados escrevem caso_conteudo" on caso_conteudo;
create policy "autenticados escrevem caso_conteudo" on caso_conteudo
  for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- ---------------------------------------------------------------------
-- 4. Banco de itens de checklist reutilizáveis (leitura + escrita)
-- ---------------------------------------------------------------------
drop policy if exists "autenticados leem checklist_base" on checklist_itens_base;
create policy "autenticados leem checklist_base" on checklist_itens_base
  for select using (auth.role() = 'authenticated');

drop policy if exists "autenticados escrevem checklist_base" on checklist_itens_base;
create policy "autenticados escrevem checklist_base" on checklist_itens_base
  for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- ---------------------------------------------------------------------
-- 5. Checklist do caso (leitura + escrita por admin autenticado)
-- ---------------------------------------------------------------------
drop policy if exists "autenticados leem checklist" on caso_checklist_itens;
create policy "autenticados leem checklist" on caso_checklist_itens
  for select using (auth.uid() in (select id from usuarios_admin where ativo));

drop policy if exists "autenticados escrevem checklist" on caso_checklist_itens;
create policy "autenticados escrevem checklist" on caso_checklist_itens
  for all using (auth.uid() in (select id from usuarios_admin where ativo))
  with check (auth.uid() in (select id from usuarios_admin where ativo));

-- ---------------------------------------------------------------------
-- 6. Histórico: leitura por admin + observação do revisor ao devolver
-- ---------------------------------------------------------------------
alter table casos_historico add column if not exists obs text;

drop policy if exists "autenticados leem historico" on casos_historico;
create policy "autenticados leem historico" on casos_historico
  for select using (auth.uid() in (select id from usuarios_admin where ativo));

drop policy if exists "owner_revisor insere comentario" on casos_historico;
create policy "owner_revisor insere comentario" on casos_historico
  for insert with check (
    usuario_id = auth.uid()
    and (select role from usuarios_admin where id = auth.uid()) in ('owner','revisor')
  );

-- ---------------------------------------------------------------------
-- 7. FK do histórico deferida: o trigger BEFORE INSERT em casos grava no
--    histórico antes do caso existir fisicamente; deferir a checagem para
--    o fim da transação evita a violação de FK ao criar um caso novo.
-- ---------------------------------------------------------------------
alter table casos_historico
  drop constraint if exists casos_historico_caso_id_fkey;
alter table casos_historico
  add constraint casos_historico_caso_id_fkey
    foreign key (caso_id) references casos(id) on delete cascade
    deferrable initially deferred;

-- ---------------------------------------------------------------------
-- 8. Apagar caso: só o owner pode apagar definitivamente (botão "Apagar"
--    no editor, ver CaseEditor.jsx). casos_historico não tinha policy de
--    delete nenhuma; casos também precisa de uma restrita ao owner.
-- ---------------------------------------------------------------------
drop policy if exists "owner apaga historico" on casos_historico;
create policy "owner apaga historico" on casos_historico
  for delete using (
    (select role from usuarios_admin where id = auth.uid()) = 'owner'
  );

drop policy if exists "owner apaga casos" on casos;
create policy "owner apaga casos" on casos
  for delete using (
    (select role from usuarios_admin where id = auth.uid()) = 'owner'
  );
