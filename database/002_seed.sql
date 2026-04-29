INSERT INTO app_users (id, name, role, language, username, password_hash) VALUES
  ('usr_01', 'Admin Adminov', 'admin', 'uz', 'admin', crypt('admin123', gen_salt('bf'))),
  ('usr_02', 'Mansur Yusupov', 'warehouseManager', 'uz', 'manager', crypt('manager123', gen_salt('bf'))),
  ('usr_03', 'Sherzod Toshmatov', 'warehouseWorker', 'uz', 'worker', crypt('worker123', gen_salt('bf')));

INSERT INTO categories (id, name_uz, name_ru) VALUES
  ('cat_01', 'Yog''ochlar', 'Деревянные изделия'),
  ('cat_02', 'Latunlar', 'Латунные изделия'),
  ('cat_03', 'Keramika buyumlar', 'Керамические изделия'),
  ('cat_04', 'Ayollar libosi', 'Женская одежда'),
  ('cat_05', 'Erkaklar libosi', 'Мужская одежда'),
  ('cat_06', 'Pichoqlar', 'Ножи'),
  ('cat_07', 'Shkatulkalar', 'Шкатулки'),
  ('cat_08', 'Bosh kiyimlar', 'Головные уборы'),
  ('cat_09', 'Magnitlar', 'Магниты'),
  ('cat_10', 'Sumkalar', 'Сумки'),
  ('cat_11', 'Sharflar', 'Шарфы'),
  ('cat_12', 'Panolar', 'Панно');

INSERT INTO warehouses (id, name, location) VALUES
  ('wh_01', 'Asosiy ombor', 'Toshkent, Yunusobod tumani'),
  ('wh_02', 'Filial ombor', 'Toshkent, Chilonzor tumani'),
  ('wh_03', 'Tranzit ombor', 'Toshkent, Olmazor tumani');

INSERT INTO products (
  id, name, sku, barcode, category_id, description, unit,
  purchase_price, selling_price, current_quantity, min_quantity, created_at, updated_at
) VALUES
  ('prod_001', 'Yog''och qoshiq (katta)', 'WD-SPO-001', '4600000000001', 'cat_01', 'Yog''ochdan yasalgan katta oshpaz qoshig''i', 'dona', 8500, 15000, 145, 20, '2025-01-15', '2025-11-10'),
  ('prod_002', 'Yog''och taxta (naqshli)', 'WD-CUT-001', '4600000000002', 'cat_01', 'Naqshli kesish taxtasi', 'dona', 25000, 45000, 8, 15, '2025-02-01', '2025-11-10'),
  ('prod_003', 'Yog''och quti (kichik)', 'WD-BOX-001', '4600000000003', 'cat_01', 'Zargarlik buyumlari uchun yog''och quti', 'dona', 18000, 32000, 0, 10, '2025-02-10', '2025-11-09'),
  ('prod_008', 'Keramika piyola (ko''k naqsh)', 'CR-CUP-001', '4600000000008', 'cat_03', 'An''anaviy o''zbek naqshi bilan bezatilgan piyola', 'dona', 12000, 22000, 89, 20, '2025-01-20', '2025-11-04'),
  ('prod_015', 'Doppi (qora)', 'MC-SKC-001', NULL, 'cat_05', NULL, 'dona', 35000, 65000, 56, 15, '2025-03-20', '2025-10-28'),
  ('prod_026', 'Magnit (Registon, kichik)', 'MG-REG-001', '4600000000026', 'cat_09', 'Registon suratlari bilan magnit', 'dona', 4500, 9000, 320, 50, '2025-01-10', '2025-10-17'),
  ('prod_029', 'Teri sumka (qo''l sumkasi)', 'BG-LTH-001', '4600000000029', 'cat_10', 'Tabiiy teridan tikilgan qo''l sumkasi', 'dona', 150000, 270000, 16, 5, '2025-04-20', '2025-10-14');

INSERT INTO stock_balances (id, product_id, warehouse_id, quantity, updated_at) VALUES
  ('sb_001', 'prod_001', 'wh_01', 100, '2025-11-10'),
  ('sb_002', 'prod_001', 'wh_02', 45, '2025-11-10'),
  ('sb_003', 'prod_002', 'wh_01', 8, '2025-11-10'),
  ('sb_004', 'prod_003', 'wh_01', 0, '2025-11-09'),
  ('sb_008', 'prod_008', 'wh_01', 89, '2025-11-04'),
  ('sb_015', 'prod_015', 'wh_01', 56, '2025-10-28'),
  ('sb_010', 'prod_026', 'wh_01', 200, '2025-10-17'),
  ('sb_011', 'prod_026', 'wh_02', 120, '2025-10-17'),
  ('sb_029', 'prod_029', 'wh_01', 16, '2025-10-14');

INSERT INTO stock_movements (
  id, product_id, warehouse_id, movement_type, quantity,
  before_quantity, after_quantity, reason, note, created_by, created_at
) VALUES
  ('mv_001', 'prod_001', 'wh_01', 'IN', 50, 95, 145, NULL, 'Etkazib beruvchidan qabul qilindi', 'usr_02', '2025-11-10 09:30:00+00'),
  ('mv_002', 'prod_026', 'wh_01', 'OUT', 30, 350, 320, 'Sale', 'Do''konga jo''natildi', 'usr_03', '2025-11-10 11:15:00+00'),
  ('mv_003', 'prod_003', 'wh_01', 'OUT', 5, 5, 0, 'Damaged', 'Zararlangan mahsulotlar olib tashlandi', 'usr_02', '2025-11-09 14:00:00+00'),
  ('mv_004', 'prod_008', 'wh_01', 'IN', 100, 0, 89, NULL, 'Yangi partiya keldi', 'usr_01', '2025-11-08 10:00:00+00'),
  ('mv_005', 'prod_015', 'wh_01', 'ADJUSTMENT', 6, 50, 56, NULL, 'Inventarizatsiya natijasi', 'usr_02', '2025-11-07 16:30:00+00'),
  ('mv_007', 'prod_029', 'wh_01', 'OUT', 4, 20, 16, 'Sale', NULL, 'usr_03', '2025-11-05 13:45:00+00');
