/*
Macros
	- blocos de código que podem ser podem ser executados em qualquer parte do pipeline, em
	qualquer modelo (CÓDIGO REUTILIZÁVEL). Ficam na pasta padrao 'macro' e são arquvos .sql
	- Dentro de um arquivo macro podemos ter várias macros, cada uma com um nome.
	- diferente dos modelos q são chamados pelo nome do arquivo, elas são chamadas pelos seus nomes
	- exemplo de uso: criar macro para retornar colunas recorrentes no select.
	- while, for, if etc.

*/
-- Criar e usar macro para retornar os campos category_name,suppliers,product_name,product_id da tab joins
select {{retorna_campos()}}
from {{ref('joins')}}