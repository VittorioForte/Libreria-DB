use tp_sistema_gpb;
GO

CREATE VIEW VW_PrestamosActivos AS
SELECT
    p.ID_LIBRO,
    l.TITULO AS TituloLibro,
    u.NOMBRE + ' ' + u.APELLIDO AS Usuario,
    p.Fecha_Salida AS FechaSalida,
    p.Fecha_Devolucion_Prevista AS FechaPrevista 
FROM Prestamos p
JOIN Usuarios u ON p.ID_Estudiante = u.ID_Estudiante
JOIN Libros l ON p.ID_LIBRO = l.ID_LIBRO
WHERE p.Fecha_Entrada IS NULL;