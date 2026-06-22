-- Remove os casos de teste criados durante o desenvolvimento do pipeline/painel.
-- Rode o SELECT primeiro e confira a lista antes de rodar o DELETE.

-- 1) Prévia: confira que são só esses os casos de teste antes de apagar.
--    Se houver outro caso de teste que você fez manualmente no editor e o
--    título dele não aparecer aqui, adicione na lista de títulos abaixo.
select id, titulo, status, criado_em
from casos
where titulo in (
  'Cefaleia súbita intensa — suspeita de hemorragia subaracnoidea',
  'evfradsc'
)
or titulo ilike '%teste%';

-- 2) Depois de confirmar a lista acima, rode o bloco abaixo para apagar.
with alvo as (
  select id from casos
  where titulo in (
    'Cefaleia súbita intensa — suspeita de hemorragia subaracnoidea',
    'evfradsc'
  )
  or titulo ilike '%teste%'
)
delete from caso_checklist_itens where caso_id in (select id from alvo);

with alvo as (
  select id from casos
  where titulo in (
    'Cefaleia súbita intensa — suspeita de hemorragia subaracnoidea',
    'evfradsc'
  )
  or titulo ilike '%teste%'
)
delete from caso_conteudo where caso_id in (select id from alvo);

with alvo as (
  select id from casos
  where titulo in (
    'Cefaleia súbita intensa — suspeita de hemorragia subaracnoidea',
    'evfradsc'
  )
  or titulo ilike '%teste%'
)
delete from casos_historico where caso_id in (select id from alvo);

delete from casos
where titulo in (
  'Cefaleia súbita intensa — suspeita de hemorragia subaracnoidea',
  'evfradsc'
)
or titulo ilike '%teste%';
