/*Lógica para calcular o valor das vendas,
calcular o desconto real*/

SELECT od.order_id /* especificando cols relevantes para tirar as irrelevantes*/
	,od.product_id
	,od.unit_price
	,od.quantity
	,pr.product_name
	,pr.supplier_id
	,pr.category_id 
	,od.unit_price * od.quantity total /*calculando total venda*/
	,(pr.unit_price * od.quantity) - total discount /* calc desconto*/
FROM {{source('sources', 'order_details') }} od
LEFT JOIN {{source('sources', 'products') }} pr
	ON (od.product_id = pr.product_id) /*join order_details com products*/