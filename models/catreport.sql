/* Materialização
 O default  criar como view. Objetivo : troca para outras materializations os dados de categories.
Configs no dbt usam sintaxe jinja.
*/

--mudar na config para ephemeral, table ou incremental [requer chave(s) única(s)]. View é default.
{{
    config(
        materialized='incremental',
        unique_key='category_id' 
    )

}}

select * from {{source('sources','categories')}}

/*
Como ephemeral, não há obj criado no BD, aka não vai aparecer um 'catreport' no redshift.
Mas o modelo está criado e pode ser referenciado em outros modelos do dbt. 
Bom para passos intermediários (ex: joins intermediários)
*/

/*
Como table, uma tabela física é criada no redshift.
Tabelas são mais lentas para criação, mas mais rápidas para consultas.
Logo, bom para dados que serão consultados diversas vezes.
Mas a tabela criada via modelo table não vai adicionar novos registros inseridos no BD do redshift.
*/

/*
Modelo incremental aceita as mudanças executadas no BD fonte (localizado no cluster do redshift no caso).
Comandos de insert, update, delete, etc.

ex: No redshift, adicione uma linha em categories
insert into categories
values (9,'IT','Computers')

Rode o modelo configurado como incremental no dbt usando uma unique_key .
veja a table catreport criada no redshift. Ela terá esse novo registro (category_id=9).
Isso não aconteceria com um modelo com materialization tipo table normal.
*/