BEGIN;

-- Core Tables

-- companies
-- branches
-- departments
-- roles
-- users
-- employees

COMMIT;
-- ==========================================================
-- Companies
-- ==========================================================

CREATE TABLE IF NOT EXISTS companies (

id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

name VARCHAR(200) NOT NULL,

code VARCHAR(50) UNIQUE NOT NULL,

email VARCHAR(255),

phone VARCHAR(50),

website VARCHAR(255),

tax_number VARCHAR(100),

commercial_register VARCHAR(100),

address TEXT,

city VARCHAR(100),

country VARCHAR(100),

logo_url TEXT,

status status_type NOT NULL DEFAULT 'active',

created_at TIMESTAMP NOT NULL DEFAULT NOW(),

updated_at TIMESTAMP NOT NULL DEFAULT NOW()

);

SELECT create_updated_at_trigger('companies');

CREATE INDEX idx_companies_code
ON companies(code);

CREATE INDEX idx_companies_status
ON companies(status);
-- ==========================================================
-- Branches
-- ==========================================================

CREATE TABLE IF NOT EXISTS branches (

id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

name VARCHAR(200) NOT NULL,

code VARCHAR(50),

phone VARCHAR(50),

email VARCHAR(255),

address TEXT,

manager_name VARCHAR(200),

status status_type NOT NULL DEFAULT 'active',

created_at TIMESTAMP NOT NULL DEFAULT NOW(),

updated_at TIMESTAMP NOT NULL DEFAULT NOW()

);

SELECT create_updated_at_trigger('branches');

CREATE INDEX idx_branches_company
ON branches(company_id);
-- ==========================================================
-- Departments
-- ==========================================================

CREATE TABLE IF NOT EXISTS departments (

id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,

name VARCHAR(200) NOT NULL,

code VARCHAR(50),

description TEXT,

status status_type NOT NULL DEFAULT 'active',

created_at TIMESTAMP NOT NULL DEFAULT NOW(),

updated_at TIMESTAMP NOT NULL DEFAULT NOW()

);

SELECT create_updated_at_trigger('departments');

CREATE INDEX idx_departments_company
ON departments(company_id);

CREATE INDEX idx_departments_branch
ON departments(branch_id);

CREATE INDEX idx_departments_status
ON departments(status);
-- ==========================================================
-- Roles
-- ==========================================================

CREATE TABLE IF NOT EXISTS roles (

id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

name VARCHAR(150) NOT NULL,

description TEXT,

status status_type NOT NULL DEFAULT 'active',

created_at TIMESTAMP NOT NULL DEFAULT NOW(),

updated_at TIMESTAMP NOT NULL DEFAULT NOW()

);

SELECT create_updated_at_trigger('roles');

CREATE INDEX idx_roles_company
ON roles(company_id);

CREATE INDEX idx_roles_status
ON roles(status);
