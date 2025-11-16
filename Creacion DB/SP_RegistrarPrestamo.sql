CREATE PROCEDURE SP_RegistrarPrestamo
    @ID_Estudiante INT,
    @ID_Libro INT,
    @DiasDePrestamo INT = 15
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY

        -- 1. Validar que el estudiante exista
        IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE ID_Estudiante = @ID_Estudiante)
        BEGIN
            RAISERROR('Error: El ID_Estudiante id no existe.', 16, 1, @ID_Estudiante);
            RETURN;
        END

        -- 2. Validar que el libro exista
        IF NOT EXISTS (SELECT 1 FROM Libros WHERE ID_Libro = @ID_Libro)
        BEGIN
            RAISERROR('Error: El ID_Libro id no existe.', 16, 1, @ID_Libro);
            RETURN;
        END

        -- 3. Validar Stock Disponible
        DECLARE @StockActual INT;
        SELECT @StockActual = Stock_Disponible FROM Libros WHERE ID_Libro = @ID_Libro;
        
        IF (@StockActual <= 0)
        BEGIN
            RAISERROR('Error: No hay stock disponible para el libro ID.', 16, 1, @ID_Libro);
            RETURN;
        END

        -- 4. Validar que el estudiante no tenga préstamos vencidos
        IF EXISTS (SELECT 1 FROM Prestamos 
            WHERE ID_Estudiante = @ID_Estudiante 
            AND Fecha_Entrada IS NULL -- Préstamo activo
            AND Fecha_Devolucion_Prevista < GETDATE()) -- Vencido
        BEGIN
            RAISERROR('Error: El estudiante tiene préstamos vencidos. No puede retirar nuevos libros.', 16, 1);
            RETURN;
        END

        -- --- FIN VALIDACIONES ---

        --- --- IF TIENE UNA SUSPENSION ACTIVA, NO DEJA HACER PRESTAMO --- ---

                IF EXISTS (
            SELECT 1
            FROM Sanciones
            WHERE ID_Prestamo IN (
                SELECT ID_Prestamo 
                FROM Prestamos 
                WHERE ID_Estudiante = @ID_Estudiante
            )
            AND Fecha_FinSuspension >= CAST(GETDATE() AS DATE)
        )
        BEGIN
            RAISERROR('Error: El estudiante está suspendido y no puede retirar libros.', 16, 1);
            RETURN;
        END

        -- 5. Si todo está OK, registrar el préstamo
        INSERT INTO Prestamos (
            ID_Libro,
            ID_Estudiante,
            Fecha_Salida,
            Fecha_Devolucion_Prevista,
            Fecha_Entrada
        )
        VALUES (
            @ID_Libro,
            @ID_Estudiante,
            GETDATE(), 
            DATEADD(day, @DiasDePrestamo, GETDATE()),
            NULL 
        );

        PRINT 'Préstamo registrado exitosamente.';
        
    END TRY
    BEGIN CATCH
        PRINT 'Ha ocurrido un error inesperado: ' + ERROR_MESSAGE();
    END CATCH
END;

GO