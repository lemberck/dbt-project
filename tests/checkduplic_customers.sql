/*
Executando teste na pipeline.
No exemplo, checar se os customers realmente foram deduplicados por uma lógica.
Testes são scripts sql que por default ficam na pasta 'test', onde o dbt vai buscar para ver o resultado.
Logica : na tabela customer já transformada (usar 'ref'), agrupar pelas cols de dedup e então fazer a contagem.
Se contagem >1 , falha no teste. Se =1, passa no teste.
*/

SELECT count(*) count
	,company_name
	,contact_name
FROM {{ref('customers') }} --tab já transformada
--FROM {{source('sources','customers')}} --tab de origem, só para ver o teste falhar
GROUP BY company_name
	,contact_name
HAVING count > 1 -- só retorna se contagem > 1 (test fail condition)

/*
rodar o comando 'dbt test' . Se 'pass', passou no teste.
Se 'fail', o log vai mostrar quantos registros falharam no teste.
*/