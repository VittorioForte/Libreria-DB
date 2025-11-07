-- AUTORES
INSERT INTO Autores (Nombre_Autor) VALUES
('J.K. Rowling'), ('George Orwell'), ('Gabriel Garcia Marquez'), ('Isaac Asimov'), ('Agatha Christie'),
('Stephen King'), ('Leo Tolstoy'), ('F. Scott Fitzgerald'), ('Ernest Hemingway'), ('Jane Austen'),
('Julio Verne'), ('H. P. Lovecraft'), ('J. R. R. Tolkien'), ('Arthur Conan Doyle'), ('Miguel de Cervantes'),
('Paulo Coelho'), ('Dan Brown'), ('Mark Twain'), ('Edgar Allan Poe'), ('Haruki Murakami');

-- CATEGORIAS
INSERT INTO Categorias (Nombre_Categoria) VALUES
('Ficcion'), ('Ciencia Ficcion'), ('Historia'), ('Misterio'), ('Terror'),
('Romance'), ('Clasicos'), ('Biografia'), ('Autoayuda'), ('Aventura');

-- LIBROS
INSERT INTO Libros (Titulo, ISBN, ID_Autor, ID_Categoria, Stock_Total, Stock_Disponible) VALUES
('Harry Potter y la Piedra Filosofal','9780747532699',1,1,15,15),
('1984','9780451524935',2,2,10,10),
('Cien Años de Soledad','9780307474728',3,1,8,8),
('Fundacion','9780553293357',4,2,12,12),
('Asesinato en el Orient Express','9780062073501',5,4,5,5),
('El Resplandor','9780307743657',6,5,7,7),
('Guerra y Paz','9781853260629',7,7,6,6),
('El Gran Gatsby','9780743273565',8,7,10,10),
('Por quien doblan las campanas','9780684803356',9,7,5,5),
('Orgullo y Prejuicio','9780141439518',10,6,9,9),
('Veinte mil leguas de viaje submarino','9780140623840',11,2,10,10),
('El llamado de Cthulhu','9780553213690',12,5,6,6),
('El Señor de los Anillos','9780544003415',13,1,12,12),
('Sherlock Holmes: Estudio en escarlata','9780451526342',14,4,9,9),
('Don Quijote de la Mancha','9788491050293',15,7,8,8),
('El Alquimista','9780061122414',16,9,10,10),
('El Codigo Da Vinci','9780307474278',17,4,11,11),
('Las Aventuras de Tom Sawyer','9780143039563',18,10,7,7),
('El Cuervo','9780142437277',19,5,5,5),
('Tokio Blues','9788490627540',20,6,6,6);

-- USUARIOS
INSERT INTO Usuarios (Nombre, Apellido, DNI_Legajo, Email) VALUES
('Franco','Casamento','12345678','franco@example.com'),
('Maria','Gonzalez','87654321','maria@example.com'),
('Juan','Perez','11223344','juan@example.com'),
('Lucia','Martinez','99887766','lucia@example.com'),
('Pedro','Rodriguez','44556677','pedro@example.com'),
('Ana','Lopez','33445566','ana@example.com'),
('Sofia','Gomez','55667788','sofia@example.com'),
('Martin','Fernandez','66778899','martin@example.com'),
('Laura','Diaz','22334455','laura@example.com'),
('Diego','Torres','77889900','diego@example.com'),
('Camila','Romero','22331122','camila@example.com'),
('Valentina','Ruiz','33442211','valentina@example.com'),
('Matias','Ramos','44332211','matias@example.com'),
('Lautaro','Benitez','55443322','lautaro@example.com'),
('Micaela','Herrera','66554433','mica@example.com'),
('Ezequiel','Morales','77665544','eze@example.com'),
('Brenda','Arias','88776655','brenda@example.com'),
('Nicolas','Acosta','99887711','nico@example.com'),
('Florencia','Vega','11229933','flor@example.com'),
('Tomas','Navarro','22330044','tomi@example.com');

-- PRESTAMOS
INSERT INTO Prestamos (ID_Libro, ID_Estudiante, Fecha_Devolucion_Prevista, Fecha_Salida) VALUES
(1,1,'2025-11-10','2025-10-27'), (2,2,'2025-11-12','2025-10-26'), (3,3,'2025-11-15','2025-10-25'),
(4,4,'2025-11-18','2025-10-24'), (5,5,'2025-11-20','2025-10-23'), (6,6,'2025-11-22','2025-10-22'),
(7,7,'2025-11-25','2025-10-21'), (8,8,'2025-11-28','2025-10-20'), (9,9,'2025-12-01','2025-10-19'),
(10,10,'2025-12-03','2025-10-18'), (11,11,'2025-12-05','2025-10-17'), (12,12,'2025-12-08','2025-10-16'),
(13,13,'2025-12-10','2025-10-15'), (14,14,'2025-12-13','2025-10-14'), (15,15,'2025-12-16','2025-10-13'),
(16,16,'2025-12-18','2025-10-12'), (17,17,'2025-12-20','2025-10-11'), (18,18,'2025-12-23','2025-10-10'),
(19,19,'2025-12-25','2025-10-09'), (20,20,'2025-12-28','2025-10-08');

-- SANCIONES
INSERT INTO Sanciones (ID_Prestamo, Tipo, Monto) VALUES
(1,'Retraso',5000.00),(2,'Dato',12000.00),(3,'Retraso',3000.00),(4,'Perdida',25000.00),(5,'Retraso',2500.00),
(6,'Dato',7500.00),(7,'Retraso',4000.00),(8,'Dato',9500.00),(9,'Perdida',22000.00),(10,'Retraso',3500.00),
(11,'Retraso',4500.00),(12,'Dato',10000.00),(13,'Retraso',3200.00),(14,'Perdida',27000.00),(15,'Retraso',6000.00),
(16,'Dato',8500.00),(17,'Retraso',2800.00),(18,'Perdida',30000.00),(19,'Dato',9000.00),(20,'Retraso',5000.00);


