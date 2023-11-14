-- Drop existing connections and set the database to single-user mode
USE master;
-- Use the firebyteDB database
USE firebyteDB;

-- -----------------------------------------------------
-- Table Empresa
-- -----------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'empresa')
BEGIN
    CREATE TABLE empresa (
        id INT IDENTITY(1,1) PRIMARY KEY,
        nomeFantasia VARCHAR(45) NOT NULL,
        razaoSocial VARCHAR(45) NOT NULL,
        CNPJ VARCHAR(18) NOT NULL
    );
END

-- -----------------------------------------------------
-- Table Dispositivo
-- -----------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'dispositivo')
BEGIN
    CREATE TABLE dispositivo (
        id INT IDENTITY(1,1) PRIMARY KEY,
        enderecoMAC VARCHAR(25) NOT NULL,
        fkEmpresa INT NOT NULL,
        titulo VARCHAR(45) NULL,
        descricao VARCHAR(255),
        ativo BIT,
        taxaAtualizacao INT,
        FOREIGN KEY (fkEmpresa) REFERENCES empresa (id)
    );
END

-- -----------------------------------------------------
-- Table TipoComponente
-- -----------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tipoComponente')
BEGIN
    CREATE TABLE tipoComponente (
        id INT IDENTITY(1,1) PRIMARY KEY,
        nome VARCHAR(45)
    );
END

-- -----------------------------------------------------
-- Table ComponentesDispositivos
-- -----------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'componentesDispositivos')
BEGIN
    CREATE TABLE componentesDispositivos (
        id INT IDENTITY(1,1) PRIMARY KEY,
        fkTipoComponente INT NOT NULL,
        fkDispositivo INT NOT NULL,
        FOREIGN KEY (fkTipoComponente) REFERENCES tipoComponente(id),
        FOREIGN KEY (fkDispositivo) REFERENCES dispositivo(id)
    );
END

-- -----------------------------------------------------
-- Table Log
-- -----------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'log')
BEGIN
    CREATE TABLE log (
        id INT IDENTITY(1,1) PRIMARY KEY,
        fkcomponenteDispositivo INT NOT NULL,
        dataHora DATETIME NOT NULL,
        captura INT NOT NULL,
        FOREIGN KEY (fkcomponenteDispositivo) REFERENCES componentesDispositivos (id)
    );
END

-- -----------------------------------------------------
-- Table NivelAcesso
-- -----------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'nivelAcesso')
BEGIN
    CREATE TABLE nivelAcesso (
        id INT IDENTITY(1,1) PRIMARY KEY,
        tipo VARCHAR(45) NOT NULL,
        ativo BIT
    );
END

-- -----------------------------------------------------
-- Table Usuario
-- -----------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'usuario')
BEGIN
    CREATE TABLE usuario (
        id INT IDENTITY(1,1) PRIMARY KEY,
        fkEmpresa INT NOT NULL,
        fkNivelAcesso INT NOT NULL,
        nome VARCHAR(45),
        email VARCHAR(100) NOT NULL,
        senha VARCHAR(45) NOT NULL,
        FOREIGN KEY (fkEmpresa) REFERENCES empresa (id),
        FOREIGN KEY (fkNivelAcesso) REFERENCES nivelAcesso (id)
    );
END

-- -----------------------------------------------------
-- Table Contato
-- -----------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'contato')
BEGIN
    CREATE TABLE contato (
        id INT IDENTITY(1,1) PRIMARY KEY,
        fkEmpresa INT NOT NULL,
        telefone VARCHAR(20),
        celular VARCHAR(15),
        email VARCHAR(100),
        FOREIGN KEY (fkEmpresa) REFERENCES empresa (id)
    );
END

-- -----------------------------------------------------
-- Table Endereco
-- -----------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'endereco')
BEGIN
    CREATE TABLE endereco (
        id INT IDENTITY(1,1) PRIMARY KEY,
        fkEmpresa INT NOT NULL,
        cep VARCHAR(10) NOT NULL,
        logradouro VARCHAR(255) NOT NULL,
        numero VARCHAR(10) NOT NULL,
        complemento VARCHAR(45),
        FOREIGN KEY (fkEmpresa) REFERENCES empresa (id)
    );
END

-- -----------------------------------------------------
-- Table Parametro
-- -----------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'parametro')
BEGIN
    CREATE TABLE parametro (
        id INT IDENTITY(1,1) PRIMARY KEY,
        fkEmpresa INT NOT NULL,
        fkComponente INT NOT NULL,
        limiteMax VARCHAR(45) NOT NULL,
        limiteMin VARCHAR(45) NOT NULL,
        metricaParametro VARCHAR(45) NOT NULL,
        FOREIGN KEY (fkComponente) REFERENCES tipoComponente (id),
        FOREIGN KEY (fkEmpresa) REFERENCES empresa (id)
    );
END
