CREATE DATABASE exercicioDez
GO
USE exercicioDez

CREATE TABLE medicamento(
codigo			INT IDENTITY(1,1) NOT NULL,
nomeMed			VARCHAR(50) NOT NULL,
apresentacao	VARCHAR(50) NOT NULL,
undCadastro		VARCHAR(50) NOT NULL,
preco			DECIMAL(7,4) NOT NULL
PRIMARY KEY (codigo)
)


CREATE TABLE cliente(
cpf			VARCHAR(20) NOT NULL,
nomeCli		VARCHAR(20) NOT NULL,
rua			VARCHAR(50) NOT NULL,
numeroRua	INT NOT NULL,
bairro		VARCHAR(50) NOT NULL,
telefone	VARCHAR(20) NOT NULL
PRIMARY KEY (cpf)
)

CREATE TABLE mercadoria(
codigoNota	INT IDENTITY(1000,1) NOT NULL,
notaFiscal	INT NOT NULL,
cpfCliente	VARCHAR(20) NOT NULL,
codigoMedi	INT NOT NULL,
quantidade	INT NOT NULL,
valorTotal	DECIMAL (7,4) NOT NULL,
dt			DATETIME NOT NULL
PRIMARY KEY (codigoNota),
FOREIGN KEY (cpfCliente) REFERENCES cliente(cpf),
FOREIGN KEY (codigoMedi) REFERENCES medicamento(codigo)
)

INSERT INTO cliente(cpf, nomeCli, rua, numeroRua, bairro, telefone)
VALUES
('343908987-00','Maria Zélia','Anhaia',65,'Barra Funda',92103762),
('213459862-90','Roseli Silva',	'Xv. De Novembro',987,'Centro',82198763),
('869279818-25','Carlos Campos','Voluntários da Pátria',1276,'Santana',98172361),
('310981209-00','João Perdizes','Carlos de Campos',90,'Pari',61982371)

INSERT INTO medicamento (nomeMed, apresentacao, undCadastro, preco)
VALUES
('Acetato de medroxiprogesterona','150 mg/ml','Ampola',6.700),
('Aciclovir','200mg/comp.','Comprimido',0.280),
('Ácido Acetilsalicílico','500mg/comp.','Comprimido',0.035),
('Ácido Acetilsalicílico','100mg/comp.','Comprimido',0.030),
('Ácido Fólico', '5mg/comp.','Comprimido',0.054),
('Albendazol','400mg/comp.mastigável','Comprimido',0.560),
('Alopurinol','100mg/comp.','Comprimido',0.080),
('Amiodarona','200mg/comp.','Comprimido',0.200),
('Amitriptilina(Cloridrato)','25mg/comp.','Comprimido',0.220),
('Amoxicilina','500mg/cáps.','Cápsula',0.190)

INSERT INTO mercadoria(notaFiscal, cpfCliente, codigoMedi, quantidade, valorTotal, dt)
VALUES
(31501,'869279818-25',10, 3,0.57,'2010-11-01'),
(31501,'869279818-25',2,10,2.8,'2010-11-01'),
(31501,'869279818-25',5,30,1.05,'2010-11-01'),
(31501,'869279818-25',8,30,6.6,	'2010-11-01'),
(31502,'343908987-00',8,15,3,'2010-11-01'),
(31502,'343908987-00',2,10,2.8,'2010-11-01'),
(31502,'343908987-00',9,10,2.2,'2010-11-01'),
(31503,'310981209-00',1,20,134,'2010-11-02')


/*Nome, apresentação, unidade e valor unitário dos remédios que ainda não 
	--foram vendidos. Caso a unidade de cadastro seja comprimido, mostrar Comp */

SELECT medicamento.nomeMed, medicamento.apresentacao, 
	CASE WHEN (medicamento.undCadastro = 'Comprimido') 
		THEN
			'comp'
		ELSE
			medicamento.undCadastro
	END AS novo, medicamento.preco
FROM medicamento LEFT OUTER JOIN mercadoria
ON medicamento.codigo = mercadoria.codigoMedi
WHERE mercadoria.codigoMedi IS NULL


--Nome dos clientes que compraram Amiodarona
SELECT cliente.nomeCli
FROM cliente INNER JOIN mercadoria
ON cliente.cpf = mercadoria.cpfCliente
INNER JOIN medicamento
ON medicamento.codigo = mercadoria.codigoMedi
WHERE medicamento.nomeMed = 'Amiodarona'

/*CPF do cliente, endereço concatenado, nome do medicamento (como nome de remédio),  
	apresentação do remédio, unidade, preço proposto, quantidade vendida e
	valor total dos remédios vendidos a Maria Zélia*/

SELECT cliente.nomeCli, cliente.cpf, cliente.rua + ',' + CAST(cliente.numeroRua AS VARCHAR (6))as enderecoComp, 
	medicamento.nomeMed + '-' + medicamento.apresentacao + ' -> ' + medicamento.undCadastro as dadosRemedio,
	medicamento.preco, mercadoria.quantidade, mercadoria.valorTotal
FROM cliente INNER JOIN mercadoria
ON cliente.cpf = mercadoria.cpfCliente
INNER JOIN medicamento
ON medicamento.codigo = mercadoria.codigoMedi
WHERE cliente.nomeCli = 'Maria Zélia'

--Data de compra, convertida, de Carlos Campos
SELECT mercadoria.dt
FROM cliente INNER JOIN mercadoria
ON cliente.cpf = mercadoria.cpfCliente
WHERE cliente.nomeCli = 'Carlos Campos'	

--Alterar o nome da  Amitriptilina(Cloridrato) para Cloridrato de Amitriptilina
UPDATE medicamento
SET nomeMed = 'Cloridrato de Amitriptilina'
WHERE nomeMed = 'Amitriptilina(Cloridrato)'


