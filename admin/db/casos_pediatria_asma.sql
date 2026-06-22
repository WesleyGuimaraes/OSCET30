-- Migracao automatica de cases.js -> Supabase (status em_revisao).
-- Gerado por gen_migracao_pediatria.js. Rodar DEPOIS de migracao_taxonomia_pediatria.sql.

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t80$Criança com falta de ar e chiado$t80$,
    $e80$Asma$e80$,
    null,
    300,
    $q80$Escolar de 8 anos, asmático, com dispneia e sibilância iniciadas hoje.$q80$,
    $res80$Pronto-socorro. Escolar de 8 anos, asmático, com dispneia e sibilância
iniciadas hoje. Avalie a gravidade da crise e conduza o tratamento. ~5 min.$res80$,
    $p80$Mãe de menino, 8 anos (asmático)$p80$,
    $ctx80$Mãe aflita com a falta de ar. Informe achados do exame quando solicitados.$ctx80$,
    jsonb_build_array(
      $r80$Desde a manhã: tosse, chiado e falta de ar, piorando.$r80$,
      $r80$Já é asmático; usou a bombinha de alívio em casa, com melhora apenas parcial.$r80$,
      $r80$Começou depois de um resfriado / exposição a poeira.$r80$,
      $r80$Achados: taquipneico, sibilos difusos, tiragem intercostal, fala frases curtas, SatO2 92%.$r80$
    ),
    $ach80$Crise asmática moderada: dispneia, sibilos difusos, tiragem, fala entrecortada, SatO2 92%. Conduta: O2 se necessário, beta-2 de curta inalatório (salbutamol) repetido, corticoide sistêmico e reavaliação da resposta.$ach80$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'asma')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('asma')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i80_0$Apresentou-se e caracterizou o início e a evolução da crise$i80_0$, 1, 0),
  ($i80_1$Confirmou diagnóstico prévio de asma e medicações em uso$i80_1$, 1, 1),
  ($i80_2$Avaliou a GRAVIDADE (FR, tiragem, fala, saturação, ausculta)$i80_2$, 3, 2),
  ($i80_3$Pesquisou fatores desencadeantes$i80_3$, 2, 3),
  ($i80_4$Reconheceu a crise e classificou a gravidade$i80_4$, 2, 4),
  ($i80_5$Iniciou beta-2 de curta inalatório (salbutamol)$i80_5$, 3, 5),
  ($i80_6$Indicou corticoide sistêmico$i80_6$, 2, 6),
  ($i80_7$Indicou oxigênio se hipoxemia e reavaliação$i80_7$, 2, 7),
  ($i80_8$Orientou conduta pós-crise/retorno$i80_8$, 1, 8),
  ($i80_9$Comunicação adequada$i80_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t81$Tosse e chiado que vivem voltando$t81$,
    $e81$Asma$e81$,
    null,
    300,
    $q81$Criança de 5 anos com episódios recorrentes de tosse e chiado.$q81$,
    $res81$Ambulatório. Criança de 5 anos com episódios recorrentes de tosse e
chiado. Avalie a hipótese de asma e oriente. ~5 min.$res81$,
    $p81$Mãe de criança, 5 anos$p81$,
    $ctx81$Mãe relata episódios repetidos. Responda ao que for perguntado.$ctx81$,
    jsonb_build_array(
      $r81$Tosse, chiado e falta de ar várias vezes ao ano, sobretudo à noite e ao correr/brincar.$r81$,
      $r81$Piora com gripes, poeira e contato com animais; melhora com a bombinha.$r81$,
      $r81$Tem rinite e teve eczema; há asma/alergia na família.$r81$,
      $r81$Entre as crises fica bem.$r81$
    ),
    $ach81$Sibilância recorrente com gatilhos típicos (exercício, noturno, infecções, alérgenos), resposta a broncodilatador e atopia pessoal/familiar → quadro clínico compatível com asma. Espirometria a partir de ~6 anos pode confirmar.$ach81$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'asma')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('asma')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i81_0$Apresentou-se e caracterizou os episódios (frequência, gatilhos, padrão noturno/exercício)$i81_0$, 3, 0),
  ($i81_1$Pesquisou resposta a broncodilatador$i81_1$, 1, 1),
  ($i81_2$Pesquisou atopia pessoal (rinite, eczema) e familiar$i81_2$, 2, 2),
  ($i81_3$Avaliou sintomas entre as crises e o impacto$i81_3$, 1, 3),
  ($i81_4$Reconheceu o padrão clínico de asma$i81_4$, 2, 4),
  ($i81_5$Considerou espirometria conforme a idade$i81_5$, 1, 5),
  ($i81_6$Diferenciou de outras causas de sibilância$i81_6$, 1, 6),
  ($i81_7$Explicou o diagnóstico e iniciou plano terapêutico$i81_7$, 2, 7),
  ($i81_8$Orientou controle ambiental e seguimento$i81_8$, 1, 8),
  ($i81_9$Comunicação clara$i81_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t82$Asma que não está controlada$t82$,
    $e82$Asma$e82$,
    null,
    300,
    $q82$Escolar de 9 anos asmático, usando só a bombinha de alívio, com sintomas frequentes.$q82$,
    $res82$Retorno. Escolar de 9 anos asmático, usando só a bombinha de alívio,
com sintomas frequentes. Avalie o controle e ajuste o tratamento. ~5 min.$res82$,
    $p82$Pai de menino, 9 anos (asmático)$p82$,
    $ctx82$Pai acha que está 'tudo bem', mas relata muitos sintomas. Responda ao que for perguntado.$ctx82$,
    jsonb_build_array(
      $r82$Tosse/chiado mais de 2x por semana; acorda à noite algumas vezes por mês.$r82$,
      $r82$Usa salbutamol quase todos os dias.$r82$,
      $r82$Falta à educação física por falta de ar; já foi ao PS este ano.$r82$,
      $r82$Usa só a 'bombinha de alívio'; não usa o preventivo regularmente.$r82$
    ),
    $ach82$Asma NÃO controlada (sintomas frequentes, despertares, uso excessivo de alívio, limitação a atividades, exacerbações). Conduta: introduzir/escalonar corticoide inalatório de manutenção, revisar adesão e técnica, fornecer plano de ação.$ach82$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'asma')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('asma')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i82_0$Apresentou-se e avaliou o controle (diurno, noturno, alívio, limitação)$i82_0$, 3, 0),
  ($i82_1$Pesquisou exacerbações/idas ao PS no último ano$i82_1$, 1, 1),
  ($i82_2$Revisou a medicação em uso (alívio x manutenção)$i82_2$, 2, 2),
  ($i82_3$Avaliou adesão e técnica inalatória$i82_3$, 2, 3),
  ($i82_4$Pesquisou desencadeantes e comorbidades (rinite)$i82_4$, 1, 4),
  ($i82_5$Classificou como asma não controlada$i82_5$, 2, 5),
  ($i82_6$Introduziu/escalonou corticoide inalatório de manutenção$i82_6$, 3, 6),
  ($i82_7$Forneceu plano de ação por escrito$i82_7$, 1, 7),
  ($i82_8$Orientou seguimento e reavaliação$i82_8$, 1, 8),
  ($i82_9$Comunicação clara$i82_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t83$Conferindo a técnica da bombinha$t83$,
    $e83$Asma$e83$,
    null,
    300,
    $q83$A mãe de uma criança de 6 anos asmática diz que "a bombinha não faz efeito".$q83$,
    $res83$Retorno. A mãe de uma criança de 6 anos asmática diz que "a bombinha
não faz efeito". Avalie e corrija a técnica inalatória. ~5 min.$res83$,
    $p83$Mãe de criança, 6 anos (asmática)$p83$,
    $ctx83$Mãe frustrada com a medicação. Demonstre a técnica errada se solicitada.$ctx83$,
    jsonb_build_array(
      $r83$Usa o spray direto na boca, sem espaçador.$r83$,
      $r83$Não agita o frasco e não coordena o disparo com a respiração.$r83$,
      $r83$Não faz pausa após inspirar; dá vários jatos seguidos.$r83$,
      $r83$Não enxágua a boca depois do corticoide. Os sintomas persistem.$r83$
    ),
    $ach83$Falha de técnica inalatória (sem espaçador, sem agitar, sem coordenação, sem pausa). Corrigir a técnica costuma resolver a 'falta de resposta': espaçador, agitar, disparo único, inspirar lento, pausa ~10 s, enxaguar a boca após corticoide.$ach83$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'asma')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('asma')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i83_0$Apresentou-se e perguntou como a criança usa o dispositivo$i83_0$, 2, 0),
  ($i83_1$Solicitou a demonstração da técnica$i83_1$, 2, 1),
  ($i83_2$Identificou os erros de técnica$i83_2$, 2, 2),
  ($i83_3$Recomendou o uso de espaçador (com/sem máscara conforme idade)$i83_3$, 3, 3),
  ($i83_4$Ensinou os passos corretos (agitar, disparo único, inspirar, pausa)$i83_4$, 3, 4),
  ($i83_5$Orientou enxaguar a boca após o corticoide inalatório$i83_5$, 2, 5),
  ($i83_6$Confirmou o aprendizado (demonstração de volta)$i83_6$, 1, 6),
  ($i83_7$Orientou seguimento$i83_7$, 1, 7),
  ($i83_8$Comunicação didática$i83_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t84$Evitando as crises de asma$t84$,
    $e84$Asma$e84$,
    null,
    300,
    $q84$Os pais de uma criança asmática de 7 anos querem reduzir as crises.$q84$,
    $res84$Ambulatório. Os pais de uma criança asmática de 7 anos querem reduzir
as crises. Faça a orientação sobre desencadeantes e plano de ação. ~5 min.$res84$,
    $p84$Pais de criança, 7 anos (asmática)$p84$,
    $ctx84$Pais querem ajuda para prevenir crises. Respondam ao que for perguntado.$ctx84$,
    jsonb_build_array(
      $r84$Crises frequentes; em casa há mofo, poeira, tapetes e bichos de pelúcia.$r84$,
      $r84$Têm um animal de estimação dentro de casa.$r84$,
      $r84$Se perguntado: alguém fuma dentro de casa.$r84$,
      $r84$Não têm plano de ação e não sabem quando procurar a emergência; não tomou vacina da gripe.$r84$
    ),
    $ach84$Cenário de educação: controle ambiental (ácaros, mofo, tabagismo passivo, pelos), adesão ao preventivo, vacinação (influenza), reconhecimento precoce da crise e plano de ação escrito.$ach84$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'asma')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('asma')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i84_0$Apresentou-se e levantou os desencadeantes do ambiente$i84_0$, 2, 0),
  ($i84_1$Orientou controle de ácaros/poeira/mofo (capas, limpeza, retirar tapetes/pelúcias)$i84_1$, 2, 1),
  ($i84_2$Orientou eliminar o tabagismo passivo$i84_2$, 3, 2),
  ($i84_3$Abordou animais de estimação/alérgenos específicos$i84_3$, 1, 3),
  ($i84_4$Reforçou a adesão ao tratamento preventivo$i84_4$, 2, 4),
  ($i84_5$Recomendou a vacinação (influenza)$i84_5$, 1, 5),
  ($i84_6$Ensinou o reconhecimento precoce da crise$i84_6$, 2, 6),
  ($i84_7$Forneceu plano de ação e quando procurar a emergência$i84_7$, 2, 7),
  ($i84_8$Comunicação didática e pactuada$i84_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t85$Bebê chiador ou já é asma?$t85$,
    $e85$Asma$e85$,
    null,
    300,
    $q85$Lactente de 14 meses com terceiro episódio de chiado no peito, sempre associado a resfriados.$q85$,
    $res85$Ambulatório. Lactente de 14 meses com terceiro episódio de chiado no
peito, sempre associado a resfriados. Diferencie "bebê chiador" de asma. ~5 min.$res85$,
    $p85$Mãe de lactente, 14 meses$p85$,
    $ctx85$Mãe ouviu de uma vizinha que 'criança pequena não tem asma'.$ctx85$,
    jsonb_build_array(
      $r85$Já teve 3 episódios de chiado, sempre durante resfriados virais, desde os 8 meses.$r85$,
      $r85$Entre os episódios, completamente assintomático, sem chiado, sem tosse.$r85$,
      $r85$Sem história pessoal de eczema/dermatite atópica, sem rinite.$r85$,
      $r85$Pais não têm asma; sem fumantes em casa.$r85$,
      $r85$Pergunta se isso 'já é asma' ou se vai passar com o tempo.$r85$
    ),
    $ach85$Lactentes com episódios de chiado exclusivamente associados a infecções virais, sem sintomas entre as crises e sem atopia pessoal/familiar ('bebê chiador' / sibilância transitória da infância), têm prognóstico favorável e tendência a resolução com a idade — diferente da asma, mais associada a atopia, sintomas entre as crises e história familiar. Reavaliar conforme evolução, já que parte evolui para asma quando há fatores de risco atópico.$ach85$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'asma')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('asma')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i85_0$Caracterizou os episódios (gatilho viral, ausência de sintomas entre crises)$i85_0$, 2, 0),
  ($i85_1$Investigou atopia pessoal (eczema, rinite) e história familiar de asma/atopia$i85_1$, 3, 1),
  ($i85_2$Diferenciou 'bebê chiador' de asma com base nesses achados$i85_2$, 3, 2),
  ($i85_3$Explicou o prognóstico favorável da sibilância transitória$i85_3$, 2, 3),
  ($i85_4$Orientou reavaliação se os fatores de risco mudarem com a idade$i85_4$, 1, 4),
  ($i85_5$Comunicação didática e tranquilizadora$i85_5$, 1, 5)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t86$Classificando a gravidade da crise de asma$t86$,
    $e86$Asma$e86$,
    null,
    300,
    $q86$Criança de 8 anos chega com crise de asma.$q86$,
    $res86$Pronto-socorro. Criança de 8 anos chega com crise de asma. Classifique
