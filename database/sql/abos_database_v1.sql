-- ============================================================
-- ABOS Database v1.0
-- Atlas Business Operating System
-- Database: PostgreSQL (Supabase)
-- Version: 1.0
-- ============================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ============================================================
-- Update Timestamp Function
-- ============================================================

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- ============================================================
-- Companies
-- ============================================================

CREATE TABLE companies (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name VARCHAR(200) NOT NULL,

    legal_name VARCHAR(255),

    commercial_registration VARCHAR(100),

    tax_number VARCHAR(100),

    email VARCHAR(200),

    phone VARCHAR(50),

    mobile VARCHAR(50),

    website VARCHAR(255),

    country VARCHAR(100),

    city VARCHAR(100),

    address TEXT,

    logo_url TEXT,

    currency VARCHAR(10) DEFAULT 'EGP',

    timezone VARCHAR(50) DEFAULT 'Africa/Cairo',

    language VARCHAR(10) DEFAULT 'ar',

    is_active BOOLEAN DEFAULT TRUE,

    is_deleted BOOLEAN DEFAULT FALSE,

    created_at TIMESTAMPTZ DEFAULT NOW(),

    updated_at TIMESTAMPTZ DEFAULT NOW()

);

CREATE INDEX idx_companies_name
ON companies(name);

CREATE INDEX idx_companies_active
ON companies(is_active);

CREATE TRIGGER trg_companies_updated_at

BEFORE UPDATE
ON companies

FOR EACH ROW

EXECUTE FUNCTION update_updated_at();
