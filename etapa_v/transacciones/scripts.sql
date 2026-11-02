sql
-- ============================================================
-- PROYECTO: SUEÑO CONTIGO
-- ETAPA V: TRANSACCIONES
-- RESPONSABLE: SOL VALENTINA MORILLA
-- BASE DE DATOS: SuenoContigo_BDL
-- ============================================================

USE SuenoContigo_BDL;
GO

-- ============================================================
-- 1. VERIFICAR LA BASE DE DATOS ACTUAL
-- ============================================================

SELECT DB_NAME() AS BaseDeDatosActual;
GO

-- ============================================================
-- 2. VERIFICAR SI LOS IDENTIFICADORES SON IDENTITY
-- ============================================================

SELECT
    TABLE_NAME AS Tabla,
    COLUMN_NAME AS Columna,
    COLUMNPROPERTY(
        OBJECT_ID(TABLE_SCHEMA + '.' + TABLE_NAME),
        COLUMN_NAME,
        'IsIdentity'
    ) AS EsIdentity
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('VENTA', 'DETALLE_VENTA', 'PRODUCTO')
  AND COLUMN_NAME IN ('id_venta', 'id_producto')
ORDER BY TABLE_NAME, COLUMN_NAME;
GO

-- ============================================================
-- 3. CONSULTAR CLIENTES DISPONIBLES
-- ============================================================

SELECT TOP 5 *
FROM CLIENTE;
GO

-- ============================================================
-- 4. CONSULTAR MÉTODOS DE PAGO DISPONIBLES
-- ============================================================

SELECT TOP 5 *
FROM METODO_PAGO;
GO

-- ============================================================
-- 5. CONSULTAR PRODUCTOS Y STOCK ACTUAL
-- ============================================================

SELECT
    id_producto,
    nombre,
    precio_vigente,
    stock
FROM PRODUCTO
ORDER BY id_producto;
GO

-- ============================================================
-- 6. VERIFICAR LA CANTIDAD DE REGISTROS DE CADA TABLA
-- ============================================================

SELECT 'CLIENTE' AS Tabla, COUNT(*) AS Cantidad
FROM CLIENTE

UNION ALL

SELECT 'METODO_PAGO', COUNT(*)
FROM METODO_PAGO

UNION ALL

SELECT 'CATEGORIA', COUNT(*)
FROM CATEGORIA

UNION ALL

SELECT 'PRODUCTO', COUNT(*)
FROM PRODUCTO

UNION ALL

SELECT 'VENTA', COUNT(*)
FROM VENTA

UNION ALL

SELECT 'DETALLE_VENTA', COUNT(*)
FROM DETALLE_VENTA;
GO

-- ============================================================
-- 7. CONSULTAR LAS VENTAS REGISTRADAS
-- ============================================================

SELECT
    V.id_venta,
    V.fecha,
    V.estado,
    V.id_cliente,
    V.id_metodo_pago
FROM VENTA AS V
ORDER BY V.id_venta;
GO

-- ============================================================
-- 8. CONSULTAR LOS DETALLES DE LAS VENTAS
-- ============================================================

SELECT
    DV.id_venta,
    DV.id_producto,
    P.nombre AS Producto,
    DV.cantidad,
    DV.precio_unitario_historico,
    DV.cantidad * DV.precio_unitario_historico AS Subtotal
FROM DETALLE_VENTA AS DV
INNER JOIN PRODUCTO AS P
    ON DV.id_producto = P.id_producto
ORDER BY DV.id_venta, DV.id_producto;
GO

-- ============================================================
-- 9. PRUEBA EXITOSA: REGISTRAR UNA VENTA
--
-- Esta transacción registra la venta, su detalle y descuenta
-- el stock. Se confirma solamente si todas las operaciones
-- se realizan correctamente.
--
-- Se deja comentada para evitar ejecuciones accidentales.
-- ============================================================

