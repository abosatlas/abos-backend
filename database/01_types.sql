BEGIN;

CREATE TYPE status_type AS ENUM (
'active',
'inactive',
'draft',
'pending',
'approved',
'rejected',
'cancelled',
'completed'
);

CREATE TYPE customer_type AS ENUM (
'company',
'individual'
);

CREATE TYPE supplier_type AS ENUM (
'company',
'individual'
);

CREATE TYPE payment_status AS ENUM (
'pending',
'partial',
'paid',
'cancelled',
'refunded'
);

CREATE TYPE payment_method AS ENUM (
'cash',
'bank_transfer',
'cheque',
'credit_card',
'debit_card',
'wallet',
'online'
);

CREATE TYPE inventory_transaction_type AS ENUM (
'opening',
'purchase',
'sale',
'return_in',
'return_out',
'adjustment_in',
'adjustment_out',
'transfer_in',
'transfer_out',
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
'issued',
'partially_paid',
'paid',
'cancelled'
);

COMMIT;
