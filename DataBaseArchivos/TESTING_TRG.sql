
--- Pruebas de los triggers


--TRG_AumentarRestarStock
--Prueba 1: Registrar un préstamo y verificar que el stock disminuye

EXEC SP_RegistrarPrestamo
    @ID_Libro = 4,
    @ID_Estudiante = 18,
    @DiasDePrestamo = 15;
GO

SELECT ID_Libro, Titulo, Stock_Disponible
FROM Libros
GO

--Prueba 2: Registrar una devolución y verificar que el stock aumenta

EXEC SP_RegistrarDevolucion
    @ID_Prestamo = 1;
GO


SELECT ID_Libro, Titulo, Stock_Disponible
FROM Libros
GO



--TRG_SuspensionPorAtraso
-- Prueba 1: Registrar un préstamo y luego una devolución tardía para verificar que el estudiante es suspendido

EXEC SP_RegistrarPrestamo 17, 1;

UPDATE Prestamos
SET Fecha_Devolucion_Prevista = '2024-06-01'
WHERE ID_Prestamo = (SELECT MAX(ID_Prestamo) FROM Prestamos);

EXEC SP_RegistrarDevolucion
    @ID_Prestamo = 2;
GO

