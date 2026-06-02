USE CompraLocal;

WITH Janela_Promocional AS (
    -- 1. Identifica os produtos vinculados a promoções e mapeia seus períodos de vigência reais
    SELECT 
        prod.id_produto,
        prod.nome AS nome_produto,
        prom.id_promocao,
        prom.preco_anterior,
        prom.preco_promocional,
        DATE(prom.data_inicio) AS data_inicio,
        DATE(prom.data_fim) AS data_fim
    FROM produto prod
    JOIN promo_prod pp ON prod.id_produto = pp.id_produto
    JOIN promocao prom ON pp.id_promocao = prom.id_promocao
),

Vendas_Diarias_Produto AS (
    -- 2. Consolida o volume total de itens comprados por produto a cada dia (Baseado estritamente em pedido e pagamento)
    SELECT 
        DATE(pag.data_pagamento) AS data_venda,
        DAYOFWEEK(pag.data_pagamento) AS dia_semana_num, -- 1 = Domingo, 2 = Segunda, ..., 7 = Sábado
        ip.id_produto,
        SUM(ip.qtd_item) AS qtd_comprada_no_dia
    FROM pagamento pag
    JOIN pedido ped ON pag.id_pedido = ped.id_pedido
    JOIN itens_pedido ip ON ped.id_pedido = ip.id_pedido
    WHERE ped.status_pedido = 'fechado' -- Considera apenas pedidos concretizados
    GROUP BY DATE(pag.data_pagamento), DAYOFWEEK(pag.data_pagamento), ip.id_produto
),

Compras_Durante_Promocao AS (
    -- 3. Média diária de compras por dia da semana ENQUANTO a promoção do produto esteve ativa
    SELECT 
        v.id_produto,
        v.dia_semana_num,
        jp.preco_anterior,
        jp.preco_promocional,
        (jp.preco_promocional - jp.preco_anterior) AS variacao_nominal_preco,
        AVG(v.qtd_comprada_no_dia) AS media_compras_com_promo
    FROM Vendas_Diarias_Produto v
    JOIN Janela_Promocional jp ON v.id_produto = jp.id_produto 
        AND v.data_venda BETWEEN jp.data_inicio AND jp.data_fim
    GROUP BY v.id_produto, v.dia_semana_num, jp.preco_anterior, jp.preco_promocional
),

Compras_Preco_Normal AS (
    -- 4. Média diária de compras por dia da semana FORA do período promocional (Dias de Preço Regular)
    SELECT 
        v.id_produto,
        v.dia_semana_num,
        AVG(v.qtd_comprada_no_dia) AS media_compras_sem_promo
    FROM Vendas_Diarias_Produto v
    WHERE NOT EXISTS (
        SELECT 1 
        FROM Janela_Promocional jp 
        WHERE v.id_produto = jp.id_produto 
          AND v.data_venda BETWEEN jp.data_inicio AND jp.data_fim
    )
    GROUP BY v.id_produto, v.dia_semana_num
)

-- 5. Resultado Final: Pareamento para anular a sazonalidade e listar produtos por ganho/perda de conversão em compras
SELECT 
    cp.id_produto,
    jp.nome_produto,
    CASE cp.dia_semana_num
        WHEN 1 THEN 'Domingo' WHEN 2 THEN 'Segunda' WHEN 3 THEN 'Terça'
        WHEN 4 THEN 'Quarta'  WHEN 5 THEN 'Quinta'  WHEN 6 THEN 'Sexta' WHEN 7 THEN 'Sábado'
    END AS dia_da_semana,
    cp.preco_anterior AS preco_antes,
    cp.preco_promocional AS preco_depois,
    cp.variacao_nominal_preco,
    
    ROUND(sp.media_compras_sem_promo, 2) AS media_compras_dia_normal,
    ROUND(cp.media_compras_com_promo, 2) AS media_compras_dia_promocional,
    
    -- Elasticidade / Variação percentual na conversão de compras de um período contra o outro
    ROUND(
        ((cp.media_compras_com_promo - sp.media_compras_sem_promo) / NULLIF(sp.media_compras_sem_promo, 0)) * 100, 
        2
    ) AS variacao_conversao_compras_porcentagem,

    -- Classificação analítica conforme comportamento de elasticidade requisitado
    CASE 
        WHEN cp.variacao_nominal_preco < 0 AND ((cp.media_compras_com_promo - sp.media_compras_sem_promo) / NULLIF(sp.media_compras_sem_promo, 0)) > 0 
            THEN 'Ganho por Desconto (Sucesso)'
        WHEN cp.variacao_nominal_preco > 0 AND ((cp.media_compras_com_promo - sp.media_compras_sem_promo) / NULLIF(sp.media_compras_sem_promo, 0)) < 0 
            THEN 'Queda por Aumento de Preço'
        ELSE 'Neutro / Sem Elasticidade Significativa'
    END AS comportamento_elasticidade

FROM Compras_Durante_Promocao cp
JOIN Compras_Preco_Normal sp ON cp.id_produto = sp.id_produto AND cp.dia_semana_num = sp.dia_semana_num
JOIN Janela_Promocional jp ON cp.id_produto = jp.id_produto
ORDER BY variacao_conversao_compras_porcentagem DESC;
