﻿CREATE TABLE produtos (
  CODIGO INT NOT NULL AUTO_INCREMENT,
  DESCRICAO VARCHAR(100) NOT NULL,
  PRECO_VENDA FLOAT NOT NULL,
  PRIMARY KEY (CODIGO),
  INDEX idx_PRODUTOS(CODIGO)
)
ENGINE = INNODB,
AUTO_INCREMENT = 20,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_0900_ai_ci,
ROW_FORMAT = DYNAMIC;