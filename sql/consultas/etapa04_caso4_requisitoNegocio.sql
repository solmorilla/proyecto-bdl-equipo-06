SELECT 
    p.id_producto AS Codigo,
    p.nombre AS Producto,
    cat.nombre AS Categoria,
    p.talle AS Talle,
    p.stock AS Stock_Actual,
    p.precio_vigente AS Precio_Lista
FROM PRODUCTO p
INNER JOIN CATEGORIA cat ON p.id_categoria = cat.id_categoria
WHERE p.stock <= 15
ORDER BY p.stock ASC;