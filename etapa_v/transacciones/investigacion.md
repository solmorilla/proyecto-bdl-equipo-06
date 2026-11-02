# Investigación: Manejo de transacciones SQL

Proyecto: Sueño Contigo  
Etapa: V – Transacciones  
Responsable: Sol Valentina Morilla
Base de datos: SuenoContigo_BDL

## 1. Definición y objetivo

Una transacción es una unidad lógica de trabajo que agrupa una o varias operaciones realizadas sobre una base de datos. Su objetivo es garantizar que dichas operaciones se ejecuten de manera controlada, evitando que un error deje información incompleta o inconsistente.

En SQL Server, las transacciones permiten confirmar todos los cambios realizados o deshacerlos cuando ocurre un problema.

En el sistema Sueño Contigo, el objetivo es asegurar que el registro de una venta, la inserción de sus detalles y la actualización del stock se realicen como una única operación.

## 2. Ventajas y aplicaciones

El uso de transacciones presenta las siguientes ventajas:

- Integridad de los datos: evita que queden registros incompletos cuando ocurre un error.
- Consistencia: permite mantener relacionados correctamente los datos de las ventas, sus detalles y el inventario.
- Recuperación ante errores: mediante `ROLLBACK` se pueden deshacer los cambios realizados durante una transacción.
- Seguridad en las operaciones: permite confirmar los cambios solamente cuando todas las operaciones se completaron correctamente.
- Control de operaciones simultáneas: permite utilizar bloqueos para reducir problemas cuando varias operaciones intentan modificar los mismos datos.

Las transacciones pueden aplicarse en distintos procesos de un sistema, por ejemplo:

- Registro de ventas.
- Actualización de inventario.
- Registro de compras.
- Procesamiento de pagos.
- Movimientos de productos entre depósitos.

## 3. Implementación en SQL Server Express

En SQL Server Express, las transacciones se implementan mediante instrucciones de Transact-SQL.

Las principales instrucciones utilizadas son:

- `BEGIN TRANSACTION`: inicia una transacción.
- `COMMIT TRANSACTION`: confirma los cambios realizados.
- `ROLLBACK TRANSACTION`: deshace los cambios realizados durante la transacción.
- `TRY...CATCH`: permite controlar los errores que puedan producirse.
- `THROW`: genera un error para interrumpir la operación cuando se detecta una condición inválida.
- `SCOPE_IDENTITY()`: obtiene el último identificador generado mediante una columna `IDENTITY` dentro del mismo ámbito.

También se utilizan condiciones `IF` para validar los datos antes de confirmar la operación.

En nuestra implementación se utilizan bloqueos mediante `UPDLOCK` y `HOLDLOCK` al consultar el producto. Esto ayuda a evitar que otra transacción modifique simultáneamente el stock mientras se está registrando la venta.

La estructura general de una transacción es:

1. Iniciar la transacción.
2. Realizar las validaciones necesarias.
3. Ejecutar las operaciones sobre las tablas.
4. Confirmar los cambios mediante `COMMIT` si todo fue correcto.
5. Deshacer los cambios mediante `ROLLBACK` si ocurre un error.

## 4. Propiedades ACID

Las propiedades ACID describen las garantías principales que deben ofrecer las transacciones:

### 4.1. Atomicidad

Establece que una transacción se ejecuta completamente o no se ejecuta.

En nuestro sistema, si se registra la cabecera de una venta y su detalle, pero no existe stock suficiente, se debe cancelar toda la operación. De esta manera, no queda una venta registrada sin que se haya podido actualizar correctamente el inventario.

### 4.2. Consistencia

Garantiza que una transacción mantenga la base de datos en un estado válido, respetando las reglas y restricciones definidas.

En nuestro caso, se valida que el producto exista, que la cantidad sea mayor que cero y que haya stock suficiente. Además, se respetan las relaciones entre las tablas de ventas, detalles, productos, clientes y métodos de pago.

### 4.3. Aislamiento

Permite controlar cómo interactúan las transacciones que se ejecutan simultáneamente.

En nuestro script se utilizan `UPDLOCK` y `HOLDLOCK` al consultar el producto, para proteger el registro durante la operación y reducir el riesgo de que otra transacción modifique el stock al mismo tiempo.

### 4.4. Durabilidad

Establece que los cambios confirmados mediante `COMMIT` deben permanecer guardados en la base de datos, incluso después de finalizar la transacción.

En nuestro sistema, una venta confirmada debe conservarse en las tablas `VENTA` y `DETALLE_VENTA`, junto con el stock actualizado.

## 5. Caso concreto aplicado al sistema de ventas Sueño Contigo

En el sistema de ventas Sueño Contigo, cada operación de venta involucra distintas tablas de la base de datos.

Para registrar una venta correctamente se deben realizar las siguientes operaciones:

1. Obtener el precio vigente y el stock del producto seleccionado.
2. Verificar que el producto exista y que la cantidad solicitada sea válida.
3. Insertar la cabecera de la venta en la tabla `VENTA`.
4. Obtener el identificador generado para esa venta.
5. Insertar el detalle en `DETALLE_VENTA`, conservando el precio histórico del producto.
6. Verificar que exista stock suficiente.
7. Descontar del inventario la cantidad vendida.
8. Confirmar la transacción mediante `COMMIT`.

Todas estas operaciones se encuentran dentro de una misma transacción.

Si alguna validación falla o se produce un error, se ejecuta `ROLLBACK`, evitando que queden cambios parciales en la base de datos.

## 6. Script de demostración y resultados obtenidos

La implementación se encuentra en el archivo `scripts.sql`, dentro de la carpeta `etapa_v/transacciones/`.

El script contiene dos pruebas principales.

### 6.1. Prueba exitosa: registro de una venta

Se ejecuta una transacción con una cantidad de unidades inferior o igual al stock disponible.

Se espera que:

- Se inserte un registro en `VENTA`.
- Se inserte el detalle correspondiente en `DETALLE_VENTA`.
- Se descuente la cantidad vendida del stock del producto.
- Se confirme la operación mediante `COMMIT TRANSACTION`.


### 6.2. Prueba fallida: rollback por stock insuficiente

Se ejecuta una transacción intentando vender 100 unidades del producto, una cantidad superior al stock disponible para la prueba.

Se espera que:

- Se detecte que no existe stock suficiente.
- Se genere un error mediante `THROW`.
- Se ejecute `ROLLBACK TRANSACTION`.
- Se revierta la inserción de la cabecera de la venta.
- Se revierta la inserción del detalle.
- El stock permanezca sin modificaciones.


## 7. Conclusión

Las transacciones permiten ejecutar operaciones relacionadas como una única unidad lógica de trabajo, manteniendo la integridad y consistencia de la información.

En el sistema Sueño Contigo, su implementación resulta fundamental para evitar que una venta quede registrada parcialmente o que el inventario se actualice de manera incorrecta.

Mediante las pruebas realizadas se busca demostrar el funcionamiento de `COMMIT` y `ROLLBACK`, especialmente las propiedades de atomicidad y consistencia, junto con los mecanismos de control utilizados para proteger las operaciones sobre el stock.