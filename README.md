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

### 🔎 VW_PrestamosActivos

Muestra en tiempo real todos los préstamos que siguen activos (libros que todavía no fueron devueltos).

- **Objetivo:** listar qué libros están actualmente fuera de la biblioteca y quién los tiene.
- **Tablas involucradas:** `Prestamos`, `Usuarios`, `Libros`.
- **Lógica principal:** solo muestra registros donde `Fecha_Entrada IS NULL`.
- **Campos clave:**
  - ID del libro (`ID_Libro`)
  - Título del libro
  - Nombre completo del usuario (Nombre + Apellido)
  - Fecha de salida del préstamo
  - Fecha de devolución prevista :contentReference[oaicite:0]{index=0}

### 📜 VW_HistorialUsuarios

Expone el historial completo de préstamos y devoluciones de cada usuario.

- **Objetivo:** analizar la frecuencia de uso y comportamiento de cada estudiante.
- **Tablas involucradas:** `Prestamos`, `Usuarios`, `Libros`.
- **Campos clave:**
  - `ID_Estudiante`
  - Nombre y Apellido
  - Libro prestado
  - Fecha de préstamo (`Fecha_Salida`)
  - Fecha de devolución (`Fecha_Entrada`, puede ser NULL si sigue activo) :contentReference[oaicite:1]{index=1}

### 📦 VW_InventarioDetallado

Vista de inventario enriquecida que combina información de varias tablas para mostrar el estado total de cada libro.

- **Objetivo:** tener una vista consolidada del catálogo y el uso del stock.
- **Tablas involucradas:** `Libros`, `Autores`, `Categorias`.
- **Campos clave:**
  - `ID_Libro`
  - Título
  - Autor
  - Categoría
  - `Stock_Total`
  - `Stock_Disponible`
  - `Cant_Prestada` = `Stock_Total - Stock_Disponible` (cantidad actualmente retirada) :contentReference[oaicite:2]{index=2}

### ⛔ VW_UsuariosSuspendidos

Lista a todos los usuarios que actualmente tienen una sanción vigente.

- **Objetivo:** identificar rápidamente quién no puede retirar libros y hasta cuándo.
- **Tablas involucradas:** `Usuarios`, `Prestamos`, `Sanciones`.
- **Lógica principal:**
  - Solo incluye sanciones donde la fecha actual está entre `Fecha_InicioSuspension` y `Fecha_FinSuspension`.
- **Campos clave:**
  - `ID_Estudiante`
  - Nombre y Apellido
  - Tipo de sanción
  - Fecha de inicio y fin de suspensión :contentReference[oaicite:3]{index=3}

## ⚙️ Procedimientos Almacenados

### 📌 SP_RegistrarPrestamo

Registra un nuevo préstamo de un libro a un estudiante, aplicando varias validaciones de negocio antes de permitir la operación.

**Parámetros:**

- `@ID_Estudiante INT`
- `@ID_Libro INT`
- `@DiasDePrestamo INT = 15` (por defecto, 15 días)

**Validaciones:**

1. El estudiante existe en `Usuarios`.
2. El libro existe en `Libros`.
3. El libro tiene stock disponible (`Stock_Disponible > 0`).
4. El estudiante no tiene préstamos vencidos:
   - `Fecha_Entrada IS NULL`
   - `Fecha_Devolucion_Prevista < GETDATE()`
5. El estudiante no tiene sanciones activas con suspensión vigente:
   - Sanción asociada a alguno de sus préstamos.
   - `Fecha_FinSuspension >= GETDATE()`.

**Acción principal:**

Si todo es correcto, inserta un nuevo registro en `Prestamos`:

- `Fecha_Salida = GETDATE()`
- `Fecha_Devolucion_Prevista = DATEADD(DAY, @DiasDePrestamo, GETDATE())`
- `Fecha_Entrada = NULL`

De esta forma, el alta del préstamo queda centralizada y validada en un único procedimiento. :contentReference[oaicite:4]{index=4}

### 📌 SP_RegistrarDevolucion

Registra la devolución de un libro para un préstamo específico y, si corresponde, genera una sanción por devolución tardía.

**Parámetro:**

- `@ID_Prestamo INT`

**Validaciones:**

1. El préstamo existe en `Prestamos`.
2. El préstamo todavía no tiene `Fecha_Entrada` (no fue devuelto antes).

**Acciones:**

1. Obtiene `Fecha_Devolucion_Prevista` del préstamo.
2. Actualiza `Prestamos`:
   - `Fecha_Entrada = GETDATE()`.
3. Si la devolución es **después** de la fecha prevista:
   - `GETDATE() > Fecha_Devolucion_Prevista`
   - Inserta una sanción en `Sanciones` con tipo `"Devolución Tarde"` y un monto predefinido.

