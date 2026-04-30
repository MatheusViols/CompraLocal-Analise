create database CompraLocal;
use CompraLocal;
create table cliente (
	cpf char (11) primary key,
    nome varchar (100) not null,
    email varchar (100) unique,
    senha varchar (255) not null
    );
create table endereco_cliente (
	id_endereco int auto_increment primary key,
    num_telefone char (11),
    cpf_cliente char (11),
    estado char (2),
    rua varchar (100),
    numero varchar (10),
    cep char (8),
    cidade varchar (25),
    foreign key (cpf_cliente) references cliente(cpf)
    );
    create table categoria (
	nome_cat varchar (25) unique,
	id_categoria int auto_increment primary key
	);
    create table produto (
	id_produto int auto_increment primary key,
    nome_produto varchar (100) not null,
    preco decimal (10,2) not null,
    qtd_estoque int not null,
    id_categoria int,
    foreign key (id_categoria) references categoria(id_categoria)
    );
create table avaliacao (
	id_avaliacao int auto_increment primary key,
    nota int check (nota between 0 and 5),
    cpf char (11),
    id_produto int,
    data_avaliacao date,
    foreign key (cpf_cliente) references cliente(CPF),
    foreign key (id_produto) references produto(id_produto)
    );
create table promocao (
	id_promocao int auto_increment primary key,
    data_inicio date,
    data_fim date,
    preco_anterior decimal (10,2) not null,
    preco_promocional decimal (10,2) not null,
    id_produto int,
    foreign key (id_produto) references produto(id_produto)
    );
create table lojista (
	id_loja int auto_increment primary key,
    cnpj char (14) not null,
    senha varchar (250) not null,
    email_lojista varchar (100) unique,
    nome_loja varchar (100) not null
    );
create table endereco_lojista (
	id_endereco int auto_increment primary key,
    id_loja int,
    rua varchar (100),
    numero varchar (10),
    cidade varchar (100),
    estado char (2),
    cep char (8),
    foreign key (id_loja) references lojista(id_loja)
    );
create table carrinho (
	id_carrinho int auto_increment primary key
    );
create table itens_carrinho (
	id_item int auto_increment primary key,
    qtd_item int not null,
    preco_unidade decimal (10,2) not null,
    id_carrinho int,
    id_produto int,
    foreign key (id_carrinho) references carrinho (id_carrinho),
    foreign key (id_produto) references produto(id_produto)
    );
 create table pedido (
    id_pedido int auto_increment primary key,
    id_carrinho int,
    cpf_cliente char(11) not null,
    data_pedido date,
    foreign key (cpf_cliente) references cliente(cpf),
    foreign key (id_carrinho) references carrinho(id_carrinho)
    );
    create table pagamento (
	id_pagamento int auto_increment primary key,
    valor_pago decimal (10,2) not null,
    id_pedido int,
    foreign key (id_pedido) references pedido (id_pedido)
    );
	create table taxa_comissao (
	id_taxa int auto_increment primary key,
    taxa decimal (10,2) not null
    );
create table campanha_vigente (
	id_campanha int auto_increment primary key,
    nome_campanha varchar (50),
    descricao text,
    data_inicio datetime,
    data_fim datetime
    );
create table nota_fiscal (
	id_nota int auto_increment primary key,
    foreign key (chave) references itens_carrinho (chave)
    );
create table reembolso (
	id_reembolso int auto_increment primary key,
    valor_reembolso decimal (10,2),
    status_reembolso enum ('Pendente', 'Em_analise','Feito', 'recusado')
    );
create table motivo (
	id_motivo int auto_increment primary key,
    motivo text
    );
create table cashback (
	id_cashback int auto_increment primary key,
    valor_cashback decimal (10,2),
    status_cashback enum ('Feito', 'Pendente', 'Em_analise', 'recusado')
    );
create table entrega (
	id_entrega int auto_increment primary key,
    status_entrega enum ('Em_transito', 'Em_preparacao', 'Entregue', 'Cancelado'),
    data_prevista date,
    data_efetiva date,
    
    rua_entrega varchar (100),
    cep_entrega char(8),
    cidade_entrega varchar(50),
    numero_entrega varchar (10),
    estado_entrega char(2)
    );
create table entregador (
id_entregador int auto_increment primary key,
cpf_entregador char(11),
email_entregador varchar(50) not null,
senha_entregador varchar(255) not null,
nome_entregador varchar (100) not null,

estado_entregador char(2),
rua_entregador varchar(100),
cep_entregador char(8),
numero_entregador varchar (10),
cidade_entregador varchar(50)
);
 