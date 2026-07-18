BEGIN;

-- ==========================================================
-- INVENTORY MODULE
-- ==========================================================

-- ==========================================================
-- Warehouses
-- ==========================================================

CREATE TABLE IF NOT EXISTS warehouses (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    code VARCHAR(50) NOT NULL,

    name VARCHAR(255) NOT NULL,

    address TEXT,

    manager_name VARCHAR(255),

    phone VARCHAR(50),

    status status_type NOT NULL DEFAULT 'active',

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),

    UNIQUE(company_id,code)

);

SELECT create_updated_at_trigger('warehouses');

CREATE INDEX idx_warehouses_company
ON warehouses(company_id);

CREATE INDEX idx_warehouses_status
ON warehouses(status);

-- ==========================================================
-- Warehouse Locations
-- ==========================================================

CREATE TABLE IF NOT EXISTS warehouse_locations (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    warehouse_id UUID NOT NULL REFERENCES warehouses(id) ON DELETE CASCADE,

    code VARCHAR(50) NOT NULL,

    name VARCHAR(255) NOT NULL,

    description TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    UNIQUE(warehouse_id,code)

);

CREATE INDEX idx_locations_warehouse
ON warehouse_locations(warehouse_id);

-- ==========================================================
-- Inventory Transactions
-- ==========================================================

CREATE TABLE IF NOT EXISTS inventory_transactions (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    warehouse_id UUID NOT NULL REFERENCES warehouses(id),

    location_id UUID REFERENCES warehouse_locations(id),

    product_id UUID NOT NULL REFERENCES products(id),

    transaction_type inventory_transaction_type NOT NULL,

    reference_type VARCHAR(50),

    reference_id UUID,

    quantity NUMERIC(18,2) NOT NULL,

    unit_cost NUMERIC(18,2) DEFAULT 0,

    total_cost NUMERIC(18,2) GENERATED ALWAYS AS (quantity * unit_cost) STORED,

    transaction_date TIMESTAMP NOT NULL DEFAULT NOW(),

    notes TEXT,

    created_by UUID REFERENCES users(id),

    created_at TIMESTAMP NOT NULL DEFAULT NOW()

);

CREATE INDEX idx_inventory_company
ON inventory_transactions(company_id);

CREATE INDEX idx_inventory_product
ON inventory_transactions(product_id);

CREATE INDEX idx_inventory_warehouse
ON inventory_transactions(warehouse_id);

CREATE INDEX idx_inventory_date
ON inventory_transactions(transaction_date);

-- ==========================================================
-- Stock Transfers
-- ==========================================================

CREATE TABLE IF NOT EXISTS stock_transfers (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id),

    transfer_number VARCHAR(100) NOT NULL,

    from_warehouse_id UUID NOT NULL REFERENCES warehouses(id),

    to_warehouse_id UUID NOT NULL REFERENCES warehouses(id),

    transfer_date DATE NOT NULL,

    notes TEXT,

    status status_type DEFAULT 'active',

    created_at TIMESTAMP DEFAULT NOW(),

    updated_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(company_id,transfer_number)

);

SELECT create_updated_at_trigger('stock_transfers');

CREATE INDEX idx_stock_transfers_company
ON stock_transfers(company_id);

-- ==========================================================
-- Stock Transfer Items
-- ==========================================================

CREATE TABLE IF NOT EXISTS stock_transfer_items (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    stock_transfer_id UUID NOT NULL REFERENCES stock_transfers(id) ON DELETE CASCADE,

    product_id UUID NOT NULL REFERENCES products(id),

    quantity NUMERIC(18,2) NOT NULL

);

CREATE INDEX idx_stock_transfer_items_transfer
ON stock_transfer_items(stock_transfer_id);

-- ==========================================================
-- Inventory Balances (View)
-- ==========================================================

CREATE OR REPLACE VIEW inventory_balances AS

SELECT

    company_id,

    warehouse_id,

    product_id,

    SUM(

        CASE

            WHEN transaction_type IN ('purchase','adjustment_in','transfer_in','opening')

                THEN quantity

            WHEN transaction_type IN ('sale','adjustment_out','transfer_out')

                THEN -quantity

            ELSE 0

        END

    ) AS quantity

FROM inventory_transactions

GROUP BY

company_id,

warehouse_id,

product_id;

COMMIT;
