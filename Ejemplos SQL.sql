USE Northwind

SELECT A.CustomerID, A.CompanyName, B.OrderID FROM 
Customers A 
INNER JOIN 
Orders B 
ON 
A.CustomerID = B.CustomerID
order by B.OrderID DESC 

--Caso 1 Cuantas ordenes tiene un cliente 
SELECT Customers.CustomerID, COUNT( Orders.OrderID)'CantidadOrdenes' FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID
HAVING COUNT( Orders.OrderID)> 10
ORDER BY   COUNT( Orders.OrderID) , Customers.CustomerID DESC

--Mostrar Nombre del empleado que hizo una orden
--IdOrden    NombreEmpleado
--1          Brayner   
select * from Orders
Select * from Employees

select Orders.OrderID , Employees.FirstName from Orders
INNER JOIN Employees
ON Orders.EmployeeID = Employees.EmployeeID
    

--Ejercicio 2: Lista de productos junto con las 
--categorías a las que pertenecen.
--Campos a mostrar: ProductName, CategoryName
select Products.ProductName, Categories.CategoryName from Products 
inner join Categories on Categories.CategoryID = Products.CategoryID







Select trasmision , color , count(ID)
from carros
Group by trasmision, color

Manuales 
2 Rojos
1 vERDE
1 AZUL
/*
Carros Manuales 
Rojo
Rojo
Verde
Azul

Carros Automaticos 
Amarillo
Verde
Rosa
Naranja 
Verde


*/


select * from TAB




 
