USE CompraLocal;

-- 1. ESTADO (Dependência de: Nenhuma)
INSERT INTO estado (nome_estado, regiao) VALUES
('PE', 'NORDESTE'), ('SP', 'SUDESTE'), ('RJ', 'SUDESTE'), ('MG', 'SUDESTE'), ('BA', 'NORDESTE'),
('PR', 'SUL'), ('RS', 'SUL'), ('CE', 'NORDESTE'), ('GO', 'CENTRO-OESTE'), ('AM', 'NORTE');

-- 2. CLIENTE (Dependência de: Nenhuma)
INSERT INTO cliente (cpf, email, nome, senha) VALUES
('11122233344', 'lucas@email.com', 'Lucas Silva', 'senha_hash_1'),
('22233344455', 'maria@email.com', 'Maria Oliveira', 'senha_hash_2'),
('33344455566', 'joao@email.com', 'João Santos', 'senha_hash_3'),
('44455566677', 'ana@email.com', 'Ana Costa', 'senha_hash_4'),
('55566677788', 'pedro@email.com', 'Pedro Souzas', 'senha_hash_5'),
('66677788899', 'carla@email.com', 'Carla Lima', 'senha_hash_6'),
('77788899900', 'bruno@email.com', 'Bruno Alves', 'senha_hash_7'),
('88899900011', 'julia@email.com', 'Júlia Rocha', 'senha_hash_8'),
('99900011122', 'marcos@email.com', 'Marcos Pereira', 'senha_hash_9'),
('00011122233', 'beatriz@email.com', 'Beatriz Cruz', 'senha_hash_10');

-- 3. ENDERECO_CLIENTE (Dependência de: Estado, Cliente)
INSERT INTO endereco_cliente (id_estado, id_cliente, cidade, rua, numero, cep, num_telefone) VALUES
(1, 1, 'Recife', 'Rua Aurora', '123', '50000000', '81999991111'),
(2, 2, 'São Paulo', 'Av Paulista', '1000', '01311000', '11999992222'),
(3, 3, 'Rio de Janeiro', 'Rua Copacabana', '45', '22020001', '21999993333'),
(4, 4, 'Belo Horizonte', 'Av Afonso Pena', '500', '30130001', '31999994444'),
(5, 5, 'Salvador', 'Rua Barra', '88', '40140000', '71999995555'),
(6, 6, 'Curitiba', 'Rua XV de Novembro', '12', '80020000', '41999996666'),
(7, 7, 'Porto Alegre', 'Av Ipiranga', '3000', '90160092', '51999997777'),
(8, 8, 'Fortaleza', 'Av Beira Mar', '777', '60165121', '85999998888'),
(9, 9, 'Goiânia', 'Av T-9', '432', '74215022', '62999999999'),
(10, 10, 'Manaus', 'Av Djalma Batista', '99', '69050010', '92999990000');

-- 4. LOJISTA (Dependência de: Estado)
INSERT INTO lojista (email, senha, cnpj, nome_loja, cep, id_estado, cidade, rua, numero) VALUES
('loja1@email.com', 'hash_loja_1', '12345678000101', 'Eletro Tech', '50030230', 1, 'Recife', 'Av Cais do Apolo', '222'),
('loja2@email.com', 'hash_loja_2', '23456789000102', 'Moda Fashion', '01414000', 2, 'São Paulo', 'Rua Augusta', '1500'),
('loja3@email.com', 'hash_loja_3', '34567890000103', 'Livraria Central', '20040002', 3, 'Rio de Janeiro', 'Rua do Ouvidor', '89'),
('loja4@email.com', 'hash_loja_4', '45678901000104', 'Mundo Esportivo', '30110001', 4, 'Belo Horizonte', 'Av Contorno', '4000'),
('loja5@email.com', 'hash_loja_5', '56789012000105', 'Beleza Rara', '40020000', 5, 'Salvador', 'Av Sete de Setembro', '11'),
('loja6@email.com', 'hash_loja_6', '67890123000106', 'ConstruExpress', '80230010', 6, 'Curitiba', 'Av Sete de Setembro', '555'),
('loja7@email.com', 'hash_loja_7', '78901234000107', 'Super Mercado Mix', '90010001', 7, 'Porto Alegre', 'Rua dos Andradas', '1200'),
('loja8@email.com', 'hash_loja_8', '89012345000108', 'Pet Shop Amigo', '60060000', 8, 'Fortaleza', 'Rua Monsenhor Tabosa', '34'),
('loja9@email.com', 'hash_loja_9', '90123456000109', 'Variedades do Lar', '74015010', 9, 'Goiânia', 'Av Anhanguera', '881'),
('loja10@email.com', 'hash_loja_10', '01234567000110', 'Info Info', '69005000', 10, 'Manaus', 'Rua Recife', '70');

