CREATE TABLE Estudiante (
  ID_Estudiante INT PRIMARY KEY,
  Nombres   VARCHAR(50) NOT NULL,
  Apellidos VARCHAR(50) NOT NULL,
  Fecha_Nac DATE,
  Estado    BIT DEFAULT 1
);
-- 1. Agregando un estudiante con todos los datos completos
INSERT INTO Estudiante (ID_Estudiante, Nombres, Apellidos, Fecha_Nac, Estado)
VALUES (1, 'Nicole Rocio', 'Vilcahuaman Remigio', '2000-10-27', 1);

-- 2. Agregando un estudiante aprovechando la regla "DEFAULT 1"
-- (Nota que no escribimos la columna 'Estado' arriba ni su valor abajo)
INSERT INTO Estudiante (ID_Estudiante, Nombres, Apellidos, Fecha_Nac)
VALUES (2, 'Carlos', 'Perez', '2001-08-22');

-- 3. Agregando varios estudiantes al mismo tiempo
INSERT INTO Estudiante (ID_Estudiante, Nombres, Apellidos, Fecha_Nac, Estado)
VALUES 
(3, 'Maria', 'Gomez', '1999-11-03', 0),
(4, 'Juan', 'Salazar', '2002-01-10', 1);

SELECT*FROM Estudiante;