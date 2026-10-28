# Investigación: Transacciones SQL

1. Objetivo

El objetivo de esta implementación es garantizar que el registro de una venta en el sistema de gestión de la lencería Sueño Contigo se realice de forma segura, manteniendo la integridad de los datos de la base de datos.

Para ello, se utiliza una transacción SQL que agrupa las operaciones de registro de la venta, inserción de sus detalles y actualización del stock de productos.

2. Atomicidad

La atomicidad es una de las propiedades ACID de las bases de datos. Establece que una transacción debe ejecutarse completamente o no ejecutarse en absoluto. Esto se conoce como el principio de «Todo o Nada».

En nuestro sistema, el registro de una venta implica tres operaciones principales:

- Insertar la cabecera de la venta en la tabla VENTA.
- Insertar los productos vendidos en la tabla DETALLE_VENTA.
- Descontar las unidades vendidas del stock en la tabla PRODUCTO.

Estas operaciones se ejecutan dentro de una misma transacción mediante BEGIN TRANSACTION. Si todas se realizan correctamente, se utiliza COMMIT TRANSACTION para confirmar los cambios. Si ocurre un error, el bloque CATCH ejecuta ROLLBACK TRANSACTION para deshacer las modificaciones realizadas dentro de la transacción.

De esta manera, se evita que una venta quede registrada parcialmente, por ejemplo, con una cabecera sin sus detalles o con el stock descontado sin que la operación se haya completado.

3. Consistencia

La consistencia es otra propiedad ACID. Significa que una transacción debe mantener las reglas y restricciones de integridad de la base de datos, llevando los datos de un estado válido a otro estado válido.

En el sistema Sueño Contigo, la consistencia se favorece mediante los siguientes controles:

- Existencia del producto: antes de registrar la venta, se verifica que el producto seleccionado exista.
- Disponibilidad del stock: la actualización descuenta las unidades únicamente si el stock disponible es suficiente.
- Integridad referencial: las claves foráneas de las tablas involucradas ayudan a garantizar que la venta se relacione con un cliente y un método de pago válidos, y que el detalle corresponda a una venta y un producto existentes.
- Precio histórico: se guarda en DETALLE_VENTA el precio unitario utilizado en la venta, conservando el valor aplicado en esa operación.

Si se detecta que el producto no existe o que el stock es insuficiente, se genera un error y la transacción se cancela.

4. Implementación en SQL Server

Para implementar la transacción se utilizan las siguientes instrucciones:

- BEGIN TRANSACTION: inicia la transacción.
- BEGIN TRY: contiene las operaciones que se intentan ejecutar.
- THROW: genera un error cuando se detecta una condición inválida.
- COMMIT TRANSACTION: confirma los cambios cuando todas las operaciones finalizan correctamente.
- BEGIN CATCH: captura los errores producidos durante la ejecución.
- ROLLBACK TRANSACTION: deshace los cambios de la transacción cuando ocurre un error y existe una transacción activa.
- SCOPE_IDENTITY(): obtiene el identificador generado para la nueva venta, que luego se utiliza para registrar sus detalles.

5. Aplicación al sistema Sueño Contigo

La transacción se aplica al proceso de registrar una venta de productos de lencería. Primero se obtiene el precio vigente del producto y se registra la cabecera de la venta. Luego se guarda el detalle con la cantidad vendida y el precio histórico. Finalmente, se descuenta del stock la cantidad correspondiente.

Todas estas operaciones forman parte de la misma transacción. Esto permite mantener relacionadas la información de la venta, sus detalles y las existencias de los productos.

6. Conclusión

La implementación de transacciones permite que el registro de una venta se realice como una única unidad de trabajo. La atomicidad garantiza que las operaciones se confirmen juntas o se deshagan ante un error, mientras que la consistencia contribuye a mantener las reglas de integridad de la base de datos.

De esta forma, el sistema Sueño Contigo puede registrar las ventas y actualizar el stock de manera controlada, reduciendo el riesgo de inconsistencias en la información.