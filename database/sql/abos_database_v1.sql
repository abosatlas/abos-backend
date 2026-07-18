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
-- ============================================================
-- Branches
-- ============================================================

CREATE TABLE branches (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    name VARCHAR(200) NOT NULL,

    code VARCHAR(50),

    phone VARCHAR(50),

    email VARCHAR(200),

    address TEXT,

    manager_name VARCHAR(200),

    is_active BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMPTZ DEFAULT NOW(),

    updated_at TIMESTAMPTZ DEFAULT NOW()

);

CREATE INDEX idx_branches_company
ON branches(company_id);

CREATE TRIGGER trg_branches_updated_at

BEFORE UPDATE
ON branches

FOR EACH ROW

EXECUTE FUNCTION update_updated_at();

-- ============================================================
-- Departments
-- ============================================================

CREATE TABLE departments (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,

    name VARCHAR(200) NOT NULL,

    description TEXT,

    is_active BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMPTZ DEFAULT NOW(),

    updated_at TIMESTAMPTZ DEFAULT NOW()

);

CREATE INDEX idx_departments_company
ON departments(company_id);

CREATE INDEX idx_departments_branch
ON departments(branch_id);

CREATE TRIGGER trg_departments_updated_at

BEFORE UPDATE
ON departments

FOR EACH ROW

EXECUTE FUNCTION update_updated_at();

-- ============================================================
-- Roles
-- ============================================================

CREATE TABLE roles (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    name VARCHAR(150) NOT NULL,

    description TEXT,

    is_system BOOLEAN DEFAULT FALSE,

    created_at TIMESTAMPTZ DEFAULT NOW(),

    updated_at TIMESTAMPTZ DEFAULT NOW()

);

CREATE INDEX idx_roles_company
ON roles(company_id);

CREATE TRIGGER trg_roles_updated_at

BEFORE UPDATE
ON roles

FOR EACH ROW

EXECUTE FUNCTION update_updated_at();
-- ============================================================
-- Users
-- ============================================================

CREATE TABLE users (

    id UUID PRIMARY KEY,

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,

    department_id UUID REFERENCES departments(id) ON DELETE SET NULL,

    role_id UUID REFERENCES roles(id) ON DELETE SET NULL,

    first_name VARCHAR(100) NOT NULL,

    last_name VARCHAR(100),

    email VARCHAR(255) NOT NULL,

    phone VARCHAR(50),

    job_title VARCHAR(150),

    avatar_url TEXT,

    is_active BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMPTZ DEFAULT NOW(),

    updated_at TIMESTAMPTZ DEFAULT NOW(),

    UNIQUE(company_id, email)

);

CREATE INDEX idx_users_company
ON users(company_id);

CREATE INDEX idx_users_email
ON users(email);

CREATE TRIGGER trg_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

-- ============================================================
-- Employees
-- ============================================================

CREATE TABLE employees (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    user_id UUID REFERENCES users(id) ON DELETE CASCADE,

    employee_code VARCHAR(50),

    national_id VARCHAR(50),

    hire_date DATE,

    birth_date DATE,

    salary NUMERIC(12,2),

    employment_status VARCHAR(50) DEFAULT 'active',

    emergency_contact_name VARCHAR(200),

    emergency_contact_phone VARCHAR(50),

    created_at TIMESTAMPTZ DEFAULT NOW(),

    updated_at TIMESTAMPTZ DEFAULT NOW()

);

CREATE INDEX idx_employees_company
ON employees(company_id);

CREATE INDEX idx_employees_user
ON employees(user_id);

CREATE TRIGGER trg_employees_updated_at
BEFORE UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();
-- ============================================================
-- CRM : Customers
-- ============================================================

