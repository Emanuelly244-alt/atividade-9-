-- Cria a base de dados.
CREATE database vendas_online_db;

-- Define o uso da base de dados.
USE vendas_online_db;

-- Cria a tabela de clientes.
CREATE TABLE clientes 
(
id INT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
cpf CHAR(11) NOT NULL UNIQUE,
email VARCHAR(120),
cidade VARCHAR(60),
ativo TINYINT DEFAULT 1
);

-- Cria um índice de desempenho para filtros por cidade.
CREATE INDEX idx_cidade ON clientes (cidade);

-- Cria a tabela de pedidos (relacionamento com clientes).
CREATE TABLE pedidos (
id INT PRIMARY KEY not null,
id_cliente INT,
valor DECIMAL(10,2),
data_pedido DATE
);

-- Chave estrangeira.
ALTER TABLE pedidos 
ADD CONSTRAINT fk_pedidos_clientes 
FOREIGN KEY (id_cliente) REFERENCES clientes(id);

-- Cria um índice de desempenho para filtrar por data do pedido.
CREATE INDEX idx_data_pedido ON pedidos(data_pedido);

-- Insere novos clientes.

INSERT INTO clientes (id, nome, cpf, cidade)
VALUES 
(1, 'Ana Souza', '11111111111', 'São Paulo'),
(2, 'Bruno Lima', '22222222222', 'São Paulo'),
(3, 'Carla Nunes', '33333333333', 'Rio de Janeiro'),
(4, 'Diego Martins', '44444444444', 'Curitiba'),
(5, 'Elisa Rocha', '55555555555', 'São Paulo');

-- Insere novos pedidos.
INSERT INTO pedidos (id, id_cliente, valor, data_pedido)
VALUES 
(1, 1, '150.00', '2025-01-10'),
(2, 1, '89.90', '2025-02-05'),
(3, 2, '320.00', '2025-03-12'),
(4, 3, '500.00', '2025-04-01'),
(5, 3, '75.50', '2025-04-15'),
(6, 4, '120.00', '2025-05-02');

CREATE TABLE entregas
(
    id INT PRIMARY KEY NOT NULL,
    id_pedidos INT,
    data_de_entrega DATE,
    status_da_entrega VARCHAR(50),
    valor_do_frete DECIMAL(10,2),
   
    FOREIGN KEY (id_pedidos) REFERENCES pedidos(id)
);

INSERT INTO entregas(id, id_pedidos, data_de_entrega, status_da_entrega, valor_do_frete)
VALUES
(1, 1, '2025-01-13', 'Entregue', '25.00'),
(2, 2, '2025-02-07', 'Entregue', '18.50'),
(3, 3, '2025-03-20', 'Cancelada', '0.00'),
(4, 4, '2025-04-05', 'Entregue', '35.00'),
(5, 5, '2025-04-17', 'Pendente', '28.90'),
(6, 6, '2025-05-06', 'Entregue', '22.00');

select * from entregas;
create index idx_status_da_entrega on entregas(status_da_entrega);


USE vendas_online_db;
GO

CREATE VIEW vw_resumo_entregas AS
SELECT 
    COUNT(id) AS total_entregas,
    AVG(valor_do_frete) AS media_frete
FROM entregas;
GO

CREATE VIEW vw_entregas_concluidas AS
SELECT 
    e.id_pedidos AS ID_Pedido,
    p.valor AS Valor_Do_Pedido,
    e.valor_do_frete AS Valor_Do_Frete,
    e.data_de_entrega AS Data_Da_Entrega
FROM entregas e
INNER JOIN pedidos p ON e.id_pedidos = p.id
WHERE e.status_da_entrega = 'Entregue';
GO

SELECT * FROM vw_resumo_entregas;

SELECT * FROM vw_entregas_concluidas;
