-- ETAPA V - TRANSACCIONES
-- Proyecto: Sueño Contigo
-- Integrantes: Sol y Lucas

-- 1. Verificar si id_venta es IDENTITY
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    COLUMNPROPERTY(
        OBJECT_ID(TABLE_SCHEMA + '.' + TABLE_NAME),
        COLUMN_NAME,
        'IsIdentity'
    ) AS EsIdentity
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('VENTA', 'DETALLE_VENTA', 'PRODUCTO')
  AND COLUMN_NAME IN ('id_venta', 'id_producto');

-- 2. Consultar clientes disponibles
SELECT TOP 5 *
FROM CLIENTE;

-- 3. Consultar métodos de pago disponibles
SELECT TOP 5 *
FROM METODO_PAGO;

-- 4. Consultar productos y stock actual
SELECT
    id_producto,
    nombre,
    precio_vigente,
    stock
FROM PRODUCTO;

-- 5. Verificar cantidad de registros disponibles

SELECT 'CLIENTE' AS Tabla, COUNT(*) AS Cantidad
FROM CLIENTE

UNION ALL

SELECT 'METODO_PAGO', COUNT(*)
FROM METODO_PAGO

UNION ALL

SELECT 'PRODUCTO', COUNT(*)
FROM PRODUCTO

UNION ALL

SELECT 'VENTA', COUNT(*)
FROM VENTA

UNION ALL

SELECT 'DETALLE_VENTA', COUNT(*)
FROM DETALLE_VENTA;


-- =====================================================
-- ETAPA V: TRANSACCION PARA REGISTRAR UNA VENTA
-- =====================================================

USE SuenoContigo_BDL;
GO

DECLARE @id_cliente INT = 1;
DECLARE @id_metodo_pago INT = 1;
DECLARE @id_producto INT = 1;
DECLARE @cantidad INT = 2;

DECLARE @id_venta INT;
DECLARE @precio DECIMAL(10,2);

BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. Obtener el precio actual del producto
    SELECT @precio = precio_vigente
    FROM PRODUCTO
    WHERE id_producto = @id_producto;

    IF @precio IS NULL
        THROW 50001, 'El producto no existe.', 1;

    -- 2. Registrar la cabecera de la venta
    INSERT INTO VENTA (estado, id_cliente, id_metodo_pago)
    VALUES ('Abonado', @id_cliente, @id_metodo_pago);

    SET @id_venta = SCOPE_IDENTITY();

    -- 3. Registrar el detalle con el precio historico
    INSERT INTO DETALLE_VENTA (
        id_venta,
        id_producto,
        cantidad,
        precio_unitario_historico
    )
    VALUES (
        @id_venta,
        @id_producto,
        @cantidad,
        @precio
    );

    -- 4. Descontar el stock solo si alcanza
    UPDATE PRODUCTO
    SET stock = stock - @cantidad
    WHERE id_producto = @id_producto
      AND stock >= @cantidad;

    IF @@ROWCOUNT = 0
        THROW 50002, 'Stock insuficiente o producto inexistente.', 1;

    -- 5. Confirmar todas las operaciones
    COMMIT TRANSACTION;

    PRINT 'Venta registrada correctamente.';
    PRINT 'ID de la venta:';
    PRINT @id_venta;

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'Error: la transaccion fue cancelada.';
    PRINT ERROR_MESSAGE();

END CATCH;
GO
