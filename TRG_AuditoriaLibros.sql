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
