-- Migracao automatica de cases.js -> Supabase (status em_revisao).
-- Gerado por gen_migracao_pediatria.js. Rodar DEPOIS de migracao_taxonomia_pediatria.sql.

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t100$Sangue nas fezes do bebê que mama no peito$t100$,
    $e100$APLV$e100$,
    null,
    300,
    $q100$Lactente de 2 meses em aleitamento materno com estrias de sangue nas fezes, mas em bom estado.$q100$,
    $res100$Ambulatório. Lactente de 2 meses em aleitamento materno com estrias de
sangue nas fezes, mas em bom estado. Avalie APLV e oriente. ~5 min.$res100$,
    $p100$Mãe de lactente, 2 meses$p100$,
    $ctx100$Mãe assustada com o sangue nas fezes. Responda ao que for perguntado.$ctx100$,
    jsonb_build_array(
      $r100$Fezes com raias de sangue e muco há cerca de 1 semana.$r100$,
      $r100$Bebê em aleitamento materno exclusivo, ativo e ganhando peso.$r100$,
      $r100$Sem febre, sem vômitos, sem distensão importante; um pouco mais irritado/cólicas.$r100$,
      $r100$A mãe consome bastante leite e derivados; há alergia/atopia na família.$r100$
    ),
    $ach100$Lactente em AME, bom estado geral, com sangue/muco nas fezes → proctocolite alérgica (APLV NÃO IgE mediada). Conduta: dieta de exclusão de leite de vaca e derivados da MÃE (mantendo a amamentação) e reavaliação.$ach100$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alergia-alimentar-aplv')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alergia-alimentar-aplv')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i100_0$Apresentou-se e caracterizou as fezes (sangue, muco, frequência)$i100_0$, 2, 0),
  ($i100_1$Avaliou estado geral, ganho de peso e hidratação$i100_1$, 2, 1),
  ($i100_2$Pesquisou sinais de gravidade (febre, vômitos, distensão, toxemia)$i100_2$, 2, 2),
  ($i100_3$Investigou dieta materna (leite/derivados) e atopia familiar$i100_3$, 2, 3),
  ($i100_4$Reconheceu proctocolite / APLV não IgE mediada$i100_4$, 3, 4),
  ($i100_5$Indicou EXCLUSÃO de leite de vaca e derivados da dieta MATERNA$i100_5$, 3, 5),
  ($i100_6$Orientou manter o aleitamento materno$i100_6$, 2, 6),
  ($i100_7$Orientou reavaliação e seguimento$i100_7$, 1, 7),
  ($i100_8$Comunicação clara e tranquilizadora$i100_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t101$Manchas no corpo após a fórmula$t101$,
    $e101$APLV$e101$,
    null,
    300,
    $q101$Lactente de 4 meses que apresentou urticária e inchaço logo após uma mamadeira de fórmula.$q101$,
    $res101$Lactente de 4 meses que apresentou urticária e inchaço logo após uma
mamadeira de fórmula. Avalie a reação e conduza. ~5 min.$res101$,
    $p101$Mãe de lactente, 4 meses$p101$,
    $ctx101$Mãe assustada com a reação súbita. Responda ao que for perguntado.$ctx101$,
    jsonb_build_array(
      $r101$Poucos minutos após a primeira fórmula: placas vermelhas, inchaço nos lábios e vômito.$r101$,
      $r101$Melhorou em algumas horas; dessa vez não teve falta de ar.$r101$,
      $r101$Estava em AME; introduziu fórmula porque achava que 'tinha pouco leite'.$r101$,
      $r101$Tem eczema; o pai tem rinite alérgica.$r101$
    ),
    $ach101$Reação imediata (minutos) com urticária, angioedema e vômito após proteína do leite de vaca → APLV IgE mediada, com risco de anafilaxia em novas exposições. Conduta: exclusão estrita, fórmula apropriada e plano para reações.$ach101$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alergia-alimentar-aplv')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alergia-alimentar-aplv')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i101_0$Apresentou-se e caracterizou a reação (tempo de início, sintomas)$i101_0$, 2, 0),
  ($i101_1$Diferenciou reação IMEDIATA (IgE) de tardia$i101_1$, 2, 1),
  ($i101_2$Pesquisou sinais de anafilaxia (respiratório, hipotonia, cardiovascular)$i101_2$, 3, 2),
  ($i101_3$Investigou atopia pessoal/familiar$i101_3$, 1, 3),
  ($i101_4$Reconheceu APLV IgE mediada$i101_4$, 2, 4),
  ($i101_5$Orientou exclusão estrita da proteína do leite de vaca$i101_5$, 3, 5),
  ($i101_6$Indicou fórmula adequada (hidrolisada/aminoácidos) ou AME com exclusão materna$i101_6$, 2, 6),
  ($i101_7$Orientou plano para reações e risco de anafilaxia$i101_7$, 2, 7),
  ($i101_8$Encaminhou ao alergologista / considerou testes$i101_8$, 1, 8),
  ($i101_9$Comunicação clara$i101_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t102$Qual fórmula usar na APLV$t102$,
    $e102$APLV$e102$,
    null,
    300,
    $q102$Lactente de 5 meses com diagnóstico de APLV, em uso de fórmula. A mãe trouxe uma "fórmula sem lactose".$q102$,
    $res102$Lactente de 5 meses com diagnóstico de APLV, em uso de fórmula. A mãe
trouxe uma "fórmula sem lactose". Oriente o manejo dietético correto. ~5 min.$res102$,
    $p102$Mãe de lactente, 5 meses (APLV)$p102$,
    $ctx102$Mãe acha que 'sem lactose' resolve. Responda ao que for perguntado.$ctx102$,
    jsonb_build_array(
      $r102$Diagnóstico de APLV; usava fórmula comum e agora comprou fórmula 'sem lactose'.$r102$,
      $r102$Pergunta se pode dar leite de cabra, 'leite' de soja de caixinha ou bebida vegetal.$r102$,
      $r102$Pergunta como ler os rótulos e sobre 'traços de leite'.$r102$
    ),
    $ach102$Erro comum: fórmula SEM LACTOSE não trata APLV (o problema é a proteína, não o açúcar). Indicar fórmula extensamente hidrolisada (1ª linha na maioria) ou de aminoácidos (casos graves/anafilaxia/falha). Leite de cabra e bebidas vegetais comuns não são adequados; ler rótulos (leite oculto).$ach102$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alergia-alimentar-aplv')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alergia-alimentar-aplv')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i102_0$Apresentou-se e revisou o diagnóstico e a dieta atual$i102_0$, 1, 0),
  ($i102_1$Explicou que 'sem lactose' NÃO trata APLV (proteína x açúcar)$i102_1$, 3, 1),
  ($i102_2$Indicou fórmula extensamente hidrolisada como 1ª linha$i102_2$, 3, 2),
  ($i102_3$Indicou fórmula de aminoácidos para casos graves/falha$i102_3$, 2, 3),
  ($i102_4$Desaconselhou leite de cabra e bebidas vegetais comuns$i102_4$, 2, 4),
  ($i102_5$Orientou leitura de rótulos e proteína do leite oculta$i102_5$, 2, 5),
  ($i102_6$Orientou manter o aporte nutricional (cálcio, crescimento)$i102_6$, 2, 6),
  ($i102_7$Orientou seguimento$i102_7$, 1, 7),
  ($i102_8$Comunicação didática$i102_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t103$Alergia ao leite ou intolerância à lactose?$t103$,
    $e103$APLV$e103$,
    null,
    300,
    $q103$Lactente de 7 meses com sintomas digestivos. A família mistura os conceitos de "alergia" e "intolerância".$q103$,
    $res103$Lactente de 7 meses com sintomas digestivos. A família mistura os
conceitos de "alergia" e "intolerância". Diferencie e oriente. ~5 min.$res103$,
    $p103$Pai de lactente, 7 meses$p103$,
    $ctx103$Pai cortou laticínios por conta própria. Responda ao que for perguntado.$ctx103$,
    jsonb_build_array(
      $r103$Distensão, gases e fezes amolecidas/explosivas relacionadas a laticínios.$r103$,
      $r103$A família acha que é tudo 'intolerância' e excluiu vários alimentos sozinha.$r103$,
      $r103$Se perguntado: já teve algum episódio de pele/sangue nas fezes? (explore).$r103$
    ),
    $ach103$Diferenciação: INTOLERÂNCIA À LACTOSE (deficiência de lactase: gases, distensão, diarreia ácida; rara como primária no lactente) x ALERGIA (APLV: resposta imune à proteína, pode ter pele, respiratório ou sangue nas fezes). A conduta depende do diagnóstico correto.$ach103$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alergia-alimentar-aplv')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alergia-alimentar-aplv')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i103_0$Apresentou-se e caracterizou os sintomas (digestivos, pele, respiratório)$i103_0$, 2, 0),
  ($i103_1$Diferenciou intolerância à lactose de alergia à proteína$i103_1$, 3, 1),
  ($i103_2$Explicou o mecanismo de cada uma (enzimático x imune)$i103_2$, 2, 2),
  ($i103_3$Avaliou a relação temporal e o tipo de sintoma$i103_3$, 2, 3),
  ($i103_4$Pesquisou sinais de APLV (sangue nas fezes, atopia, reação)$i103_4$, 2, 4),
  ($i103_5$Evitou exclusões dietéticas desnecessárias/sem critério$i103_5$, 2, 5),
  ($i103_6$Definiu conduta conforme a hipótese correta$i103_6$, 2, 6),
  ($i103_7$Orientou seguimento$i103_7$, 1, 7),
  ($i103_8$Comunicação didática$i103_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t104$Quando voltar a oferecer o leite$t104$,
    $e104$APLV$e104$,
    null,
    300,
    $q104$Lactente de 12 meses com APLV bem controlada há meses em dieta de exclusão. Os pais perguntam sobre reintrodução e prognóstico.$q104$,
    $res104$Lactente de 12 meses com APLV bem controlada há meses em dieta de
exclusão. Os pais perguntam sobre reintrodução e prognóstico. Oriente. ~5 min.$res104$,
    $p104$Pais de lactente, 12 meses (APLV)$p104$,
    $ctx104$Pais querem saber se um dia o filho poderá tomar leite. Façam perguntas.$ctx104$,
    jsonb_build_array(
      $r104$Diagnóstico de APLV (não IgE) aos 3 meses; em exclusão, sem sintomas há meses.$r104$,
      $r104$Perguntam: 'isso dura a vida toda?' e 'quando posso testar de novo?'.$r104$,
      $r104$Querem saber como fazer o teste e se podem testar em casa.$r104$
    ),
    $ach104$A maioria adquire TOLERÂNCIA (a APLV costuma resolver em boa parte até 1-3 anos, sobretudo as não IgE). Reintrodução guiada pelo médico (teste de provocação oral); formas IgE/anafilaxia exigem teste supervisionado em ambiente adequado — nunca em casa.$ach104$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alergia-alimentar-aplv')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alergia-alimentar-aplv')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i104_0$Apresentou-se e revisou a história e o tipo de APLV$i104_0$, 2, 0),
  ($i104_1$Explicou o bom prognóstico e a aquisição de tolerância$i104_1$, 2, 1),
  ($i104_2$Explicou o conceito de teste de provocação oral$i104_2$, 2, 2),
  ($i104_3$Definiu quando/como reintroduzir conforme o tipo (IgE x não IgE)$i104_3$, 3, 3),
  ($i104_4$Alertou que casos IgE/anafilaxia exigem teste supervisionado (não em casa)$i104_4$, 3, 4),
  ($i104_5$Orientou observar sintomas na reintrodução$i104_5$, 1, 5),
  ($i104_6$Orientou nutrição e seguimento$i104_6$, 1, 6),
  ($i104_7$Comunicação clara e tranquilizadora$i104_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t105$Vômitos intensos e palidez após a mamadeira$t105$,
    $e105$APLV$e105$,
    null,
    300,
    $q105$Lactente de 5 meses apresenta vômitos intensos e repetitivos, palidez e letargia cerca de 2 horas após receber fórmula infantil por primeira vez.$q105$,
    $res105$Pronto-socorro. Lactente de 5 meses apresenta vômitos intensos e
repetitivos, palidez e letargia cerca de 2 horas após receber fórmula infantil
por primeira vez. Avalie a FPIES. ~5 min.$res105$,
    $p105$Pais de lactente, 5 meses$p105$,
    $ctx105$Pais assustados com a rapidez e a intensidade da reação.$ctx105$,
    jsonb_build_array(
      $r105$Recebeu fórmula à base de leite de vaca por primeira vez há cerca de 2 horas.$r105$,
      $r105$Cerca de 1h30 depois, começou a vomitar repetidamente, ficou pálido e 'mole' (letárgico).$r105$,
      $r105$Sem urticária, sem angioedema, sem broncoespasmo/sibilância.$r105$,
      $r105$Achados (se solicitados): hipotensão leve, letargia importante, desidratação leve a moderada.$r105$,
      $r105$Já estava em aleitamento materno exclusivo até então, sem sintomas prévios.$r105$
    ),
    $ach105$Quadro compatível com FPIES (síndrome da enterocolite induzida por proteína alimentar) na forma aguda: vômitos intensos e repetitivos, letargia, palidez e podendo cursar com hipotensão, iniciando 1-4 horas após a ingestão do alimento desencadeante (leite de vaca), na AUSÊNCIA de sintomas cutâneos/respiratórios típicos de reação IgE-mediada. Manejo agudo: hidratação/estabilização hemodinâmica; dieta de exclusão da proteína do leite de vaca; IgE específica geralmente não é útil (mecanismo não IgE-mediado).$ach105$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alergia-alimentar-aplv')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alergia-alimentar-aplv')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i105_0$Caracterizou o tempo entre ingestão e início dos sintomas (1-4h)$i105_0$, 2, 0),
  ($i105_1$Identificou a ausência de sintomas cutâneos/respiratórios (não IgE-mediado)$i105_1$, 2, 1),
  ($i105_2$Reconheceu o padrão clínico de FPIES (vômitos, letargia, palidez, hipotensão)$i105_2$, 3, 2),
  ($i105_3$Indicou estabilização hemodinâmica/hidratação como prioridade aguda$i105_3$, 2, 3),
  ($i105_4$Indicou exclusão da proteína do leite de vaca da dieta$i105_4$, 2, 4),
  ($i105_5$Reconheceu que IgE específica não é útil neste quadro$i105_5$, 1, 5),
  ($i105_6$Comunicação clara sobre a gravidade aguda e o seguimento$i105_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t106$Diarreia crônica e baixo ganho de peso$t106$,
    $e106$APLV$e106$,
    null,
    300,
    $q106$Lactente de 4 meses, em uso de fórmula infantil, com diarreia crônica e ganho de peso insuficiente.$q106$,
    $res106$Ambulatório. Lactente de 4 meses, em uso de fórmula infantil, com
diarreia crônica e ganho de peso insuficiente. Avalie a enteropatia induzida
pela proteína do leite de vaca. ~5 min.$res106$,
    $p106$Mãe de lactente, 4 meses$p106$,
    $ctx106$Mãe preocupada com o baixo ganho de peso do bebê.$ctx106$,
    jsonb_build_array(
      $r106$Diarreia persistente há mais de 3 semanas, fezes amolecidas, sem sangue visível.$r106$,
      $r106$Em uso de fórmula infantil padrão (leite de vaca) desde os 2 meses.$r106$,
      $r106$Curva de peso estacionária nas últimas semanas, abaixo do esperado.$r106$,
      $r106$Sem vômitos importantes, sem distensão abdominal exuberante, sem febre.$r106$,
      $r106$Exames (se pedidos): sinais de má absorção leve, sem sangue oculto positivo, IgE específica negativa.$r106$
    ),
    $ach106$Enteropatia induzida por proteína alimentar (forma não IgE-mediada e crônica de alergia ao leite de vaca): diarreia crônica associada a sinais de má absorção e déficit de ganho ponderal, em uso de fórmula com proteína do leite de vaca, com IgE específica negativa (mecanismo não IgE-mediado). Diagnóstico confirmado pela melhora clínica com dieta de exclusão (2-4 semanas) e recidiva dos sintomas com a reexposição.$ach106$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alergia-alimentar-aplv')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alergia-alimentar-aplv')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i106_0$Caracterizou a diarreia crônica e o impacto no ganho de peso$i106_0$, 2, 0),
  ($i106_1$Investigou a relação temporal com a fórmula à base de leite de vaca$i106_1$, 2, 1),
  ($i106_2$Reconheceu que IgE específica negativa não exclui alergia não IgE-mediada$i106_2$, 2, 2),
  ($i106_3$Reconheceu a enteropatia como diagnóstico (forma crônica não IgE)$i106_3$, 3, 3),
  ($i106_4$Indicou dieta de exclusão por 2-4 semanas como teste diagnóstico$i106_4$, 3, 4),
  ($i106_5$Planejou reexposição controlada para confirmar o diagnóstico$i106_5$, 1, 5),
  ($i106_6$Comunicação clara e didática$i106_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t107$Sangue nas fezes do bebê amamentado exclusivamente$t107$,
    $e107$APLV$e107$,
    null,
    300,
    $q107$Lactente de 2 meses em aleitamento materno exclusivo apresenta raias de sangue nas fezes.$q107$,
    $res107$Ambulatório. Lactente de 2 meses em aleitamento materno exclusivo
apresenta raias de sangue nas fezes. Avalie a possível APLV via dieta materna. ~5 min.$res107$,
    $p107$Mãe de lactente, 2 meses, em aleitamento materno exclusivo$p107$,
    $ctx107$Mãe assustada ao ver sangue nas fezes do bebê.$ctx107$,
    jsonb_build_array(
      $r107$Notou raias de sangue vivo misturadas a fezes de consistência normal/levemente amolecida.$r107$,
      $r107$Bebê em aleitamento materno exclusivo, sem nenhuma fórmula ou outro alimento.$r107$,
      $r107$Bebê ganhando peso bem, ativo, sem outros sintomas (sem vômitos importantes, sem distensão).$r107$,
      $r107$Mãe consome leite e derivados normalmente na própria dieta.$r107$,
      $r107$Pergunta se precisa parar de amamentar.$r107$
    ),
    $ach107$Proctocolite alérgica induzida por proteína alimentar (FPIAP) pode ocorrer mesmo em bebês exclusivamente amamentados, por sensibilização a proteínas alimentares (como a do leite de vaca) presentes na dieta materna e transferidas pelo leite. Apresenta-se tipicamente no primeiro semestre com sangue nas fezes em lactente com bom estado geral e ganho de peso adequado. Conduta: NÃO interromper o aleitamento materno — orientar exclusão da proteína do leite de vaca (e derivados) da dieta materna, com reavaliação da resposta.$ach107$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alergia-alimentar-aplv')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alergia-alimentar-aplv')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i107_0$Caracterizou o sangramento e o bom estado geral do bebê$i107_0$, 2, 0),
  ($i107_1$Confirmou o aleitamento materno exclusivo e investigou a dieta materna$i107_1$, 2, 1),
  ($i107_2$Reconheceu a possibilidade de FPIAP via leite materno$i107_2$, 3, 2),
  ($i107_3$Orientou que o aleitamento materno NÃO deve ser interrompido$i107_3$, 3, 3),
  ($i107_4$Indicou exclusão da proteína do leite de vaca da dieta materna$i107_4$, 2, 4),
  ($i107_5$Programou reavaliação da resposta à exclusão$i107_5$, 1, 5),
  ($i107_6$Comunicação tranquilizadora$i107_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t108$Como confirmar se ainda tem alergia ao leite?$t108$,
    $e108$APLV$e108$,
    null,
    300,
    $q108$Criança de 2 anos com diagnóstico prévio de APLV IgE-mediada pergunta-se se já pode reintroduzir o leite de vaca.$q108$,
    $res108$Ambulatório. Criança de 2 anos com diagnóstico prévio de APLV
IgE-mediada pergunta-se se já pode reintroduzir o leite de vaca. Explique o
papel do teste de provocação oral (TPO). ~5 min.$res108$,
    $p108$Pais de criança de 2 anos com APLV IgE-mediada prévia$p108$,
    $ctx108$Pais quiseram testar leite em casa, mas foram orientados a não fazer isso.$ctx108$,
    jsonb_build_array(
      $r108$Diagnóstico de APLV IgE-mediada (urticária e angioedema) há 1 ano, em dieta de exclusão desde então.$r108$,
      $r108$IgE específica para proteína do leite, repetida recentemente, com queda importante em relação ao exame inicial.$r108$,
      $r108$Pais perguntam: 'já podemos testar um pouco de leite em casa para ver se passou?'$r108$,
      $r108$Sem sintomas há 1 ano, mas nunca reexpuseram a criança.$r108$
    ),
    $ach108$O teste de provocação oral (TPO), realizado em ambiente controlado/hospitalar com supervisão médica e suporte para tratar eventual reação (incluindo anafilaxia), é o exame definitivo para confirmar resolução ou persistência da alergia alimentar — a queda da IgE específica é um indício favorável, mas não substitui o TPO. Reexposição em casa é contraindicada em alergia IgE-mediada pelo risco de reação grave imprevisível.$ach108$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alergia-alimentar-aplv')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alergia-alimentar-aplv')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i108_0$Revisou o diagnóstico prévio (IgE-mediado) e a evolução da IgE específica$i108_0$, 2, 0),
  ($i108_1$Explicou que a queda da IgE específica é favorável mas não conclusiva$i108_1$, 2, 1),
  ($i108_2$Indicou o teste de provocação oral como exame definitivo$i108_2$, 3, 2),
  ($i108_3$Explicou que o TPO deve ser feito em ambiente controlado/hospitalar$i108_3$, 3, 3),
  ($i108_4$Contraindicou a reexposição em casa pelo risco de reação grave$i108_4$, 3, 4),
  ($i108_5$Comunicação clara sobre os riscos e a necessidade de supervisão$i108_5$, 1, 5)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t109$Reação grave após mamadeira$t109$,
    $e109$APLV$e109$,
    null,
    300,
    $q109$Lactente de 6 meses com urticária generalizada, edema labial e dificuldade respiratória minutos após receber fórmula infantil por primeira vez.$q109$,
    $res109$Pronto-socorro. Lactente de 6 meses com urticária generalizada,
