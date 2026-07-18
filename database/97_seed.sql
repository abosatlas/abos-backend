-- ==========================================================
-- Seed Data
-- ==========================================================

INSERT INTO companies
(
id,
name,
status,
created_at,
updated_at
)
VALUES
(
gen_random_uuid(),
'Demo Company',
'active',
NOW(),
NOW()
)
ON CONFLICT DO NOTHING;
