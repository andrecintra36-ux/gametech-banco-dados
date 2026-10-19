script de inserção das 9 tabelas
  

-- 1. CLIENTE
INSERT INTO public.cliente
    (nome, sobrenome, email, cpf, data_nascimento,
     rua, numero, bairro, cidade, estado, cep)
SELECT
    'Cliente' || n,
    'GameTech' || n,
    'cliente' || n || '@gametech.exemplo',
    LPAD(n::text, 11, '0'),
    DATE '1990-01-01' + (n % 10000),
    'Rua Gamer ' || n,
    n::text,
    'Centro',
    'Franca',
    'SP',
    '14400000'
FROM generate_series(1, 500) AS n;

-- 2. FUNCIONARIO
INSERT INTO public.funcionario
    (nome, sobrenome, email, cargo, data_admissao, salario)
SELECT
    'Funcionario' || n,
    'GameTech' || n,
    'funcionario' || n || '@gametech.exemplo',
    (ARRAY['Vendedor', 'Tecnico', 'Estoquista', 'Gerente'])
        [((n - 1) % 4) + 1],
    DATE '2020-01-01' + n,
    (1800 + n * 100)::numeric(10,2)
FROM generate_series(1, 500) AS n;

-- 3. CATEGORIA
INSERT INTO public.categoria (nome, descricao)
SELECT
    'Categoria Gamer ' || n,
    'Categoria ficticia de informatica numero ' || n
FROM generate_series(1, 500) AS n;

-- 4. CLIENTE_TELEFONE
INSERT INTO public.cliente_telefone
    (id_cliente, numero_telefone, tipo_telefone)
SELECT
    c.id_cliente,
    '169' || LPAD(
        ROW_NUMBER() OVER (ORDER BY c.id_cliente)::text,
        8, '0'
    ),
    'Celular'
FROM public.cliente c
ORDER BY c.id_cliente
LIMIT 500;

-- 5. PRODUTO
WITH categorias AS (
    SELECT id_categoria,
           ROW_NUMBER() OVER (ORDER BY id_categoria) AS rn
    FROM public.categoria
),
funcionarios AS (
    SELECT id_funcionario,
           ROW_NUMBER() OVER (ORDER BY id_funcionario) AS rn
    FROM public.funcionario
)
INSERT INTO public.produto
    (id_categoria, id_funcionario, nome, descricao,
     marca, preco, quantidade_estoque)
SELECT
    c.id_categoria,
    f.id_funcionario,
    (ARRAY[
        'Processador Gamer',
        'Memoria RAM Gamer',
        'Teclado Gamer',
        'Mouse Gamer',
        'Placa de Video Gamer'
    ])[((n - 1) % 5) + 1] || ' ' || n,
    'Produto ficticio da GameTech numero ' || n,
    (ARRAY['Kingston', 'AMD', 'Corsair', 'Logitech'])
        [((n - 1) % 4) + 1],
    (100 + n * 7.5)::numeric(10,2),
    10 + (n % 60)
FROM generate_series(1, 500) AS n
JOIN categorias c ON c.rn = n
JOIN funcionarios f ON f.rn = n;

-- 6. PEDIDO
WITH clientes AS (
    SELECT id_cliente,
           ROW_NUMBER() OVER (ORDER BY id_cliente) AS rn
    FROM public.cliente
)
INSERT INTO public.pedido
    (id_cliente, data_pedido, status_pedido, endereco_entrega)
SELECT
    c.id_cliente,
    TIMESTAMP '2025-01-01 00:00:00'
        + n * INTERVAL '1 day',
    (ARRAY[
        'Em processamento',
        'Enviado',
        'Pendente',
        'Entregue'
    ])[((n - 1) % 4) + 1],
    'Rua Gamer ' || n || ', Centro, Franca - SP'
FROM generate_series(1, 500) AS n
JOIN clientes c ON c.rn = n;

-- 7. ITEM_PEDIDO
WITH pedidos AS (
    SELECT id_pedido,
           ROW_NUMBER() OVER (ORDER BY id_pedido) AS rn
    FROM public.pedido
),
produtos AS (
    SELECT id_produto, preco,
           ROW_NUMBER() OVER (ORDER BY id_produto) AS rn
    FROM public.produto
)
INSERT INTO public.item_pedido
    (id_pedido, id_produto, quantidade, preco_unitario)
SELECT
    p.id_pedido,
    pr.id_produto,
    1 + (p.rn % 3),
    pr.preco
FROM pedidos p
JOIN produtos pr ON pr.rn = p.rn
WHERE p.rn <= 500;

-- 8. PAGAMENTO
WITH valores AS (
    SELECT
        id_pedido,
        SUM(quantidade * preco_unitario)::numeric(10,2)
            AS total
    FROM public.item_pedido
    GROUP BY id_pedido
),
pedidos AS (
    SELECT id_pedido, data_pedido,
           ROW_NUMBER() OVER (ORDER BY id_pedido) AS rn
    FROM public.pedido
)
INSERT INTO public.pagamento
    (id_pedido, forma_pagamento, valor_pago,
     status_pagamento, data_pagamento)
SELECT
    p.id_pedido,
    (ARRAY[
        'Cartao de credito',
        'Cartao de debito',
        'Boleto',
        'PIX'
    ])[((p.rn - 1) % 4) + 1],
    v.total,
    'Aprovado',
    p.data_pedido
FROM pedidos p
JOIN valores v ON v.id_pedido = p.id_pedido;

-- 9. NOTA_FISCAL
WITH pedidos AS (
    SELECT id_pedido, data_pedido,
           ROW_NUMBER() OVER (ORDER BY id_pedido) AS rn
    FROM public.pedido
)
INSERT INTO public.nota_fiscal
    (id_pedido, numero_nota, data_emissao, valor_total)
SELECT
    p.id_pedido,
    'GT-NF-' || LPAD(p.rn::text, 6, '0'),
    p.data_pedido,
    pg.valor_pago
FROM pedidos p
JOIN public.pagamento pg ON pg.id_pedido = p.id_pedido;

COMMIT;

-- CONFERENCIA DOS REGISTROS
SELECT 'cliente' AS tabela, COUNT(*) AS registros
FROM public.cliente
UNION ALL
SELECT 'funcionario', COUNT(*) FROM public.funcionario
UNION ALL
SELECT 'categoria', COUNT(*) FROM public.categoria
UNION ALL
SELECT 'cliente_telefone', COUNT(*) FROM public.cliente_telefone
UNION ALL
SELECT 'produto', COUNT(*) FROM public.produto
UNION ALL
SELECT 'pedido', COUNT(*) FROM public.pedido
UNION ALL
SELECT 'item_pedido', COUNT(*) FROM public.item_pedido
UNION ALL
SELECT 'pagamento', COUNT(*) FROM public.pagamento
UNION ALL
SELECT 'nota_fiscal', COUNT(*) FROM public.nota_fiscal;
