CREATE DATABASE bancoProjeto
GO
USE bancoProjeto

USE master

CREATE TABLE projeto(
id			INT				IDENTITY(10001,1) NOT NULL,
nome		VARCHAR(45)		NOT NULL,
descricao	VARCHAR(45),
dt			date		CHECK(dt > '2014-09-01')	NOT NULL,
PRIMARY KEY (id)
)

EXEC sp_help projeto

CREATE TABLE usuario(
id			INT			IDENTITY(1,1) NOT NULL,
nome		VARCHAR(45)	NOT NULL,
username	VARCHAR(45)	NOT NULL,
senha		VARCHAR(45)	DEFAULT('123mudar') NOT NULL,
email		VARCHAR(45)	NOT NULL,
PRIMARY KEY (id)
)

CREATE TABLE usuarioTemProjeto(
id_projeto		INT			NOT NULL,
id_usuario		INT			NOT NULL,
PRIMARY KEY (id_projeto, id_usuario),
FOREIGN KEY (id_projeto) REFERENCES projeto(id),
FOREIGN KEY (id_usuario) REFERENCES usuario(id)
)

alter table usuario
alter column username varchar(10) NOT NULL

EXEC sp_help usuario

alter table usuario
alter column senha varchar(08) NOT NULL

insert into usuario (nome, username, senha, email)
values
('Maria', 'Rh_maria', '123mudar', 'maria@empresa.com'),
('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),
('Ana', 'Rh_ana', '123mudar', 'ana@empresa.com'),
('Clara', 'Ti_clara', '123mudar', 'clara@empresa.com'), 
('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')

select * from usuario

insert into projeto (nome, descricao, dt)
values
('Re?folha', 'Refatoração das Folhas', '2014-09-05'),
('Manutenção PC´s',  'Manutenção PC´s', '2014-09-06'),
('Auditoria' ,NULL,  '2014-09-07')

select * from projeto

insert into usuarioTemProjeto(id_projeto, id_usuario)
values
(1,10001),
(5,10001),
(3,10003),
(4,10002),
(2,10002)

select * from usuarioTemProjeto

UPDATE projeto
SET dt = '2014-09-12'
WHERE nome = 'Manutenção PC´s'

UPDATE usuario
SET username = 'Rh_cido'
WHERE nome = 'Aparecido'

UPDATE usuario
SET senha = '888@'
WHERE nome = 'Maria' and senha='123mudar'

DELETE usuario 
WHERE id = 2

ALTER TABLE projeto
ADD budget DECIMAL(7,2) 

UPDATE projeto
SET budget = 5750.00 
WHERE  id =  10001UPDATE projeto
SET budget = 7850.00 
WHERE  id =  10002UPDATE projeto
SET budget = 9530.00
WHERE  id =  10003
SELECT username, senha
FROM usuario
WHERE nome = 'Maria'
SELECT nome, budget, CAST(budget * 1.25 AS DECIMAL(7,2)) AS novo_salario
FROM projeto

SELECT id, nome, email 
FROM usuario
where senha = '123mudar'

SELECT id, nome
FROM projeto
where budget >= 2000.00 and budget <= 8000.00




