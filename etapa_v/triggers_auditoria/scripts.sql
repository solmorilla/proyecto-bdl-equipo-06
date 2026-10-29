
USE SuenoContigo_BDL;
GO

-- ============================================
-- ETAPA V: TRIGGERS DE AUDITORIA
-- Sistema de ventas de lenceria
-- ============================================

-- 1. CREACION DE LA TABLA DE AUDITORIA

IF OBJECT_ID('dbo.auditoria_producto', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.auditoria_producto (
        id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
        fecha_hora DATETIME2 NOT NULL
            DEFAULT SYSDATETIME(),
        usuario_responsable SYSNAME NOT NULL,
        id_producto INT NOT NULL,
        nombre_producto VARCHAR(100) NOT NULL,
        precio_anterior DECIMAL(10,2) NOT NULL,
        precio_nuevo DECIMAL(10,2) NOT NULL
    );
END;
GO

-- ============================================
-- 2. CREACION DEL TRIGGER DE AUDITORIA
-- ============================================

CREATE OR ALTER TRIGGER dbo.tr_auditoria_precio_producto
ON dbo.PRODUCTO
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Registrar solamente cambios reales de precio.
    INSERT INTO dbo.auditoria_producto (
        fecha_hora,
        usuario_responsable,
        id_producto,
        nombre_producto,
        precio_anterior,
        precio_nuevo
    )
    SELECT
        SYSDATETIME(),
        ORIGINAL_LOGIN(),
        i.id_producto,
        i.nombre,
        d.precio_vigente,
        i.precio_vigente
    FROM inserted AS i
    INNER JOIN deleted AS d
        ON i.id_producto = d.id_producto
    WHERE i.precio_vigente <> d.precio_vigente;
END;
GO

-- ============================================
-- 3. VERIFICACION DE LOS PRODUCTOS
-- ============================================

SELECT
    id_producto,
    nombre,
    talle,
    precio_vigente,
    stock
FROM dbo.PRODUCTO
ORDER BY id_producto;
GO

-- ============================================
-- 4. VERIFICACION DEL TRIGGER
-- ============================================

SELECT
    name AS nombre_trigger,
    is_disabled AS deshabilitado
FROM sys.triggers
WHERE name = 'tr_auditoria_precio_producto';
GO

-- ============================================
-- 5. CONSULTA DE LOS REGISTROS DE AUDITORIA
-- ============================================

SELECT
    id_auditoria,
    fecha_hora,
    usuario_responsable,
    id_producto,
    nombre_producto,
    precio_anterior,
    precio_nuevo
FROM dbo.auditoria_producto
ORDER BY id_auditoria DESC;
GO

-- ============================================
-- 6. PRUEBA MANUAL DEL TRIGGER
-- Ejecutar por separado cuando se quiera probar.
-- No ejecutar automaticamente al crear el trigger.
-- ============================================

-- Ejemplo para el producto de prueba:
--
-- UPDATE dbo.PRODUCTO
-- SET precio_vigente = 5700.00
-- WHERE id_producto = 1
--   AND precio_vigente = 5600.00;
-- GO
--
-- SELECT *
-- FROM dbo.auditoria_producto
-- WHERE id_producto = 1
-- ORDER BY id_auditoria DESC;
-- GO
