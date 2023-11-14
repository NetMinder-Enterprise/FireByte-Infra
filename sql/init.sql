CREATE DATABASE IF NOT EXISTS firebyteDB;

CREATE USER IF NOT EXISTS 'firebyte'@'%' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON firebyteDB.* TO 'firebyte'@'%';
FLUSH PRIVILEGES;

USE firebyteDB;


-- -----------------------------------------------------
-- Table Empresa
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS empresa (
  id INT AUTO_INCREMENT NOT NULL,
  nomeFantasia VARCHAR(45) NOT NULL,
  razaoSocial VARCHAR(45) NOT NULL,
  CNPJ VARCHAR(18) NOT NULL,
  PRIMARY KEY (id)
);

-- -----------------------------------------------------
-- Table Dispositivo
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS dispositivo (
  id INT AUTO_INCREMENT NOT NULL,
  enderecoMAC VARCHAR(25) NOT NULL,
  fkEmpresa INT NOT NULL,
  titulo VARCHAR(45) NULL,
  descricao VARCHAR(255),
  ativo TINYINT,
  taxaAtualizacao INT,
  PRIMARY KEY (id),
  FOREIGN KEY (fkEmpresa) REFERENCES empresa (id)
);

-- -----------------------------------------------------
-- Table Componente
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tipoComponente (
  id INT AUTO_INCREMENT NOT NULL,
  nome VARCHAR(45),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS componentesDispositivos(
    id INT AUTO_INCREMENT NOT NULL,
    fkTipoComponente INT NOT NULL,
    fkDispositivo INT NOT NULL,
    PRIMARY KEY (id, fkTipoComponente, fkDispositivo),
    FOREIGN KEY (fkTipoComponente) REFERENCES tipoComponente(id),
    FOREIGN KEY (fkDispositivo) REFERENCES dispositivo(id)
);


-- -----------------------------------------------------
-- Table Log
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS log (
  id INT AUTO_INCREMENT NOT NULL,
  fkcomponenteDispositivo INT NOT NULL,
  dataHora DATETIME NOT NULL,
  captura INT NOT NULL,
  PRIMARY KEY (id, fkcomponenteDispositivo),
  FOREIGN KEY (fkcomponenteDispositivo) REFERENCES componentesDispositivos (id)
);


-- -----------------------------------------------------
-- Table NivelAcesso
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS nivelAcesso (
  id INT AUTO_INCREMENT NOT NULL,
  tipo VARCHAR(45) NOT NULL,
  ativo TINYINT,
  PRIMARY KEY (id)
);


-- -----------------------------------------------------
-- Table Usuario
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS usuario (
  id INT AUTO_INCREMENT NOT NULL,
  fkEmpresa INT NOT NULL,
  fkNivelAcesso INT NOT NULL,
  nome VARCHAR(45),
  email VARCHAR(100) NOT NULL,
  senha VARCHAR(45) NOT NULL,
  PRIMARY KEY (id, fkNivelAcesso),
  FOREIGN KEY (fkEmpresa) REFERENCES empresa (id),
  FOREIGN KEY (fkNivelAcesso) REFERENCES nivelAcesso (id)
);


-- -----------------------------------------------------
-- Table Contato
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS contato (
  id INT AUTO_INCREMENT NOT NULL,
  fkEmpresa INT NOT NULL,
  telefone VARCHAR(20),
  celular VARCHAR(15),
  email VARCHAR(100),
  PRIMARY KEY (id, fkEmpresa),
  FOREIGN KEY (fkEmpresa) REFERENCES empresa (id)
);


-- -----------------------------------------------------
-- Table Endereco
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS endereco (
  id INT AUTO_INCREMENT NOT NULL,
  fkEmpresa INT NOT NULL,
  cep VARCHAR(10) NOT NULL,
  logradouro VARCHAR(255) NOT NULL,
  numero VARCHAR(10) NOT NULL,
  complemento VARCHAR(45),
  PRIMARY KEY (id),
  FOREIGN KEY (fkEmpresa) REFERENCES empresa (id)
);


-- -----------------------------------------------------
-- Table Parametro
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS parametro (
  id INT AUTO_INCREMENT NOT NULL,
  fkEmpresa INT NOT NULL,
  fkComponente INT NOT NULL,
  limiteMax VARCHAR(45) NOT NULL,
  limiteMin VARCHAR(45) NOT NULL,
  metricaParametro VARCHAR(45) NOT NULL,
  PRIMARY KEY (id, fkEmpresa, fkComponente),
  FOREIGN KEY (fkComponente) REFERENCES tipoComponente (id),
  FOREIGN KEY (fkEmpresa) REFERENCES empresa (id)
);


INSERT INTO nivelAcesso (tipo, ativo) VALUES ('Administrador', 1), ('Usuário', 1), ('Convidado', 1);

INSERT INTO empresa (nomeFantasia, razaoSocial, CNPJ) VALUES ('Netminder', 'Netminder', '00.000.000/0000-00');

INSERT INTO usuario (fkEmpresa, fkNivelAcesso, nome, email, senha) VALUES (1, 1, 'Danilo', 'danilo.pedrazzi@sptech.school', '123');

INSERT INTO tipoComponente (nome) VALUES ('CPU'), ('RAM'), ('DISCO'), ('REDE');