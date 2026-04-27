-- ══════════════════════════════════════════════════════════════
--  Partes GlobalFeed — SQL para Supabase
--
--  INSTRUCCIONES:
--  1. Ve a tu proyecto en supabase.com
--  2. Menú izquierdo → SQL Editor → New query
--  3. Pega TODO este código y haz clic en "Run"
--  4. Se crearán las 3 tablas automáticamente
-- ══════════════════════════════════════════════════════════════

-- ── Tabla: subcontratas ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS subcontratas (
  id          TEXT PRIMARY KEY,
  nombre      TEXT NOT NULL,
  cif         TEXT DEFAULT '',
  contacto    TEXT DEFAULT '',
  email       TEXT DEFAULT '',
  tarifas     TEXT DEFAULT '[]',
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── Tabla: responsables ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS responsables (
  id            TEXT PRIMARY KEY,
  nombre        TEXT NOT NULL,
  puesto        TEXT DEFAULT '',
  email         TEXT DEFAULT '',
  telefono      TEXT DEFAULT '',
  departamento  TEXT DEFAULT '',
  numero        TEXT DEFAULT '',
  notas         TEXT DEFAULT '',
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── Tabla: partes ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS partes (
  id                   TEXT PRIMARY KEY,
  fecha                TEXT DEFAULT '',
  subcontrata_id       TEXT DEFAULT '',
  subcontrata_nombre   TEXT DEFAULT '',
  trabajador           TEXT DEFAULT '',
  area                 TEXT DEFAULT '',
  jornadas             TEXT DEFAULT '[]',
  h_normal             NUMERIC DEFAULT 0,
  h_extra              NUMERIC DEFAULT 0,
  h_noct               NUMERIC DEFAULT 0,
  lineas_coste         TEXT DEFAULT '[]',
  trabajos             TEXT DEFAULT '',
  materiales           TEXT DEFAULT '',
  permiso              TEXT DEFAULT '',
  naturaleza           TEXT DEFAULT '',
  recurso              TEXT DEFAULT '',
  expediente           TEXT DEFAULT '',
  otros                TEXT DEFAULT '',
  centro_coste         TEXT DEFAULT '',
  seccion              TEXT DEFAULT '',
  responsable          TEXT DEFAULT '',
  responsable_id       TEXT DEFAULT '',
  responsable_puesto   TEXT DEFAULT '',
  responsable_email    TEXT DEFAULT '',
  coste                NUMERIC DEFAULT 0,
  estado               TEXT DEFAULT 'Validado',
  timestamp            TEXT DEFAULT '',
  fechas               TEXT DEFAULT '[]',
  created_at           TIMESTAMPTZ DEFAULT NOW()
);

-- ── Seguridad: permitir acceso a todos (anon) ────────────────
ALTER TABLE subcontratas  ENABLE ROW LEVEL SECURITY;
ALTER TABLE responsables  ENABLE ROW LEVEL SECURITY;
ALTER TABLE partes        ENABLE ROW LEVEL SECURITY;

-- Subcontratas: lectura y escritura para todos
CREATE POLICY "acceso_total_subcontratas" ON subcontratas
  FOR ALL TO anon USING (true) WITH CHECK (true);

-- Responsables: lectura y escritura para todos
CREATE POLICY "acceso_total_responsables" ON responsables
  FOR ALL TO anon USING (true) WITH CHECK (true);

-- Partes: lectura y escritura para todos
CREATE POLICY "acceso_total_partes" ON partes
  FOR ALL TO anon USING (true) WITH CHECK (true);

-- ── Verificar que todo está creado ──────────────────────────
SELECT 'subcontratas' AS tabla, COUNT(*) AS registros FROM subcontratas
UNION ALL
SELECT 'responsables', COUNT(*) FROM responsables
UNION ALL
SELECT 'partes', COUNT(*) FROM partes;

-- Si ves 3 filas con el resultado anterior, ¡todo OK!
