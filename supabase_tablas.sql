-- ══════════════════════════════════════════════════════════════
--  Partes GlobalFeed — SQL para Supabase
--
--  INSTRUCCIONES:
--  1. Ve a tu proyecto en supabase.com
--  2. Menú izquierdo → SQL Editor → New query
--  3. Pega TODO este código y haz clic en "Run"
--  ✓ Si las tablas ya existen, este script las actualiza sin borrar datos
-- ══════════════════════════════════════════════════════════════

-- ── Tabla: subcontratas ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS subcontratas (
  id         TEXT PRIMARY KEY,
  nombre     TEXT NOT NULL,
  cif        TEXT DEFAULT '',
  contacto   TEXT DEFAULT '',
  email      TEXT DEFAULT '',
  tarifas    TEXT DEFAULT '[]',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Tabla: responsables ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS responsables (
  id           TEXT PRIMARY KEY,
  nombre       TEXT NOT NULL,
  puesto       TEXT DEFAULT '',
  email        TEXT DEFAULT '',
  telefono     TEXT DEFAULT '',
  departamento TEXT DEFAULT '',
  numero       TEXT DEFAULT '',
  notas        TEXT DEFAULT '',
  pin          TEXT DEFAULT '',
  firma        TEXT DEFAULT '',
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- ── Tabla: partes ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS partes (
  id                 TEXT PRIMARY KEY,
  fecha              TEXT DEFAULT '',
  subcontrata_id     TEXT DEFAULT '',
  subcontrata_nombre TEXT DEFAULT '',
  trabajador         TEXT DEFAULT '',
  area               TEXT DEFAULT '',
  jornadas           TEXT DEFAULT '[]',
  h_normal           NUMERIC DEFAULT 0,
  h_extra            NUMERIC DEFAULT 0,
  h_noct             NUMERIC DEFAULT 0,
  lineas_coste       TEXT DEFAULT '[]',
  trabajos           TEXT DEFAULT '',
  materiales         TEXT DEFAULT '',
  permiso            TEXT DEFAULT '',
  naturaleza         TEXT DEFAULT '',
  recurso            TEXT DEFAULT '',
  expediente         TEXT DEFAULT '',
  otros              TEXT DEFAULT '',
  centro_coste       TEXT DEFAULT '',
  seccion            TEXT DEFAULT '',
  responsable        TEXT DEFAULT '',
  responsable_id     TEXT DEFAULT '',
  responsable_puesto TEXT DEFAULT '',
  responsable_email  TEXT DEFAULT '',
  coste              NUMERIC DEFAULT 0,
  estado             TEXT DEFAULT 'Validado',
  timestamp          TEXT DEFAULT '',
  fechas             TEXT DEFAULT '[]',
  created_at         TIMESTAMPTZ DEFAULT NOW()
);

-- ── Si las tablas ya existen, añade columnas nuevas sin borrar datos ─
ALTER TABLE responsables ADD COLUMN IF NOT EXISTS pin   TEXT DEFAULT '';
ALTER TABLE responsables ADD COLUMN IF NOT EXISTS firma TEXT DEFAULT '';
ALTER TABLE partes       ADD COLUMN IF NOT EXISTS fechas TEXT DEFAULT '[]';

-- ── Seguridad: acceso total para la app (anon) ───────────────
ALTER TABLE subcontratas ENABLE ROW LEVEL SECURITY;
ALTER TABLE responsables  ENABLE ROW LEVEL SECURITY;
ALTER TABLE partes        ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "acceso_total_subcontratas" ON subcontratas;
DROP POLICY IF EXISTS "acceso_total_responsables"  ON responsables;
DROP POLICY IF EXISTS "acceso_total_partes"        ON partes;

CREATE POLICY "acceso_total_subcontratas" ON subcontratas
  FOR ALL TO anon USING (true) WITH CHECK (true);

CREATE POLICY "acceso_total_responsables" ON responsables
  FOR ALL TO anon USING (true) WITH CHECK (true);

CREATE POLICY "acceso_total_partes" ON partes
  FOR ALL TO anon USING (true) WITH CHECK (true);

-- ── Verificar resultado ──────────────────────────────────────
SELECT 'subcontratas' AS tabla, COUNT(*) AS registros FROM subcontratas
UNION ALL SELECT 'responsables', COUNT(*) FROM responsables
UNION ALL SELECT 'partes',       COUNT(*) FROM partes;

-- ── Columnas nuevas (ejecutar si la tabla ya existe) ─────────
ALTER TABLE partes ADD COLUMN IF NOT EXISTS numero_albaran TEXT DEFAULT '';
ALTER TABLE partes ADD COLUMN IF NOT EXISTS oferta         TEXT DEFAULT '';
ALTER TABLE partes ADD COLUMN IF NOT EXISTS concepto_alb   TEXT DEFAULT '';
ALTER TABLE partes ADD COLUMN IF NOT EXISTS documento_url  TEXT DEFAULT '';

-- ── Bucket de almacenamiento para documentos ─────────────────
-- Ejecuta esto en Supabase → Storage → New bucket
-- Nombre: documentos
-- Public bucket: SÍ (marcar como público)
-- O ejecuta este SQL:
INSERT INTO storage.buckets (id, name, public)
VALUES ('documentos', 'documentos', true)
ON CONFLICT (id) DO NOTHING;

-- Política de acceso para el bucket
CREATE POLICY "acceso_publico_documentos" ON storage.objects
  FOR ALL TO anon USING (bucket_id = 'documentos') WITH CHECK (bucket_id = 'documentos');
