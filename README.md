# OSCE Online — Pediatria

<!-- redeploy trigger: Vercel Web Analytics habilitado em 2026-06-19 -->

Versão web da skill de OSCE para treinar **em dupla**: uma pessoa é o
**paciente/avaliador** e a outra é o **estudante**. As duas entram na **mesma sala**
por um código, sem cadastro e sem servidor próprio — a conexão é direta entre os
navegadores via **WebRTC (PeerJS)**.

## Como jogar

1. **Paciente/avaliador** abre o site → **Criar sala** → escolhe um **modo** (abaixo).
   Aparece um **código** (ex.: `K4M7P`).
2. **Estudante** abre o mesmo site em outro computador → digita o código → **Entrar**.
3. Cada estação começa para os dois:
   - **Estudante** vê só as instruções (queixa + resumo) e conduz o atendimento
     **pessoalmente ou por chamada de voz à parte** (WhatsApp, Meet, etc.).
   - **Paciente/avaliador** vê o roteiro confidencial **ao lado do checklist**,
     controla o **timer** (5 min) e marca a avaliação.
4. **Encerrar e avaliar** mostra a pontuação da estação para ambos.
5. Os dois clicam em **"Estou pronto para a próxima"** — só então a próxima estação começa.
6. Ao final da sessão, aparece o **resumo** com a nota de cada estação e o total.

> A sessão **não tem chat de texto**: a comunicação do atendimento é por voz
> (pessoalmente ou por chamada). A conexão P2P sincroniza o caso, o timer e a
> avaliação entre os dois navegadores.

### De onde vêm os casos

As estações são carregadas em tempo real do **Supabase** (só as com status
**publicado**), geridas pelo painel administrativo (ver `admin/`). Enquanto não
houver casos publicados, os modos avisam que não há estações disponíveis.

### Alternar papéis

No setup há a opção **"Alternar papéis a cada estação"**: quando ligada, a cada
estação vocês trocam de lado (quem era avaliador vira estudante e vice-versa) —
ótimo no **modo infinito** para os dois praticarem os dois papéis.

### Testar conexão

No lobby há **"📶 Testar conexão nesta rede"**. Ele verifica se o servidor de
sinalização é alcançável e se a rede libera TURN. Redes de **faculdade/empresa**
costumam bloquear — se o teste acusar bloqueio, use o **4G/5G do celular** ou
outra rede. (Conexão entre dispositivos exige o site servido por **HTTPS**.)

### Modos (escolhidos por quem cria a sala)

| Modo | O que faz |
|---|---|
| 🎯 **Selecionar conteúdos** | Treina só estações das áreas marcadas (Respiratório, Febre, etc.) — sem revelar o texto da estação. |
| 🎲 **Aleatória** | Uma estação sorteada por vez, sem fim. O avaliador encerra quando quiser. |
| ♾️ **Modo infinito** | Todas as estações, em ordem aleatória e sem repetir, até acabarem. |
| 🏥 **Modo OSCE** | 4 estações aleatórias seguidas (como uma prova). |

> **Funciona entre dispositivos e redes diferentes** (celular + PC, Wi-Fi + dados móveis):
> usa servidores STUN + TURN públicos para atravessar o NAT. Em redes muito
> restritas (corporativas/escolares) o WebRTC ainda pode ser bloqueado.
>
> **Dica:** em vez de ditar o código, o avaliador pode enviar o **link de convite**
> (com o código embutido) — o estudante abre no celular e o código já vem preenchido.

## Publicar no GitHub Pages

1. Crie um repositório no GitHub e envie estes arquivos:
   `index.html`, `styles.css`, `app.js`, `db.js`, `README.md`.
   ```bash
   git init
   git add .
   git commit -m "OSCE Online"
   git branch -M main
   git remote add origin https://github.com/SEU_USUARIO/SEU_REPO.git
   git push -u origin main
   ```
2. No GitHub: **Settings → Pages → Source: branch `main` / pasta `/ (root)`** → **Save**.
3. Em ~1 min o site fica em `https://SEU_USUARIO.github.io/SEU_REPO/`.

## Adicionar/editar casos

Os casos agora vivem no **Supabase** e são geridos pelo **painel administrativo**
(pasta `admin/`) — criação, edição, revisão e publicação. O app de treino só
exibe casos com status **publicado**. O antigo `cases.js` permanece no repositório
apenas como **referência de formato** (não é mais carregado pelo app).

## Estrutura

| Arquivo | Função |
|---|---|
| `index.html` | telas (lobby, setup, estação, resultado) |
| `styles.css` | estilo |
| `js/` | jogo em módulos ES — `main` (entrada/UI), `session` (modos/fila), `station` (estação/timer/resultado), `connection` (P2P + reconexão), `store` (estado + casos), `config`, `util` |
| `db.js` | carrega os casos publicados do Supabase |
| `cases.js` | banco antigo — só referência de formato e fonte do gerador de migração (`admin/db/gen_migracao_pediatria.cjs`); **não vai para o deploy** nem é carregado pelo app |
| `admin/` | painel administrativo (React + Supabase) para gerenciar o banco de casos, ver `admin/README.md` |
| `vercel.json` | builda o painel admin e publica em `/admin/` dentro do mesmo projeto Vercel do jogo |

## Painel administrativo

A pasta [`admin/`](admin/) contém um painel web (React + Vite + Supabase) para
criar, editar, revisar e publicar casos com múltiplos editores, checklist
normalizado a 100 pontos e fluxo de revisão. Vive no **mesmo projeto Vercel**
do jogo: o `vercel.json` na raiz builda o admin e copia o resultado para
`/admin/` ao lado dos arquivos estáticos do jogo. Acesse pelo ícone ⚙️ no
canto superior do jogo, ou direto em `/admin/`. Instruções completas em
[`admin/README.md`](admin/README.md).
