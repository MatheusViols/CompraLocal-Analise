+ #### Cohort de clientes com recompra e margem (D30/D60/D90)
	Gerar coortes por mês da primeira compra e calcular: taxa de recompra
	em 30/60/90 dias e margem líquida (GMV – reembolsos – comissões de
	pagamento – custo de entrega subsidiado). Separar por canal de
	aquisição (se existir) e região.

- #### Split order: tempo de ciclo por loja dentro do mesmo pedido
	Para pedidos com múltiplas lojas, calcular o tempo de preparo e tempo
	total até entrega por loja e identificar:
	o pedidos em que uma loja atrasou e puxou o SLA do pedido,
	o lojas que mais “quebram” SLA quando participam de pedidos multi-
	loja.

- #### Fraude de reembolso: padrão de reincidência por motivo e categoria
	Detectar clientes que concentram reembolsos em um mesmo motivo e/ou
	categoria acima de um limiar estatístico (ex.: z-score ou percentil 95).
	Exibir histórico, taxa de reembolso por valor e por quantidade, e comparar
	com a média da plataforma.

- #### Elasticidade de preço e conversão por produto (antes/depois de promoções)
	Para produtos com mudanças de preço (promoções), comparar
	conversão (visita→compra, ou carrinho→compra) antes e depois da
	mudança, controlando por sazonalidade (mesma semana/dia). Listar
	produtos com maior queda de conversão por aumento de preço e maior
	ganho por desconto.

- #### Reputação vs recorrência: correlação por loja
	Calcular para cada loja: nota média, volume de vendas, taxa de recompra
	dos clientes dessa loja e taxa de reclamação/reembolso. Identificar
	outliers:
	- *o lojas com nota alta e recompra baixa,*
	- *o lojas com nota baixa mas recompra alta (possível nicho/preço)*


## Relações
- [[Enunciado Oficial]]