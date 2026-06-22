-- Migracao automatica de cases.js -> Supabase (status em_revisao).
-- Gerado por gen_migracao_pediatria.js. Rodar DEPOIS de migracao_taxonomia_pediatria.sql.

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t10$Exame do recém-nascido a termo$t10$,
    $e10$Exame físico do RN$e10$,
    null,
    300,
    $q10$RN de 36 h de vida, a termo.$q10$,
    $res10$Alojamento conjunto. RN de 36 h de vida, a termo. Faça o exame físico
do recém-nascido de forma sistemática (diga ao avaliador o que examinaria) e oriente a alta. ~5 min.$res10$,
    $p10$Mãe de RN, 36 h de vida (a termo)$p10$,
    $ctx10$Mãe tranquila. Forneça os achados do exame à medida que o aluno os solicitar.$ctx10$,
    jsonb_build_array(
      $r10$Gestação sem intercorrências, pré-natal completo, sorologias normais.$r10$,
      $r10$Parto vaginal a termo, bolsa rota há <12 h, Apgar 9/10.$r10$,
      $r10$Mama no peito, eliminou mecônio e urina nas primeiras 24 h.$r10$,
      $r10$Achados (se solicitados): ativo, reativo, corado, FC 140, FR 44, fontanela normotensa.$r10$,
      $r10$Reflexos primitivos presentes e simétricos; quadris estáveis; coto umbilical limpo.$r10$
    ),
    $ach10$RN a termo ativo/reativo, corado, hidratado. FC 140, FR 44. Fontanela normotensa, sem dismorfias. AC/AP sem alterações. Abdome normal, coto limpo. Quadris estáveis (Ortolani/Barlow negativos). Reflexos primitivos presentes e simétricos.$ach10$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'exame-fisico-recem-nascido')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('exame-fisico-recem-nascido')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i10_0$Apresentou-se e conferiu identificação/idade gestacional$i10_0$, 1, 0),
  ($i10_1$Revisou antecedentes gestacionais, sorologias e parto$i10_1$, 1, 1),
  ($i10_2$Avaliou estado geral, cor e sinais vitais (FC, FR)$i10_2$, 1, 2),
  ($i10_3$Examinou cabeça (fontanelas, suturas) e face$i10_3$, 1, 3),
  ($i10_4$Auscultou coração e pulmões$i10_4$, 1, 4),
  ($i10_5$Examinou abdome e coto umbilical$i10_5$, 1, 5),
  ($i10_6$Avaliou quadris (Ortolani/Barlow)$i10_6$, 1, 6),
  ($i10_7$Examinou genitália e pesquisou reflexos primitivos$i10_7$, 1, 7),
  ($i10_8$Verificou as triagens neonatais (pezinho, olhinho, orelhinha, coraçãozinho)$i10_8$, 2, 8),
  ($i10_9$Orientou cuidados/alta e comunicou-se de forma clara$i10_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t11$Sopro cardíaco no recém-nascido$t11$,
    $e11$Exame físico do RN$e11$,
    null,
    300,
    $q11$Foi auscultado um sopro no RN de 2 dias durante a rotina.$q11$,
    $res11$Alojamento conjunto. Foi auscultado um sopro no RN de 2 dias durante a
rotina. Avalie, diferencie sopro inocente de patológico e defina a conduta. ~5 min.$res11$,
    $p11$Mãe de RN, 2 dias de vida$p11$,
    $ctx11$Mãe preocupada com o 'sopro no coração'. Forneça achados ao serem solicitados.$ctx11$,
    jsonb_build_array(
      $r11$RN a termo, Apgar bom, mamando bem, sem cansaço ou suor às mamadas.$r11$,
      $r11$Sem cianose percebida pela mãe.$r11$,
      $r11$Achados: sopro sistólico ejetivo 2/6 em borda esternal esquerda, sem irradiação.$r11$,
      $r11$Corado, perfusão normal, pulsos (inclusive femorais) palpáveis e simétricos.$r11$,
      $r11$Oximetria pré e pós-ductal normais e sem diferença significativa.$r11$
    ),
    $ach11$Sopro sistólico ejetivo 2/6 em BEE, sem cianose, sem sinais de insuficiência cardíaca. Pulsos femorais presentes e simétricos. Teste do coraçãozinho (oximetria pré/pós-ductal) normal.$ach11$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'exame-fisico-recem-nascido')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('exame-fisico-recem-nascido')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i11_0$Apresentou-se e revisou antecedentes$i11_0$, 1, 0),
  ($i11_1$Caracterizou o sopro (tempo, intensidade, local, irradiação)$i11_1$, 2, 1),
  ($i11_2$Pesquisou cianose e sinais de IC (cansaço/sudorese às mamadas)$i11_2$, 2, 2),
  ($i11_3$Palpou e comparou pulsos, incluindo femorais$i11_3$, 2, 3),
  ($i11_4$Verificou oximetria pré e pós-ductal (teste do coraçãozinho)$i11_4$, 2, 4),
  ($i11_5$Diferenciou características de sopro inocente x patológico$i11_5$, 2, 5),
  ($i11_6$Definiu conduta adequada (observação/ecocardiograma)$i11_6$, 2, 6),
  ($i11_7$Orientou sinais de alarme à família$i11_7$, 1, 7),
  ($i11_8$Comunicação tranquilizadora e clara$i11_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t12$Triagem da displasia do quadril$t12$,
    $e12$Exame físico do RN$e12$,
    null,
    300,
    $q12$Exame do RN feminino, nascido de apresentação pélvica.$q12$,
    $res12$Exame do RN feminino, nascido de apresentação pélvica. Realize a triagem
para displasia do desenvolvimento do quadril (DDQ) e defina a conduta. ~5 min.$res12$,
    $p12$Mãe de RN feminino, 2 dias$p12$,
    $ctx12$Primeira filha. Informe os achados das manobras quando solicitadas.$ctx12$,
    jsonb_build_array(
      $r12$RN do sexo feminino, parto pélvico. Uma tia teve 'problema no quadril' na infância.$r12$,
      $r12$Achados: ao Ortolani, ressalto palpável (clunk) no quadril esquerdo.$r12$,
      $r12$Assimetria de pregas inguinais; abdução limitada do quadril esquerdo.$r12$,
      $r12$RN no mais bem, mamando, sem outras alterações.$r12$
    ),
    $ach12$Sinal de Ortolani positivo à esquerda (ressalto de redução), assimetria de pregas, abdução limitada à esquerda. Fatores de risco: sexo feminino, apresentação pélvica, história familiar.$ach12$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'exame-fisico-recem-nascido')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('exame-fisico-recem-nascido')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i12_0$Apresentou-se e identificou fatores de risco para DDQ$i12_0$, 2, 0),
  ($i12_1$Posicionou adequadamente o RN para o exame$i12_1$, 1, 1),
  ($i12_2$Realizou a manobra de Ortolani$i12_2$, 2, 2),
  ($i12_3$Realizou a manobra de Barlow$i12_3$, 2, 3),
  ($i12_4$Avaliou simetria de pregas e abdução dos quadris$i12_4$, 2, 4),
  ($i12_5$Interpretou o achado como sugestivo de DDQ$i12_5$, 2, 5),
  ($i12_6$Solicitou USG de quadril e/ou encaminhou à ortopedia$i12_6$, 2, 6),
  ($i12_7$Orientou a família$i12_7$, 1, 7),
  ($i12_8$Comunicação adequada$i12_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t13$Manchas e 'caroços' no recém-nascido$t13$,
    $e13$Exame físico do RN$e13$,
    null,
    300,
    $q13$A mãe está assustada com manchas na pele e um inchaço na cabeça do RN.$q13$,
    $res13$Alojamento conjunto. A mãe está assustada com manchas na pele e um
inchaço na cabeça do RN. Examine, identifique achados benignos e oriente. ~5 min.$res13$,
    $p13$Mãe de RN, 1 dia de vida$p13$,
    $ctx13$Mãe de primeira viagem, muito ansiosa. Responda e mostre achados ao ser perguntada.$ctx13$,
    jsonb_build_array(
      $r13$Notou 'manchas vermelhas com pontinho branco' no tronco que mudam de lugar.$r13$,
      $r13$Mancha azul-acinzentada na região lombossacra.$r13$,
      $r13$Pontinhos brancos no nariz e bochechas.$r13$,
      $r13$Inchaço mole no alto da cabeça que 'passa de um lado para o outro'.$r13$,
      $r13$RN mama bem, sem febre, ativo.$r13$
    ),
    $ach13$Eritema tóxico neonatal no tronco; mancha mongólica lombossacra; milium facial; bossa serossanguínea (edema que cruza as suturas, em regressão). RN ativo, afebril, sem sinais de infecção.$ach13$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'exame-fisico-recem-nascido')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('exame-fisico-recem-nascido')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i13_0$Apresentou-se e acolheu a preocupação materna$i13_0$, 1, 0),
  ($i13_1$Caracterizou as lesões (localização, evolução)$i13_1$, 2, 1),
  ($i13_2$Identificou o eritema tóxico como benigno/transitório$i13_2$, 2, 2),
  ($i13_3$Identificou a mancha mongólica como benigna$i13_3$, 1, 3),
  ($i13_4$Identificou o milium como benigno$i13_4$, 1, 4),
  ($i13_5$Diferenciou bossa serossanguínea de cefalo-hematoma$i13_5$, 2, 5),
  ($i13_6$Descartou sinais de gravidade/infecção (febre, mau estado)$i13_6$, 2, 6),
  ($i13_7$Tranquilizou e orientou a evolução esperada$i13_7$, 2, 7),
  ($i13_8$Comunicação empática e didática$i13_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t14$Recém-nascido que não mexe um braço$t14$,
    $e14$Exame físico do RN$e14$,
    null,
    300,
    $q14$A mãe percebeu que o RN "não mexe o braço direito" após um parto difícil.$q14$,
    $res14$A mãe percebeu que o RN "não mexe o braço direito" após um parto
difícil. Examine, identifique o quadro e oriente a conduta. ~5 min.$res14$,
    $p14$Mãe de RN, 1 dia de vida$p14$,
    $ctx14$Parto laborioso, bebê grande. Informe os achados do exame quando solicitados.$ctx14$,
    jsonb_build_array(
      $r14$Parto vaginal difícil, com distócia de ombro; RN grande (4,2 kg).$r14$,
      $r14$Braço direito 'paradinho'; mexe os dedos da mão.$r14$,
      $r14$Achados: MSD em adução e rotação interna, cotovelo estendido (postura de garçom).$r14$,
      $r14$Reflexo de Moro ausente à direita; preensão palmar presente bilateralmente.$r14$,
      $r14$Respira bem; avaliar clavícula (crepitação/dor à palpação).$r14$
    ),
    $ach14$Paralisia braquial obstétrica tipo Erb-Duchenne (C5-C6) à direita: 'mão de garçom', Moro assimétrico, preensão palmar preservada. Pesquisar fratura de clavícula, função do frênico e sinal de Horner.$ach14$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'exame-fisico-recem-nascido')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('exame-fisico-recem-nascido')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i14_0$Apresentou-se e revisou o parto (distócia de ombro, macrossomia)$i14_0$, 2, 0),
  ($i14_1$Avaliou a movimentação espontânea dos quatro membros$i14_1$, 1, 1),
  ($i14_2$Pesquisou o reflexo de Moro e sua simetria$i14_2$, 2, 2),
  ($i14_3$Avaliou a preensão palmar (nível da lesão)$i14_3$, 1, 3),
  ($i14_4$Examinou a clavícula (fratura associada)$i14_4$, 2, 4),
  ($i14_5$Reconheceu a paralisia braquial obstétrica (Erb)$i14_5$, 2, 5),
  ($i14_6$Avaliou complicações (frênico/diafragma, Horner)$i14_6$, 2, 6),
  ($i14_7$Indicou conduta (posicionamento, fisioterapia, seguimento)$i14_7$, 2, 7),
  ($i14_8$Orientou o prognóstico à família$i14_8$, 1, 8),
  ($i14_9$Comunicação empática$i14_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t15$Classificando o recém-nascido$t15$,
    $e15$Exame físico do RN$e15$,
    null,
    300,
    $q15$Necessidade de classificar o RN quanto à idade gestacional e ao peso de nascimento.$q15$,
    $res15$Alojamento conjunto. Classifique o RN quanto à idade gestacional e ao
peso de nascimento, e explique o que isso significa para os cuidados. ~5 min.$res15$,
    $p15$Mãe de RN, 1 dia de vida$p15$,
    $ctx15$Mãe quer entender os termos usados pela equipe. Informe os dados quando solicitados.$ctx15$,
    jsonb_build_array(
      $r15$DUM confiável; idade gestacional pelo pré-natal/USG de 1º trimestre: 35 semanas e 2 dias.$r15$,
      $r15$Peso de nascimento: 2.100 g.$r15$,
      $r15$Pergunta: 'o que significa prematuro tardio?' e 'o peso dele é baixo?'$r15$,
      $r15$Se solicitado o exame: RN ativo, mas com características de prematuridade leve (pele mais fina, pouco tecido adiposo).$r15$
    ),
    $ach15$Idade gestacional 35s2d → PRÉ-TERMO TARDIO (34s a 36s6d). Peso 2.100 g → BAIXO PESO (1.500-2.499 g). Peso adequado para a idade gestacional deve ser checado em curva (percentil 10-90 = AIG).$ach15$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'exame-fisico-recem-nascido')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('exame-fisico-recem-nascido')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i15_0$Apresentou-se e revisou a idade gestacional (DUM/USG de 1º trimestre)$i15_0$, 2, 0),
  ($i15_1$Classificou corretamente por idade gestacional (pré-termo tardio)$i15_1$, 3, 1),
  ($i15_2$Classificou corretamente por peso de nascimento (baixo peso)$i15_2$, 3, 2),
  ($i15_3$Relacionou o peso à idade gestacional (AIG/PIG/GIG)$i15_3$, 2, 3),
  ($i15_4$Citou método alternativo (New Ballard) quando DUM/USG não confiáveis$i15_4$, 2, 4),
  ($i15_5$Explicou implicações práticas (risco de hipoglicemia, icterícia, termorregulação)$i15_5$, 2, 5),
  ($i15_6$Orientou a família de forma clara$i15_6$, 1, 6),
  ($i15_7$Comunicação didática$i15_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t16$Avaliando a cabeça do recém-nascido$t16$,
    $e16$Exame físico do RN$e16$,
    null,
    300,
    $q16$Mãe assustada com uma "área mole" notada na cabeça do RN.$q16$,
    $res16$Alojamento conjunto. Examine a cabeça do RN de 1 dia, avaliando
fontanelas e suturas, e responda às dúvidas da mãe. ~5 min.$res16$,
    $p16$Mãe de RN, 1 dia de vida$p16$,
    $ctx16$Mãe notou 'um buraco mole' na cabeça do bebê e ficou assustada.$ctx16$,
    jsonb_build_array(
      $r16$Notou uma área mole no topo da cabeça do bebê.$r16$,
      $r16$Pergunta se pode 'machucar o cérebro' se tocar ali.$r16$,
      $r16$Achados ao exame (se solicitados): fontanela anterior normotensa, de tamanho normal, suturas justapostas e palpáveis.$r16$,
      $r16$RN ativo, reativo, sem vômitos, sem irritabilidade.$r16$,
      $r16$Parto vaginal sem uso de fórceps/vácuo.$r16$
    ),
    $ach16$Fontanela anterior (bregmática) normotensa = achado NORMAL, fecha entre 9-18 meses. Fontanela abaulada/tensa sugere hipertensão intracraniana; deprimida sugere desidratação. Medir perímetro cefálico na glabela/proeminência occipital. Suturas palpáveis e mobilizáveis são esperadas (craniossinostose = sutura fundida e fixa).$ach16$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'exame-fisico-recem-nascido')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('exame-fisico-recem-nascido')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i16_0$Apresentou-se e acolheu a preocupação materna$i16_0$, 1, 0),
  ($i16_1$Palpou e descreveu a fontanela anterior (tamanho, tensão)$i16_1$, 3, 1),
  ($i16_2$Avaliou as suturas cranianas (palpáveis x fundidas)$i16_2$, 2, 2),
  ($i16_3$Mediu/valorizou o perímetro cefálico$i16_3$, 2, 3),
  ($i16_4$Diferenciou fontanela normotensa de abaulada/deprimida e seus significados$i16_4$, 3, 4),
  ($i16_5$Tranquilizou explicando que a fontanela normal não 'machuca' ao toque leve$i16_5$, 2, 5),
  ($i16_6$Orientou quando a fontanela costuma fechar$i16_6$, 1, 6),
  ($i16_7$Comunicação didática e tranquilizadora$i16_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t17$Cuidados com o coto umbilical$t17$,
    $e17$Exame físico do RN$e17$,
    null,
    300,
    $q17$Mãe com dúvidas sobre os cuidados com o coto umbilical do RN.$q17$,
    $res17$Alojamento conjunto. Examine o coto umbilical do RN de 2 dias e oriente
os cuidados, identificando sinais de alarme. ~5 min.$res17$,
    $p17$Mãe de RN, 2 dias de vida$p17$,
    $ctx17$Mãe com medo de cuidar do coto umbilical. Informe achados quando solicitados.$ctx17$,
    jsonb_build_array(
      $r17$Pergunta como limpar o coto e se pode dar banho de banheira.$r17$,
      $r17$Coto ainda úmido, sem secreção purulenta, sem vermelhidão ao redor.$r17$,
      $r17$Achados ao exame (se solicitados): cordão com duas artérias e uma veia, sem hiperemia periumbilical, sem odor fétido, sem secreção purulenta.$r17$,
      $r17$RN afebril, mamando bem, ativo.$r17$
    ),
    $ach17$Coto umbilical normal: mumifica por volta do 3º-4º dia e cai entre o 7º-14º dia. Cuidado: manter limpo e seco, sem ocluir com fraldas, sem necessidade de álcool/antissépticos de rotina conforme protocolo local. Sinais de alarme (onfalite): hiperemia periumbilical, secreção purulenta, odor fétido, febre — diferente de granuloma umbilical (tecido avermelhado úmido após a queda, sem sinais infecciosos).$ach17$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'exame-fisico-recem-nascido')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('exame-fisico-recem-nascido')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i17_0$Apresentou-se e avaliou o conhecimento prévio da mãe sobre os cuidados$i17_0$, 1, 0),
  ($i17_1$Examinou o coto (vasos, secreção, hiperemia, odor)$i17_1$, 2, 1),
  ($i17_2$Orientou manter o coto limpo e seco, sem ocluir com a fralda$i17_2$, 2, 2),
  ($i17_3$Informou o tempo esperado de mumificação e queda$i17_3$, 2, 3),
  ($i17_4$Reconheceu ausência de sinais de onfalite no caso$i17_4$, 2, 4),
  ($i17_5$Diferenciou onfalite de granuloma umbilical$i17_5$, 2, 5),
  ($i17_6$Orientou sinais de alarme para procurar atendimento$i17_6$, 2, 6),
  ($i17_7$Comunicação clara e tranquilizadora$i17_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t18$Teste do coraçãozinho$t18$,
    $e18$Exame físico do RN$e18$,
    null,
    300,
    $q18$Realização do teste do coraçãozinho antes da alta do RN.$q18$,
    $res18$Alojamento conjunto. Realize e explique o teste do coraçãozinho do RN
de 26 horas de vida antes da alta. ~5 min.$res18$,
    $p18$Mãe de RN, 26 horas de vida$p18$,
    $ctx18$Mãe nunca ouviu falar do exame. Informe os resultados quando solicitados.$ctx18$,
    jsonb_build_array(
      $r18$RN a termo, assintomático, mamando bem, sem cianose percebida.$r18$,
      $r18$Pergunta: 'que teste é esse, dói?' e 'para que serve?'.$r18$,
      $r18$Achados (se solicitados): oximetria de pulso em membro superior direito (pré-ductal) = 97%; em um dos membros inferiores (pós-ductal) = 96%.$r18$,
      $r18$Diferença entre as medidas <3%; ambos os valores ≥95%.$r18$
    ),
    $ach18$Teste do coraçãozinho (oximetria de pulso) deve ser realizado a partir de 24 horas de vida, em membro superior direito (pré-ductal) e em um membro inferior (pós-ductal). Resultado NORMAL: SatO2 ≥95% em ambos e diferença <3% entre as medidas. Resultado alterado exige reteste e, se confirmado, ecocardiograma para investigar cardiopatia congênita crítica.$ach18$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'exame-fisico-recem-nascido')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('exame-fisico-recem-nascido')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i18_0$Apresentou-se e confirmou o horário adequado para o teste (≥24h)$i18_0$, 2, 0),
  ($i18_1$Explicou o objetivo do teste (rastrear cardiopatia congênita crítica)$i18_1$, 2, 1),
  ($i18_2$Realizou/descreveu a técnica (membro superior direito e um inferior)$i18_2$, 2, 2),
  ($i18_3$Interpretou corretamente o resultado (SatO2 ≥95% e diferença <3%)$i18_3$, 3, 3),
  ($i18_4$Soube a conduta diante de resultado alterado (reteste/ecocardiograma)$i18_4$, 2, 4),
  ($i18_5$Tranquilizou sobre o caráter indolor do exame$i18_5$, 1, 5),
  ($i18_6$Relacionou à triagem neonatal completa (pezinho, olhinho, orelhinha)$i18_6$, 1, 6),
  ($i18_7$Comunicação didática$i18_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t19$Examinando um recém-nascido prematuro$t19$,
    $e19$Exame físico do RN$e19$,
    null,
    300,
    $q19$Pais assustados com a aparência "diferente" de um RN pré-termo.$q19$,
    $res19$UTI neonatal. Examine um RN pré-termo de 33 semanas e descreva as
características esperadas da prematuridade aos pais. ~5 min.$res19$,
    $p19$Pais de RN pré-termo, 33 semanas, 2 dias de vida$p19$,
    $ctx19$Pais assustados com a aparência 'diferente' do bebê. Informe achados quando solicitados.$ctx19$,
    jsonb_build_array(
      $r19$Pais notam que a pele do bebê é 'fina e vermelha' e que ele é muito pequeno.$r19$,
      $r19$Perguntam por que ele fica numa incubadora e por que parece 'mole'.$r19$,
      $r19$Achados (se solicitados): pele fina e gelatinosa, pouco tecido adiposo subcutâneo, lanugo abundante.$r19$,
      $r19$Tônus e reflexos primitivos diminuídos em relação a um RN a termo; cabeça proporcionalmente grande.$r19$,
      $r19$Tórax depressível, abdome globoso; genitália imatura (no menino, testículos não totalmente descidos / bolsa escrotal pouco rugosa).$r19$
    ),
    $ach19$Características esperadas do prematuro (33 semanas): pele fina com pouco tecido adiposo, lanugo, tônus e reflexos reduzidos em relação ao termo, cabeça proporcionalmente grande, fontanelas amplas, tórax depressível, abdome globoso e genitália imatura. Risco aumentado de hérnia inguinal, sobretudo em meninos pré-termo extremos.$ach19$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'exame-fisico-recem-nascido')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('exame-fisico-recem-nascido')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i19_0$Apresentou-se e acolheu a ansiedade dos pais$i19_0$, 1, 0),
  ($i19_1$Descreveu achados de pele (fina, lanugo, pouco tecido adiposo)$i19_1$, 2, 1),
  ($i19_2$Avaliou tônus e reflexos primitivos (reduzidos em relação ao termo)$i19_2$, 2, 2),
  ($i19_3$Examinou tórax, abdome e genitália identificando imaturidade$i19_3$, 2, 3),
  ($i19_4$Explicou que esses achados são esperados para a idade gestacional$i19_4$, 2, 4),
  ($i19_5$Citou o maior risco de hérnia inguinal no prematuro$i19_5$, 1, 5),
  ($i19_6$Explicou a necessidade de cuidados especiais (incubadora, termorregulação)$i19_6$, 2, 6),
  ($i19_7$Comunicação empática e didática$i19_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t115$Pesquisa dos reflexos primitivos do RN$t115$,
    $e115$Neonatologia$e115$,
    null,
    300,
    $q115$RN a termo, 2 dias, em alojamento conjunto. A mãe pergunta sobre os "movimentos" do bebê.$q115$,
    $res115$RN a termo, 2 dias, em alojamento conjunto. A mãe pergunta sobre os "movimentos" do bebê.
Examine os reflexos primitivos e explique o que avalia. ~5 min.$res115$,
    $p115$Mãe de RN a termo, 2 dias$p115$,
    $ctx115$Mãe de primeira viagem, curiosa. Responda só ao que for perguntado.$ctx115$,
    jsonb_build_array(
      $r115$O bebê 'se assusta' e abre os bracinhos quando ela se mexe na cama.$r115$,
      $r115$Suga bem e procura o seio quando toca o canto da boca.$r115$,
      $r115$Segura firme o dedo quando ela encosta na palma.$r115$,
      $r115$Nasceu a termo, parto sem intercorrências.$r115$,
      $r115$Ela quer saber se esses movimentos são normais.$r115$
    ),
    $ach115$Moro simétrico e completo; sucção e busca presentes; preensão palmar e plantar; marcha reflexa presente; tônus normal.$ach115$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'exame-fisico-recem-nascido')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('exame-fisico-recem-nascido')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i115_0$Apresentou-se e higienizou as mãos$i115_0$, 1, 0),
  ($i115_1$Pesquisou reflexo de Moro e avaliou simetria$i115_1$, 2, 1),
  ($i115_2$Pesquisou sucção e busca (procura)$i115_2$, 2, 2),
  ($i115_3$Pesquisou preensão palmar e plantar$i115_3$, 2, 3),
  ($i115_4$Pesquisou marcha reflexa e/ou outros reflexos$i115_4$, 1, 4),
  ($i115_5$Reconheceu reflexos primitivos como normais no RN$i115_5$, 2, 5),
  ($i115_6$Explicou à mãe o significado em linguagem acessível$i115_6$, 1, 6),
  ($i115_7$Comunicação empática$i115_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t116$Variações fisiológicas da genitália no RN$t116$,
    $e116$Neonatologia$e116$,
    null,
    300,
    $q116$Mãe de RN feminina, 4 dias, assustada com "secreção e sangramento" na vagina do bebê.$q116$,
    $res116$Mãe de RN feminina, 4 dias, assustada com "secreção e sangramento" na vagina do bebê.
Avalie, diferencie do patológico e oriente. ~5 min.$res116$,
    $p116$Mãe de RN feminina, 4 dias$p116$,
    $ctx116$Mãe ansiosa. Responda só ao que for perguntado.$ctx116$,
    jsonb_build_array(
      $r116$Notou secreção esbranquiçada e um pequeno sangramento vaginal hoje.$r116$,
      $r116$O bebê está mamando bem, ativo, sem febre.$r116$,
      $r116$Nasceu a termo, parto vaginal sem intercorrências.$r116$,
      $r116$Ela teme que seja alguma doença grave.$r116$
    ),
    $ach116$Secreção vaginal esbranquiçada e discreto sangramento (pseudomenstruação); mamas levemente ingurgitadas; sem sinais de infecção.$ach116$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'exame-fisico-recem-nascido')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('exame-fisico-recem-nascido')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i116_0$Apresentou-se e higienizou as mãos$i116_0$, 1, 0),
  ($i116_1$Examinou a genitália de forma cuidadosa e respeitosa$i116_1$, 2, 1),
  ($i116_2$Reconheceu secreção/sangramento como variação hormonal fisiológica$i116_2$, 3, 2),
  ($i116_3$Avaliou estado geral para excluir sinais de gravidade$i116_3$, 2, 3),
  ($i116_4$Diferenciou de causas patológicas (infecção, trauma)$i116_4$, 1, 4),
  ($i116_5$Tranquilizou a mãe sem realizar condutas desnecessárias$i116_5$, 2, 5),
  ($i116_6$Comunicação empática e clara$i116_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t117$Perímetro cefálico e fontanela no exame do RN$t117$,
    $e117$Neonatologia$e117$,
    null,
    300,
    $q117$RN a termo, 3 dias, com história de baixa ingesta nas últimas horas.$q117$,
    $res117$RN a termo, 3 dias, com história de baixa ingesta nas últimas horas.
Avalie o crânio (perímetro, suturas e fontanelas) e interprete os achados. ~5 min.$res117$,
    $p117$Mãe de RN a termo, 3 dias$p117$,
    $ctx117$Mãe cansada; o bebê mamou pouco no último dia. Responda só ao que for perguntado.$ctx117$,
    jsonb_build_array(
      $r117$O bebê está mais sonolento e fez menos xixi hoje.$r117$,
      $r117$Mamou pouco desde ontem; a descida do leite atrasou.$r117$,
      $r117$Nasceu a termo, parto sem intercorrências.$r117$,
      $r117$Ela quer saber se a 'moleira' afundada é normal.$r117$
    ),
    $ach117$Fontanela anterior levemente deprimida; mucosas um pouco secas; suturas normais; perímetro cefálico no percentil adequado.$ach117$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'exame-fisico-recem-nascido')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('exame-fisico-recem-nascido')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i117_0$Apresentou-se e higienizou as mãos$i117_0$, 1, 0),
  ($i117_1$Mediu o perímetro cefálico corretamente (glabela à proeminência occipital)$i117_1$, 2, 1),
  ($i117_2$Avaliou suturas e fontanelas$i117_2$, 2, 2),
  ($i117_3$Reconheceu fontanela deprimida como sinal de desidratação$i117_3$, 3, 3),
  ($i117_4$Correlacionou com baixa ingesta e diurese reduzida$i117_4$, 1, 4),
  ($i117_5$Propôs avaliação da amamentação/hidratação e reavaliação$i117_5$, 2, 5),
  ($i117_6$Comunicação empática$i117_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t118$Tumefação no couro cabeludo do RN$t118$,
    $e118$Neonatologia$e118$,
    null,
    300,
    $q118$RN a termo, 1 dia, com "inchaço" na cabeça após parto vaginal prolongado.$q118$,
    $res118$RN a termo, 1 dia, com "inchaço" na cabeça após parto vaginal prolongado.
Examine, diferencie bossa de cefalo-hematoma e oriente. ~5 min.$res118$,
    $p118$Mãe de RN a termo, 1 dia$p118$,
    $ctx118$Mãe preocupada com o inchaço na cabeça. Responda só ao que for perguntado.$ctx118$,
    jsonb_build_array(
      $r118$O parto foi demorado e usaram fórceps no fim.$r118$,
      $r118$Notou uma saliência de um lado da cabeça do bebê.$r118$,
      $r118$O bebê mama bem, está ativo, sem febre.$r118$,
      $r118$Ela quer saber se é grave e se vai sumir.$r118$
    ),
    $ach118$Tumefação localizada, flutuante, limitada por suturas (não as ultrapassa), unilateral — compatível com cefalo-hematoma; sem sinais neurológicos.$ach118$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'exame-fisico-recem-nascido')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('exame-fisico-recem-nascido')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i118_0$Apresentou-se e higienizou as mãos$i118_0$, 1, 0),
  ($i118_1$Caracterizou a lesão (limites, consistência, relação com suturas)$i118_1$, 2, 1),
  ($i118_2$Reconheceu cefalo-hematoma (subperiostal, não ultrapassa suturas)$i118_2$, 3, 2),
  ($i118_3$Diferenciou de bossa serossanguínea (edema que ultrapassa suturas)$i118_3$, 2, 3),
  ($i118_4$Alertou para risco de anemia e icterícia/hiperbilirrubinemia$i118_4$, 2, 4),
  ($i118_5$Orientou acompanhamento e evolução esperada$i118_5$, 1, 5),
  ($i118_6$Comunicação empática$i118_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t119$Estimativa da idade gestacional do RN$t119$,
    $e119$Neonatologia$e119$,
    null,
    300,
    $q119$RN admitido com DUM incerta e sem USG precoce confiável.$q119$,
    $res119$RN admitido com DUM incerta e sem USG precoce confiável.
Explique e demonstre como estimar a idade gestacional e classifique o RN. ~5 min.$res119$,
    $p119$Mãe de RN, poucas horas de vida$p119$,
    $ctx119$Mãe fez pouco pré-natal; não tem certeza da data da última menstruação. Responda só ao que for perguntado.$ctx119$,
    jsonb_build_array(
      $r119$Não lembra direito a data da última menstruação e não fez ultrassom no começo.$r119$,
      $r119$O bebê nasceu com peso 2.300 g.$r119$,
      $r119$Ela quer entender 'de quantas semanas' o bebê é.$r119$
    ),
    $ach119$Avaliação somática e neuromuscular (New Ballard) compatível com ~36 semanas; peso 2.300 g; classificado como pré-termo tardio, AIG.$ach119$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'exame-fisico-recem-nascido')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('exame-fisico-recem-nascido')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i119_0$Apresentou-se e higienizou as mãos$i119_0$, 1, 0),
  ($i119_1$Explicou limitação da DUM e valor da USG de 1º trimestre$i119_1$, 2, 1),
  ($i119_2$Citou/aplicou o New Ballard (parâmetros físicos e neurológicos)$i119_2$, 3, 2),
  ($i119_3$Estimou a idade gestacional$i119_3$, 1, 3),
  ($i119_4$Classificou por IG (pré-termo tardio) e por peso/IG (AIG)$i119_4$, 2, 4),
  ($i119_5$Relacionou prematuridade tardia com riscos de vigilância$i119_5$, 1, 5),
  ($i119_6$Comunicação clara com a mãe$i119_6$, 1, 6)
) as v(texto, grav, ord);