-- 5. ENTREGADOR (Dependência de: Estado)
INSERT INTO entregador (cpf, nome, senha, email, id_estado, cidade, rua, numero, cep) VALUES
('11111111111', 'Carlos Entregas', 'hash_e1', 'carlos@motoboy.com', 1, 'Recife', 'Rua da Guia', '10', '50030210'),
('22222222222', 'Roberto Veloz', 'hash_e2', 'roberto@motoboy.com', 2, 'São Paulo', 'Rua da Consolação', '4B', '01301000'),
('33333333333', 'Fernando Flash', 'hash_e3', 'fernando@motoboy.com', 3, 'Rio de Janeiro', 'Av Mem de Sá', '102', '20230150'),
('44444444444', 'Diego Rapido', 'hash_e4', 'diego@motoboy.com', 4, 'Belo Horizonte', 'Rua Bahia', '35', '30160010'),
('55555555555', 'Sandro Moto', 'hash_e5', 'sandro@motoboy.com', 5, 'Salvador', 'Rua Chile', '9', '40020010'),
('66666666666', 'Alexandre Express', 'hash_e6', 'alexandre@motoboy.com', 6, 'Curitiba', 'Rua Marechal Deodoro', '77', '80010010'),
('77777777777', 'Thiago Frete', 'hash_e7', 'thiago@motoboy.com', 7, 'Porto Alegre', 'Rua da Praia', '200', '90010020'),
('88888888888', 'Marcelo Veloz', 'hash_e8', 'marcelo@motoboy.com', 8, 'Fortaleza', 'Rua Estelita Lima', '15A', '60425710'),
('99999999999', 'Felipe Carga', 'hash_e9', 'felipe@motoboy.com', 9, 'Goiânia', 'Rua 3', '55', '74015015'),
('00000000000', 'Giovanni Giro', 'hash_e10', 'giovanni@motoboy.com', 10, 'Manaus', 'Av Brasil', '2000', '69036110');

-- 6. CAMPANHA_VIGENTE (Dependência de: Nenhuma)
INSERT INTO campanha_vigente (descricao, nome, data_inicio, data_fim) VALUES
('Campanha de Black Friday 2026', 'Black Friday', '2026-11-01', '2026-11-30'),
('Campanha de Natal Premiado', 'Natal', '2026-12-01', '2026-12-25'),
('Liquidação de Ano Novo', 'Ano Novo', '2026-12-26', '2027-01-05'),
('Semana do Consumidor', 'Consumidor', '2026-03-10', '2026-03-17'),
('Mês das Mães com Desconto', 'Dia das Mães', '2026-05-01', '2026-05-31'),
('Campanha Dia dos Namorados', 'Namorados', '2026-06-01', '2026-06-12'),
('Festival de Inverno', 'Inverno', '2026-07-01', '2026-07-31'),
('Volta às Aulas Nota 10', 'Volta às Aulas', '2026-01-15', '2026-02-15'),
('Saldão dos Pais', 'Dia dos Pais', '2026-08-01', '2026-08-15'),
('Semana do Brasil', 'Semana do Brasil', '2026-09-01', '2026-09-07');

-- 7. TAXA_COMISSAO (Dependência de: Campanha Vigente)
INSERT INTO taxa_comissao (taxa, id_campanha) VALUES
(5.50, 1), (4.00, 2), (3.50, 3), (6.00, 4), (4.50, 5),
(5.00, 6), (3.00, 7), (2.50, 8), (4.20, 9), (4.80, 10);

-- 8. CATEGORIA (Dependência de: Taxa Comissão)
INSERT INTO categoria (nome_categoria, id_taxa) VALUES
('Eletrônicos', 1), ('Vestuário', 2), ('Livros', 3), ('Esportes', 4), ('Beleza', 5),
('Construção', 6), ('Alimentos', 7), ('Pets', 8), ('Utilidades', 9), ('Informática', 10);

-- 9. PRODUTO (Dependência de: Lojista, Categoria)
INSERT INTO produto (preco, qtd_estoque, nome, id_loja, id_categoria) VALUES
(1200.00, 50, 'Smartphone X1', 1, 1),
(89.90, 120, 'Camiseta Algodão Premium', 2, 2),
(45.00, 30, 'Livro de Banco de Dados', 3, 3),
(150.00, 15, 'Bola de Futebol Oficial', 4, 4),
(75.50, 60, 'Perfume Floral 100ml', 5, 5),
(22.00, 200, 'Argamassa 20kg', 6, 6),
(14.50, 500, 'Café Torrado e Moído', 7, 7),
(120.00, 40, 'Ração Premium Cães 10kg', 8, 8),
(35.00, 80, 'Jogo de Copos de Vidro', 9, 9),
(3500.00, 10, 'Notebook Core i5', 10, 10);

