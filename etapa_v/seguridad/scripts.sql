USE SuenoContigo;
GO

-- 1. Creación de Logins y Usuarios
CREATE LOGIN login_admin WITH PASSWORD = 'PasswordFuerte123!';
CREATE USER usuario_admin FOR LOGIN login_admin;

CREATE LOGIN login_lector WITH PASSWORD = 'PasswordLector123!';
CREATE USER usuario_lector FOR LOGIN login_lector;

CREATE LOGIN login_consulta WITH PASSWORD = 'PasswordConsulta123!';
CREATE USER usuario_consulta FOR LOGIN login_consulta;
GO

-- 2. Asignación de permisos al Administrador
ALTER ROLE db_owner ADD MEMBER usuario_admin;
GO

-- 3. Creación del Procedimiento Almacenado (para la prueba del lector)
CREATE PROCEDURE SP_RegistrarVenta
    @id_cliente INT,
    @id_metodo_pago INT
AS
BEGIN
    INSERT INTO VENTA (estado, id_cliente, id_metodo_pago)
    VALUES ('Pendiente', @id_cliente, @id_metodo_pago);
END;
GO

-- 4. Permisos del usuario_lector (Principio de Mínimo Privilegio)
GRANT SELECT ON VENTA TO usuario_lector;
GRANT EXECUTE ON SP_RegistrarVenta TO usuario_lector;
DENY INSERT ON VENTA TO usuario_lector; -- Bloqueo explícito de inserción directa
GO

-- 5. Creación de rol personalizado y asignación de permisos
CREATE ROLE rol_consulta_productos;
GRANT SELECT ON PRODUCTO TO rol_consulta_productos;
ALTER ROLE rol_consulta_productos ADD MEMBER usuario_consulta;
GO