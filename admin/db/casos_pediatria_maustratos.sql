-- Migracao automatica de cases.js -> Supabase (status em_revisao).
-- Gerado por gen_migracao_pediatria.js. Rodar DEPOIS de migracao_taxonomia_pediatria.sql.

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t30$Lesões que não combinam com a história$t30$,
    $e30$Maus-tratos na infância$e30$,
    null,
    300,
    $q30$Lactente de 8 meses trazido por "queda do sofá", com hematomas de cores diferentes.$q30$,
    $res30$Pronto-socorro. Lactente de 8 meses trazido por "queda do sofá", com
hematomas de cores diferentes. Avalie, identifique sinais de alerta e conduza. ~5 min.$res30$,
    $p30$Cuidador de lactente, 8 meses$p30$,
    $ctx30$Cuidador defensivo, muda a história. Mostre achados quando solicitados.$ctx30$,
    jsonb_build_array(
      $r30$História: 'caiu do sofá hoje'. Demorou horas para procurar atendimento.$r30$,
      $r30$Ao detalhar, a história muda e fica vaga.$r30$,
      $r30$Achados: hematomas em dorso, coxas, braços e orelha, em estágios (cores) diferentes.$r30$,
      $r30$Há uma marca que lembra o formato de um objeto.$r30$,
      $r30$O bebê está assustado e evita contato; o cuidador se irrita com as perguntas.$r30$
    ),
    $ach30$Múltiplos hematomas em estágios diferentes, em locais não usuais (dorso, coxa, orelha), com marca de objeto. Lesões incompatíveis com o relato e com a fase do desenvolvimento → sinais de alerta para maus-tratos físicos.$ach30$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'maus-tratos-na-infancia')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('maus-tratos-na-infancia')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i30_0$Apresentou-se e colheu a história do trauma com cuidado$i30_0$, 1, 0),
  ($i30_1$Identificou incompatibilidade entre lesão, história e desenvolvimento$i30_1$, 3, 1),
  ($i30_2$Descreveu/documentou as lesões objetivamente (local, estágios)$i30_2$, 2, 2),
  ($i30_3$Pesquisou lesões em locais não usuais e outros sinais de alerta$i30_3$, 2, 3),
  ($i30_4$Considerou investigação (survey ósseo, fundo de olho, coagulograma p/ ddx)$i30_4$, 2, 4),
  ($i30_5$Garantiu a proteção/segurança imediata da criança$i30_5$, 2, 5),
  ($i30_6$Reconheceu a notificação compulsória e acionou o Conselho Tutelar$i30_6$, 3, 6),
  ($i30_7$Manteve postura não acusatória e acolhedora com a criança$i30_7$, 1, 7),
  ($i30_8$Documentou adequadamente em prontuário$i30_8$, 1, 8),
  ($i30_9$Comunicação cuidadosa$i30_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t31$Criança que falta às consultas e não ganha peso$t31$,
    $e31$Maus-tratos na infância$e31$,
    null,
    300,
    $q31$Criança de 2 anos com baixo peso, atraso e faltas repetidas.$q31$,
    $res31$Ambulatório. Criança de 2 anos com baixo peso, atraso e faltas repetidas.
Avalie possível negligência e conduza. ~5 min.$res31$,
    $p31$Cuidador(a) de criança, 2 anos$p31$,
    $ctx31$Cuidador(a) com dificuldades sociais. Responda sem se sentir julgado(a).$ctx31$,
    jsonb_build_array(
      $r31$Faltou a várias consultas; vacinas atrasadas.$r31$,
      $r31$Criança magra, roupas sujas, fica muito tempo sozinha ou com vizinhos.$r31$,
      $r31$Alimentação irregular; relato de uso de álcool e dificuldades financeiras.$r31$,
      $r31$Achados: desnutrição, má higiene, dermatite de fralda crônica, atraso no desenvolvimento.$r31$
    ),
    $ach31$Desnutrição, má higiene, vacinação atrasada, atraso no desenvolvimento e cuidados inconsistentes → negligência. Avaliar contexto social e segurança da criança.$ach31$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'maus-tratos-na-infancia')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('maus-tratos-na-infancia')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i31_0$Apresentou-se e construiu vínculo, sem julgamento$i31_0$, 1, 0),
  ($i31_1$Avaliou estado nutricional e curva de crescimento$i31_1$, 2, 1),
  ($i31_2$Verificou vacinas, consultas e adesão ao seguimento$i31_2$, 2, 2),
  ($i31_3$Investigou contexto social, cuidadores e fatores de risco$i31_3$, 2, 3),
  ($i31_4$Avaliou higiene, desenvolvimento e sinais de descuido$i31_4$, 2, 4),
  ($i31_5$Reconheceu a negligência como forma de maus-tratos$i31_5$, 2, 5),
  ($i31_6$Acionou rede de proteção (Conselho Tutelar, assistência social)$i31_6$, 3, 6),
  ($i31_7$Definiu plano de cuidado e seguimento próximo$i31_7$, 1, 7),
  ($i31_8$Documentou e notificou$i31_8$, 1, 8),
  ($i31_9$Comunicação acolhedora$i31_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t32$Revelação de possível abuso sexual$t32$,
    $e32$Maus-tratos na infância$e32$,
    null,
    300,
    $q32$A mãe relata que a filha de 5 anos "contou algo" e tem queixas geniturinárias.$q32$,
    $res32$Ambulatório. A mãe relata que a filha de 5 anos "contou algo" e tem
queixas geniturinárias. Conduza a abordagem inicial e a conduta. ~5 min.$res32$,
    $p32$Mãe de criança, 5 anos$p32$,
    $ctx32$Mãe assustada e culpada. Tema delicado — conduza com sensibilidade.$ctx32$,
    jsonb_build_array(
      $r32$A criança fez relato e teve comportamento sexualizado incompatível com a idade.$r32$,
      $r32$Queixas físicas: disúria, dor, corrimento.$r32$,
      $r32$Mudanças de comportamento: regressão, pesadelos, medo de uma pessoa próxima.$r32$,
      $r32$Achados: o exame pode ser normal e não exclui abuso — evite reexame invasivo.$r32$
    ),
    $ach32$Relato + sinais comportamentais e geniturinários sugestivos. Exame deve ser conduzido por serviço especializado/forense; achados físicos normais NÃO excluem abuso.$ach32$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'maus-tratos-na-infancia')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('maus-tratos-na-infancia')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i32_0$Apresentou-se e acolheu mãe e criança com sensibilidade$i32_0$, 2, 0),
  ($i32_1$Ouviu o relato sem induzir nem repetir perguntas$i32_1$, 2, 1),
  ($i32_2$Pesquisou sintomas físicos e comportamentais$i32_2$, 2, 2),
  ($i32_3$Evitou reexame invasivo e encaminhou a serviço especializado$i32_3$, 2, 3),
  ($i32_4$Reconheceu a necessidade de proteção imediata$i32_4$, 2, 4),
  ($i32_5$Considerou profilaxias/coleta conforme tempo e protocolo$i32_5$, 2, 5),
  ($i32_6$Acionou notificação compulsória e Conselho Tutelar/autoridades$i32_6$, 3, 6),
  ($i32_7$Garantiu sigilo e cuidado emocional$i32_7$, 1, 7),
  ($i32_8$Documentou de forma objetiva$i32_8$, 1, 8),
  ($i32_9$Comunicação sensível, sem revitimização$i32_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t33$Bebê irritado e sonolento sem trauma relatado$t33$,
    $e33$Maus-tratos na infância$e33$,
    null,
    300,
    $q33$Lactente de 3 meses com irritabilidade, vômitos e sonolência, sem trauma relatado.$q33$,
    $res33$Pronto-socorro. Lactente de 3 meses com irritabilidade, vômitos e
sonolência, sem trauma relatado. Avalie e reconheça o quadro. ~5 min.$res33$,
    $p33$Cuidador de lactente, 3 meses$p33$,
    $ctx33$Cuidador nega trauma. Informe achados quando solicitados.$ctx33$,
    jsonb_build_array(
      $r33$Choro intenso, depois vômitos e muita sonolência; sem febre.$r33$,
      $r33$Não há história de trauma; 'começou do nada'.$r33$,
      $r33$Estava sozinho com o bebê, que 'não parava de chorar'.$r33$,
      $r33$Achados: fontanela abaulada/tensa, sonolento, pálido; fundo de olho com hemorragias retinianas.$r33$
    ),
    $ach33$Rebaixamento, fontanela abaulada e hemorragias retinianas sem história de trauma → suspeita de trauma craniano abusivo (síndrome do bebê sacudido). Solicitar neuroimagem e avaliação oftalmológica.$ach33$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'maus-tratos-na-infancia')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('maus-tratos-na-infancia')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i33_0$Apresentou-se e colheu história detalhada do quadro$i33_0$, 1, 0),
  ($i33_1$Avaliou nível de consciência e sinais neurológicos$i33_1$, 2, 1),
  ($i33_2$Examinou a fontanela e sinais de hipertensão intracraniana$i33_2$, 2, 2),
  ($i33_3$Valorizou quadro grave SEM história de trauma compatível$i33_3$, 2, 3),
  ($i33_4$Solicitou neuroimagem (TC) e fundo de olho$i33_4$, 3, 4),
  ($i33_5$Reconheceu o trauma craniano abusivo (bebê sacudido)$i33_5$, 3, 5),
  ($i33_6$Garantiu estabilização e proteção da criança$i33_6$, 2, 6),
  ($i33_7$Acionou notificação e Conselho Tutelar$i33_7$, 2, 7),
  ($i33_8$Comunicação cuidadosa e não acusatória$i33_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t34$Conduzindo a notificação de maus-tratos$t34$,
    $e34$Maus-tratos na infância$e34$,
    null,
    300,
    $q34$Você confirmou a suspeita de maus-tratos numa criança de 6 anos.$q34$,
    $res34$Você confirmou a suspeita de maus-tratos numa criança de 6 anos.
Conduza a comunicação com o cuidador e as providências de proteção e notificação. ~5 min.$res34$,
    $p34$Cuidador de criança, 6 anos$p34$,
    $ctx34$Cuidador fica defensivo e quer levar a criança embora imediatamente.$ctx34$,
    jsonb_build_array(
      $r34$Pergunta, irritado, 'o que vocês vão fazer' e 'estão me acusando?'.$r34$,
      $r34$Insiste em levar a criança embora na hora.$r34$,
      $r34$Pressiona para que nada seja registrado.$r34$
    ),
    $ach34$Cenário de comunicação e conduta protetiva. Pontos-chave: a notificação é compulsória diante de SUSPEITA (não exige prova), prioridade é a segurança da criança e o acionamento da rede de proteção.$ach34$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'maus-tratos-na-infancia')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('maus-tratos-na-infancia')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i34_0$Manteve postura calma, acolhedora e não acusatória$i34_0$, 2, 0),
  ($i34_1$Explicou que a notificação é dever legal diante de suspeita (sem exigir prova)$i34_1$, 3, 1),
  ($i34_2$Priorizou a segurança imediata da criança$i34_2$, 2, 2),
  ($i34_3$Preencheu a ficha de notificação compulsória (SINAN)$i34_3$, 2, 3),
  ($i34_4$Acionou o Conselho Tutelar (e autoridades se risco iminente)$i34_4$, 3, 4),
  ($i34_5$Não liberou a criança em risco sem articular proteção$i34_5$, 2, 5),
  ($i34_6$Acionou equipe multiprofissional / assistência social$i34_6$, 1, 6),
  ($i34_7$Documentou objetivamente em prontuário$i34_7$, 2, 7),
  ($i34_8$Comunicação ética e centrada na criança$i34_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t35$Atendimento agudo de violência sexual$t35$,
    $e35$Maus-tratos na infância$e35$,
    null,
    300,
    $q35$Adolescente de 14 anos trazida pela mãe relatando abuso sexual ocorrido há 10 horas.$q35$,
    $res35$Pronto-socorro. Adolescente de 14 anos trazida pela mãe relatando
abuso sexual ocorrido há 10 horas. Conduza o atendimento agudo. ~5 min.$res35$,
    $p35$Adolescente, 14 anos, acompanhada da mãe$p35$,
    $ctx35$Mãe pergunta se precisa primeiro registrar boletim de ocorrência (B.O.) antes do atendimento.$ctx35$,
    jsonb_build_array(
      $r35$Relata abuso sexual com penetração vaginal há 10 horas, por um conhecido.$r35$,
      $r35$Mãe pergunta: 'a gente precisa ir na delegacia/fazer B.O. primeiro?'$r35$,
      $r35$Adolescente sem sangramento ativo importante, hemodinamicamente estável.$r35$,
      $r35$Não sabe informar com certeza o status vacinal contra hepatite B.$r35$,
      $r35$Pergunta se vai precisar tomar muitos remédios e se isso vai 'evitar uma gravidez'.$r35$
    ),
    $ach35$Atendimento deve ocorrer independentemente de B.O./laudo do IML — esses NÃO são pré-requisitos para o acolhimento. Dentro da janela de até 72 horas: profilaxias para IST (incluindo HIV) e contracepção de emergência (levonorgestrel, eficaz até 72h, idealmente até 5 dias) são indicadas. Coleta de vestígios (esfregaço vaginal) viável até 72h. Notificação compulsória obrigatória em até 24 horas. Vacinação/imunoglobulina para hepatite B conforme status vacinal.$ach35$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'maus-tratos-na-infancia')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('maus-tratos-na-infancia')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i35_0$Acolheu a adolescente e a mãe com privacidade e sem julgamento$i35_0$, 2, 0),
  ($i35_1$Esclareceu que o atendimento NÃO depende de B.O. ou laudo do IML$i35_1$, 3, 1),
  ($i35_2$Reconheceu a janela de até 72h para profilaxias e coleta de vestígios$i35_2$, 2, 2),
  ($i35_3$Indicou contracepção de emergência (levonorgestrel)$i35_3$, 2, 3),
  ($i35_4$Indicou profilaxia para IST/HIV conforme protocolo$i35_4$, 2, 4),
  ($i35_5$Avaliou e indicou profilaxia/vacinação para hepatite B$i35_5$, 1, 5),
  ($i35_6$Mencionou a notificação compulsória em até 24 horas$i35_6$, 3, 6),
  ($i35_7$Explicou o seguimento ambulatorial necessário$i35_7$, 1, 7),
  ($i35_8$Comunicação acolhedora e sem revitimização$i35_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t36$Retorno após violência sexual$t36$,
    $e36$Maus-tratos na infância$e36$,
    null,
    300,
    $q36$Adolescente retorna 2 semanas após atendimento agudo por violência sexual.$q36$,
    $res36$Ambulatório. Adolescente retorna 2 semanas após atendimento agudo por
violência sexual. Conduza o seguimento clínico e sorológico. ~5 min.$res36$,
    $p36$Adolescente, 15 anos, em retorno$p36$,
    $ctx36$Já recebeu profilaxias no atendimento agudo. Pergunta sobre os próximos exames.$ctx36$,
    jsonb_build_array(
      $r36$Recebeu profilaxia para IST e contracepção de emergência no atendimento há 2 semanas.$r36$,
      $r36$Está em acompanhamento psicológico, refere melhora do sono.$r36$,
      $r36$Pergunta: 'eu já fiz os exames, por que preciso voltar mais vezes?'$r36$,
      $r36$Sem sintomas novos; nega sangramentos ou corrimentos.$r36$
    ),
    $ach36$Seguimento sorológico para HIV, sífilis e hepatites deve ser repetido em 2 semanas, 3 meses e 6 meses após o episódio, já que a sorologia inicial pode ser falsamente negativa na janela imunológica. Reforçar adesão às profilaxias já iniciadas, suporte psicológico continuado e avaliação ginecológica se indicado.$ach36$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'maus-tratos-na-infancia')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('maus-tratos-na-infancia')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i36_0$Apresentou-se e acolheu a adolescente no retorno$i36_0$, 1, 0),
  ($i36_1$Revisou as profilaxias realizadas no atendimento agudo$i36_1$, 2, 1),
  ($i36_2$Explicou a necessidade do seguimento sorológico (janela imunológica)$i36_2$, 3, 2),
  ($i36_3$Indicou o cronograma correto (2 semanas, 3 meses e 6 meses)$i36_3$, 3, 3),
  ($i36_4$Avaliou o suporte psicológico em andamento$i36_4$, 2, 4),
  ($i36_5$Reforçou a importância de manter o seguimento mesmo sem sintomas$i36_5$, 2, 5),
  ($i36_6$Comunicação acolhedora e sem julgamento$i36_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t37$Notificação após tentativa de suicídio$t37$,
    $e37$Maus-tratos na infância$e37$,
    null,
    300,
    $q37$Adolescente de 16 anos atendida após ingestão proposital de medicamentos.$q37$,
    $res37$Pronto-socorro. Adolescente de 16 anos atendida após ingestão proposital
de medicamentos. Conduza a notificação e o encaminhamento. ~5 min.$res37$,
    $p37$Adolescente, 16 anos, pós-atendimento clínico estabilizado$p37$,
    $ctx37$Já estabilizada clinicamente. Pais presentes, sem saber dos próximos passos.$ctx37$,
    jsonb_build_array(
      $r37$Ingeriu intencionalmente comprimidos após briga familiar; já recebeu tratamento clínico e está estável.$r37$,
      $r37$Pais perguntam se 'isso precisa ser informado para alguém' e se 'ela vai ter problema com a polícia'.$r37$,
      $r37$Adolescente relata tristeza persistente há semanas, mas nega tentativas anteriores.$r37$,
      $r37$Pergunta se vai precisar ficar internada.$r37$
    ),
    $ach37$Tentativa de suicídio é de notificação compulsória em até 24 horas, assim como violência sexual, independentemente de não envolver terceiros — não é uma questão policial, é vigilância em saúde. Avaliação de risco de repetição, suporte da saúde mental (psiquiatria/psicologia) e segurança do ambiente domiciliar (acesso a meios letais) devem ser garantidos antes da alta.$ach37$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'maus-tratos-na-infancia')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('maus-tratos-na-infancia')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i37_0$Apresentou-se e acolheu adolescente e família sem julgamento$i37_0$, 2, 0),
  ($i37_1$Esclareceu a natureza de saúde pública da notificação (não é policial)$i37_1$, 2, 1),
  ($i37_2$Indicou a notificação compulsória em até 24 horas$i37_2$, 3, 2),
  ($i37_3$Avaliou risco de repetição e ideação suicida atual$i37_3$, 2, 3),
  ($i37_4$Avaliou a segurança do ambiente domiciliar (acesso a meios letais)$i37_4$, 2, 4),
  ($i37_5$Encaminhou para avaliação de saúde mental antes da alta$i37_5$, 2, 5),
  ($i37_6$Comunicação acolhedora, sem estigmatizar$i37_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t38$Lactente irritado e sonolento após 'parar de chorar de repente'$t38$,
    $e38$Maus-tratos na infância$e38$,
    null,
    300,
    $q38$Lactente de 3 meses trazido por vômitos e sonolência após "chorar muito e parar de repente".$q38$,
    $res38$Pronto-socorro. Lactente de 3 meses trazido por vômitos e sonolência
após "chorar muito e parar de repente". Avalie a possibilidade de síndrome do
bebê sacudido. ~5 min.$res38$,
    $p38$Cuidador de lactente, 3 meses$p38$,
    $ctx38$Cuidador nervoso, com respostas pouco consistentes sobre o ocorrido. Informe achados quando solicitados.$ctx38$,
    jsonb_build_array(
      $r38$Relata que o bebê 'chorou muito, depois parou de repente e ficou mole'.$r38$,
      $r38$Quando questionado sobre o mecanismo, muda os detalhes da história (inconsistência).$r38$,
      $r38$Achados (se solicitados): letargia, vômitos, fontanela um pouco abaulada, sem trauma externo visível.$r38$,
      $r38$Sem febre. Sem outras marcas no corpo visíveis a princípio.$r38$,
      $r38$Exames (se pedidos): tomografia/RM mostrando hemorragia subdural; fundo de olho com hemorragias retinianas.$r38$
    ),
    $ach38$Tríade clássica da síndrome do bebê sacudido: hemorragia subdural, hemorragia retiniana e encefalopatia, sem trauma externo evidente — mecanismo de aceleração/desaceleração rotacional. História inconsistente ou incompatível com a gravidade da lesão é sinal de alerta para maus-tratos. Notificação compulsória obrigatória.$ach38$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'maus-tratos-na-infancia')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('maus-tratos-na-infancia')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i38_0$Apresentou-se e colheu a história com atenção a inconsistências$i38_0$, 2, 0),
  ($i38_1$Examinou fontanela, sinais neurológicos e procurou trauma externo$i38_1$, 2, 1),
  ($i38_2$Solicitou neuroimagem e avaliação de fundo de olho$i38_2$, 2, 2),
  ($i38_3$Reconheceu a tríade sugestiva de síndrome do bebê sacudido$i38_3$, 3, 3),
  ($i38_4$Identificou a incompatibilidade entre história e gravidade do quadro$i38_4$, 2, 4),
  ($i38_5$Indicou a notificação compulsória$i38_5$, 3, 5),
  ($i38_6$Comunicação cuidadosa, sem acusações diretas, mantendo foco assistencial$i38_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t39$Fratura em lactente que ainda não anda$t39$,
    $e39$Maus-tratos na infância$e39$,
    null,
    300,
    $q39$Lactente de 7 meses, ainda não deambula, trazido com choro ao manipular o braço.$q39$,
    $res39$Pronto-socorro. Lactente de 7 meses, ainda não deambula, trazido com
choro ao manipular o braço. Avalie a suspeita de fratura não acidental. ~5 min.$res39$,
    $p39$Cuidador de lactente, 7 meses$p39$,
    $ctx39$Cuidador com explicação pouco plausível para a lesão. Informe achados quando solicitados.$ctx39$,
    jsonb_build_array(
      $r39$Relata que o braço do bebê 'ficou daquele jeito' depois de uma queda do sofá ontem.$r39$,
      $r39$Lactente ainda não senta sem apoio, não engatinha, não anda.$r39$,
      $r39$Achados (se solicitados): dor à manipulação do braço, edema localizado.$r39$,
      $r39$Exame radiográfico (se pedido): fratura em espiral do úmero; achado incidental de fratura em consolidação de costela.$r39$,
      $r39$Sem outras explicações fornecidas espontaneamente para a fratura de costela.$r39$
    ),
    $ach39$Fratura em criança que ainda não tem mobilidade compatível com o mecanismo relatado (lactente não deambulante) é sinal de alerta. Fraturas em espiral de ossos longos e fraturas de costela (raras em quedas domésticas comuns) em diferentes estágios de consolidação sugerem trauma não acidental/abuso físico. Avaliação radiológica completa (rastreio de lesões ósseas ocultas) e notificação compulsória são obrigatórias.$ach39$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'maus-tratos-na-infancia')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('maus-tratos-na-infancia')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i39_0$Apresentou-se e colheu a história do mecanismo de trauma$i39_0$, 2, 0),
  ($i39_1$Avaliou a compatibilidade entre mecanismo relatado e marco motor da criança$i39_1$, 3, 1),
  ($i39_2$Examinou e descreveu a lesão (localização, edema, dor)$i39_2$, 1, 2),
  ($i39_3$Solicitou avaliação radiológica ampliada (rastreio de fraturas ocultas)$i39_3$, 2, 3),
  ($i39_4$Reconheceu o padrão sugestivo de abuso físico (fraturas múltiplas/estágios distintos)$i39_4$, 3, 4),
  ($i39_5$Indicou a notificação compulsória$i39_5$, 3, 5),
  ($i39_6$Comunicação cuidadosa e centrada na proteção da criança$i39_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t125$Queimadura com padrão suspeito$t125$,
    $e125$Pediatria / Proteção à criança$e125$,
    null,
    300,
    $q125$Pré-escolar de 2 anos levado por queimadura nos pés/nádegas. A história não bate com a lesão.$q125$,
    $res125$Pré-escolar de 2 anos levado por queimadura nos pés/nádegas. A história não bate com a lesão.
Avalie, reconheça sinais de alerta e defina conduta. ~5 min.$res125$,
    $p125$Acompanhante de criança de 2 anos$p125$,
    $ctx125$Acompanhante evasivo, muda a versão dos fatos. Responda só ao que for perguntado.$ctx125$,
    jsonb_build_array(
      $r125$Diz que a criança 'mexeu sozinha' na água quente, mas hesita nos detalhes.$r125$,
      $r125$A queimadura é nos dois pés e nádegas, com borda nítida, poupando dobras.$r125$,
      $r125$Demorou mais de um dia para procurar atendimento.$r125$,
      $r125$A criança é quieta e parece com medo do adulto.$r125$
    ),
    $ach125$Queimadura simétrica em 'luva/meia' com limite nítido (padrão de imersão); atraso na procura; criança retraída.$ach125$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'maus-tratos-na-infancia')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('maus-tratos-na-infancia')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i125_0$Apresentou-se e acolheu a criança$i125_0$, 1, 0),
  ($i125_1$Colheu a história observando inconsistências e atraso na busca$i125_1$, 2, 1),
  ($i125_2$Descreveu o padrão da queimadura (simetria, bordas, imersão)$i125_2$, 3, 2),
  ($i125_3$Reconheceu incompatibilidade entre história e lesão$i125_3$, 3, 3),
  ($i125_4$Garantiu proteção imediata e cuidado da queimadura$i125_4$, 1, 4),
  ($i125_5$Indicou notificação compulsória e Conselho Tutelar$i125_5$, 2, 5),
  ($i125_6$Comunicação sem julgamento/sem confronto agressivo$i125_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t126$Atendimento não exige boletim de ocorrência$t126$,
    $e126$Pediatria / Proteção à criança$e126$,
    null,
    300,
    $q126$Adolescente de 11 anos trazida pela tia com suspeita de violência. A família pergunta se "precisa de BO antes".$q126$,
    $res126$Adolescente de 11 anos trazida pela tia com suspeita de violência. A família pergunta se "precisa de BO antes".
Conduza o atendimento e a notificação corretamente. ~5 min.$res126$,
    $p126$Tia de adolescente de 11 anos$p126$,
    $ctx126$Tia protetora, insegura sobre o que fazer. Responda só ao que for perguntado.$ctx126$,
    jsonb_build_array(
      $r126$Pergunta se precisa registrar boletim de ocorrência antes de a criança ser atendida.$r126$,
      $r126$Teme expor a criança a repetir a história várias vezes.$r126$,
      $r126$Quer saber quem precisa ser avisado.$r126$,
      $r126$A adolescente está retraída, mas colaborativa.$r126$
    ),
    $ach126$Adolescente estável; relato sugestivo de violência; necessidade de acolhimento, proteção e notificação.$ach126$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'maus-tratos-na-infancia')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('maus-tratos-na-infancia')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i126_0$Apresentou-se e acolheu em ambiente reservado$i126_0$, 1, 0),
  ($i126_1$Esclareceu que o atendimento NÃO depende de BO ou laudo do IML$i126_1$, 3, 1),
  ($i126_2$Garantiu escuta única e sem revitimização$i126_2$, 2, 2),
  ($i126_3$Indicou notificação compulsória (imediata, <24h em violência sexual)$i126_3$, 3, 3),
  ($i126_4$Indicou comunicação ao Conselho Tutelar$i126_4$, 2, 4),
  ($i126_5$Registrou minuciosamente em prontuário$i126_5$, 1, 5),
  ($i126_6$Comunicação empática, sem culpabilizar a vítima$i126_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t127$Sinais de violência psicológica/emocional$t127$,
    $e127$Pediatria / Proteção à criança$e127$,
    null,
    300,
    $q127$Escolar de 8 anos com queixas vagas, queda escolar e medo de um familiar.$q127$,
    $res127$Escolar de 8 anos com queixas vagas, queda escolar e medo de um familiar.
Avalie sinais comportamentais e defina conduta. ~5 min.$res127$,
    $p127$Mãe de escolar de 8 anos$p127$,
    $ctx127$Mãe relata que o filho 'mudou'. Responda só ao que for perguntado.$ctx127$,
    jsonb_build_array(
      $r127$A criança ficou retraída, chora fácil e tem medo de ficar com um adulto específico.$r127$,
      $r127$Caiu o rendimento na escola e voltou a fazer xixi na cama.$r127$,
      $r127$Queixas de dor de barriga sem causa clara.$r127$,
      $r127$Sem lesões físicas visíveis.$r127$
    ),
    $ach127$Exame físico sem lesões; sinais comportamentais: regressão (enurese), medo de adulto específico, isolamento e queda escolar.$ach127$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'maus-tratos-na-infancia')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('maus-tratos-na-infancia')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i127_0$Apresentou-se e acolheu a criança$i127_0$, 1, 0),
  ($i127_1$Reconheceu sinais comportamentais/emocionais de maus-tratos$i127_1$, 3, 1),
  ($i127_2$Valorizou regressão (enurese) e medo de pessoa específica$i127_2$, 2, 2),
  ($i127_3$Conduziu escuta sem induzir respostas$i127_3$, 2, 3),
  ($i127_4$Reconheceu que ausência de lesão física não exclui violência$i127_4$, 2, 4),
  ($i127_5$Indicou notificação e abordagem multiprofissional$i127_5$, 1, 5),
  ($i127_6$Comunicação empática, sem culpabilização$i127_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t128$Escuta qualificada e proteção da vítima$t128$,
    $e128$Pediatria / Proteção à criança$e128$,
    null,
    300,
    $q128$Pré-escolar de 4 anos com relato espontâneo sugestivo de abuso, trazida pela mãe.$q128$,
    $res128$Pré-escolar de 4 anos com relato espontâneo sugestivo de abuso, trazida pela mãe.
Conduza o acolhimento e a sequência de cuidado adequada. ~5 min.$res128$,
    $p128$Mãe de pré-escolar de 4 anos$p128$,
    $ctx128$Mãe abalada, busca orientação. Responda só ao que for perguntado.$ctx128$,
    jsonb_build_array(
      $r128$A criança contou algo que sugere abuso por um conhecido.$r128$,
      $r128$A mãe não sabe se deve fazer a criança repetir a história.$r128$,
      $r128$Pergunta o que fazer primeiro.$r128$,
      $r128$A criança está calma ao lado da mãe.$r128$
    ),
    $ach128$Criança estável; relato espontâneo; conduta foca em acolher, proteger, atender, notificar e acompanhar.$ach128$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'maus-tratos-na-infancia')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('maus-tratos-na-infancia')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i128_0$Apresentou-se e criou ambiente reservado e seguro$i128_0$, 2, 0),
  ($i128_1$Acreditou na vítima e evitou repetição desnecessária do relato$i128_1$, 3, 1),
  ($i128_2$Não culpabilizou a criança nem induziu respostas$i128_2$, 2, 2),
  ($i128_3$Definiu sequência: acolher → proteger → atender → notificar → acompanhar$i128_3$, 3, 3),
  ($i128_4$Acionou Conselho Tutelar e equipe multiprofissional$i128_4$, 1, 4),
  ($i128_5$Comunicação empática e cuidadosa$i128_5$, 1, 5)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t129$Negligência e abandono em lactente$t129$,
    $e129$Pediatria / Proteção à criança$e129$,
    null,
    300,
    $q129$Lactente de 10 meses com baixo peso, atraso vacinal e cuidados inadequados.$q129$,
    $res129$Lactente de 10 meses com baixo peso, atraso vacinal e cuidados inadequados.
