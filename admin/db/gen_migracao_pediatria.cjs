// Script de uso único: le cases.js (formato antigo) e gera os arquivos SQL
// de migracao para o Supabase (status = 'em_revisao'), agrupados por area
// de conteudo. Nao roda em produção; roda local com `node gen_migracao_pediatria.js`.

const fs = require("fs");
const path = require("path");

const CASES_PATH = path.join(__dirname, "..", "..", "cases.js");
const OUT_DIR = __dirname;

const raw = fs.readFileSync(CASES_PATH, "utf8");
const start = raw.indexOf("window.OSCE_CASES = ") + "window.OSCE_CASES = ".length;
const arrayLiteral = raw.slice(start).trim().replace(/;\s*$/, "");
// eslint-disable-next-line no-eval
const CASES = (0, eval)(arrayLiteral);

const DISCIPLINA_PERIODO_PEDIATRIA = "d5403a68-35f9-4e19-9fe8-edc1c0a80c90";

// tag (cases.js) -> { principal: slug, extra?: slug } | function(caso) -> {...}
const ALIM_PRIMEIRO_ANO_IDS = new Set([
  "alim-introducao",
  "alim-erros-comuns",
  "alim-progressao-consistencia",
  "alim-neofobia",
  "alim-mel-acucar",
  "alim-risco-engasgo",
  "alim-volumes-refeicoes",
  "alim-sinais-prontidao-6m",
  "alim-progressao-8-9m",
  "alim-alimentos-proibidos-idade",
  "alim-neofobia-recusa",
]);

const TAG_MAP = {
  "Desenvolvimento": { arquivo: "dev", principal: "marcos-desenvolvimento-infantil" },
  "Exame do RN": { arquivo: "examern", principal: "exame-fisico-recem-nascido" },
  "Icterícia neonatal": { arquivo: "ictericia", principal: "ictericia-neonatal" },
  "Maus-tratos": { arquivo: "maustratos", principal: "maus-tratos-na-infancia" },
  "Síndrome nefrítica": { arquivo: "nefritica", principal: "sindrome-nefritica-nefrotica" },
  "Distúrbios funcionais": { arquivo: "funcionais", principal: "disturbios-funcionais" },
  "Uso de telas": { arquivo: "telas", principal: "uso-abusivo-de-telas" },
  "IVAS": { arquivo: "ivas", principal: "ivas" },
  "Asma": { arquivo: "asma", principal: "asma" },
  "Alimentação infantil": {
    arquivo: "alimentacao",
    principal: "alimentacao-infantil",
    extra: (caso) =>
      ALIM_PRIMEIRO_ANO_IDS.has(caso.id) ? "alimentacao-primeiro-ano-vida" : "aleitamento-materno",
  },
  "APLV": { arquivo: "aplv", principal: "alergia-alimentar-aplv" },
};

function dq(tag, text) {
  if (text == null) return "null";
  return `$${tag}$${text}$${tag}$`;
}

function sqlBlock(caso, idx) {
  const tagInfo = TAG_MAP[caso.conteudos[0]];
  if (!tagInfo) throw new Error(`Sem mapeamento para tag "${caso.conteudos[0]}" (caso ${caso.id})`);

  const slugs = [tagInfo.principal];
  if (tagInfo.extra) slugs.push(typeof tagInfo.extra === "function" ? tagInfo.extra(caso) : tagInfo.extra);

  const roteiroItens = caso.paciente.roteiro
    .map((linha) => `      ${dq("r" + idx, linha)}`)
    .join(",\n");

  const checklistItens = caso.checklist
    .map((it, i) => `  (${dq("i" + idx + "_" + i, it.item)}, ${it.peso}, ${i})`)
    .join(",\n");

  const slugsList = slugs.map((s) => `'${s}'`).join(", ");
  const principalSlug = tagInfo.principal;

  return `with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    ${dq("t" + idx, caso.titulo)},
    ${dq("e" + idx, caso.especialidade)},
    null,
    ${caso.tempo},
    ${dq("q" + idx, caso.queixaPrincipal)},
    ${dq("res" + idx, caso.resumo.trim())},
    ${dq("p" + idx, caso.paciente.personagem)},
    ${dq("ctx" + idx, caso.paciente.contexto)},
    jsonb_build_array(
${roteiroItens}
    ),
    ${dq("ach" + idx, caso.paciente.examesAchados)},
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = '${principalSlug}')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = '${DISCIPLINA_PERIODO_PEDIATRIA}'
   and c.slug in (${slugsList})
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
${checklistItens}
) as v(texto, grav, ord);`;
}

const porArquivo = {};
CASES.forEach((caso, idx) => {
  const tagInfo = TAG_MAP[caso.conteudos[0]];
  if (!tagInfo) {
    console.error(`AVISO: sem mapeamento para "${caso.conteudos[0]}" (${caso.id}) — pulado`);
    return;
  }
  const bloco = sqlBlock(caso, idx);
  porArquivo[tagInfo.arquivo] = porArquivo[tagInfo.arquivo] || [];
  porArquivo[tagInfo.arquivo].push(bloco);
});

let total = 0;
for (const [nome, blocos] of Object.entries(porArquivo)) {
  const file = path.join(OUT_DIR, `casos_pediatria_${nome}.sql`);
  fs.writeFileSync(
    file,
    `-- Migracao automatica de cases.js -> Supabase (status em_revisao).\n-- Gerado por gen_migracao_pediatria.js. Rodar DEPOIS de migracao_taxonomia_pediatria.sql.\n\n` +
      blocos.join("\n\n") +
      "\n"
  );
  console.log(`${file} — ${blocos.length} casos`);
  total += blocos.length;
}
console.log(`Total: ${total} casos de ${CASES.length} no arquivo de origem.`);
