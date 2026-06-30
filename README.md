# Próxima Estação

App web para treinar **estações de OSCE em dupla**: uma pessoa é o
**paciente/avaliador** e a outra é o **estudante**. As duas entram na **mesma sala**
por um código, **sem cadastro** — o caso, o cronômetro e a avaliação são
sincronizados em tempo real via **Supabase Realtime** (Broadcast + Presence).

> Por que Realtime e não WebRTC: o canal passa pelo mesmo HTTPS/WebSocket (porta 443)
> que já carrega os casos, então funciona em **redes restritas** (faculdade/empresa)
> sem depender de STUN/TURN.

## Como funciona

1. **Paciente/avaliador** abre o site → **Configurar treino**: escolhe o **modo**, os
   **conteúdos** e o **tempo** por estação → **Iniciar treino**. Aparece um **código**
   (ex.: `K4M7P`) e um **link de convite** com o código já embutido.
2. **Estudante** abre o mesmo site em outro aparelho → digita o código (ou abre o link)
   → **Entrar**.
3. Cada estação começa para os dois:
   - **Estudante** vê só as instruções (queixa + resumo) e conduz o atendimento
     **pessoalmente ou por chamada de voz à parte** (WhatsApp, Meet, etc.).
   - **Paciente/avaliador** vê o **roteiro confidencial ao lado do checklist**,
     controla o **cronômetro** e marca a avaliação.
4. **Encerrar e avaliar** mostra a pontuação da estação para os dois.
5. Os dois clicam em **"Estou pronto para a próxima"** — só então a próxima estação começa.
6. Ao final, aparece o **resumo** com a nota de cada estação e o total.

> Não há chat de texto: a conversa do atendimento é por voz. O canal de Realtime só
> sincroniza o caso, o cronômetro e a avaliação entre os dois navegadores.

### Modos (escolhidos por quem cria a sala)

| Modo | O que faz |
|---|---|
| 🎯 **Conteúdos selecionados** | Treina só estações das áreas marcadas (Respiratório, Febre, etc.). |
| ♾️ **Infinito** | Todas as estações, em ordem aleatória e sem repetir, até acabarem. |

### Testar conexão

Na tela de configuração há **"Testar conexão nesta rede"**. Ele verifica se o
servidor de Realtime do Supabase é alcançável. Se a rede bloquear, use **4G/5G** ou
outra rede. (A conexão entre dispositivos exige o site servido por **HTTPS**.)

### De onde vêm os casos

As estações são carregadas em tempo real do **Supabase** — apenas as com status
**publicado** — geridas pelo **painel administrativo** (pasta [`admin/`](admin/)).
Enquanto não houver casos publicados, a tela de configuração avisa que não há
estações disponíveis.

## Estrutura

| Caminho | Função |
|---|---|
| `index.html` | landing page (marketing) → aponta para `/app` e `/admin/` |
| `app.html` | o jogo (telas: configurar, estação, resultado, resumo) |
| `styles.css` | estilo do jogo |
| `js/` | jogo em módulos ES — `main` (entrada/UI), `session` (modos/fila), `station` (estação/timer/resultado), `connection` (Supabase Realtime), `store` (estado + casos), `config`, `util` |
| `db.js` | carrega os casos **publicados** do Supabase (expõe `window.loadOsceCases()`) |
| `admin/` | painel administrativo (React + Vite + Supabase) — gestão do banco de casos |
| `vercel.json` | builda o admin e publica jogo + admin no **mesmo projeto Vercel** |

## Deploy (Vercel)

Um **único projeto Vercel** hospeda o jogo (na raiz) e o admin (em `/admin/`):

- `installCommand` instala as dependências do admin.
- `buildCommand` copia os estáticos do jogo (`*.html`, `*.css`, `*.js`, `js/`) para
  `public_combined/`, builda o admin (Vite) e copia o `dist` para `public_combined/admin/`.
- `outputDirectory` é `public_combined/` (regenerado a cada build — **não versionar**).
- Headers de segurança (CSP, HSTS, nosniff, frame DENY, Permissions-Policy) e
  cache imutável dos assets do admin vêm do `vercel.json`.

**Variáveis de ambiente** (Vercel → Project → Settings → Environment Variables),
usadas pelo build do admin:

```
VITE_SUPABASE_URL=https://SEU-PROJETO.supabase.co
VITE_SUPABASE_ANON_KEY=sua-chave-publishable-ou-anon
```

> A chave do front-end é sempre a **publishable/anon** (pública por design). Quem
> protege os dados é a **RLS** no Supabase. Nunca use a chave `sb_secret_` no front.

## Painel administrativo

A pasta [`admin/`](admin/) é um painel web (React + Vite + Supabase) para criar,
editar, revisar e publicar casos, com múltiplos editores, checklist normalizado a
100 pontos e fluxo de revisão (rascunho → em revisão → publicado). Acesse pelo
ícone ⚙️ no jogo ou direto em `/admin/`. Detalhes em [`admin/README.md`](admin/README.md).

## Banco de dados

Postgres no Supabase com taxonomia disciplina → período → conteúdo, checklist
reutilizável e RLS por papel (owner/revisor/editor) + leitura pública restrita a
casos publicados. Migrações em [`admin/db/`](admin/db/).
