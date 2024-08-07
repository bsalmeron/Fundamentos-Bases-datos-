 -- funciones definadas por el sistema 
 -- funciones definas por el usuario 
CREATE FUNCTION dbo.CalculateIVA (@price DECIMAL(10,2), @ivaRate DECIMAL(5,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @price * (1 + @ivaRate / 100);
END;
GO

SELECT dbo.CalculateIVA(100.00, 13.00) AS PriceWithIVA;


USE Northwind;
GO

CREATE FUNCTION dbo.CalculateTotalDiscount (@OrderID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalDiscount DECIMAL(10, 2);
    
    SELECT @TotalDiscount = SUM(Quantity * UnitPrice * Discount)
    FROM [Order Details]
    WHERE OrderID = @OrderID;

    RETURN ISNULL(@TotalDiscount, 0);
END;
GO

 
SELECT 
    o.OrderID,
    o.CustomerID,
    o.OrderDate,
    dbo.CalculateTotalDiscount(o.OrderID) AS TotalDiscount
FROM Orders o
WHERE o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31'
ORDER BY o.OrderDate;