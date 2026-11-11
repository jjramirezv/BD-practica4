
IF OBJECT_ID('ProyectosTesis') 
IS NOT NULL DROP TABLE ProyectosTesis;

IF OBJECT_ID('LineasInvestigacion')
IS NOT NULL DROP TABLE LineasInvestigacion;
GO

--TABLA PADRE
CREATE TABLE LineasInvestigacion (
    ID_Linea INT PRIMARY KEY,
    NombreLinea VARCHAR(60) NOT NULL,
    CodigoArea CHAR(5) UNIQUE -- no puede existir dos áreas con el mismo código
);
--TABLA HIJO

CREATE TABLE ProyectosTesis (
    ID_Tesis INT PRIMARY KEY IDENTITY(1,1),
    Titulo VARCHAR(100) NOT NULL,
    Tesista VARCHAR(60) NOT NULL,
    ID_Linea INT,
    Presupuesto DECIMAL(8,2),
    Estado VARCHAR(20) DEFAULT 'En Revisión', 
    
    CONSTRAINT FK_Tesis_Linea FOREIGN KEY (ID_Linea) REFERENCES LineasInvestigacion(ID_Linea),
    CONSTRAINT CK_Presupuesto CHECK (Presupuesto >= 0) 
);
GO



PRINT '--- PASO 1: INSERCIÓN DE DATOS ---';


INSERT INTO LineasInvestigacion (ID_Linea, NombreLinea, CodigoArea)
VALUES 
(1, 'Inteligencia Artificial', 'IA001'),
(2, 'Ingeniería de Software', 'IS002'),
(3, 'Seguridad de la Información', 'SI003');


INSERT INTO ProyectosTesis (Titulo, Tesista, ID_Linea, Presupuesto)
VALUES 
('Redes Neuronales para Reconstrucción', 'Carlos Mendoza', 1, 1500.00),
('Sistema Web SIGEST', 'Ana Torres', 2, 800.00),
('Auditoría Ciberseguridad', 'Luis Rojas', 3, 2500.00),
('App Móvil para Retail', 'Maria Paz', 2, 1200.00);

SELECT * FROM LineasInvestigacion;
SELECT * FROM ProyectosTesis;
GO


PRINT '--- PASO 2: ACTUALIZACIÓN DE DATOS ---';


BEGIN TRAN;


UPDATE ProyectosTesis -- 
SET Estado = 'Aprobado'
WHERE ID_Tesis = 2;


UPDATE ProyectosTesis
SET Presupuesto = Presupuesto + 300.00
WHERE ID_Linea = 2;

-- Comprobar que cambios se realizaron
SELECT 'Después del UPDATE' AS Fase, * FROM ProyectosTesis;

COMMIT;
GO
--MERGE INTO(COMANDO QUE SIRVE PARA COMBINAR DATOS DE INSERT,UPDATEY DELETE)

PRINT '--- PASO 3: ELIMINACIÓN DE REGISTROS ---';


BEGIN TRAN;

DELETE FROM ProyectosTesis
WHERE ID_Tesis = 3;




DELETE FROM ProyectosTesis WHERE ID_Linea = 1; 
DELETE FROM LineasInvestigacion WHERE ID_Linea = 1; 

SELECT 'Sobrevivientes' AS Fase, * FROM ProyectosTesis;
SELECT * FROM LineasInvestigacion;


COMMIT;
GO