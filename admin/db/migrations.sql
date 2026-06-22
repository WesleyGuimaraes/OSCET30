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
-- leitura por admin ativo (o público lê só de casos publicados, via
-- migrations_app_publico.sql — policy separada, OR-combinada)
drop policy if exists "autenticados leem caso_conteudo" on caso_conteudo;
create policy "autenticados leem caso_conteudo" on caso_conteudo
  for select using (auth.uid() in (select id from usuarios_admin where ativo));

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

-- ---------------------------------------------------------------------
-- 9. Endurecimento de segurança (auditoria de RLS):
--
--    9a. meu_role() é SECURITY DEFINER sem search_path travado — vetor
--        clássico de escalonamento de privilégio no Postgres (um usuário
--        podia manipular o search_path da sessão para a função resolver
--        uma tabela 'usuarios_admin' forjada e mentir o próprio papel).
--        Travamos search_path = '' e qualificamos a referência.
--
--    9b/9c. As tabelas-filhas (caso_conteudo, caso_checklist_itens) tinham
--        escrita frouxa: caso_conteudo liberava QUALQUER autenticado, e
--        nenhuma das duas protegia casos já publicados — então um 'editor'
--        que (corretamente) não pode editar um caso publicado pela tabela
--        casos conseguia alterar o checklist/conteúdos dele direto na filha,
--        furando a regra de publicação. Agora espelham a regra do pai:
--        owner/revisor mexem em qualquer status; editor só em rascunho/
--        em_revisao.
-- ---------------------------------------------------------------------

-- 9a. meu_role() com search_path travado e referência qualificada.
create or replace function public.meu_role()
returns admin_role
language sql
stable security definer
set search_path = ''
as $function$
  select role from public.usuarios_admin where id = auth.uid() and ativo;
$function$;

-- 9b. caso_conteudo: escrita só para quem pode editar o caso pai.
drop policy if exists "autenticados escrevem caso_conteudo" on caso_conteudo;
drop policy if exists "admin escreve caso_conteudo" on caso_conteudo;
create policy "admin escreve caso_conteudo" on caso_conteudo
  for all
  using (
    exists (
      select 1 from casos c
      where c.id = caso_conteudo.caso_id
        and (
          meu_role() = any (array['owner'::admin_role, 'revisor'::admin_role])
          or (meu_role() = 'editor'::admin_role
              and c.status = any (array['rascunho'::caso_status, 'em_revisao'::caso_status]))
        )
    )
  )
  with check (
    exists (
      select 1 from casos c
      where c.id = caso_conteudo.caso_id
        and (
          meu_role() = any (array['owner'::admin_role, 'revisor'::admin_role])
          or (meu_role() = 'editor'::admin_role
              and c.status = any (array['rascunho'::caso_status, 'em_revisao'::caso_status]))
        )
    )
  );

-- 9c. caso_checklist_itens: mesma proteção de caso publicado.
drop policy if exists "autenticados escrevem checklist" on caso_checklist_itens;
drop policy if exists "admin escreve checklist" on caso_checklist_itens;
create policy "admin escreve checklist" on caso_checklist_itens
  for all
  using (
    exists (
      select 1 from casos c
      where c.id = caso_checklist_itens.caso_id
        and (
          meu_role() = any (array['owner'::admin_role, 'revisor'::admin_role])
          or (meu_role() = 'editor'::admin_role
              and c.status = any (array['rascunho'::caso_status, 'em_revisao'::caso_status]))
        )
    )
  )
  with check (
    exists (
      select 1 from casos c
      where c.id = caso_checklist_itens.caso_id
        and (
          meu_role() = any (array['owner'::admin_role, 'revisor'::admin_role])
          or (meu_role() = 'editor'::admin_role
              and c.status = any (array['rascunho'::caso_status, 'em_revisao'::caso_status]))
        )
    )
  );
