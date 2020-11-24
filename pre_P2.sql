CREATE DATABASE prePdois
GO
USE prePdois

CREATE TABLE corredor(
codigoCor	int NOT NULL,
tipo		VARCHAR(50) NOT NULL,
PRIMARY KEY (codigoCor)
)

CREATE TABLE autor(
codigoAut	int NOT NULL,
nome		VARCHAR(50) NOT NULL,
pais		VARCHAR(50) NOT NULL,
biografia	VARCHAR(50) NOT NULL
PRIMARY KEY (codigoAut)
)

CREATE TABLE cliente(
codigoCli	int NOT NULL,
nome		VARCHAR(50) NOT NULL,
logradouro	VARCHAR(50) ,
numero		int,
telefone	VARCHAR(50),
PRIMARY KEY (codigoCli)
)

CREATE TABLE livro(
codigoLiv	INT	NOT NULL,
codAutor	INT NOT NULL,
codCorre	INT  NOT NULL,
nome		VARCHAR(50) NOT NULL,
pagina		INT NOT NULL,
idioma		VARCHAR(50) NOT NULL,
PRIMARY KEY (codigoLiv),
FOREIGN KEY (codAutor) REFERENCES autor(codigoAut),
FOREIGN KEY (codCorre) REFERENCES corredor(codigoCor)
)


CREATE TABLE emprestimo(
codCli		INT NOT NULL,
codLivro	INT  NOT NULL,
dt			DATETIME NOT NULL,
PRIMARY KEY (codCli,codLivro),
FOREIGN KEY (codCli) REFERENCES cliente(codigoCli),
FOREIGN KEY (codLivro) REFERENCES livro(codigoLiv)
)

INSERT INTO corredor(codigoCor, tipo)
VALUES
(3251,'Inform�tica'),
(3252,'Matem�tica'),
(3253,'F�sica'),
(3254,'Qu�mica')

INSERT INTO autor(codigoAut,nome,pais,biografia)
VALUES
(10001,	'Ramez E. Elmasri',	'EUA', 'Professor da Universidade do Texas'),
(10002, 'Andrew Tannenbaum', 'Holanda', 'Desenvolvedor do Minix'),
(10003,	'Diva Mar�lia Flemming', 'Brasil','Professora Adjunta da UFSC'),
(10004,	'David Halliday', 'EUA', 'Ph.D. da University of Pittsburgh'),
(10005,	'Marco Antonio Furlan de Souza', 'Brasil','Prof. do IMT'),
(10006,	'Alfredo Steinbruch', 'Brasil', 'Professor de Matem�tica da UFRS e da PUCRS')

INSERT INTO cliente(codigoCli,nome,logradouro,numero,telefone)
VALUES
(1001,'Luis Augusto','R. 25 de Mar�o',250,'996529632'),
(1002,'Maria Luisa','R. XV de Novembro',890,'998526541'),
(1003,'Claudio Batista','R. Anhaia',112,'996547896'),
(1004,'Wilson Mendes','R. do Hip�dromo',1250,'991254789'),
(1005,'Ana Maria','R. Augusta',896,	'999365589'),
(1006,'Cinthia Souza','R. Volunt�rios da P�tria',1023,'984256398'),
(1007,'Luciano Britto',NULL,	NULL,	'995678556'),
(1008,'Ant�nio do Valle','R. Sete de Setembro',	1894,	NULL)

INSERT INTO livro(codigoLiv,codAutor,codCorre, nome, pagina,idioma)
VALUES
(1,10001,3251,'Sistemas de Banco de dados',720,'Portugu�s') ,
(2,10002,3251,'Sistemas Operacionais Modernos',580,'Portugu�s'),
(3,10003,3252,'Calculo A',290,'Portugu�s'),
(4,10004,3253,'Fundamentos de F�sica I',185,'Portugu�s'),
(5,10005,3251,'Algoritmos e L�gica de Programa��o',90,'Portugu�s'),
(6,10006,3252,'Geometria Anal�tica',75,'Portugu�s'),
(7,10004,3253,'Fundamentos de F�sica II',150,'Portugu�s'),
(8,10002,3251,'Redes de Computadores',493,'Ingl�s')  ,
(9,10002,3251,'Organiza��o Estruturada de Computadores',576,'Portugu�s')

INSERT INTO emprestimo(codCli,dt,codLivro)
VALUES
(1001,'2012-05-10 00:00:00.000',1),
(1001,'2012-05-10 00:00:00.000',2),
(1001,'2012-05-10 00:00:00.000',8),
(1002,'2012-05-11 00:00:00.000',4),
(1002,'2012-05-11 00:00:00.000',7),
(1003,'2012-05-12 00:00:00.000',3),
(1004,'2012-05-14 00:00:00.000',5),
(1001,'2012-05-15 00:00:00.000',9)

SELECT * FROM corredor
SELECT * FROM autor
SELECT * FROM cliente
SELECT * FROM livro
SELECT * FROM emprestimo


/* Fazer uma consulta que retorne o nome do cliente e a data do empr�stimo formatada 
padr�o BR (dd/mm/yyyy)
*/
SELECT cliente.nome, 
	SUBSTRING(CAST(emprestimo.dt AS varchar(50)), 5,3) + '/' +
	SUBSTRING(CAST(emprestimo.dt AS varchar(50)), 1,4) + '/' + 
	SUBSTRING(CAST(emprestimo.dt AS varchar(10)), 8,6) AS novadata
FROM cliente INNER JOIN emprestimo
ON cliente.codigoCli = emprestimo.codCli


/* Fazer uma consulta que retorne Nome do autor e Quantos livros foram escritos por Cada 
autor, ordenado pelo n�mero de livros. Se o nome do autor tiver mais de 25 caracteres, 
mostrar s� os 13 primeiros
*/
SELECT 
	CASE WHEN (LEN(autor.nome) > 25)
		THEN
			SUBSTRING(autor.nome, 1, 13) + '.' 
		ELSE
			autor.nome
	END AS nomeNovo,
count(livro.codAutor) as novo
FROM autor INNER JOIN livro
ON autor.codigoAut = livro.codAutor
GROUP BY autor.nome
ORDER BY novo

/* Fazer uma consulta que retorne o nome do autor e o pa�s de origem do livro com maior 
n�mero de p�ginas cadastrados no sistema*/

SELECT autor.codigoAut, autor.nome, autor.pais
FROM livro, autor
WHERE livro.codAutor = autor.codigoAut
	AND livro.pagina IN(
        SELECT MAX(livro.pagina)
        FROM livro
    )


/* Fazer uma consulta que retorne nome e endere�o concatenado dos clientes que tem 
livros emprestados*/
SELECT cliente.nome + ' -> ' + cliente.logradouro + ',' + CAST(cliente.numero AS varchar(5)) as novo
FROM cliente INNER JOIN emprestimo
ON cliente.codigoCli = emprestimo.codCli
GROUP BY cliente.nome, cliente.logradouro, cliente.numero

/*
Nome dos Clientes, sem repetir e, concatenados como
ender�o_telefone, o logradouro, o numero e o telefone) dos
clientes que N�o pegaram livros. 
Se o logradouro e o n�mero forem nulos e o telefone n�o for nulo, mostrar s� o telefone. 
Se o telefone for nulo e o logradouro e o n�mero n�o forem nulos, mostrar s� logradouro e n�mero. 
Se os tr�s existirem, mostrar os tr�s.
O telefone deve estar mascarado XXXXX-XXXX
*/
SELECT cliente.nome,
	CASE WHEN (cliente.logradouro IS NULL) and (cliente.numero IS NULL)
		THEN
			SUBSTRING(CAST(cliente.telefone AS varchar(10)), 1,5) + '-' + 
			SUBSTRING(CAST(cliente.telefone AS varchar(10)), 6,4)
		ELSE CASE WHEN (cliente.telefone IS NULL)
			THEN
				cliente.logradouro + ',' + CAST(cliente.numero AS varchar(25))
			ELSE
				SUBSTRING(CAST(cliente.telefone AS varchar(10)), 1,5) + '-' + 
				SUBSTRING(CAST(cliente.telefone AS varchar(10)), 6,4)+ 
				'-> ' + cliente.logradouro + ',' + CAST(cliente.numero AS varchar(25))
			END
	END
FROM cliente LEFT OUTER JOIN emprestimo
ON cliente.codigoCli = emprestimo.codCli
WHERE emprestimo.codCli IS NULL

-- Fazer uma consulta que retorne Quantos livros n�o foram emprestados
SELECT COUNT(livro.codigoLiv) as quantidade
FROM livro LEFT OUTER JOIN  emprestimo
ON livro.codigoLiv = emprestimo.codLivro
WHERE emprestimo.codCli IS NULL

/* Fazer uma consulta que retorne Nome do Autor, Tipo do corredor e quantos livros, 
ordenados por quantidade de livro*/
SELECT autor.nome, corredor.tipo, COUNT(autor.codigoAut) AS novo
FROM autor INNER JOIN livro
ON autor.codigoAut = livro.codAutor
INNER JOIN corredor
ON corredor.codigoCor = livro.codCorre
GROUP BY autor.nome, corredor.tipo
ORDER BY novo


/*Considere que hoje � dia 18/05/2012, fa�a uma consulta que apresente o nome do 
cliente, o nome do livro, o total de dias que cada um est� com o livro e, uma coluna 
que apresente, caso o n�mero de dias seja superior a 4, apresente 'Atrasado', caso contr�rio,
 apresente 'No Prazo'*/

SELECT cliente.nome, livro.nome, DATEDIFF(DAY,emprestimo.dt, '2012-05-18') AS dias, 
	CASE WHEN (DATEDIFF(DAY,emprestimo.dt, '2012-05-18') > 4)
		THEN
			'atrasado'
		ELSE
			'No Prazo'
		END AS situacao
from cliente INNER JOIN emprestimo
ON cliente.codigoCli = emprestimo.codCli
INNER JOIN livro
ON livro.codigoLiv = emprestimo.codLivro

/*Fazer uma consulta que retorne cod de corredores, tipo de corredores e quantos 
livros tem em cada corredor*/
SELECT corredor.codigoCor, corredor.codigoCor, COUNT(livro.codCorre) as quantidade
FROM corredor INNER JOIN livro
ON corredor.codigoCor = livro.codCorre
GROUP BY corredor.codigoCor, corredor.codigoCor

/*Fazer uma consulta que retorne o Nome dos autores cuja quantidade de livros 
cadastrado � maior ou igual a 2.
*/

SELECT autor.nome
FROM autor INNER JOIN  livro
ON autor.codigoAut = livro.codAutor
GROUP BY autor.nome
HAVING COUNT(livro.codAutor) >=2

/*Considere que hoje � dia 18/05/2012, fa�a uma consulta que apresente o nome do 
cliente, o nome do livro dos empr�stimos que tem 7 dias ou mais 
*/

SELECT cliente.nome, livro.nome
FROM cliente INNER JOIN emprestimo
ON cliente.codigoCli =  emprestimo.codCli
INNER JOIN livro
ON emprestimo.codLivro = livro.codigoLiv
GROUP BY cliente.nome, livro.nome, emprestimo.dt
HAVING (DATEDIFF(DAY, emprestimo.dt, '2012-05-18')) >= 7



