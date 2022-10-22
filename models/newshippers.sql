/*
Criar e usar Seeds
	- Se há infos que você precisa para o seu pipeline e ela não está no source, ela pode ser add no seu pipeline
	como arquivo CSV.
	- faz upload desse arquivo CSV para o projeto, a seed vai transformar o csv em tabela no schema do seu pipeline,
	que pode ser usada como ref no dbt
	- Colocar o csv na pasta 'seeds' ja existente na raiz do projeto e então rodar comando 'dbt seed' para ativar o seed.

*/

-- Adicionar o info de email do csv shippers_email já dentro da pasta seed para os shippers.
SELECT sh.*
,se.shipper_email  --definido cols pq tinha duplicado em shipper_email
FROM {{source('sources', 'shippers') }} sh
LEFT JOIN {{ref('shippers_emails')}} se
	ON (sh.shipper_id = se.shipper_id)


-- voltando no redshift, essa table terá as info dos shippers e a nova info dos emails do csv externo
