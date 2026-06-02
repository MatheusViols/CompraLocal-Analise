USE CompraLocal;

WITH Historico_Reembolsos_Base AS (
    SELECT 
        pag.id_cliente, r.id_motivo, m.motivo AS nome_motivo,
        cat.id_categoria, cat.nome_categoria, r.valor_reembolso
    FROM reembolso r
    JOIN motivo m ON r.id_motivo = m.id_motivo
    JOIN nota_fiscal nf ON r.id_nota_fiscal = nf.id_nota_fiscal
    JOIN pagamento pag ON nf.id_pagamento = pag.id_pagamento
    JOIN pedido ped ON pag.id_pedido = ped.id_pedido
    JOIN itens_pedido ip ON ped.id_pedido = ip.id_pedido
    JOIN produto prod ON ip.id_produto = prod.id_produto
    JOIN categoria cat ON prod.id_categoria = cat.id_categoria
    WHERE r.status_reembolso = 'disponivel'
),
Metricas_Por_Cliente_Motivo AS (
    SELECT 
        id_cliente, id_motivo, nome_motivo,
        COUNT(*) AS qtd_reembolsos_cliente_motivo,
        SUM(valor_reembolso) AS valor_total_reembolsado
    FROM Historico_Reembolsos_Base
    GROUP BY id_cliente, id_motivo, nome_motivo
),
Estatistica_Plataforma_Motivo AS (
    SELECT 
        id_motivo,
        AVG(qtd_reembolsos_cliente_motivo) AS media_qtd_plataforma,
        STDDEV(qtd_reembolsos_cliente_motivo) AS desvio_padrao_qtd_plataforma
    FROM Metricas_Por_Cliente_Motivo
    GROUP BY id_motivo
)

SELECT 
    cm.id_cliente,
    c.nome AS nome_cliente,
    cm.nome_motivo AS analise_por_motivo,
    cm.qtd_reembolsos_cliente_motivo AS qtd_reembolsos_cliente,
    ROUND(epm.media_qtd_plataforma, 2) AS media_qtd_plataforma,
    cm.valor_total_reembolsado,
    
    -- Novo cálculo lidando com o Desvio Padrão Zero
    COALESCE(
        ROUND((cm.qtd_reembolsos_cliente_motivo - epm.media_qtd_plataforma) / NULLIF(epm.desvio_padrao_qtd_plataforma, 0), 2),
        CASE WHEN cm.qtd_reembolsos_cliente_motivo >= 3 THEN 9.99 ELSE 0 END
    ) AS z_score_volumetrico,
    
    CASE 
        WHEN epm.desvio_padrao_qtd_plataforma = 0 AND cm.qtd_reembolsos_cliente_motivo >= 3 THEN 'Alerta Vermelho - Monopolizador de Motivo'
        WHEN ((cm.qtd_reembolsos_cliente_motivo - epm.media_qtd_plataforma) / NULLIF(epm.desvio_padrao_qtd_plataforma, 0)) > 2.0 THEN 'Anomalia Estatística'
        ELSE 'Normal'
    END AS status_fraude

FROM Metricas_Por_Cliente_Motivo cm
JOIN cliente c ON cm.id_cliente = c.id_cliente
JOIN Estatistica_Plataforma_Motivo epm ON cm.id_motivo = epm.id_motivo

-- Descomente a linha abaixo quando a base for gigantesca e você quiser ver SÓ as fraudes.
-- Por enquanto, deixamos livre para você visualizar todos.
WHERE COALESCE((cm.qtd_reembolsos_cliente_motivo - epm.media_qtd_plataforma) / NULLIF(epm.desvio_padrao_qtd_plataforma, 0), CASE WHEN cm.qtd_reembolsos_cliente_motivo >= 3 THEN 9.99 ELSE 0 END) > 2.0

ORDER BY z_score_volumetrico DESC;