/*

DECLARE @id_cliente INT = 1;
DECLARE @id_metodo_pago INT = 1;
DECLARE @id_producto INT = 1;
DECLARE @cantidad INT = 2;

DECLARE @id_venta INT;
DECLARE @precio DECIMAL(10,2);
DECLARE @stock_actual INT;

BEGIN TRY

    BEGIN TRANSACTION;

    -- 1. Obtener precio y stock del producto.
 

    SELECT
        @precio = precio_vigente,
        @stock_actual = stock
    FROM PRODUCTO WITH (UPDLOCK, HOLDLOCK)
    WHERE id_producto = @id_producto;

    -- 2. Validar que el producto exista.

    IF @precio IS NULL
        THROW 50001, 'El producto no existe.', 1;

    -- 3. Validar que la cantidad sea mayor que cero.

    IF @cantidad <= 0
        THROW 50003, 'La cantidad debe ser mayor que cero.', 1;

    -- 4. Registrar la cabecera de la venta.

    INSERT INTO VENTA (
        estado,
        id_cliente,
        id_metodo_pago
    )
    VALUES (
        'Abonado',
        @id_cliente,
        @id_metodo_pago
    );

    SET @id_venta = SCOPE_IDENTITY();

    -- 5. Registrar el detalle con el precio histórico.

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

    -- 6. Verificar que haya stock suficiente.

    IF @stock_actual < @cantidad
        THROW 50002, 'Stock insuficiente. La venta fue cancelada.', 1;

    -- 7. Descontar las unidades del stock.

    UPDATE PRODUCTO
    SET stock = stock - @cantidad
    WHERE id_producto = @id_producto
      AND stock >= @cantidad;

    IF @@ROWCOUNT = 0
        THROW 50004, 'No se pudo actualizar el stock.', 1;

    -- 8. Confirmar todas las operaciones.

    COMMIT TRANSACTION;

    PRINT 'Venta registrada correctamente.';
    PRINT 'ID de la venta: ' + CAST(@id_venta AS VARCHAR(20));
    PRINT 'Stock actualizado correctamente.';

END TRY

BEGIN CATCH

    -- Si ocurre un error, deshacer todas las operaciones.

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'Error: la transacción fue cancelada.';
    PRINT ERROR_MESSAGE();

END CATCH;

*/

GO

-- ============================================================
-- 10. PRUEBA DE ERROR: ROLLBACK POR STOCK INSUFICIENTE
--
-- Se intenta vender una cantidad superior al stock disponible.
-- La venta y su detalle se insertan dentro de la transacción,
-- pero deben revertirse si no hay unidades suficientes.
--
-- Se deja comentada para ejecutarla solamente al realizar
-- la prueba de rollback.
-- ============================================================

/*

DECLARE @id_cliente INT = 1;
DECLARE @id_metodo_pago INT = 1;
DECLARE @id_producto INT = 1;
DECLARE @cantidad INT = 100;

DECLARE @id_venta INT;
DECLARE @precio DECIMAL(10,2);
DECLARE @stock_actual INT;

BEGIN TRY

    BEGIN TRANSACTION;

    -- 1. Obtener precio y stock del producto.

    SELECT
        @precio = precio_vigente,
        @stock_actual = stock
    FROM PRODUCTO WITH (UPDLOCK, HOLDLOCK)
    WHERE id_producto = @id_producto;

    -- 2. Validar que el producto exista.

    IF @precio IS NULL
        THROW 50001, 'El producto no existe.', 1;

    -- 3. Validar que la cantidad sea mayor que cero.

    IF @cantidad <= 0
        THROW 50003, 'La cantidad debe ser mayor que cero.', 1;

    -- 4. Intentar registrar la cabecera de la venta.

    INSERT INTO VENTA (
        estado,
        id_cliente,
        id_metodo_pago
    )
    VALUES (
        'Abonado',
        @id_cliente,
        @id_metodo_pago
    );

    SET @id_venta = SCOPE_IDENTITY();

    -- 5. Intentar registrar el detalle.

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

    -- 6. Comprobar si existe stock suficiente.

    IF @stock_actual < @cantidad
        THROW 50002, 'Stock insuficiente. La venta fue cancelada.', 1;

    -- 7. Descontar el stock si hay unidades suficientes.

    UPDATE PRODUCTO
    SET stock = stock - @cantidad
    WHERE id_producto = @id_producto
      AND stock >= @cantidad;

    IF @@ROWCOUNT = 0
        THROW 50004, 'No se pudo actualizar el stock.', 1;

    -- 8. Confirmar la operación si todo fue correcto.

    COMMIT TRANSACTION;

    PRINT 'Venta registrada correctamente.';

END TRY

BEGIN CATCH

    -- Revertir la cabecera, el detalle y cualquier modificación.

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'Error esperado: la transacción fue cancelada.';
    PRINT ERROR_MESSAGE();

END CATCH;

*/

GO

-- ============================================================
-- 11. VERIFICACIÓN FINAL
--
-- Estas consultas permiten revisar las ventas, sus detalles
-- y el stock después de ejecutar alguna de las pruebas.
-- ============================================================

SELECT
    id_venta,
    fecha,
    estado,
    id_cliente,
    id_metodo_pago
FROM VENTA
ORDER BY id_venta;
GO

SELECT
    id_venta,
    id_producto,
    cantidad,
    precio_unitario_historico
FROM DETALLE_VENTA
ORDER BY id_venta, id_producto;
GO

SELECT
    id_producto,
    nombre,
    stock
FROM PRODUCTO
ORDER BY id_producto;
GO
