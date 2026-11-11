CREATE TABLE Carrera (
  ID_Carrera INT PRIMARY KEY,
  Nombre     VARCHAR(80) NOT NULL
);

CREATE TABLE Estudiantes (
  ID_Estudiante INT PRIMARY KEY,
  Nombres       VARCHAR(50) NOT NULL,
  ID_Carrera    INT,
  CONSTRAINT FK_Est_Carrera
    FOREIGN KEY (ID_Carrera)
    REFERENCES Carrera(ID_Carrera)
);
SELECT*FROM Carrera;
SELECT*FROM Estudiantes;