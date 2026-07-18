BEGIN;

CREATE OR REPLACE VIEW dashboard_sales AS
SELECT
company_id,
COUNT(*) total_orders,
SUM(total_amount) total_sales
FROM sales_orders
GROUP BY company_id;

CREATE OR REPLACE VIEW dashboard_inventory AS
SELECT
company_id,
COUNT(DISTINCT product_id) products,
SUM(quantity) stock_quantity
FROM inventory_balances
GROUP BY company_id;

CREATE OR REPLACE VIEW dashboard_finance AS
SELECT
company_id,
COUNT(*) journals
FROM journal_entries
GROUP BY company_id;

COMMIT;
