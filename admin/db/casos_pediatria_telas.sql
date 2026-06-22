-- Migracao automatica de cases.js -> Supabase (status em_revisao).
-- Gerado por gen_migracao_pediatria.js. Rodar DEPOIS de migracao_taxonomia_pediatria.sql.

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t60$Bebê que só se acalma com o celular$t60$,
    $e60$Uso abusivo de telas$e60$,
    null,
    300,
    $q60$Os pais relatam que o filho de 18 meses passa horas com vídeos no celular/TV.$q60$,
    $res60$Puericultura. Os pais relatam que o filho de 18 meses passa horas com
vídeos no celular/TV. Avalie o impacto e oriente. ~5 min.$res60$,
    $p60$Pais de criança, 18 meses$p60$,
    $ctx60$Pais cansados, usam a tela para conseguir uma pausa. Respondam ao que for perguntado.$ctx60$,
    jsonb_build_array(
      $r60$Assiste vídeos 3-4 h/dia, inclusive durante as refeições e para dormir.$r60$,
      $r60$Fala poucas palavras; brinca pouco com brinquedos.$r60$,
      $r60$Faz birra forte quando tiram a tela.$r60$,
      $r60$Usa o celular/TV até dormir; sono um pouco irregular.$r60$
    ),
    $ach60$Exposição a telas muito acima do recomendado (SBP: desaconselhada antes dos 2 anos), com possível repercussão em linguagem, brincar e sono. Foco em orientação familiar e avaliação do desenvolvimento.$ach60$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'uso-abusivo-de-telas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('uso-abusivo-de-telas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i60_0$Apresentou-se e investigou tempo e contexto de tela (quanto, quando, onde)$i60_0$, 2, 0),
  ($i60_1$Perguntou o conteúdo e se há couso (adulto junto)$i60_1$, 1, 1),
  ($i60_2$Avaliou impacto em linguagem, brincar e interação$i60_2$, 2, 2),
  ($i60_3$Avaliou impacto no sono e nas refeições$i60_3$, 2, 3),
  ($i60_4$Citou a recomendação de evitar telas antes dos 2 anos$i60_4$, 2, 4),
  ($i60_5$Orientou substituir por brincadeira, leitura e interação$i60_5$, 2, 5),
  ($i60_6$Orientou retirar telas das refeições e antes de dormir$i60_6$, 2, 6),
  ($i60_7$Pactuou metas realistas com a família$i60_7$, 1, 7),
  ($i60_8$Comunicação acolhedora, sem culpabilizar$i60_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t61$Pré-escolar agitado que dorme mal$t61$,
    $e61$Uso abusivo de telas$e61$,
    null,
    300,
    $q61$Pré-escolar de 4 anos com irritabilidade, birras e sono ruim; usa tablet à noite.$q61$,
    $res61$Ambulatório. Pré-escolar de 4 anos com irritabilidade, birras e sono
ruim; usa tablet à noite. Avalie a relação com as telas e oriente. ~5 min.$res61$,
    $p61$Mãe de criança, 4 anos$p61$,
    $ctx61$Mãe queixa-se das birras e do sono. Responda objetivamente.$ctx61$,
    jsonb_build_array(
      $r61$Usa tablet/TV ~4 h/dia, inclusive no quarto, à noite.$r61$,
      $r61$Demora muito para dormir e acorda cansado.$r61$,
      $r61$Muito irritado, com birras frequentes.$r61$,
      $r61$Brinca pouco ao ar livre; assiste vídeos agitados sem supervisão.$r61$
    ),
    $ach61$Uso excessivo de telas, inclusive noturno e no quarto, associado a má higiene do sono e irritabilidade. Recomendação 2-5 anos: até ~1 h/dia de conteúdo de qualidade, com supervisão.$ach61$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'uso-abusivo-de-telas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('uso-abusivo-de-telas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i61_0$Apresentou-se e quantificou o tempo/contexto de telas$i61_0$, 2, 0),
  ($i61_1$Avaliou a higiene do sono (rotina, tela no quarto, antes de dormir)$i61_1$, 3, 1),
  ($i61_2$Relacionou telas noturnas ao sono ruim e à irritabilidade$i61_2$, 2, 2),
  ($i61_3$Avaliou atividade física e brincar$i61_3$, 1, 3),
  ($i61_4$Citou a recomendação para 2-5 anos (~1 h/dia, qualidade, supervisão)$i61_4$, 2, 4),
  ($i61_5$Orientou retirar telas do quarto e ~1 h antes de dormir$i61_5$, 2, 5),
  ($i61_6$Orientou rotina de sono e mais atividade física$i61_6$, 2, 6),
  ($i61_7$Pactuou metas com a família$i61_7$, 1, 7),
  ($i61_8$Comunicação empática$i61_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t62$Escolar sedentário com ganho de peso$t62$,
    $e62$Uso abusivo de telas$e62$,
    null,
    300,
    $q62$Escolar de 10 anos com ganho de peso, muitas horas em telas e pouca atividade física.$q62$,
    $res62$Ambulatório. Escolar de 10 anos com ganho de peso, muitas horas em
telas e pouca atividade física. Avalie e oriente hábitos. ~5 min.$res62$,
    $p62$Pai de escolar, 10 anos$p62$,
    $ctx62$Pai preocupado com o peso do filho. Responda ao que for perguntado.$ctx62$,
    jsonb_build_array(
      $r62$Passa ~6 h/dia entre celular, games e TV; pratica pouca atividade física.$r62$,
      $r62$Belisca enquanto usa as telas; bebe bastante refrigerante e ultraprocessados.$r62$,
      $r62$Vem ganhando peso e reclama de cansaço.$r62$,
      $r62$Tem telas no quarto e dorme tarde.$r62$
    ),
    $ach62$Sedentarismo e uso excessivo de telas associados a alimentação inadequada e ganho ponderal. Abordagem de hábitos de vida: telas, alimentação, atividade física e sono.$ach62$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'uso-abusivo-de-telas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('uso-abusivo-de-telas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i62_0$Apresentou-se e quantificou tempo de tela e tipo de uso$i62_0$, 2, 0),
  ($i62_1$Avaliou atividade física e sedentarismo$i62_1$, 2, 1),
  ($i62_2$Avaliou alimentação (ultraprocessados, beliscar em frente à tela)$i62_2$, 2, 2),
  ($i62_3$Avaliou sono e telas no quarto$i62_3$, 1, 3),
  ($i62_4$Relacionou os hábitos ao ganho de peso$i62_4$, 2, 4),
  ($i62_5$Orientou limite de telas e aumento de atividade física$i62_5$, 2, 5),
  ($i62_6$Orientou alimentação saudável e refeições sem tela$i62_6$, 2, 6),
  ($i62_7$Pactuou metas e seguimento$i62_7$, 1, 7),
  ($i62_8$Comunicação motivacional, sem estigmatizar$i62_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t63$Adolescente sempre nas redes sociais$t63$,
    $e63$Uso abusivo de telas$e63$,
    null,
    300,
    $q63$Adolescente de 14 anos com uso intenso de redes sociais, queda no rendimento e queixas de humor e sono.$q63$,
    $res63$Ambulatório. Adolescente de 14 anos com uso intenso de redes sociais,
queda no rendimento e queixas de humor e sono. Avalie o uso problemático e oriente. ~5 min.$res63$,
    $p63$Adolescente, 14 anos (acompanhado da mãe)$p63$,
    $ctx63$Adolescente fechado; abre-se se houver privacidade e acolhimento.$ctx63$,
    jsonb_build_array(
      $r63$Fica até de madrugada em redes e jogos; dorme pouco e tem sono de dia.$r63$,
      $r63$Rendimento escolar caiu; anda irritado e se isolando.$r63$,
      $r63$Compara-se nas redes; sente-se ansioso e às vezes triste.$r63$,
      $r63$Se perguntado com cuidado: nega cyberbullying e ideação, mas é importante perguntar.$r63$
    ),
    $ach63$Uso problemático de telas/redes com repercussão em sono, humor, escola e socialização. Importante rastrear ansiedade/depressão, cyberbullying e segurança, com abordagem que respeite a privacidade do adolescente.$ach63$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'uso-abusivo-de-telas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('uso-abusivo-de-telas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i63_0$Apresentou-se e garantiu espaço/privacidade ao adolescente$i63_0$, 2, 0),
  ($i63_1$Caracterizou o padrão de uso (tempo, madrugada, perda de controle)$i63_1$, 2, 1),
  ($i63_2$Avaliou impacto em sono, escola e socialização$i63_2$, 2, 2),
  ($i63_3$Rastreou humor/ansiedade e ideação (saúde mental)$i63_3$, 3, 3),
  ($i63_4$Pesquisou cyberbullying e segurança online$i63_4$, 2, 4),
  ($i63_5$Reconheceu o uso problemático de telas$i63_5$, 2, 5),
  ($i63_6$Pactuou metas com o adolescente (autonomia) e a família$i63_6$, 2, 6),
  ($i63_7$Encaminhou para saúde mental se indicado$i63_7$, 1, 7),
  ($i63_8$Comunicação empática e sem julgamento$i63_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t64$Orientação preventiva sobre telas$t64$,
    $e64$Uso abusivo de telas$e64$,
    null,
    300,
    $q64$Puericultura de criança de 2 anos saudável. Os pais pedem orientação sobre uso de telas.$q64$,
    $res64$Puericultura de criança de 2 anos saudável. Os pais pedem orientação
sobre uso de telas. Faça o aconselhamento preventivo. ~5 min.$res64$,
    $p64$Pais de criança, 2 anos$p64$,
    $ctx64$Pais sem queixas, querem 'fazer certo'. Façam perguntas práticas.$ctx64$,
    jsonb_build_array(
      $r64$Sem queixas; perguntam 'pode deixar ver desenho?', 'quanto tempo?', 'pode na refeição?'.$r64$,
      $r64$Em casa a TV fica ligada de fundo o tempo todo.$r64$,
      $r64$Querem saber o que é recomendado para a idade.$r64$
    ),
    $ach64$Cenário de aconselhamento. Pontos SBP: evitar telas <2 anos; 2-5 anos até ~1 h/dia de qualidade com supervisão; sem telas em refeições e antes de dormir; sem tela no quarto; couso; exemplo dos pais; 'plano de mídia' familiar.$ach64$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'uso-abusivo-de-telas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('uso-abusivo-de-telas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i64_0$Apresentou-se e explorou os hábitos atuais da família$i64_0$, 2, 0),
  ($i64_1$Orientou a recomendação por faixa etária (evitar <2a; 2-5a ~1 h)$i64_1$, 3, 1),
  ($i64_2$Orientou conteúdo de qualidade e couso (assistir junto)$i64_2$, 2, 2),
  ($i64_3$Orientou ambientes livres de tela (refeições, quarto, antes de dormir)$i64_3$, 2, 3),
  ($i64_4$Ressaltou o exemplo dos pais e o uso consciente$i64_4$, 2, 4),
  ($i64_5$Incentivou brincar, leitura e atividade física$i64_5$, 2, 5),
  ($i64_6$Pactuou um 'plano de mídia' familiar$i64_6$, 1, 6),
  ($i64_7$Comunicação didática e acolhedora$i64_7$, 1, 7)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t65$Adolescente que joga sem parar$t65$,
    $e65$Uso abusivo de telas$e65$,
    null,
    300,
    $q65$Pais de adolescente de 15 anos relatam que ele "só pensa em jogos online", com queda no desempenho escolar.$q65$,
    $res65$Ambulatório. Pais de adolescente de 15 anos relatam que ele "só
