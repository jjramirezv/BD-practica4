-- 1. -- 1. Creamos la base de datos de nuestro laboratorio
CREATE DATABASE LaboratorioSemana09;
GO
USE LaboratorioSemana09;
GO
-- 2. Construimos la estructura (Tablas)
CREATE TABLE Categorias (
    ID INT PRIMARY KEY,
    CategoriaID INT 
);

CREATE TABLE Productos (
    ProductoID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50),
    Precio DECIMAL(10,2),
    CategoriaID INT
);
GO

-- 3. Llenamos el inventario con precios originales
INSERT INTO Categorias (ID, CategoriaID) 
VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

INSERT INTO Productos (Nombre, Precio, CategoriaID) 
VALUES 
('Laptop HP', 1000.00, 1),
('Mouse Inalámbrico', 50.00, 1),
('Teclado Mecánico', 120.00, 2),
('Monitor 24 pulgadas', 300.00, 3),
('Cable HDMI', 15.00, 4),
('Funda protectora', 25.00, 5);
GO

-- Vemos los precios ANTES del descuento
SELECT * FROM Productos;