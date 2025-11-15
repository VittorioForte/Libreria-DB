USE tp_sistema_gpb;
GO

-- Triggers

-- Trigger 1 (Exec desde aca hasta la siguiente linea de guiones)
-- Aumentar o restar stock

CREATE TRIGGER trg_RestarStockLibros
ON Prestamos
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Libros
    SET Libros.Stock_Disponible = Libros.Stock_Disponible - 1
    FROM Libros
    INNER JOIN inserted i ON Libros.ID_Libro = i.ID_Libro;
END;
GO

CREATE TRIGGER trg_AumentarStockLibros
ON Prestamos
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Libros
    SET Stock_Disponible = Stock_Disponible + 1
    FROM Libros
    INNER JOIN inserted i  ON Libros.ID_Libro = i.ID_Libro
    INNER JOIN deleted d   ON d.ID_Prestamo  = i.ID_Prestamo
    WHERE d.Fecha_Entrada IS NULL
    AND i.Fecha_Entrada IS NOT NULL;
END;
GO

-- Hasta aca Trigger 1


-- Trigger 2 (Exec desde aca hasta la siguiente linea de guiones)
-- Suspension por atraso

ALTER TABLE Sanciones
ADD Fecha_InicioSuspension DATE NULL,
    Fecha_FinSuspension DATE NULL;
GO


CREATE TRIGGER trg_SuspensionPorAtraso
ON Prestamos
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Sanciones (
        ID_Prestamo,
        Tipo,
        Monto,
        Fecha_Sancion,
        Fecha_InicioSuspension,
        Fecha_FinSuspension
    )
    SELECT
        i.ID_Prestamo,                    
        'Atraso en la devolución',        
        0,                                 
        i.Fecha_Entrada,                  
        i.Fecha_Entrada,                  
        DATEADD(DAY, 15, i.Fecha_Entrada) 
    FROM inserted i
    INNER JOIN deleted d 
        ON d.ID_Prestamo = i.ID_Prestamo
    WHERE 
        d.Fecha_Entrada IS NULL               
        AND i.Fecha_Entrada IS NOT NULL    
        AND i.Fecha_Entrada > i.Fecha_Devolucion_Prevista; 
END;
GO

-- Hasta aca Trigger 2


-- Trigger 3 (Exec desde aca hasta la siguiente linea de guiones)
-- Auditoria Libros

CREATE TABLE AuditoriaLibros (
    ID_Auditoria INT PRIMARY KEY IDENTITY(1,1),
    ID_Libro INT,
    Titulo_Anterior VARCHAR(100),
    Titulo_Nuevo VARCHAR(100),
    StockAnterior INT,
    StockNuevo INT,
    FechaCambio DATETIME DEFAULT GETDATE()
);
GO

CREATE TRIGGER trg_AuditoriaLibros
ON Libros
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO AuditoriaLibros (ID_Libro, Titulo_Anterior, Titulo_Nuevo, StockAnterior, StockNuevo)
    SELECT 
        d.ID_Libro,
        d.Titulo,
        i.Titulo,
        d.Stock_Disponible,
        i.Stock_Disponible
    FROM inserted i
    INNER JOIN deleted d ON i.ID_Libro = d.ID_Libro;
END;
GO


-- Hasta aca Trigger 3
