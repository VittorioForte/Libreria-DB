USE tp_sistema_gpb;
GO

CREATE PROCEDURE SP_RegistrarDevolucion
    @ID_Prestamo INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        
        -- --- VALIDACIONES ---

        IF NOT EXISTS (SELECT 1 FROM Prestamos WHERE ID_Prestamo = @ID_Prestamo)
        BEGIN
            RAISERROR('Error: El ID_Prestamo id no existe.', 16, 1, @ID_Prestamo);
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM Prestamos WHERE ID_Prestamo = @ID_Prestamo AND Fecha_Entrada IS NOT NULL)
        BEGIN
            RAISERROR('Error: Este prestamo ya fue devuelto anteriormente.', 16, 1);
            RETURN;
        END

        -- --- FIN VALIDACIONES ---

        DECLARE @FechaPrevista DATE;
        SELECT @FechaPrevista = Fecha_Devolucion_Prevista 
        FROM Prestamos 
        WHERE ID_Prestamo = @ID_Prestamo;

        UPDATE Prestamos
        SET Fecha_Entrada = GETDATE()
        WHERE ID_Prestamo = @ID_Prestamo;

        PRINT 'Devolucion registrada para el prestamo ID id.';

        IF (GETDATE() > @FechaPrevista)
        BEGIN
            PRINT 'Se ha generado una sancion por devolucion tardia.';
        END

    END TRY
    BEGIN CATCH
        PRINT 'Ha ocurrido un error inesperado: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

