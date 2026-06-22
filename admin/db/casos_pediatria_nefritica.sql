-- Migracao automatica de cases.js -> Supabase (status em_revisao).
-- Gerado por gen_migracao_pediatria.js. Rodar DEPOIS de migracao_taxonomia_pediatria.sql.

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t40$Criança com urina escura e inchaço$t40$,
    $e40$Síndrome nefrítica$e40$,
    null,
    300,
    $q40$Menino de 6 anos com urina "cor de coca-cola", edema e mal-estar.$q40$,
    $res40$Ambulatório/PS. Menino de 6 anos com urina "cor de coca-cola", edema
e mal-estar. Avalie a síndrome nefrítica e conduza. ~5 min.$res40$,
    $p40$Mãe de menino, 6 anos$p40$,
    $ctx40$Mãe preocupada. Só cite a infecção prévia se for perguntada.$ctx40$,
    jsonb_build_array(
      $r40$Urina escura (cor de coca/chá) há 2 dias, urinando menos.$r40$,
      $r40$Inchaço nos olhos de manhã e nas pernas.$r40$,
      $r40$Se perguntado: teve feridas de pele (impetigo) / dor de garganta há ~3 semanas.$r40$,
      $r40$Hoje com dor de cabeça; na triagem a pressão estava alta.$r40$,
      $r40$Achados: edema palpebral e de MMII, PA elevada para a idade.$r40$
    ),
    $ach40$Edema, hematúria macroscópica, oligúria e HAS ~3 semanas após piodermite/faringite → glomerulonefrite difusa aguda pós-estreptocócica. Esperado: C3 baixo, ASLO/anti-DNase elevados, EAS com hematúria, cilindros hemáticos e proteinúria.$ach40$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'sindrome-nefritica-nefrotica')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('sindrome-nefritica-nefrotica')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i40_0$Apresentou-se e identificou criança/responsável$i40_0$, 1, 0),
  ($i40_1$Caracterizou a hematúria (cor, duração, volume urinário)$i40_1$, 2, 1),
  ($i40_2$Caracterizou o edema (periorbitário matinal, MMII)$i40_2$, 2, 2),
  ($i40_3$Pesquisou infecção estreptocócica prévia (faringite/piodermite)$i40_3$, 2, 3),
  ($i40_4$Aferiu e valorizou a pressão arterial para a idade$i40_4$, 2, 4),
  ($i40_5$Reconheceu síndrome nefrítica / GNDA pós-estreptocócica$i40_5$, 3, 5),
  ($i40_6$Solicitou EAS, função renal, C3 e ASLO/anti-DNase$i40_6$, 3, 6),
  ($i40_7$Orientou restrição hidrossalina e controle de PA$i40_7$, 2, 7),
  ($i40_8$Explicou bom prognóstico e seguimento$i40_8$, 1, 8),
  ($i40_9$Comunicação clara$i40_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t41$Sangue na urina$t41$,
    $e41$Síndrome nefrítica$e41$,
    null,
    300,
    $q41$Menina de 8 anos com urina avermelhada.$q41$,
    $res41$Ambulatório. Menina de 8 anos com urina avermelhada. Avalie e
diferencie as causas de hematúria, definindo a investigação. ~5 min.$res41$,
    $p41$Mãe de menina, 8 anos$p41$,
    $ctx41$Mãe traz por causa da cor da urina. Responda objetivamente.$ctx41$,
    jsonb_build_array(
      $r41$Urina avermelhada/escura, sem coágulos, sem disúria importante.$r41$,
      $r41$Sem febre alta, sem trauma, sem dor em cólica.$r41$,
      $r41$Se perguntado: já teve urina escura JUNTO com resfriados, outras vezes.$r41$,
      $r41$Sem edema hoje; pressão normal. Sem surdez/hematúria na família.$r41$
    ),
    $ach41$Hematúria macroscópica recorrente concomitante a IVAS, sem edema/HAS/disúria → sugere nefropatia por IgA; diferenciar de GNDA, ITU e litíase. EAS com hemácias dismórficas/cilindros aponta origem glomerular.$ach41$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'sindrome-nefritica-nefrotica')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('sindrome-nefritica-nefrotica')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i41_0$Apresentou-se e confirmou tratar-se de hematúria$i41_0$, 1, 0),
  ($i41_1$Diferenciou hematúria glomerular x não glomerular$i41_1$, 3, 1),
  ($i41_2$Pesquisou disúria/febre (ITU) e cólica/dor lombar (litíase)$i41_2$, 2, 2),
  ($i41_3$Pesquisou relação temporal com IVAS (IgA x GNDA)$i41_3$, 2, 3),
  ($i41_4$Pesquisou edema, HAS e história familiar (Alport)$i41_4$, 2, 4),
  ($i41_5$Solicitou EAS com pesquisa de cilindros/hemácias dismórficas$i41_5$, 2, 5),
  ($i41_6$Solicitou função renal e exames direcionados$i41_6$, 2, 6),
  ($i41_7$Definiu seguimento/encaminhamento nefrológico se indicado$i41_7$, 1, 7),
  ($i41_8$Comunicação clara$i41_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t42$Síndrome nefrítica com pressão muito alta$t42$,
    $e42$Síndrome nefrítica$e42$,
    null,
    300,
    $q42$Menino de 7 anos com nefrite, agora com cefaleia intensa, vômitos e PA muito elevada.$q42$,
    $res42$Pronto-socorro. Menino de 7 anos com nefrite, agora com cefaleia
intensa, vômitos e PA muito elevada. Reconheça a emergência e conduza. ~5 min.$res42$,
    $p42$Pai de menino, 7 anos$p42$,
    $ctx42$Pai assustado com a piora. Informe achados quando solicitados.$ctx42$,
    jsonb_build_array(
      $r42$Já estava com urina escura e inchaço há alguns dias.$r42$,
      $r42$Hoje: cefaleia forte, vômitos, visão embaçada e muito sonolento.$r42$,
      $r42$Teve um episódio de 'tremor/convulsão' há pouco.$r42$,
      $r42$Achados: PA muito elevada para a idade, edema; pode ter falta de ar/estertores.$r42$
    ),
    $ach42$Hipertensão grave com encefalopatia (cefaleia, vômitos, alteração visual, convulsão) e/ou congestão no contexto de GNDA → emergência hipertensiva. Reduzir PA de forma controlada, restrição hidrossalina, diurético e suporte.$ach42$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'sindrome-nefritica-nefrotica')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('sindrome-nefritica-nefrotica')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i42_0$Apresentou-se e reconheceu a gravidade$i42_0$, 2, 0),
  ($i42_1$Aferiu a PA e interpretou para idade/sexo/estatura$i42_1$, 2, 1),
  ($i42_2$Pesquisou encefalopatia hipertensiva (cefaleia, vômito, visão, convulsão)$i42_2$, 3, 2),
  ($i42_3$Pesquisou sinais de congestão/edema agudo de pulmão$i42_3$, 2, 3),
  ($i42_4$Reconheceu a emergência hipertensiva$i42_4$, 3, 4),
  ($i42_5$Indicou restrição hidrossalina e diurético (furosemida)$i42_5$, 2, 5),
  ($i42_6$Iniciou anti-hipertensivo com redução gradual e monitorização$i42_6$, 2, 6),
  ($i42_7$Acionou suporte/UTI e nefrologia$i42_7$, 2, 7),
  ($i42_8$Condução de emergência adequada$i42_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t43$Criança inchada: nefrítica ou nefrótica?$t43$,
    $e43$Síndrome nefrítica$e43$,
    null,
    300,
    $q43$Pré-escolar de 4 anos com edema importante.$q43$,
    $res43$Ambulatório. Pré-escolar de 4 anos com edema importante. Diferencie
síndrome nefrítica de nefrótica e oriente a investigação. ~5 min.$res43$,
    $p43$Mãe de criança, 4 anos$p43$,
    $ctx43$Mãe preocupada com o inchaço que aumenta. Responda ao que for perguntado.$ctx43$,
    jsonb_build_array(
      $r43$Edema começou nos olhos e foi se espalhando; hoje barriga e bolsa escrotal inchadas.$r43$,
      $r43$Urina espumosa; volume urinário um pouco reduzido.$r43$,
      $r43$Sem urina escura; sem dor de cabeça; pressão normal na triagem.$r43$,
      $r43$Achados: edema mole, ascite, sem hipertensão, sem hematúria visível.$r43$
    ),
    $ach43$Edema generalizado (anasarca), urina espumosa, sem hematúria macroscópica nem HAS → padrão NEFRÓTICO (proteinúria maciça, hipoalbuminemia). Contrasta com a nefrítica (hematúria + HAS + oligúria).$ach43$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'sindrome-nefritica-nefrotica')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('sindrome-nefritica-nefrotica')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i43_0$Apresentou-se e caracterizou o edema (início, evolução, extensão)$i43_0$, 2, 0),
  ($i43_1$Pesquisou urina espumosa x urina escura/hematúria$i43_1$, 2, 1),
  ($i43_2$Aferiu a PA e avaliou o volume urinário$i43_2$, 2, 2),
  ($i43_3$Diferenciou padrão NEFRÓTICO de NEFRÍTICO$i43_3$, 3, 3),
  ($i43_4$Solicitou EAS, proteinúria, albumina e lipídios$i43_4$, 3, 4),
  ($i43_5$Levantou hipótese adequada (ex.: nefrótica por lesão mínima)$i43_5$, 2, 5),
  ($i43_6$Orientou conduta inicial / encaminhamento$i43_6$, 1, 6),
  ($i43_7$Comunicação clara$i43_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t44$Orientações na nefrite pós-estreptocócica$t44$,
    $e44$Síndrome nefrítica$e44$,
    null,
    300,
    $q44$A mãe de um menino de 6 anos com GNDA pós-estreptocócica quer entender a evolução e os cuidados.$q44$,
    $res44$Retorno. A mãe de um menino de 6 anos com GNDA pós-estreptocócica quer
entender a evolução e os cuidados. Oriente e defina o seguimento. ~5 min.$res44$,
    $p44$Mãe de menino, 6 anos$p44$,
    $ctx44$Mãe cheia de dúvidas, já mais aliviada. Faça perguntas e oriente.$ctx44$,
    jsonb_build_array(
      $r44$Diagnóstico recente de nefrite pós-estreptocócica; edema melhorando.$r44$,
      $r44$Pergunta: 'vai ficar com problema no rim para sempre?'$r44$,
      $r44$Pergunta: 'precisa de dieta?' e 'os outros filhos podem pegar?'$r44$,
      $r44$Quer saber quando os exames (C3) normalizam.$r44$
    ),
    $ach44$GNDA pós-estreptocócica costuma ter bom prognóstico na criança. C3 normaliza em ~6-8 semanas; hematúria microscópica pode persistir por meses. Cuidados: restrição de sal/líquidos na fase aguda, controle de PA e seguimento.$ach44$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'sindrome-nefritica-nefrotica')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('sindrome-nefritica-nefrotica')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i44_0$Apresentou-se e revisou o quadro/diagnóstico$i44_0$, 1, 0),
  ($i44_1$Explicou o mecanismo (pós-infeccioso) de forma acessível$i44_1$, 2, 1),
  ($i44_2$Orientou restrição de sal e líquidos na fase aguda$i44_2$, 2, 2),
  ($i44_3$Orientou controle de PA e do volume urinário$i44_3$, 2, 3),
  ($i44_4$Explicou o bom prognóstico habitual na criança$i44_4$, 2, 4),
  ($i44_5$Informou normalização do C3 (~6-8 sem) e hematúria residual$i44_5$, 2, 5),
  ($i44_6$Definiu seguimento e sinais de alarme para retorno$i44_6$, 2, 6),
  ($i44_7$Esclareceu dúvidas da família (contágio, irmãos)$i44_7$, 1, 7),
  ($i44_8$Comunicação didática e empática$i44_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t45$Edema progressivo em criança de 4 anos$t45$,
    $e45$Síndrome nefrótica$e45$,
    null,
    300,
    $q45$Criança de 4 anos com edema progressivo há 5 dias, iniciado na face.$q45$,
    $res45$Ambulatório. Criança de 4 anos com edema progressivo há 5 dias, iniciado
na face. Conduza a investigação da síndrome nefrótica. ~5 min.$res45$,
    $p45$Pais de criança de 4 anos$p45$,
    $ctx45$Pais notaram 'inchaço' que foi piorando. Informe achados quando solicitados.$ctx45$,
    jsonb_build_array(
      $r45$Edema começou ao redor dos olhos pela manhã, depois espalhou para pernas e abdome.$r45$,
      $r45$Edema é mole, frio e depressível (cacifo positivo).$r45$,
      $r45$Sem febre, sem queixa urinária além de 'espuma' na urina.$r45$,
      $r45$Sem episódio recente de faringite ou impetigo.$r45$,
      $r45$Exames (se pedidos): proteinúria de 24h ~60 mg/kg/dia (ou relação proteína/creatinina urinária >2), albumina sérica 2,0 g/dL, colesterol elevado, complemento (C3) normal.$r45$
    ),
    $ach45$Tríade da síndrome nefrótica: edema (tipicamente iniciando na face, mole/frio/depressível), proteinúria maciça (>50 mg/kg/dia ou relação proteína/creatinina >2) e hipoalbuminemia (<2,5 g/dL), associada a hiperlipidemia. Complemento normal é compatível com doença de lesão mínima (causa mais comum na faixa pré-escolar), diferente da síndrome nefrítica (C3 baixo).$ach45$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'sindrome-nefritica-nefrotica')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('sindrome-nefritica-nefrotica')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i45_0$Caracterizou o edema (início facial, mole, frio, depressível)$i45_0$, 2, 0),
  ($i45_1$Investigou sintomas urinários (espuma = proteinúria) e diurese$i45_1$, 1, 1),
  ($i45_2$Solicitou proteinúria de 24h ou relação proteína/creatinina urinária$i45_2$, 2, 2),
  ($i45_3$Solicitou albumina sérica e perfil lipídico$i45_3$, 2, 3),
  ($i45_4$Solicitou complemento (C3) para diferenciar de síndrome nefrítica$i45_4$, 2, 4),
  ($i45_5$Reconheceu a tríade da síndrome nefrótica$i45_5$, 3, 5),
  ($i45_6$Relacionou complemento normal à doença de lesão mínima$i45_6$, 2, 6),
  ($i45_7$Comunicação clara com a família$i45_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t46$Tratamento da síndrome nefrótica idiopática$t46$,
    $e46$Síndrome nefrótica$e46$,
    null,
    300,
    $q46$Criança de 5 anos com diagnóstico recente de síndrome nefrótica idiopática (lesão mínima).$q46$,
    $res46$Ambulatório. Criança de 5 anos com diagnóstico recente de síndrome
nefrótica idiopática (lesão mínima). Explique o tratamento e o prognóstico aos pais. ~5 min.$res46$,
    $p46$Pais de criança de 5 anos com síndrome nefrótica$p46$,
    $ctx46$Pais preocupados com o uso prolongado de corticoide.$ctx46$,
    jsonb_build_array(
      $r46$Diagnóstico recente: edema, proteinúria maciça, hipoalbuminemia, complemento normal.$r46$,
      $r46$Pais perguntam: 'vai precisar de biópsia?' e 'quanto tempo vai durar o remédio?'$r46$,
      $r46$Perguntam sobre restrição alimentar e se a criança pode voltar à escola.$r46$,
      $r46$Preocupados com efeitos colaterais do corticoide (ganho de peso, humor).$r46$
    ),
    $ach46$Síndrome nefrótica idiopática (lesão mínima) na faixa etária típica geralmente não exige biópsia inicial. Tratamento: dieta hipossódica + prednisona 2 mg/kg/dia por 6-8 semanas (esquema então reduzido/desmamado conforme protocolo). Cerca de 90% das crianças alcançam remissão com corticoterapia. Diuréticos e albumina IV são reservados para casos refratários/edema importante com risco. Restrição hídrica não é rotina; restrição de sódio sim.$ach46$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'sindrome-nefritica-nefrotica')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('sindrome-nefritica-nefrotica')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i46_0$Explicou que biópsia não é necessária na apresentação típica$i46_0$, 2, 0),
  ($i46_1$Indicou dieta hipossódica$i46_1$, 2, 1),
  ($i46_2$Indicou corticoterapia (prednisona 2 mg/kg/dia) e a duração esperada (6-8 semanas)$i46_2$, 3, 2),
  ($i46_3$Informou a alta taxa de remissão com corticoide (~90%)$i46_3$, 2, 3),
  ($i46_4$Esclareceu que diuréticos/albumina são reservados a casos refratários$i46_4$, 2, 4),
  ($i46_5$Abordou efeitos colaterais esperados do corticoide$i46_5$, 1, 5),
  ($i46_6$Orientou retorno escolar e cuidados gerais$i46_6$, 1, 6),
  ($i46_7$Comunicação clara e tranquilizadora$i46_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t47$Criança nefrótica com dor abdominal e febre$t47$,
    $e47$Síndrome nefrótica$e47$,
    null,
    300,
    $q47$Criança com síndrome nefrótica em atividade, apresenta febre e dor abdominal súbita.$q47$,
    $res47$Pronto-socorro. Criança com síndrome nefrótica em atividade, apresenta
febre e dor abdominal súbita. Avalie as complicações possíveis. ~5 min.$res47$,
    $p47$Pais de criança com síndrome nefrótica em atividade$p47$,
    $ctx47$Criança em uso de corticoide, com edema ainda presente. Informe achados quando solicitados.$ctx47$,
    jsonb_build_array(
      $r47$Febre de 38,5°C e dor abdominal difusa de início há algumas horas.$r47$,
      $r47$Criança está com edema generalizado, ainda em proteinúria maciça.$r47$,
      $r47$Sem diarreia, sem vômitos importantes; abdome discretamente distendido.$r47$,
      $r47$Exames (se pedidos): leucocitose, líquido ascítico com características de peritonite bacteriana (se investigado); considerar também risco de trombose (membro inchado/dor torácica) se houver esses sinais.$r47$
    ),
    $ach47$Crianças com síndrome nefrótica em atividade têm maior risco de infecções (sobretudo peritonite bacteriana espontânea, geralmente por pneumococo, relacionada à perda urinária de imunoglobulinas) e de eventos trombóticos (por hipovolemia relativa, hipoalbuminemia e alterações de fatores de coagulação). Febre + dor abdominal nesse contexto deve levantar suspeita de peritonite bacteriana, exigindo investigação e antibioticoterapia.$ach47$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'sindrome-nefritica-nefrotica')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('sindrome-nefritica-nefrotica')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i47_0$Reconheceu o maior risco infeccioso da síndrome nefrótica em atividade$i47_0$, 3, 0),
  ($i47_1$Suspeitou de peritonite bacteriana espontânea diante de febre + dor abdominal$i47_1$, 3, 1),
  ($i47_2$Investigou sinais de complicação trombótica (edema assimétrico, dor torácica)$i47_2$, 2, 2),
  ($i47_3$Solicitou exames complementares pertinentes (hemograma, líquido ascítico se indicado)$i47_3$, 2, 3),
  ($i47_4$Relacionou o risco a hipogamaglobulinemia/perda urinária de proteínas$i47_4$, 2, 4),
  ($i47_5$Indicou conduta apropriada (antibioticoterapia se confirmada infecção)$i47_5$, 2, 5),
  ($i47_6$Comunicação clara sobre a gravidade potencial$i47_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t48$Síndrome nefrótica que volta a inchar$t48$,
    $e48$Síndrome nefrótica$e48$,
    null,
    300,
    $q48$Criança de 6 anos com história de síndrome nefrótica, já tratada antes, retorna com edema e proteinúria novamente.$q48$,
    $res48$Ambulatório. Criança de 6 anos com história de síndrome nefrótica,
já tratada antes, retorna com edema e proteinúria novamente. Avalie a recidiva. ~5 min.$res48$,
    $p48$Pais de criança de 6 anos com história de síndrome nefrótica$p48$,
    $ctx48$Pais frustrados, achavam que a doença tinha sido 'curada' da primeira vez.$ctx48$,
    jsonb_build_array(
      $r48$Há 8 meses teve o primeiro episódio, tratado com corticoide, com remissão completa.$r48$,
      $r48$Há 3 dias, edema periorbitário reapareceu; urina com proteína positiva no teste de fita novamente.$r48$,
      $r48$Pais perguntam: 'isso é normal acontecer de novo?' e 'vai precisar do mesmo tratamento?'$r48$,
      $r48$Criança sem febre, sem outros sintomas associados.$r48$
    ),
    $ach48$Recidivas são comuns na síndrome nefrótica idiopática (lesão mínima); a maioria das crianças apresenta ao menos uma recidiva após o primeiro episódio. O tratamento de recidivas geralmente repete corticoterapia em esquema definido. Casos com recidivas frequentes, corticodependência ou corticorresistência podem necessitar de investigação adicional (incluindo biópsia) e terapias poupadoras de corticoide.$ach48$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'sindrome-nefritica-nefrotica')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('sindrome-nefritica-nefrotica')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i48_0$Confirmou a recidiva (proteinúria + edema) com história prévia de remissão$i48_0$, 2, 0),
  ($i48_1$Explicou que recidivas são comuns e esperadas na evolução da doença$i48_1$, 3, 1),
  ($i48_2$Indicou reinício de corticoterapia conforme protocolo de recidiva$i48_2$, 2, 2),
  ($i48_3$Reconheceu critérios de recidiva frequente/corticodependência/corticorresistência$i48_3$, 3, 3),
  ($i48_4$Mencionou possível necessidade de biópsia/terapia poupadora em casos complicados$i48_4$, 2, 4),
  ($i48_5$Acolheu a frustração dos pais com explicação clara$i48_5$, 1, 5),
  ($i48_6$Comunicação didática$i48_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t49$Quando indicar biópsia renal na síndrome nefrítica$t49$,
    $e49$Síndrome nefrítica$e49$,
    null,
    300,
    $q49$Criança com GNPE há 6 semanas, ainda com alterações urinárias.$q49$,
    $res49$Ambulatório de seguimento. Criança com GNPE há 6 semanas, ainda com
alterações urinárias. Avalie a necessidade de biópsia renal. ~5 min.$res49$,
    $p49$Pais de criança em seguimento de GNPE$p49$,
    $ctx49$Pais preocupados pela demora na resolução total dos exames.$ctx49$,
    jsonb_build_array(
      $r49$Diagnóstico de GNPE há 6 semanas, após faringite confirmada por ASLO elevado.$r49$,
      $r49$Pressão arterial normalizada há 3 semanas; edema resolvido.$r49$,
      $r49$Hematúria microscópica ainda presente no exame de urina mais recente.$r49$,
      $r49$Complemento (C3), repetido com 6 semanas, já normalizado.$r49$,
      $r49$Pais perguntam se precisa de biópsia já que 'ainda tem sangue na urina'.$r49$
    ),
    $ach49$Na GNPE, a hematúria microscópica pode persistir por até 1-2 anos sem necessidade de biópsia, desde que HAS e função renal tenham se normalizado e o complemento tenha normalizado dentro do esperado (até 8 semanas). Indicações de biópsia: hematúria macroscópica/HAS/função renal alterada persistindo além de 4 semanas, oligoanúria prolongada (>48-72h) na fase aguda, ou C3 persistentemente baixo após 8 semanas.$ach49$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'sindrome-nefritica-nefrotica')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('sindrome-nefritica-nefrotica')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i49_0$Revisou a evolução clínica (PA, edema, função renal)$i49_0$, 2, 0),
  ($i49_1$Verificou a normalização do complemento (C3) dentro do prazo esperado$i49_1$, 2, 1),
  ($i49_2$Reconheceu que hematúria microscópica isolada pode persistir sem indicar biópsia$i49_2$, 3, 2),
  ($i49_3$Listou corretamente os critérios que indicariam biópsia$i49_3$, 3, 3),
  ($i49_4$Concluiu que biópsia não é necessária neste momento$i49_4$, 2, 4),
  ($i49_5$Orientou seguimento ambulatorial continuado$i49_5$, 1, 5),
  ($i49_6$Comunicação tranquilizadora e didática$i49_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t130$Síndrome nefrítica após impetigo$t130$,
    $e130$Nefrologia pediátrica$e130$,
    null,
    300,
    $q130$Escolar de 7 anos com urina escura e edema, semanas após lesões de pele.$q130$,
    $res130$Escolar de 7 anos com urina escura e edema, semanas após lesões de pele.
Avalie, levante a hipótese de GNPE e oriente investigação. ~5 min.$res130$,
    $p130$Mãe de escolar de 7 anos$p130$,
    $ctx130$Mãe preocupada com a urina 'cor de coca-cola'. Responda só ao que for perguntado.$ctx130$,
    jsonb_build_array(
      $r130$Há cerca de 2–3 semanas teve feridas de pele (impetigo) tratadas em casa.$r130$,
      $r130$Agora a urina está escura e o rosto está inchado pela manhã.$r130$,
      $r130$Fez menos xixi e está com dor de cabeça.$r130$,
      $r130$Sem febre no momento.$r130$
    ),
    $ach130$Edema, hipertensão e hematúria macroscópica (cor de coca-cola) após impetigo; oligúria. Sugere GNPE.$ach130$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'sindrome-nefritica-nefrotica')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('sindrome-nefritica-nefrotica')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i130_0$Apresentou-se e identificou criança/responsável$i130_0$, 1, 0),
  ($i130_1$Reconheceu a tríade nefrítica (hematúria, hipertensão, edema)$i130_1$, 3, 1),
  ($i130_2$Relacionou com infecção estreptocócica prévia (impetigo)$i130_2$, 2, 2),
  ($i130_3$Aferiu/valorizou a pressão arterial$i130_3$, 2, 3),
  ($i130_4$Solicitou EAS, função renal, C3 e anti-DNase B$i130_4$, 2, 4),
  ($i130_5$Orientou suporte (restrição hídrica/salina, vigilância)$i130_5$, 1, 5),
  ($i130_6$Comunicação clara e empática$i130_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t131$Interpretação de C3, ASLO e anti-DNase B$t131$,
    $e131$Nefrologia pediátrica$e131$,
    null,
    300,
    $q131$Escolar de 8 anos com quadro nefrítico e exames já colhidos.$q131$,
    $res131$Escolar de 8 anos com quadro nefrítico e exames já colhidos.
Interprete o complemento e os marcadores estreptocócicos e explique aos pais. ~5 min.$res131$,
    $p131$Pai de escolar de 8 anos$p131$,
    $ctx131$Pai trouxe os exames e quer entender os resultados. Responda só ao que for perguntado.$ctx131$,
    jsonb_build_array(
      $r131$A criança teve dor de garganta há algumas semanas.$r131$,
      $r131$Os exames mostram C3 baixo e marcadores estreptocócicos positivos.$r131$,
      $r131$Ele pergunta se o complemento baixo é permanente.$r131$,
      $r131$A criança está em acompanhamento, melhorando.$r131$
    ),
    $ach131$C3 reduzido; ASLO elevado (pós-faringite); quadro compatível com GNPE, com tendência à normalização do C3.$ach131$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'sindrome-nefritica-nefrotica')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('sindrome-nefritica-nefrotica')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i131_0$Apresentou-se e identificou o responsável$i131_0$, 1, 0),
  ($i131_1$Explicou C3 baixo como típico da GNPE$i131_1$, 3, 1),
  ($i131_2$Diferenciou ASLO (pós-faringite) e anti-DNase B (pós-impetigo)$i131_2$, 2, 2),
  ($i131_3$Reconheceu hematúria glomerular (dismorfismo, cilindros hemáticos)$i131_3$, 2, 3),
  ($i131_4$Explicou que o C3 tende a normalizar em algumas semanas$i131_4$, 2, 4),
  ($i131_5$Indicou que C3 persistentemente baixo motiva investigação/biópsia$i131_5$, 1, 5),
  ($i131_6$Linguagem acessível e empática$i131_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t132$Síndrome nefrótica de início — corticoterapia$t132$,
    $e132$Nefrologia pediátrica$e132$,
    null,
    300,
    $q132$Pré-escolar de 3 anos com edema facial progressivo e urina espumosa.$q132$,
    $res132$Pré-escolar de 3 anos com edema facial progressivo e urina espumosa.
Avalie, levante síndrome nefrótica e oriente tratamento inicial. ~5 min.$res132$,
    $p132$Mãe de pré-escolar de 3 anos$p132$,
    $ctx132$Mãe achou que era 'alergia no rosto'. Responda só ao que for perguntado.$ctx132$,
    jsonb_build_array(
      $r132$O inchaço começou ao redor dos olhos, pela manhã, e foi aumentando.$r132$,
      $r132$A urina está espumosa; a barriga ficou mais distendida.$r132$,
      $r132$Está comendo menos e mais quietinho.$r132$,
      $r132$Sem febre; pressão normal nas medidas.$r132$
    ),
    $ach132$Edema mole, frio, depressível, iniciado em face; urina espumosa; proteinúria maciça, hipoalbuminemia (<2,5 g/dL); PA normal; complemento normal.$ach132$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'sindrome-nefritica-nefrotica')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('sindrome-nefritica-nefrotica')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i132_0$Apresentou-se e identificou criança/responsável$i132_0$, 1, 0),
  ($i132_1$Reconheceu a tríade nefrótica (edema, proteinúria, hipoalbuminemia)$i132_1$, 3, 1),
  ($i132_2$Caracterizou o edema (face, mole, depressível) e urina espumosa$i132_2$, 2, 2),
  ($i132_3$Solicitou proteinúria, albumina e relação proteína/creatinina$i132_3$, 2, 3),
  ($i132_4$Indicou dieta hipossódica e corticoterapia (prednisona)$i132_4$, 2, 4),
  ($i132_5$Explicou bom prognóstico/corticossensibilidade na maioria$i132_5$, 1, 5),
  ($i132_6$Comunicação clara e empática$i132_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t133$Risco de infecção/trombose na síndrome nefrótica$t133$,
    $e133$Nefrologia pediátrica$e133$,
    null,
    300,
    $q133$Pré-escolar com síndrome nefrótica em atividade apresenta febre e dor abdominal.$q133$,
    $res133$Pré-escolar com síndrome nefrótica em atividade apresenta febre e dor abdominal.
Reconheça as complicações de risco e oriente conduta. ~5 min.$res133$,
    $p133$Mãe de pré-escolar de 4 anos com síndrome nefrótica$p133$,
    $ctx133$Criança em recidiva, muito edemaciada. Responda só ao que for perguntado.$ctx133$,
    jsonb_build_array(
      $r133$Está bem inchado (anasarca), com a barriga tensa (ascite).$r133$,
      $r133$Hoje teve febre e dor forte na barriga.$r133$,
      $r133$Uma perna está mais inchada e dolorida que a outra.$r133$,
      $r133$Em uso irregular do corticoide.$r133$
    ),
    $ach133$Anasarca com ascite; febre + dor abdominal (alerta para peritonite/sepse); edema assimétrico de membro (alerta para trombose).$ach133$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'sindrome-nefritica-nefrotica')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('sindrome-nefritica-nefrotica')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i133_0$Apresentou-se e avaliou a criança$i133_0$, 1, 0),
  ($i133_1$Reconheceu maior risco de infecção (perda urinária de imunoglobulinas)$i133_1$, 2, 1),
  ($i133_2$Suspeitou de peritonite/sepse diante de febre + dor abdominal$i133_2$, 3, 2),
  ($i133_3$Reconheceu risco tromboembólico (edema assimétrico)$i133_3$, 2, 3),
  ($i133_4$Indicou avaliação urgente e tratamento adequado$i133_4$, 2, 4),
  ($i133_5$Orientou importância da adesão e cuidados com vacinas vivas no corticoide$i133_5$, 1, 5),
  ($i133_6$Comunicação clara da gravidade$i133_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t134$Diferenciar síndrome nefrítica de nefrótica$t134$,
    $e134$Nefrologia pediátrica$e134$,
    null,
    300,
    $q134$Você é solicitado a explicar a um estudante as diferenças entre as duas síndromes a partir de dois casos.$q134$,
    $res134$Você é solicitado a explicar a um estudante as diferenças entre as duas síndromes a partir de dois casos.
Conduza o raciocínio comparativo. ~5 min.$res134$,
    $p134$Estudante de medicina (avaliador faz o papel)$p134$,
    $ctx134$O estudante traz dois casos e pede para você diferenciar. Responda só ao que for perguntado.$ctx134$,
    jsonb_build_array(
      $r134$Caso 1: urina escura, edema discreto e pressão alta após faringite.$r134$,
      $r134$Caso 2: edema importante, urina espumosa e pressão normal.$r134$,
      $r134$Pergunta como diferenciar pelo complemento e pela urina.$r134$,
      $r134$Pergunta sobre as principais complicações de cada uma.$r134$
    ),
    $ach134$Caso 1 = padrão nefrítico (hematúria, HAS, C3 baixo). Caso 2 = padrão nefrótico (proteinúria maciça, hipoalbuminemia, C3 normal).$ach134$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'sindrome-nefritica-nefrotica')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('sindrome-nefritica-nefrotica')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i134_0$Apresentou-se e organizou o raciocínio$i134_0$, 1, 0),
  ($i134_1$Definiu nefrítica: inflamação glomerular, hematúria, HAS, oligúria$i134_1$, 2, 1),
  ($i134_2$Definiu nefrótica: proteinúria maciça, hipoalbuminemia, edema marcante$i134_2$, 2, 2),
  ($i134_3$Diferenciou pela urina (hematúria dismórfica × proteinúria espumosa)$i134_3$, 2, 3),
  ($i134_4$Diferenciou pelo complemento (C3 baixo na GNPE × normal na LM)$i134_4$, 2, 4),
  ($i134_5$Comparou complicações (HAS/IRA × infecção/trombose)$i134_5$, 2, 5),
  ($i134_6$Comunicação didática e organizada$i134_6$, 1, 6)
) as v(texto, grav, ord);
