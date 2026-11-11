-- 1. Eliminamos la tabla si ya existe
IF OBJECT_ID('libros') IS NOT NULL
    DROP TABLE libros;
GO

-- 2. Creamos la tabla "simple" (solo las columnas, sin reglas todavía)
CREATE TABLE libros(
    codigo INT NOT NULL,
    titulo VARCHAR(40),
    autor VARCHAR(30),
    editorial VARCHAR(15),
    precio DECIMAL(6,2)
);
GO

-- 3. Definimos la Llave Primaria
ALTER TABLE libros
ADD CONSTRAINT PK_libros_codigo PRIMARY KEY (codigo);
GO

-- 4. Definimos que no existan precios negativos (Regla CHECK)
ALTER TABLE libros
ADD CONSTRAINT CK_libros_precio CHECK (precio >= 0);
GO

-- 5. Definimos valores por defecto (Regla DEFAULT)
ALTER TABLE libros
ADD CONSTRAINT DF_libros_autor DEFAULT 'Desconocido' FOR autor;
GO

ALTER TABLE libros
ADD CONSTRAINT DF_libros_precio DEFAULT 0 FOR precio;
GO


-- 6. Ver todas las restricciones aplicadas a la tabla
EXEC sp_helpconstraint 'libros';
GO

-- 7. Eliminamos una regla por defecto y la llave primaria
ALTER TABLE libros 
DROP CONSTRAINT DF_libros_autor;
GO

ALTER TABLE libros 
DROP CONSTRAINT PK_libros_codigo;
GO

-- 8. Verificamos que se hayan borrado
EXEC sp_helpconstraint 'libros';
GO