CREATE TABLE customers (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    customer_code VARCHAR(50),

    name VARCHAR(255) NOT NULL,

    customer_type VARCHAR(50) DEFAULT 'company',

    tax_number VARCHAR(100),

    commercial_registration VARCHAR(100),

    email VARCHAR(255),

    phone VARCHAR(50),

    mobile VARCHAR(50),

    website VARCHAR(255),

    country VARCHAR(100),

    city VARCHAR(100),

    address TEXT,

    credit_limit NUMERIC(14,2) DEFAULT 0,

    current_balance NUMERIC(14,2) DEFAULT 0,

    payment_terms INTEGER DEFAULT 30,

    status VARCHAR(30) DEFAULT 'active',

    notes TEXT,

    created_by UUID REFERENCES users(id),

    created_at TIMESTAMPTZ DEFAULT NOW(),

    updated_at TIMESTAMPTZ DEFAULT NOW()

);

CREATE INDEX idx_customers_company
ON customers(company_id);

CREATE INDEX idx_customers_name
ON customers(name);

CREATE TRIGGER trg_customers_updated_at
BEFORE UPDATE ON customers
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

-- ============================================================
-- CRM : Contacts
-- ============================================================

CREATE TABLE contacts (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,

    full_name VARCHAR(255) NOT NULL,

    job_title VARCHAR(150),

    email VARCHAR(255),

    phone VARCHAR(50),

    mobile VARCHAR(50),

    is_primary BOOLEAN DEFAULT FALSE,

    notes TEXT,

    created_at TIMESTAMPTZ DEFAULT NOW(),

    updated_at TIMESTAMPTZ DEFAULT NOW()

);

CREATE INDEX idx_contacts_customer
ON contacts(customer_id);

CREATE TRIGGER trg_contacts_updated_at
BEFORE UPDATE ON contacts
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();
-- ============================================================
-- CRM : Leads
-- ============================================================

CREATE TABLE leads (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    assigned_to UUID REFERENCES users(id),

    first_name VARCHAR(100),

    last_name VARCHAR(100),

    company_name VARCHAR(255),

    email VARCHAR(255),

    phone VARCHAR(50),

    source VARCHAR(100),

    status VARCHAR(30) DEFAULT 'new',

    estimated_value NUMERIC(14,2) DEFAULT 0,

    notes TEXT,

    created_at TIMESTAMPTZ DEFAULT NOW(),

    updated_at TIMESTAMPTZ DEFAULT NOW()

);

CREATE INDEX idx_leads_company
ON leads(company_id);

CREATE INDEX idx_leads_status
ON leads(status);

CREATE TRIGGER trg_leads_updated_at
BEFORE UPDATE
ON leads
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

-- ============================================================
-- CRM : Opportunities
-- ============================================================

CREATE TABLE opportunities (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    customer_id UUID REFERENCES customers(id),

    lead_id UUID REFERENCES leads(id),

    assigned_to UUID REFERENCES users(id),

    title VARCHAR(255) NOT NULL,

    stage VARCHAR(50) DEFAULT 'qualification',

    probability INTEGER DEFAULT 10,

    expected_revenue NUMERIC(14,2) DEFAULT 0,

    expected_close_date DATE,

    notes TEXT,

    created_at TIMESTAMPTZ DEFAULT NOW(),

    updated_at TIMESTAMPTZ DEFAULT NOW()

);

CREATE INDEX idx_opportunities_company
ON opportunities(company_id);

CREATE INDEX idx_opportunities_stage
ON opportunities(stage);

CREATE TRIGGER trg_opportunities_updated_at
BEFORE UPDATE
ON opportunities
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

-- ============================================================
-- CRM : Activities
-- ============================================================

CREATE TABLE activities (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    customer_id UUID REFERENCES customers(id),

    lead_id UUID REFERENCES leads(id),

    opportunity_id UUID REFERENCES opportunities(id),

    user_id UUID REFERENCES users(id),

    activity_type VARCHAR(50),

    subject VARCHAR(255),

    description TEXT,

    activity_date TIMESTAMPTZ,

    status VARCHAR(30) DEFAULT 'planned',

    created_at TIMESTAMPTZ DEFAULT NOW(),

    updated_at TIMESTAMPTZ DEFAULT NOW()

);

CREATE INDEX idx_activities_company
ON activities(company_id);

CREATE INDEX idx_activities_user
ON activities(user_id);