Avalie sinais de negligência e defina conduta. ~5 min.$res129$,
    $p129$Responsável por lactente de 10 meses$p129$,
    $ctx129$Responsável pouco atento aos cuidados. Responda só ao que for perguntado.$ctx129$,
    jsonb_build_array(
      $r129$O bebê falta às consultas e está com vacinas atrasadas.$r129$,
      $r129$Fica muitas horas sozinho ou aos cuidados de outras crianças.$r129$,
      $r129$Está magro, com fraldas e higiene precárias.$r129$,
      $r129$Sem lesões traumáticas evidentes.$r129$
    ),
    $ach129$Baixo peso/desnutrição leve; atraso vacinal; higiene precária; sinais de negligência/abandono sem lesão traumática.$ach129$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'maus-tratos-na-infancia')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('maus-tratos-na-infancia')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i129_0$Apresentou-se e avaliou o lactente$i129_0$, 1, 0),
  ($i129_1$Reconheceu negligência (omissão de cuidados, higiene, vacinas, alimentação)$i129_1$, 3, 1),
  ($i129_2$Diferenciou negligência de outras formas de violência$i129_2$, 2, 2),
  ($i129_3$Avaliou estado nutricional e de saúde global$i129_3$, 2, 3),
  ($i129_4$Indicou notificação e acionamento da rede de proteção$i129_4$, 2, 4),
  ($i129_5$Propôs acompanhamento e suporte à família$i129_5$, 1, 5),
  ($i129_6$Comunicação sem julgamento$i129_6$, 1, 6)
) as v(texto, grav, ord);
