BEGIN;

CREATE TABLE IF NOT EXISTS audit_logs (

id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

company_id UUID REFERENCES companies(id),

table_name TEXT NOT NULL,

record_id UUID,

action TEXT NOT NULL,

old_data JSONB,

new_data JSONB,

created_by UUID REFERENCES users(id),

created_at TIMESTAMP DEFAULT NOW()

);

CREATE INDEX idx_audit_company
ON audit_logs(company_id);

CREATE INDEX idx_audit_table
ON audit_logs(table_name);

COMMIT;