edema labial e dificuldade respiratória minutos após receber fórmula infantil
por primeira vez. Conduza a anafilaxia e oriente a fórmula de substituição. ~5 min.$res109$,
    $p109$Pais de lactente, 6 meses$p109$,
    $ctx109$Reação ocorreu minutos após a primeira mamadeira de fórmula. Informe achados quando solicitados.$ctx109$,
    jsonb_build_array(
      $r109$Cerca de 15 minutos após receber fórmula à base de leite de vaca por primeira vez: urticária generalizada, edema labial, e leve dificuldade respiratória com sibilância.$r109$,
      $r109$Achados (se solicitados): taquicardia, SatO2 levemente reduzida, estridor leve.$r109$,
      $r109$Sem perda de consciência, mas com aspecto de desconforto importante.$r109$,
      $r109$Pais perguntam o que vai acontecer agora e se o bebê 'nunca mais vai poder tomar leite'.$r109$
    ),
    $ach109$Quadro de anafilaxia por APLV IgE-mediada (envolvimento cutâneo + respiratório, início em minutos): tratamento imediato com ADRENALINA intramuscular é a prioridade, seguida de suporte (oxigênio, broncodilatador se sibilância, observação prolongada pelo risco de reação bifásica). Após estabilização, eleita fórmula de substituição: em alergia IgE-mediada grave/anafilaxia, a fórmula extensamente hidrolisada pode ser insuficiente — fórmula de aminoácidos é a indicada nesses casos.$ach109$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alergia-alimentar-aplv')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alergia-alimentar-aplv')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i109_0$Reconheceu o quadro como anafilaxia (cutâneo + respiratório)$i109_0$, 3, 0),
  ($i109_1$Indicou adrenalina intramuscular como tratamento de primeira linha$i109_1$, 3, 1),
  ($i109_2$Indicou suporte adicional (O2, broncodilatador, observação prolongada)$i109_2$, 2, 2),
  ($i109_3$Considerou o risco de reação bifásica$i109_3$, 1, 3),
  ($i109_4$Indicou fórmula de aminoácidos como substituta após anafilaxia$i109_4$, 3, 4),
  ($i109_5$Orientou seguimento com alergologista e plano de ação de emergência$i109_5$, 1, 5),
  ($i109_6$Comunicação clara sobre a gravidade e o manejo futuro$i109_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t155$Sangue nas fezes do lactente — FPIAP$t155$,
    $e155$Alergia / Gastropediatria$e155$,
    null,
    300,
    $q155$Lactente de 2 meses saudável, com raias de sangue nas fezes.$q155$,
    $res155$Lactente de 2 meses saudável, com raias de sangue nas fezes.
Avalie, levante FPIAP e oriente conduta. ~5 min.$res155$,
    $p155$Mãe de lactente de 2 meses$p155$,
    $ctx155$Mãe assustada com sangue nas fezes. Responda só ao que for perguntado.$ctx155$,
    jsonb_build_array(
      $r155$Notou raias de sangue vermelho-vivo nas fezes, com um pouco de muco.$r155$,
      $r155$O bebê está bem, mamando no peito, ganhando peso e sem febre.$r155$,
      $r155$Ela consome bastante leite e derivados.$r155$,
      $r155$Sem vômitos importantes nem distensão.$r155$
    ),
    $ach155$Lactente saudável, bom ganho ponderal; raias de sangue e muco nas fezes em AME — compatível com FPIAP (proctocolite alérgica).$ach155$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alergia-alimentar-aplv')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alergia-alimentar-aplv')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i155_0$Apresentou-se e identificou criança/responsável$i155_0$, 1, 0),
  ($i155_1$Caracterizou as fezes (sangue/muco) e confirmou bom estado geral$i155_1$, 2, 1),
  ($i155_2$Reconheceu FPIAP em lactente saudável no 1º semestre$i155_2$, 3, 2),
  ($i155_3$Explicou que ocorre mesmo em AME (proteínas na dieta materna)$i155_3$, 2, 3),
  ($i155_4$Orientou exclusão de leite/derivados da dieta materna (2–4 semanas)$i155_4$, 2, 4),
  ($i155_5$Explicou diagnóstico clínico (melhora na exclusão, recidiva na reexposição)$i155_5$, 1, 5),
  ($i155_6$Comunicação empática e tranquilizadora$i155_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t156$FPIES aguda — reconhecer a emergência$t156$,
    $e156$Alergia / Gastropediatria$e156$,
    null,
    300,
    $q156$Lactente com vômitos intensos, palidez e letargia cerca de 2 horas após fórmula.$q156$,
    $res156$Lactente com vômitos intensos, palidez e letargia cerca de 2 horas após fórmula.
Avalie, reconheça FPIES e conduza. ~5 min.$res156$,
    $p156$Mãe de lactente de 5 meses$p156$,
    $ctx156$Mãe muito assustada com o episódio. Responda só ao que for perguntado.$ctx156$,
    jsonb_build_array(
      $r156$Cerca de 2 horas após receber fórmula, começou com vômitos repetidos e fortes.$r156$,
      $r156$Ficou pálido, mole e sonolento.$r156$,
      $r156$Já havia acontecido algo parecido antes com fórmula.$r156$,
      $r156$Sem urticária ou chiado naquele momento.$r156$
    ),
    $ach156$Vômitos profusos 1–4h após proteína, palidez, letargia e hipotonia (possível hipotensão) — FPIES aguda.$ach156$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alergia-alimentar-aplv')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alergia-alimentar-aplv')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i156_0$Apresentou-se e avaliou rapidamente o lactente$i156_0$, 1, 0),
  ($i156_1$Caracterizou a relação temporal (1–4h) e os vômitos profusos$i156_1$, 2, 1),
  ($i156_2$Reconheceu FPIES como emergência potencial (letargia, hipotensão)$i156_2$, 3, 2),
  ($i156_3$Indicou suporte: hidratação/reposição volêmica e observação$i156_3$, 2, 3),
  ($i156_4$Diferenciou de reação IgE-mediada (sem urticária/anafilaxia típica)$i156_4$, 2, 4),
  ($i156_5$Orientou exclusão do alérgeno e seguimento especializado$i156_5$, 1, 5),
  ($i156_6$Comunicação clara da gravidade$i156_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t157$Escolha da fórmula na APLV$t157$,
    $e157$Alergia / Gastropediatria$e157$,
    null,
    300,
    $q157$Lactente de 4 meses em fórmula com diagnóstico de APLV; a mãe pergunta qual fórmula usar.$q157$,
    $res157$Lactente de 4 meses em fórmula com diagnóstico de APLV; a mãe pergunta qual fórmula usar.
Oriente a escolha. ~5 min.$res157$,
    $p157$Mãe de lactente de 4 meses$p157$,
    $ctx157$Mãe quer saber qual fórmula é a certa. Responda só ao que for perguntado.$ctx157$,
    jsonb_build_array(
      $r157$O bebê não mama no peito e usa fórmula de leite de vaca.$r157$,
      $r157$Teve diagnóstico de APLV; a mãe ouviu falar de 'soja' e 'fórmulas especiais'.$r157$,
      $r157$Pergunta se pode dar fórmula de soja.$r157$,
      $r157$Quer saber quando se usa a fórmula de aminoácidos.$r157$
    ),
    $ach157$APLV confirmada; necessidade de substituir a fórmula por opção apropriada conforme gravidade.$ach157$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alergia-alimentar-aplv')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alergia-alimentar-aplv')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i157_0$Apresentou-se e identificou criança/responsável$i157_0$, 1, 0),
  ($i157_1$Indicou fórmula extensamente hidrolisada (FEH) como primeira opção em muitos casos$i157_1$, 3, 1),
  ($i157_2$Indicou fórmula de aminoácidos em falha da FEH/anafilaxia/FPIES/alergias múltiplas$i157_2$, 2, 2),
  ($i157_3$Explicou que soja só após 6 meses e sem alergia à soja$i157_3$, 2, 3),
  ($i157_4$Reforçou adequação nutricional e leitura de rótulos$i157_4$, 1, 4),
  ($i157_5$Orientou acompanhamento e não usar leites inadequados$i157_5$, 1, 5),
  ($i157_6$Comunicação clara$i157_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t158$Dieta materna de exclusão no aleitamento$t158$,
    $e158$Alergia / Gastropediatria$e158$,
    null,
    300,
    $q158$Lactente em AME com APLV (forma não IgE); a mãe precisa excluir leite da dieta.$q158$,
    $res158$Lactente em AME com APLV (forma não IgE); a mãe precisa excluir leite da dieta.
Oriente a exclusão materna com segurança nutricional. ~5 min.$res158$,
    $p158$Mãe de lactente de 3 meses$p158$,
    $ctx158$Mãe disposta a manter o peito. Responda só ao que for perguntado.$ctx158$,
    jsonb_build_array(
      $r158$O bebê melhorou os sintomas quando ela reduziu leite, mas ela está insegura.$r158$,
      $r158$Quer continuar amamentando.$r158$,
      $r158$Pergunta se ela precisa de algum cuidado com a própria alimentação.$r158$,
      $r158$Tem dúvida sobre cálcio e vitaminas.$r158$
    ),
    $ach158$APLV não IgE em AME; resposta à exclusão materna; necessidade de suporte nutricional da mãe.$ach158$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alergia-alimentar-aplv')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alergia-alimentar-aplv')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i158_0$Apresentou-se e identificou criança/responsável$i158_0$, 1, 0),
  ($i158_1$Indicou manter o aleitamento materno$i158_1$, 2, 1),
  ($i158_2$Orientou exclusão de leite de vaca e derivados na dieta materna$i158_2$, 3, 2),
  ($i158_3$Orientou suplementação de cálcio e vitamina D para a mãe$i158_3$, 2, 3),
  ($i158_4$Explicou avaliação por exclusão (2–4 semanas) e reexposição$i158_4$, 1, 4),
  ($i158_5$Orientou leitura de rótulos e acompanhamento nutricional$i158_5$, 1, 5),
  ($i158_6$Comunicação empática e de apoio à amamentação$i158_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t159$Diferenciar refluxo de APLV no lactente$t159$,
    $e159$Alergia / Gastropediatria$e159$,
    null,
    300,
    $q159$Lactente de 2 meses com regurgitação, irritabilidade e algumas fezes com muco/sangue.$q159$,
    $res159$Lactente de 2 meses com regurgitação, irritabilidade e algumas fezes com muco/sangue.
Diferencie RGE fisiológico, DRGE e APLV. ~5 min.$res159$,
    $p159$Mãe de lactente de 2 meses$p159$,
    $ctx159$Mãe confusa entre 'refluxo' e 'alergia'. Responda só ao que for perguntado.$ctx159$,
    jsonb_build_array(
      $r159$Golfa após mamar e às vezes fica irritado durante as mamadas.$r159$,
      $r159$Notou muco e, em alguns dias, raias de sangue nas fezes.$r159$,
      $r159$Tem dermatite no rosto; a mãe consome bastante leite.$r159$,
      $r159$O ganho de peso está no limite.$r159$
    ),
    $ach159$Regurgitação com irritabilidade, muco/sangue nas fezes e dermatite — sugere componente de APLV além de RGE.$ach159$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alergia-alimentar-aplv')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alergia-alimentar-aplv')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i159_0$Apresentou-se e identificou criança/responsável$i159_0$, 1, 0),
  ($i159_1$Caracterizou regurgitação, irritabilidade e fezes (muco/sangue)$i159_1$, 2, 1),
  ($i159_2$Diferenciou RGE fisiológico de DRGE$i159_2$, 2, 2),
  ($i159_3$Reconheceu sinais sugestivos de APLV (sangue nas fezes, atopia)$i159_3$, 3, 3),
  ($i159_4$Propôs exclusão de leite (dieta materna/fórmula) como teste diagnóstico$i159_4$, 2, 4),
  ($i159_5$Evitou medicação antirrefluxo desnecessária$i159_5$, 1, 5),
  ($i159_6$Comunicação clara e empática$i159_6$, 1, 6)
) as v(texto, grav, ord);
