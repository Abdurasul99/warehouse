-- M005: stock_balances was missing created_at and the
-- set_updated_at() trigger. Without the trigger, updated_at would
-- never change on UPDATE.

BEGIN;

ALTER TABLE stock_balances
  ADD COLUMN created_at TIMESTAMPTZ NOT NULL DEFAULT now();

CREATE TRIGGER trg_stock_balances_updated_at
  BEFORE UPDATE ON stock_balances
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

COMMIT;
