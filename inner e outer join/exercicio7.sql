CREATE DATABASE exercicioSete
GO
USE exercicioSete

CREATE TABLE cliente(
rg			VARCHAR(20) NOT NULL,
cpf			VARCHAR(20) NOT NULL,
nome		VARCHAR(20) NOT NULL,
endereco	VARCHAR(50) NOT NULL
PRIMARY KEY (rg)
)

CREATE TABLE pedido(
notaFiscal	INT	  IDENTITY(1001,1) NOT NULL, 
valor		DECIMAL(7,2)  NOT NULL,
dt			DATETIME NOT NULL,
rgCliente	VARCHAR(20) NOT NULL,
PRIMARY KEY (notaFiscal),
FOREIGN KEY (rgCliente) REFERENCES cliente (rg)
)

CREATE TABLE fornecedor(
codigo		INT IDENTITY(1,1) NOT NULL,
nome		VARCHAR(50) NOT NULL,
endereco	VARCHAR(50) NOT NULL,
telefone	VARCHAR(50),
cgc			VARCHAR(50),
cidade		VARCHAR(50),
transporte	VARCHAR(50),
pais		VARCHAR(50),
moeda		VARCHAR(50),
PRIMARY KEY (codigo)
)

CREATE TABLE mercadoria(
codigoMerc		INT	IDENTITY(10,1) NOT NULL,
descricao		VARCHAR(50) NOT NULL,
preco			DECIMAL(7,2)  NOT NULL,
quantidade		INT  NOT NULL,
codFornecedor	INT  NOT NULL,
PRIMARY KEY (codigoMerc),
FOREIGN KEY (codFornecedor) REFERENCES fornecedor(codigo)
)

INSERT INTO cliente (rg, cpf, nome, endereco)
VALUES
('2.953.184-4', '345.198.780-40', 'Luiz André', 'R. Astorga, 500'),
('13.514.996-x', '849.842.856-30', 'Maria Luiza','R. Piauí, 174'),
('12.198.554-1', '233.549.973-10', 'Ana Barbara', 'Av. Jaceguai, 1141'),
('23.987.746-x', '435.876.699-20', 'Marcos Alberto', 'R. Quinze, 22')

INSERT INTO pedido (valor, dt, rgCliente)
VALUES
(754,  '2018-04-01', '12.198.554-1'),
(350,  '2018-04-01', '12.198.554-1'),
(30 ,  '2018-04-01', '2.953.184-4'),
(1500, '2018-01-01', '13.514.996-x')

INSERT INTO fornecedor (nome, endereco, telefone, cgc, cidade, transporte, pais, moeda)
VALUES
('Clone', 'Av. Nações Unidas, 12000'	, '(11)4148-7000', null	, 'São Paulo', null, null, null),
('Logitech', '28th Street, 100', '1-800-145990', null, null, 'Avião', 'EUA', 'US$'),
('LG', 'Rod. Castello Branco', '0800-664400', '415997810/0001', 'Sorocaba', null, null, null),
('PcChips', 'Ponte da Amizade', null, null, null, 'Navio', 'Py', 'US$')

INSERT INTO mercadoria (descricao, preco, quantidade, codFornecedor)
VALUES
('Mouse', 24, 30, 1),
('Teclado', 50, 20, 1),
('Cx. De Som', 30, 8, 2),
('Monitor 17', 350, 4, 3),
('Notebook', 1500, 7, 4)

--FK: Cliente em Pedido - Fornecedor em Mercadoria	

	--ok
					
--Consultar 10% de desconto no pedido 1003			
SELECT valor, valor * 0.9 as novoValor
FROM pedido 
WHERE notaFiscal = 1003
		
--Consultar 5% de desconto em pedidos com valor maior de R$700,00	
SELECT valor, valor * 0.95 as novoValor
FROM pedido 
WHERE valor > 700
				
--Consultar e atualizar aumento de 20% no valor de marcadorias com estoque menor de 10	
SELECT preco FROM mercadoria

UPDATE mercadoria
SET preco = preco * 1.2
WHERE quantidade < 10

SELECT preco FROM mercadoria
				
--Data e valor dos pedidos do Luiz	
SELECT pedido.dt, pedido.valor
FROM pedido INNER JOIN cliente
ON cliente.rg = pedido.rgCliente
WHERE nome like 'Luiz%'
			
--CPF, Nome e endereço do cliente de nota 1004	
SELECT cliente.cpf, cliente.nome, cliente.endereco
FROM  pedido INNER JOIN cliente
ON cliente.rg = pedido.rgCliente
WHERE notaFiscal = 1004
			
--País e meio de transporte da Cx. De som	
SELECT fornecedor.pais, fornecedor.transporte
FROM  fornecedor INNER JOIN mercadoria
ON fornecedor.codigo = mercadoria.codFornecedor
WHERE descricao = 'Cx. De som'
				
--Nome e Quantidade em estoque dos produtos fornecidos pela Clone
SELECT mercadoria.descricao, mercadoria.quantidade
FROM  fornecedor INNER JOIN mercadoria
ON fornecedor.codigo = mercadoria.codFornecedor
WHERE nome = 'Clone'
					
--Endereço e telefone dos fornecedores do monitor
SELECT fornecedor.endereco, fornecedor.telefone
FROM  fornecedor INNER JOIN mercadoria
ON fornecedor.codigo = mercadoria.codFornecedor
WHERE descricao LIKE 'monitor%'

--Tipo de moeda que se compra o notebook	
SELECT fornecedor.moeda
FROM  fornecedor INNER JOIN mercadoria
ON fornecedor.codigo = mercadoria.codFornecedor
WHERE descricao ='notebook'
				
--Há quantos dias foram feitos os pedidos e, criar uma coluna que escreva Pedido antigo para pedidos feitos há mais de 6 meses					
SELECT DATEDIFF(DAY, dt, GETDATE()) AS tempoPedido,

	CASE WHEN (DATEDIFF(MONTH, dt, GETDATE())) >= 6
		THEN
			'Pedido antigo'
		ELSE
			'Pedido novo'
	END AS quandoFoi

FROM pedido

--Nome e Quantos pedidos foram feitos por cada cliente	
SELECT cliente.nome, COUNT(cliente.nome) as quantidade
FROM  cliente INNER JOIN pedido
ON cliente.rg = pedido.rgCliente
GROUP BY cliente.nome

--RG,CPF,Nome e Endereço dos cliente cadastrados que Não Fizeram pedidos
SELECT cliente.rg, cliente.nome, cliente.endereco
FROM cliente LEFT OUTER JOIN pedido
ON cliente.rg = pedido.rgCliente
WHERE pedido.rgCliente IS NULL



