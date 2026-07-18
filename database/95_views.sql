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
CREATE OR REPLACE VIEW customer_balances AS

SELECT

c.id,

c.company_id,

c.name,

COALESCE(SUM(i.total_amount),0) invoices,

COALESCE(SUM(i.paid_amount),0) paid,

COALESCE(SUM(i.total_amount-i.paid_amount),0) balance

FROM customers c

LEFT JOIN invoices i

ON c.id=i.customer_id

GROUP BY

c.id,

c.company_id,

c.name;

CREATE OR REPLACE VIEW supplier_balances AS

SELECT

s.id,

s.company_id,

s.name,

COALESCE(SUM(b.total_amount),0) bills,

COALESCE(SUM(b.paid_amount),0) paid,

COALESCE(SUM(b.total_amount-b.paid_amount),0) balance

FROM suppliers s

LEFT JOIN purchase_bills b

ON s.id=b.supplier_id

GROUP BY

s.id,

s.company_id,

s.name;
