-- ==============================================================================
-- ETAPA III: SCRIPT DML - Poblado Inicial de Datos de Prueba
-- Coherencia: 8 a 10 registros por tabla
-- ==============================================================================

-- PARTE 1: Entidades Maestras (Mauro)
INSERT INTO CATEGORIA (nombre, descripcion) VALUES 
('Pijamas Invierno', 'Pijamas de polar y franela'),
('Pijamas Verano', 'Pijamas cortos de algodón y satén'),
('Lencería Fina', 'Conjuntos de encaje y lencería de diseño'),
('Básicos', 'Ropa interior de uso diario'),
('Batas', 'Batas de toalla y seda'),
('Pantuflas', 'Calzado de descanso para interiores'),
('Medias', 'Medias de algodón y térmicas'),
('Maternal', 'Lencería y pijamas para lactancia');

INSERT INTO METODO_PAGO (nombre) VALUES 
('Efectivo'), 
('Transferencia Bancaria'), 
('Tarjeta de Débito'), 
('Tarjeta de Crédito Visa'), 
('Tarjeta de Crédito MasterCard'), 
('MercadoPago'), 
('Cuenta DNI'), 
('Modo');

INSERT INTO CLIENTE (nombre, apellido, email, telefono, direccion) VALUES 
('Valentina', 'Gómez', 'valegomez@email.com', '3794111111', 'San Martín 123, Corrientes'),
('Martín', 'Pérez', 'martin.p@email.com', '3794222222', 'Junín 456, Corrientes'),
('Lucía', 'Fernández', 'luciaf@email.com', '3794333333', 'Av. 3 de Abril 789, Corrientes'),
('Carlos', 'López', 'carlopez@email.com', '3794444444', 'Belgrano 101, Resistencia'),
('Sofía', 'Romero', 'sofi.romero@email.com', '3794555555', 'Salta 202, Corrientes'),
('Agustín', 'Díaz', 'agusdiaz@email.com', '3794666666', 'Mendoza 303, Corrientes'),
('María', 'García', 'mariagarcia@email.com', '3794777777', '9 de Julio 404, Resistencia'),
('Julieta', 'Alonso', 'julialonso@email.com', '3794888888', 'Pellegrini 505, Corrientes');

-- ==============================================================================
-- PARTE 2: Entidades Transaccionales y Dependientes (Lorenzo Marder)
-- ==============================================================================

INSERT INTO PRODUCTO (nombre, descripcion, talle, precio_vigente, stock, id_categoria) VALUES 
('Pijama Polar Oso', 'Pijama de dos piezas súper abrigado', 'M', 25000.00, 15, 1),
('Conjunto Satén', 'Musculosa y short de satén negro', 'S', 18000.00, 20, 2),
('Conjunto Encaje Rojo', 'Soutien y bombacha de encaje', '90', 22000.00, 10, 3),
('Pack Bombachas', 'Pack x3 bombachas de algodón', 'L', 9500.00, 30, 4),
('Bata de Toalla', 'Bata blanca absorbente', 'Único', 30000.00, 5, 5),
('Pantuflas Piel', 'Pantuflas cerradas con corderito', '38', 12000.00, 25, 6),
('Medias Térmicas', 'Medias largas para invierno', 'Único', 4500.00, 50, 7),
('Camisón Maternal', 'Camisón con apertura para lactancia', 'XL', 19000.00, 12, 8);

INSERT INTO VENTA (fecha, estado, id_cliente, id_metodo_pago) VALUES 
('2026-09-01', 'Despachado', 1, 2),
('2026-09-05', 'Abonado', 2, 6),
('2026-09-10', 'Pendiente', 3, 1),
('2026-09-12', 'Cancelado', 4, 3),
('2026-09-15', 'Despachado', 5, 4),
('2026-09-20', 'Pendiente', 6, 7),
('2026-09-25', 'Abonado', 7, 2),
('2026-09-28', 'Despachado', 8, 5);

INSERT INTO DETALLE_VENTA (id_venta, id_producto, cantidad, precio_unitario_historico) VALUES 
(1, 1, 1, 25000.00),
(2, 3, 2, 22000.00),
(3, 4, 1, 9500.00),
(4, 2, 1, 18000.00),
(5, 5, 1, 30000.00),
(5, 6, 1, 12000.00),
(6, 7, 3, 4500.00),
(7, 8, 1, 19000.00),
(8, 1, 2, 25000.00),
(8, 4, 1, 9500.00);