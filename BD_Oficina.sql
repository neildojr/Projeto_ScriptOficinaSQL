CREATE DATABASE OFICINA;

USE OFICINA;

CREATE TABLE CARRO(
	IDCARRO INT PRIMARY KEY AUTO_INCREMENT,
	MODELO VARCHAR(30) NOT NULL,
	PLACA VARCHAR(30) NOT NULL UNIQUE,
	ID_MARCA INT
);

CREATE TABLE CLIENTE(
	IDCLIENTE INT PRIMARY KEY AUTO_INCREMENT,
	NOME VARCHAR(30) NOT NULL,
	SEXO ENUM('M','F') NOT NULL,
	ID_CARRO INT UNIQUE
);

CREATE TABLE TELEFONE(
	IDTELEFONE INT PRIMARY KEY AUTO_INCREMENT,
	TIPO ENUM('CEL','RES','COM') NOT NULL,
	NUMERO VARCHAR(30) NOT NULL,
	ID_CLIENTE INT 
);

CREATE TABLE MARCA(
	IDMARCA INT PRIMARY KEY AUTO_INCREMENT,
	MARCA VARCHAR(30) UNIQUE
);


CREATE TABLE COR(
	IDCOR INT PRIMARY KEY AUTO_INCREMENT,
	COR VARCHAR(30) UNIQUE
);

CREATE TABLE CARRO_COR(
	ID_CARRO INT,
	ID_COR INT,
	PRIMARY KEY(ID_CARRO,ID_COR)
);

/* CONSTRAINTS */

ALTER TABLE TELEFONE 
ADD CONSTRAINT FK_TELEFONE_CLIENTE
FOREIGN KEY(ID_CLIENTE)
REFERENCES CLIENTE(IDCLIENTE);


ALTER TABLE CLIENTE
ADD CONSTRAINT FK_CLIENTE_CARRO
FOREIGN KEY(ID_CARRO)
REFERENCES CARRO(IDCARRO);


ALTER TABLE CARRO
ADD CONSTRAINT FK_CARRO_MARCA
FOREIGN KEY(ID_MARCA)
REFERENCES MARCA(IDMARCA);


ALTER TABLE CARRO_COR
ADD CONSTRAINT FK_COR
FOREIGN KEY(ID_COR)
REFERENCES COR(IDCOR);


ALTER TABLE CARRO_COR
ADD CONSTRAINT FK_CARRO
FOREIGN KEY(ID_CARRO)
REFERENCES CARRO(IDCARRO);

/* Criando BACKUP do sistema */

CREATE DATABASE BACKUP;

USE BACKUP;

CREATE TABLE BKP_CLIENTE(
	IDCLIENTEBKP INT PRIMARY KEY AUTO_INCREMENT,
	IDCLIENTE INT,
	NOME VARCHAR(30),
	SEXO ENUM('M', 'F'),
	ID_CARRO INT,
	DATA DATETIME,
	EVENTO CHAR(2)
);

CREATE TABLE BKP_TELEFONE(
	IDTELEFONE INT PRIMARY KEY AUTO_INCREMENT,
	IDTELEFONEBKP INT,
	ID_CLIENTE INT,
	TIPO_ORIGINAL CHAR(3),
	TIPO_NOVO CHAR(3),
	NUMERO_VELHO VARCHAR(30),
	NUMERO_NOVO VARCHAR(30),
	DATA DATETIME,
	EVENTO CHAR(2)
);
CREATE TABLE BKP_CARROS(
	IDBACKUP INT PRIMARY KEY AUTO_INCREMENT,
	IDCARRO INT,
	MODELO VARCHAR(30),
	PLACA VARCHAR(30),
	ID_MARCA INT,
	TIPO CHAR(1)
);

/* 
Criando as TRIGGERS que faram a ligação entre o banco
OFICINA e o BACKUP
  */
USE OFICINA;

DELIMITER $
CREATE TRIGGER BKP_NEWCAR
BEFORE INSERT ON CARRO
FOR EACH ROW
BEGIN
	INSERT INTO BACKUP.BKP_CARROS VALUES(NULL, NEW.IDCARRO, NEW.MODELO, NEW.PLACA, NEW.ID_MARCA,'I');
END
$
DELIMITER ;