a gravidade da exacerbação e defina a conduta inicial. ~5 min.$res86$,
    $p86$Pais de criança de 8 anos, asmática$p86$,
    $ctx86$Já fazem uso de bombinha de resgate em casa, sem melhora completa.$ctx86$,
    jsonb_build_array(
      $r86$Falando frases completas, mas com desconforto respiratório perceptível.$r86$,
      $r86$Achados (se solicitados): SatO2 93% em ar ambiente, sibilos difusos, uso leve de musculatura acessória, FR pouco elevada para a idade.$r86$,
      $r86$Já usou broncodilatador de resgate em casa há 1 hora, com melhora parcial.$r86$,
      $r86$Sem cianose, sem sonolência/agitação importante, consegue falar normalmente.$r86$
    ),
    $ach86$Classificação de gravidade da crise asmática combina dados clínicos e SatO2: resposta INCOMPLETA ao tratamento corresponde a SatO2 entre 91-95%, geralmente crise leve a moderada (fala frases completas, uso leve de musculatura acessória); má resposta/crise grave corresponde a SatO2 <91%, com dificuldade para falar, uso intenso de musculatura acessória, sonolência ou agitação. Conduta: repetir broncodilatador a cada 20 minutos por até 3 doses na primeira hora, associar corticoide sistêmico se resposta incompleta.$ach86$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'asma')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('asma')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i86_0$Avaliou SatO2, FR e uso de musculatura acessória$i86_0$, 2, 0),
  ($i86_1$Avaliou a capacidade de falar (frases completas x incompletas)$i86_1$, 2, 1),
  ($i86_2$Classificou a gravidade da crise com base nesses parâmetros$i86_2$, 3, 2),
  ($i86_3$Relacionou a SatO2 91-95% à resposta incompleta/crise leve-moderada$i86_3$, 2, 3),
  ($i86_4$Indicou repetição do broncodilatador (a cada 20 min, até 3 doses na 1ª hora)$i86_4$, 2, 4),
  ($i86_5$Considerou corticoide sistêmico diante de resposta incompleta$i86_5$, 2, 5),
  ($i86_6$Comunicação clara sobre a gravidade e a conduta$i86_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t87$Doses na crise de asma moderada$t87$,
    $e87$Asma$e87$,
    null,
    300,
    $q87$Criança de 25 kg em crise de asma moderada.$q87$,
    $res87$Pronto-socorro. Criança de 25 kg em crise de asma moderada. Calcule
e justifique as doses dos medicamentos a serem administrados. ~5 min.$res87$,
    $p87$Pais de criança de 25 kg em crise de asma$p87$,
    $ctx87$Pais querem entender por que tantos medicamentos diferentes serão usados.$ctx87$,
    jsonb_build_array(
      $r87$Criança com sibilos difusos, uso moderado de musculatura acessória, SatO2 92%.$r87$,
      $r87$Fala frases parcialmente interrompidas pela falta de ar.$r87$,
      $r87$Pais perguntam: 'quanto vai ser de cada remédio?' e 'por que vai tomar mais de um?'$r87$,
      $r87$Sem comorbidades, sem alergia medicamentosa conhecida.$r87$
    ),
    $ach87$Crise moderada (25 kg): salbutamol/beta-2 agonista de curta ação — via inalador dosimetrado: 1 jato a cada 3 kg (≈8 jatos), máximo 10 jatos; ou via nebulização: 0,15 mg/kg/dose (máx. 5 mg ou 20 gotas). Associar ipratrópio (250-500 mcg) nas primeiras 3 nebulizações por se tratar de crise moderada/grave. Corticoide sistêmico: prednisolona 2 mg/kg (máximo 40 mg), via oral. Repetir broncodilatador a cada 20 minutos até 3 doses na primeira hora, reavaliando a resposta.$ach87$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'asma')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('asma')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i87_0$Calculou corretamente a dose de salbutamol (jatos ou nebulização) para o peso$i87_0$, 3, 0),
  ($i87_1$Indicou a associação de ipratrópio por se tratar de crise moderada/grave$i87_1$, 2, 1),
  ($i87_2$Calculou corretamente a dose de prednisolona (2 mg/kg, máx. 40 mg)$i87_2$, 3, 2),
  ($i87_3$Explicou o esquema de repetição do broncodilatador (a cada 20 min, até 3x)$i87_3$, 2, 3),
  ($i87_4$Explicou aos pais o motivo da associação de medicamentos$i87_4$, 1, 4),
  ($i87_5$Comunicação clara e didática$i87_5$, 1, 5)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t88$Interpretando a espirometria na asma$t88$,
    $e88$Asma$e88$,
    null,
    300,
    $q88$Criança de 9 anos com suspeita de asma realizou espirometria.$q88$,
    $res88$Ambulatório. Criança de 9 anos com suspeita de asma realizou