CREATE TRIGGER trg_activities_updated_at
BEFORE UPDATE
ON activities
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();
-- ============================================================
-- CRM : Leads
-- ============================================================

CREATE TABLE leads (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL
        REFERENCES companies(id)
        ON DELETE CASCADE,

    assigned_to UUID
        REFERENCES users(id)
        ON DELETE SET NULL,

    customer_id UUID
        REFERENCES customers(id)
        ON DELETE SET NULL,

    first_name VARCHAR(100),

    last_name VARCHAR(100),

    company_name VARCHAR(255),

    job_title VARCHAR(150),

    email VARCHAR(255),

    phone VARCHAR(50),

    mobile VARCHAR(50),

    source VARCHAR(100),

    status VARCHAR(30) NOT NULL DEFAULT 'new',

    priority VARCHAR(20) DEFAULT 'medium',

    estimated_value NUMERIC(14,2) DEFAULT 0,

    expected_close_date DATE,

    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()

);

CREATE INDEX idx_leads_company
ON leads(company_id);

CREATE INDEX idx_leads_status
ON leads(status);

CREATE INDEX idx_leads_assigned
ON leads(assigned_to);

CREATE TRIGGER trg_leads_updated_at
BEFORE UPDATE
ON leads
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();
-- ============================================================
-- CRM : Opportunities
-- ============================================================

CREATE TABLE opportunities (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL
        REFERENCES companies(id)
        ON DELETE CASCADE,

    customer_id UUID
        REFERENCES customers(id)
        ON DELETE SET NULL,

    lead_id UUID
        REFERENCES leads(id)
        ON DELETE SET NULL,

    owner_id UUID
        REFERENCES users(id)
        ON DELETE SET NULL,

    opportunity_number VARCHAR(50),

    title VARCHAR(255) NOT NULL,

    description TEXT,

    stage VARCHAR(50) NOT NULL DEFAULT 'qualification',

    probability INTEGER NOT NULL DEFAULT 10
        CHECK (probability BETWEEN 0 AND 100),

    expected_revenue NUMERIC(14,2) NOT NULL DEFAULT 0,

    expected_close_date DATE,

    actual_close_date DATE,

    status VARCHAR(30) DEFAULT 'open',

    lost_reason TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()

);

CREATE INDEX idx_opportunities_company
ON opportunities(company_id);

CREATE INDEX idx_opportunities_customer
ON opportunities(customer_id);

CREATE INDEX idx_opportunities_lead
ON opportunities(lead_id);

CREATE INDEX idx_opportunities_owner
ON opportunities(owner_id);

CREATE INDEX idx_opportunities_stage
ON opportunities(stage);

CREATE TRIGGER trg_opportunities_updated_at
BEFORE UPDATE
ON opportunities
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();
-- ============================================================
-- CRM : Activities
-- ============================================================

CREATE TABLE activities (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL
        REFERENCES companies(id)
        ON DELETE CASCADE,

    customer_id UUID
        REFERENCES customers(id)
        ON DELETE SET NULL,

    contact_id UUID
        REFERENCES contacts(id)
        ON DELETE SET NULL,

    lead_id UUID
        REFERENCES leads(id)
        ON DELETE SET NULL,

    opportunity_id UUID
        REFERENCES opportunities(id)
        ON DELETE SET NULL,

    assigned_to UUID
        REFERENCES users(id)
        ON DELETE SET NULL,

    activity_type VARCHAR(30) NOT NULL,

    subject VARCHAR(255) NOT NULL,

    description TEXT,

    status VARCHAR(20) NOT NULL DEFAULT 'planned',

    priority VARCHAR(20) NOT NULL DEFAULT 'medium',

    start_at TIMESTAMPTZ,

    end_at TIMESTAMPTZ,

    completed_at TIMESTAMPTZ,

    reminder_at TIMESTAMPTZ,

    location VARCHAR(255),

    outcome TEXT,

    created_by UUID
        REFERENCES users(id)
        ON DELETE SET NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()

);

-- ============================================================
-- Indexes
-- ============================================================

