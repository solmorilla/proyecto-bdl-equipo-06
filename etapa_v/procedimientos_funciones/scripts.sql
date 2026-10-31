-- Procedimientos y Funciones Almacenadas

-- 1. FUNCIÓN ALMACENADA: Calcular Descuento por Fidelidad
-- Calcula un % de descuento si el cliente compró mucho históricamente.
GO
CREATE FUNCTION dbo.fn_CalcularDescuentoCliente(@id_cliente INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @TotalAcumulado DECIMAL(12,2);
    DECLARE @Descuento DECIMAL(5,2);

    -- sumamos todo lo que gastó el cliente en su historia
    SELECT @TotalAcumulado = ISNULL(SUM(dv.cantidad * dv.precio_unitario_historico), 0)
    FROM VENTA v
    INNER JOIN DETALLE_VENTA dv ON v.id_venta = dv.id_venta
    WHERE v.id_cliente = @id_cliente;

    -- lógica de negocio 
    IF @TotalAcumulado > 500000 
        SET @Descuento = 0.10; -- descuento del 10%
    ELSE IF @TotalAcumulado > 200000 
        SET @Descuento = 0.05; -- descuento del 5%
    ELSE 
        SET @Descuento = 0.00; -- sin descuento

    RETURN @Descuento;
END;
GO


-- 2. PROCEDIMIENTO ALMACENADO: Registrar Venta Completa
-- Centraliza los INSERTS y el UPDATE de stock en un solo paso.
GO
CREATE PROCEDURE dbo.sp_RegistrarVentaCompleta
    @p_id_cliente INT,
    @p_id_metodo_pago INT,
    @p_id_producto INT,
    @p_cantidad INT
AS
BEGIN
    DECLARE @v_id_venta INT;
    DECLARE @v_precio_vigente DECIMAL(12,2);

    -- obtenemos el precio actual del producto para congelarlo en el detalle
    SELECT @v_precio_vigente = precio_vigente 
    FROM PRODUCTO 
    WHERE id_producto = @p_id_producto;

    -- insertamos la cabecera de la factura
    INSERT INTO VENTA (fecha, estado, id_cliente, id_metodo_pago)
    VALUES (SYSDATETIME(), 'Pendiente', @p_id_cliente, @p_id_metodo_pago);

    -- capturamos el ID de la venta que se acaba de generar
    SET @v_id_venta = SCOPE_IDENTITY();

    -- insertamos el renglón del detalle usando el precio congelado
    INSERT INTO DETALLE_VENTA (id_venta, id_producto, cantidad, precio_unitario_historico)
    VALUES (@v_id_venta, @p_id_producto, @p_cantidad, @v_precio_vigente);

    -- descontamos el stock
    UPDATE PRODUCTO
    SET stock = stock - @p_cantidad
    WHERE id_producto = @p_id_producto;

    PRINT 'Venta registrada con éxito. Stock actualizado.';
END;
GO


-- 3. BLOQUE DE PRUEBAS (Ejecución)

-- probamos la Función de Descuento
SELECT 
    c.nombre, 
    c.apellido, 
    ISNULL(SUM(dv.cantidad * dv.precio_unitario_historico), 0) AS Total_Gastado,
    dbo.fn_CalcularDescuentoCliente(c.id_cliente) AS Porcentaje_Descuento
FROM CLIENTE c
LEFT JOIN VENTA v ON c.id_cliente = v.id_cliente
LEFT JOIN DETALLE_VENTA dv ON v.id_venta = dv.id_venta
GROUP BY c.id_cliente, c.nombre, c.apellido;

-- probamos el Procedimiento (cliente 2: Martín Pérez compra 12 unidades de conjunto satén usando efectivo)
EXEC dbo.sp_RegistrarVentaCompleta 
    @p_id_cliente = 2, 
    @p_id_metodo_pago = 1, 
    @p_id_producto = 2, 
    @p_cantidad = 12;
-- cliente 3: Lucia Fernandez compra 10 unidades del producto 3 usando efectivo
EXEC dbo.sp_RegistrarVentaCompleta 
    @p_id_cliente = 3, 
    @p_id_metodo_pago = 1, 
    @p_id_producto = 3, 
    @p_cantidad = 10;