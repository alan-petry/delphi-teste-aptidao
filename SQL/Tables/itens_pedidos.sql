﻿CREATE TABLE itens_pedidos (
  ID_ITEM INT NOT NULL AUTO_INCREMENT,
  PEDIDO INT NOT NULL,
  PRODUTO INT NOT NULL,
  QUANTIDADE FLOAT NOT NULL,
  UNITARIO FLOAT NOT NULL,
  TOTAL FLOAT DEFAULT NULL,
  PRIMARY KEY (ID_ITEM),
  INDEX idx_ITENS_PEDIDOS(ID_ITEM)
)
ENGINE = INNODB,
AUTO_INCREMENT = 4,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_0900_ai_ci,
ROW_FORMAT = DYNAMIC;