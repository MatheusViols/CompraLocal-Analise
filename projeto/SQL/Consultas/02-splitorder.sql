USE CompraLocal;

WITH Lojas_Por_Pedido AS (
    -- 1. Identifica quais lojas possuem produtos em cada pedido
    SELECT 
        ip.id_pedido,
        prod.id_loja,
        loj.nome_loja
    FROM itens_pedido ip
    JOIN produto prod ON ip.id_produto = prod.id_produto
    JOIN lojista loj ON prod.id_loja = loj.id_loja
    GROUP BY ip.id_pedido, prod.id_loja, loj.nome_loja
),

Pedidos_Multi_Loja AS (
    -- 2. Filtra apenas os pedidos que possuem mais de uma loja envolvida
    SELECT 
        id_pedido,
        COUNT(DISTINCT id_loja) AS qtd_lojas
    FROM Lojas_Por_Pedido
    GROUP BY id_pedido
    HAVING COUNT(DISTINCT id_loja) > 1
),

Dados_Entrega AS (
    -- 3. Amarra o pedido aos dados reais de entrega registrados no banco
    SELECT 
        p.id_pedido,
        p.data_pedido,
        ent.data_prevista,
        ent.data_efetiva,
        -- No estado atual do banco, o tempo de ciclo e atraso é calculado a nível de entrega do pedido
        DATEDIFF(ent.data_efetiva, p.data_pedido) AS tempo_total_entrega,
        DATEDIFF(ent.data_efetiva, ent.data_prevista) AS dias_atraso,
        CASE WHEN ent.data_efetiva > ent.data_prevista THEN 1 ELSE 0 END AS houve_atraso
    FROM pedido p
    JOIN pagamento pag ON p.id_pedido = pag.id_pedido
    JOIN nota_fiscal nf ON pag.id_pagamento = nf.id_pagamento
    JOIN entrega ent ON nf.id_nota_fiscal = ent.id_nota_fiscal
    WHERE p.status_pedido = 'fechado' AND ent.status_entrega = 'entregue'
)

-- 4. Consulta Final: Consolida o tempo de ciclo atribuído às lojas em pedidos multi-loja
SELECT 
    de.id_pedido,
    de.data_pedido,
    lp.id_loja,
    lp.nome_loja,
    de.data_prevista,
    de.data_efetiva,
    de.tempo_total_entrega AS tempo_ciclo_pedido_dias,
    CASE 
        WHEN de.dias_atraso > 0 THEN de.dias_atraso 
        ELSE 0 
    END AS dias_atraso_pedido,
    
    -- Como o banco possui apenas uma entrega por pedido, todas as lojas do split order 
    -- compartilham o status de atraso daquela entrega conjunta no estado atual do modelo.
    CASE 
        WHEN de.houve_atraso = 1 THEN 'Pedido Atrasado (Multi-Loja)'
        ELSE 'Dentro do SLA'
    END AS status_sla_loja

FROM Pedidos_Multi_Loja pml
JOIN Lojas_Por_Pedido lp ON pml.id_pedido = lp.id_pedido
JOIN Dados_Entrega de ON pml.id_pedido = de.id_pedido
ORDER BY de.id_pedido ASC, lp.id_loja ASC;
