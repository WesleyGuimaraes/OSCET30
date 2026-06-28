import { useEffect, useState } from "react";
import { supabase } from "./supabaseClient.js";
import { duplicarCaso, fetchCasos, fetchTaxonomia } from "./lib/data.js";
import Login from "./pages/Login.jsx";
import ResetPassword from "./pages/ResetPassword.jsx";
import Lista from "./pages/Lista.jsx";
import CaseEditor from "./pages/CaseEditor.jsx";
import Preview from "./pages/Preview.jsx";
import Fila from "./pages/Fila.jsx";
import Historico from "./pages/Historico.jsx";
import Dashboard from "./pages/Dashboard.jsx";
import Topbar from "./components/Topbar.jsx";

export default function App() {
  const [session, setSession] = useState(undefined); // undefined = ainda checando
  const [admin, setAdmin] = useState(null); // linha de usuarios_admin (nome, role)
  const [adminErro, setAdminErro] = useState("");
  const [recuperandoSenha, setRecuperandoSenha] = useState(false);

  const [screen, setScreen] = useState("dashboard");
  const [casoSelecionado, setCasoSelecionado] = useState(null); // id ou null (novo)
  const [filtroConteudoId, setFiltroConteudoId] = useState(""); // pré-filtro vindo do dashboard
  const [previewCasoId, setPreviewCasoId] = useState(null);
  const [previewFrom, setPreviewFrom] = useState("lista");
  const [histCasoId, setHistCasoId] = useState(null);
  const [histFrom, setHistFrom] = useState("lista");
  const [casos, setCasos] = useState([]);
  const [taxonomia, setTaxonomia] = useState([]);
  const [carregandoDados, setCarregandoDados] = useState(false);
  const [erroDados, setErroDados] = useState("");

  useEffect(() => {
    supabase.auth.getSession().then(({ data }) => setSession(data.session));
    const { data: sub } = supabase.auth.onAuthStateChange((event, s) => {
      if (event === "PASSWORD_RECOVERY") setRecuperandoSenha(true);
      setSession(s);
    });
    return () => sub.subscription.unsubscribe();
  }, []);

  useEffect(() => {
    if (!session) {
      setAdmin(null);
      return;
    }
    let ativo = true;
    supabase
      .from("usuarios_admin")
      .select("id, nome, email, role, ativo")
      .eq("id", session.user.id)
      .single()
      .then(({ data, error }) => {
        if (!ativo) return;
        if (error || !data || !data.ativo) {
          setAdminErro(
            "Sua conta entrou, mas não está cadastrada como editora do painel " +
              "(tabela usuarios_admin). Peça ao owner para te cadastrar."
          );
          setAdmin(null);
        } else {
          setAdmin(data);
          setAdminErro("");
        }
      });
    return () => {
      ativo = false;
    };
  }, [session]);

  async function recarregarDados() {
    setCarregandoDados(true);
    setErroDados("");
    try {
      const [c, t] = await Promise.all([fetchCasos(), fetchTaxonomia()]);
      setCasos(c);
      setTaxonomia(t);
    } catch (err) {
      setErroDados(err.message || "Erro ao carregar dados do Supabase.");
    } finally {
      setCarregandoDados(false);
    }
  }

  useEffect(() => {
    if (admin) recarregarDados();
  }, [admin]);

  if (session === undefined) {
    return (
      <div style={{ minHeight: "100vh", display: "grid", placeItems: "center", color: "var(--c-muted)" }}>
        Carregando…
      </div>
    );
  }

  if (recuperandoSenha) {
    return (
      <ResetPassword
        onConcluido={() => {
          setRecuperandoSenha(false);
        }}
      />
    );
  }

  if (!session) return <Login />;

  if (adminErro) {
    return (
      <div style={{ minHeight: "100vh", display: "grid", placeItems: "center", padding: 20 }}>
        <div className="card" style={{ maxWidth: 440 }}>
          <p style={{ margin: "0 0 16px", lineHeight: 1.5 }}>{adminErro}</p>
          <button className="btn btn-ghost" onClick={() => supabase.auth.signOut()}>
            Sair
          </button>
        </div>
      </div>
    );
  }

  if (!admin) {
    return (
      <div style={{ minHeight: "100vh", display: "grid", placeItems: "center", color: "var(--c-muted)" }}>
        Carregando…
      </div>
    );
  }

  const filaCount = casos.filter((c) => c.status === "em_revisao").length;

  return (
    <div style={{ minHeight: "100vh" }}>
      <Topbar
        screen={screen}
        onGoDashboard={() => setScreen("dashboard")}
        onGoCasos={() => {
          setFiltroConteudoId("");
          setScreen("lista");
        }}
        onGoFila={() => setScreen("fila")}
        filaCount={filaCount}
        admin={admin}
      />

      {erroDados && (
        <div style={{ maxWidth: 1180, margin: "16px auto 0", padding: "0 28px" }}>
          <div
            style={{
              padding: "10px 14px",
              background: "var(--c-bad-fill)",
              border: "1px solid #4a2424",
              borderRadius: 10,
              color: "var(--c-danger)",
              fontSize: "0.88rem",
            }}
          >
            Erro ao carregar dados: {erroDados}
          </div>
        </div>
      )}

      {carregandoDados && casos.length === 0 ? (
        <div style={{ padding: 48, textAlign: "center", color: "var(--c-muted)" }}>Carregando casos…</div>
      ) : screen === "dashboard" ? (
        <Dashboard
          casos={casos}
          taxonomia={taxonomia}
          onIrParaConteudo={(ct) => {
            setFiltroConteudoId(ct.id);
            setScreen("lista");
          }}
          onNovoCaso={() => {
            setCasoSelecionado(null);
            setScreen("editor");
          }}
        />
      ) : screen === "lista" ? (
        <Lista
          casos={casos}
          taxonomia={taxonomia}
          filtroConteudoId={filtroConteudoId}
          onNovoCaso={() => {
            setCasoSelecionado(null);
            setScreen("editor");
          }}
          onOpenCaso={(id) => {
            setCasoSelecionado(id);
            setScreen("editor");
          }}
          onPreview={(id) => {
            setPreviewCasoId(id);
            setPreviewFrom("lista");
            setScreen("preview");
          }}
          onHist={(id) => {
            setHistCasoId(id);
            setHistFrom("lista");
            setScreen("historico");
          }}
          onDuplicar={async (id) => {
            try {
              const novoId = await duplicarCaso(id, admin.id);
              await recarregarDados();
              setCasoSelecionado(novoId);
              setScreen("editor");
            } catch (err) {
              setErroDados(err.message || "Erro ao duplicar caso.");
            }
          }}
        />
      ) : screen === "editor" ? (
        <CaseEditor
          casoId={casoSelecionado}
          admin={admin}
          taxonomia={taxonomia}
          onBack={() => setScreen("lista")}
          onSalvo={recarregarDados}
          onPreview={(id) => {
            setPreviewCasoId(id);
            setPreviewFrom("editor");
            setScreen("preview");
          }}
          onHist={(id) => {
            setHistCasoId(id);
            setHistFrom("editor");
            setScreen("historico");
          }}
        />
      ) : screen === "preview" ? (
        <Preview
          casoId={previewCasoId}
          admin={admin}
          onBack={() => setScreen(previewFrom)}
          onRecarregar={recarregarDados}
        />
      ) : screen === "fila" ? (
        <Fila
          casosEmRevisao={casos.filter((c) => c.status === "em_revisao")}
          admin={admin}
          onRecarregar={recarregarDados}
          onPreview={(id) => {
            setPreviewCasoId(id);
            setPreviewFrom("fila");
            setScreen("preview");
          }}
        />
      ) : screen === "historico" ? (
        <Historico
          casoId={histCasoId}
          casoTitulo={casos.find((c) => c.id === histCasoId)?.titulo || "(sem título)"}
          onBack={() => setScreen(histFrom)}
        />
      ) : (
        <div style={{ padding: 48, textAlign: "center", color: "var(--c-muted)" }}>Tela desconhecida.</div>
      )}
    </div>
  );
}