Este procedimiento asegura que toda devolución quede registrada y que las devoluciones fuera de término queden reflejadas en el sistema de sanciones. :contentReference[oaicite:5]{index=5}

### 📌 SP_RenovarPrestamo

Permite extender el plazo de devolución de un préstamo activo.

**Parámetros:**

- `@ID_Prestamo INT`
- `@DiasExtra INT = 7` (por defecto, suma 7 días)

**Validaciones:**

1. El préstamo existe.
2. El préstamo **no** fue devuelto aún (`Fecha_Entrada IS NULL`).
3. El préstamo **no está vencido** (`Fecha_Devolucion_Prevista >= GETDATE()`).

**Acción principal:**

- Actualiza `Fecha_Devolucion_Prevista` usando:
  - `DATEADD(DAY, @DiasExtra, Fecha_Devolucion_Prevista)`

Esto permite renovar el préstamo sin perder el historial ni crear nuevos registros duplicados de movimientos. :contentReference[oaicite:6]{index=6}

## 🔄 Triggers

### 📉 trg_RestarStockLibros (AFTER INSERT en Prestamos)

Se ejecuta cada vez que se inserta un nuevo préstamo.

**Objetivo:** descontar automáticamente el stock disponible del libro que se está prestando.

**Lógica:**

- Tabla base: `Prestamos` (AFTER INSERT).
- Actualiza `Libros.Stock_Disponible = Stock_Disponible - 1`
  para cada `ID_Libro` presente en `inserted`.

Con esto, el inventario refleja inmediatamente la salida de ejemplares. :contentReference[oaicite:7]{index=7}

### 📈 trg_AumentarStockLibros (AFTER UPDATE en Prestamos)

Se ejecuta cuando un préstamo cambia de **activo** a **devuelto**.

**Objetivo:** sumar automáticamente al stock cuando se registra una devolución.

**Lógica:**

- Tabla base: `Prestamos` (AFTER UPDATE).
- Usa las tablas lógicas `deleted` e `inserted`.
- Solo actúa cuando:
  - Antes: `d.Fecha_Entrada IS NULL`
  - Después: `i.Fecha_Entrada IS NOT NULL`
- En ese caso incrementa `Libros.Stock_Disponible = Stock_Disponible + 1`
  para el libro afectado.

De esta forma, el stock se mantiene sincronizado sin operaciones manuales. :contentReference[oaicite:8]{index=8}

### ⏱️ trg_SuspensionPorAtraso (AFTER UPDATE en Prestamos)

Aplica automáticamente una **suspensión de 15 días** a los usuarios que devuelven un libro fuera de término.

**Requisitos previos:**

- La tabla `Sanciones` incluye las columnas:
  - `Fecha_InicioSuspension`
  - `Fecha_FinSuspension`

**Lógica del trigger:**

- Tabla base: `Prestamos` (AFTER UPDATE).
- Condición:
  - Antes: `d.Fecha_Entrada IS NULL`
  - Después: `i.Fecha_Entrada IS NOT NULL`
  - Y además: `i.Fecha_Entrada > i.Fecha_Devolucion_Prevista`
- Acción:
  - Inserta un registro en `Sanciones` con:
    - `Tipo = 'Atraso en la devolución'`
    - `Fecha_Sancion = i.Fecha_Entrada`
    - `Fecha_InicioSuspension = i.Fecha_Entrada`
    - `Fecha_FinSuspension = DATEADD(DAY, 15, i.Fecha_Entrada)`

Durante ese período, el estudiante quedará bloqueado por el procedimiento `SP_RegistrarPrestamo` cuando intente realizar nuevos préstamos. :contentReference[oaicite:9]{index=9}


### 📋 trg_AuditoriaLibros (AFTER UPDATE en Libros)

Registra automáticamente los cambios realizados sobre los libros, manteniendo un historial de auditoría.

**Tabla de auditoría:**

`AuditoriaLibros` con los campos:

- `ID_Auditoria` (IDENTITY)
- `ID_Libro`
- `Titulo_Anterior`
- `Titulo_Nuevo`
- `StockAnterior`
- `StockNuevo`
- `FechaCambio` (por defecto `GETDATE()`)

**Lógica del trigger:**

- Tabla base: `Libros` (AFTER UPDATE).
- Usa `deleted` (valores anteriores) e `inserted` (valores nuevos).
- Inserta en `AuditoriaLibros` un registro por cada libro modificado, guardando los valores previos y nuevos de:
  - Título
  - Stock disponible

Esto permite auditar cambios críticos en el catálogo de la biblioteca. :contentReference[oaicite:10]{index=10}

## 🧮 Lógica de Negocio

Automatización de stock: Cada préstamo o devolución actualiza el inventario sin intervención manual.

Integridad referencial: Todas las operaciones se validan con claves foráneas y restricciones CHECK.

Historial persistente: Ningún préstamo se elimina, garantizando trazabilidad total.
