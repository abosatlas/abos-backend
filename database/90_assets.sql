BEGIN;

-- ==========================================================
-- ASSETS MODULE
-- ==========================================================

CREATE TABLE IF NOT EXISTS assets (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id),

    asset_code VARCHAR(50) NOT NULL,

    asset_name VARCHAR(255) NOT NULL,

    category VARCHAR(100),

    purchase_date DATE,

    purchase_cost NUMERIC(18,2),

    current_value NUMERIC(18,2),

    depreciation_rate NUMERIC(8,2),

    location VARCHAR(255),

    assigned_to UUID REFERENCES users(id),

    status status_type DEFAULT 'active',

    notes TEXT,

    created_at TIMESTAMP DEFAULT NOW(),

    updated_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(company_id,asset_code)

);

SELECT create_updated_at_trigger('assets');

CREATE INDEX idx_assets_company
ON assets(company_id);

CREATE INDEX idx_assets_user
ON assets(assigned_to);

-- ==========================================================

CREATE TABLE IF NOT EXISTS asset_maintenance (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    asset_id UUID NOT NULL REFERENCES assets(id) ON DELETE CASCADE,

    maintenance_date DATE NOT NULL,

    maintenance_type VARCHAR(100),

    vendor VARCHAR(255),

    cost NUMERIC(18,2) DEFAULT 0,

    notes TEXT,

    created_at TIMESTAMP DEFAULT NOW()

);

CREATE INDEX idx_asset_maintenance_asset
ON asset_maintenance(asset_id);

COMMIT;
