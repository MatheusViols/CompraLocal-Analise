USE CompraLocal;

-- =========================================================================================
-- 1. INSERÇÕES PARA A CONSULTA DE COHORT E RECOMPRA (30/60/90 Dias)
-- Objetivo: Criar uma "turma" (Cohort) de Janeiro de 2026 e forçar compras subsequentes
-- =========================================================================================

-- Pedidos Iniciais (Primeira Compra do Cohort de Janeiro de 2026)
INSERT INTO pedido (id_pedido, id_cliente, data_pedido, status_pedido) VALUES
(201, 1, '2026-01-10 10:00:00', 'fechado'), -- Cliente 1
(202, 2, '2026-01-12 11:00:00', 'fechado'); -- Cliente 2

-- Pagamentos Iniciais
INSERT INTO pagamento (id_pagamento, valor_pago, data_pagamento, id_cliente, id_pedido) VALUES
(201, 100.00, '2026-01-10 10:05:00', 1, 201),
(202, 100.00, '2026-01-12 11:05:00', 2, 202);

-- Recompras (Para bater as taxas D30, D60 e D90)
INSERT INTO pedido (id_pedido, id_cliente, data_pedido, status_pedido) VALUES
(203, 1, '2026-02-05 10:00:00', 'fechado'), -- Cliente 1 recomprando em ~25 dias (D30)
(204, 1, '2026-03-05 10:00:00', 'fechado'), -- Cliente 1 recomprando em ~55 dias (D60)
(205, 2, '2026-04-05 10:00:00', 'fechado'); -- Cliente 2 recomprando em ~85 dias (D90)

INSERT INTO pagamento (id_pagamento, valor_pago, data_pagamento, id_cliente, id_pedido) VALUES
(203, 100.00, '2026-02-05 10:05:00', 1, 203),
(204, 100.00, '2026-03-05 10:05:00', 1, 204),
(205, 100.00, '2026-04-05 10:05:00', 2, 205);

-- Itens para os pedidos do Cohort
INSERT INTO itens_pedido (id_pedido, id_produto, qtd_item, preco_uni) VALUES
(201, 1, 1, 100.00), (202, 1, 1, 100.00), (203, 1, 1, 100.00), (204, 1, 1, 100.00), (205, 1, 1, 100.00);


-- =========================================================================================
-- 2. INSERÇÕES PARA A CONSULTA DE SPLIT ORDER E QUEBRA DE SLA
-- Objetivo: Criar um pedido com itens de lojas diferentes e registrar um atraso severo
-- =========================================================================================

-- Pedido Multi-Loja (Split Order)
INSERT INTO pedido (id_pedido, id_cliente, data_pedido, status_pedido) VALUES 
(206, 3, '2026-03-01 10:00:00', 'fechado');

-- Inserindo Produto 1 (id_loja = 1) e Produto 2 (id_loja = 2) no mesmo pedido
INSERT INTO itens_pedido (id_pedido, id_produto, qtd_item, preco_uni) VALUES
(206, 1, 1, 1200.00), 
(206, 2, 1, 89.90);

-- Cadeia financeira e logística com atraso (SLA era 05/03, Entregou 10/03)
INSERT INTO pagamento (id_pagamento, valor_pago, data_pagamento, id_cliente, id_pedido) VALUES 
(206, 1289.90, '2026-03-01 10:05:00', 3, 206);

INSERT INTO nota_fiscal (id_nota_fiscal, id_pagamento) VALUES 
(206, 206);

INSERT INTO entrega (id_entrega, data_prevista, data_efetiva, status_entrega, id_nota_fiscal, id_estado, cidade, rua, numero, cep, id_entregador) VALUES
(206, '2026-03-05', '2026-03-10', 'entregue', 206, 1, 'Recife', 'Rua Aurora', '123', '50000000', 1);


-- =========================================================================================
-- 3. INSERÇÕES PARA A CONSULTA DE FRAUDE DE REEMBOLSO (Z-SCORE)
-- Objetivo: Criar um comportamento anômalo para o Cliente 10 estourar a média estatística
-- =========================================================================================

-- O Cliente 10 fará 5 pedidos separados em dias seguidos e pedirá reembolso do Motivo 1 para todos
INSERT INTO pedido (id_pedido, id_cliente, data_pedido, status_pedido) VALUES
(207, 10, '2026-04-01 10:00:00', 'fechado'), (208, 10, '2026-04-02 10:00:00', 'fechado'), 
(209, 10, '2026-04-03 10:00:00', 'fechado'), (210, 10, '2026-04-04 10:00:00', 'fechado'), 
(211, 10, '2026-04-05 10:00:00', 'fechado');

INSERT INTO itens_pedido (id_pedido, id_produto, qtd_item, preco_uni) VALUES
(207, 1, 1, 10.00), (208, 1, 1, 10.00), (209, 1, 1, 10.00), (210, 1, 1, 10.00), (211, 1, 1, 10.00);

INSERT INTO pagamento (id_pagamento, valor_pago, data_pagamento, id_cliente, id_pedido) VALUES
(207, 10.00, '2026-04-01 10:05:00', 10, 207), (208, 10.00, '2026-04-02 10:05:00', 10, 208), 
(209, 10.00, '2026-04-03 10:05:00', 10, 209), (210, 10.00, '2026-04-04 10:05:00', 10, 210), 
(211, 10.00, '2026-04-05 10:05:00', 10, 211);

INSERT INTO nota_fiscal (id_nota_fiscal, id_pagamento) VALUES 
(207, 207), (208, 208), (209, 209), (210, 210), (211, 211);

-- Inserindo 5 Reembolsos seguidos com status "disponivel" para o Motivo 1 ('produto_danificado')
INSERT INTO reembolso (id_reembolso, status_reembolso, valor_reembolso, id_nota_fiscal, id_motivo) VALUES
(207, 'disponivel', 10.00, 207, 1), (208, 'disponivel', 10.00, 208, 1), 
(209, 'disponivel', 10.00, 209, 1), (210, 'disponivel', 10.00, 210, 1), 
(211, 'disponivel', 10.00, 211, 1);


-- =========================================================================================
-- 4. INSERÇÕES PARA A CONSULTA DE ELASTICIDADE DE PREÇO (Sazonalidade Parada)
-- Objetivo: Parear o mesmo dia da semana fora do período promocional
-- =========================================================================================

-- O Produto 1 tem uma promoção cadastrada até 31/05/2026.
-- O script original que você enviou já tem uma venda dele numa Terça-feira (26/05/2026).
-- Vamos inserir uma venda desse mesmo produto numa Terça-Feira fora da promoção (09/06/2026).

INSERT INTO pedido (id_pedido, id_cliente, data_pedido, status_pedido) VALUES 
(212, 1, '2026-06-09 10:00:00', 'fechado');

-- Simulando que sem desconto venderam-se apenas 2 itens
INSERT INTO itens_pedido (id_pedido, id_produto, qtd_item, preco_uni) VALUES 
(212, 1, 2, 1200.00);

-- Pagamento registrando a conversão real na data
INSERT INTO pagamento (id_pagamento, valor_pago, data_pagamento, id_cliente, id_pedido) VALUES 
(212, 2400.00, '2026-06-09 10:05:00', 1, 212);
