/*Lógica para extrair idade pela data de nascimento dos employees [nao precisa ser exato, fazer pelo ano],
o tempo de serviço pela data de admissão e
juntar first name e last name em uma unica coluna name*/

with calc_employees as ( --criando a CTE !
    SELECT 
        date_part(year,current_date) - date_part(year,birth_date) age --extrair o ano da data, diminui atual do ano de nasc p pegar idade
        ,date_part(year,current_date) - date_part(year,hire_date) lengthofservice  --mesma ideia do anterior, com data de admissão
        ,first_name || ' ' || last_name name --concat de first e last name, separados por espaço
        , * --trazer o resto das infos
    FROM {{source('sources', 'employees') }}
    )

select * from calc_employees