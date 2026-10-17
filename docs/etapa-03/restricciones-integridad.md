# Restricciones de Integridad y Reglas de Negocio - Etapa III

## 1. Integridad de Entidad (Claves Primarias)
* **Claves simples:** Se definieron identificadores enteros autoincrementales (`INT IDENTITY(1,1) PRIMARY KEY`) en las entidades `CLIENTE`, `CATEGORIA`, `METODO_PAGO`, `PRODUCTO` y `VENTA`.
* **Clave primaria compuesta:** En la tabla `DETALLE_VENTA` se definió la clave primaria sobre `(id_venta, id_producto)`. Esto evita que un mismo producto se repita en distintas líneas de una misma venta, asegurando que se agrupe la cantidad comprada.

## 2. Integridad Referencial (Claves Foráneas)
* **FK_PRODUCTO_CATEGORIA:** Relaciona `PRODUCTO` con `CATEGORIA`. Un producto no puede existir sin estar asociado a una categoría válida.
* **FK_VENTA_CLIENTE:** Relaciona `VENTA` con `CLIENTE`. Toda venta debe tener asignado al cliente que realizó la compra.
* **FK_VENTA_METODO_PAGO:** Relaciona `VENTA` con `METODO_PAGO`, obligando a registrar el medio de cobro utilizado.
* **FK_DETALLE_VENTA_VENTA:** Relaciona el detalle con la cabecera de la venta. Garantiza que cada línea de detalle pertenezca a una orden real.
* **FK_DETALLE_VENTA_PRODUCTO:** Relaciona el detalle con el producto vendido, evitando ítems sin referencia en el catálogo.

## 3. Integridad de Dominio y Validaciones
* **Restricciones CHECK:**
  * `CK_PRODUCTO_PRECIO`: `precio_vigente >= 0` para evitar precios negativos.
  * `CK_PRODUCTO_STOCK`: `stock >= 0` para que el stock no quede en valores negativos.
  * `CK_VENTA_ESTADO`: Restringe los estados permitidos a `('Pendiente', 'Abonado', 'Despachado', 'Cancelado')`.
  * `CK_DETALLE_VENTA_CANTIDAD`: `cantidad > 0` para asegurar que cada línea vendida tenga al menos 1 unidad.
  * `CK_DETALLE_VENTA_PRECIO`: `precio_unitario_historico >= 0` para registrar el precio unitario pactado al momento de la venta.
* **Restricciones UNIQUE:**
  * `CLIENTE.email`: Impide que dos clientes se registren con el mismo correo.
  * `METODO_PAGO.nombre`: Evita nombres de métodos de pago repetidos.
* **Valores por defecto (DEFAULT):**
  * `VENTA.fecha`: Toma por defecto la fecha y hora del sistema mediante `GETDATE()`.