espirometria. Interprete o exame e explique aos pais. ~5 min.$res88$,
    $p88$Pais de criança de 9 anos$p88$,
    $ctx88$Pais trazem o laudo do exame e não entendem os números.$ctx88$,
    jsonb_build_array(
      $r88$Trazem laudo de espirometria: relação VEF1/CVF de 0,82 antes do broncodilatador.$r88$,
      $r88$Após uso de broncodilatador, VEF1 aumentou 15% em relação ao valor basal.$r88$,
      $r88$Criança tem tosse noturna recorrente e chiado em dias de exercício físico.$r88$,
      $r88$Pais perguntam o que esses números significam.$r88$
    ),
    $ach88$Relação VEF1/CVF <0,90 indica padrão obstrutivo nessa faixa etária. Resposta ao broncodilatador considerada significativa quando há aumento de VEF1 ≥12% (e nesse caso o aumento foi de 15%) — confirma reversibilidade da obstrução, compatível com asma. Outro parâmetro útil é o pico de fluxo expiratório (PFE): variabilidade >13% ao longo do dia ou melhora ≥15% após broncodilatador também sugerem asma.$ach88$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'asma')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('asma')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i88_0$Interpretou a relação VEF1/CVF como padrão obstrutivo (<0,90)$i88_0$, 3, 0),
  ($i88_1$Interpretou a resposta ao broncodilatador como significativa (≥12%)$i88_1$, 3, 1),
  ($i88_2$Relacionou os achados espirométricos ao quadro clínico de asma$i88_2$, 2, 2),
  ($i88_3$Citou o PFE como ferramenta complementar (variabilidade/resposta)$i88_3$, 2, 3),
  ($i88_4$Explicou os resultados de forma compreensível aos pais$i88_4$, 1, 4),
  ($i88_5$Comunicação didática$i88_5$, 1, 5)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t89$Ajustando o tratamento de manutenção$t89$,
    $e89$Asma$e89$,
    null,
    300,
    $q89$Criança de 10 anos com asma persistente, mesmo em uso de corticoide inalatório em dose baixa.$q89$,
    $res89$Ambulatório. Criança de 10 anos com asma persistente, mesmo em uso
