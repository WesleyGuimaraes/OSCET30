/* Constantes da sessão e do transporte (Supabase Realtime). */

export const MODE_LABEL = {
  conteudos: "Conteúdos selecionados",
  infinito: "Infinito",
};

// prefixo do nome do canal de Realtime; host e guest usam a mesma sala
// ("sala-CÓDIGO"). Genérico (o app não é mais só de pediatria).
export const SALA_PREFIX = "sala-";

// Supabase: a sessão do jogo trafega por um canal de Realtime (Broadcast +
// Presence) em vez de WebRTC — passa pelo mesmo WebSocket/HTTPS que já carrega
// os casos, então funciona em redes restritas (faculdade) sem STUN/TURN.
// Chave PUBLISHABLE/anon (pública por design; a RLS é quem protege os dados).
export const SUPABASE_URL = "https://goykvxbtabrheakybgvd.supabase.co";
export const SUPABASE_ANON_KEY = "sb_publishable_JLPOZYZjs6aqVa3eZF_e_w_sw6w5SRl";
