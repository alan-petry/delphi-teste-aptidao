﻿CREATE TABLE clientes (
  CODIGO INT NOT NULL AUTO_INCREMENT,
  NOME VARCHAR(100) NOT NULL,
  CIDADE VARCHAR(100) DEFAULT NULL,
  UF VARCHAR(2) DEFAULT NULL,
  PRIMARY KEY (CODIGO),
  INDEX idx_CLIENTES_CODIGO(CODIGO)
)
ENGINE = INNODB,
AUTO_INCREMENT = 20,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_0900_ai_ci,
ROW_FORMAT = DYNAMIC;