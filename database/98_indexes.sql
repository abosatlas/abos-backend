BEGIN;

-- ==========================================================
-- PERFORMANCE INDEXES
-- ==========================================================

CREATE INDEX IF NOT EXISTS idx_customers_company_status
ON customers(company_id, status);

CREATE INDEX IF NOT EXISTS idx_products_company_status
ON products(company_id, status);

CREATE INDEX IF NOT EXISTS idx_sales_orders_customer
ON sales_orders(customer_id);

CREATE INDEX IF NOT EXISTS idx_sales_orders_company_date
ON sales_orders(company_id, order_date);

CREATE INDEX IF NOT EXISTS idx_invoices_customer
ON invoices(customer_id);

CREATE INDEX IF NOT EXISTS idx_invoices_status
ON invoices(invoice_status);

CREATE INDEX IF NOT EXISTS idx_inventory_product_date
ON inventory_transactions(product_id, transaction_date);

CREATE INDEX IF NOT EXISTS idx_inventory_company_product
ON inventory_transactions(company_id, product_id);

CREATE INDEX IF NOT EXISTS idx_purchase_supplier
ON purchase_orders(supplier_id);

CREATE INDEX IF NOT EXISTS idx_projects_status
ON projects(status);

CREATE INDEX IF NOT EXISTS idx_assets_status
ON assets(status);

COMMIT;
