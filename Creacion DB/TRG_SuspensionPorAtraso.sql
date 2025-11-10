USE tp_sistema_gpb;
GO

--Se agrega las columnas para las fechas de inicio y fin de suspensión en la tabla Sanciones

ALTER TABLE Sanciones
ADD 
    Fecha_InicioSuspension DATE NULL,
    Fecha_FinSuspension DATE NULL;
GO

--Se crea el trigger para actualizar las fechas de suspensión al insertar una sanción de tipo "Suspensión por Atraso"
-- La fecha de inicio será la fecha de sanción y la fecha de fin será 15 días después.

CREATE TRIGGER trg_SuspensionPorAtraso
ON Sanciones
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE s
    SET
        s.Fecha_InicioSuspension = i.Fecha_Sancion,
        s.Fecha_FinSuspension = DATEADD(DAY, 15, i.Fecha_Sancion)
    FROM Sanciones s
    INNER JOIN inserted i ON s.ID_Sancion = i.ID_Sancion
    INNER JOIN Prestamos p ON p.ID_Prestamo = i.ID_Prestamo
    WHERE i.Tipo = 'Suspensión por Atraso';

END;
GO
