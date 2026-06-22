/* Constantes de configuração da sessão e da conexão P2P. */

export const MODE_LABEL = {
  conteudos: "Conteúdos selecionados",
  aleatoria: "Aleatória",
  infinito: "Infinito",
  osce: "Modo OSCE",
};

// prefixo do ID no broker do PeerJS. Genérico (o app não é mais só de
// pediatria); host e guest usam a mesma constante, então mudar aqui basta.
export const PREFIX = "osce-";

// ICE servers: STUN (descobre IP público) + TURN (retransmite quando o NAT
// bloqueia a conexão direta — essencial entre redes/dados móveis diferentes).
export const PEER_OPTS = {
  config: {
    iceServers: [
      { urls: "stun:stun.l.google.com:19302" },
      { urls: "stun:stun1.l.google.com:19302" },
      {
        // TURN: retransmite quando o NAT/firewall bloqueia a conexão direta.
        // As variantes TCP e TLS na 443 ajudam em redes restritas (faculdade)
        // que só liberam tráfego web (HTTPS).
        urls: [
          "turn:openrelay.metered.ca:80",
          "turn:openrelay.metered.ca:80?transport=tcp",
          "turn:openrelay.metered.ca:443",
          "turn:openrelay.metered.ca:443?transport=tcp",
          "turns:openrelay.metered.ca:443?transport=tcp",
        ],
        username: "openrelayproject",
        credential: "openrelayproject",
      },
    ],
  },
};
