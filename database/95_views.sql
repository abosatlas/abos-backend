BEGIN;

CREATE OR REPLACE VIEW active_customers AS
SELECT *
FROM customers
WHERE status='active';

CREATE OR REPLACE VIEW active_suppliers AS
SELECT *
FROM suppliers
WHERE status='active';

CREATE OR REPLACE VIEW active_products AS
SELECT *
FROM products
WHERE status='active';

CREATE OR REPLACE VIEW inventory_stock AS

SELECT

company_id,

warehouse_id,

product_id,

SUM(

CASE

WHEN transaction_type IN
('opening','purchase','adjustment_in','transfer_in','production_in','return_in')

THEN quantity

ELSE -quantity

END

) quantity

FROM inventory_transactions

GROUP BY

company_id,

warehouse_id,

product_id;

COMMIT;
