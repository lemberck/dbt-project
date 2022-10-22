/* Joins dos resultados, selecionando cols relevantes e dando alias para as em comum*/
/* Etapa 1 : juntar products com suppliers e categories*/
WITH prod AS (
	SELECT ct.category_name
		,sp.company_name suppliers
		,pd.product_name
		,pd.unit_price
		,pd.product_id
	FROM {{source('sources', 'products') }} pd
	LEFT JOIN {{source('sources', 'suppliers') }} sp
		ON (pd.supplier_id = sp.supplier_id)
	LEFT JOIN {{source('sources', 'categories') }} ct
		ON (pd.category_id = ct.category_id)
	)
	/*Etapa 2 : join do result anterior com orders criada anteriormente (orderdetails) -> precisa usar 'ref' então*/
	, orddetail AS (
	SELECT pd.*
		,od.order_id
		,od.quantity
		,od.discount
	FROM {{ref('orderdetails') }} od /*ref a uma view criada anteriormente*/
	LEFT JOIN prod pd
		ON (od.product_id = pd.product_id)
	)
    /*Etapa 3 : join de orders anterior com employees, customers e shippers 
    Usar as views ('ref') que foram trabalhadas com as regras de negócio*/
	, ordrs AS (
		SELECT ord.order_date
			,ord.order_id
			,cs.company_name customer
			,em.name employee
			,em.age
			,em.lengthofservice
		FROM {{source('sources', 'orders') }} ord
		LEFT JOIN {{ref('customers') }} cs
			ON (ord.customer_id = cs.customer_id)
		LEFT JOIN {{ref('employees') }} em
			ON (ord.employee_id = em.employee_id)
		LEFT JOIN {{source('sources', 'shippers') }} sh
			ON (ord.ship_via = sh.shipper_id)
		)
    /*Etapa 4 : join final de result etapa 2 com result etapa 3
    inner join pois toda order tem order detail e vice versa*/
	, finaljoin AS (
		SELECT od.*
			,ord.order_date
			,ord.customer
			,ord.employee
			,ord.age
			,ord.lengthofservice
		FROM orddetail od
		INNER JOIN ordrs ord
			ON (od.order_id = ord.order_id)
		)
SELECT * FROM finaljoin

/*conferindo : finaljoin tem q ter o msm numero de order_details*/
/*select count(*) from finaljoin*/
/*select count(*) from order_details*/