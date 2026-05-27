USE CompraLocal;

WITH Avaliacoes AS (
    SELECT 
        p.id_loja,
        AVG(a.nota) AS nota_media
    FROM avaliacao a
    JOIN produto p ON a.id_produto = p.id_produto
    GROUP BY p.id_loja
),
Vendas_Clientes AS (
    -- Sem Carrinho: o caminho é produto → itens_pedido → pedido → pagamento
    SELECT 
        p.id_loja,
        pag.id_cliente,
        COUNT(DISTINCT ped.id_pedido) AS qtd_pedidos_cliente
    FROM produto p
    JOIN itens_pedido ip  ON p.id_produto   = ip.id_produto
    JOIN pedido ped       ON ip.id_pedido   = ped.id_pedido
    JOIN pagamento pag    ON ped.id_pedido  = pag.id_pedido
    GROUP BY p.id_loja, pag.id_cliente
),
Metricas_Vendas AS (
    SELECT 
        id_loja,
        SUM(qtd_pedidos_cliente)                                                  AS volume_vendas_total,
        COUNT(DISTINCT id_cliente)                                                AS total_clientes_unicos,
        COUNT(DISTINCT CASE WHEN qtd_pedidos_cliente > 1 THEN id_cliente END)    AS clientes_recorrentes
    FROM Vendas_Clientes
    GROUP BY id_loja
),
Reembolsos_Loja AS (
    -- nota_fiscal → pagamento (via id_pagamento) → pedido → itens_pedido → produto
    SELECT 
        p.id_loja,
        COUNT(DISTINCT r.id_reembolso) AS qtd_reembolsos
    FROM reembolso r
    JOIN nota_fiscal nf  ON r.id_nota_fiscal  = nf.id_nota_fiscal
    JOIN pagamento pag   ON nf.id_pagamento   = pag.id_pagamento
    JOIN pedido ped      ON pag.id_pedido     = ped.id_pedido
    JOIN itens_pedido ip ON ped.id_pedido     = ip.id_pedido
    JOIN produto p       ON ip.id_produto     = p.id_produto
    GROUP BY p.id_loja
)
SELECT 
    l.nome_loja,
    ROUND(COALESCE(av.nota_media, 0), 2)                                                              AS nota_media,
    COALESCE(mv.volume_vendas_total, 0)                                                               AS volume_vendas,
    ROUND(COALESCE(mv.clientes_recorrentes / NULLIF(mv.total_clientes_unicos, 0) * 100, 0), 2)       AS taxa_recompra_percentual,
    ROUND(COALESCE(rl.qtd_reembolsos     / NULLIF(mv.volume_vendas_total,     0) * 100, 0), 2)       AS taxa_reembolso_percentual,
    CASE 
        WHEN av.nota_media >= 4.5 
             AND (mv.clientes_recorrentes / NULLIF(mv.total_clientes_unicos, 0)) < 0.10 
            THEN 'Alerta: Nota Alta, Recompra Baixa'
        WHEN av.nota_media <= 3.0 
             AND (mv.clientes_recorrentes / NULLIF(mv.total_clientes_unicos, 0)) > 0.30 
            THEN 'Oportunidade: Nota Baixa, Recompra Alta (Nicho/Preço)'
        ELSE 'Comportamento Padrão'
    END AS status_outlier
FROM lojista l
LEFT JOIN Avaliacoes      av ON l.id_loja = av.id_loja
LEFT JOIN Metricas_Vendas mv ON l.id_loja = mv.id_loja
LEFT JOIN Reembolsos_Loja rl ON l.id_loja = rl.id_loja
ORDER BY status_outlier ASC, nota_media DESC;
