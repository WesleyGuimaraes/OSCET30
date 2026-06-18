# OSCE Online — Pediatria

Versão web da skill de OSCE para treinar **em dupla**: uma pessoa é o
**paciente/avaliador** e a outra é o **estudante**. As duas entram na **mesma sala**
por um código, sem cadastro e sem servidor próprio — a conexão é direta entre os
navegadores via **WebRTC (PeerJS)**.

## Como jogar

1. **Paciente/avaliador** abre o site → **Criar sala** → escolhe um **modo** (abaixo).
   Aparece um **código** (ex.: `K4M7P`).
2. **Estudante** abre o mesmo site em outro computador → digita o código → **Entrar**.
3. Cada estação começa para os dois:
   - **Estudante** vê só as instruções e conduz o atendimento pelo chat.
   - **Paciente/avaliador** vê o roteiro confidencial, controla o **timer** (5 min) e marca o **checklist**.
4. **Encerrar e avaliar** mostra a pontuação da estação para ambos.
5. Os dois clicam em **"Estou pronto para a próxima"** — só então a próxima estação começa.
6. Ao final da sessão, aparece o **resumo** com a nota de cada estação e o total.

### Distância vs. presencial

Ao criar a sala, quem é paciente/avaliador escolhe:

- **💬 À distância** — mantém o **chat** para a conversa do atendimento.
- **🤝 No mesmo local** — **remove o chat** da tela (vocês conversam pessoalmente).
  Nesse modo o **checklist** do avaliador fica **ao lado do caso clínico**, e o
  estudante vê só as instruções em tela cheia. A escolha vale para os dois.

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
   `index.html`, `styles.css`, `app.js`, `cases.js`, `README.md`.
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

Edite `cases.js`. Cada caso tem: `resumo` (o que o estudante vê), `paciente`
(roteiro confidencial + achados de exame) e `checklist` (itens com peso em pontos).

## Estrutura

| Arquivo | Função |
|---|---|
| `index.html` | telas (lobby, setup, estação, resultado) |
| `styles.css` | estilo |
| `app.js` | conexão P2P, papéis, timer, chat e avaliação |
| `cases.js` | banco de estações de pediatria |
