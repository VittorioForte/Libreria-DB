USE tp_sistema_gpb;
GO

CREATE VIEW VW_UsuariosSuspendidos AS
SELECT 
    u.ID_Estudiante,
    u.Nombre,
    u.Apellido,
    s.Tipo,
    s.Fecha_InicioSuspension,
    s.Fecha_FinSuspension
FROM Usuarios u
JOIN Prestamos p ON u.ID_Estudiante = p.ID_Estudiante
JOIN Sanciones s ON p.ID_Prestamo = s.ID_Prestamo
WHERE 
    s.Fecha_InicioSuspension <= GETDATE()
    AND s.Fecha_FinSuspension >= GETDATE();
GO
