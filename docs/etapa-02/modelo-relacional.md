CLIENTE(
    id_cliente PK,
    nombre,
    apellido,
    email,
    telefono,
    direccion
)

CATEGORIA(
    id_categoria PK,
    nombre,
    descripcion
)

PRODUCTO(
    id_producto PK,
    nombre,
    descripcion,
    talle,
    precio_vigente,
    stock,
    id_categoria FK
)

METODO_PAGO(
    id_metodo_pago PK,
    nombre
)

VENTA(
    id_venta PK,
    fecha,
    estado,
    id_cliente FK,
    id_metodo_pago FK
)

DETALLE_VENTA(
    id_venta PK/FK,
    id_producto PK/FK,
    cantidad,
    precio_unitario_historico
)
