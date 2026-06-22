-- Migracao automatica de cases.js -> Supabase (status em_revisao).
-- Gerado por gen_migracao_pediatria.js. Rodar DEPOIS de migracao_taxonomia_pediatria.sql.

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t50$Dor de barriga que sempre volta, sem achado nos exames$t50$,
    $e50$Distúrbios funcionais$e50$,
    null,
    300,
    $q50$Escolar de 8 anos com dor abdominal recorrente há 4 meses, já com exames normais.$q50$,
    $res50$Ambulatório. Escolar de 8 anos com dor abdominal recorrente há 4
meses; a família já fez vários exames, todos normais. Avalie o quadro e
explique aos pais por que não é preciso repetir tudo de novo. ~5 min.$res50$,
    $p50$Mãe de escolar, 8 anos$p50$,
    $ctx50$Mãe frustrada, achando que 'os exames não encontraram porque não procuraram certo'. Responda ao que for perguntado.$ctx50$,
    jsonb_build_array(
      $r50$Dor abdominal recorrente há 4 meses, várias vezes por semana, sem padrão claro de piora.$r50$,
      $r50$Já fez hemograma, exame de urina, parasitológico e ultrassom abdominal — todos normais.$r50$,
      $r50$Sem perda de peso, sem sangue nas fezes, sem febre, sem despertar noturno pela dor.$r50$,
      $r50$Cresce e ganha peso normalmente; come bem na maior parte dos dias.$r50$,
      $r50$Mãe pergunta: 'como pode doer tanto e não ter nada errado?'$r50$
    ),
    $ach50$Sintomas gastrointestinais recorrentes sem alteração estrutural ou laboratorial que os explique, em criança com crescimento e exames normais e sem sinais de alarme → quadro compatível com distúrbio funcional gastrointestinal. O diagnóstico é clínico, baseado na frequência/duração dos sintomas, nas características da dor e na ausência de sinais de alerta — não depende de repetir exames indefinidamente.$ach50$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'disturbios-funcionais')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('disturbios-funcionais')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i50_0$Revisou a investigação já realizada antes de pedir novos exames$i50_0$, 2, 0),
  ($i50_1$Caracterizou frequência, duração e impacto dos sintomas na rotina$i50_1$, 2, 1),
  ($i50_2$Pesquisou sinais de alarme (perda de peso, sangue, febre, despertar noturno)$i50_2$, 3, 2),
  ($i50_3$Explicou que o distúrbio funcional envolve interação entre intestino, sistema nervoso e fatores emocionais$i50_3$, 3, 3),
  ($i50_4$Explicou que o diagnóstico é clínico e não exige exame que 'prove' a ausência de doença$i50_4$, 2, 4),
  ($i50_5$Evitou prometer mais exames sem indicação clara$i50_5$, 1, 5),
  ($i50_6$Comunicação validando o sofrimento da família sem alarmar$i50_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t51$Dor abdominal que piora nos dias de prova$t51$,
    $e51$Distúrbios funcionais$e51$,
    null,
    300,
    $q51$Escolar de 9 anos com dor abdominal periumbilical recorrente, sem sinais de alarme.$q51$,
    $res51$Ambulatório. Escolar de 9 anos com dor abdominal periumbilical
recorrente há meses, sem sinais de alarme. Avalie e diferencie de causa
orgânica. ~5 min.$res51$,
    $p51$Mãe de escolar, 9 anos$p51$,
    $ctx51$Mãe ansiosa, com faltas escolares da filha. Responda ao que for perguntado.$ctx51$,
    jsonb_build_array(
      $r51$Dor em volta do umbigo, várias vezes por semana, há meses; melhora sozinha em minutos.$r51$,
      $r51$Não acorda à noite por causa da dor; não perdeu peso; cresce bem.$r51$,
      $r51$Piora em manhãs de prova ou quando está ansiosa; melhora nos fins de semana.$r51$,
      $r51$Sem diarreia, sangue nas fezes, vômito, febre ou disúria.$r51$
    ),
    $ach51$Dor periumbilical recorrente, sem relação consistente com evacuação, sem sinais de alarme (sem perda de peso, sem despertar noturno, sem sangramento, crescimento e exame normais) e com gatilho emocional claro (ansiedade escolar) → dor abdominal funcional.$ach51$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'disturbios-funcionais')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('disturbios-funcionais')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i51_0$Caracterizou a dor (localização periumbilical, padrão, gatilhos)$i51_0$, 2, 0),
  ($i51_1$Pesquisou sinais de alarme (perda de peso, dor noturna, sangue, febre)$i51_1$, 3, 1),
  ($i51_2$Avaliou crescimento/desenvolvimento e exame físico$i51_2$, 2, 2),
  ($i51_3$Investigou o contexto psicossocial (escola, ansiedade, família)$i51_3$, 2, 3),
  ($i51_4$Reconheceu a dor abdominal funcional$i51_4$, 2, 4),
  ($i51_5$Evitou propor exames/intervenções desnecessárias$i51_5$, 2, 5),
  ($i51_6$Explicou a natureza funcional sem invalidar a dor da criança$i51_6$, 2, 6),
  ($i51_7$Comunicação empática$i51_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t52$Dor que melhora ao evacuar, com fezes soltas$t52$,
    $e52$Distúrbios funcionais$e52$,
    null,
    300,
    $q52$Adolescente de 14 anos com dor abdominal recorrente associada a evacuações frequentes e fezes amolecidas.$q52$,
    $res52$Ambulatório. Adolescente de 14 anos com dor abdominal recorrente,
associada a evacuações frequentes e fezes amolecidas, há vários meses. Avalie
a síndrome do intestino irritável. ~5 min.$res52$,
    $p52$Adolescente, 14 anos$p52$,
    $ctx52$Já investigado antes, sem causa orgânica identificada. Responda ao que for perguntado.$ctx52$,
    jsonb_build_array(
      $r52$Dor abdominal várias vezes por semana, há mais de 4 meses, geralmente em cólica.$r52$,
      $r52$A dor melhora bastante depois de evacuar; evacua várias vezes ao dia, fezes amolecidas.$r52$,
      $r52$Piora visivelmente em períodos de prova ou conflito familiar.$r52$,
      $r52$Sem perda de peso, sem sangue nas fezes, sem febre, crescimento e puberdade normais.$r52$,
      $r52$Exames laboratoriais e marcadores inflamatórios já solicitados antes, normais.$r52$
    ),
    $ach52$Dor abdominal associada à alteração do hábito intestinal, com alívio após evacuar e predomínio de fezes amolecidas/frequentes, sem sinais de alarme e sem achado orgânico na investigação prévia → síndrome do intestino irritável (subtipo com predomínio de diarreia). Relacionada a alterações de motilidade e sensibilidade intestinal, sem marcador laboratorial específico.$ach52$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'disturbios-funcionais')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('disturbios-funcionais')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i52_0$Caracterizou a relação da dor com a evacuação (alívio/piora)$i52_0$, 3, 0),
  ($i52_1$Caracterizou o padrão das fezes (frequência, consistência)$i52_1$, 2, 1),
  ($i52_2$Pesquisou sinais de alarme (perda de peso, sangue, febre, déficit puberal)$i52_2$, 2, 2),
  ($i52_3$Investigou gatilhos emocionais/estresse$i52_3$, 1, 3),
  ($i52_4$Revisou a investigação prévia sem repetir exames sem indicação$i52_4$, 1, 4),
  ($i52_5$Reconheceu a síndrome do intestino irritável com predomínio de diarreia$i52_5$, 3, 5),
  ($i52_6$Orientou manejo inicial (dieta, manejo do estresse, sintomáticos)$i52_6$, 1, 6),
  ($i52_7$Comunicação clara e validando o desconforto do adolescente$i52_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t53$Dor abdominal com hábito intestinal que muda o tempo todo$t53$,
    $e53$Distúrbios funcionais$e53$,
    null,
    300,
    $q53$Adolescente de 13 anos com dor abdominal recorrente associada a alternância entre diarreia e constipação.$q53$,
    $res53$Ambulatório. Adolescente de 13 anos com dor abdominal recorrente
associada a alternância entre diarreia e constipação. Avalie a síndrome do
intestino irritável. ~5 min.$res53$,
    $p53$Adolescente, 13 anos$p53$,
    $ctx53$Já investigada anteriormente, sem causa orgânica identificada.$ctx53$,
    jsonb_build_array(
      $r53$Dor abdominal recorrente há mais de 3 meses, pelo menos 1 vez por semana.$r53$,
      $r53$Dor melhora após evacuar; piora em períodos de estresse/provas escolares.$r53$,
      $r53$Alterna entre fezes mais endurecidas e mais amolecidas, sem padrão fixo.$r53$,
      $r53$Sem perda de peso, sem sangue nas fezes, sem febre, crescimento adequado.$r53$,
      $r53$Exames laboratoriais e marcadores inflamatórios já solicitados previamente, normais.$r53$
    ),
    $ach53$Dor abdominal associada à evacuação (alívio ou piora) e à alteração na frequência/forma das fezes (alternando consistência), sem sinais de alarme e com exclusão de causas orgânicas → síndrome do intestino irritável (subtipo misto/alternante). Diagnóstico clínico, sem marcador laboratorial específico.$ach53$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'disturbios-funcionais')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('disturbios-funcionais')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i53_0$Caracterizou a relação da dor com a evacuação$i53_0$, 2, 0),
  ($i53_1$Investigou a alteração do hábito intestinal (alternância de consistência)$i53_1$, 3, 1),
  ($i53_2$Investigou gatilhos emocionais/estresse$i53_2$, 1, 2),
  ($i53_3$Descartou sinais de alarme (perda de peso, sangue, febre, déficit de crescimento)$i53_3$, 3, 3),
  ($i53_4$Reconheceu a síndrome do intestino irritável (subtipo alternante)$i53_4$, 3, 4),
  ($i53_5$Explicou a natureza funcional e o caráter clínico do diagnóstico$i53_5$, 1, 5),
  ($i53_6$Orientou manejo (dieta, manejo do estresse, sintomáticos conforme padrão)$i53_6$, 1, 6),
  ($i53_7$Comunicação clara e validando o sofrimento da adolescente$i53_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t54$Criança que evacua com dor e se esconde para segurar$t54$,
    $e54$Distúrbios funcionais$e54$,
    null,
    300,
    $q54$Pré-escolar de 3 anos com fezes duras, dolorosas e infrequentes.$q54$,
    $res54$Ambulatório. Pré-escolar de 3 anos com fezes duras, dolorosas e
infrequentes. Avalie a constipação funcional e a retenção fecal voluntária. ~5 min.$res54$,
    $p54$Mãe de criança, 3 anos$p54$,
    $ctx54$Mãe preocupada com a dor e o sangue nas fezes. Responda objetivamente.$ctx54$,
    jsonb_build_array(
      $r54$Fezes endurecidas e grossas a cada 3-4 dias, com dor e às vezes sangue vivo.$r54$,
      $r54$Faz força, se esconde e cruza/aperta as perninhas para segurar a evacuação (retenção voluntária).$r54$,
      $r54$Às vezes escapa um pouco de fezes na calcinha entre as evacuações completas.$r54$,
      $r54$Começou perto da retirada da fralda; come poucas fibras e bebe pouca água.$r54$,
      $r54$Eliminou mecônio normalmente ao nascer; ganha peso bem.$r54$
    ),
    $ach54$Evacuação difícil e dolorosa com retenção fecal voluntária, fissura anal e escape fecal por extravasamento; sem sinais de alarme (mecônio normal ao nascer, sem distensão importante, desenvolvimento normal) → constipação funcional.$ach54$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'disturbios-funcionais')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('disturbios-funcionais')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i54_0$Caracterizou o hábito intestinal (frequência, consistência, dor)$i54_0$, 2, 0),
  ($i54_1$Identificou o comportamento de retenção fecal voluntária$i54_1$, 3, 1),
  ($i54_2$Pesquisou escape fecal por extravasamento (soiling)$i54_2$, 1, 2),
  ($i54_3$Pesquisou sinais de alarme (mecônio tardio, distensão, baixo ganho)$i54_3$, 2, 3),
  ($i54_4$Avaliou dieta (fibras, água) e fatores desencadeantes (desfralde)$i54_4$, 2, 4),
  ($i54_5$Reconheceu a constipação funcional$i54_5$, 2, 5),
  ($i54_6$Orientou que a retenção não é 'birra' e sim parte do quadro$i54_6$, 1, 6),
  ($i54_7$Comunicação empática, desculpabilizando a criança$i54_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t55$Constipação que não melhora só com dieta$t55$,
    $e55$Distúrbios funcionais$e55$,
    null,
    300,
    $q55$Pré-escolar de 4 anos com constipação funcional já diagnosticada, sem melhora apenas com mudança na dieta.$q55$,
    $res55$Ambulatório. Pré-escolar de 4 anos com constipação funcional já
diagnosticada; a família tentou só ajustar a dieta, sem sucesso. Defina o
manejo terapêutico. ~5 min.$res55$,
    $p55$Pais de criança de 4 anos$p55$,
    $ctx55$Pais já tentaram mudar a dieta por conta própria, sem melhora. Responda ao que for perguntado.$ctx55$,
    jsonb_build_array(
      $r55$Diagnóstico de constipação funcional há 2 meses; tentaram aumentar fibras e água, sem grande melhora.$r55$,
      $r55$Ainda evacua a cada 4-5 dias, com dor, fezes grossas e episódios de escape entre as evacuações.$r55$,
      $r55$Exame abdominal (se solicitado): massa fecal palpável em quadrante inferior esquerdo.$r55$,
      $r55$Pais perguntam se 'só dieta' já devia ter resolvido ou se falta algo mais.$r55$
    ),
    $ach55$Constipação funcional com massa fecal retida (impactação) e escape por extravasamento, sem resposta a medidas dietéticas isoladas → indicação de desimpactação (laxante em dose adequada) seguida de manutenção prolongada com laxante osmótico, associada a rotina de toalete (treino comportamental) e ajustes alimentares. Medidas dietéticas isoladas raramente resolvem quadros com impactação já estabelecida.$ach55$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'disturbios-funcionais')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('disturbios-funcionais')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i55_0$Revisou o que já foi tentado (dieta) e por que não foi suficiente$i55_0$, 2, 0),
  ($i55_1$Identificou a impactação fecal ao exame$i55_1$, 2, 1),
  ($i55_2$Indicou desimpactação antes da fase de manutenção$i55_2$, 3, 2),
  ($i55_3$Indicou manutenção com laxante osmótico por tempo prolongado$i55_3$, 3, 3),
  ($i55_4$Orientou rotina de toalete/treino comportamental$i55_4$, 2, 4),
  ($i55_5$Explicou que dieta isolada raramente resolve impactação já estabelecida$i55_5$, 1, 5),
  ($i55_6$Comunicação empática, sem culpabilizar os pais$i55_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t56$Criança que para de comer no meio da refeição$t56$,
    $e56$Distúrbios funcionais$e56$,
    null,
    300,
    $q56$Escolar de 10 anos com saciedade precoce e sensação de estômago muito cheio após pequenas refeições.$q56$,
    $res56$Ambulatório. Escolar de 10 anos relata que "enche rápido" e sente o
estômago muito cheio mesmo comendo pouco, há alguns meses. Avalie a dispepsia
funcional. ~5 min.$res56$,
    $p56$Mãe de escolar, 10 anos$p56$,
    $ctx56$Mãe preocupada porque a criança come pouco nas refeições. Responda ao que for perguntado.$ctx56$,
    jsonb_build_array(
      $r56$Sente o estômago 'cheio demais' logo no início das refeições, e para de comer.$r56$,
      $r56$Sente plenitude/inchaço na região superior do abdome após comer, sem dor importante.$r56$,
      $r56$Sem vômitos, sem perda de peso, sem disfagia, crescimento adequado.$r56$,
      $r56$Sintomas pioram um pouco em períodos de mais estresse na escola.$r56$
    ),
    $ach56$Saciedade precoce e plenitude pós-prandial na região epigástrica, sem sinais de alarme (sem perda de peso, sem disfagia, sem vômitos persistentes, crescimento normal) → dispepsia funcional (subtipo com predomínio de distensão/saciedade precoce).$ach56$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'disturbios-funcionais')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('disturbios-funcionais')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i56_0$Caracterizou os sintomas (localização epigástrica, relação com a refeição)$i56_0$, 3, 0),
  ($i56_1$Diferenciou saciedade precoce/plenitude de dor epigástrica predominante$i56_1$, 2, 1),
  ($i56_2$Pesquisou sinais de alarme (perda de peso, disfagia, vômitos persistentes)$i56_2$, 3, 2),
  ($i56_3$Avaliou crescimento e estado nutricional$i56_3$, 1, 3),
  ($i56_4$Reconheceu a dispepsia funcional$i56_4$, 2, 4),
  ($i56_5$Orientou fracionamento das refeições e manejo de fatores emocionais$i56_5$, 1, 5),
  ($i56_6$Comunicação empática, sem forçar a criança a comer mais$i56_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t57$Dor na 'boca do estômago' fora das refeições$t57$,
    $e57$Distúrbios funcionais$e57$,
    null,
    300,
    $q57$Adolescente de 15 anos com dor epigástrica recorrente, não necessariamente relacionada às refeições.$q57$,
    $res57$Ambulatório. Adolescente de 15 anos com dor recorrente na região
epigástrica há 3 meses, sem relação clara com as refeições. Avalie a dispepsia
funcional e diferencie de causa orgânica. ~5 min.$res57$,
    $p57$Adolescente, 15 anos$p57$,
    $ctx57$Já fez exames básicos antes, normais. Responda ao que for perguntado.$ctx57$,
    jsonb_build_array(
      $r57$Dor na 'boca do estômago', recorrente, há 3 meses, não piora nem melhora claramente com a comida.$r57$,
      $r57$Sem queimação retroesternal importante, sem disfagia, sem perda de peso.$r57$,
      $r57$Sem vômitos significativos, sem sangue nas fezes, sem história familiar de doença ulcerosa/câncer GI.$r57$,
      $r57$Já fez exames laboratoriais básicos, normais; ainda não fez endoscopia.$r57$
    ),
    $ach57$Dor epigástrica recorrente sem relação consistente com as refeições e sem sinais de alarme (sem perda de peso, sem disfagia, sem sangramento, sem história familiar relevante) → dispepsia funcional (subtipo síndrome da dor epigástrica). Diferente de doença ulcerosa/causa orgânica, que cursaria com sinais de alarme ou fatores de risco.$ach57$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'disturbios-funcionais')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('disturbios-funcionais')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i57_0$Caracterizou a dor (localização epigástrica, relação com refeições)$i57_0$, 2, 0),
  ($i57_1$Pesquisou sinais de alarme (perda de peso, disfagia, sangramento)$i57_1$, 3, 1),
  ($i57_2$Investigou história familiar de doenças gastrointestinais importantes$i57_2$, 2, 2),
  ($i57_3$Revisou a investigação já realizada$i57_3$, 1, 3),
  ($i57_4$Reconheceu a dispepsia funcional (subtipo dor epigástrica)$i57_4$, 3, 4),
  ($i57_5$Diferenciou de causa orgânica (úlcera, doença inflamatória)$i57_5$, 2, 5),
  ($i57_6$Orientou manejo inicial e quando considerar investigação adicional$i57_6$, 1, 6),
  ($i57_7$Comunicação clara e respeitosa com o adolescente$i57_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t58$Dor abdominal recorrente, mas com perda de peso$t58$,
    $e58$Distúrbios funcionais$e58$,
    null,
    300,
    $q58$Escolar de 11 anos com dor abdominal recorrente associada a perda de peso e sangue nas fezes.$q58$,
    $res58$Ambulatório. Escolar de 11 anos com dor abdominal recorrente há 2
meses, mas a mãe nota perda de peso e notou sangue nas fezes. Avalie os sinais
de alarme e diferencie de um quadro funcional. ~5 min.$res58$,
    $p58$Mãe de escolar, 11 anos$p58$,
    $ctx58$Mãe inicialmente pensou que fosse 'só nervoso', mas notou outros sinais. Responda ao que for perguntado.$ctx58$,
    jsonb_build_array(
      $r58$Dor abdominal recorrente há 2 meses, em cólica, sem relação clara com estresse.$r58$,
      $r58$Perda de peso perceptível nas últimas semanas (roupas estão largas).$r58$,
      $r58$Notou sangue misturado nas fezes em mais de uma ocasião.$r58$,
      $r58$Tem episódios de febre baixa intermitente e já despertou à noite por causa da dor.$r58$,
      $r58$Tio materno tem doença inflamatória intestinal.$r58$
    ),
    $ach58$Presença de múltiplos sinais de alarme — perda de peso, sangramento gastrointestinal, febre persistente, sintomas noturnos relevantes e história familiar de doença gastrointestinal importante — torna este quadro INCOMPATÍVEL com diagnóstico funcional isolado; exige investigação para causa orgânica (ex.: doença inflamatória intestinal) antes de se considerar qualquer diagnóstico funcional.$ach58$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'disturbios-funcionais')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('disturbios-funcionais')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i58_0$Caracterizou a dor abdominal e sua evolução temporal$i58_0$, 1, 0),
  ($i58_1$Identificou ativamente os sinais de alarme (peso, sangue, febre, sono)$i58_1$, 3, 1),
  ($i58_2$Investigou história familiar de doença gastrointestinal importante$i58_2$, 2, 2),
  ($i58_3$Reconheceu que sinais de alarme excluem diagnóstico funcional isolado$i58_3$, 3, 3),
  ($i58_4$Indicou investigação direcionada para causa orgânica$i58_4$, 3, 4),
  ($i58_5$Evitou tranquilizar precocemente como se fosse quadro funcional$i58_5$, 2, 5),
  ($i58_6$Comunicação clara sobre a necessidade de investigação adicional$i58_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t59$Já confirmou que é funcional — e agora?$t59$,
    $e59$Distúrbios funcionais$e59$,
    null,
    300,
    $q59$Pais de escolar de 9 anos com diagnóstico confirmado de distúrbio funcional gastrointestinal, buscando orientação sobre o tratamento.$q59$,
    $res59$Retorno. Pais de escolar de 9 anos já com diagnóstico de distúrbio
funcional gastrointestinal (dor abdominal funcional). Explique a abordagem
terapêutica e responda às dúvidas da família. ~5 min.$res59$,
    $p59$Pais de escolar, 9 anos$p59$,
    $ctx59$Pais aliviados por não ser doença grave, mas sem saber o que fazer na prática. Responda ao que for perguntado.$ctx59$,
    jsonb_build_array(
      $r59$Diagnóstico de dor abdominal funcional já estabelecido na consulta anterior, sem sinais de alarme.$r59$,
      $r59$Pais perguntam: 'já que não é nada grave, não tem remédio que resolve de vez?'$r59$,
      $r59$Notam que a criança fica mais ansiosa antes de provas e que a dor piora nesses dias.$r59$,
      $r59$Alimentação é irregular, com pouca rotina nas refeições e no sono.$r59$
    ),
    $ach59$Abordagem terapêutica do distúrbio funcional gastrointestinal é baseada em medidas gerais: educação da família e da criança sobre o diagnóstico (explicar que é real, mas não é uma doença estrutural), estabelecimento de rotina intestinal e alimentar adequada, alimentação equilibrada e abordagem dos fatores emocionais associados. O tratamento é individualizado conforme o sintoma predominante (ex.: manejo da constipação, ajustes alimentares específicos), e não existe uma única medicação que 'resolva de vez' a maioria dos casos.$ach59$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'disturbios-funcionais')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('disturbios-funcionais')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i59_0$Revisou o diagnóstico já estabelecido e a ausência de sinais de alarme$i59_0$, 1, 0),
  ($i59_1$Explicou a educação da família como pilar do tratamento (diagnóstico é real, não estrutural)$i59_1$, 3, 1),
  ($i59_2$Orientou rotina intestinal e alimentar adequada$i59_2$, 2, 2),
  ($i59_3$Abordou os fatores emocionais identificados (ansiedade escolar)$i59_3$, 2, 3),
  ($i59_4$Esclareceu que o tratamento é individualizado conforme o sintoma predominante$i59_4$, 2, 4),
  ($i59_5$Corrigiu a expectativa de uma medicação única que resolva tudo$i59_5$, 2, 5),
  ($i59_6$Comunicação didática e acolhedora$i59_6$, 1, 6)
) as v(texto, grav, ord);
