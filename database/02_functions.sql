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
