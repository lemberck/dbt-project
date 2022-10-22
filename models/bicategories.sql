/*
Variáveis 
	- substituídas a medida que o pipeline vai sendo executado
	- Criar no arquivo de configuração yml padrão do projeto
		- exemplo 
			vars:
  			  category: Seafood
	- Na definição, pode atribuir um valor para ela (como acima) ou em tempo de execução.
	- ex de uso : filtragem dinâmica

*/

-- Faça filtro dinâmico da table 'joins' para filtrar pela categoria Seafood (definida na atribuição no config)
select * 
from {{ref('joins')}}
where category_name = '{{var('category')}}' -- colocar entre aspas para dbt entender q é texto, não coluna

-- ao rodar o modelo, no redshift terá uma view do join filtrado pelo padrão definido na variável (Seafood)

/*
Para passar um outro valor à variável, fazer na linha de comando:
    dbt run --select bicategories --vars 'nomeVariavel: valorVariavel'
        ex: dbt run --select bicategories --vars 'category: Condiments'
        
ps: substitui a view existente
*/