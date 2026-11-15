# Investigación: Seguridad, Roles y Permisos

1. Objetivo

El objetivo de esta implementación es garantizar que el acceso y la modificación de los datos en el sistema de gestión de la lencería Sueño Contigo se realicen de forma segura, controlada y estrictamente autorizada.

Para ello, se utiliza un esquema de seguridad basado en la gestión de cuentas (logins y usuarios) y la asignación de permisos específicos mediante roles, evitando accesos indebidos a la base de datos.

2. Principio de Mínimo Privilegio

El Principio de Mínimo Privilegio (PoLP) es un concepto fundamental en la seguridad de la información. Establece que cada usuario o proceso debe tener únicamente los permisos estrictamente necesarios para cumplir con sus funciones diarias, y ningún privilegio adicional.

En nuestro sistema, la aplicación de este principio implica:
- Bloquear el acceso directo a la escritura, modificación o eliminación de datos en tablas críticas.
- Otorgar permisos de lectura (SELECT) solo sobre las tablas que el usuario necesita visualizar para su trabajo.
- Habilitar la ejecución (EXECUTE) de procedimientos almacenados específicos en lugar de dar control total sobre las tablas.

De esta manera, se evita que un usuario con perfil de lectura pueda alterar información financiera o eliminar registros por accidente o mala intención.

3. Roles y Encapsulamiento

La seguridad y consistencia en el acceso se favorecen mediante el uso de roles y el encapsulamiento de la lógica de negocio:

- Administración por roles: en lugar de asignar permisos usuario por usuario, se crean perfiles (roles) con un conjunto de permisos definidos. Los usuarios simplemente se agregan a estos roles, facilitando la escalabilidad del sistema.
- Encapsulamiento: al denegar las sentencias INSERT, UPDATE y DELETE directas sobre las tablas, se obliga a los usuarios a interactuar a través de Procedimientos Almacenados. Esto garantiza que cualquier modificación de datos pase primero por las reglas y validaciones de negocio programadas en dichos procedimientos.

4. Implementación en SQL Server

Para implementar la seguridad y los controles de acceso se utilizan las siguientes instrucciones del lenguaje de control de datos (DCL):

- CREATE LOGIN: crea una credencial de acceso a nivel del servidor de base de datos.
- CREATE USER: asocia un login del servidor con un usuario específico dentro de la base de datos local.
- GRANT: otorga un permiso específico (ej. SELECT o EXECUTE) a un usuario o rol.
- DENY: deniega explícitamente un permiso, sobrescribiendo cualquier otro acceso otorgado previamente.
- CREATE ROLE: crea un rol personalizado en la base de datos para agrupar permisos.
- ALTER ROLE ... ADD MEMBER: añade un usuario a un rol existente para que herede sus permisos.

5. Aplicación al sistema Sueño Contigo

La seguridad se aplica definiendo perfiles claros para el personal de la lencería. Primero, se configuró un `usuario_admin` asociado al rol superior `db_owner`. Luego, se diseñó un perfil restringido (`usuario_lector`) al cual se le aplicó un DENY explícito para impedirle hacer INSERT directamente en la tabla VENTA. 

Para que este usuario pueda registrar ventas sin tener acceso directo a la tabla, se le otorgó un GRANT EXECUTE exclusivamente sobre el procedimiento `dbo.sp_RegistrarVentaCompleta`. Adicionalmente, se creó un rol personalizado (`rol_consulta_productos`) con permisos solo de lectura sobre el catálogo, asociando allí a los usuarios correspondientes.

6. Conclusión

La implementación de roles y permisos permite que el control de acceso al sistema se maneje de forma centralizada y segura. El Principio de Mínimo Privilegio garantiza que los datos críticos no queden expuestos a modificaciones no autorizadas, mientras que el encapsulamiento protege la integridad de las tablas.

De esta forma, el sistema Sueño Contigo asegura que las transacciones y operaciones diarias sean ejecutadas únicamente por el personal autorizado y a través de los canales correctos, reduciendo drásticamente el riesgo de pérdida o corrupción de información.