-- 10. PROMOCAO (Dependência de: Nenhuma)
INSERT INTO promocao (data_inicio, data_fim, preco_anterior, preco_promocional) VALUES
('2026-05-01 00:00:00', '2026-05-31 23:59:59', 1200.00, 1050.00),
('2026-05-10 00:00:00', '2026-05-20 23:59:59', 89.90, 69.90),
('2026-05-15 00:00:00', '2026-05-30 23:59:59', 45.00, 35.00),
('2026-06-01 00:00:00', '2026-06-12 23:59:59', 150.00, 130.00),
('2026-05-01 00:00:00', '2026-05-15 23:59:59', 75.50, 59.90),
('2026-07-01 00:00:00', '2026-07-10 23:59:59', 22.00, 18.00),
('2026-05-20 00:00:00', '2026-05-27 23:59:59', 14.50, 11.90),
('2026-08-01 00:00:00', '2026-08-15 23:59:59', 120.00, 99.00),
('2026-05-01 00:00:00', '2026-05-10 23:59:59', 35.00, 28.00),
('2026-05-25 00:00:00', '2026-06-05 23:59:59', 3500.00, 3199.00);

-- 11. PROMO_PROD (Dependência de: Promocao, Produto)
INSERT INTO promo_prod (id_promocao, id_produto) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10);

-- 12. PEDIDO (Dependência de: Cliente)
INSERT INTO pedido (id_cliente, data_pedido, status_pedido) VALUES
(1, '2026-05-26 10:00:00', 'fechado'),
(2, '2026-05-26 11:30:00', 'fechado'),
(3, '2026-05-26 14:15:00', 'fechado'),
(4, '2026-05-26 16:00:00', 'fechado'),
(5, '2026-05-26 18:22:00', 'fechado'),
(6, '2026-05-27 09:00:00', 'fechado'),
(7, '2026-05-27 10:45:00', 'fechado'),
(8, '2026-05-27 11:15:00', 'fechado'),
(9, '2026-05-27 13:00:00', 'fechado'),
(10, '2026-05-27 14:00:00', 'aberto');

-- 13. ITENS_PEDIDO (Dependência de: Pedido, Produto)
INSERT INTO itens_pedido (qtd_item, preco_uni, id_pedido, id_produto) VALUES
(1, 1050.00, 1, 1),
(2, 69.90, 2, 2),
(1, 35.00, 3, 3),
(1, 130.00, 4, 4),
(2, 59.90, 5, 5),
(5, 18.00, 6, 6),
(3, 11.90, 7, 7),
(1, 99.00, 8, 8),
(2, 28.00, 9, 9),
(1, 3500.00, 10, 10);

-- 14. CUPOM (Dependência de: Nenhuma)
INSERT INTO cupom (cod_promocional, taxa_desconto, descricao, origem, status_cupom) VALUES
('BEMVINDO10', 10.00, 'Cupom de boas-vindas da plataforma', 'plataforma', 'ativo'),
('LOJA10OFF', 10.00, 'Desconto especial da Eletro Tech', 'loja', 'ativo'),
('FRETEGRATIS', 15.00, 'Cupom para abatimento de valor frete', 'plataforma', 'ativo'),
('MODA15', 15.00, 'Renove seu guarda-roupa', 'loja', 'ativo'),
('CUPOMMAES', 20.00, 'Especial de Dia das Mães', 'plataforma', 'ativo'),
('LIVROS5', 5.00, 'Incentivo à leitura', 'loja', 'ativo'),
('SUDESTE5', 5.00, 'Desconto regional', 'plataforma', 'ativo'),
('PROMOOUTLET', 30.00, 'Queima de estoque', 'plataforma', 'inativo'),
('PETAMIGO', 12.00, 'Mimo para seu pet', 'loja', 'ativo'),
('TECH50', 50.00, 'Desconto em informática', 'plataforma', 'ativo');

-- 15. APLICA (Dependência de: Cupom, Pedido, Cliente)
-- Garante a amarração correta respeitando a restrição UNIQUE (id_cliente, id_cupom)
INSERT INTO aplica (id_cupom, id_pedido, id_cliente) VALUES
(1, 1, 1), (2, 2, 2), (3, 3, 3), (4, 4, 4), (5, 5, 5),
(6, 6, 6), (7, 7, 7), (8, 8, 8), (9, 9, 9), (10, 10, 10);

-- 16. PAGAMENTO (Dependência de: Cliente, Pedido)
INSERT INTO pagamento (valor_pago, data_pagamento, id_cliente, id_pedido) VALUES
(1040.00, '2026-05-26 10:05:00', 1, 1),
(129.80, '2026-05-26 11:32:00', 2, 2),
(30.00, '2026-05-26 14:20:00', 3, 3),
(115.00, '2026-05-26 16:02:00', 4, 4),
(99.80, '2026-05-26 18:25:00', 5, 5),
(85.00, '2026-05-27 09:05:00', 6, 6),
(30.70, '2026-05-27 10:50:00', 7, 7),
(87.00, '2026-05-27 11:20:00', 8, 8),
(44.00, '2026-05-27 13:05:00', 9, 9),
(3450.00, '2026-05-27 14:05:00', 10, 10);

-- 17. NOTA_FISCAL (Dependência de: Pagamento)
INSERT INTO nota_fiscal (id_pagamento) VALUES
(1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

-- 18. ENTREGA (Dependência de: Nota Fiscal, Entregador, Estado)
INSERT INTO entrega (data_prevista, data_efetiva, status_entrega, id_nota_fiscal, id_estado, cidade, rua, numero, cep, id_entregador) VALUES
('2026-05-30', '2026-05-29', 'entregue', 1, 1, 'Recife', 'Rua Aurora', '123', '50000000', 1),
('2026-05-29', '2026-05-29', 'entregue', 2, 2, 'São Paulo', 'Av Paulista', '1000', '01311000', 2),
('2026-06-02', NULL, 'em transito', 3, 3, 'Rio de Janeiro', 'Rua Copacabana', '45', '22020001', 3),
('2026-05-28', '2026-05-28', 'entregue', 4, 4, 'Belo Horizonte', 'Av Afonso Pena', '500', '30130001', 4),
('2026-06-05', NULL, 'pendente', 5, 5, 'Salvador', 'Rua Barra', '88', '40140000', 5),
('2026-06-01', NULL, 'em transito', 6, 6, 'Curitiba', 'Rua XV de Novembro', '12', '80020000', 6),
('2026-06-03', NULL, 'pendente', 7, 7, 'Porto Alegre', 'Av Ipiranga', '3000', '90160092', 7),
('2026-06-02', NULL, 'em transito', 8, 8, 'Fortaleza', 'Av Beira Mar', '777', '60165121', 8),
('2026-05-30', '2026-05-30', 'entregue', 9, 9, 'Goiânia', 'Av T-9', '432', '74215022', 9),
('2026-06-10', NULL, 'pendente', 10, 10, 'Manaus', 'Av Djalma Batista', '99', '69050010', 10);

-- 19. MOTIVO (Dependência de: Nenhuma)
INSERT INTO motivo (motivo) VALUES
('produto_danificado'), ('produto_errado'), ('arrependimento_compra'), ('atraso_entrega'),
('pedido_cancelado'), ('duplicidade_pagamento'), ('produto_nao_recebido'), ('descricao_divergente'),
('problema_qualidade'), ('outro');

-- 20. REEMBOLSO (Dependência de: Nota Fiscal, Motivo)
INSERT INTO reembolso (status_reembolso, valor_reembolso, id_nota_fiscal, id_motivo) VALUES
('em analise', 1050.00, 1, 1),
('recusado', 20.00, 2, 2),
('disponivel', 35.00, 3, 3),
('em analise', 130.00, 4, 4),
('disponivel', 59.90, 5, 5),
('recusado', 18.00, 6, 6),
('em analise', 11.90, 7, 7),
('disponivel', 99.00, 8, 8),
('em analise', 28.00, 9, 9),
('recusado', 50.00, 10, 10);

-- 21. CASHBACK (Dependência de: Nota Fiscal)
INSERT INTO cashback (valor_cash, status_cash, id_nota_fiscal) VALUES
(10.50, 'disponivel', 1),
(1.40, 'disponivel', 2),
(0.70, 'pendente', 3),
(2.60, 'disponivel', 4),
(1.20, 'pendente', 5),
(0.36, 'indisponivel', 6),
(0.24, 'pendente', 7),
(1.98, 'disponivel', 8),
(0.56, 'pendente', 9),
(70.00, 'pendente', 10);

-- 22. AVALIACAO (Dependência de: Cliente, Produto)
INSERT INTO avaliacao (nota, data_avaliacao, id_cliente, id_produto) VALUES
(5, '2026-05-27', 1, 1),
(4, '2026-05-27', 2, 2),
(5, '2026-05-27', 3, 3),
(3, '2026-05-27', 4, 4),
(4, '2026-05-27', 5, 5),
(2, '2026-05-27', 6, 6),
(5, '2026-05-27', 7, 7),
(4, '2026-05-27', 8, 8),
(1, '2026-05-27', 9, 9),
(5, '2026-05-27', 10, 10);
