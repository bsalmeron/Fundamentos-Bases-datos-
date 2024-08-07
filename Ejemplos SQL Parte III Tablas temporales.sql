use Northwind

-- Tablas temporales 

-- Locales  #
-- Crear una tabla temporal local
CREATE TABLE #LocalTempTable (
    ProductID int,
    ProductName nvarchar(40),
    UnitsInStock smallint
);

INSERT INTO #LocalTempTable (ProductID, ProductName, UnitsInStock)
SELECT ProductID, ProductName, UnitsInStock
FROM Products
WHERE UnitsInStock < 20;

select * from  #LocalTempTable
-- Globales 
CREATE TABLE ##GlobalTempTable (
    ProductID int,
    ProductName nvarchar(40),
    UnitsInStock smallint
);

INSERT INTO ##GlobalTempTable (ProductID, ProductName, UnitsInStock)
SELECT ProductID, ProductName, UnitsInStock
FROM Products
WHERE UnitsInStock < 20;

select * from  ##GlobalTempTable

DROP TABLE ##GlobalTempTable