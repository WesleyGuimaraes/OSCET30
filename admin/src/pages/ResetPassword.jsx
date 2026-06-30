import { useState } from "react";
import { supabase } from "../supabaseClient.js";

export default function ResetPassword({ onConcluido }) {
  const [senha, setSenha] = useState("");
  const [confirmar, setConfirmar] = useState("");
  const [erro, setErro] = useState("");
  const [carregando, setCarregando] = useState(false);

  async function salvar(e) {
    e.preventDefault();
    setErro("");
    if (senha.length < 6) {
      setErro("A senha precisa ter pelo menos 6 caracteres.");
      return;
    }
    if (senha !== confirmar) {
      setErro("As senhas não coincidem.");
      return;
    }
    setCarregando(true);
    const { error } = await supabase.auth.updateUser({ password: senha });
    setCarregando(false);
    if (error) {
      setErro(error.message);
    } else {
      onConcluido();
    }
  }

  return (
    <div style={{ minHeight: "100vh", display: "grid", placeItems: "center", padding: 20 }}>
      <form onSubmit={salvar} className="card" style={{ width: 360, maxWidth: "100%" }}>
        <div style={{ display: "flex", alignItems: "center", gap: 9, fontSize: "1.15rem", fontWeight: 800, marginBottom: 6 }}>
          <span>🩺</span>
          <span>Próxima Estação</span>
          <span style={{ color: "var(--c-teal)", fontWeight: 500 }}>Painel</span>
        </div>
        <p style={{ margin: "0 0 20px", color: "var(--c-muted)", fontSize: "0.88rem" }}>
          Defina sua nova senha.
        </p>

        <div style={{ display: "flex", flexDirection: "column", gap: 6, marginBottom: 14 }}>
          <label className="label">Nova senha</label>
          <input
            className="input"
            type="password"
            autoComplete="new-password"
            required
            value={senha}
            onChange={(e) => setSenha(e.target.value)}
            placeholder="mínimo 6 caracteres"
          />
        </div>
        <div style={{ display: "flex", flexDirection: "column", gap: 6, marginBottom: 18 }}>
          <label className="label">Confirmar senha</label>
          <input
            className="input"
            type="password"
            autoComplete="new-password"
            required
            value={confirmar}
            onChange={(e) => setConfirmar(e.target.value)}
            placeholder="repita a senha"
          />
        </div>

        {erro && (
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
            {erro}
          </div>
        )}

        <button type="submit" className="btn btn-primary" disabled={carregando} style={{ width: "100%" }}>
          {carregando ? "Salvando…" : "Salvar nova senha"}
        </button>
      </form>
    </div>
  );
}
