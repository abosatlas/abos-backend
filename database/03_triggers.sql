-- ==========================================================
-- ABOS ERP v1
-- Common Triggers
-- ==========================================================

CREATE OR REPLACE FUNCTION create_updated_at_trigger(table_name TEXT)
RETURNS VOID
LANGUAGE plpgsql
AS
$$
BEGIN

EXECUTE format('
DROP TRIGGER IF EXISTS trg_update_%I ON %I;
',table_name,table_name);

EXECUTE format('
CREATE TRIGGER trg_update_%I
BEFORE UPDATE
ON %I
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();
',table_name,table_name);

END;
$$;
CREATE OR REPLACE FUNCTION prevent_negative_quantity()

RETURNS TRIGGER

LANGUAGE plpgsql

AS $$

BEGIN

IF NEW.quantity < 0 THEN

RAISE EXCEPTION 'Quantity cannot be negative';

END IF;

RETURN NEW;

END;

$$;

DROP TRIGGER IF EXISTS trg_inventory_quantity
ON inventory_transactions;

CREATE TRIGGER trg_inventory_quantity

BEFORE INSERT OR UPDATE

ON inventory_transactions

FOR EACH ROW

EXECUTE FUNCTION prevent_negative_quantity();
