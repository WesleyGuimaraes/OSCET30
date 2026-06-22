# Pipeline de autoria de casos (Claude → revisor)

Fluxo para o Claude gerar novas estações de OSCE a partir de material-fonte e
entregá-las **prontas para revisão** no painel, sem ninguém precisar digitar
caso a caso.

## Como funciona

1. **Uma vez:** o Wesley define o "esqueleto" (formato + regras de estilo) — fica
   na seção [Esqueleto / preferências](#esqueleto--preferências) abaixo.
2. **A cada lote:** o Wesley manda o conteúdo (PDF, resumo, tema, nº de casos).
   O Claude escreve os casos e gera um arquivo `db/casos_<tema>.sql`.
3. O Wesley **cola esse SQL no SQL Editor do Supabase** e roda (uma vez).
4. Os casos entram com status **`em_revisao`** e aparecem na **Fila de revisão**
   do painel. O revisor (owner/revisor) publica ou devolve com observação.

> Os casos nascem em revisão de propósito — nada vai ao ar sem um revisor humano.

## Estrutura de um caso (campos)

| Campo | O que é |
|---|---|
| `titulo` | nome curto e clínico da estação |
| `especialidade` | texto livre exibido na estação (ex.: "Pediatria") |
| `subtipo` | variação clínica dentro do conteúdo (opcional) |
| `tempo_segundos` | duração (padrão 300 = 5 min) |
| `queixa_principal` | 1 linha curta que orienta o caso |
| `resumo` | instruções que o ESTUDANTE lê |
| `personagem` | quem o ator/paciente interpreta |
| `contexto` | tom/atitude do ator |
| `roteiro` | lista de falas/fatos que o ator revela quando perguntado |
| `exames_achados` | achados de exame/complementares liberados sob solicitação |
| conteúdos | 1+ conteúdos da taxonomia (1 marcado como principal) |
| checklist | itens avaliados, cada um com **gravidade 1–5** (o peso em pontos é calculado e normalizado a 100 automaticamente) |

## Regras de conteúdo

- **Fidelidade ao material-fonte**: não inventar doses/condutas/classificações que
  não estejam no material enviado, salvo quando o Wesley pedir conteúdo atualizado.
- Checklist por **gravidade (1–5)**, não por pontos — o sistema normaliza a 100.
- Cada caso precisa de: título, resumo, ≥1 conteúdo e ≥1 item de checklist
  (senão o painel não deixa enviar para revisão).

## Template de SQL (um bloco por caso)

Cada caso é UM comando (CTEs encadeados): cria o caso, liga os conteúdos e insere
o checklist. Usa *dollar-quoting* (`$c$…$c$`) para não precisar escapar aspas, e
resolve o conteúdo por `slug` dentro da disciplina/período certos.

```sql
with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $c$Título do caso$c$,
    $c$Pediatria$c$,
    null,                       -- subtipo (ou $c$...$c$)
    300,
    $c$Queixa principal curta$c$,
    $c$Instruções que o estudante lê.$c$,
    $c$Mãe de lactente de 5 meses…$c$,
    $c$Ansiosa; responde ao que for perguntado.$c$,
    jsonb_build_array(
      $c$Fato/fala 1 que o ator revela.$c$,
      $c$Fato/fala 2.$c$
    ),
    $c$Achados de exame liberados sob solicitação.$c$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = $princ$asma$princ$)   -- principal = este slug
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = (
         select dp.id from disciplina_periodo dp
         join disciplinas d on d.id = dp.disciplina_id
         join periodos   p on p.id = dp.periodo_id
         where d.slug = 'pediatria' and p.numero = 6   -- disciplina + período
       )
   and c.slug in ('asma', 'ivas')                      -- 1+ slugs de conteúdo
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i$Apresentou-se e identificou a criança/responsável$i$, 2, 0),
  ($i$Caracterizou a queixa (início, duração, evolução)$i$,    4, 1),
  ($i$Pesquisou sinais de alarme pertinentes$i$,               5, 2),
  ($i$Definiu conduta e orientou retorno/sinais de alarme$i$,  4, 3)
) as v(texto, grav, ord);
```

Repetir o bloco para cada caso do lote (separados por linha em branco). Rodar tudo
de uma vez no SQL Editor.

### Slugs de conteúdo (Pediatria 6º)

`aleitamento-materno, alergia-alimentar-aplv, anemias, asma, baixa-estatura,
bronquiolite-aguda, crescimento-infantil, dermatoses-na-infancia, diarreia-aguda,
disturbios-funcionais, doencas-exantematicas, dores-do-crescimento,
icutericia-neonatal, imunizacoes, itu, ivas, maus-tratos-na-infancia,
obesidade-infantil, parasitoses-intestinais, pac, puberdade-normal-e-alterada,
sindrome-nefritica-nefrotica, transtornos-neurodesenvolvimento, uso-abusivo-de-telas`

(Para Clínica Médica 5º ou Cirurgia 7º, trocar disciplina/período e usar os slugs
do `seed_taxonomia.sql`.)

---

## Esqueleto / preferências

> **A preencher pelo Wesley.** Cole aqui o esqueleto/modelo de caso que você quer
> que eu siga (estilo, tamanho do roteiro, tom, nº de itens de checklist, exemplos
> de casos "bons", o que evitar, etc.). A partir daí eu sigo este padrão em todo
> lote, sem você precisar repetir.
