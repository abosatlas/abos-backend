-- ==========================================================
-- ABOS ERP v1
-- ENUM Types
-- ==========================================================

CREATE TYPE status_type AS ENUM (
'active',
'inactive',
'draft',
'pending',
'approved',
'rejected',
'completed',
'cancelled'
);

CREATE TYPE customer_type AS ENUM (
'individual',
'company'
);

CREATE TYPE supplier_type AS ENUM (
'individual',
'company'
);

CREATE TYPE payment_status AS ENUM (
'unpaid',
'partial',
'paid',
'overdue'
);

CREATE TYPE payment_method AS ENUM (
'cash',
'bank_transfer',
'credit_card',
'cheque',
'wallet'
);

CREATE TYPE inventory_transaction_type AS ENUM (
'opening_balance',
'purchase',
'sale',
'sales_return',
'purchase_return',
'transfer_in',
'transfer_out',
'adjustment',
'production_in',
'production_out'
);

CREATE TYPE lead_status AS ENUM (
'new',
'contacted',
'qualified',
'proposal',
'won',
'lost'
);

CREATE TYPE opportunity_stage AS ENUM (
'qualification',
'proposal',
'negotiation',
'won',
'lost'
);

CREATE TYPE invoice_status AS ENUM (
'draft',
'sent',
'paid',
'cancelled'
);
