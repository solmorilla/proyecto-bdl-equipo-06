# Triggers de Auditoría en SQL Server

## 1. Definición y objetivo

Un trigger es un objeto de la base de datos que ejecuta automáticamente un conjunto de instrucciones cuando ocurre un evento determinado sobre una tabla o vista.

En SQL Server, los triggers DML permiten responder a operaciones como INSERT, UPDATE y DELETE.

El objetivo de los triggers de auditoría es registrar automáticamente las modificaciones realizadas sobre los datos, permitiendo conocer qué información cambió, cuándo ocurrió y qué usuario inició la operación.

En nuestro sistema de ventas de lencería se implementó un trigger sobre la tabla PRODUCTO para registrar los cambios de precios. De esta manera, se obtiene un historial de las modificaciones realizadas sobre el precio de venta de los productos.

## 2. Ventajas y aplicaciones

Las principales ventajas de los triggers de auditoría son:

- **Trazabilidad:** permiten consultar los cambios realizados en los productos.
- **Automatización:** el registro se genera sin necesidad de que la aplicación lo realice manualmente.
- **Control interno:** facilitan la detección de modificaciones inesperadas en los precios.
- **Consistencia:** el registro de auditoría se genera como parte de la misma operación que modifica el producto.
- **Historial de cambios:** permiten comparar los precios anteriores con los nuevos.

Entre sus desventajas se encuentran el aumento del trabajo que debe realizar el motor de base de datos y la necesidad de mantener correctamente las tablas de auditoría. Un trigger mal diseñado también puede afectar el rendimiento de las operaciones.

## 3. Implementación en SQL Server Express

Para implementar la auditoría se creó la tabla auditoria_producto, destinada a almacenar los datos de cada modificación de precio.

La tabla contiene los siguientes campos:

- **id_auditoria:** identificador único del registro.
- **fecha_hora:** fecha y hora en que se registra el cambio.
- **usuario_responsable:** inicio de sesión original de SQL Server.
- **id_producto:** identificador del producto modificado.
- **nombre_producto:** nombre del producto auditado.
- **precio_anterior:** valor del precio antes de la modificación.
- **precio_nuevo:** valor del precio después de la modificación.

Posteriormente, se implementó el trigger tr_auditoria_precio_producto sobre la tabla PRODUCTO mediante AFTER UPDATE.

El trigger utiliza las tablas virtuales inserted y deleted para comparar los valores nuevos y anteriores. La tabla inserted contiene los valores posteriores a la modificación, mientras que deleted conserva los valores anteriores.

La condición de comparación permite registrar únicamente los casos en los que precio_vigente presenta una modificación real. Además, el trigger utiliza ORIGINAL_LOGIN() para identificar el inicio de sesión original de SQL Server que ejecutó la operación. Este valor no necesariamente identifica a la persona física si varias personas comparten una misma cuenta.

## 4. Caso concreto aplicado al sistema de ventas de lencería

En el sistema de ventas, la tabla PRODUCTO almacena información de los artículos comercializados, como su nombre, talle, precio vigente y stock.

El precio de venta puede modificarse por decisiones comerciales o actualizaciones de precios. Para mantener un registro de estos cambios se implementó el trigger de auditoría.

Cuando se actualiza el precio de un producto, el trigger registra automáticamente la operación en auditoria_producto. El registro incluye el identificador y nombre del producto, la fecha y hora, el usuario responsable y los valores del precio anterior y del nuevo.

Esta información permite revisar las modificaciones realizadas y facilita el control de los precios del catálogo.

La implementación se enfoca específicamente en las modificaciones del precio de venta. Los cambios en el stock, talle o descripción no generan registros de auditoría mediante este trigger.

## 5. Script de demostración y resultados obtenidos

Para comprobar el funcionamiento se realizaron las siguientes operaciones:

1. Se creó la tabla auditoria_producto.
2. Se creó el trigger tr_auditoria_precio_producto sobre PRODUCTO.
3. Se insertó un producto de prueba con un precio inicial de $5.000.
4. Se actualizó el precio del producto a $5.500.
5. Se consultó la tabla auditoria_producto para verificar el registro generado.
6. Se volvió a modificar el precio de $5.500 a $5.600 y se consultó nuevamente la tabla de auditoría.

Como resultado, se obtuvieron dos registros de auditoría para el producto de prueba:

- **Primer cambio:** precio anterior de $5.000 y precio nuevo de $5.500.
- **Segundo cambio:** precio anterior de $5.500 y precio nuevo de $5.600.

En ambos registros se almacenaron la fecha y hora, el usuario responsable, el identificador del producto y su nombre.

Las pruebas permitieron comprobar que el trigger registra automáticamente las modificaciones del precio sin necesidad de insertar manualmente los registros de auditoría.

Las capturas de la actualización del precio y de los registros generados se encuentran en la carpeta evidencias/.

## Conclusión

La implementación de triggers de auditoría mejora la trazabilidad y el control de los cambios de precios en el sistema de ventas de lencería.

La automatización del registro permite disponer de un historial útil para revisar las modificaciones y reduce la dependencia de la aplicación para mantener esa información.

De esta manera, se mejora la capacidad de control y mantenimiento de la base de datos, cumpliendo el objetivo de implementar un mecanismo de auditoría mediante SQL Server Express.