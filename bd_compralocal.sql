CREATE DATABASE CompraLocal;
USE CompraLocal;

CREATE TABLE cliente (
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    cpf CHAR(11) UNIQUE CHECK (cpf REGEXP '^[0-9]{11}$'),
    email VARCHAR (50) UNIQUE,
    nome VARCHAR (100),
    senha VARCHAR (150) NOT NULL
    );
CREATE TABLE endereco_cliente (
	id_endereco INT PRIMARY KEY AUTO_INCREMENT,
    estado CHAR (2) CHECK (estado REGEXP '^[A-Z]{2}$'),
    cidade VARCHAR (100),
    rua VARCHAR (150),
    numero VARCHAR (8) CHECK (numero REGEXP '^[0-9]$'),
    cep CHAR (8) CHECK (cep REGEXP '^[0-9]{8}$'),
    num_telefone CHAR (11) CHECK (num_telefone REGEXP '^[0-9]$')
    );
CREATE TABLE reside (
	id_endereco INT,
    id_cliente INT,
    PRIMARY KEY (id_endereco, id_cliente),
    FOREIGN KEY (id_endereco) REFERENCES endereco_cliente (id_endereco),
    FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
    );
CREATE TABLE carrinho (
	id_carrinho INT PRIMARY KEY AUTO_INCREMENT
    );
CREATE TABLE cupom (
id_cupom INT PRIMARY KEY AUTO_INCREMENT,
cod_promocional VARCHAR (20),
descricao VARCHAR (100),
origem ENUM ('aplicavel', 'inaplicavel'),
STATUS ENUM ('ativo', 'inativo')
);
CREATE TABLE aplica (
id_cupom INT,
id_carrinho INT,
PRIMARY KEY (id_cupom, id_carrinho),
FOREIGN KEY (id_cupom) REFERENCES cupom (id_cupom),
FOREIGN KEY (id_carrinho) REFERENCES carrinho (id_carrinho)
);
CREATE TABLE lojista (
	id_loja INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR (50) UNIQUE,
    senha VARCHAR (150) NOT NULL,
    cnpj CHAR (14) UNIQUE CHECK (cnpj REGEXP '^[0-9]{14}$'),
    nome_loja VARCHAR (100),
    cep CHAR (8) CHECK (cep REGEXP '^[0-9]{8}$'),
    estado CHAR (2) CHECK (estado REGEXP '^[A-Z]{2}$'),
    cidade VARCHAR (100),
    rua VARCHAR (150),
    numero VARCHAR (8) CHECK (numero REGEXP '^[0-9]$'),
    UNIQUE (cep, estado, cidade, rua, numero)
    );
CREATE TABLE entregador (
	id_entregador INT PRIMARY KEY AUTO_INCREMENT,
    cpf CHAR (11) UNIQUE CHECK (cpf REGEXP '^[0-9]{11}$'),
    nome VARCHAR (100),
    senha VARCHAR (150),
    email VARCHAR (100) UNIQUE,
    estado CHAR (2) CHECK (estado REGEXP '^[A-Z]{2}+$'),
    cidade VARCHAR (100),
    rua VARCHAR (100),
    numero VARCHAR (10) CHECK (numero REGEXP '^[0-9A-Za-z]+$'),
    cep CHAR (8) CHECK (cep REGEXP '^[0-9]{8}$')
	);
    CREATE TABLE entrega (
    id_entrega INT PRIMARY KEY AUTO_INCREMENT,
    data_prevista DATE,
    data_efetiva DATE,
    status_entrega ENUM ('pendente', 'em transito', 'entregue', 'cancelada'),
    estado CHAR (2) CHECK (estado REGEXP '^[A-Z]$'),
    cidade VARCHAR (100),
    rua VARCHAR (150),
    numero VARCHAR (8),
    cep CHAR (8) CHECK (cep REGEXP '^[0-9]{8}$'),
    id_entregador INT,
    FOREIGN KEY (id_entregador) REFERENCES entregador (id_entregador)
    );
