-- -------------------------------------------------------------------------
-- CASO DE USO 1
-- Factura/Comprobante: Consulta que consolide el encabezado y detalle de 
-- una venta, calculando sub-totales por renglón y el total acumulado.
-- -------------------------------------------------------------------------

SELECT 
    v.id_venta AS Nro_Factura,
    v.fecha AS Fecha_Emision,
    c.nombre + ' ' + c.apellido AS Cliente,
    c.direccion AS Enviar_a,
    p.nombre AS Producto,
    dv.cantidad AS Cantidad,
    dv.precio_unitario_historico AS Precio_Unitario,
    (dv.cantidad * dv.precio_unitario_historico) AS Subtotal_Renglon,
    -- subconsulta para calcular el total acumulado de la venta en la misma fila
    (SELECT SUM(cantidad * precio_unitario_historico) 
     FROM DETALLE_VENTA 
     WHERE id_venta = v.id_venta) AS Total_Acumulado_Factura
FROM VENTA v
INNER JOIN CLIENTE c ON v.id_cliente = c.id_cliente
INNER JOIN DETALLE_VENTA dv ON v.id_venta = dv.id_venta
INNER JOIN PRODUCTO p ON dv.id_producto = p.id_producto
WHERE v.id_venta = 5; 