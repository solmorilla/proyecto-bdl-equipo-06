<div align="center">

# 🌙 Sueño Contigo
### 🛒 Sistema de Gestión de Ventas e Inventario para Lencería

> **Universidad Nacional del Nordeste (UNNE)** <br>
> Cátedra: Base de Datos I — Proyecto Integrador 2026

<br>

![Materia](https://img.shields.io/badge/Materia-Base_de_Datos_I-002E5D?style=for-the-badge)
![Año](https://img.shields.io/badge/Ciclo-2026-D35400?style=for-the-badge)
![Grupo](https://img.shields.io/badge/Grupo-06-1E8449?style=for-the-badge)
![Fase](https://img.shields.io/badge/Fase_Actual-Etapa_IV-8E44AD?style=for-the-badge)

---

### 👥 Integrantes del Equipo
**Alias, Mauro Sebastian** &nbsp;&middot;&nbsp; **Benitez, Franco Nicolás** &nbsp;&middot;&nbsp; **Fernandez, Lucas Tomás** &nbsp;&middot;&nbsp; **Marder, Lorenzo** &nbsp;&middot;&nbsp; **Morilla, Sol Valentina**

<br>
</div>

---

## 📖 Contexto

**Sueño Contigo** es un emprendimiento dedicado a la comercialización minorista de indumentaria y prendas de descanso (pijamas, conjuntos y lencería). 

La empresa necesitaba dar un salto y reemplazar su registro informal de operaciones por un sistema centralizado basado en una base de datos relacional. El propósito principal de este proyecto es garantizar la consistencia en los niveles de stock, asegurar que los comprobantes mantengan la información de precios inalterable a lo largo del tiempo y llevar un control bien estructurado de los pedidos y sus cobros.

---

## 🎯 Alcance del sistema

**Dentro del alcance:**
- **Gestión de catálogo y stock:** Registro de productos con su talle, precio vigente y stock físico, clasificados en categorías específicas.
- **Gestión de clientes:** Directorio con datos personales y de contacto para emitir comprobantes y coordinar entregas.
- **Gestión de ventas y pedidos:** Creación de órdenes que asocian los productos adquiridos, totalizan el importe y congelan el precio pactado al momento de la compra.
- **Gestión de pagos:** Asociación de cada venta con un método de pago disponible y un estado logístico/comercial.

**Fuera del alcance (Delimitación explícita):**
- Integración con pasarelas de cobro externas o validaciones bancarias en tiempo real.
- Facturación electrónica automatizada con AFIP/ARCA.
- Seguimiento por GPS o ruteo logístico de los envíos.
- Gestión contable integral (balances, compras a proveedores).

---

## 📋 Reglas de negocio principales

El comportamiento de nuestra base de datos está regido por las siguientes reglas fundamentales establecidas en la Etapa 1:

- **RN.01 - Registro y Unicidad de Clientes:** Todo cliente debe tener un correo electrónico único. No pueden existir dos registros con el mismo email. Un cliente puede tener muchas ventas, pero cada venta es de un único cliente.
- **RN.02 - Control Automático de Stock:** Al registrarse una venta, el stock del producto se descuenta automáticamente. No se permite vender si el stock es cero o menor a la cantidad pedida.
- **RN.03 - Inmutabilidad de Precios:** El sistema guarda el precio unitario exacto al momento de la operación en el detalle de la venta, aislando ese registro histórico de cualquier cambio futuro en el catálogo de productos.
- **RN.04 - Métodos de Pago:** Cada venta debe tener obligatoriamente asociado un único método de pago habilitado en el sistema.
- **RN.05 - Totalización de la Venta:** Toda venta debe tener al menos un producto. El monto total se calcula sumando los subtotales de cada línea (precio histórico x cantidad).
- **RN.06 - Clasificación de Productos:** Todo producto pertenece a una, y solo una, categoría válida. No pueden existir productos sin categoría.
- **RN.07 - Estados del Pedido:** Las ventas solo pueden estar en estado: Pendiente, Abonado, Despachado o Cancelado. Si se cancela un pedido, el sistema reintegra el stock comprometido.

---

## 📚 Documentación y Etapas del Proyecto

El desarrollo del proyecto está documentado y dividido en etapas evolutivas:

- **Etapa 01 - Requerimientos y dominio del negocio:** Análisis del caso, delimitación del alcance y definición de las reglas de negocio base (`equipo06_etapa_1.pdf`).
- **Etapa 02 - Modelado conceptual y lógico:** Diseño del Diagrama Entidad-Relación (`DER.png`), aplicación de las reglas de normalización (1FN, 2FN, 3FN) y definición formal del modelo relacional (`modelo relacional.png` y `.md`).
- **Etapa 03 - Implementación física:** Construcción de la base de datos con scripts de creación y poblado. Incluye el detalle de las restricciones de integridad y las pruebas de validación aplicadas al motor de base de datos.
- **Etapa 04 - Consultas y Casos de Uso:** Desarrollo de sentencias SQL (DML) para resolver necesidades de información del negocio como facturación, reportes agregados, control de inventario y logística.

---

## 📂 Estructura del repositorio

```text
proyecto-bdl-equipo-06/
│
├── 📁 docs/                             
│   │
│   ├── 📁 etapa-01/
│   │   ├── 📄 .gitkeep
│   │   └── 📄 equipo06_etapa_1.pdf
│   │
│   ├── 📁 etapa-02/
│   │   ├── 📄 DER.png
│   │   ├── 📄 Primera Forma Normal (1FN)
│   │   ├── 📄 Segunda Forma Normal
│   │   ├── 📄 Tercera Forma Normal (3FN)
│   │   ├── 📄 modelo relacional.png
│   │   └── 📄 modelo-relacional.md
│   │
│   ├── 📁 etapa-03/
│   │   ├── 📄 .gitkeep
│   │   ├── 📄 pruebas-validacion.md
│   │   └── 📄 restricciones-integridad.md
│   │
│   ├── 📁 etapa-04/
│   └── 📁 etapa-05/
│
├── 📁 sql/                             
│   │
│   ├── 📁 consultas/
│   │   ├── 📄 .gitkeep
│   │   ├── 📄 etapa04_caso1_factura.sql
│   │   ├── 📄 etapa04_caso2_reporte_agregado.sql
│   │   ├── 📄 etapa04_caso3_negocio.sql
│   │   ├── 📄 etapa04_caso4_requisitoNegocio.sql
│   │   └── 📄 etapa04_caso5_gestionLogistica.sql
│   │
│   ├── 📁 ddl/
│   │   ├── 📄 .gitkeep
│   │   └── 📄 create_tables.sql
│   │
│   ├── 📁 dml/
│   │   ├── 📄 .gitkeep
│   │   └── 📄 datos_prueba.sql
│   │
│   └── 📁 tecnico/
│       └── 📄 .gitkeep
│
└── 📄 README.md