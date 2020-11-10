CREATE DATABASE exercicioUm
GO
USE exercicioUm

USE master

CREATE TABLE aluno(
ra			INT				NOT NULL,
nome		VARCHAR(45)		NOT NULL,
sobrenome	VARCHAR(45)		NOT NULL,
rua 		VARCHAR(45)		NOT NULL,
numero 		INT				NOT NULL,
bairro		VARCHAR(45)		NOT NULL,
cep			VARCHAR(45)		NOT NULL,
telefone	VARCHAR(45),
PRIMARY KEY (ra)
)

EXEC sp_help aluno

CREATE TABLE curso(
codigo		INT				IDENTITY(1,1) NOT NULL,
nome		VARCHAR(45)		NOT NULL,
cargaHor	INT				NOT NULL,
turno		VARCHAR(45)		NOT NULL,
PRIMARY KEY (codigo)
)

EXEC sp_help curso

CREATE TABLE disciplina(
codigo		INT				IDENTITY(1,1) NOT NULL,
nome		VARCHAR(45)		NOT NULL,
cargaHor	INT				NOT NULL,
turno		VARCHAR(45)		NOT NULL,
semestre	INT				NOT NULL,
)

EXEC sp_help disciplina

insert into aluno (ra, nome, sobrenome, rua, numero, bairro, cep, telefone)
values
(12345, 'José', 'Silva', 'Almirante Noronha', 236, 'Jardim São Paulo', '1589000', '69875287'),
(12346, 'Ana', 'Maria Bastos', 'Anhaia', 1568, 'Barra Funda' , '3569000', '25698526'),
(12347, 'Mario', 'Santos', 'XV de Novembro', 1841, 'Centro', '1020030', null),
(12348, 'Marcia', 'Neves', 'Voluntários da Patria' , 225, 'Santana', '2785090', '78964152')

select * from aluno


insert into curso (nome, cargaHor, turno)
values
('Informática', 2800, 'Tarde'),
('Informática', 2800, 'Noite'),
('Logística', 2650, 'Tarde'),
('Logística', 2650, 'Noite'),
('Plásticos', 2500, 'Tarde'),
('Plásticos', 2500,'Noite')

select * from curso

insert into disciplina (nome, cargaHor, turno,semestre)
values
('Informática', 4, 'Tarde', 1),
('Informática', 4, 'Noite', 1),
('Quimica', 4, 'Tarde', 1),
('Quimica', 4, 'Noite', 1),
('Banco de Dados I', 2, 'Tarde', 3),
('Banco de Dados I', 2, 'Noite', 3),
('Estrutura de Dados', 4, 'Tarde', 4),
('Estrutura de Dados', 4, 'Noite', 4)

select * from disciplina


SELECT nome + ' ' + sobrenome AS nome_completo
FROM aluno

SELECT rua +','+CAST(numero AS VARCHAR(5))+' - '+ cep AS endereco_completo, bairro, cep
FROM aluno
WHERE telefone IS NULL

SELECT telefone
FROM aluno
WHERE ra = 12348

SELECT nome, turno
from curso
WHERE cargaHor = 2800

SELECT semestre
from disciplina
WHERE nome = 'Banco de Dados I' and turno = 'Noite'