DELIMITER $
CREATE TRIGGER BKP_DEL_CAR
AFTER DELETE ON CARRO
FOR EACH ROW
BEGIN
	INSERT INTO BACKUP.BKP_CARROS VALUES
	(NULL, OLD.IDCARRO, OLD.MODELO, OLD.PLACA, OLD.ID_MARCA,'D');
END
$
DELIMITER ;

DELIMITER $
CREATE TRIGGER BKP_NEWCLIENTE
BEFORE INSERT ON CLIENTE
FOR EACH ROW
BEGIN
	INSERT INTO BACKUP.BKP_CLIENTE VALUES (NULL, NEW.IDCLIENTE, NEW.NOME, NEW.SEXO, NEW.ID_CARRO, NOW(), 'I');
END
$
DELIMITER ;

DELIMITER $
CREATE TRIGGER BKP_ATT_TELEFONE
AFTER UPDATE ON TELEFONE
FOR EACH ROW
BEGIN
	INSERT INTO BACKUP.BKP_TELEFONE VALUES(NULL, NEW.IDTELEFONE, OLD.ID_CLIENTE, OLD.TIPO, NEW.TIPO, OLD.NUMERO, NEW.NUMERO, NOW(),'U');
END
$
DELIMITER ; 

/* Inserção na Tabela "MARCA" - MARCA */
INSERT INTO MARCA VALUES(NULL,'FIAT');
INSERT INTO MARCA VALUES(NULL,'VOLKSWAGEN');
INSERT INTO MARCA VALUES(NULL,'TOYOTA');
INSERT INTO MARCA VALUES(NULL,'FORD');
INSERT INTO MARCA VALUES(NULL,'NISSAN');
INSERT INTO MARCA VALUES(NULL,'citroen');
/*
  +---------+------------+
  | IDMARCA | MARCA      |
  +---------+------------+
  |       6 | citroen    |
  |       1 | FIAT       |
  |       4 | FORD       |
  |       5 | NISSAN     |
  |       3 | TOYOTA     |
  |       2 | VOLKSWAGEN |
  +---------+------------+
  6 rows in set (0.00 sec)
*/
/* Inserção na Tabela "CARRO" - CARROS */
INSERT INTO CARRO VALUES(NULL,'C3','PEN7556',6);
INSERT INTO CARRO VALUES(NULL,'UNO','BBJ-8495',1);
INSERT INTO CARRO VALUES(NULL,'ARGO','XIA-1137',1);
INSERT INTO CARRO VALUES(NULL,'GOL','GHO-3187',NULL);
INSERT INTO CARRO VALUES(NULL,'COROLA','NNN-8711',NULL);
INSERT INTO CARRO VALUES(NULL,'FUSION','XXX-6666',NULL);
INSERT INTO CARRO VALUES(NULL,'MARCH','IYQ-7943',NULL);
INSERT INTO CARRO VALUES(NULL,'CRONOS','GTB-7780',NULL);
INSERT INTO CARRO VALUES(NULL,'CAMRY','AFT-6973',NULL);
INSERT INTO CARRO VALUES(NULL,'KA','CUU-2424',4);
INSERT INTO CARRO VALUES(NULL,'VERSA','ROL-8006',5);
INSERT INTO CARRO VALUES(NULL,'C4','PVF-8876',2);
/*
+---------+--------+----------+----------+
| IDCARRO | MODELO | PLACA    | ID_MARCA |
+---------+--------+----------+----------+
|       1 | C3     | PEN7556  |        6 |
|       2 | UNO    | BBJ-8495 |        1 |
|       3 | ARGO   | XIA-1137 |        1 |
|       4 | GOL    | GHO-3187 |     NULL |
|       5 | COROLA | NNN-8711 |     NULL |
|       6 | FUSION | XXX-6666 |     NULL |
|       7 | MARCH  | IYQ-7943 |     NULL |
|       8 | CRONOS | GTB-7780 |     NULL |
|       9 | CAMRY  | AFT-6973 |     NULL |
|      10 | KA     | CUU-2424 |        4 |
|      11 | VERSA  | ROL-8006 |        5 |
|      12 | C4     | PVF-8876 |        2 |
+---------+--------+----------+----------+
12 rows in set (0.00 sec)
*/
/* Corrigindo os valores Nulos e CARROs vinculados a MARCAS errada*/
UPDATE CARRO
SET ID_MARCA = '1'
WHERE MODELO LIKE 'CRONOS';
UPDATE CARRO
SET ID_MARCA = '2'
WHERE MODELO LIKE 'GOL'; 
UPDATE CARRO
SET ID_MARCA = '3'
WHERE MODELO LIKE 'COROLA' OR MODELO LIKE 'CAMRY'; 
UPDATE CARRO
SET ID_MARCA = '4'
WHERE MODELO LIKE 'FUSION';
UPDATE CARRO
SET ID_MARCA = '5'
WHERE MODELO LIKE 'MARCH';
UPDATE CARRO
SET ID_MARCA = '6'
WHERE MODELO LIKE 'C3';

