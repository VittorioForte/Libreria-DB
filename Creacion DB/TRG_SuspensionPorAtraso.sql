
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

-- Prueba del trigger

--EXEC SP_RegistrarPrestamo 17, 1;

--UPDATE Prestamos
--SET Fecha_Devolucion_Prevista = '2024-06-01'
--WHERE ID_Prestamo = (SELECT MAX(ID_Prestamo) FROM Prestamos);

--EXEC SP_RegistrarDevolucion
--    @ID_Prestamo = 1005;
--GO

