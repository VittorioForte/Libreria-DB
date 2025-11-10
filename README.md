# 📚 Sistema de Gestión de Préstamos Bibliográficos (SGPB)

Este proyecto consiste en el desarrollo de una Base de Datos para la gestión integral de una biblioteca, enfocada en el registro y control de préstamos, devoluciones y stock de libros en tiempo real.

https://docs.google.com/document/d/1gtdBc5Y-jxiPNj3X1sFqBVx_roGeIykbJkQrvBdESZ0/edit?usp=sharing

 ## 🧠 Contexto Académico

Este sistema fue desarrollado en el marco de la materia Base de Datos II (Año 2025) perteneciente a la Tecnicatura Universitaria en Programación – UTN FRGP.

## 👥 Integrantes del equipo

Forte, Vittorio – 31975

Casamento, Franco – 25444

Díaz, Joaquín – 29746

## 🧩 Descripción del Sistema

El SGPB (Sistema de Gestión de Préstamos Bibliográficos) permite administrar de manera eficiente el inventario, los préstamos y devoluciones de libros, así como la gestión de los usuarios registrados (estudiantes).

El sistema se basa en una base de datos relacional simplificada, donde la información descriptiva de cada libro (autor y editorial) se encuentra desnormalizada e integrada directamente en la tabla de LIBROS, priorizando la trazabilidad de movimientos y el control transaccional.

## ⚙️ Funcionalidades principales

Gestión de Usuarios:
Registro y administración de usuarios, incluyendo su historial de préstamos y devoluciones.

Administración de Inventario (Stock Responsivo):
Control en tiempo real del stock disponible. Los valores se actualizan automáticamente mediante Triggers cada vez que se realiza un préstamo o devolución.

Control de Préstamos y Devoluciones:
Los administradores pueden registrar las salidas y entradas de libros, vinculando cada operación con el usuario y las fechas correspondientes.
Esta acción se realiza a través de un Procedimiento Almacenado que automatiza las validaciones.

Registro Histórico y Reportes:
El sistema conserva un historial completo de movimientos, permitiendo generar reportes y consultas personalizadas mediante Vistas y Procedimientos Almacenados.

## 🗃️ Entidades principales del sistema

USUARIOS → (ID, Nombre, Apellido, DNI/Legajo, Email, FechaRegistro)

LIBROS → (ID, Título, Autor, Categoría, ISBN, StockTotal, StockDisponible)

PRÉSTAMOS → (IDLibro, IDEstudiante, FechaSalida, FechaDevoluciónPrevista, FechaEntrada)

## ⚙️ Componentes Técnicos

## 👁️‍🗨️ Vistas

(Espacio para detallar las vistas creadas)

## ⚙️ Procedimientos Almacenados

(Espacio para detallar los procedimientos almacenados)

## 🔄 Triggers

(Espacio para detallar los triggers implementados)

## 🧮 Lógica de Negocio

Automatización de stock: Cada préstamo o devolución actualiza el inventario sin intervención manual.

Integridad referencial: Todas las operaciones se validan con claves foráneas y restricciones CHECK.

Historial persistente: Ningún préstamo se elimina, garantizando trazabilidad total.
