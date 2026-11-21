# Flujos de Orquestación (n8n v2.25.7)

Esta carpeta contiene los flujos exportados desde el motor de orquestación `targo-n8n`:
- **`targo_main_workflow.json`**: Flujo principal orquestador de estados conversacionales, registro de usuarios, negociación de tarifas y asignación de fletes.
- **`subflows/`**: Subflujos modulares reutilizables (validación multimodal de comprobantes con Claude API, envío de plantillas vía Chatwoot API, etc.).
