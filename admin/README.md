# OSCE T30 — Painel Admin

Painel administrativo para gerenciar o banco de estações do OSCET30 (criar, editar,
revisar e publicar casos). React + Vite, autenticação e dados via Supabase.

## Telas

- **Visão geral** — contadores por status e progresso de produção por conteúdo
  (meta de ~10 casos por conteúdo), para coordenar o trabalho entre colegas.
- **Casos** — lista filtrável (disciplina, período, conteúdo, status, autor) +
  ações de preview, histórico e duplicar.
- **Editor** — formulário completo do caso, conteúdos (N:N, com principal) e
  checklist com peso normalizado a 100 em tempo real. Avisa sobre alterações não
  salvas ao sair.
- **Preview** — visão do estudante x avaliador (roteiro e checklist lado a lado).
- **Fila de revisão** — publicar / devolver com observação (owner/revisor).
- **Histórico** — linha do tempo de cada caso.

## Banco de dados (Supabase)

Rode, no SQL Editor, nesta ordem:

1. `../<bundle>/schema.sql` — schema base (tabelas, view, triggers, RLS).
2. `../<bundle>/seed_taxonomia.sql` — disciplinas, períodos e conteúdos.
3. **`db/migrations.sql`** (neste projeto) — políticas RLS e ajustes adicionais
   que o painel precisa. É idempotente; pode rodar de novo sem erro.
4. **`db/seed_checklist_base.sql`** (opcional, recomendado) — popula o banco de
   itens de checklist reutilizáveis (botão "Banco de itens" no editor).

Depois, crie seu usuário em **Authentication → Users** (marque *Auto Confirm*),
e cadastre-o como owner:

```sql
insert into usuarios_admin (id, nome, email, role)
values ('<UID-do-auth>', 'Seu Nome', 'seu-email@exemplo.com', 'owner');
```

## Setup local

```bash
cd admin
npm install
cp .env.example .env.local   # preencha URL + publishable/anon key (Settings → API)
npm run dev
```

> A **secret key** (`sb_secret_…`) NUNCA vai no front-end — só a publishable/anon.

## Deploy na Vercel

Este projeto vive numa subpasta (`admin/`), então é um **segundo projeto Vercel**
separado do site de treino:

1. Vercel → **Add New → Project** → repositório `OSCET30`.
2. **Root Directory**: `admin`.
3. Framework preset: **Vite** (auto-detectado).
4. **Environment Variables**: `VITE_SUPABASE_URL` e `VITE_SUPABASE_ANON_KEY`.
5. Deploy.
6. No Supabase, em **Authentication → URL Configuration**, adicione a URL do deploy
   em **Redirect URLs** (necessário para o fluxo de "esqueci minha senha").

## Acesso

Login via Supabase Auth (e-mail/senha) + "esqueci minha senha". O papel exibido
(owner/revisor/editor) vem da tabela `usuarios_admin` — sem seletor manual; é sempre
o papel real de quem está logado, respeitando a RLS.
