 /*Ejercicio 1: Inner Join Básico entre Pedidos y Clientes
Descripción: Obtener una lista detallada de todos 
los pedidos realizados y sus respectivos clientes.
•	Tablas involucradas: Orders, Customers
•	Campos a mostrar: OrderID, OrderDate, CustomerID, CompanyName
*/

SELECT 
Orders.OrderID,
Orders.OrderDate,
Customers.CustomerID,
Customers.CompanyName
FROM Orders
INNER JOIN  Customers
ON Orders.CustomerID= Customers.CustomerID

/*
Ejercicio 2: Inner Join entre Productos y Categorías
Descripción: Listar los productos junto con la categoría 
a la que pertenecen.
•	Tablas involucradas: Products, Categories
•	Campos a mostrar: ProductID, ProductName, CategoryName
*/

SELECT *
FROM 
Products P
INNER JOIN Categories C
ON P.CategoryID= C.CategoryID

/*
Ejercicio 3: Inner Join con Detalles del Pedido y Productos
Descripción: Obtener los detalles específicos de cada pedido,
incluyendo información detallada de los productos.
•	Tablas involucradas: Order Details, Products
•	Campos a mostrar: OrderID, ProductID,
ProductName, Quantity, UnitPrice
*/ 

SELECT Detalles.OrderID, Products.ProductID, 
Products.ProductName, Detalles.Quantity, Products.UnitPrice
FROM [Order Details] Detalles
INNER JOIN Products 
ON Detalles.ProductID = Products.ProductID
ORDER BY Detalles.OrderID ASC
-- Reporte de lineas de pedido 
SELECT Detalle.OrderID, Detalle.ProductID,
Detalle.UnitPrice,Products.UnitPrice precioHoy, Categories.CategoryName, 
Detalle.Quantity, Detalle.Discount,
Orders.OrderDate OrderDate FROM [Order Details] Detalle
INNER JOIN Orders
ON Detalle.OrderID = Orders.OrderID 
INNER JOIN Products
ON  Detalle.ProductID = Products.ProductID
INNER JOIN Categories
ON Products.CategoryID = Categories.CategoryID
WHERE Detalle.ProductID=2
ORDER BY Orders.OrderID ASC
--- Reporte de ventas por orden 
 SELECT 
        [Order Details].OrderID,
        SUM( ([Order Details].UnitPrice * [Order Details].Quantity * (1 - [Order Details].Discount))) AS TotalPrice
    FROM 
        [Order Details]
    INNER JOIN 
        Products
    ON 
        [Order Details].ProductID = Products.ProductID
     
   GROUP BY [Order Details].OrderID 
   ORDER BY [Order Details].OrderID ASC

--Procedimientos almacenados 
--Vistas
--Funciones  (escalares, tabla, system)
--Triggers
--Jobs 



CREATE PROCEDURE CalculateTotalPrice
    @OrderID INT  
   
AS
BEGIN
    SELECT 
        [Order Details].OrderID,
        [Order Details].ProductID,
        Products.ProductName,
        [Order Details].UnitPrice,
        [Order Details].Quantity,
        [Order Details].Discount,
        ([Order Details].UnitPrice * [Order Details].Quantity * (1 - [Order Details].Discount)) AS TotalPrice
    FROM 
        [Order Details]
    INNER JOIN 
        Products
    ON 
        [Order Details].ProductID = Products.ProductID
    WHERE
          [Order Details].OrderID = @OrderID 
         
END;

EXEC CalculateTotalPrice 10255

-- Seguridad 
-- Reutilizacion 
-- Reglas 

--Conceptos generales de SQL 

-- AND, OR, NOT 
use [Northwind] 

SELECT * FROM Products 
where (UnitPrice >20) AND (UnitsInStock < 50)
order by  UnitPrice desc

SELECT * 
FROM Products
WHERE CategoryID = 1 OR CategoryID = 2
ORDER BY CategoryID DESC

--Funciones de agregación: MIN, MAX, COUNT, SUM, AVG

SELECT MIN(UnitPrice) AS MinPrice 
FROM Products;
SELECT MAX(UnitPrice) AS MaxPrice 
FROM Products;
SELECT COUNT(*) AS ProductCount 
FROM Products;
SELECT SUM(UnitsInStock) AS TotalStock 
FROM Products;
SELECT AVG(UnitPrice) AS AveragePrice 
FROM Products;

-- LIKE y comodines
USE Northwind

 SELECT ProductName FROM Products 
 WHERE ProductName LIKE 'C%'

 SELECT ProductName FROM Products 
 WHERE ProductName LIKE '%A'

 SELECT ProductName, CategoryID FROM Products 
 WHERE  (CategoryID = 1) AND  (  ProductName LIKE '%Ch%') AND ( UnitPrice >50)

 -- IN
 Select  ProductName, CategoryID from Products
 where CategoryID IN (1,2,3)
 order by CategoryID 

-- BETWEEN
SELECT ProductName, UnitPrice 
FROM Products
WHERE UnitPrice BETWEEN 10 AND 20;

