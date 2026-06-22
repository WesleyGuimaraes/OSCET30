-- Migracao automatica de cases.js -> Supabase (status em_revisao).
-- Gerado por gen_migracao_pediatria.js. Rodar DEPOIS de migracao_taxonomia_pediatria.sql.

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t90$Apoio à amamentação no primeiro mês$t90$,
    $e90$Alimentação infantil$e90$,
    null,
    300,
    $q90$Mãe de RN de 20 dias com dúvidas sobre amamentação.$q90$,
    $res90$Puericultura. Mãe de RN de 20 dias com dúvidas sobre amamentação.
Faça a orientação sobre aleitamento materno exclusivo. ~5 min.$res90$,
    $p90$Mãe de RN, 20 dias$p90$,
    $ctx90$Mãe de primeira viagem, cheia de dúvidas. Faça perguntas práticas.$ctx90$,
    jsonb_build_array(
      $r90$Amamenta no peito; pergunta se precisa dar água/chá nos dias quentes.$r90$,
      $r90$Pergunta sobre horários ('de 3 em 3 horas?') e quanto tempo deixar em cada mama.$r90$,
      $r90$O bebê ganha peso e faz bastante xixi e cocô.$r90$,
      $r90$Pergunta se pode usar chupeta e mamadeira.$r90$
    ),
    $ach90$Cenário de orientação. Pontos: aleitamento materno EXCLUSIVO até 6 meses (sem água/chá), livre demanda, pega correta, esvaziar uma mama antes de oferecer a outra, evitar bicos artificiais; sinais de boa amamentação (ganho de peso, diurese, fezes).$ach90$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alimentacao-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alimentacao-infantil', 'aleitamento-materno')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i90_0$Apresentou-se e avaliou como está a amamentação$i90_0$, 1, 0),
  ($i90_1$Orientou aleitamento materno exclusivo até os 6 meses (sem água/chás)$i90_1$, 3, 1),
  ($i90_2$Orientou livre demanda (sem horários rígidos)$i90_2$, 2, 2),
  ($i90_3$Avaliou/orientou a pega e o posicionamento$i90_3$, 2, 3),
  ($i90_4$Orientou esvaziar uma mama antes de oferecer a outra$i90_4$, 1, 4),
  ($i90_5$Orientou evitar chupeta/mamadeira no início$i90_5$, 1, 5),
  ($i90_6$Reforçou sinais de boa amamentação (peso, diurese, fezes)$i90_6$, 2, 6),
  ($i90_7$Orientou manutenção até 2 anos ou mais (com complementação)$i90_7$, 1, 7),
  ($i90_8$Esclareceu dúvidas e deu suporte$i90_8$, 1, 8),
  ($i90_9$Comunicação acolhedora$i90_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t91$Começando a comida aos 6 meses$t91$,
    $e91$Alimentação infantil$e91$,
    null,
    300,
    $q91$A mãe de um lactente de 6 meses quer saber como iniciar a alimentação complementar.$q91$,
    $res91$Puericultura. A mãe de um lactente de 6 meses quer saber como iniciar
a alimentação complementar. Oriente. ~5 min.$res91$,
    $p91$Mãe de lactente, 6 meses$p91$,
    $ctx91$Mãe quer começar a comida 'do jeito certo'. Faça perguntas.$ctx91$,
    jsonb_build_array(
      $r91$Em aleitamento materno exclusivo; acabou de completar 6 meses.$r91$,
      $r91$Pergunta o que oferecer, qual consistência e quantas vezes ao dia.$r91$,
      $r91$Pergunta se mantém o peito e se pode dar suco.$r91$,
      $r91$Pergunta se pode liquidificar/peneirar tudo e sobre a ordem dos alimentos.$r91$
    ),
    $ach91$Cenário de orientação. Pontos: iniciar aos 6 meses mantendo o leite materno; comida amassada (não liquidificada/peneirada), evoluindo a consistência; variar os grupos alimentares; sem açúcar/sal/mel; evitar sucos; respeitar a aceitação.$ach91$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alimentacao-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alimentacao-infantil', 'alimentacao-primeiro-ano-vida')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i91_0$Apresentou-se e confirmou idade/condições para a introdução$i91_0$, 1, 0),
  ($i91_1$Orientou manter o leite materno junto à alimentação$i91_1$, 2, 1),
  ($i91_2$Orientou consistência adequada (amassada, não liquidificada)$i91_2$, 2, 2),
  ($i91_3$Orientou variedade (cereais/tubérculos, leguminosas, proteína, hortaliças, fruta)$i91_3$, 2, 3),
  ($i91_4$Orientou o número de refeições por dia conforme a idade$i91_4$, 1, 4),
  ($i91_5$Orientou NÃO adicionar açúcar/sal e não dar mel (<1 ano)$i91_5$, 3, 5),
  ($i91_6$Orientou evitar sucos e ultraprocessados$i91_6$, 1, 6),
  ($i91_7$Orientou oferta de água e respeito à aceitação da criança$i91_7$, 1, 7),
  ($i91_8$Orientou segurança/sinais de engasgo$i91_8$, 1, 8),
  ($i91_9$Comunicação didática$i91_9$, 1, 9)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t92$Dor para amamentar$t92$,
    $e92$Alimentação infantil$e92$,
    null,
    300,
    $q92$Mãe de RN de 10 dias com dor e fissura nos mamilos, pensando em desmamar.$q92$,
    $res92$Mãe de RN de 10 dias com dor e fissura nos mamilos, pensando em
desmamar. Avalie e oriente. ~5 min.$res92$,
    $p92$Mãe de RN, 10 dias$p92$,
    $ctx92$Mãe sofrendo com a dor e insegura. Responda ao que for perguntado.$ctx92$,
    jsonb_build_array(
      $r92$Dor intensa ao amamentar; mamilos com fissuras/rachaduras.$r92$,
      $r92$O bebê faz barulho ao mamar e parece pegar só a ponta do mamilo.$r92$,
      $r92$Tem medo de 'leite fraco' e de baixa produção; mamas ficam cheias.$r92$,
      $r92$Está pensando em introduzir mamadeira.$r92$
    ),
    $ach92$Dor/fissura por PEGA INADEQUADA (abocanha só o mamilo). Corrigir a pega resolve a maioria dos casos. 'Leite fraco' é mito; a produção responde à pega e ao esvaziamento frequente. Não há indicação de desmame.$ach92$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alimentacao-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alimentacao-infantil', 'aleitamento-materno')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i92_0$Apresentou-se e acolheu a dificuldade$i92_0$, 1, 0),
  ($i92_1$Avaliou a técnica/pega e o posicionamento$i92_1$, 3, 1),
  ($i92_2$Identificou a pega inadequada como causa da fissura$i92_2$, 3, 2),
  ($i92_3$Corrigiu a pega (boca bem aberta, aréola, queixo no peito)$i92_3$, 2, 3),
  ($i92_4$Desmistificou o 'leite fraco' / baixa produção$i92_4$, 2, 4),
  ($i92_5$Orientou cuidados com os mamilos$i92_5$, 1, 5),
  ($i92_6$Desencorajou o desmame/mamadeira desnecessários$i92_6$, 2, 6),
  ($i92_7$Ofereceu apoio/rede de aleitamento$i92_7$, 1, 7),
  ($i92_8$Comunicação empática e encorajadora$i92_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t93$Quando o peito não é possível$t93$,
    $e93$Alimentação infantil$e93$,
    null,
    300,
    $q93$Lactente de 2 meses cuja mãe precisará usar fórmula.$q93$,
    $res93$Lactente de 2 meses cuja mãe precisará usar fórmula. Oriente o uso e o
preparo corretos da fórmula infantil. ~5 min.$res93$,
    $p93$Mãe de lactente, 2 meses$p93$,
    $ctx93$Mãe vai voltar ao trabalho e está insegura. Responda ao que for perguntado.$ctx93$,
    jsonb_build_array(
      $r93$Vai retornar ao trabalho e não conseguirá amamentar exclusivamente.$r93$,
      $r93$Pergunta qual leite usar e como preparar; pensa em leite de vaca integral.$r93$,
      $r93$Pergunta sobre quantidade, higiene e como diluir.$r93$
    ),
    $ach93$Cenário de orientação. Pontos: incentivar a manutenção do leite materno (ordenha) quando possível; se fórmula, usar fórmula infantil apropriada para a idade (NÃO leite de vaca integral antes de 1 ano), diluição correta, higiene/esterilização e não reaproveitar sobras.$ach93$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alimentacao-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alimentacao-infantil', 'aleitamento-materno')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i93_0$Apresentou-se e explorou o motivo/contexto$i93_0$, 1, 0),
  ($i93_1$Incentivou manter o leite materno (ordenha/estoque) quando possível$i93_1$, 2, 1),
  ($i93_2$Orientou fórmula infantil apropriada para a idade$i93_2$, 2, 2),
  ($i93_3$Desaconselhou leite de vaca integral antes de 1 ano$i93_3$, 3, 3),
  ($i93_4$Orientou diluição/preparo correto conforme o produto$i93_4$, 2, 4),
  ($i93_5$Orientou higiene e esterilização dos utensílios$i93_5$, 2, 5),
  ($i93_6$Orientou não reaproveitar sobras e o armazenamento$i93_6$, 1, 6),
  ($i93_7$Orientou oferta (quantidade/frequência aproximada)$i93_7$, 1, 7),
  ($i93_8$Comunicação sem julgamento$i93_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t94$Mitos e erros na alimentação do bebê$t94$,
    $e94$Alimentação infantil$e94$,
    null,
    300,
    $q94$Lactente de 8 meses cuja família relata a dieta atual.$q94$,
    $res94$Lactente de 8 meses cuja família relata a dieta atual. Identifique os
erros alimentares comuns e oriente. ~5 min.$res94$,
    $p94$Avó de lactente, 8 meses$p94$,
    $ctx94$Avó cuida do bebê e segue 'o que sempre fez'. Responda ao que for perguntado.$ctx94$,
    jsonb_build_array(
      $r94$Dá mel 'para a tosse'; oferece leite de vaca integral; põe açúcar no mingau.$r94$,
      $r94$Dá suco de caixinha, refrigerante e bolacha recheada.$r94$,
      $r94$A comida é sempre peneirada/liquidificada; usa mamadeira com engrossante.$r94$,
      $r94$O bebê come pouca comida 'de verdade'.$r94$
    ),
    $ach94$Vários erros: mel <1 ano (risco de botulismo), leite de vaca integral precoce, açúcar e ultraprocessados (<2 anos) e alimentos sempre liquidificados. Corrigir conforme o Guia Alimentar para crianças <2 anos.$ach94$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alimentacao-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alimentacao-infantil', 'alimentacao-primeiro-ano-vida')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i94_0$Apresentou-se e fez um recordatório da alimentação$i94_0$, 2, 0),
  ($i94_1$Identificou o uso de MEL antes de 1 ano (risco de botulismo)$i94_1$, 3, 1),
  ($i94_2$Identificou o leite de vaca integral precoce como inadequado$i94_2$, 2, 2),
  ($i94_3$Identificou açúcar e ultraprocessados como inadequados (<2 anos)$i94_3$, 3, 3),
  ($i94_4$Orientou consistência adequada (amassada, não liquidificada)$i94_4$, 2, 4),
  ($i94_5$Reforçou alimentos in natura e variedade$i94_5$, 2, 5),
  ($i94_6$Orientou manter o leite materno e oferecer água$i94_6$, 1, 6),
  ($i94_7$Pactuou mudanças realistas com a família$i94_7$, 1, 7),
  ($i94_8$Comunicação didática, sem culpabilizar$i94_8$, 1, 8)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t95$Como evoluir a consistência da comida do bebê?$t95$,
    $e95$Alimentação infantil$e95$,
    null,
    300,
    $q95$Mãe de bebê de 8 meses pergunta se já pode parar de amassar a comida e oferecer pedaços.$q95$,
    $res95$Puericultura. Mãe de bebê de 8 meses pergunta se já pode parar de
amassar a comida e oferecer pedaços. Oriente a progressão da consistência
alimentar no primeiro ano. ~5 min.$res95$,
    $p95$Mãe de lactente, 8 meses$p95$,
    $ctx95$Mãe insegura sobre quando avançar a textura dos alimentos.$ctx95$,
    jsonb_build_array(
      $r95$Iniciou alimentação complementar aos 6 meses com frutas amassadas e, depois, a primeira refeição principal.$r95$,
      $r95$Hoje oferece 2 refeições principais, ainda bem amassadas/passadas no liquidificador, por medo de engasgo.$r95$,
      $r95$Pergunta se já pode oferecer pedacinhos ou se deve continuar amassando por mais tempo.$r95$,
      $r95$Bebê já senta bem com apoio, leva objetos à boca, mastiga a gengiva.$r95$
    ),
    $ach95$Progressão esperada de consistência: aos 6 meses, frutas amassadas e início da 1ª refeição principal; aos 7 meses, alimentos amassados/papa espessa; aos 8 meses (idade do caso), já se espera oferecer 2 refeições principais com consistência um pouco menos lisa, evoluindo para pequenos pedaços conforme a tolerância; aos 9 meses, consistência mais próxima da família; aos 12 meses, alimentação da família. Uso rotineiro de liquidificador/peneira deve ser evitado, pois atrasa o desenvolvimento da mastigação.$ach95$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alimentacao-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alimentacao-infantil', 'alimentacao-primeiro-ano-vida')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i95_0$Revisou a história alimentar desde os 6 meses$i95_0$, 1, 0),
  ($i95_1$Avaliou sinais de prontidão para evolução da textura (mastigação, sentar)$i95_1$, 2, 1),
  ($i95_2$Orientou a progressão esperada de consistência por idade$i95_2$, 3, 2),
  ($i95_3$Desencorajou o uso rotineiro de liquidificador/peneira$i95_3$, 2, 3),
  ($i95_4$Tranquilizou sobre o medo de engasgo com orientação de segurança$i95_4$, 2, 4),
  ($i95_5$Relacionou a evolução da textura ao desenvolvimento da mastigação$i95_5$, 1, 5),
  ($i95_6$Comunicação acolhedora e didática$i95_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t96$'Ele cospe tudo que é diferente'$t96$,
    $e96$Alimentação infantil$e96$,
    null,
    300,
    $q96$Mãe de criança de 2 anos relata que ele recusa qualquer alimento novo, "cospe e chora".$q96$,
    $res96$Ambulatório. Mãe de criança de 2 anos relata que ele recusa qualquer
alimento novo, "cospe e chora". Oriente sobre a neofobia alimentar. ~5 min.$res96$,
    $p96$Mãe de criança de 2 anos$p96$,
    $ctx96$Mãe desanimada, já desistiu de oferecer alimentos novos.$ctx96$,
    jsonb_build_array(
      $r96$Toda vez que oferece um alimento novo, a criança recusa, cospe ou chora.$r96$,
      $r96$Mãe já desistiu de oferecer de novo depois da 2ª ou 3ª tentativa.$r96$,
      $r96$Criança come bem os mesmos 4-5 alimentos repetidos todos os dias.$r96$,
      $r96$Crescimento e desenvolvimento adequados; sem sinais de alarme nutricional.$r96$,
      $r96$Pergunta se isso é 'normal' ou se já é um problema sério.$r96$
    ),
    $ach96$Neofobia alimentar é uma fase esperada do desenvolvimento, comum entre 18 meses e 6 anos, caracterizada pela recusa inicial de alimentos novos. Pode ser necessário oferecer o mesmo alimento novo repetidamente — em torno de 8 a 15 exposições — antes que a criança o aceite. Insistir sem forçar, oferecer junto a alimentos já aceitos, e dar o exemplo à mesa são estratégias úteis. Desistir após poucas tentativas perpetua a seletividade.$ach96$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alimentacao-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alimentacao-infantil', 'alimentacao-primeiro-ano-vida')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i96_0$Caracterizou o padrão de recusa e o repertório alimentar atual$i96_0$, 2, 0),
  ($i96_1$Avaliou crescimento/desenvolvimento para descartar repercussão nutricional$i96_1$, 2, 1),
  ($i96_2$Reconheceu a neofobia alimentar como fase esperada do desenvolvimento$i96_2$, 3, 2),
  ($i96_3$Orientou a necessidade de múltiplas exposições (~8-15 vezes)$i96_3$, 3, 3),
  ($i96_4$Orientou não forçar, mas insistir de forma positiva e repetida$i96_4$, 2, 4),
  ($i96_5$Reforçou o exemplo alimentar dos pais/família$i96_5$, 1, 5),
  ($i96_6$Comunicação encorajadora, sem culpabilizar a mãe$i96_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t97$Pode dar mel para ajudar a tosse do bebê?$t97$,
    $e97$Alimentação infantil$e97$,
    null,
    300,
    $q97$Mãe de bebê de 8 meses com resfriado pergunta se pode dar mel para "aliviar a tosse" e se pode adoçar as frutas.$q97$,
    $res97$Ambulatório. Mãe de bebê de 8 meses com resfriado pergunta se pode
dar mel para "aliviar a tosse" e se pode adoçar as frutas. Oriente sobre os
riscos do mel e do açúcar antes de determinadas idades. ~5 min.$res97$,
    $p97$Mãe de lactente, 8 meses$p97$,
    $ctx97$Mãe ouviu de familiares que mel 'é natural e ajuda a tosse'.$ctx97$,
    jsonb_build_array(
      $r97$Bebê com tosse e coriza há 2 dias, por resfriado comum.$r97$,
      $r97$Avó sugeriu dar uma colherzinha de mel para 'aliviar a tosse'.$r97$,
      $r97$Mãe também pergunta se pode colocar açúcar nas frutas/papas porque o bebê 'faz careta de amargo'.$r97$,
      $r97$Sem outras queixas; bebê mamando e se alimentando bem, apesar do resfriado.$r97$
    ),
    $ach97$Mel está CONTRAINDICADO antes de 1 ano de idade pelo risco de botulismo infantil (esporos de Clostridium botulinum). Açúcar adicionado deve ser evitado antes dos 2 anos de idade, mesmo para 'adoçar' ou disfarçar sabores — favorece preferência por sabor doce e excesso calórico. Para tosse de resfriado comum, priorizar medidas de conforto (hidratação, lavagem nasal); analgésicos/antitérmicos apenas se necessário e conforme orientação médica.$ach97$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alimentacao-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alimentacao-infantil', 'alimentacao-primeiro-ano-vida')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i97_0$Contraindicou explicitamente o mel antes de 1 ano$i97_0$, 3, 0),
  ($i97_1$Explicou o risco específico (botulismo infantil)$i97_1$, 3, 1),
  ($i97_2$Contraindicou açúcar adicionado antes dos 2 anos$i97_2$, 2, 2),
  ($i97_3$Orientou medidas de conforto adequadas para o resfriado$i97_3$, 1, 3),
  ($i97_4$Acolheu a sugestão familiar sem desqualificar a avó$i97_4$, 1, 4),
  ($i97_5$Comunicação clara e didática sobre os riscos$i97_5$, 1, 5)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t98$Quais alimentos evitar pelo risco de engasgo?$t98$,
    $e98$Alimentação infantil$e98$,
    null,
    300,
    $q98$Pais de bebê de 9 meses, que iniciaram a oferta de pedaços de alimento, perguntam quais alimentos devem ser evitados pelo risco de engasgo/sufocação.$q98$,
    $res98$Puericultura. Pais de bebê de 9 meses, que iniciaram a oferta de
pedaços de alimento, perguntam quais alimentos devem ser evitados pelo risco
de engasgo/sufocação. ~5 min.$res98$,
    $p98$Pais de lactente, 9 meses$p98$,
    $ctx98$Pais interessados em oferecer mais variedade de texturas com segurança.$ctx98$,
    jsonb_build_array(
      $r98$Já oferecem pedaços pequenos de alimentos macios (banana, batata cozida).$r98$,
      $r98$Perguntam se podem oferecer uva inteira, balas, pipoca, ou pedaços de cenoura crua.$r98$,
      $r98$Perguntam também sobre castanhas e amendoim inteiros.$r98$,
      $r98$Bebê já tem alguns dentes, mastiga a gengiva e leva objetos à boca.$r98$
    ),
    $ach98$Alimentos de alto risco de engasgo/sufocação em lactentes e crianças pequenas: uva inteira, balas/doces duros, pipoca, pedaços de cenoura/maçã crua não ralados, salsicha/linguiça em rodelas, castanhas e amendoim inteiros (também risco de aspiração e alergia). Devem ser oferecidos picados em pedaços pequenos, ralados/cozidos até ficarem macios, ou evitados na forma íntegra até idade mais avançada (geralmente após os 4 anos para os itens mais duros/redondos).$ach98$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alimentacao-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alimentacao-infantil', 'alimentacao-primeiro-ano-vida')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i98_0$Avaliou a habilidade motora oral atual do bebê$i98_0$, 1, 0),
  ($i98_1$Identificou corretamente os alimentos de alto risco de engasgo$i98_1$, 3, 1),
  ($i98_2$Orientou formas seguras de oferecer alimentos de risco (picado, ralado, cozido)$i98_2$, 3, 2),
  ($i98_3$Orientou supervisão constante durante as refeições$i98_3$, 2, 3),
  ($i98_4$Orientou evitar alimentos íntegros de alto risco até idade mais avançada$i98_4$, 2, 4),
  ($i98_5$Comunicação clara e prática$i98_5$, 1, 5)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t99$Quanto o bebê deveria comer nessa idade?$t99$,
    $e99$Alimentação infantil$e99$,
    null,
    300,
    $q99$Mãe de bebê de 9 meses preocupada que ele "come muito pouco" em comparação a outros bebês.$q99$,
    $res99$Puericultura. Mãe de bebê de 9 meses preocupada que ele "come muito
pouco" em comparação a outros bebês. Oriente sobre os volumes e número de
refeições esperados. ~5 min.$res99$,
    $p99$Mãe de lactente, 9 meses$p99$,
    $ctx99$Mãe compara com sobrinho de mesma idade que 'come muito mais'.$ctx99$,
    jsonb_build_array(
      $r99$Bebê faz 2 refeições principais por dia, com volume de aproximadamente 150-170 mL cada.$r99$,
      $r99$Continua em aleitamento materno, com boa frequência de mamadas.$r99$,
      $r99$Curva de crescimento e ganho de peso adequados desde o nascimento.$r99$,
      $r99$Pergunta se o volume está 'baixo' para a idade.$r99$
    ),
    $ach99$Volumes esperados por idade nas refeições principais: aos 8 meses, em torno de 150 mL; aos 9 meses, em torno de 175 mL, evoluindo para porções próximas de 250 mL por volta de 12 meses, sempre considerando que cada criança tem variação individual e que o crescimento adequado é o melhor parâmetro de suficiência alimentar — não a comparação direta entre crianças.$ach99$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alimentacao-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alimentacao-infantil', 'alimentacao-primeiro-ano-vida')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i99_0$Quantificou o volume e o número de refeições principais atuais$i99_0$, 2, 0),
  ($i99_1$Avaliou o crescimento/curva de peso como parâmetro central$i99_1$, 3, 1),
  ($i99_2$Informou o volume esperado para a idade (~175 mL aos 9 meses)$i99_2$, 2, 2),
  ($i99_3$Desencorajou a comparação direta com outras crianças$i99_3$, 2, 3),
  ($i99_4$Reforçou a manutenção do aleitamento materno$i99_4$, 1, 4),
  ($i99_5$Comunicação tranquilizadora$i99_5$, 1, 5)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t150$Sinais de prontidão para a introdução alimentar$t150$,
    $e150$Pediatria geral$e150$,
    null,
    300,
    $q150$Lactente de 6 meses; a mãe quer iniciar alimentos.$q150$,
    $res150$Lactente de 6 meses; a mãe quer iniciar alimentos. Avalie a prontidão e oriente o início.
~5 min.$res150$,
    $p150$Mãe de lactente de 6 meses$p150$,
    $ctx150$Mãe quer começar 'as papinhas'. Responda só ao que for perguntado.$ctx150$,
    jsonb_build_array(
      $r150$Sustenta a cabeça e o tronco e senta com pouco apoio.$r150$,
      $r150$Mostra interesse pela comida e leva objetos à boca.$r150$,
      $r150$Mama no peito; perguntam se já pode água.$r150$,
      $r150$Quer saber como começar.$r150$
    ),
    $ach150$Sinais de prontidão presentes (sustentação de cabeça/tronco, reflexo de protrusão reduzido, interesse alimentar) aos 6 meses.$ach150$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alimentacao-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alimentacao-infantil', 'alimentacao-primeiro-ano-vida')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i150_0$Apresentou-se e identificou criança/responsável$i150_0$, 1, 0),
  ($i150_1$Avaliou sinais de prontidão (cabeça/tronco, sentar, protrusão, interesse)$i150_1$, 3, 1),
  ($i150_2$Orientou início aos 6 meses mantendo amamentação$i150_2$, 2, 2),
  ($i150_3$Orientou oferta de frutas amassadas/raspadas em colher$i150_3$, 2, 3),
  ($i150_4$Orientou início de água a partir dos 6 meses$i150_4$, 1, 4),
  ($i150_5$Orientou evitar liquidificador/peneira de rotina$i150_5$, 1, 5),
  ($i150_6$Comunicação clara$i150_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t151$Progressão da alimentação aos 8–9 meses$t151$,
    $e151$Pediatria geral$e151$,
    null,
    300,
    $q151$Lactente de 8 meses já comendo papas; a mãe pergunta sobre consistência e volume.$q151$,
    $res151$Lactente de 8 meses já comendo papas; a mãe pergunta sobre consistência e volume.
Oriente a progressão. ~5 min.$res151$,
    $p151$Mãe de lactente de 8 meses$p151$,
    $ctx151$Mãe quer ajustar a alimentação. Responda só ao que for perguntado.$ctx151$,
    jsonb_build_array(
      $r151$Come papa amassada uma vez ao dia; ainda passa tudo no liquidificador.$r151$,
      $r151$Mama no peito e está ganhando peso.$r151$,
      $r151$Pergunta quantas refeições e que quantidade oferecer.$r151$,
      $r151$Quer saber quando engrossar a comida.$r151$
    ),
    $ach151$Lactente saudável; dieta ainda liquidificada e em volume/numero de refeições abaixo do recomendado para a idade.$ach151$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alimentacao-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alimentacao-infantil', 'alimentacao-primeiro-ano-vida')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i151_0$Apresentou-se e identificou criança/responsável$i151_0$, 1, 0),
  ($i151_1$Orientou evoluir consistência (amassada com garfo, não liquidificar)$i151_1$, 3, 1),
  ($i151_2$Orientou número de refeições principais (cerca de 2/dia aos 8 meses)$i151_2$, 2, 2),
  ($i151_3$Orientou volume aproximado (até ~2/3 de xícara / 150 mL)$i151_3$, 2, 3),
  ($i151_4$Reforçou variedade (cereais, feijões, legumes, carnes, ovo, frutas)$i151_4$, 1, 4),
  ($i151_5$Manteve amamentação e respeito à fome/saciedade$i151_5$, 1, 5),
  ($i151_6$Comunicação clara$i151_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t152$Alimentos a evitar no primeiro/segundo ano$t152$,
    $e152$Pediatria geral$e152$,
    null,
    300,
    $q152$Lactente de 9 meses; a família oferece mel, suco e ultraprocessados.$q152$,
    $res152$Lactente de 9 meses; a família oferece mel, suco e ultraprocessados.
Corrija erros alimentares e oriente. ~5 min.$res152$,
    $p152$Avó de lactente de 9 meses$p152$,
    $ctx152$Avó cuidadora, com hábitos antigos. Responda só ao que for perguntado.$ctx152$,
    jsonb_build_array(
      $r152$Dá uma colherzinha de mel 'para a tosse'.$r152$,
      $r152$Oferece suco e às vezes refrigerante e bolacha recheada.$r152$,
      $r152$Adoça a comida com açúcar.$r152$,
      $r152$Pergunta o que pode e o que não pode nessa idade.$r152$
    ),
    $ach152$Oferta inadequada: mel no 1º ano, açúcar antes dos 2 anos, sucos/ultraprocessados; necessidade de orientação.$ach152$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alimentacao-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alimentacao-infantil', 'alimentacao-primeiro-ano-vida')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i152_0$Apresentou-se e acolheu a cuidadora$i152_0$, 1, 0),
  ($i152_1$Orientou não oferecer mel no primeiro ano (risco de botulismo)$i152_1$, 3, 1),
  ($i152_2$Orientou não oferecer açúcar antes dos 2 anos$i152_2$, 2, 2),
  ($i152_3$Orientou evitar sucos, refrigerantes e ultraprocessados$i152_3$, 2, 3),
  ($i152_4$Alertou sobre alimentos com risco de aspiração (ex.: pipoca)$i152_4$, 1, 4),
  ($i152_5$Reforçou água e alimentos in natura/variados$i152_5$, 1, 5),
  ($i152_6$Comunicação respeitosa, sem culpabilizar$i152_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t153$Manter aleitamento exclusivo aos 5 meses$t153$,
    $e153$Pediatria geral$e153$,
    null,
    300,
    $q153$Lactente de 5 meses; a mãe quer iniciar comida e água por pressão da família.$q153$,
    $res153$Lactente de 5 meses; a mãe quer iniciar comida e água por pressão da família.
Oriente conforme as recomendações. ~5 min.$res153$,
    $p153$Mãe de lactente de 5 meses$p153$,
    $ctx153$Mãe em dúvida com palpites da família. Responda só ao que for perguntado.$ctx153$,
    jsonb_build_array(
      $r153$Está em aleitamento materno exclusivo e o bebê ganha peso bem.$r153$,
      $r153$A família diz que 'só leite é fraco' e manda dar água e papa.$r153$,
      $r153$Não há indicação médica para complementar.$r153$,
      $r153$Pergunta se deve começar agora.$r153$
    ),
    $ach153$Lactente saudável, ganho de peso adequado, em AME, sem indicação individual de antecipar a complementação.$ach153$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alimentacao-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alimentacao-infantil', 'aleitamento-materno')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i153_0$Apresentou-se e identificou criança/responsável$i153_0$, 1, 0),
  ($i153_1$Reforçou aleitamento materno exclusivo até os 6 meses$i153_1$, 3, 1),
  ($i153_2$Explicou que não há necessidade de água no AME$i153_2$, 2, 2),
  ($i153_3$Confirmou bom ganho de peso e ausência de indicação para antecipar$i153_3$, 2, 3),
  ($i153_4$Orientou iniciar complementação aos 6 meses$i153_4$, 2, 4),
  ($i153_5$Acolheu pressões familiares e empoderou a mãe$i153_5$, 1, 5),
  ($i153_6$Comunicação empática$i153_6$, 1, 6)
) as v(texto, grav, ord);

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $t154$Recusa alimentar e neofobia$t154$,
    $e154$Pediatria geral$e154$,
    null,
    300,
    $q154$Pré-escolar de 2 anos que recusa alimentos novos. A mãe está preocupada e força a comida.$q154$,
    $res154$Pré-escolar de 2 anos que recusa alimentos novos. A mãe está preocupada e força a comida.
Oriente o manejo. ~5 min.$res154$,
    $p154$Mãe de pré-escolar de 2 anos$p154$,
    $ctx154$Mãe ansiosa com a recusa. Responda só ao que for perguntado.$ctx154$,
    jsonb_build_array(
      $r154$Rejeita alimentos novos, principalmente verduras, na primeira oferta.$r154$,
      $r154$A mãe insiste, brigando e às vezes usando tela para 'enganar'.$r154$,
      $r154$A criança cresce bem e come outros alimentos.$r154$,
      $r154$Pergunta se precisa de vitamina/suplemento.$r154$
    ),
    $ach154$Crescimento adequado; recusa de alimentos novos (neofobia esperada); estratégias inadequadas (forçar, telas).$ach154$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, (c.slug = 'alimentacao-infantil')
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
   and c.slug in ('alimentacao-infantil', 'alimentacao-primeiro-ano-vida')
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i154_0$Apresentou-se e identificou criança/responsável$i154_0$, 1, 0),
  ($i154_1$Confirmou crescimento adequado e variedade aceita$i154_1$, 2, 1),
  ($i154_2$Reconheceu a neofobia como fase esperada$i154_2$, 3, 2),
  ($i154_3$Orientou ofertas repetidas (até ~15 vezes) sem forçar$i154_3$, 2, 3),
  ($i154_4$Orientou refeição como momento positivo e sem telas$i154_4$, 2, 4),
  ($i154_5$Respeitou sinais de fome e saciedade$i154_5$, 1, 5),
  ($i154_6$Comunicação empática, reduzindo a ansiedade materna$i154_6$, 1, 6)
) as v(texto, grav, ord);
