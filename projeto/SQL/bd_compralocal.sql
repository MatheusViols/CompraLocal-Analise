CREATE DATABASE CompraLocal;
USE CompraLocal;

CREATE TABLE cliente (
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
	cpf CHAR(11) NOT NULL UNIQUE CHECK (cpf REGEXP '^[0-9]{11}$'),
	email VARCHAR (50) NOT NULL UNIQUE,
	nome VARCHAR (100) NOT NULL,
	senha VARCHAR (150) NOT NULL
);

CREATE TABLE estado (
	id_estado INT PRIMARY KEY AUTO_INCREMENT,
    nome_estado ENUM (
		'AC', 'AL', 'AM', 'AP', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MG',
		'MS', 'MT', 'PA', 'PI', 'PB', 'PE', 'PR', 'RJ', 'RN', 'RO', 'RR',
		'RS', 'SC', 'SE', 'SP', 'TO') NOT NULL,
    regiao ENUM (
		'CENTRO-OESTE'
		,'NORTE',
		'NORDESTE',
        'SUL',
        'SUDESTE') NOT NULL
);

CREATE TABLE endereco_cliente (
	id_endereco INT PRIMARY KEY AUTO_INCREMENT,
	id_estado INT NOT NULL,
    id_cliente INT NOT NULL,
	cidade VARCHAR (100) NOT NULL,
	rua VARCHAR (150) NOT NULL,
	numero VARCHAR (8) NOT NULL CHECK (numero REGEXP '^[0-9]+$'),
	cep CHAR (8) NOT NULL CHECK (cep REGEXP '^[0-9]{8}$'),
	num_telefone CHAR (11) NOT NULL CHECK (num_telefone REGEXP '^[0-9]{11}$'),

	FOREIGN KEY (id_cliente)
    REFERENCES cliente (id_cliente),

	FOREIGN KEY (id_estado)
    REFERENCES estado (id_estado)
);

CREATE TABLE lojista (
	id_loja INT PRIMARY KEY AUTO_INCREMENT,
	email VARCHAR (50) NOT NULL UNIQUE,
	senha VARCHAR (150) NOT NULL,
	cnpj CHAR (14) NOT NULL UNIQUE CHECK (cnpj REGEXP '^[0-9]{14}$'),
	nome_loja VARCHAR (100) NOT NULL,
	cep CHAR (8) NOT NULL CHECK (cep REGEXP '^[0-9]{8}$'),
	id_estado INT,
	cidade VARCHAR (100) NOT NULL,
	rua VARCHAR (150) NOT NULL,
	numero VARCHAR (8) NOT NULL CHECK (numero REGEXP '^[0-9]+$'),
	UNIQUE (cep, cidade, rua, numero),

	FOREIGN KEY (id_estado)
    REFERENCES estado (id_estado)
);

CREATE TABLE entregador (
	id_entregador INT PRIMARY KEY AUTO_INCREMENT,
	cpf CHAR (11) NOT NULL UNIQUE CHECK (cpf REGEXP '^[0-9]{11}$'),
	nome VARCHAR (100) NOT NULL,
	senha VARCHAR (150) NOT NULL,
	email VARCHAR (100) NOT NULL UNIQUE,
	id_estado INT,
	cidade VARCHAR (100) NOT NULL,
	rua VARCHAR (100) NOT NULL,
	numero VARCHAR (10) NOT NULL CHECK (numero REGEXP '^[0-9A-Za-z]+$'),
	cep CHAR (8) NOT NULL CHECK (cep REGEXP '^[0-9]{8}$'),

	FOREIGN KEY (id_estado)
    REFERENCES estado (id_estado)
);

CREATE TABLE campanha_vigente (
	id_campanha INT PRIMARY KEY AUTO_INCREMENT,
	descricao VARCHAR (300) NOT NULL,
	nome VARCHAR(150) NOT NULL,
	data_inicio DATE NOT NULL,
	data_fim DATE NOT NULL
);

CREATE TABLE taxa_comissao (
	id_taxa INT PRIMARY KEY AUTO_INCREMENT,
	taxa DECIMAL NOT NULL,
	id_campanha INT NOT NULL,

	FOREIGN KEY (id_campanha)
	REFERENCES campanha_vigente (id_campanha)
);

CREATE TABLE categoria (
	id_categoria INT PRIMARY KEY AUTO_INCREMENT,
	nome_categoria VARCHAR (50) NOT NULL,
	id_taxa INT NOT NULL,

	FOREIGN KEY (id_taxa)
	REFERENCES taxa_comissao (id_taxa)
);

CREATE TABLE produto (
	id_produto INT PRIMARY KEY AUTO_INCREMENT,
	preco DECIMAL NOT NULL,
	qtd_estoque INT NOT NULL,
	nome VARCHAR (100) NOT NULL,
	id_loja INT NOT NULL,
	id_categoria INT NOT NULL,

	FOREIGN KEY (id_loja)
	REFERENCES lojista (id_loja),

	FOREIGN KEY (id_categoria)
	REFERENCES categoria (id_categoria)
);

CREATE TABLE promocao (
	id_promocao INT PRIMARY KEY AUTO_INCREMENT,
	data_inicio DATETIME NOT NULL,
	data_fim DATETIME NOT NULL,
	preco_anterior DECIMAL NOT NULL,
	preco_promocional DECIMAL NOT NULL
);

CREATE TABLE promo_prod (
	id_promocao INT NOT NULL,
	id_produto INT NOT NULL,

	FOREIGN KEY (id_promocao)
	REFERENCES promocao (id_promocao),

	FOREIGN KEY (id_produto)
	REFERENCES produto (id_produto),
    
    PRIMARY KEY (id_promocao, id_produto)
);

