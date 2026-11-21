-- ============================================================================
-- TARGO — Control de Concurrencia Atómica para Asignación de Fletes
-- Motor: PostgreSQL 16 (Base de datos: n8n_sistema_db)
-- Propósito: Evitar condiciones de carrera (race conditions) cuando múltiples
--            conductores o productores aceptan simultáneamente una oferta.
-- ============================================================================

BEGIN;

-- 1. Bloqueo explícito a nivel de fila sin bloquear el resto de la tabla.
--    FOR UPDATE OF o, s SKIP LOCKED garantiza que si dos transacciones
--    intentan procesar el mismo registro al mismo tiempo, la segunda lo omita
--    de inmediato en lugar de generar doble asignación o interbloqueo.
WITH oferta_disponible AS (
    SELECT 
        o.id AS oferta_id,
        o.solicitud_id,
        o.conductor_id,
        o.precio_propuesto
    FROM targo.ofertas o
    INNER JOIN targo.solicitudes_carga s ON s.id = o.solicitud_id
    WHERE o.id = $1                     -- ID de la oferta aceptada
      AND o.estado = 'pendiente'
      AND s.estado = 'abierta'
    FOR UPDATE OF o, s SKIP LOCKED
)
-- 2. Marcar la oferta seleccionada como aceptada
UPDATE targo.ofertas
SET estado = 'aceptada'
FROM oferta_disponible
WHERE targo.ofertas.id = oferta_disponible.oferta_id
RETURNING 
    oferta_disponible.oferta_id,
    oferta_disponible.solicitud_id,
    oferta_disponible.conductor_id,
    oferta_disponible.precio_propuesto;

-- 3. Actualizar la solicitud de carga a estado 'asignada'
UPDATE targo.solicitudes_carga
SET estado = 'asignada'
WHERE id = (
    SELECT solicitud_id 
    FROM targo.ofertas 
    WHERE id = $1 AND estado = 'aceptada'
);

-- 4. Rechazar automáticamente cualquier otra oferta pendiente sobre la misma solicitud
UPDATE targo.ofertas
SET estado = 'rechazada'
WHERE solicitud_id = (
    SELECT solicitud_id 
    FROM targo.ofertas 
    WHERE id = $1 AND estado = 'aceptada'
)
  AND id <> $1
  AND estado = 'pendiente';

COMMIT;
