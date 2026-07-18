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
