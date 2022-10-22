/* Loggins

Loggins via package e alteração do yml do projeto para modelo genérico de post e pre hooks
	- no yml principal do projeto, adicionar em 'models:' :
		pre-hook: "{{logging.log_model_start_event()}}"
  		post-hook: "{{logging.log_model_end_event()}}"
	- Com isso, ao rodar um modelo vai ter uma parte de 'details' com os loggings.
	- No redshift, vai criar um schema com msm nome do schema onde está rodando + sufixo '_meta', onde
	terá uma tabela 'dbt_audit_log' com os logs de eventos da execução

Criar modelo no dbt para investigar a table 'dbt_audit_log' criada pelo pkg loggings
    - FROM {{target.schema}}_meta.dbt_audit_log   <para ter flexibilidade do schema>
*/

SELECT DISTINCT event_name tipoEvento
	,event_timestamp dataHora
	,event_schema currentSchema
	,event_model modelo
	,event_user usuario
	,event_target
FROM {{target.schema}}_meta.dbt_audit_log