-- UNION
 
 SELECT Distinct City  FROM (SELECT City From Customers
 UNION 
SELECT City From Suppliers) AS Ciudad

 -- EXISTS
SELECT ProductName
FROM Products
WHERE EXISTS (SELECT * 
              FROM [Order Details]
              WHERE Products.ProductID = [Order Details].ProductID);


SELECT Distinct ProductName FROM Products 
INNER JOIN [Order Details]
ON Products.ProductID = [Order Details].ProductID



-- Investigar 
-- Diferencias Vistas, SP, Funciones y Triggers
--USO 

--ANY, ALL
use [Northwind]

SELECT UnitPrice 
                       FROM Products 
                       WHERE CategoryID = 1
--ANY Permite que una condicion sea verdadera si se cumpe para al menos 
--uno de los valores devueltos de la subconsulta

SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice > ANY (SELECT UnitPrice 
                       FROM Products 
                       WHERE CategoryID = 1);

-- ALL permite que una condicion sea verdadera si cumple
--para todos los valores devueltos por la sub consulta 
SELECT ProductName , UnitPrice
FROM Products
WHERE UnitPrice > ALL (SELECT UnitPrice 
                       FROM Products 
                       WHERE CategoryID = 1);

USE Northwind;
GO

SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice > ALL (SELECT UnitPrice FROM Products WHERE CategoryID = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Beverages'));

-- SELECT INTO 
--COpia 
 select * from Orders

 Select * Into Respaldo_Orders
 From Orders


 select * from Respaldo_Orders

 -- INSERT TO SELECT

 USE Northwind;
GO

-- Crear la tabla HighValueOrders
CREATE TABLE HighValueOrders (
    OrderID INT,
    ProductID INT,
    UnitPrice MONEY,
    Quantity SMALLINT,
    Discount REAL,
    TotalPrice MONEY
);
GO

Select * from HighValueOrders
INSERT INTO HighValueOrders (OrderID, ProductID, UnitPrice, Quantity, Discount, TotalPrice)
SELECT od.OrderID, od.ProductID, od.UnitPrice, od.Quantity,
od.Discount, (od.UnitPrice * od.Quantity) AS TotalPrice
FROM [Order Details] od
WHERE (od.UnitPrice * od.Quantity) > 100;

--CASE 

SELECT ProductName,UnitPrice,
CASE 
	 WHEN UnitPrice >50 THEN 'Caro'
	 WHEN UnitPrice BETWEEN 20 AND  50 THEN 'Moderado'
	 ELSE 'Barato'
END  'PrecioCategoria'
FROM  Products

-- Funciones Null
USE Northwind;
GO

SELECT EmployeeID, FirstName, LastName, ISNULL(Region, 'No Region') 'Region', Region AS Region  
FROM Employees;

USE Northwind;
GO

SELECT EmployeeID, FirstName, LastName, NULLIF(Title, 'Sales Representative') 'TitleNull' ,
Title AS Title
FROM Employees;

--UNIQUE campos unicos 

  USE Northwind;
GO

-- Crear la tabla Usuarios
CREATE TABLE Usuarios (
    UsuarioID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100),
    CorreoElectronico NVARCHAR(255) UNIQUE
);
GO

-- Insertar datos en la tabla Usuarios
INSERT INTO Usuarios (Nombre, CorreoElectronico)
VALUES ('Juan Perez', 'juan.perez@example.com'),
       ('Ana Gómez', 'ana.gomez@example.com');
GO

INSERT INTO Usuarios (Nombre, CorreoElectronico)
VALUES ('Carlos López', 'juan.perez@example.com');
GO

SELECT *  FROM Usuarios

-- Agregar la restricción UNIQUE a la columna Email
ALTER TABLE Clientes
ADD CONSTRAINT UQ_Email UNIQUE (Email);
GO

CREATE TABLE Empleados (
    EmpleadoID INT PRIMARY KEY IDENTITY(1,1), -- Primary Key
    Nombre NVARCHAR(100) NOT NULL, -- Not Null
    Email NVARCHAR(255) UNIQUE, -- Unique
    FechaNacimiento DATE CHECK (FechaNacimiento <= GETDATE()), -- Check
    Salario DECIMAL(18,2) DEFAULT 0, -- Default
    DepartamentoID INT FOREIGN KEY REFERENCES Departamentos(DepartamentoID) -- Foreign Key
);
GO

-- Manejo de fechas 

USE Northwind;
GO

-- Obtener pedidos que se realizaron hoy
SELECT OrderID, CustomerID, OrderDate,  CAST(OrderDate AS DATE) 'Cast',
RequiredDate, ShippedDate
FROM Orders
WHERE CAST(OrderDate AS DATE) = CAST('1996-07-05 00:00:00.000' AS DATE);
GO

-- Obtener pedidos que se realizarán en el futuro
SELECT OrderID, CustomerID, OrderDate, RequiredDate, ShippedDate
FROM Orders
WHERE OrderDate > GETDATE();
GO

