CREATE DATABASE exercicioDois
GO
USE exercicioDois

CREATE TABLE carro(
placa		VARCHAR(10)		NOT NULL,
marca		VARCHAR(200)    NOT NULL,
modelo      VARCHAR(25)	    NOT NULL,
cor			VARCHAR(20)     NOT NULL,
ano			VARCHAR(10)     NOT NULL,
PRIMARY KEY(placa)
)

CREATE TABLE cliente(
nome        VARCHAR(100)    NOT NULL,
logradouro  VARCHAR(200)    NOT NULL,
numero      INT             NOT NULL,
bairro		VARCHAR(20)		NOT NULL,
telefone    VARCHAR(20)     NOT NULL,
carro		VARCHAR(10)     NOT NULL,
PRIMARY KEY(carro),
FOREIGN KEY(carro) REFERENCES carro(placa),
)

CREATE TABLE peca(
codigo		int		NOT NULL,
nome		VARCHAR(200)    NOT NULL,
valor		DECIMAL (7,2)	NOT NULL
PRIMARY KEY(codigo)
)

CREATE TABLE servico(
carro		VARCHAR(10)		NOT NULL,
peca		int				NOT NULL,
quantidade	int				NOT NULL,
valor		DECIMAL (7,2)	NOT NULL,
dt			DATETIME		NOT NULL
PRIMARY KEY(carro,peca,dt),
FOREIGN KEY(carro) REFERENCES carro(placa),
FOREIGN KEY(peca) REFERENCES peca(codigo),
)


insert into carro (placa, marca, modelo, cor, ano)
values
('AFT9087', 'VW', 'Gol', 'Preto', 2007),
('DXO9876', 'Ford','Ka','Azul', 2000),
('EGT4631', 'Renault', 'Clio',',Verde', 2004),
('LKM7380', 'Fiat', 'Palio', 'Prata', 1997),
('BCD7521', 'Ford', 'Fiesta', 'Preto', 1999)

select * from carro

insert into cliente (nome,logradouro, numero, bairro, telefone, carro)
values
('João Alves', 'R. Pereira Barreto', 1258, 'Jd. Oliveiras','2154-9658', 'DXO9876'),
('Ana Maria', 'R. 7 de Setembro', 259, 'Centro', '9658-8541', 'LKM7380'),
('Clara Oliveira', 'Av. Nações Unidas', 10254, 'Pinheiros', '2458-9658', 'EGT4631'),
('José Simões', 'R. XV de Novembro', 36, 'Água Branca', '7895-2459', 'BCD7521'),
('Paula Rocha', 'R. Anhaia', 548, 'Barra Funda', '6958-2548', 'AFT9087')

select * from cliente

insert into peca (codigo, nome, valor)
values
(1,'Vela', 70),
(2,'Correia Dentada', 125),
(3,'Trambulador', 90),
(4,'Filtro de Ar',30)

select * from peca

insert into servico (carro, peca, quantidade, valor, dt)
values
('DXO9876', 1, 4, 280, '2020-08-01'),
('DXO9876', 4, 1, 30, '2020-08-01'),
('EGT4631', 3, 1, 90, '2020-08-02'),
('DXO9876', 2, 1, 125,'2020-08-07')

select * from servico

SELECT telefone
FROM cliente
WHERE carro IN
(
	SELECT DISTINCT placa
	FROM carro
	WHERE modelo = 'Ka' and cor = 'Azul'
)

SELECT logradouro + ',' + CAST(numero as varchar (6)) + ' - ' + bairro as endereco_tudo
FROM cliente
WHERE carro IN
(
	SELECT DISTINCT carro
	FROM servico
	WHERE dt = '2020-08-02'
)

SELECT placa
from carro
WHERE ano < 2001

SELECT marca + ' -> ' + modelo + ' -> ' + cor as tudo
from carro
WHERE ano > 2005

SELECT codigo, nome
from peca
WHERE valor < 80
