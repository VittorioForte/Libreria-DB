USE tp_sistema_gpb;
GO

--Se agrega las columnas para las fechas de inicio y fin de suspensión en la tabla Sanciones

ALTER TABLE Sanciones
ADD 
    Fecha_InicioSuspension DATE NULL,
    Fecha_FinSuspension DATE NULL;
GO

--Se crea el trigger para actualizar las fechas de suspensión al insertar una sanción de tipo "Suspensión por Atraso"
--La fecha de inicio será la fecha de sanción y la fecha de fin será 15 días después.

CREATE TRIGGER trg_SancionPorRetraso
ON dbo.Prestamos
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @ID_Prestamo INT,
        @ID_Estudiante INT,
        @FechaDevolucionPrevista DATE,
        @FechaEntrada DATE;

    -- Tomamos los datos del préstamo actualizado
    SELECT 
        @ID_Prestamo = i.ID_Prestamo,
        @ID_Estudiante = i.ID_Estudiante,
        @FechaDevolucionPrevista = i.Fecha_Devolucion_Prevista,
        @FechaEntrada = i.Fecha_Entrada
    FROM inserted i
    INNER JOIN deleted d ON i.ID_Prestamo = d.ID_Prestamo
    WHERE d.Fecha_Entrada IS NULL AND i.Fecha_Entrada IS NOT NULL;

    -- Si la devolución es posterior a la prevista, se aplica sanción
    IF @FechaEntrada >= @FechaDevolucionPrevista
    BEGIN
        INSERT INTO Sanciones (ID_Prestamo, Tipo, Fecha_Sancion)
        VALUES (@ID_Prestamo, 'Retraso en devolución', GETDATE());

        UPDATE Sanciones
        SET 
            Fecha_InicioSuspension = GETDATE(),
            Fecha_FinSuspension = DATEADD(DAY, 15, GETDATE())
        WHERE ID_Prestamo = @ID_Prestamo;
    END
END;
GO
