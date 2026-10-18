
# GameTech Informática

Projeto final de Modelagem de Banco de Dados — FATEC.

## 1. Cenário
### 1.1 Descrição da empresa

A GameTech Informática é uma empresa fictícia especializada na venda de peças para computadores e acessórios gamer. Seu catálogo inclui processadores, placas de vídeo, memórias RAM, placas-mãe, SSDs, monitores, teclados, mouses e headsets. A loja atende clientes que desejam montar, melhorar ou realizar manutenção em seus computadores.

Para organizar suas atividades, a empresa precisa de um banco de dados que reúna informações sobre clientes, funcionários, produtos, categorias, pedidos, pagamentos e notas fiscais.

### 1.2 Problema identificado

Sem um sistema centralizado, a loja pode enfrentar dificuldades para consultar produtos, acompanhar o estoque, localizar pedidos antigos e identificar os itens mais vendidos. O registro manual também pode provocar informações duplicadas, erros nas quantidades e divergências nos valores das vendas.

### 1.3 Solução proposta

A proposta é desenvolver um banco de dados relacional utilizando PostgreSQL, disponibilizado pela plataforma Supabase. O sistema permitirá cadastrar clientes e funcionários, organizar produtos por categorias, registrar pedidos e seus itens, controlar pagamentos e armazenar informações das notas fiscais.

### 1.4 Entidades e atributos

O banco de dados será composto por nove entidades:

**Cliente:** id_cliente (PK), nome, sobrenome, email, cpf, data_nascimento, rua, numero, bairro, cidade, estado, cep e data_cadastro.

**Cliente_Telefone:** id_telefone (PK), id_cliente (FK), numero_telefone e tipo_telefone.

**Funcionario:** id_funcionario (PK), nome, sobrenome, email, cargo, data_admissao e salario.

**Categoria:** id_categoria (PK), nome e descricao.

**Produto:** id_produto (PK), id_categoria (FK), id_funcionario (FK), nome, descricao, marca, preco, quantidade_estoque e data_cadastro.

**Pedido:** id_pedido (PK), id_cliente (FK), data_pedido, status_pedido e endereco_entrega.

**Item_Pedido:** id_pedido (PK/FK), id_produto (PK/FK), quantidade e preco_unitario. A chave primária é composta por id_pedido e id_produto.

**Pagamento:** id_pagamento (PK), id_pedido (FK com restrição UNIQUE), forma_pagamento, valor_pago, status_pagamento e data_pagamento.

**Nota_Fiscal:** id_nota_fiscal (PK), id_pedido (FK com restrição UNIQUE), numero_nota, data_emissao e valor_total.

### 1.5 Tipos de atributos

Os atributos simples são representados por informações como nome, email, marca e preco.

O endereço do cliente é um atributo composto, pois pode ser dividido em rua, numero, bairro, cidade, estado e cep.

O telefone é um atributo multivalorado, porque um cliente pode possuir vários números. Para representar isso no banco relacional, foi criada a entidade Cliente_Telefone.

O valor total do pedido é um atributo derivado, calculado pela soma dos resultados de quantidade multiplicada pelo preco_unitario de cada item.

As chaves primárias identificam os registros de cada entidade. Na entidade Item_Pedido, a identificação utiliza uma chave primária composta.

### 1.6 Relacionamentos

- Cliente e Pedido: 1:N.
- Cliente e Cliente_Telefone: 1:N.
- Categoria e Produto: 1:N.
- Funcionario e Produto: 1:N.
- Pedido e Item_Pedido: 1:N.
- Produto e Item_Pedido: 1:N.
- Pedido e Produto: N:N, resolvido pela entidade Item_Pedido.
- Pedido e Pagamento: 1:1.
- Pedido e Nota_Fiscal: 1:1.

### 1.7 Regras de negócio

Cada cliente possui um identificador único e pode cadastrar mais de um telefone.

Cada produto pertence a uma categoria e possui um funcionário responsável pelo seu cadastro.

Um cliente pode realizar vários pedidos, mas cada pedido pertence a apenas um cliente.

Cada pedido deve possuir pelo menos um item, e a quantidade de produtos registrada deve ser maior que zero.

O preço do produto no momento da venda será armazenado em Item_Pedido, preservando o histórico mesmo quando o preço do catálogo mudar.

O valor total do pedido será calculado a partir de seus itens.

Cada pedido deverá possuir um registro de pagamento e uma nota fiscal, conforme as regras definidas para este projeto.

As chaves estrangeiras serão utilizadas para manter a integridade dos relacionamentos entre as tabelas.

### 1.8 Objetivo do projeto

O objetivo é construir um banco de dados relacional capaz de organizar as operações da GameTech Informática, aplicando modelagem conceitual, lógica e física, inserção de dados, operações CRUD e consultas SQL para geração de relatórios.


## 2. Modelagem Conceitual

O diagrama abaixo representa as entidades e os relacionamentos do sistema.

![DER da GameTech](der_gametech_completo.png)


  
## 3. Modelagem Lógica

A modelagem lógica da GameTech Informática foi desenvolvida a partir do Diagrama Entidade-Relacionamento (DER). Foram definidas nove tabelas, seus atributos, tipos de dados, chaves primárias (PK), chaves estrangeiras (FK) e restrições de integridade.

