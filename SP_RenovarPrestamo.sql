USE tp_sistema_gpb;
GO

CREATE PROCEDURE SP_RenovarPrestamo
    @ID_Prestamo INT,
    @DiasExtra INT = 7
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        -- 1. Verificar que el préstamo exista
        IF NOT EXISTS (SELECT 1 FROM Prestamos WHERE ID_Prestamo = @ID_Prestamo)
        BEGIN
            RAISERROR('Error: El préstamo no existe.', 16, 1);
            RETURN;
        END

        DECLARE @FechaPrevista DATE, @FechaEntrada DATE;

        -- Traemos fechas actuales
        SELECT 
            @FechaPrevista = Fecha_Devolucion_Prevista,
            @FechaEntrada = Fecha_Entrada
        FROM Prestamos
        WHERE ID_Prestamo = @ID_Prestamo;

        -- 2. No se puede renovar si ya fue devuelto
        IF @FechaEntrada IS NOT NULL
        BEGIN
            RAISERROR('Error: No se puede renovar un préstamo ya devuelto.', 16, 1);
            RETURN;
        END

        -- 3. No se puede renovar si ya está vencido
        IF @FechaPrevista < GETDATE()
        BEGIN
            RAISERROR('Error: El préstamo está vencido. No puede renovarse.', 16, 1);
            RETURN;
        END

        -- 4. Renovación → se suman días
        UPDATE Prestamos
        SET Fecha_Devolucion_Prevista = DATEADD(day, @DiasExtra, Fecha_Devolucion_Prevista)
        WHERE ID_Prestamo = @ID_Prestamo;

        PRINT 'Préstamo renovado correctamente.';

    END TRY
    BEGIN CATCH
        PRINT 'Error inesperado: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
