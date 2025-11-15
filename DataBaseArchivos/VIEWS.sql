USE tp_sistema_gpb;
GO

-- Views


-- View 1 (Ejecutar desde aca hasta sigiente linea de guiones)
-- Historial de usuarios

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

-- Fin View 1
----------------------------------------------------------------------------

-- View 2 (Ejecutar desde aca hasta sigiente linea de guiones)
-- Inventario detallado de libros


CREATE VIEW VW_InventarioDetallado AS
SELECT
    l.ID_Libro,
    l.Titulo,
    a.Nombre_Autor AS Autor,
    c.Nombre_Categoria AS Categoria,
    l.Stock_Total,
    l.Stock_Disponible,
    (l.Stock_Total - l.Stock_Disponible) AS Cant_Prestada
FROM Libros AS L
JOIN Autores AS A ON l.ID_Autor = a.ID_Autor
JOIN Categorias AS C ON l.ID_Categoria = c.ID_Categoria;
GO

-- Fin View 2
----------------------------------------------------------------------------



-- View 3 (Ejecutar desde aca hasta sigiente linea de guiones)
-- Prestamos activos por usuario


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
GO


-- Fin View 3
----------------------------------------------------------------------------


-- View 4 (Ejecutar desde aca hasta sigiente linea de guiones)
-- Usuarios suspendidos

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
GO
-- Fin View 4
----------------------------------------------------------------------------