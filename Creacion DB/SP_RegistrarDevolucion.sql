USE tp_sistema_gpb;
GO

CREATE PROCEDURE SP_RegistrarDevolucion
    @ID_Prestamo INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        
        -- --- VALIDACIONES ---

        -- 1. Validar que el préstamo exista
        IF NOT EXISTS (SELECT 1 FROM Prestamos WHERE ID_Prestamo = @ID_Prestamo)
        BEGIN
            RAISERROR('Error: El ID_Prestamo %d no existe.', 16, 1, @ID_Prestamo);
            RETURN;
        END

        -- 2. Validar que el préstamo NO haya sido devuelto ya
        IF EXISTS (SELECT 1 FROM Prestamos WHERE ID_Prestamo = @ID_Prestamo AND Fecha_Entrada IS NOT NULL)
        BEGIN
            RAISERROR('Error: Este préstamo ya fue devuelto anteriormente.', 16, 1);
            RETURN;
        END

        -- --- FIN VALIDACIONES ---

        -- Obtenemos la fecha en que DEBÍA ser devuelto
        DECLARE @FechaPrevista DATE;
        SELECT @FechaPrevista = Fecha_Devolucion_Prevista 
        FROM Prestamos 
        WHERE ID_Prestamo = @ID_Prestamo;

        -- 3. Actualizar el préstamo marcándolo como devuelto hoy
        UPDATE Prestamos
        SET Fecha_Entrada = GETDATE()
        WHERE ID_Prestamo = @ID_Prestamo;

        PRINT 'Devolución registrada para el préstamo ID %d.';

        -- 4. Lógica de Sanción: ¿Lo devolvió tarde?
        IF (GETDATE() > @FechaPrevista)
        BEGIN
            -- El préstamo está vencido. Insertamos una sanción.
            -- (El monto es un ejemplo, puedes ajustarlo)
            INSERT INTO Sanciones (ID_Prestamo, Tipo, Monto)
            VALUES (@ID_Prestamo, 'Devolución Tarde', 250.50);
            
            PRINT 'Se ha generado una sanción por devolución tardía.';
        END

    END TRY
    BEGIN CATCH
        PRINT 'Ha ocurrido un error inesperado: ' + ERROR_MESSAGE();
    END CATCH
END;
GO