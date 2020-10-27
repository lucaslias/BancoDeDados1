CREATE DATABASE ExercicioUmCrud
GO
USE ExercicioUmCrud

create table livro(
codigo_livro	int				NOT NULL	IDENTITY(0,1),
nome			VARCHAR(100)	NOT NULL,
lingua			VARCHAR(50)		NOT NULL,
ano				int				NOT NULL
primary key (codigo_livro)
)

create table autor(
codigo_autor	int				NOT NULL	IDENTITY(2000,1),
nome			VARCHAR(100)	NOT NULL,
nascimento		date			NOT NULL,
pais			VARCHAR(100)	NOT NULL,
biografia		VARCHAR(max)	NOT NULL
primary key (codigo_autor)
)

create table edicoes(
isbn			int				NOT NULL,
preco			decimal(7,2)	NOT NULL,
ano				int				NOT NULL,
num_paginas 	int				NOT NULL,
qnt_estoque 	int				NOT NULL
primary key (isbn)
)

create table editora(
codigo_editora		int				NOT NULL	IDENTITY(6000,1),
nome 				VARCHAR(50)		NOT NULL,
logradouro 			VARCHAR(250)		NOT NULL,
numero  			int				NOT NULL,
cep					char(8) NOT NULL,
telefone			char(11) NOT NULL
primary key (codigo_editora)
)
--checar as tabelas
EXEC sp_help autor

-- 1-a) Modificar o nome da coluna ano da tabela edicoes, para AnoEdicao
EXEC sp_rename 'dbo.edicoes.ano','ano_edicao','COLUMN'

-- 1-b) Modificar o tamanho do varchar do Nome da editora de 50 para 30alter table editora 
alter column nome varchar(30) NOT NULL

-- 1-c) Modificar o tipo da coluna ano da tabela autor para int
ALTER TABLE autor
DROP COLUMN nascimento
ALTER TABLE autor
ADD ano INT NOT NULL

-- 2-a) Inserir os dados

INSERT INTO livro (nome, lingua, ano)
VALUES
('CCNA 4.1', 'PT-BR ', 2015),
('HTML 5' , 'PT-BR ', 2017),
('Redes de Computadores' , 'EN', 2010),
('Android em Ação ' , 'PT-BR', 2018)

INSERT INTO autor (nome, pais, biografia, ano)
VALUES
('Inácio da Silva', 'Brasil', 'Programador WEB desde 1995', 1975),
('Andrew Tannenbaum', 'EUA', 'Chefe do Departamento de Sistemas de Computação da Universidade de Vrij', 1944),
('Luis Rocha ', 'Brasil', 'Programador Mobile desde 2000', 1967),
('David Halliday  ', 'EUA ', 'Físico PH.D desde 1941', 1916)

SELECT * FROM autor

INSERT INTO livro_autor (codigo_livro, codigo_autor)
values
(0,2000),
(1,2001),
(2,2002),
(3,2003)

INSERT INTO edicoes (isbn, preco, ano_edicao, num_paginas, qnt_estoque)
VALUES
(0130661023, 189.99, 2018, 653, 10)

-- 2-b) A universidade do Prof. Tannenbaum chama-se Vrije e não Vrij, modificar

UPDATE autor
SET biografia = 'Chefe do Departamento de Sistemas de Computação da Universidade de Vrije'
WHERE nome = 'Andrew Tannenbaum'

-- 2-c) A livraria vendeu 2 unidades do livro 0130661023, atualizar
UPDATE edicoes
SET qnt_estoque = qnt_estoque - 2
WHERE  isbn = 0130661023

-- 2-d) Por não ter mais livros do David Halliday, apagar o autor.

DELETE autor
WHERE codigo_autor = 2003

SELECT * FROM autor





