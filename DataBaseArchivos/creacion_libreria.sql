CREATE DATABASE tp_sistema_gpb;
GO
USE tp_sistema_gpb;
GO
-- AUTORES
CREATE TABLE Autores (
    ID_Autor INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Autor VARCHAR(100) NOT NULL
);
GO
-- CATEGORIAS
CREATE TABLE Categorias (
    ID_Categoria INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Categoria VARCHAR(100) NOT NULL
);
GO
-- LIBROS
CREATE TABLE Libros (
    ID_Libro INT PRIMARY KEY IDENTITY(1,1),
    Titulo VARCHAR(100) NOT NULL,
    ISBN VARCHAR(40),
    ID_Autor INT NOT NULL,
    ID_Categoria INT NOT NULL,
    Stock_Total INT DEFAULT 0,
    Stock_Disponible INT DEFAULT 0,
    FOREIGN KEY (ID_Autor) REFERENCES Autores(ID_Autor),
    FOREIGN KEY (ID_Categoria) REFERENCES Categorias(ID_Categoria)
);
GO
-- USUARIOS 
CREATE TABLE Usuarios (
    ID_Estudiante INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(40) NOT NULL,
    Apellido VARCHAR(40) NOT NULL,
    DNI_Legajo VARCHAR(40) UNIQUE NOT NULL,
    Email VARCHAR(40),
    Fecha_Registro DATE DEFAULT GETDATE()
);
GO
-- TABLA: PRESTAMOS
CREATE TABLE Prestamos (
    ID_Prestamo INT PRIMARY KEY IDENTITY(1,1),
    ID_Libro INT NOT NULL,
    ID_Estudiante INT NOT NULL,
    Fecha_Salida DATE DEFAULT GETDATE(),
    Fecha_Devolucion_Prevista DATE NOT NULL,
    Fecha_Entrada DATE NULL,
    FOREIGN KEY (ID_Libro) REFERENCES Libros(ID_Libro),
    FOREIGN KEY (ID_Estudiante) REFERENCES Usuarios(ID_Estudiante)
);
GO
-- SANCIONES
CREATE TABLE Sanciones (
    ID_Sancion INT PRIMARY KEY IDENTITY(1,1),
    ID_Prestamo INT NOT NULL,
    Tipo VARCHAR(50),
    Monto DECIMAL(10,2) DEFAULT 0,
    Fecha_Sancion DATE DEFAULT GETDATE(),
    FOREIGN KEY (ID_Prestamo) REFERENCES Prestamos(ID_Prestamo)
);
GO

