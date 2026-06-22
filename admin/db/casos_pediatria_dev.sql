-- Migracao automatica de cases.js -> Supabase (status em_revisao).
-- Gerado por gen_migracao_pediatria.js. Rodar DEPOIS de migracao_taxonomia_pediatria.sql.

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t0$Lactente que ainda não senta$t0$,
    $e0$Desenvolvimento infantil$e0$,
    null,
    300,
    $q0$A mãe de Pedro, 9 meses, está preocupada porque ele "ainda não senta sozinho".$q0$,
    $res0$Puericultura. A mãe de Pedro, 9 meses, está preocupada porque ele "ainda
não senta sozinho". Avalie o desenvolvimento, identifique sinais de alerta e oriente. ~5 min.$res0$,
    $p0$Mãe de Pedro, 9 meses$p0$,
    $ctx0$Mãe atenta e ansiosa. Responda só ao que for perguntado.$ctx0$,
    jsonb_build_array(
      $r0$Senta com apoio desde os 8 meses, mas não senta sozinho. Não engatinha.$r0$,
      $r0$Sustentou a cabeça com ~4 meses; rolou com ~7 meses (ela achou tarde).$r0$,
      $r0$Pega objetos, leva à boca e há pouco começou a passar de uma mão para a outra.$r0$,
      $r0$Balbucia 'dadada', sorriu por volta de 2 meses, estranha desconhecidos.$r0$,
      $r0$Nasceu a termo, parto sem intercorrências, sem internações. Vacinas em dia.$r0$,
      $r0$Acha o filho 'molinho'. Sem doença neuromuscular na família.$r0$
    ),
    $ach0$Hipotonia axial leve; senta com apoio, não senta sem apoio aos 9m; reflexos presentes; sem dismorfias.$ach0$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'marcos-desenvolvimento-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('marcos-desenvolvimento-infantil')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i0_0$Apresentou-se e identificou criança/responsável$i0_0$, 1, 0),
  ($i0_1$Pesquisou marcos motores grosseiros (cefálico, rolar, sentar)$i0_1$, 2, 1),
  ($i0_2$Avaliou motricidade fina (preensão, transferência)$i0_2$, 1, 2),
  ($i0_3$Avaliou linguagem (balbucio)$i0_3$, 1, 3),
  ($i0_4$Avaliou social/adaptativo (sorriso, estranhamento)$i0_4$, 1, 4),
  ($i0_5$Investigou antecedentes pré/peri/pós-natais e familiares$i0_5$, 2, 5),
  ($i0_6$Identificou atraso/sinal de alerta no desenvolvimento motor$i0_6$, 2, 6),
  ($i0_7$Valorizou avaliação do tônus muscular$i0_7$, 2, 7),
  ($i0_8$Propôs seguimento/estimulação ou encaminhamento adequado$i0_8$, 2, 8),
  ($i0_9$Comunicação empática, sem alarmar desnecessariamente$i0_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t1$Criança de 2 anos que fala pouco$t1$,
    $e1$Desenvolvimento infantil$e1$,
    null,
    300,
    $q1$O pai de Laura, 2 anos, diz que ela "quase não fala".$q1$,
    $res1$Ambulatório. O pai de Laura, 2 anos, diz que ela "quase não fala".
Avalie a linguagem e o desenvolvimento global, levante hipóteses e oriente. ~5 min.$res1$,
    $p1$Pai de Laura, 2 anos$p1$,
    $ctx1$Pai calmo, compara com o filho mais velho que 'falava mais'.$ctx1$,
    jsonb_build_array(
      $r1$Fala umas 5 palavras soltas ('mamã', 'papá', 'au-au'), não junta duas palavras.$r1$,
      $r1$Entende ordens simples ('pega a bola', 'dá tchau') e aponta o que quer.$r1$,
      $r1$Anda bem desde 13 meses, corre, sobe escada com ajuda. Brinca, faz contato visual.$r1$,
      $r1$Interage, imita, brinca de 'faz de conta' simples.$r1$,
      $r1$Já teve várias otites; nunca testou audição. TV ligada boa parte do dia.$r1$,
      $r1$Nasceu a termo, sem intercorrências. Vacinas em dia.$r1$
    ),
    $ach1$Bom contato visual e social, atende pelo nome, motor normal. Linguagem expressiva abaixo do esperado para 24 meses; compreensão preservada.$ach1$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'marcos-desenvolvimento-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('marcos-desenvolvimento-infantil')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i1_0$Apresentou-se e acolheu o responsável$i1_0$, 1, 0),
  ($i1_1$Caracterizou a linguagem EXPRESSIVA (vocabulário, frases)$i1_1$, 2, 1),
  ($i1_2$Avaliou a linguagem RECEPTIVA / compreensão$i1_2$, 2, 2),
  ($i1_3$Avaliou áreas motora e social (descartar atraso global/TEA)$i1_3$, 2, 3),
  ($i1_4$Investigou otites de repetição e triagem auditiva$i1_4$, 2, 4),
  ($i1_5$Perguntou exposição a telas e estímulo de linguagem$i1_5$, 1, 5),
  ($i1_6$Reconheceu atraso de linguagem isolado como hipótese$i1_6$, 2, 6),
  ($i1_7$Indicou avaliação auditiva e seguimento/fonoaudiologia$i1_7$, 2, 7),
  ($i1_8$Orientou estímulo (conversar, ler, reduzir telas)$i1_8$, 1, 8),
  ($i1_9$Comunicação clara e tranquilizadora$i1_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t2$Puericultura do lactente de 4 meses$t2$,
    $e2$Desenvolvimento infantil$e2$,
    null,
    300,
    $q2$A mãe de Miguel, 4 meses, quer saber se o desenvolvimento "está no caminho certo".$q2$,
    $res2$Consulta de rotina. A mãe de Miguel, 4 meses, quer saber se o
desenvolvimento "está no caminho certo". Avalie os marcos e oriente os próximos. ~5 min.$res2$,
    $p2$Mãe de Miguel, 4 meses$p2$,
    $ctx2$Mãe de primeira viagem, curiosa, sem queixas — quer orientação.$ctx2$,
    jsonb_build_array(
      $r2$Sustenta bem a cabeça, fica de bruços e levanta o tronco apoiado nos braços.$r2$,
      $r2$Sorri, 'conversa' com sons (arrulhos), segue objetos e a face com os olhos.$r2$,
      $r2$Leva as mãos à linha média e à boca; começa a tentar pegar objetos.$r2$,
      $r2$Ainda não rola completamente. Reconhece a mãe e se acalma com a voz dela.$r2$,
      $r2$Mama no peito, dorme bem. Nasceu a termo, vacinas em dia.$r2$,
      $r2$Pergunta: 'O que devo esperar para os próximos meses?'$r2$
    ),
    $ach2$Desenvolvimento adequado para 4 meses: bom sustento cefálico, sorriso social, fixa e segue, mãos na linha média.$ach2$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'marcos-desenvolvimento-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('marcos-desenvolvimento-infantil')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i2_0$Apresentou-se e identificou criança/responsável$i2_0$, 1, 0),
  ($i2_1$Avaliou marco motor grosseiro (sustento cefálico/bruços)$i2_1$, 1, 1),
  ($i2_2$Avaliou motricidade fina (mãos na linha média, preensão)$i2_2$, 1, 2),
  ($i2_3$Avaliou linguagem (arrulhos/vocalização)$i2_3$, 1, 3),
  ($i2_4$Avaliou social (sorriso, fixa e segue, reconhece a mãe)$i2_4$, 1, 4),
  ($i2_5$Concluiu que o desenvolvimento está adequado para a idade$i2_5$, 2, 5),
  ($i2_6$Orientou marcos esperados dos próximos meses (rolar, sentar)$i2_6$, 2, 6),
  ($i2_7$Orientou estímulo adequado (tummy time, fala, interação)$i2_7$, 2, 7),
  ($i2_8$Reforçou segurança (sono seguro, evitar quedas)$i2_8$, 1, 8),
  ($i2_9$Comunicação acolhedora e didática$i2_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t3$Criança de 18 meses que 'mudou'$t3$,
    $e3$Desenvolvimento infantil$e3$,
    null,
    300,
    $q3$A mãe de Théo, 18 meses, conta que ele "parou de apontar e fala menos do que falava".$q3$,
    $res3$Ambulatório. A mãe de Théo, 18 meses, conta que ele "parou de
apontar e fala menos do que falava". Avalie o desenvolvimento e os sinais de alerta. ~5 min.$res3$,
    $p3$Mãe de Théo, 18 meses$p3$,
    $ctx3$Mãe preocupada, percebe que ele 'se isola'. Responda objetivamente.$ctx3$,
    jsonb_build_array(
      $r3$Falava 3-4 palavras aos 12m e parece ter perdido algumas; quase não fala agora.$r3$,
      $r3$Não aponta para mostrar coisas; pega a mão do adulto e leva até o objeto.$r3$,
      $r3$Faz pouco contato visual, raramente atende quando o chamam pelo nome.$r3$,
      $r3$Brinca enfileirando objetos; gira rodinhas; incomoda-se com barulhos altos.$r3$,
      $r3$Anda desde 13 meses (motor normal). Sem 'faz de conta'.$r3$,
      $r3$Nasceu a termo, sem intercorrências. Sem irmãos. Vacinas em dia.$r3$
    ),
    $ach3$Pouco contato visual, não atende ao nome, ausência de apontar protodeclarativo, interesses restritos e estereotipias. Motor preservado.$ach3$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'marcos-desenvolvimento-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('marcos-desenvolvimento-infantil')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i3_0$Apresentou-se e acolheu a mãe$i3_0$, 1, 0),
  ($i3_1$Caracterizou a linguagem e possível regressão$i3_1$, 2, 1),
  ($i3_2$Pesquisou comunicação não verbal (apontar, contato visual, atender ao nome)$i3_2$, 2, 2),
  ($i3_3$Pesquisou interação social e brincar (faz de conta)$i3_3$, 1, 3),
  ($i3_4$Pesquisou comportamentos restritos/repetitivos (estereotipias)$i3_4$, 2, 4),
  ($i3_5$Avaliou as demais áreas (motor) p/ desenvolvimento global$i3_5$, 1, 5),
  ($i3_6$Reconheceu sinais de alerta para TEA$i3_6$, 2, 6),
  ($i3_7$Indicou avaliação auditiva e encaminhamento especializado$i3_7$, 2, 7),
  ($i3_8$Orientou a família e valorizou intervenção precoce$i3_8$, 1, 8),
  ($i3_9$Comunicação empática, sem fechar diagnóstico precipitado$i3_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t4$Desenvolvimento do ex-prematuro$t4$,
    $e4$Desenvolvimento infantil$e4$,
    null,
    300,
    $q4$A mãe de Alice, 6 meses de idade cronológica (nasceu com 32 semanas), acha que ela está "atrasada".$q4$,
    $res4$Seguimento. A mãe de Alice, 6 meses de idade cronológica (nasceu com
32 semanas), acha que ela está "atrasada". Avalie usando idade corrigida e oriente. ~5 min.$res4$,
    $p4$Mãe de Alice, 6 meses (nascida com 32 semanas)$p4$,
    $ctx4$Mãe ansiosa, compara com sobrinha da mesma idade que já senta.$ctx4$,
    jsonb_build_array(
      $r4$Nasceu com 32 semanas (2 meses antes); ficou 3 semanas na UTI neonatal.$r4$,
      $r4$Hoje tem 6 meses de vida; sustenta a cabeça, rola, fica de bruços apoiada.$r4$,
      $r4$Ainda não senta sem apoio. Pega objetos, leva à boca, sorri e vocaliza.$r4$,
      $r4$Compara: 'a filha da minha irmã, de 6 meses, já senta'.$r4$,
      $r4$Alimenta-se bem, ganho de peso adequado no seguimento.$r4$,
      $r4$Pergunta: 'Ela está atrasada, doutor?'$r4$
    ),
    $ach4$Idade corrigida = 4 meses. Desenvolvimento compatível com 4 meses (não esperar sentar sem apoio ainda). Tônus e exame normais.$ach4$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'marcos-desenvolvimento-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('marcos-desenvolvimento-infantil')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i4_0$Apresentou-se e identificou criança/responsável$i4_0$, 1, 0),
  ($i4_1$Perguntou idade gestacional ao nascer e intercorrências neonatais$i4_1$, 2, 1),
  ($i4_2$Calculou/aplicou a IDADE CORRIGIDA$i4_2$, 3, 2),
  ($i4_3$Avaliou os marcos motores, finos, linguagem e social$i4_3$, 2, 3),
  ($i4_4$Concluiu desenvolvimento adequado para a idade corrigida$i4_4$, 2, 4),
  ($i4_5$Explicou à mãe o conceito de idade corrigida$i4_5$, 2, 5),
  ($i4_6$Orientou seguimento do prematuro e estímulo$i4_6$, 1, 6),
  ($i4_7$Tranquilizou de forma adequada$i4_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t5$Puericultura do lactente de 2 meses$t5$,
    $e5$Desenvolvimento infantil$e5$,
    null,
    300,
    $q5$A mãe de Davi, 2 meses, quer saber se ele está "se desenvolvendo bem".$q5$,
    $res5$Consulta de rotina. A mãe de Davi, 2 meses, quer saber se ele está
"se desenvolvendo bem". Avalie os marcos esperados para a idade e oriente. ~5 min.$res5$,
    $p5$Mãe de Davi, 2 meses$p5$,
    $ctx5$Mãe de primeira viagem, sem queixas, só quer confirmação e orientação.$ctx5$,
    jsonb_build_array(
      $r5$Sustenta a cabeça por curtos períodos quando posto de bruços; ainda 'cai' às vezes.$r5$,
      $r5$Sorri em resposta ao rosto da mãe (sorriso social) desde a 6ª semana.$r5$,
      $r5$Emite sons guturais; acalma-se com a voz da mãe; fixa o rosto e acompanha com o olhar.$r5$,
      $r5$Mãos ainda fechadas a maior parte do tempo; reflexo de preensão palmar presente.$r5$,
      $r5$Nasceu a termo, sem intercorrências. Mama no peito em livre demanda. Vacinas em dia.$r5$,
      $r5$Pergunta: 'isso tudo está certo para a idade dele?'$r5$
    ),
    $ach5$Desenvolvimento adequado para 2 meses: sorriso social presente, fixa e segue com o olhar, começa o controle cefálico, reflexos primitivos presentes e simétricos (Moro, preensão palmar). Sem sinais de alarme.$ach5$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'marcos-desenvolvimento-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('marcos-desenvolvimento-infantil')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i5_0$Apresentou-se e identificou criança/responsável$i5_0$, 1, 0),
  ($i5_1$Avaliou o controle cefálico (marco motor grosseiro)$i5_1$, 2, 1),
  ($i5_2$Avaliou motricidade fina/reflexos primitivos (preensão palmar)$i5_2$, 1, 2),
  ($i5_3$Avaliou marco social (sorriso social) e visual (fixa e segue)$i5_3$, 2, 3),
  ($i5_4$Avaliou linguagem (sons guturais, resposta à voz)$i5_4$, 1, 4),
  ($i5_5$Concluiu que o desenvolvimento está adequado para a idade$i5_5$, 2, 5),
  ($i5_6$Orientou marcos esperados dos próximos meses$i5_6$, 1, 6),
  ($i5_7$Reforçou estímulo (tummy time, conversar, contato visual)$i5_7$, 1, 7),
  ($i5_8$Comunicação acolhedora e didática$i5_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t6$Criança de 16 meses que ainda não anda$t6$,
    $e6$Desenvolvimento infantil$e6$,
    null,
    300,
    $q6$Os pais de Bruna, 16 meses, estão preocupados porque ela "ainda não anda sozinha".$q6$,
    $res6$Ambulatório. Os pais de Bruna, 16 meses, estão preocupados porque ela
"ainda não anda sozinha". Avalie o desenvolvimento motor e os sinais de alerta. ~5 min.$res6$,
    $p6$Pais de Bruna, 16 meses$p6$,
    $ctx6$Pais comparam com outras crianças da mesma idade. Respondam ao que for perguntado.$ctx6$,
    jsonb_build_array(
      $r6$Engatinhou com 9 meses; fica em pé com apoio e dá alguns passos segurando os móveis.$r6$,
      $r6$Ainda não solta para andar sozinha; quando solta, senta no chão.$r6$,
      $r6$Sustentou a cabeça e sentou sem apoio nas idades esperadas (sem atraso prévio).$r6$,
      $r6$Pega objetos pequenos com pinça, transfere de mão em mão, aponta para pedir.$r6$,
      $r6$Fala 'mamã', 'papá' e mais 3-4 palavras; entende ordens simples.$r6$,
      $r6$Nasceu a termo, sem intercorrências. Vacinas em dia. Sem doenças neuromusculares na família.$r6$
    ),
    $ach6$Marcha independente surge tipicamente entre 12-18 meses (ainda dentro do limite até 16-18m, sobretudo se já anda com apoio). Tônus, reflexos e demais áreas do desenvolvimento normais. Sem sinais de alarme até o momento; reavaliar se não andar sozinha até 18 meses.$ach6$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'marcos-desenvolvimento-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('marcos-desenvolvimento-infantil')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i6_0$Apresentou-se e acolheu a preocupação dos pais$i6_0$, 1, 0),
  ($i6_1$Pesquisou a sequência motora prévia (sentar, engatinhar, ficar em pé)$i6_1$, 2, 1),
  ($i6_2$Avaliou a marcha com apoio e a tentativa de soltar$i6_2$, 2, 2),
  ($i6_3$Avaliou as demais áreas (fina, linguagem, social) para descartar atraso global$i6_3$, 2, 3),
  ($i6_4$Avaliou tônus muscular e simetria dos membros$i6_4$, 2, 4),
  ($i6_5$Reconheceu que 16 meses ainda está dentro da faixa esperada$i6_5$, 2, 5),
  ($i6_6$Definiu o limite de alerta (reavaliar se não andar até 18 meses)$i6_6$, 2, 6),
  ($i6_7$Orientou estímulo adequado e segurança no ambiente$i6_7$, 1, 7),
  ($i6_8$Comunicação tranquilizadora, sem alarmar desnecessariamente$i6_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t7$Quando iniciar o desfralde?$t7$,
    $e7$Desenvolvimento infantil$e7$,
    null,
    300,
    $q7$A mãe de Gael, 2 anos e 4 meses, pergunta se já é hora de "tirar a fralda".$q7$,
    $res7$Puericultura. A mãe de Gael, 2 anos e 4 meses, pergunta se já é hora de
"tirar a fralda". Avalie a prontidão para o controle esfincteriano e oriente. ~5 min.$res7$,
    $p7$Mãe de Gael, 2 anos e 4 meses$p7$,
    $ctx7$Mãe sob pressão da família para iniciar o desfralde. Responda objetivamente.$ctx7$,
    jsonb_build_array(
      $r7$Fica seco por períodos de 2 horas durante o dia; percebe quando está fazendo cocô (faz careta, se esconde).$r7$,
      $r7$Já consegue subir e descer as próprias calças com alguma ajuda.$r7$,
      $r7$Entende e segue instruções simples ('vamos no troninho').$r7$,
      $r7$Demonstra interesse em imitar os adultos no banheiro.$r7$,
      $r7$Avó insiste que 'já devia ter tirado a fralda há tempos'.$r7$,
      $r7$Sem constipação, sem histórico de ITU, desenvolvimento normal nas demais áreas.$r7$
    ),
    $ach7$Sinais de prontidão presentes (controle vesical intermitente, percepção da urgência, capacidade motora e compreensão de instruções) → momento adequado para iniciar o treinamento esfincteriano, tipicamente entre 2-3 anos. Processo deve ser gradual e sem punição.$ach7$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'marcos-desenvolvimento-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('marcos-desenvolvimento-infantil')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i7_0$Apresentou-se e acolheu a dúvida da família$i7_0$, 1, 0),
  ($i7_1$Pesquisou sinais de prontidão física (períodos secos, percepção da urgência)$i7_1$, 3, 1),
  ($i7_2$Pesquisou sinais de prontidão cognitiva/motora (entende instruções, veste-se)$i7_2$, 2, 2),
  ($i7_3$Descartou fatores que dificultam (constipação, ITU, estresse familiar)$i7_3$, 2, 3),
  ($i7_4$Orientou que não há uma idade fixa obrigatória, e sim sinais individuais$i7_4$, 2, 4),
  ($i7_5$Orientou abordagem gradual, positiva, sem punição ou pressão$i7_5$, 2, 5),
  ($i7_6$Orientou lidar com a pressão familiar de forma acolhedora$i7_6$, 1, 6),
  ($i7_7$Comunicação didática e tranquilizadora$i7_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t8$Pré-escolar que 'engasga' nas palavras$t8$,
    $e8$Desenvolvimento infantil$e8$,
    null,
    300,
    $q8$Os pais de Sofia, 3 anos, notaram que ela "repete sílabas e trava" ao falar há 1 mês.$q8$,
    $res8$Ambulatório. Os pais de Sofia, 3 anos, notaram que ela "repete sílabas e
trava" ao falar há 1 mês. Avalie a fala e diferencie disfluência fisiológica de gagueira. ~5 min.$res8$,
    $p8$Pais de Sofia, 3 anos$p8$,
    $ctx8$Pais ansiosos, acham que ela está 'gaguejando'. Respondam ao que for perguntado.$ctx8$,
    jsonb_build_array(
      $r8$Repete sílabas e palavras inteiras ('eu eu eu quero'), principalmente quando está animada ou cansada.$r8$,
      $r8$Não trava o ar, não faz caretas, não tem tensão facial nem repete com esforço/bloqueios.$r8$,
      $r8$Começou há cerca de 1 mês, sem evento estressor identificado.$r8$,
      $r8$Vocabulário cresceu muito nas últimas semanas; fala frases mais longas e complexas que antes.$r8$,
      $r8$Não evita falar, não se frustra com a própria fala. Sem história familiar de gagueira persistente.$r8$,
      $r8$Demais marcos do desenvolvimento adequados para a idade.$r8$
    ),
    $ach8$Disfluência fisiológica do desenvolvimento (comum entre 2-5 anos, coincide com salto na complexidade de linguagem): repetições simples, sem tensão/esforço, sem esquiva, flutuante. Diferente de gagueira verdadeira (bloqueios, tensão, prolongamentos, esquiva, frustração, história familiar).$ach8$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'marcos-desenvolvimento-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('marcos-desenvolvimento-infantil')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i8_0$Apresentou-se e caracterizou o tipo de disfluência (repetição x bloqueio)$i8_0$, 3, 0),
  ($i8_1$Pesquisou sinais de tensão física/esforço e esquiva da fala$i8_1$, 2, 1),
  ($i8_2$Pesquisou frustração da criança com a própria fala$i8_2$, 1, 2),
  ($i8_3$Investigou história familiar de gagueira$i8_3$, 1, 3),
  ($i8_4$Relacionou o quadro ao salto recente de vocabulário/linguagem$i8_4$, 1, 4),
  ($i8_5$Avaliou as demais áreas do desenvolvimento$i8_5$, 1, 5),
  ($i8_6$Reconheceu a disfluência fisiológica do desenvolvimento$i8_6$, 2, 6),
  ($i8_7$Orientou não corrigir/pressionar a criança ao falar$i8_7$, 2, 7),
  ($i8_8$Indicou sinais de alerta para encaminhar à fonoaudiologia$i8_8$, 1, 8),
  ($i8_9$Comunicação tranquilizadora$i8_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t9$Está pronta para a alfabetização?$t9$,
    $e9$Desenvolvimento infantil$e9$,
    null,
    300,
    $q9$Os pais de Helena, 5 anos e meio, perguntam se ela está "pronta" para entrar no 1º ano.$q9$,
    $res9$Puericultura. Os pais de Helena, 5 anos e meio, perguntam se ela está
"pronta" para entrar no 1º ano. Avalie a prontidão escolar e oriente. ~5 min.$res9$,
    $p9$Pais de Helena, 5 anos e 6 meses$p9$,
    $ctx9$Pais ansiosos com a alfabetização. Respondam ao que for perguntado.$ctx9$,
    jsonb_build_array(
      $r9$Reconhece e nomeia a maioria das letras e os números até 20; escreve o próprio nome.$r9$,
      $r9$Recorta com tesoura, desenha figura humana com detalhes, segura o lápis com pinça adequada.$r9$,
      $r9$Consegue ficar sentada e atenta em atividades por cerca de 15-20 minutos.$r9$,
      $r9$Segue regras de jogos simples, interage bem com outras crianças, espera a vez de falar.$r9$,
      $r9$Consegue contar uma história com começo, meio e fim de forma compreensível.$r9$,
      $r9$Sem queixas de audição ou visão; sem antecedentes de atraso no desenvolvimento.$r9$
    ),
    $ach9$Marcos compatíveis com prontidão para alfabetização: linguagem expressiva/compreensiva adequada, coordenação motora fina (pinça, recorte), atenção sustentada por tempo razoável para a idade, e habilidades sociais (regras, espera da vez). Sem sinais de alerta.$ach9$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'marcos-desenvolvimento-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('marcos-desenvolvimento-infantil')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i9_0$Apresentou-se e acolheu a dúvida da família$i9_0$, 1, 0),
  ($i9_1$Avaliou a linguagem (vocabulário, narrativa, compreensão)$i9_1$, 2, 1),
  ($i9_2$Avaliou a motricidade fina (pinça, recorte, desenho)$i9_2$, 2, 2),
  ($i9_3$Avaliou atenção/concentração para a idade$i9_3$, 2, 3),
  ($i9_4$Avaliou habilidades sociais e comportamentais (regras, espera da vez)$i9_4$, 2, 4),
  ($i9_5$Triou acuidade visual/auditiva como possíveis fatores limitantes$i9_5$, 1, 5),
  ($i9_6$Concluiu sobre a prontidão escolar de forma individualizada$i9_6$, 2, 6),
  ($i9_7$Orientou estímulos complementares e expectativas realistas$i9_7$, 1, 7),
  ($i9_8$Comunicação didática e acolhedora$i9_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t110$Lactente de 6 meses na puericultura$t110$,
    $e110$Desenvolvimento infantil$e110$,
    null,
    300,
    $q110$Puericultura de Lívia, 6 meses, trazida pela mãe para consulta de rotina.$q110$,
    $res110$Puericultura de Lívia, 6 meses, trazida pela mãe para consulta de rotina.
Avalie os marcos do desenvolvimento, diga se estão adequados e oriente. ~5 min.$res110$,
    $p110$Mãe de Lívia, 6 meses$p110$,
    $ctx110$Mãe tranquila, criança saudável. Responda só ao que for perguntado.$ctx110$,
    jsonb_build_array(
      $r110$Senta com apoio, sustenta bem a cabeça, rola para os dois lados.$r110$,
      $r110$Pega objetos e leva à boca; ainda não transfere de uma mão para a outra com firmeza.$r110$,
      $r110$Balbucia, sorri, vira-se para a voz e estranha pouco desconhecidos.$r110$,
      $r110$Nasceu a termo, sem intercorrências, mama no peito e está iniciando interesse por comida.$r110$,
      $r110$Vacinas em dia; ganho de peso adequado nas consultas.$r110$
    ),
    $ach110$Tônus normal, senta com apoio, preensão presente, interação social adequada. Sem sinais de alerta.$ach110$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'marcos-desenvolvimento-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('marcos-desenvolvimento-infantil')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i110_0$Apresentou-se e identificou criança/responsável$i110_0$, 1, 0),
  ($i110_1$Avaliou motor grosseiro (cabeça, rolar, sentar com apoio)$i110_1$, 2, 1),
  ($i110_2$Avaliou motricidade fina (preensão/transferência)$i110_2$, 1, 2),
  ($i110_3$Avaliou linguagem (balbucio) e social (sorriso, estranhamento)$i110_3$, 2, 3),
  ($i110_4$Reconheceu marcos adequados para 6 meses$i110_4$, 2, 4),
  ($i110_5$Verificou alimentação e prontidão para introdução alimentar$i110_5$, 1, 5),
  ($i110_6$Reforçou vacinação e seguimento$i110_6$, 1, 6),
  ($i110_7$Tranquilizou a mãe sem banalizar a vigilância do desenvolvimento$i110_7$, 1, 7),
  ($i110_8$Comunicação empática e clara$i110_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t111$Criança que não anda aos 18 meses$t111$,
    $e111$Desenvolvimento infantil$e111$,
    null,
    300,
    $q111$A mãe de Théo, 18 meses, relata que ele ainda não anda sozinho.$q111$,
    $res111$A mãe de Théo, 18 meses, relata que ele ainda não anda sozinho.
Avalie, identifique sinal de alerta e defina conduta. ~5 min.$res111$,
    $p111$Mãe de Théo, 18 meses$p111$,
    $ctx111$Mãe preocupada. Responda só ao que for perguntado.$ctx111$,
    jsonb_build_array(
      $r111$Anda apoiado em móveis desde os 14 meses, mas não dá passos sem apoio.$r111$,
      $r111$Sentou sozinho com ~9 meses; engatinhou com ~12 meses.$r111$,
      $r111$Fala 'mamã', 'papá' e mais umas poucas palavras; aponta o que quer.$r111$,
      $r111$Nasceu a termo, sem internações; um tio andou 'tarde' também.$r111$,
      $r111$Brinca, interage e entende ordens simples.$r111$
    ),
    $ach111$Sem dismorfias; tônus e força preservados; reflexos normais; marcha independente ausente aos 18m.$ach111$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'marcos-desenvolvimento-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('marcos-desenvolvimento-infantil')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i111_0$Apresentou-se e identificou criança/responsável$i111_0$, 1, 0),
  ($i111_1$Detalhou a aquisição da marcha e marcos motores prévios$i111_1$, 2, 1),
  ($i111_2$Avaliou linguagem e social/adaptativo$i111_2$, 1, 2),
  ($i111_3$Investigou antecedentes pré/peri/pós-natais e familiares$i111_3$, 1, 3),
  ($i111_4$Reconheceu não andar aos 18 meses como sinal de alerta$i111_4$, 3, 4),
  ($i111_5$Avaliou tônus e força para excluir doença neuromuscular$i111_5$, 2, 5),
  ($i111_6$Propôs investigação/encaminhamento adequado$i111_6$, 2, 6),
  ($i111_7$Comunicação empática, sem alarmar excessivamente$i111_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t112$Perda de habilidades já adquiridas$t112$,
    $e112$Desenvolvimento infantil$e112$,
    null,
    300,
    $q112$A mãe de Sofia, 15 meses, conta que ela "desaprendeu" coisas que já fazia.$q112$,
    $res112$A mãe de Sofia, 15 meses, conta que ela "desaprendeu" coisas que já fazia.
Avalie e reconheça a gravidade do quadro. ~5 min.$res112$,
    $p112$Mãe de Sofia, 15 meses$p112$,
    $ctx112$Mãe assustada. Responda só ao que for perguntado.$ctx112$,
    jsonb_build_array(
      $r112$Já falava algumas palavras e batia palmas; há semanas parou de falar e de interagir.$r112$,
      $r112$Andava com apoio e agora cambaleia mais e cai com frequência.$r112$,
      $r112$Faz movimentos repetitivos com as mãos e evita contato visual.$r112$,
      $r112$Nasceu a termo; desenvolvimento era considerado normal até cerca de 12 meses.$r112$,
      $r112$Sem febre; sem trauma conhecido.$r112$
    ),
    $ach112$Regressão de marcos motores e de linguagem; estereotipias manuais; redução do contato social.$ach112$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'marcos-desenvolvimento-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('marcos-desenvolvimento-infantil')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i112_0$Apresentou-se e identificou criança/responsável$i112_0$, 1, 0),
  ($i112_1$Caracterizou quais marcos foram perdidos e em quanto tempo$i112_1$, 3, 1),
  ($i112_2$Diferenciou atraso de regressão do desenvolvimento$i112_2$, 2, 2),
  ($i112_3$Reconheceu a regressão como sinal de alerta grave$i112_3$, 3, 3),
  ($i112_4$Investigou antecedentes e fatores associados$i112_4$, 1, 4),
  ($i112_5$Indicou encaminhamento/investigação especializada com prioridade$i112_5$, 2, 5),
  ($i112_6$Comunicação empática diante da angústia materna$i112_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t113$Pré-escolar que fala pouco e não responde ao chamado$t113$,
    $e113$Desenvolvimento infantil$e113$,
    null,
    300,
    $q113$Os pais de Caio, 3 anos, acham que ele "não escuta direito" e fala pouco.$q113$,
    $res113$Os pais de Caio, 3 anos, acham que ele "não escuta direito" e fala pouco.
Avalie a linguagem, levante a hipótese auditiva e oriente. ~5 min.$res113$,
    $p113$Mãe de Caio, 3 anos$p113$,
    $ctx113$Mãe atenta. Responda só ao que for perguntado.$ctx113$,
    jsonb_build_array(
      $r113$Fala poucas palavras soltas, não forma frases; aponta e puxa pela mão.$r113$,
      $r113$Às vezes não atende quando chamam, mas reage a sons altos.$r113$,
      $r113$Teve várias otites no último ano.$r113$,
      $r113$Nasceu a termo; não lembra se fez o teste da orelhinha.$r113$,
      $r113$Interage, brinca e mantém contato visual.$r113$
    ),
    $ach113$Linguagem expressiva pobre para a idade; interação social preservada; antecedente de otites de repetição.$ach113$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'marcos-desenvolvimento-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('marcos-desenvolvimento-infantil')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i113_0$Apresentou-se e identificou criança/responsável$i113_0$, 1, 0),
  ($i113_1$Caracterizou a linguagem expressiva e receptiva$i113_1$, 2, 1),
  ($i113_2$Investigou resposta a sons e antecedente de otites$i113_2$, 2, 2),
  ($i113_3$Perguntou sobre triagem auditiva neonatal (teste da orelhinha)$i113_3$, 2, 3),
  ($i113_4$Levantou hipótese de déficit auditivo afetando a linguagem$i113_4$, 2, 4),
  ($i113_5$Avaliou social para diferenciar de TEA$i113_5$, 1, 5),
  ($i113_6$Indicou avaliação auditiva/fonoaudiológica$i113_6$, 2, 6),
  ($i113_7$Comunicação clara e acolhedora$i113_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t114$Avaliação da motricidade fina ao ano de idade$t114$,
    $e114$Desenvolvimento infantil$e114$,
    null,
    300,
    $q114$Puericultura de Bento, 12 meses. A mãe pergunta se a "coordenação das mãos" está normal.$q114$,
    $res114$Puericultura de Bento, 12 meses. A mãe pergunta se a "coordenação das mãos" está normal.
Avalie a motricidade fina e os demais marcos. ~5 min.$res114$,
    $p114$Mãe de Bento, 12 meses$p114$,
    $ctx114$Mãe curiosa, criança saudável. Responda só ao que for perguntado.$ctx114$,
    jsonb_build_array(
      $r114$Pega objetos pequenos com o polegar e o indicador (pinça) e bate dois cubos.$r114$,
      $r114$Fica de pé com apoio e dá passos segurando nos móveis.$r114$,
      $r114$Fala 'mamã'/'papá' com sentido e aponta o que quer.$r114$,
      $r114$Estranha desconhecidos, dá tchau e brinca de esconde-achou.$r114$,
      $r114$Nasceu a termo, vacinas em dia.$r114$
    ),
    $ach114$Pinça superior presente; transfere e bate objetos; marcos motores, de linguagem e sociais adequados para 12m.$ach114$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'marcos-desenvolvimento-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('marcos-desenvolvimento-infantil')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i114_0$Apresentou-se e identificou criança/responsável$i114_0$, 1, 0),
  ($i114_1$Avaliou pinça e habilidades manuais (bater cubos, soltar)$i114_1$, 3, 1),
  ($i114_2$Avaliou motor grosseiro (ficar em pé, passos com apoio)$i114_2$, 1, 2),
  ($i114_3$Avaliou linguagem e social/adaptativo$i114_3$, 2, 3),
  ($i114_4$Reconheceu marcos adequados para 12 meses$i114_4$, 2, 4),
  ($i114_5$Orientou estímulos apropriados$i114_5$, 1, 5),
  ($i114_6$Comunicação empática e clara$i114_6$, 1, 6)
) as v(texto, grav, ord);
