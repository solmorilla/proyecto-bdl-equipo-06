# Investigación sobre procedimientos y funciones almacenadas

### 1.Objetivo
El objetivo de este desarrollo es centralizar la lógica de negocio y automatizar los procesos operativos de la lencería. Se busca evitar la repetición de código en la aplicación, garantizar la atomicidad de las operaciones de venta y estandarizar el cálculo de beneficios por fidelidad para los clientes.

## 2. Ventajas y aplicaciones

### Ventajas
- **Modularidad y Reutilización:** Permiten encapsular reglas de negocio complejas en un solo lugar, evitando duplicar código SQL en distintas partes del sistema.
- **Seguridad e Integridad:** Restringen el acceso directo del usuario a las tablas operativas, obligando a interactuar a través de canales controlados y transacciones seguras (`BEGIN TRANSACTION`, `COMMIT`, `ROLLBACK`).
- **Rendimiento:** Al estar precompilados en el motor de SQL Server Express, optimizan el tiempo de respuesta y reducen el tráfico de red.

### Aplicaciones
- Inserciones complejas que involucren múltiples tablas relacionadas (como el registro de una venta que afecta cabeceras, detalles e inventario simultáneamente).
- Cálculos repetitivos o reportes de estado que requieran evaluar históricos de compras, escalas de descuentos o bonificaciones personalizadas.

## 3. Implementación en SQL Server

 **Implementación de la Función (`dbo.fn_CalcularDescuentoCliente`):**
   Recibe el ID del cliente, consulta el historial sumando los subtotales de las tablas `VENTA` y `DETALLE_VENTA` mediante uniones, y evalúa escalas condicionales para retornar el porcentaje correspondiente (`0.10`, `0.05` o `0.00`).
   
   CREATE FUNCTION dbo.fn_CalcularDescuentoCliente (@id_cliente INT)
   RETURNS DECIMAL(5,2)
   AS
   BEGIN
       DECLARE @total_gastado DECIMAL(12,2);
       DECLARE @descuento DECIMAL(5,2);

       SELECT @total_gastado = ISNULL(SUM(dv.cantidad * dv.precio_unitario_historico), 0)
       FROM VENTA v
       INNER JOIN DETALLE_VENTA dv ON v.id_venta = dv.id_venta
       WHERE v.id_cliente = @id_cliente;

       IF @total_gastado > 500000
           SET @descuento = 0.10;
       ELSE IF @total_gastado > 200000
           SET @descuento = 0.05;
       ELSE
           SET @descuento = 0.00;

       RETURN @descuento;
   END;
   GO

**Implementación del Procedimiento (`dbo.sp_RegistrarVentaCompleta`):**
Captura el precio vigente del producto, insertando la cabecera en `VENTA`, recuperando el ID generado, insertando el renglón en `DETALLE_VENTA` y actualizando el stock del catálogo.

CREATE PROCEDURE dbo.sp_RegistrarVentaCompleta
    @p_id_cliente INT,
    @p_id_metodo_pago INT,
    @p_id_producto INT,
    @p_cantidad INT
AS
BEGIN
    DECLARE @v_id_venta INT;
    DECLARE @v_precio_vigente DECIMAL(12,2);

    SELECT @v_precio_vigente = precio_vigente 
    FROM PRODUCTO 
    WHERE id_producto = @p_id_producto;

    INSERT INTO VENTA (fecha, estado, id_cliente, id_metodo_pago)
    VALUES (SYSDATETIME(), 'Pendiente', @p_id_cliente, @p_id_metodo_pago);

    SET @v_id_venta = SCOPE_IDENTITY();

    INSERT INTO DETALLE_VENTA (id_venta, id_producto, cantidad, precio_unitario_historico)
    VALUES (@v_id_venta, @p_id_producto, @p_cantidad, @v_precio_vigente);

    UPDATE PRODUCTO
    SET stock = stock - @p_cantidad
    WHERE id_producto = @p_id_producto;

    PRINT 'Venta registrada con éxito. Stock actualizado.';
END;
GO

## 4. Script de demostración y resultados obtenidos
Las evidencias visuales obtenidas de las pruebas se encuentran guardadas en la carpeta evidencias/ del repositorio: