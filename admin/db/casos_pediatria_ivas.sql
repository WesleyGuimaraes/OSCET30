-- Migracao automatica de cases.js -> Supabase (status em_revisao).
-- Gerado por gen_migracao_pediatria.js. Rodar DEPOIS de migracao_taxonomia_pediatria.sql.

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t70$Criança com coriza e tosse$t70$,
    $e70$IVAS$e70$,
    null,
    300,
    $q70$Pré-escolar de 3 anos com coriza, tosse e febre baixa há 3 dias.$q70$,
    $res70$Ambulatório. Pré-escolar de 3 anos com coriza, tosse e febre baixa há
3 dias. Avalie, defina a conduta e oriente. ~5 min.$res70$,
    $p70$Mãe de criança, 3 anos$p70$,
    $ctx70$Mãe quer 'antibiótico para cortar'. Responda ao que for perguntado.$ctx70$,
    jsonb_build_array(
      $r70$Coriza, tosse, espirros e febre baixa há 2-3 dias.$r70$,
      $r70$Come e bebe razoavelmente, fica ativo nos intervalos da febre.$r70$,
      $r70$Frequenta creche e já teve vários 'resfriados' este ano.$r70$,
      $r70$Sem falta de ar; sem dor de ouvido importante.$r70$
    ),
    $ach70$IVAS viral (resfriado comum): coriza, tosse, febre baixa, bom estado geral. Oroscopia e otoscopia sem sinais bacterianos. Antibiótico não indicado.$ach70$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ivas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ivas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i70_0$Apresentou-se e caracterizou os sintomas (duração, febre, secreção)$i70_0$, 2, 0),
  ($i70_1$Avaliou estado geral, hidratação e alimentação$i70_1$, 2, 1),
  ($i70_2$Pesquisou sinais de complicação (dispneia, otalgia, febre persistente)$i70_2$, 2, 2),
  ($i70_3$Examinou orofaringe e fez otoscopia$i70_3$, 1, 3),
  ($i70_4$Reconheceu IVAS viral (resfriado comum)$i70_4$, 2, 4),
  ($i70_5$Explicou que antibiótico não está indicado$i70_5$, 2, 5),
  ($i70_6$Orientou sintomáticos e hidratação (lavagem nasal, antitérmico)$i70_6$, 2, 6),
  ($i70_7$Orientou sinais de alarme e evolução esperada$i70_7$, 2, 7),
  ($i70_8$Comunicação clara, manejando a expectativa de antibiótico$i70_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t71$Dor de garganta e febre alta$t71$,
    $e71$IVAS$e71$,
    null,
    300,
    $q71$Escolar de 7 anos com dor de garganta intensa e febre alta.$q71$,
    $res71$Ambulatório. Escolar de 7 anos com dor de garganta intensa e febre alta.
Diferencie faringite viral de estreptocócica e defina a conduta. ~5 min.$res71$,
    $p71$Pai de escolar, 7 anos$p71$,
    $ctx71$Pai relata febre alta. Informe os achados do exame quando solicitados.$ctx71$,
    jsonb_build_array(
      $r71$Dor de garganta forte e dor para engolir, febre alta há 2 dias.$r71$,
      $r71$Importante: SEM tosse e SEM coriza.$r71$,
      $r71$Achados: amígdalas hiperemiadas com placas/exsudato; gânglios do pescoço dolorosos.$r71$,
      $r71$Teve dor de barriga e um episódio de vômito.$r71$
    ),
    $ach71$Faringoamigdalite com exsudato, adenopatia cervical anterior dolorosa, febre e ausência de tosse/coriza (Centor alto) → provável estreptocócica. Confirmar com teste rápido/cultura se disponível; tratar com penicilina/amoxicilina.$ach71$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ivas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ivas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i71_0$Apresentou-se e caracterizou a dor de garganta e a febre$i71_0$, 2, 0),
  ($i71_1$Pesquisou a ausência de tosse/coriza (critérios de Centor)$i71_1$, 2, 1),
  ($i71_2$Examinou orofaringe (exsudato) e linfonodos cervicais$i71_2$, 2, 2),
  ($i71_3$Aplicou escore clínico (Centor/McIsaac)$i71_3$, 2, 3),
  ($i71_4$Considerou teste rápido/cultura para estreptococo$i71_4$, 2, 4),
  ($i71_5$Reconheceu provável faringite estreptocócica$i71_5$, 2, 5),
  ($i71_6$Prescreveu antibiótico adequado (penicilina/amoxicilina)$i71_6$, 2, 6),
  ($i71_7$Explicou a importância do tratamento (prevenir febre reumática)$i71_7$, 2, 7),
  ($i71_8$Orientou sintomáticos e sinais de alarme$i71_8$, 1, 8),
  ($i71_9$Comunicação clara$i71_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t72$Criança com dor de ouvido$t72$,
    $e72$IVAS$e72$,
    null,
    300,
    $q72$Criança de 2 anos com dor de ouvido, febre e irritabilidade depois de um resfriado.$q72$,
    $res72$Ambulatório. Criança de 2 anos com dor de ouvido, febre e irritabilidade
depois de um resfriado. Avalie a otite média aguda e defina a conduta. ~5 min.$res72$,
    $p72$Mãe de criança, 2 anos$p72$,
    $ctx72$Mãe relata criança chorosa. Informe a otoscopia quando solicitada.$ctx72$,
    jsonb_build_array(
      $r72$Depois de alguns dias de resfriado: febre, irritabilidade e dor de ouvido.$r72$,
      $r72$Leva a mão à orelha direita, dorme mal e come menos.$r72$,
      $r72$Achados: à otoscopia, membrana timpânica direita abaulada, hiperemiada e opaca.$r72$,
      $r72$Sem secreção saindo do ouvido (sem otorreia).$r72$
    ),
    $ach72$Otite média aguda: membrana timpânica abaulada, hiperemiada e opaca, com otalgia e febre após IVAS. Conduta: analgesia sempre; amoxicilina conforme idade/gravidade (ou observação em casos selecionados).$ach72$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ivas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ivas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i72_0$Apresentou-se e caracterizou a otalgia e a febre$i72_0$, 2, 0),
  ($i72_1$Relacionou ao quadro de IVAS prévio$i72_1$, 1, 1),
  ($i72_2$Realizou/valorizou a otoscopia (membrana abaulada/hiperemiada)$i72_2$, 3, 2),
  ($i72_3$Pesquisou otorreia e sinais de complicação (mastoidite)$i72_3$, 2, 3),
  ($i72_4$Reconheceu a otite média aguda$i72_4$, 2, 4),
  ($i72_5$Priorizou a ANALGESIA$i72_5$, 2, 5),
  ($i72_6$Definiu antibiótico (amoxicilina) x observação conforme critérios$i72_6$, 2, 6),
  ($i72_7$Orientou sinais de alarme e reavaliação$i72_7$, 1, 7),
  ($i72_8$Comunicação clara$i72_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t73$Resfriado que não melhora$t73$,
    $e73$IVAS$e73$,
    null,
    300,
    $q73$Escolar de 8 anos com coriza e tosse há 12 dias, sem melhora.$q73$,
    $res73$Ambulatório. Escolar de 8 anos com coriza e tosse há 12 dias, sem
melhora. Diferencie rinossinusite bacteriana de viral e oriente. ~5 min.$res73$,
    $p73$Mãe de escolar, 8 anos$p73$,
    $ctx73$Mãe diz que 'o resfriado não passa'. Responda ao que for perguntado.$ctx73$,
    jsonb_build_array(
      $r73$Coriza (agora amarelo-esverdeada) e tosse há 12 dias, sem melhorar.$r73$,
      $r73$Tosse pior à noite, congestão nasal, mau hálito e febre baixa arrastada.$r73$,
      $r73$Se perguntado: chegou a melhorar e depois piorou de novo.$r73$,
      $r73$Sem inchaço/vermelhidão ao redor do olho; sem alteração visual.$r73$
    ),
    $ach73$Sintomas de IVAS persistentes >10 dias sem melhora (ou piora após melhora) → rinossinusite bacteriana aguda. Sem sinais de complicação (celulite orbitária, neurológicos). Tratamento: amoxicilina.$ach73$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ivas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ivas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i73_0$Apresentou-se e caracterizou a duração e a evolução dos sintomas$i73_0$, 2, 0),
  ($i73_1$Identificou critério de persistência >10 dias / dupla piora$i73_1$, 3, 1),
  ($i73_2$Pesquisou sinais de complicação (edema/dor periorbitária, visual, neurológico)$i73_2$, 2, 2),
  ($i73_3$Examinou as vias aéreas superiores$i73_3$, 1, 3),
  ($i73_4$Reconheceu a rinossinusite bacteriana aguda$i73_4$, 2, 4),
  ($i73_5$Diferenciou de quadro viral$i73_5$, 2, 5),
  ($i73_6$Prescreveu antibiótico adequado (amoxicilina)$i73_6$, 2, 6),
  ($i73_7$Orientou lavagem nasal e sintomáticos$i73_7$, 1, 7),
  ($i73_8$Orientou sinais de alarme$i73_8$, 1, 8),
  ($i73_9$Comunicação clara$i73_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t74$Criança com tosse 'de cachorro'$t74$,
    $e74$IVAS$e74$,
    null,
    300,
    $q74$Pré-escolar de 2 anos com tosse "de cachorro", rouquidão e ruído ao respirar, à noite.$q74$,
    $res74$Pronto-socorro. Pré-escolar de 2 anos com tosse "de cachorro",
rouquidão e ruído ao respirar, à noite. Avalie o crupe e conduza. ~5 min.$res74$,
    $p74$Mãe de criança, 2 anos$p74$,
    $ctx74$Mãe assustada com o ruído na respiração. Informe achados quando solicitados.$ctx74$,
    jsonb_build_array(
      $r74$Começou à noite: tosse ladrante, voz rouca e ruído (estridor) ao inspirar.$r74$,
      $r74$Teve coriza nos dias anteriores e febre baixa.$r74$,
      $r74$Achados: estridor inspiratório, tiragem leve quando agita, melhora em repouso, saturação normal.$r74$,
      $r74$Sem baba/salivação intensa, consegue engolir; vacinas em dia.$r74$
    ),
    $ach74$Laringotraqueíte viral (crupe): tosse ladrante, rouquidão e estridor inspiratório, em geral noturnos, após pródromo de IVAS. Avaliar gravidade (estridor em repouso, tiragem). Conduta: corticoide (dexametasona); adrenalina nebulizada se moderado/grave.$ach74$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ivas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ivas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i74_0$Apresentou-se e caracterizou tosse ladrante, rouquidão e estridor$i74_0$, 2, 0),
  ($i74_1$Avaliou a gravidade (estridor em repouso, tiragem, saturação, estado geral)$i74_1$, 3, 1),
  ($i74_2$Diferenciou de epiglotite/corpo estranho (salivação, início, vacinação)$i74_2$, 2, 2),
  ($i74_3$Reconheceu o crupe viral (laringotraqueíte)$i74_3$, 2, 3),
  ($i74_4$Indicou corticoide (dexametasona)$i74_4$, 3, 4),
  ($i74_5$Indicou adrenalina nebulizada se moderado/grave$i74_5$, 2, 5),
  ($i74_6$Orientou observação e medidas de conforto$i74_6$, 1, 6),
  ($i74_7$Orientou sinais de alarme para retorno$i74_7$, 2, 7),
  ($i74_8$Comunicação tranquilizadora$i74_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t75$'Ele tá sempre gripado', isso é normal?$t75$,
    $e75$IVAS$e75$,
    null,
    300,
    $q75$Mãe de criança de 3 anos que frequenta a creche está preocupada porque ele "está sempre resfriado".$q75$,
    $res75$Ambulatório. Mãe de criança de 3 anos que frequenta a creche está
preocupada porque ele "está sempre resfriado". Avalie a frequência esperada de
IVAS e oriente. ~5 min.$res75$,
    $p75$Mãe de criança de 3 anos$p75$,
    $ctx75$Mãe acha que algo está errado com a imunidade do filho.$ctx75$,
    jsonb_build_array(
      $r75$Criança teve cerca de 8 resfriados nos últimos 12 meses, desde que entrou na creche.$r75$,
      $r75$Cada episódio dura entre 7-10 dias, com resolução completa entre eles.$r75$,
      $r75$Sem sinais de gravidade nos episódios (sem necessidade de internação, sem pneumonia).$r75$,
      $r75$Pergunta se precisa investigar a imunidade ou tomar algum 'fortalecedor'.$r75$,
      $r75$Desenvolvimento e crescimento normais; vacinação em dia.$r75$
    ),
    $ach75$Crianças menores de 5 anos, especialmente as que frequentam creche, apresentam normalmente entre 5 e 14 episódios de IVAS por ano — frequência alta é esperada nessa faixa etária por imaturidade imunológica e maior exposição. Sem sinais de alarme (infecções graves, necessidade de internação, complicações recorrentes), não há indicação de investigação imunológica nem de imunoestimulantes.$ach75$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ivas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ivas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i75_0$Quantificou o número de episódios no último ano$i75_0$, 2, 0),
  ($i75_1$Avaliou a gravidade e a resolução completa entre os episódios$i75_1$, 2, 1),
  ($i75_2$Informou a frequência esperada para a idade (5-14 episódios/ano)$i75_2$, 3, 2),
  ($i75_3$Relacionou a frequência à creche e à imaturidade imunológica$i75_3$, 2, 3),
  ($i75_4$Descartou sinais de alarme que indicariam investigação$i75_4$, 2, 4),
  ($i75_5$Desencorajou uso de 'imunoestimulantes' sem indicação$i75_5$, 1, 5),
  ($i75_6$Comunicação tranquilizadora$i75_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t76$Otite média aguda: tratar com antibiótico já?$t76$,
    $e76$IVAS$e76$,
    null,
    300,
    $q76$Criança de 3 anos com otalgia leve há 12 horas.$q76$,
    $res76$Ambulatório. Criança de 3 anos com otalgia leve há 12 horas. Avalie
se a conduta expectante (observação) é apropriada neste caso de OMA. ~5 min.$res76$,
    $p76$Mãe de criança de 3 anos$p76$,
    $ctx76$Mãe espera que o médico já passe um antibiótico.$ctx76$,
    jsonb_build_array(
      $r76$Otalgia leve iniciada há 12 horas, sem otorreia.$r76$,
      $r76$Febre baixa (37,8°C), criança ativa, brincando, mamando/comendo bem.$r76$,
      $r76$Achados à otoscopia (se solicitados): membrana timpânica hiperemiada e discretamente abaulada, sem otorreia.$r76$,
      $r76$Sem otite anterior recorrente, sem fatores de risco adicionais (sem fenda palatina, sem imunodeficiência).$r76$,
      $r76$Mãe pergunta: 'não vai dar antibiótico hoje?'$r76$
    ),
    $ach76$Em crianças ≥2 anos com OMA unilateral, sintomas leves (otalgia leve, sem otorreia, febre <39°C) e sem fatores de risco, a conduta de observação vigilante por 48-72 horas com analgesia é uma opção apropriada, reservando antibiótico para falha de melhora ou agravamento. Pneumococo é o agente mais comum quando há indicação de antibiótico (amoxicilina em dose adequada é primeira escolha).$ach76$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ivas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ivas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i76_0$Realizou/descreveu a otoscopia (abaulamento, hiperemia, otorreia)$i76_0$, 2, 0),
  ($i76_1$Avaliou idade, gravidade dos sintomas e fatores de risco$i76_1$, 2, 1),
  ($i76_2$Reconheceu critérios para conduta expectante (observação 48-72h)$i76_2$, 3, 2),
  ($i76_3$Indicou analgesia adequada durante a observação$i76_3$, 2, 3),
  ($i76_4$Orientou retorno/reavaliação se não houver melhora ou houver piora$i76_4$, 2, 4),
  ($i76_5$Citou amoxicilina como antibiótico de escolha se necessário$i76_5$, 1, 5),
  ($i76_6$Comunicação que explica a decisão de não tratar de imediato$i76_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t77$'O moleque tá com o catarro verde, não é bactéria?'$t77$,
    $e77$IVAS$e77$,
    null,
    300,
    $q77$Pai de criança de 6 anos com resfriado de 4 dias insiste em antibiótico porque a secreção nasal "ficou verde".$q77$,
    $res77$Ambulatório. Pai de criança de 6 anos com resfriado de 4 dias insiste
em antibiótico porque a secreção nasal "ficou verde". Esclareça o mito e
oriente a conduta correta. ~5 min.$res77$,
    $p77$Pai de criança de 6 anos$p77$,
    $ctx77$Pai convencido de que secreção colorida = infecção bacteriana.$ctx77$,
    jsonb_build_array(
      $r77$Resfriado há 4 dias, com coriza que evoluiu de clara para amarelo-esverdeada.$r77$,
      $r77$Criança sem febre alta, ativa, comendo normalmente, sem dor facial/sinusal importante.$r77$,
      $r77$Pai pergunta: 'secreção verde não é sinal de que já é bactéria? Não devia já tomar antibiótico?'$r77$,
      $r77$Sem piora após melhora inicial (sem 'dupla piora'), sem sintomas há mais de 10 dias.$r77$
    ),
    $ach77$A cor da secreção nasal (clara, amarela ou esverdeada) isoladamente NÃO diferencia infecção viral de bacteriana — é uma evolução esperada e comum durante um resfriado viral comum, que dura tipicamente 7-14 dias. Suspeita de sinusite bacteriana exige persistência de sintomas por 10-14 dias sem melhora ou padrão de 'dupla piora' (melhora inicial seguida de novo agravamento), não apenas a cor da secreção.$ach77$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ivas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ivas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i77_0$Investigou a duração e a evolução dos sintomas$i77_0$, 2, 0),
  ($i77_1$Desconstruiu o mito de que secreção colorida indica infecção bacteriana$i77_1$, 3, 1),
  ($i77_2$Explicou a duração esperada do resfriado comum (7-14 dias)$i77_2$, 2, 2),
  ($i77_3$Citou os critérios que sugerem sinusite bacteriana (persistência/dupla piora)$i77_3$, 2, 3),
  ($i77_4$Concluiu que não há indicação de antibiótico neste momento$i77_4$, 2, 4),
  ($i77_5$Orientou sinais de alarme para retorno$i77_5$, 1, 5),
  ($i77_6$Comunicação respeitosa diante da insistência do pai$i77_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t78$Sinusite com inchaço ao redor do olho$t78$,
    $e78$IVAS$e78$,
    null,
    300,
    $q78$Criança de 7 anos com quadro de sinusite há 10 dias, agora com edema e vermelhidão ao redor do olho.$q78$,
    $res78$Pronto-socorro. Criança de 7 anos com quadro de sinusite há 10 dias,
agora com edema e vermelhidão ao redor do olho. Reconheça a complicação e
conduza com urgência. ~5 min.$res78$,
    $p78$Pais de criança de 7 anos$p78$,
    $ctx78$Pais notaram piora súbita do quadro nas últimas horas.$ctx78$,
    jsonb_build_array(
      $r78$Resfriado/sinusite há 10 dias, com persistência de obstrução nasal e secreção purulenta.$r78$,
      $r78$Há algumas horas, surgiu inchaço e vermelhidão ao redor do olho direito, com dor à movimentação ocular.$r78$,
      $r78$Achados (se solicitados): edema palpebral, hiperemia, dor à movimentação ocular, sem alteração da acuidade visual referida até agora.$r78$,
      $r78$Sem febre alta neste momento, mas já teve febre nos dias anteriores.$r78$
    ),
    $ach78$Quadro sugestivo de celulite periorbitária/orbitária como complicação de sinusite bacteriana (mais comumente etmoidal) — emergência que requer avaliação urgente, exame oftalmológico, possível imagem (TC de seios da face/órbita) e antibioticoterapia endovenosa, com avaliação de necessidade de drenagem cirúrgica se houver abscesso subperiosteal/orbitário ou comprometimento visual/de motilidade ocular.$ach78$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ivas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ivas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i78_0$Reconheceu o sinal de alarme (edema/dor periorbitária após sinusite)$i78_0$, 3, 0),
  ($i78_1$Diferenciou celulite periorbitária de orbitária (dor à movimentação/visão)$i78_1$, 2, 1),
  ($i78_2$Indicou avaliação oftalmológica urgente$i78_2$, 2, 2),
  ($i78_3$Indicou exame de imagem (TC) quando apropriado$i78_3$, 2, 3),
  ($i78_4$Indicou antibioticoterapia endovenosa/internação$i78_4$, 2, 4),
  ($i78_5$Reconheceu a gravidade e a necessidade de conduta urgente$i78_5$, 2, 5),
  ($i78_6$Comunicação clara sobre a gravidade aos pais$i78_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t79$Criança com estridor, mas sem tosse: outro diagnóstico?$t79$,
    $e79$IVAS$e79$,
    null,
    300,
    $q79$Criança de 4 anos com início súbito de febre alta, dor de garganta intensa, voz "engolada" e estridor, sem tosse.$q79$,
    $res79$Pronto-socorro. Criança de 4 anos com início súbito de febre alta,
dor de garganta intensa, voz "engolada" e estridor, sem tosse. Reconheça a
emergência e diferencie do crupe viral. ~5 min.$res79$,
    $p79$Pais de criança de 4 anos$p79$,
    $ctx79$Quadro de evolução muito rápida (horas). Informe achados quando solicitados.$ctx79$,
    jsonb_build_array(
      $r79$Início súbito há poucas horas: febre alta, dor de garganta intensa, dificuldade para engolir e falar.$r79$,
      $r79$Sem tosse característica (diferente das vezes em que teve 'crupe' antes).$r79$,
      $r79$Achados (se solicitados): criança prefere sentar inclinada para frente, com a boca aberta e babando (sialorreia), voz 'engolada', estridor inspiratório, toxemia (parece muito doente).$r79$,
      $r79$Não está com a vacinação completa contra Haemophilus influenzae tipo b (Hib) — esquema atrasado.$r79$
    ),
    $ach79$Quadro clássico de epiglotite aguda: início súbito, febre alta, toxemia, disfagia/sialorreia, voz 'engolada', posição em tripé/inclinada para frente, ausência de tosse típica (diferente do crupe viral, que tem tosse 'de cachorro' e evolução mais gradual). É uma emergência de via aérea — evitar manipular a orofaringe/deitar a criança forçadamente, manter ambiente calmo, garantir via aérea avançada disponível (possível intubação), e iniciar antibioticoterapia. Mais associada a vacinação incompleta para Hib.$ach79$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ivas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ivas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i79_0$Diferenciou o quadro do crupe viral (início súbito, sem tosse típica, toxemia)$i79_0$, 3, 0),
  ($i79_1$Identificou sinais de gravidade (sialorreia, posição em tripé, estridor)$i79_1$, 2, 1),
  ($i79_2$Reconheceu a epiglotite aguda como hipótese$i79_2$, 3, 2),
  ($i79_3$Evitou manipulação da orofaringe/posicionamento forçado$i79_3$, 2, 3),
  ($i79_4$Priorizou a manutenção da via aérea como emergência$i79_4$, 2, 4),
  ($i79_5$Relacionou o quadro à vacinação incompleta para Hib$i79_5$, 1, 5),
  ($i79_6$Comunicação calma, mas transmitindo a gravidade aos pais$i79_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t140$Resfriado comum — evitar antibiótico$t140$,
    $e140$Pediatria geral$e140$,
    null,
    300,
    $q140$Pré-escolar de 3 anos com coriza e tosse há 3 dias; a mãe quer antibiótico.$q140$,
    $res140$Pré-escolar de 3 anos com coriza e tosse há 3 dias; a mãe quer antibiótico.
Avalie, diferencie de quadro bacteriano e oriente. ~5 min.$res140$,
    $p140$Mãe de pré-escolar de 3 anos$p140$,
    $ctx140$Mãe quer antibiótico pela 'secreção verde'. Responda só ao que for perguntado.$ctx140$,
    jsonb_build_array(
      $r140$Há 3 dias com coriza, obstrução nasal e tosse; a secreção ficou esverdeada.$r140$,
      $r140$Bom estado geral, brinca, come razoável, febre baixa no 1º dia.$r140$,
      $r140$Frequenta creche e tem vários resfriados por ano.$r140$,
      $r140$A mãe insiste em antibiótico.$r140$
    ),
    $ach140$Bom estado geral; rinorreia e tosse; sem sinais de complicação. Quadro viral (resfriado comum).$ach140$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ivas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ivas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i140_0$Apresentou-se e identificou criança/responsável$i140_0$, 1, 0),
  ($i140_1$Caracterizou tempo e evolução dos sintomas$i140_1$, 2, 1),
  ($i140_2$Explicou que a cor da secreção não indica bactéria$i140_2$, 3, 2),
  ($i140_3$Reconheceu etiologia viral e a alta frequência na idade$i140_3$, 2, 3),
  ($i140_4$Evitou antibiótico e orientou sinais de alarme/retorno$i140_4$, 2, 4),
  ($i140_5$Orientou medidas de suporte (hidratação, lavagem nasal)$i140_5$, 1, 5),
  ($i140_6$Comunicação empática, manejando a expectativa materna$i140_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t141$Rinossinusite bacteriana — dupla piora$t141$,
    $e141$Pediatria geral$e141$,
    null,
    300,
    $q141$Escolar de 8 anos com resfriado que melhorou e voltou a piorar no 5º dia.$q141$,
    $res141$Escolar de 8 anos com resfriado que melhorou e voltou a piorar no 5º dia.
Avalie e defina diagnóstico e conduta. ~5 min.$res141$,
    $p141$Mãe de escolar de 8 anos$p141$,
    $ctx141$Mãe relata que 'tinha melhorado e piorou'. Responda só ao que for perguntado.$ctx141$,
    jsonb_build_array(
      $r141$Começou com coriza, melhorou no 4º dia e voltou a piorar no 5º.$r141$,
      $r141$Agora com febre, secreção espessa e dor/pressão na face.$r141$,
      $r141$Estado geral um pouco abatido.$r141$,
      $r141$Sem sinais neurológicos ou edema ocular.$r141$
    ),
    $ach141$Padrão de 'dupla piora' com febre, secreção purulenta e dor facial — rinossinusite bacteriana, sem sinais de complicação.$ach141$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ivas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ivas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i141_0$Apresentou-se e identificou criança/responsável$i141_0$, 1, 0),
  ($i141_1$Caracterizou a evolução (dupla piora/persistência ≥10 dias)$i141_1$, 3, 1),
  ($i141_2$Reconheceu critérios de rinossinusite bacteriana$i141_2$, 2, 2),
  ($i141_3$Citou agentes (pneumococo, H. influenzae, M. catarrhalis)$i141_3$, 1, 3),
  ($i141_4$Indicou amoxicilina como primeira escolha$i141_4$, 2, 4),
  ($i141_5$Pesquisou sinais de complicação (orbitária/SNC)$i141_5$, 2, 5),
  ($i141_6$Comunicação clara$i141_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t142$Faringoamigdalite viral × estreptocócica$t142$,
    $e142$Pediatria geral$e142$,
    null,
    300,
    $q142$Pré-escolar de 4 anos com dor de garganta.$q142$,
    $res142$Pré-escolar de 4 anos com dor de garganta. Diferencie etiologia viral de estreptocócica.
Avalie e defina conduta. ~5 min.$res142$,
    $p142$Mãe de pré-escolar de 4 anos$p142$,
    $ctx142$Mãe quer saber se é 'bacteriano'. Responda só ao que for perguntado.$ctx142$,
    jsonb_build_array(
      $r142$Dor de garganta com tosse, coriza e os olhos vermelhos (conjuntivite).$r142$,
      $r142$Febre baixa; sem petéquias no céu da boca.$r142$,
      $r142$Bom estado geral, comendo razoável.$r142$,
      $r142$Tem 4 anos.$r142$
    ),
    $ach142$Tosse, coriza e conjuntivite, sem petéquias palatinas; idade <3–5 anos — quadro sugestivo de faringite viral.$ach142$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ivas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ivas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i142_0$Apresentou-se e identificou criança/responsável$i142_0$, 1, 0),
  ($i142_1$Pesquisou sinais virais (tosse, coriza, conjuntivite, rouquidão)$i142_1$, 2, 1),
  ($i142_2$Pesquisou sinais estreptocócicos (petéquias, adenite dolorosa, ausência de sintomas virais)$i142_2$, 2, 2),
  ($i142_3$Considerou a idade na probabilidade etiológica$i142_3$, 2, 3),
  ($i142_4$Reconheceu provável etiologia viral$i142_4$, 2, 4),
  ($i142_5$Mencionou cultura/teste rápido quando indicado e evitou antibiótico desnecessário$i142_5$, 2, 5),
  ($i142_6$Comunicação clara$i142_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t143$Otite média aguda — observar ou tratar$t143$,
    $e143$Pediatria geral$e143$,
    null,
    300,
    $q143$Lactente de 18 meses com otalgia e febre; otoscopia com abaulamento timpânico.$q143$,
    $res143$Lactente de 18 meses com otalgia e febre; otoscopia com abaulamento timpânico.
Avalie e decida entre observação e antibiótico. ~5 min.$res143$,
    $p143$Mãe de lactente de 18 meses$p143$,
    $ctx143$Mãe relata choro e febre. Responda só ao que for perguntado.$ctx143$,
    jsonb_build_array(
      $r143$Está irritado, puxando a orelha, com febre há 1 dia.$r143$,
      $r143$Sem otorreia; é o primeiro episódio.$r143$,
      $r143$Acordou várias vezes à noite chorando.$r143$,
      $r143$Mora perto e consegue retornar para reavaliação.$r143$
    ),
    $ach143$Otoscopia: membrana timpânica abaulada e hiperemiada, unilateral; sem otorreia. Diagnóstico de OMA.$ach143$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ivas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ivas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i143_0$Apresentou-se e identificou criança/responsável$i143_0$, 1, 0),
  ($i143_1$Fez/valorizou a otoscopia (abaulamento/otorreia)$i143_1$, 3, 1),
  ($i143_2$Confirmou diagnóstico de OMA$i143_2$, 2, 2),
  ($i143_3$Considerou idade, gravidade, bilateralidade e otorreia na decisão$i143_3$, 2, 3),
  ($i143_4$Definiu observação 48–72h × antibiótico de forma adequada$i143_4$, 2, 4),
  ($i143_5$Prescreveu analgesia e orientou retorno$i143_5$, 1, 5),
  ($i143_6$Comunicação clara$i143_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t144$Complicações da infecção estreptocócica$t144$,
    $e144$Pediatria geral$e144$,
    null,
    300,
    $q144$Escolar de 9 anos com faringite estreptocócica confirmada. A mãe pergunta sobre "complicações".$q144$,
    $res144$Escolar de 9 anos com faringite estreptocócica confirmada. A mãe pergunta sobre "complicações".
Explique as complicações e a importância do tratamento. ~5 min.$res144$,
    $p144$Mãe de escolar de 9 anos$p144$,
    $ctx144$Mãe quer entender riscos e por que tratar. Responda só ao que for perguntado.$ctx144$,
    jsonb_build_array(
      $r144$A criança teve dor de garganta com placas e adenite cervical dolorosa.$r144$,
      $r144$Confirmou-se estreptococo.$r144$,
      $r144$Ela quer saber se precisa mesmo completar o antibiótico.$r144$,
      $r144$Pergunta o que pode acontecer se não tratar.$r144$
    ),
    $ach144$Faringoamigdalite estreptocócica; importância da antibioticoterapia completa para reduzir complicações.$ach144$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ivas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ivas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i144_0$Apresentou-se e identificou criança/responsável$i144_0$, 1, 0),
  ($i144_1$Explicou complicações supurativas (abscesso peritonsilar)$i144_1$, 2, 1),
  ($i144_2$Explicou febre reumática como complicação não supurativa$i144_2$, 3, 2),
  ($i144_3$Citou glomerulonefrite pós-estreptocócica$i144_3$, 2, 3),
  ($i144_4$Reforçou a importância de completar o tratamento$i144_4$, 2, 4),
  ($i144_5$Orientou sinais de alarme e retorno$i144_5$, 1, 5),
  ($i144_6$Comunicação clara e empática$i144_6$, 1, 6)
) as v(texto, grav, ord);
