CREATE DATABASE exercicioOito
GO
USE exercicioOito

CREATE TABLE cliente(
codigoCli	INT IDENTITY(1,1) NOT NULL,
nome		VARCHAR(20) NOT NULL,
endereco	VARCHAR(50) NOT NULL,
telefonePe	VARCHAR(50),
telefoneCm	VARCHAR(50),
PRIMARY KEY (codigoCli)
)

CREATE TABLE tipoMercadoria(
codigoTipoMerc	INT IDENTITY(10001,1) NOT NULL,
nome			VARCHAR(20) NOT NULL,
PRIMARY KEY (codigoTipoMerc)
)

CREATE TABLE corredor(
codigoCor	INT IDENTITY(101,1) NOT NULL,
nome		VARCHAR(20),
tipo		INT,
PRIMARY KEY (codigoCor),
FOREIGN KEY (tipo) REFERENCES tipoMercadoria(codigoTipoMerc)
)

CREATE TABLE compra(
notaFiscal	INT  NOT NULL,
cliente		INT  NOT NULL,
valor		DECIMAL(7,2) NOT NULL,
PRIMARY KEY (notaFiscal),
FOREIGN KEY (cliente) REFERENCES cliente(codigoCli)
)

CREATE TABLE mercadoria(
codigoMerc		INT  IDENTITY(1001,1) NOT NULL,
nome			VARCHAR(20) NOT NULL,
corredorMerc	INT NOT NULL,
tipo			INT NOT NULL,
valor			DECIMAL (7,2) NOT NULL,
PRIMARY KEY (codigoMerc),
FOREIGN KEY (corredorMerc) REFERENCES corredor(codigoCor),
FOREIGN KEY (tipo) REFERENCES tipoMercadoria(codigoTipoMerc)
)

INSERT INTO cliente
VALUES
('Luis Paulo','R. Xv de Novembro, 100','45657878',null),
('Maria Fernanda','R. Anhaia, 1098','27289098','40040090'),
('Ana Claudia','Av. Voluntários da Pátria,876','21346548',null),
('Marcos Henrique','R. Pantojo, 76','51425890','30394540'),
('Emerson Souza','R. Pedro Álvares Cabral, 97','44236545','39389900'),
('Ricardo Santos','Trav. Hum, 10','98789878',null)

SELECT * FROM cliente

INSERT INTO mercadoria
VALUES
('Pão de Forma',101,10001, 3.5),
('Presunto',101,10002,2.0),
('Cream Cracker',103,10003,4.5),
('Água Sanitária',104,10004,6.5),
('Maçã',105,10005,	0.9),
('Palha de Aço',106,10006,	1.3),
('Lasanha',107,10007,9.7)

INSERT INTO corredor
VALUES
('Padaria',10001),
('Calçados',10002),
('Biscoitos',10003),
('Limpeza',10004),
(null,null),
(null,null),
('Congelados',10007)

INSERT INTO tipoMercadoria
VALUES
('Pães'),
('Frios'),
('Bolacha'),
('Clorados'),
('Frutas'),
('Esponjas'),
('Massas'),
('Molhos')

INSERT INTO	compra
VALUES
(1234,2,200),
(2345,4,156),
(3456,6,354),
(4567,3,19)
	
--Valor da Compra de Luis Paulo		
SELECT compra.valor
FROM cliente INNER JOIN compra
ON cliente.codigoCli = compra.cliente
WHERE nome = 'Luis Paulo'

--Valor da Compra de Marcos Henrique	
SELECT compra.valor
FROM cliente INNER JOIN compra
ON cliente.codigoCli = compra.cliente
WHERE nome = 'Marcos Henrique'	

--da mercadoria cadastrada do tipo " Pães"		
SELECT mercadoria.valor
FROM tipoMercadoria INNER JOIN mercadoria
ON tipoMercadoria.codigoTipoMerc = mercadoria.tipo
WHERE tipoMercadoria.nome= 'Pães'
	
--Nome do corredor onde está a Lasanha	
SELECT corredor.nome
FROM tipoMercadoria INNER JOIN corredor
ON tipoMercadoria.codigoTipoMerc = corredor.tipo
INNER JOIN mercadoria
ON corredor.codigoCor = mercadoria.corredorMerc
WHERE mercadoria.nome = 'Lasanha'

--Nome do corredor onde estão os clorados	
SELECT corredor.nome
FROM tipoMercadoria INNER JOIN corredor
ON tipoMercadoria.codigoTipoMerc = corredor.tipo
WHERE tipoMercadoria.nome= 'clorados'	


