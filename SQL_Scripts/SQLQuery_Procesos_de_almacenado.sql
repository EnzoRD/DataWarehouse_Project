CREATE OR ALTER PROCEDURE DW.sp_PoblarDimCategorias AS
BEGIN
    INSERT INTO DW.DimCategorias (ID_Categoria, Nombre_Categoria)
    SELECT DISTINCT 
        ID_Categoria, 
        Nombre_Categoria
    FROM AdventureWorks2022.Stage.vw_Categorias
    WHERE NOT EXISTS (
        SELECT 1 
        FROM DataWarehouse_PT.DW.DimCategorias d
        WHERE d.ID_Categoria = AdventureWorks2022.Stage.vw_Categorias.ID_Categoria
    );
END;
GO


CREATE OR ALTER PROCEDURE DW.sp_PoblarDimSubcategorias AS
BEGIN
    INSERT INTO DW.DimSubcategorias (ID_Subcategoria, Nombre_Subcategoria, ID_Categoria)
    SELECT DISTINCT 
        ID_Subcategoria,
        Nombre_Subcategoria,
        ID_Categoria
    FROM AdventureWorks2022.Stage.vw_Subcategorias
    WHERE NOT EXISTS (
        SELECT 1 
        FROM DW.DimSubcategorias d
        WHERE d.ID_Subcategoria = AdventureWorks2022.Stage.vw_Subcategorias.ID_Subcategoria
    );
END;
GO


CREATE OR ALTER PROCEDURE DW.sp_PoblarDimProductos AS
BEGIN
    INSERT INTO DW.DimProductos (ID_Producto, Nombre, Precio, ID_Subcategoria)
    SELECT DISTINCT 
        ID_Producto,
        Nombre,
        Precio,
        ID_Subcategoria
    FROM AdventureWorks2022.Stage.vw_Productos
    WHERE NOT EXISTS (
        SELECT 1 
        FROM DW.DimProductos d
        WHERE d.ID_Producto = AdventureWorks2022.Stage.vw_Productos.ID_Producto
    );
END;
GO


CREATE OR ALTER PROCEDURE DW.sp_PoblarDimClientes AS
BEGIN
    INSERT INTO DW.DimClientes (ID_Cliente, Nombre, Apellido, Ciudad, Pais)
    SELECT DISTINCT 
        ID_Cliente, 
        Nombre, 
        Apellido, 
        Ciudad, 
        Pais
    FROM AdventureWorks2022.Stage.vw_Clientes
    WHERE NOT EXISTS (
        SELECT 1 
        FROM DW.DimClientes d
        WHERE d.ID_Cliente = AdventureWorks2022.Stage.vw_Clientes.ID_Cliente
    );
END;
GO

CREATE OR ALTER PROCEDURE DW.sp_PoblarDimTiempo AS
BEGIN
    INSERT INTO DW.DimTiempo (ID_Tiempo, Fecha, Año, Trimestre, Mes, Dia)
    SELECT 
        ROW_NUMBER() OVER (ORDER BY Fecha) AS ID_Tiempo,
        Fecha,
        YEAR(Fecha) AS Año,
        DATEPART(QUARTER, Fecha) AS Trimestre,
        MONTH(Fecha) AS Mes,
        DAY(Fecha) AS Dia
    FROM (SELECT DISTINCT Fecha FROM AdventureWorks2022.Stage.vw_Ventas) AS Fechas
    WHERE NOT EXISTS (
        SELECT 1 
        FROM DW.DimTiempo t
        WHERE t.Fecha = Fechas.Fecha
    );
END;
GO


CREATE OR ALTER PROCEDURE DW.sp_PoblarHechosVentas AS
BEGIN
    INSERT INTO DW.HechosVentas (ID_Producto, ID_Cliente, ID_Tiempo, Cantidad, Precio_Unitario, Descuento, Importe_Total)
    SELECT 
        v.ID_Producto,
        v.ID_Cliente,
        t.ID_Tiempo,
        v.Cantidad,
        v.Precio_Unitario,
        v.Descuento,
        v.Importe_Total
    FROM AdventureWorks2022.Stage.vw_Ventas v
    JOIN DW.DimTiempo t ON v.Fecha = t.Fecha
    WHERE NOT EXISTS (
        SELECT 1 
        FROM DW.HechosVentas h
        WHERE h.ID_Producto = v.ID_Producto
          AND h.ID_Cliente = v.ID_Cliente
          AND h.ID_Tiempo = t.ID_Tiempo
    );
END;
GO



EXEC DW.sp_PoblarDimCategorias;
EXEC DW.sp_PoblarDimSubcategorias;
EXEC DW.sp_PoblarDimProductos;
EXEC DW.sp_PoblarDimClientes;
EXEC DW.sp_PoblarDimTiempo;
EXEC DW.sp_PoblarHechosVentas;





