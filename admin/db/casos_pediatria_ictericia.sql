-- Migracao automatica de cases.js -> Supabase (status em_revisao).
-- Gerado por gen_migracao_pediatria.js. Rodar DEPOIS de migracao_taxonomia_pediatria.sql.

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t20$Recém-nascido amarelo no 3º dia$t20$,
    $e20$Icterícia neonatal$e20$,
    null,
    300,
    $q20$RN de 3 dias trazido por estar "amarelinho".$q20$,
    $res20$Alojamento/PA. RN de 3 dias trazido por estar "amarelinho". Avalie a
icterícia, estime a gravidade e defina a conduta. ~5 min.$res20$,
    $p20$Mãe de RN, 3 dias de vida$p20$,
    $ctx20$Mãe atenta. Informe os achados do exame quando solicitados.$ctx20$,
    jsonb_build_array(
      $r20$Amarelão começou no rosto e hoje já está no peito/barriga.$r20$,
      $r20$RN a termo, mamando no peito, boa diurese, fezes normais (amareladas).$r20$,
      $r20$Mãe é O+, não sabe o tipo do bebê. Sem irmão com icterícia grave.$r20$,
      $r20$Achados: ictérico até o abdome, ativo, sem letargia, sem hepatoesplenomegalia.$r20$
    ),
    $ach20$Icterícia até o abdome (Kramer III, ~12 mg/dL estimado), RN ativo, 72 h, mamando. Mãe O+. Conduta guiada por bilirrubina total e fatores de risco (nomograma).$ach20$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ictericia-neonatal')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ictericia-neonatal')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i20_0$Apresentou-se e identificou o RN e a idade em horas$i20_0$, 1, 0),
  ($i20_1$Caracterizou início e progressão (céfalo-caudal/zonas de Kramer)$i20_1$, 2, 1),
  ($i20_2$Perguntou idade gestacional e tempo de vida$i20_2$, 1, 2),
  ($i20_3$Investigou tipagem/incompatibilidade ABO-Rh e Coombs$i20_3$, 2, 3),
  ($i20_4$Avaliou aleitamento, diurese e fezes$i20_4$, 1, 4),
  ($i20_5$Pesquisou sinais de alerta (letargia, recusa, início <24 h)$i20_5$, 2, 5),
  ($i20_6$Solicitou bilirrubina total e frações$i20_6$, 2, 6),
  ($i20_7$Decidiu fototerapia conforme nomograma/fatores de risco$i20_7$, 2, 7),
  ($i20_8$Orientou retorno e amamentação$i20_8$, 1, 8),
  ($i20_9$Comunicação clara$i20_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t21$Icterícia nas primeiras 24 horas$t21$,
    $e21$Icterícia neonatal$e21$,
    null,
    300,
    $q21$RN com icterícia surgida com 18 h de vida.$q21$,
    $res21$RN com icterícia surgida com 18 h de vida. Avalie — isso é esperado?
Defina a investigação e a conduta. ~5 min.$res21$,
    $p21$Mãe de RN, 18 h de vida$p21$,
    $ctx21$Mãe preocupada com o amarelão precoce. Informe os exames se solicitados.$ctx21$,
    jsonb_build_array(
      $r21$Amarelão já visível com menos de um dia de vida.$r21$,
      $r21$Mãe O+, bebê A+ (souberam pelo teste). Parto a termo.$r21$,
      $r21$Achados: ictérico, um pouco mais hipoativo do que o esperado.$r21$,
      $r21$Exames (se pedidos): bilirrubina alta para a idade, Coombs direto positivo, anemia com reticulócitos altos.$r21$
    ),
    $ach21$Icterícia com 18 h de vida (SEMPRE patológica). Mãe O+ / RN A+, Coombs direto positivo, anemia e reticulocitose → doença hemolítica por incompatibilidade ABO.$ach21$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ictericia-neonatal')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ictericia-neonatal')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i21_0$Apresentou-se e definiu o tempo de vida no início da icterícia$i21_0$, 1, 0),
  ($i21_1$Reconheceu icterícia <24 h como PATOLÓGICA$i21_1$, 3, 1),
  ($i21_2$Investigou tipagem sanguínea e incompatibilidade$i21_2$, 2, 2),
  ($i21_3$Solicitou bilirrubina, Coombs e hemograma/reticulócitos$i21_3$, 2, 3),
  ($i21_4$Avaliou sinais de hemólise/anemia$i21_4$, 1, 4),
  ($i21_5$Indicou fototerapia precoce$i21_5$, 2, 5),
  ($i21_6$Considerou exsanguineotransfusão conforme critérios$i21_6$, 1, 6),
  ($i21_7$Comunicou a gravidade e o plano à família$i21_7$, 1, 7),
  ($i21_8$Comunicação adequada$i21_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t22$Icterícia que não passa (3 semanas)$t22$,
    $e22$Icterícia neonatal$e22$,
    null,
    300,
    $q22$Lactente de 20 dias continua ictérico.$q22$,
    $res22$Ambulatório. Lactente de 20 dias continua ictérico. Diferencie causas
benignas de colestase e defina a investigação. ~5 min.$res22$,
    $p22$Mãe de lactente, 20 dias$p22$,
    $ctx22$Mãe relata que 'a cor não some'. Só revele cor de fezes/urina se perguntado.$ctx22$,
    jsonb_build_array(
      $r22$Amarelão desde a 1ª semana, ainda presente aos 20 dias.$r22$,
      $r22$Aleitamento materno exclusivo, ganhando peso, ativo.$r22$,
      $r22$Se perguntado: as fezes estão esbranquiçadas/claras e a urina escura.$r22$,
      $r22$Achados: ictérico, fígado palpável a ~3 cm do rebordo costal.$r22$
    ),
    $ach22$Icterícia prolongada (>14 dias) com hipocolia fecal, colúria e hepatomegalia → COLESTASE (bilirrubina direta elevada). Suspeita de atresia de vias biliares — investigação e cirurgia precoces.$ach22$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ictericia-neonatal')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ictericia-neonatal')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i22_0$Apresentou-se e caracterizou a duração (>14 dias)$i22_0$, 1, 0),
  ($i22_1$Perguntou padrão alimentar e ganho de peso$i22_1$, 1, 1),
  ($i22_2$Pesquisou a COR DAS FEZES e da URINA (acolia/colúria)$i22_2$, 3, 2),
  ($i22_3$Examinou fígado e baço$i22_3$, 1, 3),
  ($i22_4$Solicitou bilirrubina TOTAL E FRAÇÕES (direta)$i22_4$, 3, 4),
  ($i22_5$Reconheceu colestase / suspeita de atresia de vias biliares$i22_5$, 3, 5),
  ($i22_6$Valorizou a urgência do encaminhamento (cirurgia precoce)$i22_6$, 2, 6),
  ($i22_7$Orientou a família$i22_7$, 1, 7),
  ($i22_8$Comunicação adequada$i22_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t23$Icterícia e dificuldade para mamar$t23$,
    $e23$Icterícia neonatal$e23$,
    null,
    300,
    $q23$RN de 4 dias, ictérico, com perda de peso importante.$q23$,
    $res23$RN de 4 dias, ictérico, com perda de peso importante. Avalie a relação
com a amamentação e oriente a conduta. ~5 min.$res23$,
    $p23$Mãe de RN, 4 dias$p23$,
    $ctx23$Mãe insegura com a amamentação. Informe achados quando solicitados.$ctx23$,
    jsonb_build_array(
      $r23$Amarelão; mamadas difíceis, pega ruim, dorme muito e mama pouco.$r23$,
      $r23$Perdeu cerca de 10% do peso de nascimento. Poucas fraldas molhadas/dia.$r23$,
      $r23$Achados: ictérico até membros, mucosas um pouco secas, hipoativo.$r23$
    ),
    $ach23$Icterícia por ingesta insuficiente ('breastfeeding jaundice') com perda ponderal ~10% e sinais de desidratação. Corrigir amamentação e dosar bilirrubina.$ach23$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ictericia-neonatal')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ictericia-neonatal')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i23_0$Apresentou-se e avaliou o aleitamento (pega, frequência, duração)$i23_0$, 2, 0),
  ($i23_1$Quantificou a perda de peso em relação ao nascimento$i23_1$, 2, 1),
  ($i23_2$Avaliou diurese e estado de hidratação$i23_2$, 2, 2),
  ($i23_3$Relacionou a icterícia à baixa ingesta$i23_3$, 2, 3),
  ($i23_4$Solicitou bilirrubina e avaliou indicação de fototerapia$i23_4$, 2, 4),
  ($i23_5$Corrigiu a técnica de amamentação / apoio à lactação$i23_5$, 2, 5),
  ($i23_6$Orientou aumento de oferta e reavaliação do peso$i23_6$, 1, 6),
  ($i23_7$Orientou sinais de alarme$i23_7$, 1, 7),
  ($i23_8$Comunicação empática$i23_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t24$Recém-nascido muito amarelo e sonolento$t24$,
    $e24$Icterícia neonatal$e24$,
    null,
    300,
    $q24$RN de 5 dias intensamente ictérico e letárgico.$q24$,
    $res24$Pronto-socorro. RN de 5 dias intensamente ictérico e letárgico.
Reconheça a gravidade e conduza. ~5 min.$res24$,
    $p24$Mãe de RN, 5 dias$p24$,
    $ctx24$Mãe assustada com o bebê 'molinho'. Informe achados quando solicitados.$ctx24$,
    jsonb_build_array(
      $r24$Amarelão intenso, chegando às mãos e plantas dos pés.$r24$,
      $r24$Muito sonolento, mama mal; hoje teve momentos com o corpo 'arqueado para trás'.$r24$,
      $r24$Parto domiciliar, sem triagens, pré-natal incompleto.$r24$,
      $r24$Exames (se pedidos): bilirrubina total muito elevada (ex.: 28 mg/dL).$r24$
    ),
    $ach24$Icterícia zona V (mãos/pés), letargia, hipotonia alternando com hipertonia/opistótono e choro agudo: encefalopatia bilirrubínica aguda (risco de kernicterus). BT muito elevada — EMERGÊNCIA.$ach24$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ictericia-neonatal')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ictericia-neonatal')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i24_0$Apresentou-se e reconheceu a gravidade rapidamente$i24_0$, 2, 0),
  ($i24_1$Avaliou a extensão da icterícia (zonas, mãos/pés)$i24_1$, 2, 1),
  ($i24_2$Pesquisou sinais neurológicos (letargia, hipertonia, opistótono, choro agudo)$i24_2$, 3, 2),
  ($i24_3$Solicitou bilirrubina total com urgência$i24_3$, 2, 3),
  ($i24_4$Reconheceu encefalopatia bilirrubínica / risco de kernicterus$i24_4$, 3, 4),
  ($i24_5$Iniciou fototerapia intensiva imediata$i24_5$, 2, 5),
  ($i24_6$Acionou exsanguineotransfusão$i24_6$, 2, 6),
  ($i24_7$Comunicou a gravidade à família$i24_7$, 1, 7),
  ($i24_8$Condução de emergência adequada$i24_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t25$Mãe Rh negativo, bebê ictérico$t25$,
    $e25$Icterícia neonatal$e25$,
    null,
    300,
    $q25$RN de 30 horas de vida com icterícia precoce. A mãe é Rh negativo.$q25$,
    $res25$RN de 30 horas de vida com icterícia precoce. A mãe é Rh negativo.
Avalie a possível doença hemolítica por incompatibilidade Rh e conduza. ~5 min.$res25$,
    $p25$Mãe de RN, 30 horas de vida$p25$,
    $ctx25$Mãe sabe que é 'Rh negativo' mas não entende o risco. Informe achados quando solicitados.$ctx25$,
    jsonb_build_array(
      $r25$Mãe Rh negativo, já teve uma gestação anterior; não tem certeza se tomou a 'injeção' (imunoglobulina anti-D) no pré-natal/pós-parto anterior.$r25$,
      $r25$RN Rh positivo (saiu no exame do cordão). Icterícia já visível com 30 h de vida.$r25$,
      $r25$Achados: ictérico até o tronco, um pouco hipoativo.$r25$,
      $r25$Exames (se pedidos): Coombs direto positivo, anemia com reticulocitose, bilirrubina elevada para a idade.$r25$
    ),
    $ach25$Icterícia precoce (<24-36h) em RN Rh positivo de mãe Rh negativo sensibilizada, com Coombs direto positivo, anemia e reticulocitose → doença hemolítica perinatal por incompatibilidade Rh, em geral mais grave que a ABO. Fototerapia precoce; considerar imunoglobulina IV e avaliar critérios de exsanguineotransfusão.$ach25$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ictericia-neonatal')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ictericia-neonatal')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i25_0$Apresentou-se e investigou tipagem Rh da mãe e do RN$i25_0$, 2, 0),
  ($i25_1$Perguntou sobre uso de imunoglobulina anti-D em gestações anteriores$i25_1$, 2, 1),
  ($i25_2$Reconheceu a icterícia precoce como sinal de alerta$i25_2$, 2, 2),
  ($i25_3$Solicitou Coombs direto, bilirrubina e hemograma/reticulócitos$i25_3$, 2, 3),
  ($i25_4$Reconheceu a doença hemolítica por incompatibilidade Rh$i25_4$, 3, 4),
  ($i25_5$Indicou fototerapia precoce/intensiva$i25_5$, 2, 5),
  ($i25_6$Considerou imunoglobulina IV e critérios de exsanguineotransfusão$i25_6$, 2, 6),
  ($i25_7$Comunicação clara sobre a gravidade$i25_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t26$Explicando a fototerapia para a família$t26$,
    $e26$Icterícia neonatal$e26$,
    null,
    300,
    $q26$RN de 4 dias internado em fototerapia. Os pais têm dúvidas sobre o tratamento.$q26$,
    $res26$RN de 4 dias internado em fototerapia. Os pais têm dúvidas sobre o
tratamento. Explique o mecanismo, os cuidados e os possíveis efeitos. ~5 min.$res26$,
    $p26$Pais de RN, 4 dias, em fototerapia$p26$,
    $ctx26$Pais assustados ao ver o bebê 'só de fralda, sob a luz e com óculos'.$ctx26$,
    jsonb_build_array(
      $r26$Perguntam por que o bebê está 'pelado debaixo da luz' e com proteção nos olhos.$r26$,
      $r26$Perguntam se a luz 'queima' ou faz mal ao bebê.$r26$,
      $r26$Notaram que as fezes do bebê ficaram mais amolecidas e a urina mais escura desde o início do tratamento.$r26$,
      $r26$Perguntam quanto tempo vai durar e se podem continuar amamentando.$r26$
    ),
    $ach26$Fototerapia: luz azul-esverdeada (400-500 nm) promove fotoisomerização/foto-oxidação da bilirrubina indireta em produtos hidrossolúveis excretáveis. Eficácia depende da área de pele exposta e da irradiância (E = área exposta × irradiância) — por isso o RN fica desnudo, com proteção ocular. Efeitos esperados/benignos: fezes amolecidas, maior perda hídrica, urina mais escura; bronzeamento da pele (síndrome do bebê bronzeado) pode ocorrer se houver bilirrubina direta elevada associada. Amamentação deve ser mantida, com pausas breves da luz.$ach26$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ictericia-neonatal')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ictericia-neonatal')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i26_0$Apresentou-se e acolheu as dúvidas dos pais$i26_0$, 1, 0),
  ($i26_1$Explicou o mecanismo da fototerapia (fotoisomerização/foto-oxidação)$i26_1$, 3, 1),
  ($i26_2$Explicou a faixa de luz usada (400-500 nm) e por que o RN fica desnudo$i26_2$, 2, 2),
  ($i26_3$Explicou a proteção ocular como medida de segurança$i26_3$, 1, 3),
  ($i26_4$Tranquilizou sobre fezes amolecidas e urina escura (esperados/benignos)$i26_4$, 2, 4),
  ($i26_5$Orientou manutenção da amamentação durante o tratamento$i26_5$, 2, 5),
  ($i26_6$Citou possíveis efeitos a vigiar (hidratação, temperatura)$i26_6$, 1, 6),
  ($i26_7$Comunicação clara e tranquilizadora$i26_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t27$Icterícia grave após uso de naftalina$t27$,
    $e27$Icterícia neonatal$e27$,
    null,
    300,
    $q27$RN de 5 dias com icterícia intensa de início súbito. A família guarda roupas com naftalina.$q27$,
    $res27$RN de 5 dias com icterícia intensa de início súbito. A família guarda
roupas com naftalina. Avalie a possível deficiência de G6PD. ~5 min.$res27$,
    $p27$Mãe de RN, 5 dias de vida$p27$,
    $ctx27$Mãe não associa o agravamento a nada específico. Informe achados quando solicitados.$ctx27$,
    jsonb_build_array(
      $r27$RN estava bem, mamando, com icterícia leve até o 3º dia.$r27$,
      $r27$Subitamente, a partir de ontem: icterícia mais intensa, RN mais pálido e hipoativo.$r27$,
      $r27$Se perguntado: as roupinhas novas do bebê ficaram guardadas com bolinhas de naftalina.$r27$,
      $r27$Há histórico de tios/avôs com 'problema no sangue' ao tomar certos remédios ou comer fava.$r27$,
      $r27$Exames (se pedidos): bilirrubina muito elevada, anemia importante, reticulocitose.$r27$
    ),
    $ach27$Icterícia de agravamento súbito com anemia e reticulocitose após exposição a agente oxidante (naftalina) + história familiar sugestiva → deficiência de G6PD com crise hemolítica aguda. Solicitar dosagem de G6PD (pode estar falsamente normal na crise aguda — repetir após), evitar novos agentes oxidantes (naftalina, alguns medicamentos, fava), fototerapia/exsanguineotransfusão conforme gravidade.$ach27$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ictericia-neonatal')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ictericia-neonatal')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i27_0$Apresentou-se e caracterizou o agravamento súbito da icterícia$i27_0$, 2, 0),
  ($i27_1$Investigou exposição a agentes oxidantes (naftalina, medicamentos, fava)$i27_1$, 3, 1),
  ($i27_2$Investigou história familiar de hemólise/deficiência enzimática$i27_2$, 2, 2),
  ($i27_3$Solicitou bilirrubina, hemograma/reticulócitos e dosagem de G6PD$i27_3$, 2, 3),
  ($i27_4$Reconheceu a deficiência de G6PD como hipótese$i27_4$, 3, 4),
  ($i27_5$Orientou afastar agentes desencadeantes$i27_5$, 2, 5),
  ($i27_6$Indicou fototerapia/conduta conforme a gravidade$i27_6$, 2, 6),
  ($i27_7$Comunicação clara$i27_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t28$Quando a fototerapia não é suficiente$t28$,
    $e28$Icterícia neonatal$e28$,
    null,
    300,
    $q28$RN em fototerapia intensiva, com bilirrubina ainda em ascensão e sinais neurológicos iniciais.$q28$,
    $res28$RN em fototerapia intensiva, com bilirrubina ainda em ascensão e sinais
neurológicos iniciais. Avalie a indicação de exsanguineotransfusão. ~5 min.$res28$,
    $p28$Pais de RN, 3 dias, em fototerapia intensiva$p28$,
    $ctx28$Pais veem a equipe discutir um procedimento mais invasivo e ficam com medo.$ctx28$,
    jsonb_build_array(
      $r28$RN com doença hemolítica por incompatibilidade Rh, já em fototerapia intensiva há horas.$r28$,
      $r28$Bilirrubina continua subindo apesar do tratamento.$r28$,
      $r28$RN está um pouco mais hipotônico e sonolento do que antes.$r28$,
      $r28$Pais perguntam: 'o que é essa troca de sangue, é perigoso?'$r28$
    ),
    $ach28$Falha de resposta à fototerapia intensiva com bilirrubina em ascensão e sinais neurológicos iniciais (hipotonia, sonolência) → indicação de exsanguineotransfusão. Procedimento troca aproximadamente duas volemias (~160 mL/kg), remove bilirrubina, anticorpos e hemácias sensibilizadas. Risco do procedimento existe, mas o risco de NÃO tratar (kernicterus) é maior.$ach28$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ictericia-neonatal')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ictericia-neonatal')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i28_0$Apresentou-se e reconheceu a falha de resposta à fototerapia$i28_0$, 2, 0),
  ($i28_1$Identificou sinais neurológicos iniciais como sinal de gravidade$i28_1$, 3, 1),
  ($i28_2$Reconheceu a indicação de exsanguineotransfusão$i28_2$, 3, 2),
  ($i28_3$Explicou o objetivo do procedimento (remover bilirrubina/anticorpos/hemácias)$i28_3$, 2, 3),
  ($i28_4$Explicou de forma honesta os riscos versus benefícios$i28_4$, 2, 4),
  ($i28_5$Acolheu o medo dos pais com empatia$i28_5$, 2, 5),
  ($i28_6$Comunicação clara e respeitosa diante de procedimento invasivo$i28_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t29$Triagem da icterícia antes da alta$t29$,
    $e29$Icterícia neonatal$e29$,
    null,
    300,
    $q29$RN de 38 horas de vida recebendo alta da maternidade.$q29$,
    $res29$RN de 38 horas de vida recebendo alta da maternidade. Avalie o risco de
icterícia significativa e programe a reavaliação. ~5 min.$res29$,
    $p29$Mãe de RN, 38 horas de vida, recebendo alta$p29$,
    $ctx29$Mãe ansiosa para ir para casa. Informe achados quando solicitados.$ctx29$,
    jsonb_build_array(
      $r29$RN a termo (38 semanas), mamando ao peito, com icterícia leve restrita à face.$r29$,
      $r29$Bilirrubina transcutânea medida em zona de risco intermediário para a idade em horas.$r29$,
      $r29$Mãe é O+, RN ainda sem tipagem confirmada.$r29$,
      $r29$Pergunta se pode ir para casa e quando precisa voltar.$r29$
    ),
    $ach29$RN a termo limítrofe (38 semanas) com icterícia em zona intermediária de risco antes de 48h de vida → necessita reavaliação precoce (48-72h) após a alta, mesmo sem indicação atual de fototerapia. Triagem antes da alta com bilirrubina (transcutânea ou sérica) e nomograma específico por hora de vida reduz risco de hiperbilirrubinemia grave não detectada.$ach29$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ictericia-neonatal')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ictericia-neonatal')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i29_0$Apresentou-se e avaliou a icterícia antes da alta (zona/extensão)$i29_0$, 2, 0),
  ($i29_1$Verificou a idade em horas e a idade gestacional (fator de risco)$i29_1$, 2, 1),
  ($i29_2$Solicitou/interpretou bilirrubina em relação ao nomograma por hora de vida$i29_2$, 3, 2),
  ($i29_3$Identificou fatores de risco adicionais (tipagem materna, prematuridade tardia)$i29_3$, 2, 3),
  ($i29_4$Programou reavaliação em 48-72 horas mesmo sem indicação de fototerapia$i29_4$, 3, 4),
  ($i29_5$Orientou sinais de alarme para retorno antes do agendado$i29_5$, 1, 5),
  ($i29_6$Comunicação clara sobre o plano de alta$i29_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t120$Icterícia precoce e incompatibilidade ABO$t120$,
    $e120$Neonatologia$e120$,
    null,
    300,
    $q120$RN com 20 horas de vida, ictérico, mãe tipo O e RN tipo A.$q120$,
    $res120$RN com 20 horas de vida, ictérico, mãe tipo O e RN tipo A.
Avalie a causa, peça exames e defina conduta inicial. ~5 min.$res120$,
    $p120$Mãe de RN a termo, 20 horas$p120$,
    $ctx120$Mãe tipo sanguíneo O; bebê tipo A. Responda só ao que for perguntado.$ctx120$,
    jsonb_build_array(
      $r120$Percebeu o bebê amarelado já no fim do primeiro dia.$r120$,
      $r120$É o primeiro filho; ela é O positivo e o bebê é A positivo.$r120$,
      $r120$O bebê mama, mas está um pouco sonolento.$r120$,
      $r120$Nasceu a termo, sem outras intercorrências.$r120$
    ),
    $ach120$Icterícia até tronco com <24h de vida; bilirrubina indireta elevada; mãe O / RN A; sugere incompatibilidade ABO.$ach120$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ictericia-neonatal')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ictericia-neonatal')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i120_0$Apresentou-se e identificou mãe/RN$i120_0$, 1, 0),
  ($i120_1$Reconheceu icterícia nas primeiras 24h como sinal de alerta/patológica$i120_1$, 3, 1),
  ($i120_2$Levantou incompatibilidade ABO (mãe O, RN A/B)$i120_2$, 2, 2),
  ($i120_3$Solicitou bilirrubina total e frações$i120_3$, 2, 3),
  ($i120_4$Solicitou tipagem, Coombs direto, hemograma/reticulócitos$i120_4$, 2, 4),
  ($i120_5$Indicou fototerapia conforme gravidade$i120_5$, 2, 5),
  ($i120_6$Comunicação empática e clara$i120_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t121$Icterícia prolongada com colúria e acolia$t121$,
    $e121$Neonatologia$e121$,
    null,
    300,
    $q121$Lactente de 5 semanas com icterícia que não regrediu, urina escura e fezes claras.$q121$,
    $res121$Lactente de 5 semanas com icterícia que não regrediu, urina escura e fezes claras.
Avalie, suspeite de colestase e defina prioridade de investigação. ~5 min.$res121$,
    $p121$Mãe de lactente, 5 semanas$p121$,
    $ctx121$Mãe percebeu que a icterícia 'não foi embora'. Responda só ao que for perguntado.$ctx121$,
    jsonb_build_array(
      $r121$A icterícia começou na 1ª semana e nunca desapareceu de todo.$r121$,
      $r121$A urina está escura (mancha a fralda) e as fezes ficaram esbranquiçadas/claras.$r121$,
      $r121$Mama no peito, ganha pouco peso.$r121$,
      $r121$Nasceu a termo, sem intercorrências no parto.$r121$
    ),
    $ach121$Icterícia persistente >14 dias; colúria; hipocolia/acolia fecal; fígado discretamente aumentado. Sugere colestase neonatal.$ach121$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ictericia-neonatal')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ictericia-neonatal')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i121_0$Apresentou-se e identificou criança/responsável$i121_0$, 1, 0),
  ($i121_1$Reconheceu icterícia >14 dias como alerta para colestase$i121_1$, 3, 1),
  ($i121_2$Valorizou colúria e hipocolia/acolia fecal$i121_2$, 3, 2),
  ($i121_3$Diferenciou hiperbilirrubinemia direta (colestática) da indireta$i121_3$, 2, 3),
  ($i121_4$Solicitou bilirrubina total e frações$i121_4$, 2, 4),
  ($i121_5$Reconheceu urgência da investigação de atresia biliar (Kasai precoce)$i121_5$, 2, 5),
  ($i121_6$Comunicação empática e encaminhamento adequado$i121_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t122$Explicando o metabolismo da bilirrubina aos pais$t122$,
    $e122$Neonatologia$e122$,
    null,
    300,
    $q122$Pais de RN a termo, 3 dias, com icterícia fisiológica, querem entender "por que o bebê fica amarelo".$q122$,
    $res122$Pais de RN a termo, 3 dias, com icterícia fisiológica, querem entender "por que o bebê fica amarelo".
Explique o metabolismo da bilirrubina e diferencie fisiológico de patológico. ~5 min.$res122$,
    $p122$Pai de RN a termo, 3 dias$p122$,
    $ctx122$Pai informado, quer entender o processo. Responda só ao que for perguntado.$ctx122$,
    jsonb_build_array(
      $r122$A icterícia apareceu depois do 2º dia e o bebê está bem, mamando.$r122$,
      $r122$Ele quer saber de onde vem 'esse amarelo'.$r122$,
      $r122$Pergunta por que recém-nascidos ficam mais amarelos que adultos.$r122$,
      $r122$Nasceu a termo, sem intercorrências.$r122$
    ),
    $ach122$Icterícia leve a moderada surgida após 24h, RN ativo e mamando — padrão fisiológico.$ach122$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ictericia-neonatal')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ictericia-neonatal')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i122_0$Apresentou-se e identificou o responsável$i122_0$, 1, 0),
  ($i122_1$Explicou origem da bilirrubina (catabolismo do heme)$i122_1$, 2, 1),
  ($i122_2$Diferenciou bilirrubina indireta (lipossolúvel) e direta (hidrossolúvel)$i122_2$, 2, 2),
  ($i122_3$Citou papel da albumina, hepatócito e conjugação (UGT1A1)$i122_3$, 2, 3),
  ($i122_4$Explicou particularidades neonatais (mais produção, menos conjugação, ciclo êntero-hepático)$i122_4$, 2, 4),
  ($i122_5$Diferenciou icterícia fisiológica (após 24h) de patológica$i122_5$, 2, 5),
  ($i122_6$Linguagem acessível e empática$i122_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t123$Triagem de icterícia antes da alta$t123$,
    $e123$Neonatologia$e123$,
    null,
    300,
    $q123$RN a termo, 40 horas, em vias de alta. A equipe pede avaliação do risco de hiperbilirrubinemia.$q123$,
    $res123$RN a termo, 40 horas, em vias de alta. A equipe pede avaliação do risco de hiperbilirrubinemia.
Avalie fatores de risco e oriente reavaliação. ~5 min.$res123$,
    $p123$Mãe de RN a termo, 40 horas$p123$,
    $ctx123$Alta programada para hoje. Responda só ao que for perguntado.$ctx123$,
    jsonb_build_array(
      $r123$O bebê está discretamente amarelado no rosto.$r123$,
      $r123$Mãe O positivo; não sabe o tipo do bebê ainda.$r123$,
      $r123$Houve dificuldade inicial de pega ao seio; perdeu um pouco de peso.$r123$,
      $r123$Vão para casa hoje e moram longe do hospital.$r123$
    ),
    $ach123$Icterícia leve em face; fatores de risco: incompatibilidade ABO possível, perda ponderal, dificuldade de amamentação.$ach123$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ictericia-neonatal')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ictericia-neonatal')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i123_0$Apresentou-se e identificou mãe/RN$i123_0$, 1, 0),
  ($i123_1$Avaliou a icterícia (zona/intensidade) e estado geral$i123_1$, 2, 1),
  ($i123_2$Identificou fatores de risco para hiperbilirrubinemia$i123_2$, 3, 2),
  ($i123_3$Considerou bilirrubina transcutânea/sérica antes da alta$i123_3$, 2, 3),
  ($i123_4$Orientou reavaliação em 48–72 horas após a alta$i123_4$, 2, 4),
  ($i123_5$Orientou sinais de alarme para retorno imediato$i123_5$, 1, 5),
  ($i123_6$Comunicação clara, considerando o acesso ao serviço$i123_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t124$Efeitos adversos da fototerapia$t124$,
    $e124$Neonatologia$e124$,
    null,
    300,
    $q124$RN em fototerapia há 1 dia. A mãe está preocupada com mudanças que notou no bebê.$q124$,
    $res124$RN em fototerapia há 1 dia. A mãe está preocupada com mudanças que notou no bebê.
Avalie, explique os efeitos adversos esperados e oriente cuidados. ~5 min.$res124$,
    $p124$Mãe de RN a termo em fototerapia$p124$,
    $ctx124$Mãe ansiosa com a fototerapia. Responda só ao que for perguntado.$ctx124$,
    jsonb_build_array(
      $r124$O bebê está com fezes mais amolecidas e xixi mais escuro.$r124$,
      $r124$Parece mamar com mais frequência e às vezes está mais 'molinho'.$r124$,
      $r124$Pergunta se a luz faz mal aos olhos.$r124$,
      $r124$A icterícia está melhorando segundo a equipe.$r124$
    ),
    $ach124$Sob fototerapia: fezes amolecidas, perdas hídricas aumentadas; olhos protegidos; sem síndrome do bebê bronzeado (BD normal).$ach124$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'ictericia-neonatal')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('ictericia-neonatal')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i124_0$Apresentou-se e identificou mãe/RN$i124_0$, 1, 0),
  ($i124_1$Explicou o mecanismo da fototerapia (fotoisomerização, 400–500 nm)$i124_1$, 2, 1),
  ($i124_2$Reconheceu efeitos adversos (perdas hídricas, fezes amolecidas, urina escura)$i124_2$, 3, 2),
  ($i124_3$Citou proteção ocular e cuidado com hidratação/temperatura$i124_3$, 2, 3),
  ($i124_4$Mencionou síndrome do bebê bronzeado quando BD elevada$i124_4$, 1, 4),
  ($i124_5$Reforçou que a eficácia depende de área exposta e irradiância$i124_5$, 2, 5),
  ($i124_6$Comunicação empática e tranquilizadora$i124_6$, 1, 6)
) as v(texto, grav, ord);
