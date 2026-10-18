-- GameTech Informática
-- Modelo físico: criação das nove tabelas
-- Execute em um banco vazio. Não execute novamente no projeto Supabase já preenchido.

CREATE TABLE cliente (
    id_cliente INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    cpf CHAR(11) UNIQUE,
    data_nascimento DATE,
    rua VARCHAR(150),
    numero VARCHAR(10),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado CHAR(2),
    cep CHAR(8),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE funcionario (
    id_funcionario INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    cargo VARCHAR(80),
    data_admissao DATE,
    salario NUMERIC(10,2) CHECK (salario >= 0)
);

CREATE TABLE IF NOT EXISTS categoria (
    id_categoria INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT
);

CREATE TABLE cliente_telefone (
    id_telefone INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    numero_telefone VARCHAR(15) NOT NULL,
    tipo_telefone VARCHAR(20),
    CONSTRAINT fk_cliente_telefone
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
);

CREATE TABLE produto (
    id_produto INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_categoria INTEGER NOT NULL,
    id_funcionario INTEGER NOT NULL,
    nome VARCHAR(150) NOT NULL,
    descricao TEXT,
    marca VARCHAR(100),
    preco NUMERIC(10,2) CHECK (preco >= 0),
    quantidade_estoque INTEGER CHECK (quantidade_estoque >= 0),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_produto_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria),
    CONSTRAINT fk_produto_funcionario
        FOREIGN KEY (id_funcionario)
        REFERENCES funcionario(id_funcionario)
);

CREATE TABLE pedido (
    id_pedido INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_pedido VARCHAR(30),
    endereco_entrega TEXT,
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
);

CREATE TABLE item_pedido (
    id_pedido INTEGER NOT NULL,
    id_produto INTEGER NOT NULL,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario NUMERIC(10,2) NOT NULL CHECK (preco_unitario >= 0),
    CONSTRAINT pk_item_pedido
        PRIMARY KEY (id_pedido, id_produto),
    CONSTRAINT fk_item_pedido_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedido(id_pedido),
    CONSTRAINT fk_item_pedido_produto
        FOREIGN KEY (id_produto)
        REFERENCES produto(id_produto)
);

CREATE TABLE pagamento (
    id_pagamento INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pedido INTEGER NOT NULL UNIQUE,
    forma_pagamento VARCHAR(50) NOT NULL,
    valor_pago NUMERIC(10,2) NOT NULL CHECK (valor_pago >= 0),
    status_pagamento VARCHAR(30),
    data_pagamento TIMESTAMP,
    CONSTRAINT fk_pagamento_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedido(id_pedido)
);

CREATE TABLE nota_fiscal (
    id_nota_fiscal INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pedido INTEGER NOT NULL UNIQUE,
    numero_nota VARCHAR(50) NOT NULL UNIQUE,
    data_emissao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor_total NUMERIC(10,2) NOT NULL CHECK (valor_total >= 0),
    CONSTRAINT fk_nota_fiscal_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedido(id_pedido)
);