/* Preenchendo a TABELA "CLIENTE" com alguns CLIENTES */
INSERT INTO CLIENTE VALUES(NULL,'NEILDO JUNIOR','M', 1);
INSERT INTO CLIENTE VALUES(NULL,'JOSE MARIA','M', 2);
INSERT INTO CLIENTE VALUES(NULL,'SHEILA THAIS','F', 3);
INSERT INTO CLIENTE VALUES(NULL,'FERNANDA CUNHA','F', 5);
INSERT INTO CLIENTE VALUES(NULL,'PAOLA OLIVEIRA','F', 6);
INSERT INTO CLIENTE VALUES(NULL,'CAIO CASTRO','M', 8);
INSERT INTO CLIENTE VALUES(NULL,'ANA MARIA BRAGA','F', 9);
INSERT INTO CLIENTE VALUES(NULL,'FERNANDA LIMA','F', 10);
INSERT INTO CLIENTE VALUES(NULL,'DOM L','M', 11);
INSERT INTO CLIENTE VALUES(NULL,'PRICILA SENNA','F', 12);
/*
+-----------+-----------------+------+----------+
| IDCLIENTE | NOME            | SEXO | ID_CARRO |
+-----------+-----------------+------+----------+
|         1 | NEILDO JUNIOR   | M    |        1 |
|         2 | JOSE MARIA      | M    |        2 |
|         3 | SHEILA THAIS    | F    |        3 |
|         4 | FERNANDA CUNHA  | F    |        5 |
|         5 | PAOLA OLIVEIRA  | F    |        6 |
|         6 | CAIO CASTRO     | M    |        8 |
|         7 | ANA MARIA BRAGA | F    |        9 |
|         8 | FERNANDA LIMA   | F    |       10 |
|         9 | DOM L           | M    |       11 |
|        10 | PRICILA SENNA   | F    |       12 |
+-----------+-----------------+------+----------+
10 rows in set (0.00 sec)
*/

/* Inserindo cores na TABELA "COR" */
INSERT INTO COR(IDCOR,COR) VALUES(NULL,'PRETO');
INSERT INTO COR(IDCOR,COR) VALUES(NULL,'CINZA');
INSERT INTO COR(IDCOR,COR) VALUES(NULL,'BRANCO');
INSERT INTO COR(IDCOR,COR) VALUES(NULL,'VERMELHO');
INSERT INTO COR(IDCOR,COR) VALUES(NULL,'VERDE');
INSERT INTO COR(IDCOR,COR) VALUES(NULL,'AZUL');
INSERT INTO COR(IDCOR,COR) VALUES(NULL,'AMARELO');
INSERT INTO COR(IDCOR,COR) VALUES(NULL,'LARANJA');
INSERT INTO COR(IDCOR,COR) VALUES(NULL,'ANIL');
INSERT INTO COR(IDCOR,COR) VALUES(NULL,'VIOLETA');

 /* Vinculando as cores aos carros  */
INSERT INTO CARRO_COR(ID_CARRO,ID_COR) VALUES(1,3);
INSERT INTO CARRO_COR(ID_CARRO,ID_COR) VALUES(1,1);
INSERT INTO CARRO_COR(ID_CARRO,ID_COR) VALUES(2,3);
INSERT INTO CARRO_COR(ID_CARRO,ID_COR) VALUES(2,1);
INSERT INTO CARRO_COR(ID_CARRO,ID_COR) VALUES(3,3);
INSERT INTO CARRO_COR(ID_CARRO,ID_COR) VALUES(3,1);
INSERT INTO CARRO_COR(ID_CARRO,ID_COR) VALUES(4,1);
INSERT INTO CARRO_COR(ID_CARRO,ID_COR) VALUES(5,2);
INSERT INTO CARRO_COR(ID_CARRO,ID_COR) VALUES(6,4);
INSERT INTO CARRO_COR(ID_CARRO,ID_COR) VALUES(6,1);
INSERT INTO CARRO_COR(ID_CARRO,ID_COR) VALUES(7,5);
INSERT INTO CARRO_COR(ID_CARRO,ID_COR) VALUES(7,1);
INSERT INTO CARRO_COR(ID_CARRO,ID_COR) VALUES(8,8);
INSERT INTO CARRO_COR(ID_CARRO,ID_COR) VALUES(8,1);
INSERT INTO CARRO_COR(ID_CARRO,ID_COR) VALUES(9,10);
INSERT INTO CARRO_COR(ID_CARRO,ID_COR) VALUES(10,1);
INSERT INTO CARRO_COR(ID_CARRO,ID_COR) VALUES(10,9);

