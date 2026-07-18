BEGIN;

-- ==========================================================
-- FINANCE MODULE
-- ==========================================================

-- ==========================================================
-- Chart Of Accounts
-- ==========================================================

CREATE TABLE IF NOT EXISTS chart_of_accounts (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    parent_id UUID REFERENCES chart_of_accounts(id) ON DELETE SET NULL,

    account_code VARCHAR(50) NOT NULL,

    account_name VARCHAR(255) NOT NULL,

    account_type VARCHAR(50) NOT NULL,

    is_postable BOOLEAN NOT NULL DEFAULT TRUE,

    opening_balance NUMERIC(18,2) DEFAULT 0,

    current_balance NUMERIC(18,2) DEFAULT 0,

    status status_type NOT NULL DEFAULT 'active',

    created_at TIMESTAMP DEFAULT NOW(),

    updated_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(company_id,account_code)

);

SELECT create_updated_at_trigger('chart_of_accounts');

CREATE INDEX idx_coa_company
ON chart_of_accounts(company_id);

CREATE INDEX idx_coa_parent
ON chart_of_accounts(parent_id);

CREATE INDEX idx_coa_type
ON chart_of_accounts(account_type);

-- ==========================================================
-- Journal Entries
-- ==========================================================

CREATE TABLE IF NOT EXISTS journal_entries (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id),

    journal_number VARCHAR(100) NOT NULL,

    journal_date DATE NOT NULL,

    reference_type VARCHAR(50),

    reference_id UUID,

    description TEXT,

    created_by UUID REFERENCES users(id),

    created_at TIMESTAMP DEFAULT NOW(),

    updated_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(company_id,journal_number)

);

SELECT create_updated_at_trigger('journal_entries');

CREATE INDEX idx_journal_company
ON journal_entries(company_id);

CREATE INDEX idx_journal_date
ON journal_entries(journal_date);

-- ==========================================================
-- Journal Entry Lines
-- ==========================================================

CREATE TABLE IF NOT EXISTS journal_entry_lines (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    journal_entry_id UUID NOT NULL REFERENCES journal_entries(id) ON DELETE CASCADE,

    account_id UUID NOT NULL REFERENCES chart_of_accounts(id),

    debit NUMERIC(18,2) DEFAULT 0,

    credit NUMERIC(18,2) DEFAULT 0,

    description TEXT

);

CREATE INDEX idx_journal_lines_entry
ON journal_entry_lines(journal_entry_id);

CREATE INDEX idx_journal_lines_account
ON journal_entry_lines(account_id);

-- ==========================================================
-- Cash Accounts
-- ==========================================================

CREATE TABLE IF NOT EXISTS cash_accounts (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id),

    account_id UUID NOT NULL REFERENCES chart_of_accounts(id),

    name VARCHAR(255) NOT NULL,

    current_balance NUMERIC(18,2) DEFAULT 0,

    created_at TIMESTAMP DEFAULT NOW(),

    updated_at TIMESTAMP DEFAULT NOW()

);

SELECT create_updated_at_trigger('cash_accounts');

-- ==========================================================
-- Bank Accounts
-- ==========================================================

CREATE TABLE IF NOT EXISTS bank_accounts (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id),

    account_id UUID NOT NULL REFERENCES chart_of_accounts(id),

    bank_name VARCHAR(255) NOT NULL,

    account_name VARCHAR(255),

    account_number VARCHAR(100),

    iban VARCHAR(100),

    swift_code VARCHAR(50),

    currency VARCHAR(20) DEFAULT 'EGP',

    current_balance NUMERIC(18,2) DEFAULT 0,

    created_at TIMESTAMP DEFAULT NOW(),

    updated_at TIMESTAMP DEFAULT NOW()

);

SELECT create_updated_at_trigger('bank_accounts');

-- ==========================================================
-- Receipts
-- ==========================================================

CREATE TABLE IF NOT EXISTS receipts (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id),

    receipt_number VARCHAR(100) NOT NULL,

    customer_id UUID REFERENCES customers(id),

    cash_account_id UUID REFERENCES cash_accounts(id),

    bank_account_id UUID REFERENCES bank_accounts(id),

    amount NUMERIC(18,2) NOT NULL,

    payment_method payment_method NOT NULL,

    receipt_date DATE NOT NULL,

    notes TEXT,

    created_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(company_id,receipt_number)

);

CREATE INDEX idx_receipts_customer
ON receipts(customer_id);

-- ==========================================================
-- Payments
-- ==========================================================

CREATE TABLE IF NOT EXISTS payments (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id),

    payment_number VARCHAR(100) NOT NULL,

    supplier_id UUID REFERENCES suppliers(id),

    cash_account_id UUID REFERENCES cash_accounts(id),

    bank_account_id UUID REFERENCES bank_accounts(id),

    amount NUMERIC(18,2) NOT NULL,

    payment_method payment_method NOT NULL,

    payment_date DATE NOT NULL,

    notes TEXT,

    created_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(company_id,payment_number)

);

CREATE INDEX idx_payments_supplier
ON payments(supplier_id);

COMMIT;