CREATE INDEX idx_activities_company
ON activities(company_id);

CREATE INDEX idx_activities_customer
ON activities(customer_id);

CREATE INDEX idx_activities_contact
ON activities(contact_id);

CREATE INDEX idx_activities_lead
ON activities(lead_id);

CREATE INDEX idx_activities_opportunity
ON activities(opportunity_id);

CREATE INDEX idx_activities_assigned
ON activities(assigned_to);

CREATE INDEX idx_activities_status
ON activities(status);

CREATE INDEX idx_activities_type
ON activities(activity_type);

CREATE INDEX idx_activities_start_at
ON activities(start_at);

-- ============================================================
-- Trigger
-- ============================================================

CREATE TRIGGER trg_activities_updated_at
BEFORE UPDATE
ON activities
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();
-- ============================================================
-- SALES : Product Categories
-- ============================================================

CREATE TABLE product_categories (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL
        REFERENCES companies(id)
        ON DELETE CASCADE,

    parent_category_id UUID
        REFERENCES product_categories(id)
        ON DELETE SET NULL,

    name VARCHAR(255) NOT NULL,

    code VARCHAR(50),

    description TEXT,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_product_category_name
        UNIQUE(company_id, name),

    CONSTRAINT uq_product_category_code
        UNIQUE(company_id, code)

);

-- ============================================================
-- Indexes
-- ============================================================

CREATE INDEX idx_product_categories_company
ON product_categories(company_id);

CREATE INDEX idx_product_categories_parent
ON product_categories(parent_category_id);

CREATE INDEX idx_product_categories_active
ON product_categories(is_active);

-- ============================================================
-- Trigger
-- ============================================================

CREATE TRIGGER trg_product_categories_updated_at
BEFORE UPDATE
ON product_categories
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();
-- ============================================================
-- SALES : Products
-- ============================================================

CREATE TABLE products (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL
        REFERENCES companies(id)
        ON DELETE CASCADE,

    category_id UUID
        REFERENCES product_categories(id)
        ON DELETE SET NULL,

    sku VARCHAR(100) NOT NULL,

    barcode VARCHAR(100),

    name_ar VARCHAR(255) NOT NULL,

    name_en VARCHAR(255),

    short_description TEXT,

    description TEXT,

    unit VARCHAR(50) NOT NULL DEFAULT 'Piece',

    product_type VARCHAR(30) NOT NULL DEFAULT 'product',

    cost_price NUMERIC(14,2) NOT NULL DEFAULT 0,

    selling_price NUMERIC(14,2) NOT NULL DEFAULT 0,

    tax_rate NUMERIC(5,2) NOT NULL DEFAULT 0,

    currency VARCHAR(10) NOT NULL DEFAULT 'EGP',

    track_inventory BOOLEAN NOT NULL DEFAULT TRUE,

    current_stock NUMERIC(14,2) NOT NULL DEFAULT 0,

    minimum_stock NUMERIC(14,2) NOT NULL DEFAULT 0,

    maximum_stock NUMERIC(14,2),

    reorder_level NUMERIC(14,2) DEFAULT 0,

    weight NUMERIC(10,3),

    length NUMERIC(10,2),

    width NUMERIC(10,2),

    height NUMERIC(10,2),

    image_url TEXT,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_by UUID
        REFERENCES users(id)
        ON DELETE SET NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_products_sku
        UNIQUE(company_id, sku),

    CONSTRAINT uq_products_barcode
        UNIQUE(company_id, barcode)

);

-- ============================================================
-- Indexes
-- ============================================================

CREATE INDEX idx_products_company
ON products(company_id);

CREATE INDEX idx_products_category
ON products(category_id);

CREATE INDEX idx_products_name_ar
ON products(name_ar);

CREATE INDEX idx_products_name_en
ON products(name_en);

CREATE INDEX idx_products_active
ON products(is_active);

CREATE INDEX idx_products_inventory
ON products(track_inventory);

-- ============================================================
-- Trigger
-- ============================================================

CREATE TRIGGER trg_products_updated_at
BEFORE UPDATE
ON products
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();
