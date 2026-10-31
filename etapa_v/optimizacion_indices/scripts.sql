
/*
  PROYECTO: Sueño Contigo - Equipo 06
  ETAPA 5: Optimizacion de Consultas (Indices)
  INTEGRANTE: Lucas
  MOTOR: SQL Server

  IMPORTANTE:
  Ejecutar por bloques para guardar las evidencias
  de cada una de las tres pruebas.
*/

USE [SuenoContigo];
GO

/* =====================================================
   1. CREAR TABLA Y CARGAR 1.000.000 DE REGISTROS
   ===================================================== */

IF OBJECT_ID('dbo.VentaHistorica', 'U') IS NOT NULL
    DROP TABLE dbo.VentaHistorica;
GO

CREATE TABLE dbo.VentaHistorica
(
    id_venta_historica BIGINT IDENTITY(1,1) NOT NULL,
    fecha DATE NOT NULL,
    importe DECIMAL(12,2) NOT NULL
);
GO

/*
  Generamos un millon de filas con combinaciones
  de digitos. NEWID() permite distribuir fechas
  e importes pseudoaleatorios entre las filas.
*/

;WITH Digitos AS
(
    SELECT n
    FROM (VALUES (0),(1),(2),(3),(4),
                 (5),(6),(7),(8),(9)) AS D(n)
),
Numeros AS
(
    SELECT TOP (1000000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS numero
    FROM Digitos a
    CROSS JOIN Digitos b
    CROSS JOIN Digitos c
    CROSS JOIN Digitos d
    CROSS JOIN Digitos e
    CROSS JOIN Digitos f
)
INSERT INTO dbo.VentaHistorica (fecha, importe)
SELECT
    DATEADD
    (
        DAY,
        -CONVERT(INT,
            ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) % 3650),
        CONVERT(DATE, '20260101', 112)
    ),
    CONVERT
    (
        DECIMAL(12,2),
        100.00 +
        (ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) % 100000) / 100.0
    )
FROM Numeros;
GO

-- Verificar la cantidad de registros.
SELECT COUNT(*) AS TotalRegistros
FROM dbo.VentaHistorica;
GO


/* =====================================================
   2. PRUEBA A: SIN INDICES CREADOS POR NOSOTROS
   ===================================================== */



SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT fecha, importe
FROM dbo.VentaHistorica
WHERE fecha >= '20240101'
  AND fecha <  '20250101';
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO


/* =====================================================
   3. PRUEBA B: INDICE AGRUPADO (CLUSTERED)
   ===================================================== */

CREATE CLUSTERED INDEX IX_VentaHistorica_Fecha
ON dbo.VentaHistorica (fecha);
GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT fecha, importe
FROM dbo.VentaHistorica
WHERE fecha >= '20240101'
  AND fecha <  '20250101';
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO


/* =====================================================
   4. PRUEBA C: INDICE NO AGRUPADO CON INCLUDE
   ===================================================== */

/*
  Se elimina el indice agrupado para volver a dejar
  la tabla como heap, sin indice agrupado.
*/

DROP INDEX IX_VentaHistorica_Fecha
ON dbo.VentaHistorica;
GO

CREATE NONCLUSTERED INDEX IX_VentaHistorica_Fecha_IncluyeImporte
ON dbo.VentaHistorica (fecha)
INCLUDE (importe);
GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT fecha, importe
FROM dbo.VentaHistorica
WHERE fecha >= '20240101'
  AND fecha <  '20250101';
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO


/* =====================================================
   5. VERIFICACION FINAL
   ===================================================== */

-- Confirmar cantidad de filas.
SELECT COUNT(*) AS TotalRegistros
FROM dbo.VentaHistorica;
GO

-- Consultar los indices que quedaron creados.
SELECT
    name AS NombreIndice,
    type_desc AS TipoIndice
FROM sys.indexes
WHERE object_id = OBJECT_ID('dbo.VentaHistorica')
  AND index_id > 0;
GO
