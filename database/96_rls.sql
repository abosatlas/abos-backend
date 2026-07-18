-- ==========================================================
-- ABOS ERP v1
-- Row Level Security
-- ==========================================================

ALTER TABLE companies ENABLE ROW LEVEL SECURITY;

CREATE POLICY company_policy
ON companies
FOR ALL
USING (
id=current_company()
);
