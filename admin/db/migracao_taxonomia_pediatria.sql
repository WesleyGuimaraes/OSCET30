-- Ajustes na taxonomia de Pediatria 6º antes de migrar as 165 estações do
-- antigo cases.js. Rodar ANTES de qualquer casos_pediatria_*.sql.

-- 1) Corrige o typo no slug de icterícia (icutericia -> ictericia).
update conteudos
set slug = 'ictericia-neonatal'
where disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
  and slug = 'icutericia-neonatal';

-- 2) Novos conteúdos que não tinham equivalente na taxonomia atual.
insert into conteudos (disciplina_periodo_id, nome, slug, ordem, ativo)
select 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90', v.nome, v.slug, v.ordem, true
from (values
  ('Marcos do desenvolvimento infantil', 'marcos-desenvolvimento-infantil', 100),
  ('Exame físico do recém-nascido', 'exame-fisico-recem-nascido', 101),
  ('Alimentação infantil', 'alimentacao-infantil', 102),
  ('Alimentação no primeiro ano de vida', 'alimentacao-primeiro-ano-vida', 103)
) as v(nome, slug, ordem)
where not exists (
  select 1 from conteudos c
  where c.disciplina_periodo_id = 'd5403a68-35f9-4e19-9fe8-edc1c0a80c90'
    and c.slug = v.slug
);