/* Verificação: */

SELECT CAR.IDCARRO, CAR.MODELO, MC.IDMARCA, MC.MARCA
FROM CARRO CAR
INNER JOIN MARCA MC
ON CAR.ID_MARCA = MC.IDMARCA
ORDER BY CAR.IDCARRO;
/*
+---------+--------+---------+------------+
| IDCARRO | MODELO | IDMARCA | MARCA      |
+---------+--------+---------+------------+
|       1 | C3     |       6 | citroen    |
|       2 | UNO    |       1 | FIAT       |
|       3 | ARGO   |       1 | FIAT       |
|       4 | GOL    |       2 | VOLKSWAGEN |
|       5 | COROLA |       3 | TOYOTA     |
|       6 | FUSION |       4 | FORD       |
|       7 | MARCH  |       5 | NISSAN     |
|       8 | CRONOS |       1 | FIAT       |
|       9 | CAMRY  |       3 | TOYOTA     |
|      10 | KA     |       4 | FORD       |
|      11 | VERSA  |       5 | NISSAN     |
|      12 | C4     |       2 | VOLKSWAGEN |
+---------+--------+---------+------------+
12 rows in set (0.01 sec)
*/
/* Inserindo dados na TABELA "TELEFONE*/
INSERT INTO TELEFONE (IDTELEFONE,TIPO,NUMERO,ID_CLIENTE) VALUES (NULL,'RES','994521783',1);
INSERT INTO TELEFONE (IDTELEFONE,TIPO,NUMERO,ID_CLIENTE) VALUES (NULL,'RES','446781987',5);
INSERT INTO TELEFONE (IDTELEFONE,TIPO,NUMERO,ID_CLIENTE) VALUES (NULL,'CEL','427798167',6);
INSERT INTO TELEFONE (IDTELEFONE,TIPO,NUMERO,ID_CLIENTE) VALUES (NULL,'CEL','315487922',2);
INSERT INTO TELEFONE (IDTELEFONE,TIPO,NUMERO,ID_CLIENTE) VALUES (NULL,'CEL','997815648',8);
INSERT INTO TELEFONE (IDTELEFONE,TIPO,NUMERO,ID_CLIENTE) VALUES (NULL,'CEL','487422999',9);
INSERT INTO TELEFONE (IDTELEFONE,TIPO,NUMERO,ID_CLIENTE) VALUES (NULL,'COM','478469749',10);

UPDATE TELEFONE SET TIPO = 'CEL'
WHERE ID_CLIENTE = 1;

/* Criando uma VIEW de visão Geral da tabela :"V_RELATORIO_GERAL" */
CREATE VIEW V_RELATORIO_GERAL AS
SELECT C.NOME AS "CLIENTE",
   C.SEXO,
   IFNULL(T.TIPO,'*SEM TIPO*') AS "TIPO",
   IFNULL(T.NUMERO,'*SEM TELEFONE*') AS "TELEFONE",
   CAR.PLACA,
       M.MARCA,
   CAR.MODELO,    
   COR AS "CORES"
FROM MARCA M
INNER JOIN CARRO CAR
		ON M.IDMARCA = CAR.ID_MARCA
	INNER JOIN CARRO_COR CARCOR
		ON CAR.IDCARRO = CARCOR.ID_CARRO
		INNER JOIN COR
			ON COR.IDCOR = CARCOR.ID_COR
			INNER JOIN CLIENTE C
				ON CAR.IDCARRO = C.ID_CARRO
			LEFT JOIN TELEFONE T
				ON C.IDCLIENTE = T.ID_CLIENTE;

				DESC V_RELATORIO_GERAL;


