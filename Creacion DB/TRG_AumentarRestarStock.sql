USE tp_sistema_gpb;
GO

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

