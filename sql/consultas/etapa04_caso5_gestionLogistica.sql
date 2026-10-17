SELECT 
    v.id_venta AS Nro_Pedido,
    v.fecha AS Fecha_Compra,
    c.nombre + ' ' + c.apellido AS Cliente,
    c.telefono AS Telefono,
    c.direccion AS Direccion_Envio,
    v.estado AS Estado_Logistico,
    mp.nombre AS Metodo_Pago
FROM VENTA v
INNER JOIN CLIENTE c ON v.id_cliente = c.id_cliente
INNER JOIN METODO_PAGO mp ON v.id_metodo_pago = mp.id_metodo_pago
WHERE v.estado IN ('Pendiente', 'Abonado')
ORDER BY v.fecha ASC;