Select * from Orders 
where OrderDate ='1996-07-05 00:00:00.000'

Update Orders
set  OrderDate = '2024-07-25 00:00:00.000'
where OrderDate ='1996-07-05 00:00:00.000'


-- Obtener pedidos que ya han sido enviados
SELECT OrderID, CustomerID, OrderDate, RequiredDate, 
CAST( ShippedDate AS DATE) 'ShippedDate'
FROM Orders
WHERE (ShippedDate IS NOT NULL ) AND (ShippedDate < GETDATE());
GO

SELECT GETDATE()
-- Calcular el tiempo en días entre la fecha de pedido y la fecha requerida
SELECT OrderID, CustomerID, OrderDate, RequiredDate, 
       DATEDIFF(MONTH, OrderDate, RequiredDate) AS DiasParaRequerir
FROM Orders;
GO

-- Mostrar las ordenes con 10 dias de mas  
 SELECT OrderID, OrderDate, DATEADD(DAY, 10, OrderDate) FROM 
 Orders 
-- Postergar la fecha requerida de todos los pedidos una semana
UPDATE Orders
SET RequiredDate = DATEADD(WEEK, 1, RequiredDate);
GO

-- Cambiar la fecha de envío de un pedido específico
Begin Tran 
UPDATE Orders
SET ShippedDate = DATEADD(HOUR, 48, ShippedDate)
WHERE OrderID = 10248;
GO

SELECT  * FROM   Orders
-- Verificar los datos actualizados
SELECT OrderID, CustomerID, OrderDate, RequiredDate, ShippedDate
FROM Orders
WHERE OrderID = 10248;
GO

--Microsoft Certified: SQL Server Database Administrator
--Microsoft Certified: Azure Data Engineer Associate
--AZURE  
--AWS  
--Google Cloud 


-- SP 

CREATE PROCEDURE GetCustomerOrders
    @CustomerID NVARCHAR(5)
AS
BEGIN
    SELECT * FROM Orders
    WHERE CustomerID = @CustomerID;
END;
GO

EXEC GetCustomerOrders   'ALFKI';


CREATE PROCEDURE GetTotalOrders
    @CustomerID NVARCHAR(5),
    @TotalOrders INT OUTPUT
AS
BEGIN
    SELECT @TotalOrders = COUNT(*)
    FROM Orders
    WHERE CustomerID = @CustomerID;
END;
GO


DECLARE @Total INT;

EXEC GetTotalOrders @CustomerID = 'ALFKI', @TotalOrders = @Total OUTPUT;
SELECT @Total AS TotalOrders;

--

CREATE PROCEDURE AddCustomer
    @CustomerID NVARCHAR(5),
    @CompanyName NVARCHAR(40),
    @ContactName NVARCHAR(30),
    @ContactTitle NVARCHAR(30),
    @Address NVARCHAR(60),
    @City NVARCHAR(15),
    @Region NVARCHAR(15),
    @PostalCode NVARCHAR(10),
    @Country NVARCHAR(15),
    @Phone NVARCHAR(24),
    @Fax NVARCHAR(24)
AS
BEGIN
    INSERT INTO Customers
        (CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax)
    VALUES
        (@CustomerID, @CompanyName, @ContactName, @ContactTitle, @Address, @City, @Region, @PostalCode, @Country, @Phone, @Fax);
END;
GO


EXEC AddCustomer 
    @CustomerID = 'NEWID',
    @CompanyName = 'New Company',
    @ContactName = 'John Doe',
    @ContactTitle = 'Manager',
    @Address = '123 New Street',
    @City = 'New City',
    @Region = 'NC',
    @PostalCode = '12345',
    @Country = 'Countryland',
    @Phone = '123-456-7890',
    @Fax = '123-456-7891';

--VISTAS

CREATE VIEW AllCustomers AS
SELECT 
    CustomerID,
    CompanyName,
    ContactName,
    ContactTitle,
    Address,
    City,
    Region,
    PostalCode,
    Country,
    Phone,
    Fax
FROM 
    Customers;
GO

SELECT * FROM AllCustomers


CREATE VIEW DetailedOrderInfo AS
SELECT 
    o.OrderID,
    o.OrderDate,
    o.RequiredDate,
    o.ShippedDate,
    c.CustomerID,
    c.CompanyName AS CustomerCompanyName,
    c.ContactName AS CustomerContactName,
    e.EmployeeID,
    e.FirstName AS EmployeeFirstName,
    e.LastName AS EmployeeLastName,
    p.ProductID,
    p.ProductName,
    od.UnitPrice,
    od.Quantity,
    (od.UnitPrice * od.Quantity) AS LineTotal
FROM 
    Orders o
INNER JOIN 
    Customers c ON o.CustomerID = c.CustomerID
INNER JOIN 
    Employees e ON o.EmployeeID = e.EmployeeID
INNER JOIN 
    [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN 
    Products p ON od.ProductID = p.ProductID;
GO


SELECT * FROM  DetailedOrderInfo 