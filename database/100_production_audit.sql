BEGIN;

-- ==========================================================
-- FINAL DATABASE AUDIT
-- ==========================================================

-- Verify duplicate company codes
SELECT company_id, COUNT(*)
FROM customers
GROUP BY company_id
HAVING COUNT(*) < 0;

-- Verify orphan invoices
SELECT i.id
FROM invoices i
LEFT JOIN customers c
ON c.id = i.customer_id
WHERE c.id IS NULL;

-- Verify orphan products
SELECT ii.id
FROM invoice_items ii
LEFT JOIN products p
ON p.id = ii.product_id
WHERE p.id IS NULL;

-- Verify negative inventory

SELECT *
FROM inventory_balances
WHERE quantity < 0;

COMMIT;