pensa em jogos online", com queda no desempenho escolar. Avalie o Transtorno
do Jogo (Gaming Disorder). ~5 min.$res65$,
    $p65$Pais de adolescente, 15 anos$p65$,
    $ctx65$Pais preocupados, adolescente relutante em conversar sobre o assunto.$ctx65$,
    jsonb_build_array(
      $r65$Joga mais de 8 horas por dia, incluindo madrugadas, há mais de 1 ano.$r65$,
      $r65$Já perdeu o interesse por atividades que gostava antes (esportes, amigos presenciais).$r65$,
      $r65$Quando os pais tentam limitar o tempo, fica extremamente irritado e agressivo verbalmente.$r65$,
      $r65$Continua jogando mesmo sabendo que está reprovando matérias na escola.$r65$,
      $r65$Já tentou reduzir o tempo de jogo por conta própria e não conseguiu.$r65$,
      $r65$Tem alterado o sono e diminuído a alimentação para continuar jogando.$r65$
    ),
    $ach65$Critérios do DSM-5 para Transtorno do Jogo (Gaming Disorder): presença de pelo menos 5 de 9 critérios (preocupação com o jogo, abstinência ao ser impedido, tolerância/necessidade de mais tempo, tentativas fracassadas de controlar, perda de interesse em outras atividades, uso continuado a despeito de problemas, mentir sobre o tempo de uso, uso para escapar de humor negativo, prejuízo significativo em relações/escola/trabalho) em um período de 12 meses, com impacto funcional significativo. O caso preenche múltiplos critérios (perda de interesse, conflito ao limitar, uso continuado com prejuízo escolar, alteração de sono/alimentação).$ach65$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'uso-abusivo-de-telas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('uso-abusivo-de-telas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i65_0$Investigou o tempo e o padrão de uso dos jogos$i65_0$, 2, 0),
  ($i65_1$Avaliou prejuízo funcional (escola, sono, alimentação, relações)$i65_1$, 2, 1),
  ($i65_2$Avaliou tentativas fracassadas de reduzir o uso e reação ao ser limitado$i65_2$, 2, 2),
  ($i65_3$Aplicou/citou os critérios do DSM-5 para Transtorno do Jogo (≥5 de 9 critérios)$i65_3$, 3, 3),
  ($i65_4$Reconheceu o diagnóstico de Gaming Disorder$i65_4$, 3, 4),
  ($i65_5$Discutiu encaminhamento para suporte especializado (psicologia/psiquiatria)$i65_5$, 1, 5),
  ($i65_6$Comunicação acolhedora com a família e com o adolescente$i65_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t66$Ansiedade sem o celular por perto$t66$,
    $e66$Uso abusivo de telas$e66$,
    null,
    300,
    $q66$Adolescente de 16 anos relata "desespero" quando fica sem o celular ou sem internet.$q66$,
    $res66$Ambulatório. Adolescente de 16 anos relata "desespero" quando fica
sem o celular ou sem internet. Avalie a nomofobia e o FoMO. ~5 min.$res66$,
    $p66$Adolescente, 16 anos$p66$,
    $ctx66$Veio acompanhada da mãe, mas fala abertamente quando perguntada.$ctx66$,
    jsonb_build_array(
      $r66$Relata ansiedade intensa quando o celular fica sem bateria ou sem sinal.$r66$,
      $r66$Checa as redes sociais constantemente por medo de 'perder algo importante' que os amigos estão fazendo/postando.$r66$,
      $r66$Leva o celular ao banheiro e dorme com ele ao lado, checando notificações de madrugada.$r66$,
      $r66$Já teve crises de choro quando a mãe tentou guardar o celular por um dia.$r66$,
      $r66$Sem outros sintomas psiquiátricos identificados até o momento.$r66$
    ),
    $ach66$Nomofobia ('no mobile phone phobia'): medo/ansiedade exagerada de ficar sem o celular ou sem acesso à internet. FoMO ('fear of missing out'): medo de perder experiências/informações que outros estão tendo, levando à checagem compulsiva de redes sociais. Ambos os construtos estão associados ao uso problemático de telas e podem prejudicar sono, atenção e bem-estar emocional do adolescente.$ach66$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'uso-abusivo-de-telas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('uso-abusivo-de-telas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i66_0$Investigou a reação emocional à ausência do celular/internet$i66_0$, 2, 0),
  ($i66_1$Identificou o padrão de checagem compulsiva de redes sociais$i66_1$, 2, 1),
  ($i66_2$Reconheceu o conceito de nomofobia$i66_2$, 3, 2),
  ($i66_3$Reconheceu o conceito de FoMO (medo de ficar de fora)$i66_3$, 3, 3),
  ($i66_4$Avaliou o impacto sobre sono e rotina$i66_4$, 1, 4),
  ($i66_5$Orientou estratégias de manejo (horários sem tela, suporte psicológico se necessário)$i66_5$, 2, 5),
  ($i66_6$Comunicação didática e sem julgamento$i66_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t67$Tela durante as refeições e antes de dormir$t67$,
    $e67$Uso abusivo de telas$e67$,
    null,
    300,
    $q67$Pais de criança de 4 anos relatam que ela "só come vendo desenho" e usa tablet até a hora de dormir.$q67$,
    $res67$Puericultura. Pais de criança de 4 anos relatam que ela "só come
vendo desenho" e usa tablet até a hora de dormir. Oriente sobre os momentos a
evitar o uso de telas. ~5 min.$res67$,
    $p67$Pais de criança de 4 anos$p67$,
    $ctx67$Pais acham que a tela 'ajuda' a criança a comer e a ficar calma antes de dormir.$ctx67$,
    jsonb_build_array(
      $r67$Criança só aceita comer enquanto assiste desenhos no tablet, em todas as refeições.$r67$,
      $r67$Usa tablet/celular até pouco antes de apagar a luz para dormir.$r67$,
      $r67$Demora para pegar no sono e acorda à noite com frequência.$r67$,
      $r67$Pais acham que 'sem a tela ela não comeria nada' e teriam mais dificuldade na hora de dormir.$r67$,
      $r67$Tempo total de tela no dia, somando momentos, é de cerca de 3-4 horas.$r67$
    ),
    $ach67$Recomendações da SBP: evitar uso de telas durante as refeições (interfere na percepção de saciedade e na interação familiar) e evitar telas nas 1-2 horas antes de dormir (luz azul e estimulação interferem na higiene do sono). Para a faixa de 2-5 anos, o tempo recomendado de tela é de até 1 hora/dia — o tempo relatado (3-4h) está bem acima do recomendado.$ach67$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'uso-abusivo-de-telas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('uso-abusivo-de-telas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i67_0$Quantificou o tempo total de tela no dia$i67_0$, 2, 0),
  ($i67_1$Identificou o uso de telas durante as refeições como inadequado$i67_1$, 2, 1),
  ($i67_2$Identificou o uso de telas antes de dormir como inadequado$i67_2$, 2, 2),
  ($i67_3$Informou o limite recomendado para a faixa etária (até 1h/dia, 2-5 anos)$i67_3$, 3, 3),
  ($i67_4$Relacionou o uso nas refeições/antes de dormir aos problemas de sono/comportamento$i67_4$, 2, 4),
  ($i67_5$Orientou estratégias alternativas (rotina de sono, refeições em família sem tela)$i67_5$, 2, 5),
  ($i67_6$Comunicação acolhedora, sem culpabilizar os pais$i67_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t68$Quanto tempo de tela é adequado para essa idade?$t68$,
    $e68$Uso abusivo de telas$e68$,
    null,
    300,
    $q68$Pais de criança de 8 anos perguntam qual o tempo de tela recomendado e como negociar regras em casa.$q68$,
    $res68$Puericultura. Pais de criança de 8 anos perguntam qual o tempo de
tela recomendado e como negociar regras em casa. ~5 min.$res68$,
    $p68$Pais de criança de 8 anos$p68$,
    $ctx68$Pais sem regras claras atualmente, criança usa tela 'quando quer'.$ctx68$,
    jsonb_build_array(
      $r68$Hoje a criança usa tela de forma livre, sem horário definido, cerca de 4-5 horas por dia entre TV, tablet e jogos.$r68$,
      $r68$Pais perguntam: 'qual é o tempo certo para essa idade?'$r68$,
      $r68$Notam que o desempenho escolar caiu um pouco e a criança fica mais irritada quando pedem para desligar.$r68$,
      $r68$Perguntam como negociar limites sem gerar muito conflito.$r68$
    ),
    $ach68$Recomendação da SBP para a faixa dos 5 anos até a adolescência: até 2 horas de tela por dia, com conteúdo de qualidade e supervisionado. O tempo atual relatado (4-5h) está acima do recomendado. Estratégias úteis: regras claras e combinadas com antecedência, tempo de tela como parte de uma rotina equilibrada (não como recompensa/punição isolada), e consistência dos pais no cumprimento das regras.$ach68$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'uso-abusivo-de-telas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('uso-abusivo-de-telas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i68_0$Quantificou o tempo atual de uso de telas$i68_0$, 2, 0),
  ($i68_1$Informou o limite recomendado para a faixa etária (até 2h/dia, 5 anos a adolescência)$i68_1$, 3, 1),
  ($i68_2$Relacionou o uso excessivo à queda de desempenho escolar e irritabilidade$i68_2$, 2, 2),
  ($i68_3$Orientou regras claras e combinadas com antecedência$i68_3$, 2, 3),
  ($i68_4$Orientou consistência dos pais e evitar uso de tela como recompensa/punição$i68_4$, 2, 4),
  ($i68_5$Incentivou atividades alternativas (esporte, leitura, brincadeiras)$i68_5$, 1, 5),
  ($i68_6$Comunicação prática e sem julgamento$i68_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t69$Brigas em casa por causa do tempo de tela$t69$,
    $e69$Uso abusivo de telas$e69$,
    null,
    300,
    $q69$Pais de adolescente de 13 anos relatam conflitos diários e intensos na tentativa de limitar o uso do celular.$q69$,
    $res69$Ambulatório. Pais de adolescente de 13 anos relatam conflitos
diários e intensos na tentativa de limitar o uso do celular. Oriente uma
abordagem familiar para o uso de telas. ~5 min.$res69$,
    $p69$Pais de adolescente, 13 anos$p69$,
    $ctx69$Pais exaustos, alternam entre permitir tudo e proibir tudo de uma vez.$ctx69$,
    jsonb_build_array(
      $r69$Brigas diárias na hora de pedir para o adolescente desligar o celular.$r69$,
      $r69$Não existe horário ou regra combinada — os limites mudam dependendo do humor dos pais no dia.$r69$,
      $r69$Quando tentam confiscar o celular, o adolescente fica agressivo verbalmente e há gritos.$r69$,
      $r69$Pais às vezes usam o celular como ameaça/castigo ('se não fizer X, fico com o celular para sempre').$r69$,
      $r69$Perguntam: 'como a gente para de brigar todo dia por isso?'$r69$
    ),
    $ach69$Conflitos recorrentes por tempo de tela geralmente refletem ausência de regras claras e consistentes, mais do que apenas o tempo de uso em si. Recomenda-se construir um 'plano de mídia familiar' negociado previamente (e não decidido no calor do momento), com horários e locais sem tela definidos (refeições, quarto, 1-2h antes de dormir), consistência entre os pais, e evitar usar a tela como moeda de punição/recompensa extrema, o que aumenta o valor emocional do dispositivo e o conflito.$ach69$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'uso-abusivo-de-telas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('uso-abusivo-de-telas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i69_0$Investigou como as regras de uso são (ou não) definidas em casa$i69_0$, 2, 0),
  ($i69_1$Identificou a inconsistência das regras como fator de conflito$i69_1$, 2, 1),
  ($i69_2$Desencorajou o uso do celular como punição/recompensa extrema$i69_2$, 2, 2),
  ($i69_3$Orientou a construção de um plano de mídia familiar negociado$i69_3$, 3, 3),
  ($i69_4$Orientou consistência entre os pais na aplicação das regras$i69_4$, 2, 4),
  ($i69_5$Sugeriu momentos/locais sem tela (refeições, antes de dormir)$i69_5$, 1, 5),
  ($i69_6$Comunicação acolhedora com a exaustão dos pais$i69_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t135$Exposição a telas no lactente$t135$,
    $e135$Pediatria / Saúde mental$e135$,
    null,
    300,
    $q135$Lactente de 18 meses exposto passivamente a telas durante boa parte do dia.$q135$,
    $res135$Lactente de 18 meses exposto passivamente a telas durante boa parte do dia.
Oriente os pais com base nas recomendações por idade. ~5 min.$res135$,
    $p135$Mãe de lactente de 18 meses$p135$,
    $ctx135$Mãe acha que vídeos 'educativos' ajudam. Responda só ao que for perguntado.$ctx135$,
    jsonb_build_array(
      $r135$A criança assiste a vídeos no celular/TV por várias horas, inclusive nas refeições.$r135$,
      $r135$Usam a tela para distrair na hora de comer e para dormir.$r135$,
      $r135$Ela fala poucas palavras e interage menos quando está na tela.$r135$,
      $r135$Os pais perguntam quanto tempo de tela é permitido nessa idade.$r135$
    ),
    $ach135$Exposição excessiva e passiva a telas; uso nas refeições e antes de dormir; possível impacto em linguagem/interação.$ach135$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'uso-abusivo-de-telas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('uso-abusivo-de-telas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i135_0$Apresentou-se e identificou criança/responsável$i135_0$, 1, 0),
  ($i135_1$Quantificou o tempo e o contexto do uso de telas$i135_1$, 2, 1),
  ($i135_2$Orientou que abaixo de 2 anos telas não são recomendadas$i135_2$, 3, 2),
  ($i135_3$Explicou importância de vínculo, linguagem e estímulos nos primeiros mil dias$i135_3$, 2, 3),
  ($i135_4$Orientou evitar telas nas refeições e antes de dormir$i135_4$, 2, 4),
  ($i135_5$Sugeriu alternativas de interação/brincadeira$i135_5$, 1, 5),
  ($i135_6$Comunicação empática, sem culpabilizar$i135_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t136$Diferenciar FoMO, nomofobia e Gaming Disorder$t136$,
    $e136$Pediatria / Saúde mental$e136$,
    null,
    300,
    $q136$Adolescente de 14 anos com uso intenso de redes/jogos. Os pais querem entender os conceitos.$q136$,
    $res136$Adolescente de 14 anos com uso intenso de redes/jogos. Os pais querem entender os conceitos.
Diferencie FoMO, nomofobia e Gaming Disorder e oriente. ~5 min.$res136$,
    $p136$Mãe de adolescente de 14 anos$p136$,
    $ctx136$Mãe ouviu vários termos e quer entender. Responda só ao que for perguntado.$ctx136$,
    jsonb_build_array(
      $r136$O filho fica ansioso achando que 'está perdendo' o que rola online.$r136$,
      $r136$Entra em pânico quando fica sem o celular ou sem bateria.$r136$,
      $r136$Joga muitas horas, já largou outras atividades e briga quando pedem para parar.$r136$,
      $r136$Pergunta a diferença entre esses 'transtornos'.$r136$
    ),
    $ach136$Relato sugere FoMO (medo de perder experiências), nomofobia (medo de ficar sem celular) e traços de Gaming Disorder.$ach136$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'uso-abusivo-de-telas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('uso-abusivo-de-telas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i136_0$Apresentou-se e acolheu a família$i136_0$, 1, 0),
  ($i136_1$Definiu FoMO (medo de perder experiências/informações online)$i136_1$, 2, 1),
  ($i136_2$Definiu nomofobia (ansiedade/medo de ficar sem o celular)$i136_2$, 2, 2),
  ($i136_3$Definiu Gaming Disorder (padrão persistente e prejudicial)$i136_3$, 2, 3),
  ($i136_4$Citou critério geral (≥5 de 9 em 12 meses, com prejuízo)$i136_4$, 2, 4),
  ($i136_5$Orientou abordagem (psicoeducação, TCC, mediação parental)$i136_5$, 1, 5),
  ($i136_6$Comunicação clara e empática$i136_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t137$Telas, luz azul e sono no escolar$t137$,
    $e137$Pediatria / Saúde mental$e137$,
    null,
    300,
    $q137$Escolar de 10 anos com dificuldade para dormir e uso de telas à noite.$q137$,
    $res137$Escolar de 10 anos com dificuldade para dormir e uso de telas à noite.
Explique a relação com o sono e oriente higiene de sono. ~5 min.$res137$,
    $p137$Mãe de escolar de 10 anos$p137$,
    $ctx137$Mãe relata que o filho 'não desliga'. Responda só ao que for perguntado.$ctx137$,
    jsonb_build_array(
      $r137$Usa tablet e celular na cama até tarde.$r137$,
      $r137$Demora a pegar no sono, acorda cansado e rende menos na escola.$r137$,
      $r137$Tem TV/celular no quarto.$r137$,
      $r137$Ela quer saber se a tela atrapalha o sono.$r137$
    ),
    $ach137$Uso de telas noturno; latência do sono aumentada; sonolência diurna e queda de rendimento.$ach137$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'uso-abusivo-de-telas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('uso-abusivo-de-telas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i137_0$Apresentou-se e identificou criança/responsável$i137_0$, 1, 0),
  ($i137_1$Caracterizou o uso noturno e o impacto no sono/escola$i137_1$, 2, 1),
  ($i137_2$Explicou luz azul × melatonina e prejuízo do sono$i137_2$, 3, 2),
  ($i137_3$Orientou evitar telas 1–2 horas antes de dormir$i137_3$, 2, 3),
  ($i137_4$Sugeriu limites por idade (até ~2h/dia) e telas fora do quarto$i137_4$, 2, 4),
  ($i137_5$Reforçou rotina de sono e atividade física$i137_5$, 1, 5),
  ($i137_6$Comunicação empática$i137_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t138$Riscos online: cyberbullying e sexting$t138$,
    $e138$Pediatria / Saúde mental$e138$,
    null,
    300,
    $q138$Adolescente de 13 anos com retraimento e queda escolar após situações nas redes sociais.$q138$,
    $res138$Adolescente de 13 anos com retraimento e queda escolar após situações nas redes sociais.
Avalie riscos online e oriente proteção. ~5 min.$res138$,
    $p138$Pai de adolescente de 13 anos$p138$,
    $ctx138$Pai notou mudança de comportamento. Responda só ao que for perguntado.$ctx138$,
    jsonb_build_array(
      $r138$O(a) filho(a) ficou retraído(a), ansioso(a) e evita o celular na frente dos pais.$r138$,
      $r138$Houve relatos de mensagens ofensivas em grupos (cyberbullying).$r138$,
      $r138$Preocupação com troca de imagens íntimas (sexting).$r138$,
      $r138$Caiu o rendimento e o humor.$r138$
    ),
    $ach138$Sinais de sofrimento associados a riscos online (cyberbullying, sexting); humor deprimido/ansioso.$ach138$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'uso-abusivo-de-telas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('uso-abusivo-de-telas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i138_0$Apresentou-se e criou ambiente de confiança$i138_0$, 1, 0),
  ($i138_1$Investigou riscos online (cyberbullying, sexting, exposição)$i138_1$, 3, 1),
  ($i138_2$Avaliou impacto no humor e sinais de sofrimento/risco$i138_2$, 2, 2),
  ($i138_3$Orientou diálogo, mediação parental e privacidade/segurança$i138_3$, 2, 3),
  ($i138_4$Indicou apoio psicológico quando necessário$i138_4$, 1, 4),
  ($i138_5$Abordou aspectos de proteção sem culpabilizar o adolescente$i138_5$, 1, 5),
  ($i138_6$Comunicação empática e cuidadosa$i138_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t139$Definindo limites de tela em família$t139$,
    $e139$Pediatria / Saúde mental$e139$,
    null,
    300,
    $q139$Pré-escolar de 4 anos com uso crescente de telas. Os pais pedim orientação prática.$q139$,
    $res139$Pré-escolar de 4 anos com uso crescente de telas. Os pais pedim orientação prática.
Oriente limites e estratégias por idade. ~5 min.$res139$,
    $p139$Mãe de pré-escolar de 4 anos$p139$,
    $ctx139$Mãe quer regras práticas e viáveis. Responda só ao que for perguntado.$ctx139$,
    jsonb_build_array(
      $r139$A criança assiste a desenhos por cerca de 3 horas por dia.$r139$,
      $r139$Usa tela durante as refeições e tem birra ao desligar.$r139$,
      $r139$Os pais também ficam muito no celular em casa.$r139$,
      $r139$Perguntam o que é razoável para a idade.$r139$
    ),
    $ach139$Uso acima do recomendado para a idade; tela nas refeições; modelo parental de uso intenso.$ach139$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'uso-abusivo-de-telas')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('uso-abusivo-de-telas')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i139_0$Apresentou-se e identificou criança/responsável$i139_0$, 1, 0),
  ($i139_1$Quantificou tempo e contexto do uso$i139_1$, 2, 1),
  ($i139_2$Orientou limite por idade (2–5 anos: até ~1h/dia)$i139_2$, 3, 2),
  ($i139_3$Orientou evitar telas nas refeições e antes de dormir$i139_3$, 2, 3),
  ($i139_4$Sugeriu uso em áreas comuns e exemplo dos pais$i139_4$, 2, 4),
  ($i139_5$Propôs alternativas (brincar, ler, atividade física)$i139_5$, 1, 5),
  ($i139_6$Comunicação empática, sem culpabilizar$i139_6$, 1, 6)
) as v(texto, grav, ord);
