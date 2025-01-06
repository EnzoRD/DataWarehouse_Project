CREATE OR ALTER VIEW Stage.vw_Categorias AS
SELECT DISTINCT
     ISNULL(ProductCategoryID, -1) AS ID_Categoria, -- Asignar -1 a valores NULL
	 ISNULL(Name, 'Sin Categoría') AS Nombre_Categoria
FROM Production.ProductCategory
UNION ALL
SELECT 
    -1 AS ID_Categoria, 
    'Sin Categoría' AS Nombre_Categoria;
GO

CREATE OR ALTER VIEW Stage.vw_Subcategorias AS
SELECT DISTINCT
	ISNULL(ProductSubcategoryID, -1) AS ID_Subcategoria, -- Asignar -1 si es NULL
    ISNULL(Name, 'Sin Subcategoría') AS Nombre_Subcategoria,
    ISNULL(ProductCategoryID, -1) AS ID_Categoria -- Asignar -1 si es NULL
FROM Production.ProductSubcategory
UNION ALL
SELECT 
    -1 AS ID_Subcategoria,
    'Sin Subcategoría' AS Nombre_Subcategoria,
    -1 AS ID_Categoria;
GO

CREATE OR ALTER VIEW Stage.vw_Productos AS
SELECT 
    p.ProductID AS ID_Producto,
    p.Name AS Nombre,
    p.ListPrice AS Precio,
    ISNULL(ps.ProductSubcategoryID, -1) AS ID_Subcategoria
FROM Production.Product p
LEFT JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID;
GO

CREATE OR ALTER VIEW Stage.vw_Clientes AS
SELECT DISTINCT
    c.CustomerID AS ID_Cliente,
    ISNULL(p.FirstName, 'Cliente Desconocido') AS Nombre,
    ISNULL(p.LastName, 'Desconocido') AS Apellido,
    ISNULL(a.City, 'Sin Ciudad') AS Ciudad,
    ISNULL(cr.Name, 'Sin País') AS Pais
FROM Sales.Customer c
LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Person.Address a ON c.CustomerID = a.AddressID
LEFT JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
LEFT JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
UNION
SELECT DISTINCT
    soh.CustomerID AS ID_Cliente,
    'Cliente Desconocido' AS Nombre,
    'Desconocido' AS Apellido,
    'Sin Ciudad' AS Ciudad,
    'Sin País' AS Pais
FROM Sales.SalesOrderHeader soh
WHERE NOT EXISTS (
    SELECT 1 
    FROM Sales.Customer c
    WHERE c.CustomerID = soh.CustomerID
);
GO



CREATE OR ALTER VIEW Stage.vw_Ventas AS
SELECT 
    sod.ProductID AS ID_Producto,
    c.ID_Cliente AS ID_Cliente, 
    soh.OrderDate AS Fecha,
    sod.OrderQty AS Cantidad,
    sod.UnitPrice AS Precio_Unitario,
    sod.UnitPriceDiscount AS Descuento,
    (sod.UnitPrice * sod.OrderQty) - (sod.UnitPriceDiscount * sod.OrderQty) AS Importe_Total
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
LEFT JOIN Stage.vw_Clientes c ON soh.CustomerID = c.ID_Cliente;
GO



SELECT DISTINCT s.ID_Categoria, c.ID_Categoria
FROM Stage.vw_Subcategorias s
LEFT JOIN Stage.vw_Categorias c ON s.ID_Categoria = c.ID_Categoria
WHERE c.ID_Categoria IS NULL;

SELECT DISTINCT v.ID_Cliente
FROM Stage.vw_Ventas v
LEFT JOIN Stage.vw_Clientes c ON v.ID_Cliente = c.ID_Cliente
order by ID_cliente ASC
WHERE c.ID_Cliente = -1

SELECT 
    sod.ProductID AS ID_Producto,
    ISNULL(c.ID_Cliente, -1) AS ID_Cliente, -- Cliente genérico si falta
    soh.OrderDate AS Fecha,
    sod.OrderQty AS Cantidad,
    sod.UnitPrice AS Precio_Unitario,
    sod.UnitPriceDiscount AS Descuento,
    (sod.UnitPrice * sod.OrderQty) - (sod.UnitPriceDiscount * sod.OrderQty) AS Importe_Total
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
LEFT JOIN Stage.vw_Clientes c ON soh.CustomerID = c.ID_Cliente
where ID_Cliente = -1


DELETE FROM DW.HechosVentas