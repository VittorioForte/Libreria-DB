USE tp_sistema_gpb;
GO

--Procedimientos

--Procedimiento 1 (Exec desde  aca hasta antes de la siguiente linea de guiones)
--Registrar Préstamo

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
--Ejecutar Procedimiento 1


--Procedimiento 2 (Exec desde  aca hasta antes de la siguiente linea de guiones)
--Renovar Préstamo

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

--Ejecutar Procedimiento 2


--Procedimiento 3 (Exec desde  aca hasta antes de la siguiente linea de guiones)
--Registrar Devolución


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

--Ejecutar Procedimiento 3