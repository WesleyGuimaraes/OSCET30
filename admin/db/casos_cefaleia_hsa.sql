-- Caso de teste do pipeline de autoria (Claude -> revisor).
-- Conteúdo "Cefaleia" já existe em Clínica Médica, então resolvemos o
-- conteúdo direto pelo disciplina_periodo_id (visto via REST com a chave
-- publishable) em vez de por slug de disciplina/período.

with novo as (
  insert into casos
    (titulo, especialidade, subtipo, tempo_segundos, queixa_principal, resumo,
     personagem, contexto, roteiro, exames_achados, status, criado_por)
  values (
    $c$Cefaleia súbita intensa — suspeita de hemorragia subaracnoidea$c$,
    $c$Clínica Médica$c$,
    null,
    420,
    $c$Dor de cabeça muito forte iniciada há 2 horas.$c$,
    $c$Paciente feminina, 52 anos, comparece ao pronto-socorro relatando cefaleia de início súbito há aproximadamente 2 horas. Refere que a dor começou abruptamente enquanto assistia televisão, atingindo intensidade máxima em poucos segundos. Descreve a dor como a pior dor de cabeça da vida.
Associado ao quadro, apresenta náuseas, um episódio de vômito e fotofobia. Nega trauma recente. Possui antecedentes de hipertensão arterial sistêmica em tratamento irregular e tabagismo há 30 anos.

Você é o médico responsável pelo atendimento inicial no pronto-socorro.
Durante os próximos 7 minutos:
1. Realize anamnese dirigida para investigação da cefaleia.
2. Solicite os principais elementos do exame físico pertinentes ao caso.
3. Identifique sinais de alarme.
4. Apresente sua principal hipótese diagnóstica.
5. Informe quais exames complementares devem ser solicitados inicialmente.
6. Explique a conduta inicial adequada para esta paciente.$c$,
    $c$Maria Aparecida Santos, 52 anos, hipertensa em tratamento irregular, tabagista há 30 anos. Pai teve um "derrame" em idade avançada. Nunca apresentou episódio semelhante antes.$c$,
    $c$Demonstra preocupação e desconforto importante por causa da dor; colaborativa, responde ao que for perguntado.$c$,
    jsonb_build_array(
      $c$A dor começou de forma súbita há 2 horas, enquanto eu assistia televisão, e ficou muito forte em poucos segundos.$c$,
      $c$É a pior dor de cabeça que já senti na vida. É forte, difusa e não para desde que começou.$c$,
      $c$Tive náusea e vomitei uma vez. A luz está incomodando muito (fotofobia).$c$,
      $c$Nunca tive uma dor de cabeça assim antes.$c$,
      $c$Não bati a cabeça, não tive febre, não convulsionei e não perdi a consciência.$c$,
      $c$Não notei fraqueza, alteração na fala nem formigamento em nenhum lado do corpo.$c$,
      $c$Tenho pressão alta, mas confesso que tomo o remédio de forma irregular.$c$,
      $c$Fumo há cerca de 30 anos.$c$,
      $c$Meu pai teve um derrame quando já estava mais velho.$c$
    ),
    $c$Regular estado geral, consciente, orientada em tempo e espaço, Glasgow 15, com fácies de dor.
Sinais vitais: PA 180/100 mmHg; FC 88 bpm; FR 18 irpm; SatO2 98% em ar ambiente; Tax 36,7°C.
Exame neurológico: sem déficits motores ou sensitivos focais; linguagem preservada; pupilas isocóricas e fotorreagentes; rigidez de nuca presente.$c$,
    'em_revisao',
    (select id from usuarios_admin where role = 'owner' order by criado_em limit 1)
  )
  returning id
),
cont as (
  insert into caso_conteudo (caso_id, conteudo_id, principal)
  select n.id, c.id, true
  from novo n
  join conteudos c
    on c.disciplina_periodo_id = '875d2403-6b6a-4d81-bef6-e0f3698e0009'
   and c.slug = 'cefaleia'
)
insert into caso_checklist_itens (caso_id, texto_especifico, gravidade, ordem)
select n.id, v.texto, v.grav, v.ord
from novo n,
(values
  ($i$Apresenta-se, confirma a identificação da paciente e mantém postura cordial durante todo o atendimento$i$, 1, 0),
  ($i$Demonstra empatia, acolhimento e respeito às queixas e preocupações da paciente$i$, 2, 1),
  ($i$Obtém adequadamente a história da doença atual, caracterizando a cefaleia (início, intensidade, evolução e fatores associados)$i$, 4, 2),
  ($i$Investiga sintomas associados e sinais de alarme para cefaleia secundária (náuseas, vômitos, alteração do nível de consciência, déficits neurológicos, rigidez de nuca etc.)$i$, 5, 3),
  ($i$Pesquisa antecedentes relevantes e fatores de risco para doença cerebrovascular (HAS, tabagismo, uso de medicamentos, história familiar de aneurisma)$i$, 3, 4),
  ($i$Solicita ou realiza exame físico direcionado, incluindo avaliação neurológica, nível de consciência, sinais meníngeos e sinais vitais$i$, 4, 5),
  ($i$Reconhece a gravidade do quadro e interpreta adequadamente os achados clínicos$i$, 4, 6),
  ($i$Formula como principal hipótese diagnóstica Hemorragia Subaracnoidea (HSA)$i$, 5, 7),
  ($i$Solicita exames complementares apropriados: TC de crânio sem contraste como exame inicial, seguida de angiotomografia cerebral e/ou punção lombar caso indicada$i$, 4, 8),
  ($i$Propõe conduta inicial adequada: monitorização, analgesia, controle pressórico, avaliação neurocirúrgica e internação em unidade de alta complexidade, explicando os próximos passos à paciente em linguagem clara$i$, 4, 9)
) as v(texto, grav, ord);
