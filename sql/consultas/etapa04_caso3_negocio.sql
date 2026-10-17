
-- CASO DE USO 3
-- Consulta de Negocio Avanzada. Consulta que combine 
-- al menos 3 tablas mediante JOIN y aplique filtros condicionales (HAVING).
-- Descripción: Identifica clientes "VIP" que superen los $20.000 de gasto.


SELECT 
    c.nombre + ' ' + c.apellido AS Cliente_VIP,
    c.email AS Correo_Contacto,
    COUNT(DISTINCT v.id_venta) AS Total_Compras_Realizadas,
    SUM(dv.cantidad * dv.precio_unitario_historico) AS Monto_Total_Invertido
FROM CLIENTE c
INNER JOIN VENTA v ON c.id_cliente = v.id_cliente
INNER JOIN DETALLE_VENTA dv ON v.id_venta = dv.id_venta
WHERE v.estado != 'Cancelado'
GROUP BY c.id_cliente, c.nombre, c.apellido, c.email
HAVING SUM(dv.cantidad * dv.precio_unitario_historico) > 20000
ORDER BY Monto_Total_Invertido DESC;