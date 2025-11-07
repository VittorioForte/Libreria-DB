use tp_sistema_gpb;
GO

CREATE VIEW VW_HistorialUsuarios AS
SELECT
    u.ID_Estudiante,
    u.NOMBRE,
    u.APELLIDO,
    l.TITULO AS Libro,
    p.Fecha_Salida AS FechaPrestamo,
    p.Fecha_Entrada AS FechaDevolucion
FROM PRESTAMOS p
JOIN USUARIOS u ON p.ID_Estudiante = u.ID_Estudiante
JOIN LIBROS l ON p.ID_LIBRO = l.ID_LIBRO;
GO