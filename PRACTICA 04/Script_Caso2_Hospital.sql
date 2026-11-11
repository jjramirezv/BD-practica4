-- =========================================================
-- PRÁCTICA CALIFICADA 04 - CASO 2: Sistema de Gestión Hospitalaria Integral
-- Curso: Diseño de Base de Datos (IS064B) - VI Semestre
-- =========================================================

-- 1. Creamos la base de datos
USE master;
GO
IF DB_ID('HospitalBD') IS NOT NULL
    DROP DATABASE HospitalBD;
GO
CREATE DATABASE HospitalBD;
GO
USE HospitalBD;
GO

-- 2. Construimos la estructura (Tablas)

-- TABLA PADRE
CREATE TABLE Medicos (
    ID_Medico    INT PRIMARY KEY,
    CMP          CHAR(6) NOT NULL,
    Nombres      VARCHAR(50) NOT NULL,
    Apellidos    VARCHAR(50) NOT NULL,
    Especialidad VARCHAR(40) NOT NULL,
    Estado       BIT DEFAULT 1,                 -- 1 = Activo, 0 = Inactivo
    CONSTRAINT UQ_Medicos_CMP UNIQUE (CMP)      -- no pueden existir dos médicos con el mismo CMP
);

-- TABLA PADRE
CREATE TABLE Pacientes (
    ID_Paciente   INT PRIMARY KEY,
    DNI           CHAR(8) NOT NULL,
    Nombres       VARCHAR(50) NOT NULL,
    Apellidos     VARCHAR(50) NOT NULL,
    Fecha_Nac     DATE,
    Sexo          CHAR(1) NOT NULL,
    FechaRegistro DATE DEFAULT GETDATE(),       -- si no se indica, se guarda la fecha de hoy
    CONSTRAINT UQ_Pacientes_DNI  UNIQUE (DNI),  -- no pueden existir dos pacientes con el mismo DNI
    CONSTRAINT CK_Pacientes_Sexo CHECK (Sexo = 'M' OR Sexo = 'F')
);

-- TABLA HIJO
CREATE TABLE CitasMedicas (
    ID_Cita     INT PRIMARY KEY IDENTITY(1,1),
    ID_Medico   INT NOT NULL,                   -- NOT NULL: toda cita debe tener médico
    ID_Paciente INT NOT NULL,                   -- NOT NULL: toda cita debe tener paciente
    FechaHora   DATETIME NOT NULL,              -- día y hora de la cita
    Costo       DECIMAL(8,2) NOT NULL,
    Descuento   DECIMAL(8,2) DEFAULT 0,         -- descuento aplicado (al inicio 0)
    Estado      VARCHAR(20) DEFAULT 'Programada',

    CONSTRAINT FK_Cita_Medico     FOREIGN KEY (ID_Medico)   REFERENCES Medicos(ID_Medico),
    CONSTRAINT FK_Cita_Paciente   FOREIGN KEY (ID_Paciente) REFERENCES Pacientes(ID_Paciente),
    CONSTRAINT CK_Cita_Costo      CHECK (Costo > 0),       -- el costo no puede ser cero ni negativo
    CONSTRAINT CK_Cita_Descuento  CHECK (Descuento >= 0)   -- el descuento no puede ser negativo
);
GO

-- Mostramos todas las reglas aplicadas a las tablas
EXEC sp_helpconstraint 'Medicos';
EXEC sp_helpconstraint 'Pacientes';
EXEC sp_helpconstraint 'CitasMedicas';
GO


PRINT '--- PASO 1: INSERCIÓN DE DATOS ---';

-- No escribimos "Estado": se aplica el DEFAULT 1
INSERT INTO Medicos (ID_Medico, CMP, Nombres, Apellidos, Especialidad)
VALUES
(1, '045123', 'Carlos', 'Quispe Huamán', 'Cardiología'),
(2, '052874', 'María',  'Rojas Pérez',   'Pediatría'),
(3, '061390', 'Jorge',  'Mendoza Ríos',  'Traumatología');

