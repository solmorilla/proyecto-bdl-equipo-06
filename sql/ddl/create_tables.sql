CREATE DATABASE SuenoContigo_BDL;
GO

USE SuenoContigo_BDL;
GO


-- ============================================
-- TABLA: CLIENTE
-- ============================================

CREATE TABLE CLIENTE (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(150)
);
GO


-- ============================================
-- TABLA: CATEGORIA
-- ============================================

CREATE TABLE CATEGORIA (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150)
);
GO


-- ============================================
-- TABLA: METODO_PAGO
-- ============================================

CREATE TABLE METODO_PAGO (
    id_metodo_pago INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);
GO


-- ============================================
-- TABLA: PRODUCTO
-- ============================================

CREATE TABLE PRODUCTO (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(200),
    talle VARCHAR(20) NOT NULL,
    precio_vigente DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    id_categoria INT NOT NULL,

    CONSTRAINT FK_PRODUCTO_CATEGORIA
        FOREIGN KEY (id_categoria)
        REFERENCES CATEGORIA(id_categoria),

    CONSTRAINT CK_PRODUCTO_PRECIO
        CHECK (precio_vigente >= 0),

    CONSTRAINT CK_PRODUCTO_STOCK
        CHECK (stock >= 0)
);
GO


-- ============================================
-- TABLA: VENTA
-- ============================================

CREATE TABLE VENTA (
    id_venta INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATETIME NOT NULL DEFAULT GETDATE(),
    estado VARCHAR(20) NOT NULL,
    id_cliente INT NOT NULL,
    id_metodo_pago INT NOT NULL,

    CONSTRAINT FK_VENTA_CLIENTE
        FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE(id_cliente),

    CONSTRAINT FK_VENTA_METODO_PAGO
        FOREIGN KEY (id_metodo_pago)
        REFERENCES METODO_PAGO(id_metodo_pago),

    CONSTRAINT CK_VENTA_ESTADO
        CHECK (estado IN ('Pendiente', 'Abonado', 'Despachado', 'Cancelado'))
);
GO


-- ============================================
-- TABLA: DETALLE_VENTA
-- ============================================

CREATE TABLE DETALLE_VENTA (
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario_historico DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_DETALLE_VENTA
        PRIMARY KEY (id_venta, id_producto),

    CONSTRAINT FK_DETALLE_VENTA_VENTA
        FOREIGN KEY (id_venta)
        REFERENCES VENTA(id_venta),

    CONSTRAINT FK_DETALLE_VENTA_PRODUCTO
        FOREIGN KEY (id_producto)
        REFERENCES PRODUCTO(id_producto),

    CONSTRAINT CK_DETALLE_VENTA_CANTIDAD
        CHECK (cantidad > 0),

    CONSTRAINT CK_DETALLE_VENTA_PRECIO
        CHECK (precio_unitario_historico >= 0)
);
GO