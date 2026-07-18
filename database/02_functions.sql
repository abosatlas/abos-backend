-- ==========================================================
-- ABOS ERP v1
-- Common Database Functions
-- ==========================================================

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- ==========================================================

CREATE OR REPLACE FUNCTION generate_document_number(
    prefix TEXT
)
RETURNS TEXT AS
$$
DECLARE
    random_part TEXT;
BEGIN

    random_part :=
        LPAD(
            FLOOR(RANDOM()*1000000)::TEXT,
            6,
            '0'
        );

    RETURN prefix ||
           '-' ||
           TO_CHAR(NOW(),'YYYYMMDD') ||
           '-' ||
           random_part;

END;
$$
LANGUAGE plpgsql;

-- ==========================================================

CREATE OR REPLACE FUNCTION current_company()
RETURNS UUID
LANGUAGE SQL
STABLE
AS
$$
SELECT NULLIF(
current_setting('app.current_company', TRUE),
''
)::UUID;
$$;

-- ==========================================================

CREATE OR REPLACE FUNCTION current_user_id()
RETURNS UUID
LANGUAGE SQL
STABLE
AS
$$
SELECT NULLIF(
current_setting('app.current_user', TRUE),
''
)::UUID;
$$;
CREATE OR REPLACE FUNCTION generate_code(prefix TEXT)

RETURNS TEXT

LANGUAGE plpgsql

AS $$

DECLARE

v_code TEXT;

BEGIN

v_code :=

prefix ||

'-' ||

TO_CHAR(NOW(),'YYYYMMDD') ||

'-' ||

LPAD(FLOOR(RANDOM()*100000)::TEXT,5,'0');

RETURN v_code;

END;

$$;
CREATE OR REPLACE FUNCTION calculate_inventory_balance(

p_company UUID,

p_product UUID,

p_warehouse UUID

)

RETURNS NUMERIC

LANGUAGE SQL

AS $$

SELECT COALESCE(

SUM(

CASE

WHEN transaction_type IN
('opening','purchase','adjustment_in','transfer_in','production_in','return_in')

THEN quantity

ELSE -quantity

END

),0)

FROM inventory_transactions

WHERE company_id=p_company

AND warehouse_id=p_warehouse

AND product_id=p_product;

$$;