### 3.1 Cliente

| Atributo | Tipo de dado | Restrição |
|---|---|---|
| id_cliente | INTEGER | PK |
| nome | VARCHAR(100) | NOT NULL |
| sobrenome | VARCHAR(100) | NOT NULL |
| email | VARCHAR(150) | UNIQUE |
| cpf | CHAR(11) | UNIQUE |
| data_nascimento | DATE | |
| rua | VARCHAR(150) | |
| numero | VARCHAR(10) | |
| bairro | VARCHAR(100) | |
| cidade | VARCHAR(100) | |
| estado | CHAR(2) | |
| cep | CHAR(8) | |
| data_cadastro | TIMESTAMP | |

### 3.2 Cliente_Telefone

| Atributo | Tipo de dado | Restrição |
|---|---|---|
| id_telefone | INTEGER | PK |
| id_cliente | INTEGER | FK → Cliente(id_cliente), NOT NULL |
| numero_telefone | VARCHAR(15) | NOT NULL |
| tipo_telefone | VARCHAR(20) | |

### 3.3 Funcionario

| Atributo | Tipo de dado | Restrição |
|---|---|---|
| id_funcionario | INTEGER | PK |
| nome | VARCHAR(100) | NOT NULL |
| sobrenome | VARCHAR(100) | NOT NULL |
| email | VARCHAR(150) | UNIQUE |
| cargo | VARCHAR(80) | |
| data_admissao | DATE | |
| salario | NUMERIC(10,2) | CHECK (salario >= 0) |

### 3.4 Categoria

| Atributo | Tipo de dado | Restrição |
|---|---|---|
| id_categoria | INTEGER | PK |
| nome | VARCHAR(100) | NOT NULL, UNIQUE |
| descricao | TEXT | |

### 3.5 Produto

| Atributo | Tipo de dado | Restrição |
|---|---|---|
| id_produto | INTEGER | PK |
| id_categoria | INTEGER | FK → Categoria(id_categoria), NOT NULL |
| id_funcionario | INTEGER | FK → Funcionario(id_funcionario), NOT NULL |
| nome | VARCHAR(150) | NOT NULL |
| descricao | TEXT | |
| marca | VARCHAR(100) | |
| preco | NUMERIC(10,2) | CHECK (preco >= 0) |
| quantidade_estoque | INTEGER | CHECK (quantidade_estoque >= 0) |
| data_cadastro | TIMESTAMP | |

### 3.6 Pedido

| Atributo | Tipo de dado | Restrição |
|---|---|---|
| id_pedido | INTEGER | PK |
| id_cliente | INTEGER | FK → Cliente(id_cliente), NOT NULL |
| data_pedido | TIMESTAMP | |
| status_pedido | VARCHAR(30) | |
| endereco_entrega | TEXT | |

### 3.7 Item_Pedido

| Atributo | Tipo de dado | Restrição |
|---|---|---|
| id_pedido | INTEGER | PK composta, FK → Pedido(id_pedido) |
| id_produto | INTEGER | PK composta, FK → Produto(id_produto) |
| quantidade | INTEGER | NOT NULL, CHECK (quantidade > 0) |
| preco_unitario | NUMERIC(10,2) | NOT NULL, CHECK (preco_unitario >= 0) |

Chave primária composta: (id_pedido, id_produto).

### 3.8 Pagamento

| Atributo | Tipo de dado | Restrição |
|---|---|---|
| id_pagamento | INTEGER | PK |
| id_pedido | INTEGER | FK → Pedido(id_pedido), NOT NULL, UNIQUE |
| forma_pagamento | VARCHAR(30) | |
| valor_pago | NUMERIC(10,2) | CHECK (valor_pago >= 0) |
| status_pagamento | VARCHAR(30) | |
| data_pagamento | TIMESTAMP | |

### 3.9 Nota_Fiscal

| Atributo | Tipo de dado | Restrição |
|---|---|---|
| id_nota_fiscal | INTEGER | PK |
| id_pedido | INTEGER | FK → Pedido(id_pedido), NOT NULL, UNIQUE |
| numero_nota | VARCHAR(50) | UNIQUE |
| data_emissao | TIMESTAMP | |
| valor_total | NUMERIC(10,2) | CHECK (valor_total >= 0) |

### 3.10 Relacionamentos e regras de integridade

- Cliente 1:N Pedido.
- Cliente 1:N Cliente_Telefone.
- Categoria 1:N Produto.
- Funcionario 1:N Produto.
- Pedido 1:N Item_Pedido.
- Produto 1:N Item_Pedido.
- Pedido N:N Produto, resolvido por Item_Pedido.
- Pedido 1:1 Pagamento.
- Pedido 1:1 Nota_Fiscal.

A restrição UNIQUE nas tabelas Pagamento e Nota_Fiscal impede múltiplos registros associados ao mesmo pedido. A obrigatoriedade de existência desses registros e de pelo menos um item por pedido será tratada nas regras de implementação e no fluxo das operações.

O total de cada pedido será calculado pela soma de quantidade × preco_unitario de seus itens. O valor_total da nota fiscal deverá corresponder a esse resultado.
  
