CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE app_users (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('admin', 'warehouseManager', 'warehouseWorker')),
  language TEXT NOT NULL DEFAULT 'uz' CHECK (language IN ('uz', 'ru')),
  username TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE categories (
  id TEXT PRIMARY KEY,
  name_uz TEXT NOT NULL,
  name_ru TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE warehouses (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  location TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE products (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  sku TEXT NOT NULL UNIQUE,
  barcode TEXT UNIQUE,
  category_id TEXT NOT NULL REFERENCES categories(id),
  description TEXT,
  unit TEXT NOT NULL,
  purchase_price NUMERIC(14, 2) NOT NULL DEFAULT 0 CHECK (purchase_price >= 0),
  selling_price NUMERIC(14, 2) NOT NULL DEFAULT 0 CHECK (selling_price >= 0),
  current_quantity INTEGER NOT NULL DEFAULT 0 CHECK (current_quantity >= 0),
  min_quantity INTEGER NOT NULL DEFAULT 0 CHECK (min_quantity >= 0),
  image_placeholder TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE stock_balances (
  id TEXT PRIMARY KEY,
  product_id TEXT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  warehouse_id TEXT NOT NULL REFERENCES warehouses(id),
  quantity INTEGER NOT NULL DEFAULT 0 CHECK (quantity >= 0),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (product_id, warehouse_id)
);

CREATE TABLE stock_movements (
  id TEXT PRIMARY KEY,
  product_id TEXT NOT NULL REFERENCES products(id),
  warehouse_id TEXT NOT NULL REFERENCES warehouses(id),
  movement_type TEXT NOT NULL CHECK (
    movement_type IN ('IN', 'OUT', 'TRANSFER', 'ADJUSTMENT', 'RETURN', 'DAMAGED', 'INVENTORY')
  ),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  before_quantity INTEGER NOT NULL CHECK (before_quantity >= 0),
  after_quantity INTEGER NOT NULL CHECK (after_quantity >= 0),
  reason TEXT,
  note TEXT,
  created_by TEXT NOT NULL REFERENCES app_users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_stock_balances_product_id ON stock_balances(product_id);
CREATE INDEX idx_stock_balances_warehouse_id ON stock_balances(warehouse_id);
CREATE INDEX idx_stock_movements_product_id_created_at ON stock_movements(product_id, created_at DESC);
CREATE INDEX idx_stock_movements_warehouse_id_created_at ON stock_movements(warehouse_id, created_at DESC);
CREATE INDEX idx_stock_movements_type_created_at ON stock_movements(movement_type, created_at DESC);

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_app_users_updated_at
BEFORE UPDATE ON app_users
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_categories_updated_at
BEFORE UPDATE ON categories
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_warehouses_updated_at
BEFORE UPDATE ON warehouses
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_products_updated_at
BEFORE UPDATE ON products
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
