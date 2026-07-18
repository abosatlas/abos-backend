BEGIN;

-- ==========================================================
-- PROJECTS MODULE
-- ==========================================================

CREATE TABLE IF NOT EXISTS projects (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    code VARCHAR(50) NOT NULL,

    name VARCHAR(255) NOT NULL,

    customer_id UUID REFERENCES customers(id),

    manager_id UUID REFERENCES users(id),

    start_date DATE,

    end_date DATE,

    budget NUMERIC(18,2) DEFAULT 0,

    status status_type DEFAULT 'active',

    description TEXT,

    created_at TIMESTAMP DEFAULT NOW(),

    updated_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(company_id,code)

);

SELECT create_updated_at_trigger('projects');

CREATE INDEX idx_projects_company
ON projects(company_id);

CREATE INDEX idx_projects_customer
ON projects(customer_id);

CREATE INDEX idx_projects_manager
ON projects(manager_id);

-- ==========================================================

CREATE TABLE IF NOT EXISTS project_tasks (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,

    assigned_to UUID REFERENCES users(id),

    title VARCHAR(255) NOT NULL,

    description TEXT,

    priority VARCHAR(30) DEFAULT 'medium',

    status VARCHAR(30) DEFAULT 'todo',

    start_date DATE,

    due_date DATE,

    completed_at TIMESTAMP,

    created_at TIMESTAMP DEFAULT NOW(),

    updated_at TIMESTAMP DEFAULT NOW()

);

SELECT create_updated_at_trigger('project_tasks');

CREATE INDEX idx_project_tasks_project
ON project_tasks(project_id);

CREATE INDEX idx_project_tasks_user
ON project_tasks(assigned_to);

COMMIT;
