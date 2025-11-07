use tp_sistema_gpb;
GO

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