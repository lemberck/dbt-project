{# 
Hooks
pre-hook : executado antes do modelo ser criado. Ex: Lock de tabela (Impede que a tabela seja usada enquando está sendo feita uma alteração nela.)
post-hook : executado depois do modelo ser criado. Ex: limitar o acesso a certas tabelas para um grupo específico (permissões)
on-run-start : executado antes de executar o pipeline
on-run-end : executado depois de executar o pipeline

Hooks são feitos na config com sintaxe jinja.
O schema é variavel (pode ser o de dev ou o de prod), logo não pode deixar hard-coded. Usar {{target.schema}} para
variar de acordo com o schema que estiver rodando
*/

/*Exemplo : crie permissão da tabela 'joins' para um usuario usertest, senha Aa123456 , do grupo biuser*/
/*
1 - criar o grupo, usuário e adicionar esse usuário ao grupo no redshift :

create group biusers;
create user usertest with password 'Aa123456';
alter group biusers add user usertest;

2- config post_hook no dbt
    - Dar GRANT USAGE do schema para o grupo (permissão de acesso ao schema)
    - Dar GRAND SELECT ON TABLE para o grupo (permissão de leitura)

3- criar o select da tabela pedida no dbt
#}

{{
    config(
        materialized='table',
        post_hook=["
            GRANT USAGE ON SCHEMA {{target.schema}} TO GROUP biusers;
            GRANT SELECT ON TABLE {{target.schema}}.bireport TO GROUP biusers;
        "]
    )

}}

select * from {{ref('joins')}}

{#
Exemplo com lock em prehook e entao permissão com posthook (commit libera o lock)
{{
    config(
        materialized='table',
        pre_hook=["
            begin; 
            lock table {{target.schema}}.bireport;
            "],

        post_hook=["
            commit;
            GRANT USAGE ON SCHEMA {{target.schema}} TO GROUP biusers;
            GRANT SELECT ON TABLE {{target.schema}}.bireport TO GROUP biusers;
        "]

    )

}}
#}