-- M003: add owner_user_id to products for multi-tenant filtering.
-- Existing rows are seeded as owned by usr_01 (admin) so admin keeps
-- visibility of the original demo catalog while every new user starts
-- with an empty warehouse.

BEGIN;

ALTER TABLE products
  ADD COLUMN owner_user_id TEXT NOT NULL DEFAULT 'usr_01';

ALTER TABLE products
  ADD CONSTRAINT products_owner_user_id_fkey
  FOREIGN KEY (owner_user_id) REFERENCES app_users(id);

CREATE INDEX idx_products_owner_user_id ON products(owner_user_id);

COMMIT;
