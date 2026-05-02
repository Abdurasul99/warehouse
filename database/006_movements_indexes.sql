-- M006: stock_movements was missing an index on created_by (queries
-- "movements by user" did full scans) and the FK on product_id had
-- no explicit ON DELETE rule (NO ACTION default), which permits
-- orphan-style states. Switching to RESTRICT makes deletes explicit.

BEGIN;

CREATE INDEX idx_stock_movements_created_by ON stock_movements(created_by);

ALTER TABLE stock_movements
  DROP CONSTRAINT stock_movements_product_id_fkey;

ALTER TABLE stock_movements
  ADD CONSTRAINT stock_movements_product_id_fkey
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT;

COMMIT;
