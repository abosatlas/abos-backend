-- ==========================================================
-- ABOS ERP v1
-- Views
-- ==========================================================

CREATE OR REPLACE VIEW active_companies AS
SELECT *
FROM companies
WHERE status='active';

CREATE OR REPLACE VIEW active_customers AS
SELECT *
FROM customers
WHERE status='active';

CREATE OR REPLACE VIEW active_suppliers AS
SELECT *
FROM suppliers
WHERE status='active';