CREATE TABLE pedido (
	id_pedido INT PRIMARY KEY AUTO_INCREMENT,
	id_cliente INT NOT NULL,
	data_pedido DATETIME NOT NULL,
    status_pedido ENUM (
		'aberto',
        'fechado',
        'cancelado') 
        DEFAULT 'aberto' NOT NULL,

	FOREIGN KEY (id_cliente)
    REFERENCES cliente (id_cliente)
);

CREATE TABLE itens_pedido (
	id_item_pedido INT PRIMARY KEY AUTO_INCREMENT,
	qtd_item INT NOT NULL,
	preco_uni DECIMAL NOT NULL,
	id_pedido INT NOT NULL,
	id_produto INT NOT NULL,

	FOREIGN KEY (id_pedido)
    REFERENCES pedido (id_pedido),

	FOREIGN KEY (id_produto)
    REFERENCES produto (id_produto)
);

CREATE TABLE cupom (
	id_cupom INT PRIMARY KEY AUTO_INCREMENT,
	cod_promocional VARCHAR (20) NOT NULL,
	taxa_desconto DECIMAL NOT NULL,
	descricao VARCHAR (100) NOT NULL,
	origem ENUM ('loja', 'plataforma') DEFAULT 'plataforma' NOT NULL,
	status_cupom ENUM ('ativo', 'inativo') DEFAULT 'ativo' NOT NULL
);

CREATE TABLE aplica (
	id_cupom INT NOT NULL,
    id_pedido INT NOT NULL,
    id_cliente INT NOT NULL,

	FOREIGN KEY (id_cupom)
	REFERENCES cupom (id_cupom),

	FOREIGN KEY (id_pedido)
	REFERENCES pedido (id_pedido),

	FOREIGN KEY (id_cliente)
    REFERENCES cliente (id_cliente),
    
	PRIMARY KEY (id_cupom, id_pedido),
    
    UNIQUE (id_cliente, id_cupom)
);

CREATE TABLE pagamento (
	id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
	valor_pago DECIMAL NOT NULL,
	data_pagamento DATETIME NOT NULL,
	id_cliente INT NOT NULL,
	id_pedido INT NOT NULL,

	FOREIGN KEY (id_cliente)
	REFERENCES cliente (id_cliente),

	FOREIGN KEY (id_pedido)
	REFERENCES pedido (id_pedido)
);

CREATE TABLE nota_fiscal (
	id_nota_fiscal INT PRIMARY KEY AUTO_INCREMENT,
	id_pagamento INT NOT NULL,
    
    FOREIGN KEY (id_pagamento)
    REFERENCES pagamento (id_pagamento)
);

CREATE TABLE entrega (
	id_entrega INT PRIMARY KEY AUTO_INCREMENT,
	data_prevista DATE NOT NULL,
	data_efetiva DATE,
	status_entrega ENUM (
		'pendente',
		'em transito',
		'entregue',
		'cancelada'
	) DEFAULT 'em transito' NOT NULL,
	id_nota_fiscal INT,
	id_estado INT,
	cidade VARCHAR (100) NOT NULL,
	rua VARCHAR (150) NOT NULL,
	numero VARCHAR (8) NOT NULL,
	cep CHAR (8) NOT NULL CHECK (cep REGEXP '^[0-9]{8}$'),
	id_entregador INT NOT NULL,
    
    FOREIGN KEY (id_nota_fiscal)
    REFERENCES nota_fiscal (id_nota_fiscal),

	FOREIGN KEY (id_entregador)
    REFERENCES entregador (id_entregador),

	FOREIGN KEY (id_estado)
    REFERENCES estado (id_estado)
);

CREATE TABLE motivo (
	id_motivo INT PRIMARY KEY AUTO_INCREMENT,
	motivo ENUM (
		'produto_danificado',
		'produto_errado',
		'produto_incompleto',
		'produto_com_defeito',
		'arrependimento_compra',
		'atraso_entrega',
		'pedido_cancelado',
		'duplicidade_pagamento',
		'produto_nao_recebido',
		'descricao_divergente',
		'problema_qualidade',
		'cobranca_indevida',
		'outro')
);

CREATE TABLE reembolso (
	id_reembolso INT PRIMARY KEY AUTO_INCREMENT,
	status_reembolso ENUM (
		'disponivel',
		'recusado',
		'em analise'
	) DEFAULT 'em analise' NOT NULL,

	valor_reembolso DECIMAL NOT NULL,
	id_nota_fiscal INT NOT NULL,
	id_motivo INT NOT NULL,

	FOREIGN KEY (id_nota_fiscal)
	REFERENCES nota_fiscal (id_nota_fiscal),

	FOREIGN KEY (id_motivo)
	REFERENCES motivo (id_motivo)
);

CREATE TABLE cashback (
	id_cashback INT PRIMARY KEY AUTO_INCREMENT,
	valor_cash DECIMAL NOT NULL,

	status_cash ENUM (
		'pendente',
		'disponivel',
		'indisponivel'
	) DEFAULT 'pendente' NOT NULL,

	id_nota_fiscal INT NOT NULL,

	FOREIGN KEY (id_nota_fiscal)
	REFERENCES nota_fiscal (id_nota_fiscal)
);

CREATE TABLE avaliacao (
	id_avaliacao INT PRIMARY KEY AUTO_INCREMENT,
	nota INT NOT NULL CHECK (nota BETWEEN 1 AND 5),
	data_avaliacao DATE NOT NULL,
	id_cliente INT NOT NULL,
	id_produto INT NOT NULL,

	FOREIGN KEY (id_cliente)
    REFERENCES cliente (id_cliente),

	FOREIGN KEY (id_produto)
    REFERENCES produto (id_produto)
);