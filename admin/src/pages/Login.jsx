import { useState } from "react";
import { supabase } from "../supabaseClient.js";

const CardShell = ({ children }) => (
  <div style={{ minHeight: "100vh", display: "grid", placeItems: "center", padding: 20 }}>
    <div className="card" style={{ width: 360, maxWidth: "100%" }}>
      <div style={{ display: "flex", alignItems: "center", gap: 9, fontSize: "1.15rem", fontWeight: 800, marginBottom: 6 }}>
        <span>🩺</span>
        <span>OSCE T30</span>
        <span style={{ color: "var(--c-teal)", fontWeight: 500 }}>Painel</span>
      </div>
      {children}
    </div>
  </div>
);

const ErroBox = ({ children }) => (
  <div
    style={{
      marginBottom: 14,
      padding: "10px 14px",
      background: "var(--c-bad-fill)",
      border: "1px solid #4a2424",
      borderRadius: 10,
      color: "var(--c-danger)",
      fontSize: "0.85rem",
    }}
  >
    {children}
  </div>
);

const OkBox = ({ children }) => (
  <div
    style={{
      marginBottom: 14,
      padding: "10px 14px",
      background: "var(--c-ok-fill)",
      border: "1px solid #244a39",
      borderRadius: 10,
      color: "var(--c-good)",
      fontSize: "0.85rem",
    }}
  >
    {children}
  </div>
);

export default function Login() {
  const [modo, setModo] = useState("login"); // "login" | "esqueci"
  const [email, setEmail] = useState("");
  const [senha, setSenha] = useState("");
  const [erro, setErro] = useState("");
  const [ok, setOk] = useState("");
  const [carregando, setCarregando] = useState(false);

  async function entrar(e) {
    e.preventDefault();
    setErro("");
    setCarregando(true);
    const { error } = await supabase.auth.signInWithPassword({ email, password: senha });
    setCarregando(false);
    if (error) {
      setErro(error.message === "Invalid login credentials" ? "E-mail ou senha incorretos." : error.message);
    }
    // sucesso: o App ouve onAuthStateChange e troca de tela sozinho
  }

  async function enviarRecuperacao(e) {
    e.preventDefault();
    setErro("");
    setOk("");
    setCarregando(true);
    const { error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: window.location.origin,
    });
    setCarregando(false);
    if (error) {
      setErro(error.message);
    } else {
      setOk("Link enviado! Confira seu e-mail (e a caixa de spam) e clique no link para definir uma nova senha.");
    }
  }

  if (modo === "esqueci") {
    return (
      <CardShell>
        <p style={{ margin: "0 0 20px", color: "var(--c-muted)", fontSize: "0.88rem" }}>
          Informe seu e-mail para receber um link de redefinição de senha.
        </p>
        <form onSubmit={enviarRecuperacao}>
          <div style={{ display: "flex", flexDirection: "column", gap: 6, marginBottom: 18 }}>
            <label className="label">E-mail</label>
            <input
              className="input"
              type="email"
              autoComplete="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="seu-email@exemplo.com"
            />
          </div>

          {erro && <ErroBox>{erro}</ErroBox>}
          {ok && <OkBox>{ok}</OkBox>}

          <button type="submit" className="btn btn-primary" disabled={carregando} style={{ width: "100%", marginBottom: 10 }}>
            {carregando ? "Enviando…" : "Enviar link de recuperação"}
          </button>
          <button
            type="button"
            className="btn btn-ghost"
            style={{ width: "100%" }}
            onClick={() => {
              setModo("login");
              setErro("");
              setOk("");
            }}
          >
            ← Voltar para o login
          </button>
        </form>
      </CardShell>
    );
  }

  return (
    <CardShell>
      <p style={{ margin: "0 0 20px", color: "var(--c-muted)", fontSize: "0.88rem" }}>
        Entre com sua conta de editor/revisor/owner.
      </p>
      <form onSubmit={entrar}>
        <div style={{ display: "flex", flexDirection: "column", gap: 6, marginBottom: 14 }}>
          <label className="label">E-mail</label>
          <input
            className="input"
            type="email"
            autoComplete="email"
            required
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="seu-email@exemplo.com"
          />
        </div>
        <div style={{ display: "flex", flexDirection: "column", gap: 6, marginBottom: 8 }}>
          <label className="label">Senha</label>
          <input
            className="input"
            type="password"
            autoComplete="current-password"
            required
            value={senha}
            onChange={(e) => setSenha(e.target.value)}
            placeholder="••••••••"
          />
        </div>
        <div style={{ textAlign: "right", marginBottom: 18 }}>
          <button
            type="button"
            onClick={() => {
              setModo("esqueci");
              setErro("");
              setOk("");
            }}
            style={{ background: "none", border: "none", color: "var(--c-teal)", fontSize: "0.82rem", cursor: "pointer", padding: 0 }}
          >
            Esqueci minha senha
          </button>
        </div>

        {erro && <ErroBox>{erro}</ErroBox>}

        <button type="submit" className="btn btn-primary" disabled={carregando} style={{ width: "100%" }}>
          {carregando ? "Entrando…" : "Entrar"}
        </button>
      </form>
    </CardShell>
  );
}
