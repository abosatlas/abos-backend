BEGIN;

-- ==========================================================
-- PURCHASING MODULE
-- ==========================================================

-- ==========================================================
-- Suppliers
-- ==========================================================

CREATE TABLE IF NOT EXISTS suppliers (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    supplier_type supplier_type NOT NULL DEFAULT 'company',

    code VARCHAR(50) NOT NULL,

    name VARCHAR(255) NOT NULL,

    email VARCHAR(255),

    phone VARCHAR(50),

    mobile VARCHAR(50),

    tax_number VARCHAR(100),

    address TEXT,

    city VARCHAR(100),

    country VARCHAR(100),

    payment_terms INTEGER DEFAULT 0,

    credit_limit NUMERIC(18,2) DEFAULT 0,

    notes TEXT,

    status status_type NOT NULL DEFAULT 'active',

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),

    UNIQUE(company_id,code)

);

SELECT create_updated_at_trigger('suppliers');

CREATE INDEX idx_suppliers_company
ON suppliers(company_id);

CREATE INDEX idx_suppliers_name
ON suppliers(name);

CREATE INDEX idx_suppliers_status
ON suppliers(status);

-- ==========================================================
-- Purchase Orders
-- ==========================================================

CREATE TABLE IF NOT EXISTS purchase_orders (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id),

    supplier_id UUID NOT NULL REFERENCES suppliers(id),

    order_number VARCHAR(100) NOT NULL,

    order_date DATE NOT NULL,

    expected_date DATE,

    subtotal NUMERIC(18,2) DEFAULT 0,

    tax_amount NUMERIC(18,2) DEFAULT 0,

    discount_amount NUMERIC(18,2) DEFAULT 0,

    total_amount NUMERIC(18,2) DEFAULT 0,

    notes TEXT,

    status status_type NOT NULL DEFAULT 'active',

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),

    UNIQUE(company_id,order_number)

);

SELECT create_updated_at_trigger('purchase_orders');

CREATE INDEX idx_purchase_orders_supplier
ON purchase_orders(supplier_id);

CREATE INDEX idx_purchase_orders_company
ON purchase_orders(company_id);

-- ==========================================================
-- Purchase Order Items
-- ==========================================================

CREATE TABLE IF NOT EXISTS purchase_order_items (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    purchase_order_id UUID NOT NULL REFERENCES purchase_orders(id) ON DELETE CASCADE,

    product_id UUID NOT NULL REFERENCES products(id),

    quantity NUMERIC(18,2) NOT NULL,

    unit_cost NUMERIC(18,2) NOT NULL,

    discount NUMERIC(18,2) DEFAULT 0,

    tax NUMERIC(18,2) DEFAULT 0,

    total NUMERIC(18,2) NOT NULL

);

CREATE INDEX idx_purchase_order_items_order
ON purchase_order_items(purchase_order_id);

-- ==========================================================
-- Goods Receipts
-- ==========================================================

CREATE TABLE IF NOT EXISTS goods_receipts (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id),

    purchase_order_id UUID REFERENCES purchase_orders(id),

    warehouse_id UUID NOT NULL REFERENCES warehouses(id),

    receipt_number VARCHAR(100) NOT NULL,

    receipt_date DATE NOT NULL,

    notes TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    UNIQUE(company_id,receipt_number)

);

CREATE INDEX idx_goods_receipts_order
ON goods_receipts(purchase_order_id);

CREATE INDEX idx_goods_receipts_warehouse
ON goods_receipts(warehouse_id);

-- ==========================================================
-- Goods Receipt Items
-- ==========================================================

CREATE TABLE IF NOT EXISTS goods_receipt_items (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    goods_receipt_id UUID NOT NULL REFERENCES goods_receipts(id) ON DELETE CASCADE,

    product_id UUID NOT NULL REFERENCES products(id),

    quantity NUMERIC(18,2) NOT NULL,

    unit_cost NUMERIC(18,2) NOT NULL

);

CREATE INDEX idx_goods_receipt_items_receipt
ON goods_receipt_items(goods_receipt_id);

-- ==========================================================
-- Purchase Bills
-- ==========================================================

CREATE TABLE IF NOT EXISTS purchase_bills (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id),

    supplier_id UUID NOT NULL REFERENCES suppliers(id),

    goods_receipt_id UUID REFERENCES goods_receipts(id),

    bill_number VARCHAR(100) NOT NULL,

    bill_date DATE NOT NULL,

    due_date DATE,

    subtotal NUMERIC(18,2) DEFAULT 0,

    tax_amount NUMERIC(18,2) DEFAULT 0,

    discount_amount NUMERIC(18,2) DEFAULT 0,

    total_amount NUMERIC(18,2) DEFAULT 0,

    paid_amount NUMERIC(18,2) DEFAULT 0,

    payment_status payment_status DEFAULT 'pending',

    notes TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),

    UNIQUE(company_id,bill_number)

);

SELECT create_updated_at_trigger('purchase_bills');

CREATE INDEX idx_purchase_bills_supplier
ON purchase_bills(supplier_id);

CREATE INDEX idx_purchase_bills_status
ON purchase_bills(payment_status);

COMMIT;
