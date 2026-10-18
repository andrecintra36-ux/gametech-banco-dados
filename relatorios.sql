-- GameTech Informatica - 10 Relatorios SQL
-- Relatorio 01: Clientes em ordem alfabetica
SELECT id_cliente, nome, sobrenome, email, cidade, estado
FROM public.cliente
ORDER BY nome ASC, sobrenome ASC
LIMIT 20;

-- Relatorio 02: Produtos com preco acima de 500
SELECT id_produto, nome, marca, preco, quantidade_estoque
FROM public.produto
WHERE preco > 500
ORDER BY preco DESC
LIMIT 20;

-- Relatorio 03: Produtos e categorias
SELECT p.id_produto, p.nome AS produto, c.nome AS categoria, p.marca, p.preco
FROM public.produto p
INNER JOIN public.categoria c ON p.id_categoria = c.id_categoria
ORDER BY p.nome ASC
LIMIT 20;

-- Relatorio 04: Pedidos e clientes
SELECT p.id_pedido, c.nome, c.sobrenome, p.data_pedido, p.status_pedido
FROM public.pedido p
INNER JOIN public.cliente c ON p.id_cliente = c.id_cliente
ORDER BY p.data_pedido DESC
LIMIT 20;

-- Relatorio 05: Itens vendidos por pedido
SELECT i.id_pedido, p.nome AS produto, i.quantidade, i.preco_unitario,
       (i.quantidade * i.preco_unitario) AS valor_total
FROM public.item_pedido i
INNER JOIN public.produto p ON i.id_produto = p.id_produto
ORDER BY i.id_pedido ASC
LIMIT 20;

-- Relatorio 06: Pagamentos dos pedidos
SELECT pg.id_pagamento, p.id_pedido, c.nome AS cliente, pg.forma_pagamento,
       pg.valor_pago, pg.status_pagamento
FROM public.pagamento pg
INNER JOIN public.pedido p ON pg.id_pedido = p.id_pedido
INNER JOIN public.cliente c ON p.id_cliente = c.id_cliente
ORDER BY pg.valor_pago DESC
LIMIT 20;

-- Relatorio 07: Notas fiscais emitidas
SELECT nf.numero_nota, p.id_pedido, c.nome AS cliente, c.sobrenome,
       nf.data_emissao, nf.valor_total
FROM public.nota_fiscal nf
INNER JOIN public.pedido p ON nf.id_pedido = p.id_pedido
INNER JOIN public.cliente c ON p.id_cliente = c.id_cliente
ORDER BY nf.valor_total DESC
LIMIT 20;

-- Relatorio 08: Produtos com estoque baixo
SELECT id_produto, nome, marca, quantidade_estoque, preco
FROM public.produto
WHERE quantidade_estoque <= 30
ORDER BY quantidade_estoque ASC
LIMIT 20;

-- Relatorio 09: Funcionarios responsaveis pelos produtos
SELECT p.id_produto, p.nome AS produto, p.marca, f.nome AS funcionario,
       f.sobrenome, f.cargo
FROM public.produto p
INNER JOIN public.funcionario f ON p.id_funcionario = f.id_funcionario
ORDER BY f.nome ASC
LIMIT 20;

-- Relatorio 10: Clientes que mais gastaram
SELECT c.id_cliente, c.nome, c.sobrenome,
       COUNT(p.id_pedido) AS total_pedidos,
       SUM(pg.valor_pago) AS total_gasto
FROM public.cliente c
INNER JOIN public.pedido p ON c.id_cliente = p.id_cliente
INNER JOIN public.pagamento pg ON p.id_pedido = pg.id_pedido
WHERE pg.status_pagamento = 'Aprovado'
GROUP BY c.id_cliente, c.nome, c.sobrenome
ORDER BY total_gasto DESC
LIMIT 20;
