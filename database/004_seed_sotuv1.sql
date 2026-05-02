-- M004: seed user usr_04 (sotuv1) which exists in the Flutter mock
-- but was missing from the original 002_seed.sql.

BEGIN;

INSERT INTO app_users (id, name, role, language, username, password_hash) VALUES
  ('usr_04', 'Sotuv Xodimi', 'warehouseWorker', 'uz', 'sotuv1',
   crypt('Sotuv12026!', gen_salt('bf')));

COMMIT;
