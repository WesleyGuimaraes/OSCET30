import { createClient } from "@supabase/supabase-js";

const url = import.meta.env.VITE_SUPABASE_URL;
const anonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!url || !anonKey) {
  // eslint-disable-next-line no-console
  console.error(
    "Variáveis VITE_SUPABASE_URL / VITE_SUPABASE_ANON_KEY não definidas. " +
      "Crie admin/.env.local (dev) ou configure-as no projeto da Vercel (produção)."
  );
}

// Proteção: a chave do front-end DEVE ser a publishable/anon, nunca a secret.
// O supabase-js bloqueia chaves sb_secret_ no navegador ("Forbidden use of
// secret API key in browser"); aqui damos uma mensagem mais clara e acionável.
if (anonKey && anonKey.startsWith("sb_secret_")) {
  const msg =
    "Chave SECRETA detectada no front-end (VITE_SUPABASE_ANON_KEY). Use a chave " +
    "publishable/anon (sb_publishable_… ou a anon key legada), nunca a secret. " +
    "Corrija no .env.local (dev) ou nas Environment Variables da Vercel (produção) e refaça o deploy.";
  // eslint-disable-next-line no-console
  console.error(msg);
  document.addEventListener("DOMContentLoaded", () => {
    const root = document.getElementById("root");
    if (root && !root.childElementCount) {
      root.innerHTML =
        '<div style="max-width:520px;margin:80px auto;padding:24px;border:1px solid #4a2424;' +
        'background:#2a1a1a;color:#e6edf3;border-radius:14px;font-family:system-ui,sans-serif;line-height:1.5">' +
        "<strong>Configuração inválida</strong><br><br>" +
        msg +
        "</div>";
    }
  });
}

export const supabase = createClient(url, anonKey);
