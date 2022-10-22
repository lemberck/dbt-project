/*Particionando os dados para otimização de dados analíticos - ganho de performance
Partição por ano - Esse partição pelo ano 2021
*/
SELECT *
FROM {{ref('joins') }}
WHERE date_part(year, order_date) = 2021