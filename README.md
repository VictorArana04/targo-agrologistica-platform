# 🚜 TARGO — Plataforma Conversacional de Intermediación Logística Agropecuaria

**TARGO** es una solución tecnológica desarrollada para automatizar la intermediación logística, la negociación dinámica de tarifas y la trazabilidad operativa entre pequeños y medianos productores agropecuarios y transportadores de carga en el Valle del Cauca, Colombia[cite: 1]. 

La plataforma opera 100% sobre **WhatsApp** sin requerir la instalación de aplicaciones móviles adicionales[cite: 1], integrando un motor de orquestación basado en eventos, control de concurrencia transaccional en base de datos, validación multimodal de comprobantes de pago mediante Inteligencia Artificial y un CRM conversacional híbrido (bot + atención humana)[cite: 1].

---

## 👥 Equipo de Desarrollo e Investigación
* **Programa:** Ingeniería de Sistemas — Escuela de Ciencias Básicas, Tecnología e Ingeniería (ECBTI)[cite: 1]
* **Institución:** Universidad Nacional Abierta y a Distancia (UNAD) — CEAD Palmira[cite: 1]
* **Curso:** Proyecto de Grado (`202016907` — Grupo `52`)[cite: 1]
* **Integrantes:**
  * Víctor Manuel Jiménez Arana *(Investigador Principal)*[cite: 1]
  * Carlos Arturo Villada Serna *(Coinvestigador)*[cite: 1]
  * Jhonatan Estiben González Cifuentes *(Coinvestigador)*[cite: 1]
  * Andrés Felipe Llamosa Pechené *(Coinvestigador)*[cite: 1]
* **Tutor:** Daniel Andrés Guzmán[cite: 1]

---

## 🏗️ Arquitectura Tecnológica en Producción

El sistema se encuentra desplegado en una instancia VPS de **Oracle Cloud Infrastructure (OCI)** con sistema operativo **Ubuntu 24.04.4 LTS** sobre arquitectura **ARM64 (`aarch64`)**[cite: 1].

### Topología de Servicios
1. **Reverse Proxy (`targo-proxy` — Caddy):** Única puerta de entrada expuesta a internet (puertos `80` y `443`)[cite: 1]. Gestiona certificados SSL/TLS automáticos con Let's Encrypt y enruta el tráfico hacia subdominios de DuckDNS[cite: 1]:
   * `targopruebas.duckdns.org` $\rightarrow$ Motor de orquestación n8n.
   * `targochat.duckdns.org` $\rightarrow$ CRM Conversacional Chatwoot.
2. **Motor de Orquestación (`targo-n8n` — n8n v2.25.7):** Contenedor Docker ejecutándose en el puerto interno `5678` (aislado de acceso directo externo)[cite: 1]. Orquesta el flujo conversacional principal (~254 nodos) y sub-workflows modulares mediante máquinas de estado persistidas.
3. **Base de Datos Relacional (`targo-postgres` — PostgreSQL 16 + `pgvector`):** Contenedor Docker en red interna (`5432`)[cite: 1]. Almacena la base de datos `n8n_sistema_db` dividida en:
   * **Esquema `targo` (11 tablas de negocio):** `productores`, `solicitudes_carga`, `ofertas`, `matches`, `pagos`, `pagos_comprobantes`, `calificaciones`, `conversaciones_estado`, `configuracion`, `numeros_bloqueados` y `rate_limit`.
   * **Esquema `public`:** Tabla `conductores` (en proceso de unificación hacia `targo`) y tablas operativas internas de n8n y Chatwoot.
   * **Control de Concurrencia Atómica:** Implementación de bloqueos explícitos a nivel de fila (`SELECT ... FOR UPDATE SKIP LOCKED`) para eliminar condiciones de carrera y evitar la doble asignación de un mismo flete[cite: 1].
4. **CRM Conversacional Híbrido (Chatwoot Community Edition):** Desplegado de forma nativa sobre Ubuntu mediante `systemd` (`chatwoot-web.service` y `chatwoot-worker.service`) para optimizar el rendimiento en arquitectura ARM64. Permite la transición fluida entre atención automatizada y agentes humanos sin colisión de estados[cite: 1].
5. **Integraciones Externas:**
   * **WhatsApp Business Cloud API (Meta):** Canal oficial de mensajería y envío de plantillas aprobadas vía API de Chatwoot[cite: 1].
   * **Claude API (Anthropic):** Procesamiento de IA multimodal para extracción de datos y validación automática de imágenes de comprobantes bancarios[cite: 1].

> **Nota sobre despliegue:** En el entorno productivo ARM64, los contenedores operan en directorios independientes bajo `/opt/` comunicados por red interna de Docker, mientras que Chatwoot corre nativamente en `systemd`. En la carpeta `/docker` de este repositorio se incluye un `docker-compose.yml` unificado de referencia para facilitar la replicación del núcleo contenerizado.

---

## 📂 Estructura del Repositorio

```text
targo-agrologistica-platform/
├── README.md                     # Documentación principal del proyecto
├── .gitignore                    # Exclusión de credenciales, certificados y temporales
├── docker/                       # Infraestructura as Code (IaC) de referencia
│   ├── docker-compose.yml        # Orquestación de targo-proxy, targo-n8n y targo-postgres
│   ├── Caddyfile                 # Configuración de proxy inverso y TLS automático
│   └── .env.example              # Plantilla de variables de entorno (sin secretos)
├── database/                     # Esquema relacional y control de concurrencia
│   ├── 01_schema_targo.sql       # DDL de tablas de negocio (esquema targo y conductores)
│   └── 02_concurrency_lock.sql   # Transacción ACID con FOR UPDATE SKIP LOCKED
├── n8n-workflows/                # Flujos exportados desde n8n v2.25.7
│   ├── targo_main_workflow.json  # Flujo orquestador principal
│   └── subflows/                 # Subflujos modulares (validación IA, notificaciones, etc.)
└── docs-evidencias/              # Evidencias técnicas del despliegue y pruebas (TRL 5 / TRL 7)
    └── capturas-vps/             # Capturas de docker ps, systemd, n8n, Chatwoot y WhatsApp
