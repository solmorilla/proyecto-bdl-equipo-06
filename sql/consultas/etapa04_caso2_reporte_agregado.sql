-- -------------------------------------------------------------------------
-- CASO DE USO 2
-- Consigna Oficial: Reporte Agregado. Total de ventas realizadas por cada 
-- vendedor o por cada categoría de producto en un rango de fechas 
-- (GROUP BY, SUM, COUNT).
-- -------------------------------------------------------------------------

SELECT 
    cat.nombre AS Categoria_Producto,
    COUNT(DISTINCT v.id_venta) AS Cantidad_Pedidos,
    SUM(dv.cantidad) AS Unidades_Vendidas,
    SUM(dv.cantidad * dv.precio_unitario_historico) AS Ingresos_Totales
FROM VENTA v
INNER JOIN DETALLE_VENTA dv ON v.id_venta = dv.id_venta
INNER JOIN PRODUCTO p ON dv.id_producto = p.id_producto
INNER JOIN CATEGORIA cat ON p.id_categoria = cat.id_categoria
WHERE v.fecha BETWEEN '2026-09-01' AND '2026-09-30'
  AND v.estado != 'Cancelado'
GROUP BY cat.nombre
ORDER BY Ingresos_Totales DESC;