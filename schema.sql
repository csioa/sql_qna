CREATE SCHEMA practice;
USE practice;
CREATE TABLE customer (
  customerId INTEGER NOT NULL,
  firstName VARCHAR(30),
  lastName VARCHAR(30),
  PRIMARY KEY (customerId)
);
CREATE TABLE store (
  storeId INTEGER NOT NULL,
  city VARCHAR(30),
  country VARCHAR(30),
  PRIMARY KEY (storeId)
);
CREATE TABLE transaction (
   transactionId INTEGER NOT NULL,
   storeId INTEGER NOT NULL,
   customerId INTEGER NOT NULL,
   transactionTimestamp INTEGER,
   amount FLOAT,
   PRIMARY KEY (transactionId),
   FOREIGN KEY (customerId) REFERENCES customer(customerId),
   FOREIGN KEY (storeId) REFERENCES store(storeId)
);