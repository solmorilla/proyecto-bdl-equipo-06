# Etapa 5: Optimización de Consultas mediante Índices

**Proyecto:** Sueño Contigo  
**Equipo:** 06  
**Integrante:** Lucas Tomás Fernandez  
**Materia:** Base de Datos I  

## 1. Definición y objetivo

### Definición
Un *índice* en SQL Server es una estructura de datos en disco asociada a una tabla o vista que acelera la recuperación de filas. 
Funciona de manera análoga al índice alfabético de un libro: en lugar de escanear todas las páginas para encontrar un tema, el motor consulta la estructura del índice y se dirige directamente a la ubicación física de las páginas de datos requeridas.

### Objetivo
El objetivo de esta investigación y práctica es analizar, implementar y medir el impacto que tiene la creación de índices en el rendimiento de consultas sobre tablas con volúmenes masivos de información (1.000.000 de registros). 
Se busca optimizar los tiempos de ejecución, el procesamiento de CPU y, principalmente, minimizar la cantidad de lecturas lógicas a disco.


## 2. Ventajas y aplicaciones

### Ventajas
- *Reducción del costo de E/S (Entrada/Salida):* Disminuye de forma drástica la cantidad de páginas de datos que el motor debe leer desde el disco o la memoria caché.
- *Mejora en tiempos de respuesta:* Transforma búsquedas secuenciales lentas (Table Scan) en búsquedas directas por árbol B (Index Seek).
- *Cobertura total de consultas (Covering Index):* Al usar la cláusula INCLUDE, permite responder la consulta únicamente accediendo a las hojas del índice sin necesidad de consultar la tabla base.

### Aplicaciones
- Tablas de transacciones o históricos con millones de registros (como ventas, auditorías o facturación).
- Columnas frecuentemente utilizadas en cláusulas de filtrado (WHERE), uniones (JOIN), ordenamiento (ORDER BY) y agrupamiento (GROUP BY).


## 3. Implementación en SQL Server Express

En *SQL Server Express*, los índices se gestionan a través del motor relacional mediante comandos T-SQL en SQL Server Management Studio (SSMS). Se implementan dos arquitecturas principales:
1. *Índice Agrupado (CLUSTERED):*
   - Determina el orden físico en el que se almacenan los datos dentro de la tabla.
   - Solo puede existir *un índice agrupado por tabla*.
   - Sintaxis de creación:
     sql
     CREATE CLUSTERED INDEX IX_VentaHistorica_Fecha 
     ON dbo.VentaHistorica (fecha);
     
2. *Índice No Agrupado (NONCLUSTERED) con Columnas Incluidas (INCLUDE):*
   - Mantiene una estructura de árbol B separada de la tabla. Sus hojas contienen las claves de búsqueda y punteros hacia la tabla base.
   - La cláusula INCLUDE añade columnas adicionales únicamente al nivel hoja del índice, logrando que la consulta sea "cubierta" (Covering Index) sin costo adicional en el tamaño de los nodos intermedios.
   - Sintaxis de creación:
     sql
     CREATE NONCLUSTERED INDEX IX_VentaHistorica_Fecha_IncluyeImporte 
     ON dbo.VentaHistorica (fecha) 
     INCLUDE (importe);
     

## 4. Caso concreto aplicado al sistema de ventas del equipo

En el sistema *Sueño Contigo*, se requiere generar reportes periódicos de ventas por rango de fechas (por ejemplo, obtener todas las ventas realizadas en un año específico para balances financieros).

Para simular este escenario a escala de producción, se creó la tabla transaccional dbo.VentaHistorica poblada sintéticamente con *1.000.000 de registros* de ventas (columnas: id_venta_historica, fecha, importe). 

La consulta bajo prueba simula el reporte anual del sistema:
```sql
SELECT fecha, importe
FROM dbo.VentaHistorica
WHERE fecha >= '20240101' AND fecha < '20250101';cas en más de un 90% en comparación con la consulta en una tabla sin indexar.