CREATE TABLE motivo (
	id_motivo INT PRIMARY KEY AUTO_INCREMENT,
    motivo TEXT
    );
CREATE TABLE nota_fiscal (
	id_nota_fiscal INT PRIMARY KEY AUTO_INCREMENT,
    id_entrega INT,
    FOREIGN KEY (id_entrega) REFERENCES entrega (id_entrega)
    );
CREATE TABLE reembolso (
	id_reembolso INT PRIMARY KEY AUTO_INCREMENT,
    status_reembolso ENUM ('pendente', 'disponivel', 'indisponivel', 'em analise'),
    valor_reembolso DECIMAL,
    id_nota_fiscal INT,
    id_motivo INT,
    FOREIGN KEY (id_nota_fiscal) REFERENCES nota_fiscal (id_nota_fiscal),
    FOREIGN KEY (id_motivo) REFERENCES motivo (id_motivo)
    );
CREATE TABLE cashback (
	id_cashback INT PRIMARY KEY AUTO_INCREMENT,
    valor_cash DECIMAL,
    status_cash ENUM ('pendente', 'disponível', 'indisponível'),
    id_nota_fiscal INT,
    FOREIGN KEY (id_nota_fiscal) REFERENCES nota_fiscal (id_nota_fiscal)
    );
CREATE TABLE campanha_vigente (
	id_campanha INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR (300),
    nome VARCHAR(150),
    data_inicio DATE,
    data_fim DATE
    );
CREATE TABLE taxa_comissao (
	id_taxa INT PRIMARY KEY AUTO_INCREMENT,
    taxa DECIMAL,
    id_campanha INT,
    FOREIGN KEY (id_campanha) REFERENCES campanha_vigente (id_campanha)
    );
CREATE TABLE categoria (
	id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nome_categoria VARCHAR (50),
    id_taxa INT,
    FOREIGN KEY (id_taxa) REFERENCES taxa_comissao (id_taxa)
    );
CREATE TABLE promocao (
	id_promocao INT PRIMARY KEY AUTO_INCREMENT,
	data_inicio DATETIME,
	data_fim DATETIME,
	preco_anterior DECIMAL,
	preco_promocional DECIMAL
);
CREATE TABLE produto (
	id_produto INT PRIMARY KEY AUTO_INCREMENT,
	preco DECIMAL,
	qtd_estoque INT,
	nome VARCHAR (100),
	id_lojista INT,
	id_categoria INT,
	id_promocao INT,
	FOREIGN KEY (id_lojista) REFERENCES lojista (id_lojista),
	FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria),
	FOREIGN KEY (id_promocao) REFERENCES promocao (id_promocao)
	);
CREATE TABLE avaliacao (
	id_avaliacao INT PRIMARY KEY AUTO_INCREMENT,
    nota INT CHECK (nota BETWEEN 1 AND 5),
    data_avaliacao DATE,
    id_cliente INT,
    id_produto INT,
    FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente),
    FOREIGN KEY (id_produto) REFERENCES produto (id_produto)
    );
CREATE TABLE pedido (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_carrinho INT,
    FOREIGN KEY (id_carrinho) REFERENCES carrinho (id_carrinho)
    );
CREATE TABLE itens_pedido (
    id_item_pedido INT PRIMARY KEY AUTO_INCREMENT,
    qtd_item INT,
    preco_uni DECIMAL,
    id_pedido INT,
    id_produto INT,
    FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido),
    FOREIGN KEY (id_produto) REFERENCES produto (id_produto)
    );
CREATE TABLE pagamento (
	id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    valor_pago DECIMAL,
    data_pagamento DATETIME,
    id_nota_fiscal INT,
    id_cliente INT,
    id_pedido INT,
    FOREIGN KEY (id_nota_fiscal) REFERENCES nota_fiscal (id_nota_fiscal),
    FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente),
    FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido)
	);