de corticoide inalatório em dose baixa. Avalie o controle e ajuste o tratamento
conforme a terapia em escada (stepwise). ~5 min.$res89$,
    $p89$Pais de criança de 10 anos, asmática$p89$,
    $ctx89$Já em tratamento, mas com sintomas persistentes. Informe achados quando solicitados.$ctx89$,
    jsonb_build_array(
      $r89$Em uso de corticoide inalatório em dose baixa há 3 meses, com técnica inalatória confirmada correta.$r89$,
      $r89$Ainda apresenta sintomas diurnos mais de 2x por semana e desperta à noite por chiado pelo menos 1x por semana.$r89$,
      $r89$Já usou broncodilatador de resgate mais de 2x por semana nas últimas semanas.$r89$,
      $r89$Adesão ao tratamento confirmada como boa pelos pais.$r89$,
      $r89$Pergunta: 'por que ainda tem sintomas mesmo tomando a bombinha preventiva?'$r89$
    ),
    $ach89$Sintomas persistentes (diurnos >2x/semana, despertares noturnos, uso frequente de resgate) a despeito de boa adesão e técnica inalatória correta, em uso de corticoide inalatório dose baixa, indicam asma não controlada no step atual — antes de trocar a medicação, deve-se confirmar adesão/técnica (já feito no caso) e então avançar na terapia em escada (stepwise), por exemplo aumentando a dose do corticoide inalatório ou associando outra classe terapêutica, conforme a faixa etária.$ach89$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'asma')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('asma')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i89_0$Avaliou os critérios de controle (sintomas diurnos, noturnos, uso de resgate)$i89_0$, 3, 0),
  ($i89_1$Confirmou adesão e técnica inalatória antes de qualquer ajuste$i89_1$, 2, 1),
  ($i89_2$Classificou a asma como não controlada no step atual$i89_2$, 2, 2),
  ($i89_3$Indicou avanço na terapia em escada (stepwise) adequado à faixa etária$i89_3$, 3, 3),
  ($i89_4$Explicou aos pais por que a 'bombinha preventiva' isolada pode não ser suficiente$i89_4$, 1, 4),
  ($i89_5$Programou reavaliação após o ajuste$i89_5$, 1, 5),
  ($i89_6$Comunicação didática$i89_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t145$Crise de asma grave — reconhecer e internar$t145$,
    $e145$Pneumologia pediátrica$e145$,
    null,
    300,
    $q145$Escolar de 7 anos asmático em crise, com grande esforço e saturação baixa.$q145$,
    $res145$Escolar de 7 anos asmático em crise, com grande esforço e saturação baixa.
Avalie a gravidade, conduza a crise e defina destino. ~5 min.$res145$,
    $p145$Mãe de escolar de 7 anos asmático$p145$,
    $ctx145$Criança em franco desconforto respiratório. Responda só ao que for perguntado.$ctx145$,
    jsonb_build_array(
      $r145$Piorou ao longo do dia; usa muito a musculatura do pescoço para respirar.$r145$,
      $r145$Fala em palavras curtas, está agitado e cansado.$r145$,
      $r145$Já usou a bombinha em casa várias vezes sem melhora.$r145$,
      $r145$Tem histórico de internações por asma.$r145$
    ),
    $ach145$Tiragem importante, fala entrecortada, sibilos difusos com pouca entrada de ar; SatO2 < 91%.$ach145$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'asma')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('asma')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i145_0$Apresentou-se e avaliou rapidamente a gravidade$i145_0$, 1, 0),
  ($i145_1$Avaliou FR, FC, ausculta, esforço, fala e saturação$i145_1$, 2, 1),
  ($i145_2$Reconheceu crise grave (SatO2 <91%, má resposta)$i145_2$, 3, 2),
  ($i145_3$Indicou O2, beta-2 de curta (repetir a cada 20 min, até 3x) e ipratrópio$i145_3$, 2, 3),
  ($i145_4$Indicou corticoide sistêmico (prednisolona 2 mg/kg, máx 40 mg)$i145_4$, 2, 4),
  ($i145_5$Definiu internação/observação prolongada$i145_5$, 1, 5),
  ($i145_6$Comunicação clara da gravidade$i145_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t146$Diagnóstico de asma no pré-escolar$t146$,
    $e146$Pneumologia pediátrica$e146$,
    null,
    300,
    $q146$Pré-escolar de 4 anos com sibilância recorrente e atopia.$q146$,
    $res146$Pré-escolar de 4 anos com sibilância recorrente e atopia. Avalie e proponha abordagem diagnóstica.
~5 min.$res146$,
    $p146$Mãe de pré-escolar de 4 anos$p146$,
    $ctx146$Mãe relata 'chiado' frequente. Responda só ao que for perguntado.$ctx146$,
    jsonb_build_array(
      $r146$Já teve mais de três episódios de chiado no último ano, alguns sem resfriado.$r146$,
      $r146$Piora à noite e com poeira/atividade; melhora com a bombinha.$r146$,
      $r146$Tem rinite e dermatite atópica; pai asmático.$r146$,
      $r146$Quer saber se 'é asma' e como confirmar.$r146$
    ),
    $ach146$Sibilância recorrente (≥3/ano), piora noturna, resposta a broncodilatador e atopia; idade torna espirometria pouco viável.$ach146$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'asma')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('asma')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i146_0$Apresentou-se e identificou criança/responsável$i146_0$, 1, 0),
  ($i146_1$Caracterizou recorrência, padrão noturno e gatilhos$i146_1$, 2, 1),
  ($i146_2$Valorizou atopia pessoal/familiar e resposta ao broncodilatador$i146_2$, 2, 2),
  ($i146_3$Explicou diagnóstico clínico-probabilístico em <5 anos$i146_3$, 3, 3),
  ($i146_4$Propôs prova terapêutica com corticoide inalatório (2–3 meses)$i146_4$, 2, 4),
  ($i146_5$Diferenciou de bebê chiador/outros diagnósticos$i146_5$, 1, 5),
  ($i146_6$Comunicação clara$i146_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t147$Tratamento de manutenção (6–11 anos)$t147$,
    $e147$Pneumologia pediátrica$e147$,
    null,
    300,
    $q147$Escolar de 9 anos com asma sintomática na maioria dos dias.$q147$,
    $res147$Escolar de 9 anos com asma sintomática na maioria dos dias. Defina a terapia de manutenção escalonada.
~5 min.$res147$,
    $p147$Mãe de escolar de 9 anos asmático$p147$,
    $ctx147$Mãe relata sintomas frequentes. Responda só ao que for perguntado.$ctx147$,
    jsonb_build_array(
      $r147$Tem tosse/chiado na maioria dos dias e acorda à noite algumas vezes por semana.$r147$,
      $r147$Usa só a bombinha de alívio, várias vezes por semana.$r147$,
      $r147$Falta à escola por causa dos sintomas.$r147$,
      $r147$Nunca usou medicação controladora regular.$r147$
    ),
    $ach147$Asma não controlada (sintomas na maioria dos dias, despertares noturnos, uso frequente de alívio); sem controlador.$ach147$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'asma')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('asma')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i147_0$Apresentou-se e identificou criança/responsável$i147_0$, 1, 0),
  ($i147_1$Avaliou o controle (sintomas, despertares, uso de alívio, faltas)$i147_1$, 2, 1),
  ($i147_2$Diferenciou controlador (corticoide inalatório) de resgate (salbutamol)$i147_2$, 2, 2),
  ($i147_3$Indicou corticoide inalatório de manutenção (escalonar conforme controle)$i147_3$, 3, 3),
  ($i147_4$Considerou associação BALD/MART em sintomas frequentes$i147_4$, 1, 4),
  ($i147_5$Orientou reavaliação do controle e adesão/técnica$i147_5$, 2, 5),
  ($i147_6$Comunicação clara$i147_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t148$Bebê chiador × asma$t148$,
    $e148$Pneumologia pediátrica$e148$,
    null,
    300,
    $q148$Lactente de 14 meses com episódios de chiado sempre associados a resfriados.$q148$,
    $res148$Lactente de 14 meses com episódios de chiado sempre associados a resfriados.
Avalie e diferencie bebê chiador de asma. ~5 min.$res148$,
    $p148$Mãe de lactente de 14 meses$p148$,
    $ctx148$Mãe preocupada se 'já é asma'. Responda só ao que for perguntado.$ctx148$,
    jsonb_build_array(
      $r148$O chiado aparece sempre junto com resfriados virais e some depois.$r148$,
      $r148$Entre os episódios fica bem, sem sintomas.$r148$,
      $r148$Sem rinite/eczema; sem asma na família.$r148$,
      $r148$Frequenta creche.$r148$
    ),
    $ach148$Episódios de sibilância virais transitórios, intercrise assintomática, sem atopia — padrão de bebê chiador.$ach148$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'asma')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('asma')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i148_0$Apresentou-se e identificou criança/responsável$i148_0$, 1, 0),
  ($i148_1$Caracterizou os episódios e os gatilhos (virais)$i148_1$, 2, 1),
  ($i148_2$Avaliou intercrise e presença/ausência de atopia$i148_2$, 2, 2),
  ($i148_3$Diferenciou bebê chiador (transitório/viral) de asma (recorrente/atópica)$i148_3$, 3, 3),
  ($i148_4$Explicou conduta e vigilância evolutiva$i148_4$, 2, 4),
  ($i148_5$Evitou rótulo/medicação controladora precoce desnecessária$i148_5$, 1, 5),
  ($i148_6$Comunicação clara e tranquilizadora$i148_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t149$Técnica da bombinha com espaçador$t149$,
    $e149$Pneumologia pediátrica$e149$,
    null,
    300,
    $q149$Pré-escolar de 5 anos asmático com controle ruim; a mãe relata dúvidas no uso da bombinha.$q149$,
    $res149$Pré-escolar de 5 anos asmático com controle ruim; a mãe relata dúvidas no uso da bombinha.
Avalie e ensine a técnica correta com espaçador. ~5 min.$res149$,
    $p149$Mãe de pré-escolar de 5 anos asmático$p149$,
    $ctx149$Mãe insegura com o dispositivo. Responda só ao que for perguntado.$ctx149$,
    jsonb_build_array(
      $r149$Aplica vários jatos de uma vez no espaçador.$r149$,
      $r149$A máscara nem sempre fica bem vedada no rosto.$r149$,
      $r149$Não espera entre os jatos nem agita o spray.$r149$,
      $r149$Acha que 'não está fazendo efeito'.$r149$
    ),
    $ach149$Erros de técnica: múltiplos jatos juntos, vedação inadequada, sem aguardar inalação — reduzindo a eficácia.$ach149$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'asma')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('asma')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i149_0$Apresentou-se e identificou criança/responsável$i149_0$, 1, 0),
  ($i149_1$Observou/perguntou a técnica atual$i149_1$, 2, 1),
  ($i149_2$Orientou agitar o spray e aplicar um jato por vez$i149_2$, 2, 2),
  ($i149_3$Orientou vedação correta da máscara/espaçador$i149_3$, 2, 3),
  ($i149_4$Orientou aguardar respirações suficientes por jato$i149_4$, 2, 4),
  ($i149_5$Reforçou higiene do espaçador e checagem periódica$i149_5$, 1, 5),
  ($i149_6$Comunicação didática e empática$i149_6$, 1, 6)
) as v(texto, grav, ord);
