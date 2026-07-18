BEGIN;

-- ==========================================================
-- CRM MODULE
-- ==========================================================

-- ==========================================================
-- Customers
-- ==========================================================

CREATE TABLE IF NOT EXISTS customers (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    customer_type customer_type NOT NULL DEFAULT 'company',

    code VARCHAR(50) NOT NULL,

    name VARCHAR(255) NOT NULL,

    email VARCHAR(255),

    phone VARCHAR(50),

    mobile VARCHAR(50),

    tax_number VARCHAR(100),

    address TEXT,

    city VARCHAR(100),

    country VARCHAR(100),

    credit_limit NUMERIC(18,2) DEFAULT 0,

    payment_terms INTEGER DEFAULT 0,

    notes TEXT,

    status status_type NOT NULL DEFAULT 'active',

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),

    UNIQUE(company_id, code)

);

SELECT create_updated_at_trigger('customers');

CREATE INDEX idx_customers_company
ON customers(company_id);

CREATE INDEX idx_customers_name
ON customers(name);

CREATE INDEX idx_customers_status
ON customers(status);

-- ==========================================================
-- Contacts
-- ==========================================================

CREATE TABLE IF NOT EXISTS contacts (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,

    first_name VARCHAR(100) NOT NULL,

    last_name VARCHAR(100),

    job_title VARCHAR(150),

    email VARCHAR(255),

    phone VARCHAR(50),

    mobile VARCHAR(50),

    is_primary BOOLEAN DEFAULT FALSE,

    status status_type NOT NULL DEFAULT 'active',

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMP NOT NULL DEFAULT NOW()

);

SELECT create_updated_at_trigger('contacts');

CREATE INDEX idx_contacts_company
ON contacts(company_id);

CREATE INDEX idx_contacts_customer
ON contacts(customer_id);

-- ==========================================================
-- Leads
-- ==========================================================

CREATE TABLE IF NOT EXISTS leads (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    assigned_to UUID REFERENCES users(id) ON DELETE SET NULL,

    name VARCHAR(255) NOT NULL,

    company_name VARCHAR(255),

    email VARCHAR(255),

    phone VARCHAR(50),

    source VARCHAR(100),

    expected_value NUMERIC(18,2) DEFAULT 0,

    status lead_status NOT NULL DEFAULT 'new',

    notes TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMP NOT NULL DEFAULT NOW()

);

SELECT create_updated_at_trigger('leads');

CREATE INDEX idx_leads_company
ON leads(company_id);

CREATE INDEX idx_leads_assigned
ON leads(assigned_to);

CREATE INDEX idx_leads_status
ON leads(status);

-- ==========================================================
-- Opportunities
-- ==========================================================

CREATE TABLE IF NOT EXISTS opportunities (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    customer_id UUID REFERENCES customers(id) ON DELETE SET NULL,

    lead_id UUID REFERENCES leads(id) ON DELETE SET NULL,

    owner_id UUID REFERENCES users(id) ON DELETE SET NULL,

    title VARCHAR(255) NOT NULL,

    description TEXT,

    stage opportunity_stage NOT NULL DEFAULT 'qualification',

    estimated_value NUMERIC(18,2) DEFAULT 0,

    probability INTEGER DEFAULT 0 CHECK (probability BETWEEN 0 AND 100),

    expected_close_date DATE,

    status status_type NOT NULL DEFAULT 'active',

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMP NOT NULL DEFAULT NOW()

);

SELECT create_updated_at_trigger('opportunities');

CREATE INDEX idx_opportunities_company
ON opportunities(company_id);

CREATE INDEX idx_opportunities_customer
ON opportunities(customer_id);

CREATE INDEX idx_opportunities_owner
ON opportunities(owner_id);

CREATE INDEX idx_opportunities_stage
ON opportunities(stage);

-- ==========================================================
-- Activities
-- ==========================================================

CREATE TABLE IF NOT EXISTS activities (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    customer_id UUID REFERENCES customers(id) ON DELETE CASCADE,

    lead_id UUID REFERENCES leads(id) ON DELETE CASCADE,

    opportunity_id UUID REFERENCES opportunities(id) ON DELETE CASCADE,

    user_id UUID REFERENCES users(id) ON DELETE SET NULL,

    activity_type VARCHAR(50) NOT NULL,

    subject VARCHAR(255) NOT NULL,

    description TEXT,

    activity_date TIMESTAMP NOT NULL,

    completed_at TIMESTAMP,

    status status_type NOT NULL DEFAULT 'active',

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMP NOT NULL DEFAULT NOW()

);

SELECT create_updated_at_trigger('activities');

CREATE INDEX idx_activities_company
ON activities(company_id);

CREATE INDEX idx_activities_user
ON activities(user_id);

CREATE INDEX idx_activities_customer
ON activities(customer_id);

CREATE INDEX idx_activities_date
ON activities(activity_date);

COMMIT;
