/* Lógica de dedup para customers
Regra: duplicado se [company name + contact name] forem iguais */

/* Passo 1 : cria coluna 'result' que repete 
o customer_id para os casos duplicados. Os valores repetidos nessa col são duplicados */
with markup as ( /* criando uma CTE*/
    SELECT *
        ,first_value(customer_id) /*mostrar o customer_id dos duplicados primeiro*/
        OVER (
            PARTITION BY company_name
            ,contact_name /* particionando pelas colunas informadas que indicam dup*/
            ORDER BY company_name /*ordenamento opcional*/
            rows BETWEEN unbounded preceding
                AND unbounded following
            ) AS result /* unbounded para mostrar todos (da primeira até ultima duplicata)*/
    FROM {{source('sources', 'customers') }} /* 'sources' [nome da source] e 'customers' [nome da tabela] definidos no source.yml*/
)

/* Passo 2 : pegar os customer_id dos deduplicados*/
, removed as (
    select distinct result from markup
)

/* Passo 3 : Trazer todas as informações dos clientes deduplicados para montar uma tabela final*/
, final as (
   SELECT *
   FROM {{source('sources', 'customers') }}
   WHERE customer_id IN (
		SELECT result
		FROM removed
		)
)

select * from final /* resultado da dedup*/
