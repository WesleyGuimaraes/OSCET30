-- =====================================================================
--  OSCET30 — SEED: banco de itens de checklist reutilizáveis
--
--  Popula checklist_itens_base com itens genéricos de OSCE que podem ser
--  plugados em qualquer caso pelo editor (botão "Banco de itens"). Rode no
--  SQL Editor do Supabase. Idempotente: não duplica se rodar de novo.
-- =====================================================================

insert into checklist_itens_base (texto, categoria, gravidade_padrao)
select v.texto, v.categoria, v.gravidade_padrao
from (values
  ('Apresentou-se e identificou o paciente/responsável',            'abertura',     2),
  ('Higienizou as mãos antes do exame',                             'exame físico', 2),
  ('Investigou início, duração e evolução da queixa',               'anamnese',     4),
  ('Caracterizou a queixa principal (localização, intensidade)',    'anamnese',     4),
  ('Pesquisou fatores de melhora e piora',                          'anamnese',     3),
  ('Questionou sintomas associados',                                'anamnese',     3),
  ('Investigou antecedentes pessoais e familiares',                 'anamnese',     3),
  ('Verificou histórico de medicações e alergias',                  'anamnese',     2),
  ('Pesquisou sinais de alarme pertinentes à queixa',               'anamnese',     5),
  ('Solicitou e interpretou os sinais vitais',                      'exame físico', 4),
  ('Realizou exame físico direcionado à queixa',                    'exame físico', 4),
  ('Levantou hipótese diagnóstica coerente',                        'raciocínio',   4),
  ('Solicitou exames complementares pertinentes',                   'raciocínio',   3),
  ('Explicou a hipótese diagnóstica em linguagem acessível',        'comunicação',  3),
  ('Definiu conduta e orientou sinais de alarme / retorno',         'conduta',      4),
  ('Verificou entendimento e abriu espaço para dúvidas',            'comunicação',  2),
  ('Comunicação empática, sem alarmar desnecessariamente',          'comunicação',  2)
) as v(texto, categoria, gravidade_padrao)
where not exists (
  select 1 from checklist_itens_base b where b.texto = v.texto
);