-- No escribimos "FechaRegistro": se aplica el DEFAULT (fecha de hoy)
INSERT INTO Pacientes (ID_Paciente, DNI, Nombres, Apellidos, Fecha_Nac, Sexo)
VALUES
(1, '70123456', 'Ana',   'Torres Lazo',   '1990-05-14', 'F'),
(2, '71234567', 'Luis',  'Huamán Soto',   '1985-11-02', 'M'),
(3, '72345678', 'Rosa',  'Cárdenas Vega', '2015-03-20', 'F'),
(4, '73456789', 'Pedro', 'Salazar Núñez', '1978-07-09', 'M'),
(5, '74567890', 'Lucía', 'Poma Quispe',   '2019-01-30', 'F');

-- No escribimos "Descuento" ni "Estado": se aplican los DEFAULT 0 y 'Programada'
INSERT INTO CitasMedicas (ID_Medico, ID_Paciente, FechaHora, Costo)
VALUES
(1, 1, '2026-11-16 08:00', 180.00),   -- Ana   -> Cardiología
(3, 2, '2026-11-16 09:00',  90.00),   -- Luis  -> Traumatología
(2, 3, '2026-11-17 10:00', 200.00),   -- Rosa  -> Pediatría
(1, 4, '2026-11-17 11:00', 150.00),   -- Pedro -> Cardiología
(2, 5, '2026-11-18 15:00', 120.00);   -- Lucía -> Pediatría

SELECT * FROM Medicos;
SELECT * FROM Pacientes;
SELECT * FROM CitasMedicas;
GO


PRINT '--- PASO 2: COMPROBAMOS LAS REGLAS (estos INSERT DEBEN dar error en rojo) ---';

-- UNIQUE: el CMP '045123' ya existe
INSERT INTO Medicos (ID_Medico, CMP, Nombres, Apellidos, Especialidad)
VALUES (4, '045123', 'Pedro', 'Ramos', 'Neurología');

-- CHECK: costo negativo
INSERT INTO CitasMedicas (ID_Medico, ID_Paciente, FechaHora, Costo)
VALUES (1, 2, '2026-11-20 08:00', -50.00);

-- FOREIGN KEY: el médico 9 no existe
INSERT INTO CitasMedicas (ID_Medico, ID_Paciente, FechaHora, Costo)
VALUES (9, 1, '2026-11-20 09:00', 100.00);
GO


PRINT '--- PASO 3: DESCUENTOS (WHILE + IF...ELSE) ---';

SELECT 'Antes del descuento' AS Fase, * FROM CitasMedicas;

BEGIN TRAN;

DECLARE @i INT = 1, @costo DECIMAL(8,2);

WHILE @i <= 5
BEGIN
    -- Guardamos en @costo el costo de la cita del paciente número @i
    SELECT @costo = Costo FROM CitasMedicas WHERE ID_Paciente = @i;

    IF @costo > 150
    BEGIN
        UPDATE CitasMedicas
        SET Costo = Costo - 50,         -- supera S/ 150: descuento de S/ 50
            Descuento = 50
        WHERE ID_Paciente = @i;
    END
    ELSE
    BEGIN
        UPDATE CitasMedicas
        SET Costo = Costo - 20,         -- S/ 150 o menos: descuento de S/ 20
            Descuento = 20
        WHERE ID_Paciente = @i;
    END

    SET @i += 1;                        -- sin esto el bucle sería infinito
END

SELECT 'Después del descuento' AS Fase, * FROM CitasMedicas;

COMMIT;
GO


PRINT '--- PASO 4: OLVIDO DIGITAL ---';

-- Si borramos directamente al paciente:
--     DELETE FROM Pacientes WHERE ID_Paciente = 4;
-- SQL Server da ERROR, porque el paciente todavía tiene citas (FK_Cita_Paciente).
-- Solución: primero borramos sus citas (tabla hijo) y luego al paciente (tabla padre).

BEGIN TRAN;

DELETE FROM CitasMedicas WHERE ID_Paciente = 4;   -- 1° tabla hijo
DELETE FROM Pacientes    WHERE ID_Paciente = 4;   -- 2° tabla padre

SELECT 'Sobrevivientes' AS Fase, * FROM CitasMedicas;
SELECT * FROM Pacientes;

COMMIT;
GO
