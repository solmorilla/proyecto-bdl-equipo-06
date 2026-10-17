# Pruebas de Validación y Control de Integridad - Etapa 03

**Proyecto:** E-Commerce Sueño Contigo  
**Equipo:** 06  


---

# 1. Verificación de Volumetría Requerida (8 a 10 registros por tabla)


```sql
SELECT 'CLIENTE' AS Tabla, COUNT(*) AS Total_Registros FROM CLIENTE
UNION ALL
SELECT 'CATEGORIA', COUNT(*) FROM CATEGORIA
UNION ALL
SELECT 'METODO_PAGO', COUNT(*) FROM METODO_PAGO
UNION ALL
SELECT 'PRODUCTO', COUNT(*) FROM PRODUCTO
UNION ALL
SELECT 'VENTA', COUNT(*) FROM VENTA
UNION ALL
SELECT 'DETALLE_VENTA', COUNT(*) FROM DETALLE_VENTA;