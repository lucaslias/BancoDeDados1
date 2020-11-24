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
(3251,'Informática'),
(3252,'Matemática'),
(3253,'Física'),
(3254,'Química')

INSERT INTO autor(codigoAut,nome,pais,biografia)
VALUES
(10001,	'Ramez E. Elmasri',	'EUA', 'Professor da Universidade do Texas'),
(10002, 'Andrew Tannenbaum', 'Holanda', 'Desenvolvedor do Minix'),
(10003,	'Diva Marília Flemming', 'Brasil','Professora Adjunta da UFSC'),
(10004,	'David Halliday', 'EUA', 'Ph.D. da University of Pittsburgh'),
(10005,	'Marco Antonio Furlan de Souza', 'Brasil','Prof. do IMT'),
(10006,	'Alfredo Steinbruch', 'Brasil', 'Professor de Matemática da UFRS e da PUCRS')

INSERT INTO cliente(codigoCli,nome,logradouro,numero,telefone)
VALUES
(1001,'Luis Augusto','R. 25 de Março',250,'996529632'),
(1002,'Maria Luisa','R. XV de Novembro',890,'998526541'),
(1003,'Claudio Batista','R. Anhaia',112,'996547896'),
(1004,'Wilson Mendes','R. do Hipódromo',1250,'991254789'),
(1005,'Ana Maria','R. Augusta',896,	'999365589'),
(1006,'Cinthia Souza','R. Voluntários da Pátria',1023,'984256398'),
(1007,'Luciano Britto',NULL,	NULL,	'995678556'),
(1008,'Antônio do Valle','R. Sete de Setembro',	1894,	NULL)

INSERT INTO livro(codigoLiv,codAutor,codCorre, nome, pagina,idioma)
VALUES
(1,10001,3251,'Sistemas de Banco de dados',720,'Português') ,
(2,10002,3251,'Sistemas Operacionais Modernos',580,'Português'),
(3,10003,3252,'Calculo A',290,'Português'),
(4,10004,3253,'Fundamentos de Física I',185,'Português'),
(5,10005,3251,'Algoritmos e Lógica de Programação',90,'Português'),
(6,10006,3252,'Geometria Analítica',75,'Português'),
(7,10004,3253,'Fundamentos de Física II',150,'Português'),
(8,10002,3251,'Redes de Computadores',493,'Inglês')  ,
(9,10002,3251,'Organização Estruturada de Computadores',576,'Português')

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


/* Fazer uma consulta que retorne o nome do cliente e a data do empréstimo formatada 
padrão BR (dd/mm/yyyy)
*/
SELECT cliente.nome, 
	SUBSTRING(CAST(emprestimo.dt AS varchar(50)), 5,3) + '/' +
	SUBSTRING(CAST(emprestimo.dt AS varchar(50)), 1,4) + '/' + 
	SUBSTRING(CAST(emprestimo.dt AS varchar(10)), 8,6) AS novadata
FROM cliente INNER JOIN emprestimo
ON cliente.codigoCli = emprestimo.codCli


/* Fazer uma consulta que retorne Nome do autor e Quantos livros foram escritos por Cada 
autor, ordenado pelo número de livros. Se o nome do autor tiver mais de 25 caracteres, 
mostrar só os 13 primeiros
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

/* Fazer uma consulta que retorne o nome do autor e o país de origem do livro com maior 
número de páginas cadastrados no sistema*/

SELECT autor.codigoAut, autor.nome, autor.pais
FROM livro, autor
WHERE livro.codAutor = autor.codigoAut
	AND livro.pagina IN(
        SELECT MAX(livro.pagina)
        FROM livro
    )


/* Fazer uma consulta que retorne nome e endereço concatenado dos clientes que tem 
livros emprestados*/
SELECT cliente.nome + ' -> ' + cliente.logradouro + ',' + CAST(cliente.numero AS varchar(5)) as novo
FROM cliente INNER JOIN emprestimo
ON cliente.codigoCli = emprestimo.codCli
GROUP BY cliente.nome, cliente.logradouro, cliente.numero

/*
Nome dos Clientes, sem repetir e, concatenados como
enderço_telefone, o logradouro, o numero e o telefone) dos
clientes que Não pegaram livros. 
Se o logradouro e o número forem nulos e o telefone não for nulo, mostrar só o telefone. 
Se o telefone for nulo e o logradouro e o número não forem nulos, mostrar só logradouro e número. 
Se os três existirem, mostrar os três.
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

-- Fazer uma consulta que retorne Quantos livros não foram emprestados
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


/*Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do 
cliente, o nome do livro, o total de dias que cada um está com o livro e, uma coluna 
que apresente, caso o número de dias seja superior a 4, apresente 'Atrasado', caso contrário,
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
cadastrado é maior ou igual a 2.
*/

SELECT autor.nome
FROM autor INNER JOIN  livro
ON autor.codigoAut = livro.codAutor
GROUP BY autor.nome
HAVING COUNT(livro.codAutor) >=2

/*Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do 
cliente, o nome do livro dos empréstimos que tem 7 dias ou mais 
*/

SELECT cliente.nome, livro.nome
FROM cliente INNER JOIN emprestimo
ON cliente.codigoCli =  emprestimo.codCli
INNER JOIN livro
ON emprestimo.codLivro = livro.codigoLiv
GROUP BY cliente.nome, livro.nome, emprestimo.dt
HAVING (DATEDIFF(DAY, emprestimo.dt, '2012-05-18')) >= 7



