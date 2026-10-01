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