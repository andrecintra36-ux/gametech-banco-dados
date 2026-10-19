

script de inserção de dados



  
WITH pedidos AS (
    SELECT
        id_pedido,
        ROW_NUMBER() OVER (ORDER BY id_pedido) AS numero
    FROM public.pedido
),
produtos AS (
    SELECT
        id_produto,
        preco,
        ROW_NUMBER() OVER (ORDER BY id_produto) AS numero
    FROM public.produto
),
itens_inseridos AS (
    INSERT INTO public.item_pedido (
        id_pedido,
        id_produto,
        quantidade,
        preco_unitario
    )
    SELECT
        p.id_pedido,
        pr.id_produto,
        1 + (p.numero % 3),
        pr.preco
    FROM pedidos p
    JOIN produtos pr
        ON p.numero = pr.numero
    WHERE p.numero <= 500
    ON CONFLICT (id_pedido, id_produto) DO NOTHING
    RETURNING id_pedido
)
SELECT COUNT(*) AS total_inserido
FROM itens_inseridos;
