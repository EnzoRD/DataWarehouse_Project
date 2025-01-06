CREATE TABLE DW.DimCategorias (
    ID_Categoria INT PRIMARY KEY,
    Nombre_Categoria NVARCHAR(100) NOT NULL
);
GO
CREATE TABLE DW.DimSubcategorias (
    ID_Subcategoria INT PRIMARY KEY,
    Nombre_Subcategoria NVARCHAR(100) NOT NULL,
    ID_Categoria INT NOT NULL FOREIGN KEY REFERENCES DW.DimCategorias(ID_Categoria)
);
GO
CREATE TABLE DW.DimProductos (
    ID_Producto INT PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Precio DECIMAL(10, 2) NOT NULL,
    ID_Subcategoria INT NOT NULL FOREIGN KEY REFERENCES DW.DimSubcategorias(ID_Subcategoria)
);
GO

CREATE TABLE DW.DimClientes (
    ID_Cliente INT PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL,
    Apellido NVARCHAR(50) NOT NULL,
    Ciudad NVARCHAR(100),
    Pais NVARCHAR(100)
);
GO
CREATE TABLE DW.DimTiempo (
    ID_Tiempo INT PRIMARY KEY,
    Fecha DATE NOT NULL,
    Año INT NOT NULL,
    Trimestre INT NOT NULL,
    Mes INT NOT NULL,
    Dia INT NOT NULL
);
GO
CREATE TABLE DW.HechosVentas (
    ID_Venta INT IDENTITY(1,1) PRIMARY KEY,
    ID_Producto INT NOT NULL FOREIGN KEY REFERENCES DW.DimProductos(ID_Producto),
    ID_Cliente INT NOT NULL FOREIGN KEY REFERENCES DW.DimClientes(ID_Cliente),
    ID_Tiempo INT NOT NULL FOREIGN KEY REFERENCES DW.DimTiempo(ID_Tiempo),
    Cantidad INT NOT NULL,
    Precio_Unitario DECIMAL(10, 2) NOT NULL,
    Descuento DECIMAL(10, 2) NOT NULL,
    Importe_Total DECIMAL(10, 2) NOT NULL
);
GO

