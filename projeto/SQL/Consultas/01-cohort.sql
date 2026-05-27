USE CompraLocal;

WITH PrimeiraCompra AS (
    -- 1. Identifica a data e o mês da primeira compra (pelo pagamento aprovado)
    SELECT
        id_cliente,
        MIN(DATE(data_pagamento)) AS data_primeira_compra,
        DATE_FORMAT(MIN(data_pagamento), '%Y-%m') AS mes_cohort
    FROM pagamento
    GROUP BY id_cliente
),

Financeiro_Base AS (
    -- 2. Consolida os dados financeiros por pedido
    SELECT
        ped.id_pedido,
        pag.id_cliente,
        DATE(pag.data_pagamento) AS data_pagamento,
        
        -- Canal de Atração do Pedido (Baseado na origem do cupom)
        COALESCE(c.origem, 'Direto/Orgânico') AS canal_atracao,
        
        -- GMV (Faturamento Bruto dos Itens)
        SUM(ip.preco_uni * ip.qtd_item) AS gmv,
        
        -- Reembolsos vinculados à nota fiscal daquele pagamento
        COALESCE(r.valor_reembolso, 0) AS total_reembolso,
        
        -- Comissão que a plataforma fatura (útil para cálculo de margem do ecossistema)
        SUM(ip.preco_uni * ip.qtd_item * COALESCE(tc.taxa, 0)) AS comissao_plataforma
        
    FROM pedido ped
    JOIN pagamento pag ON ped.id_pedido = pag.id_pedido
    JOIN itens_pedido ip ON ped.id_pedido = ip.id_pedido
    JOIN produto prod ON ip.id_produto = prod.id_produto
    JOIN categoria cat ON prod.id_categoria = cat.id_categoria
    JOIN taxa_comissao tc ON cat.id_taxa = tc.id_taxa
    
    -- Joins opcionais para capturar cupons e reembolsos se existirem
    LEFT JOIN aplica ap ON ped.id_pedido = ap.id_pedido
    LEFT JOIN cupom c ON ap.id_cupom = c.id_cupom
    LEFT JOIN nota_fiscal nf ON pag.id_pagamento = nf.id_pagamento
    LEFT JOIN reembolso r ON nf.id_nota_fiscal = r.id_nota_fiscal AND r.status_reembolso = 'disponivel'
    
    GROUP BY 
        ped.id_pedido, 
        pag.id_cliente, 
        DATE(pag.data_pagamento),
        COALESCE(c.origem, 'Direto/Orgânico'),
        COALESCE(r.valor_reembolso, 0)
),

Geografia_Cliente AS (
    -- 3. Mapeia o estado e a macrorregião de cada cliente
    SELECT DISTINCT
        ec.id_cliente,
        est.nome_estado AS uf,
        est.regiao AS macro_regiao
    FROM endereco_cliente ec
    JOIN estado est ON ec.id_estado = est.id_estado
)

-- 4. Agrupamento final por Cohort, Região e Canal de Atração
SELECT
    pc.mes_cohort,
    geo.macro_regiao,
    geo.uf,
    f.canal_atracao,
    
    -- Tamanho do Cohort (Clientes únicos que iniciaram no mês/região/canal)
    COUNT(DISTINCT pc.id_cliente) AS total_clientes_cohort,
    
    -- Taxa de Recompra em 30 Dias (Clientes que compraram novamente dentro de 1 a 30 dias)
    COUNT(DISTINCT CASE 
        WHEN DATEDIFF(f.data_pagamento, pc.data_primeira_compra) > 0 
         AND DATEDIFF(f.data_pagamento, pc.data_primeira_compra) <= 30 
        THEN f.id_cliente 
    END) / COUNT(DISTINCT pc.id_cliente) * 100 AS taxa_recompra_d30_porcentagem,
    
    -- Taxa de Recompra em 60 Dias
    COUNT(DISTINCT CASE 
        WHEN DATEDIFF(f.data_pagamento, pc.data_primeira_compra) > 0 
         AND DATEDIFF(f.data_pagamento, pc.data_primeira_compra) <= 60 
        THEN f.id_cliente 
    END) / COUNT(DISTINCT pc.id_cliente) * 100 AS taxa_recompra_d60_porcentagem,
    
    -- Taxa de Recompra em 90 Dias
    COUNT(DISTINCT CASE 
        WHEN DATEDIFF(f.data_pagamento, pc.data_primeira_compra) > 0 
         AND DATEDIFF(f.data_pagamento, pc.data_primeira_compra) <= 90 
        THEN f.id_cliente 
    END) / COUNT(DISTINCT pc.id_cliente) * 100 AS taxa_recompra_d90_porcentagem,
    
    -- Métricas Financeiras Consolidadas do Grupo
    SUM(f.gmv) AS gmv_total,
    SUM(f.total_reembolso) AS reembolsos_total,
    SUM(f.comissao_plataforma) AS receita_comissao_total,
    
    -- Margem Líquida (GMV - Reembolsos). 
    -- Nota: Como o custo do frete e taxas de cartão não constam no banco, 
    -- calculamos o GMV real gerado deduzido dos estornos (Vol. Líquido de Vendas)
    SUM(f.gmv - f.total_reembolso) AS margem_liquida_vendas

FROM PrimeiraCompra pc
JOIN Geografia_Cliente geo ON pc.id_cliente = geo.id_cliente
JOIN Financeiro_Base f ON pc.id_cliente = f.id_cliente
GROUP BY
    pc.mes_cohort,
    geo.macro_regiao,
    geo.uf,
    f.canal_atracao
ORDER BY
    pc.mes_cohort ASC,
    geo.macro_regiao ASC,
    geo.uf ASC,
    f.canal_atracao ASC;
