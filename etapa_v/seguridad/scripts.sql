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

-- 2. Asignación al administrador
ALTER ROLE db_owner ADD MEMBER usuario_admin;
GO

-- 3. Permisos del usuario_lector (Mínimo Privilegio)
-- Se otorga lectura en Venta y ejecución sobre el SP de VentaCompleta
GRANT SELECT ON VENTA TO usuario_lector;
GRANT EXECUTE ON dbo.sp_RegistrarVentaCompleta TO usuario_lector;
DENY INSERT ON VENTA TO usuario_lector; -- Bloqueo explícito
GO

-- 4. Rol personalizado y asignación
CREATE ROLE rol_consulta_productos;
GRANT SELECT ON PRODUCTO TO rol_consulta_productos;
ALTER ROLE rol_consulta_productos ADD MEMBER usuario_consulta;
GO