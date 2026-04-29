import '../models/product_model.dart';

final List<ProductModel> mockProducts = [
  // --- cat_01: Yog'ochlar ---
  ProductModel(
    id: 'prod_001', name: "Yog'och qoshiq (katta)", sku: 'WD-SPO-001',
    barcode: '4600000000001', categoryId: 'cat_01',
    description: "Yog'ochdan yasalgan katta oshpaz qoshig'i", unit: 'dona',
    purchasePrice: 8500, sellingPrice: 15000, currentQuantity: 145, minQuantity: 20,
    createdAt: DateTime(2025, 1, 15), updatedAt: DateTime(2025, 11, 10),
  ),
  ProductModel(
    id: 'prod_002', name: "Yog'och taxta (naqshli)", sku: 'WD-CUT-001',
    barcode: '4600000000002', categoryId: 'cat_01',
    description: "Naqshli kesish taxtasi", unit: 'dona',
    purchasePrice: 25000, sellingPrice: 45000, currentQuantity: 8, minQuantity: 15,
    createdAt: DateTime(2025, 2, 1), updatedAt: DateTime(2025, 11, 10),
  ),
  ProductModel(
    id: 'prod_003', name: "Yog'och quti (kichik)", sku: 'WD-BOX-001',
    barcode: '4600000000003', categoryId: 'cat_01',
    description: "Zargarlik buyumlari uchun yog'och quti", unit: 'dona',
    purchasePrice: 18000, sellingPrice: 32000, currentQuantity: 0, minQuantity: 10,
    createdAt: DateTime(2025, 2, 10), updatedAt: DateTime(2025, 11, 9),
  ),
  ProductModel(
    id: 'prod_004', name: "Yog'och ramka (20x30)", sku: 'WD-FRM-001',
    categoryId: 'cat_01', unit: 'dona',
    purchasePrice: 35000, sellingPrice: 60000, currentQuantity: 52, minQuantity: 15,
    createdAt: DateTime(2025, 3, 1), updatedAt: DateTime(2025, 11, 8),
  ),

  // --- cat_02: Latunlar ---
  ProductModel(
    id: 'prod_005', name: "Latun qoshiq to'plami", sku: 'BR-SET-001',
    barcode: '4600000000005', categoryId: 'cat_02',
    description: "6 donali latun qoshiq to'plami", unit: 'set',
    purchasePrice: 45000, sellingPrice: 85000, currentQuantity: 34, minQuantity: 10,
    createdAt: DateTime(2025, 2, 20), updatedAt: DateTime(2025, 11, 7),
  ),
  ProductModel(
    id: 'prod_006', name: "Latun kandil", sku: 'BR-CND-001',
    categoryId: 'cat_02', unit: 'dona',
    purchasePrice: 120000, sellingPrice: 220000, currentQuantity: 12, minQuantity: 5,
    createdAt: DateTime(2025, 3, 5), updatedAt: DateTime(2025, 11, 6),
  ),
  ProductModel(
    id: 'prod_007', name: "Latun brikcha (kichik)", sku: 'BR-PND-001',
    categoryId: 'cat_02', unit: 'dona',
    purchasePrice: 15000, sellingPrice: 28000, currentQuantity: 3, minQuantity: 10,
    createdAt: DateTime(2025, 3, 10), updatedAt: DateTime(2025, 11, 5),
  ),

  // --- cat_03: Keramika buyumlar ---
  ProductModel(
    id: 'prod_008', name: "Keramika piyola (ko'k naqsh)", sku: 'CR-CUP-001',
    barcode: '4600000000008', categoryId: 'cat_03',
    description: "An'anaviy o'zbek naqshi bilan bezatilgan piyola", unit: 'dona',
    purchasePrice: 12000, sellingPrice: 22000, currentQuantity: 89, minQuantity: 20,
    createdAt: DateTime(2025, 1, 20), updatedAt: DateTime(2025, 11, 4),
  ),
  ProductModel(
    id: 'prod_009', name: "Keramika lagan", sku: 'CR-DSH-001',
    categoryId: 'cat_03', unit: 'dona',
    purchasePrice: 55000, sellingPrice: 95000, currentQuantity: 23, minQuantity: 8,
    createdAt: DateTime(2025, 2, 15), updatedAt: DateTime(2025, 11, 3),
  ),
  ProductModel(
    id: 'prod_010', name: "Keramika guldonga", sku: 'CR-VAS-001',
    categoryId: 'cat_03', unit: 'dona',
    purchasePrice: 40000, sellingPrice: 72000, currentQuantity: 7, minQuantity: 10,
    createdAt: DateTime(2025, 3, 1), updatedAt: DateTime(2025, 11, 2),
  ),

  // --- cat_04: Ayollar libosi ---
  ProductModel(
    id: 'prod_011', name: "Atlas ko'ylak (qizil, M)", sku: 'WC-DRS-001',
    barcode: '4600000000011', categoryId: 'cat_04',
    description: "Atlas matosidan tikilgan milliy ko'ylak", unit: 'dona',
    purchasePrice: 180000, sellingPrice: 320000, currentQuantity: 15, minQuantity: 5,
    createdAt: DateTime(2025, 4, 1), updatedAt: DateTime(2025, 11, 1),
  ),
  ProductModel(
    id: 'prod_012', name: "Atlas ko'ylak (yashil, L)", sku: 'WC-DRS-002',
    categoryId: 'cat_04', unit: 'dona',
    purchasePrice: 185000, sellingPrice: 330000, currentQuantity: 8, minQuantity: 5,
    createdAt: DateTime(2025, 4, 2), updatedAt: DateTime(2025, 10, 31),
  ),
  ProductModel(
    id: 'prod_013', name: "Belbog' (ipak)", sku: 'WC-BLT-001',
    categoryId: 'cat_04', unit: 'dona',
    purchasePrice: 25000, sellingPrice: 45000, currentQuantity: 42, minQuantity: 10,
    createdAt: DateTime(2025, 4, 10), updatedAt: DateTime(2025, 10, 30),
  ),

  // --- cat_05: Erkaklar libosi ---
  ProductModel(
    id: 'prod_014', name: "Chapan (to'q ko'k)", sku: 'MC-CHP-001',
    barcode: '4600000000014', categoryId: 'cat_05',
    description: "An'anaviy o'zbek chapani", unit: 'dona',
    purchasePrice: 280000, sellingPrice: 480000, currentQuantity: 10, minQuantity: 3,
    createdAt: DateTime(2025, 4, 15), updatedAt: DateTime(2025, 10, 29),
  ),
  ProductModel(
    id: 'prod_015', name: "Doppi (qora)", sku: 'MC-SKC-001',
    categoryId: 'cat_05', unit: 'dona',
    purchasePrice: 35000, sellingPrice: 65000, currentQuantity: 56, minQuantity: 15,
    createdAt: DateTime(2025, 3, 20), updatedAt: DateTime(2025, 10, 28),
  ),
  ProductModel(
    id: 'prod_016', name: "Belbo'g' (teri)", sku: 'MC-BLT-001',
    categoryId: 'cat_05', unit: 'dona',
    purchasePrice: 40000, sellingPrice: 75000, currentQuantity: 28, minQuantity: 10,
    createdAt: DateTime(2025, 3, 25), updatedAt: DateTime(2025, 10, 27),
  ),

  // --- cat_06: Pichoqlar ---
  ProductModel(
    id: 'prod_017', name: "Milliy pichoq (kichik, suyak dasta)", sku: 'KN-SML-001',
    barcode: '4600000000017', categoryId: 'cat_06',
    description: "Dekorativ milliy pichoq, suvenir", unit: 'dona',
    purchasePrice: 45000, sellingPrice: 85000, currentQuantity: 33, minQuantity: 10,
    createdAt: DateTime(2025, 2, 5), updatedAt: DateTime(2025, 10, 26),
  ),
  ProductModel(
    id: 'prod_018', name: "Milliy pichoq (katta, mis dasta)", sku: 'KN-LRG-001',
    categoryId: 'cat_06', unit: 'dona',
    purchasePrice: 85000, sellingPrice: 155000, currentQuantity: 18, minQuantity: 5,
    createdAt: DateTime(2025, 2, 10), updatedAt: DateTime(2025, 10, 25),
  ),
  ProductModel(
    id: 'prod_019', name: "Pichoq uchi (to'plam, 3 ta)", sku: 'KN-SET-001',
    categoryId: 'cat_06', unit: 'set',
    purchasePrice: 120000, sellingPrice: 220000, currentQuantity: 5, minQuantity: 6,
    createdAt: DateTime(2025, 2, 15), updatedAt: DateTime(2025, 10, 24),
  ),

  // --- cat_07: Shkatulkalar ---
  ProductModel(
    id: 'prod_020', name: "Yog'och shkatulka (kichik, naqshli)", sku: 'JB-SML-001',
    barcode: '4600000000020', categoryId: 'cat_07',
    description: "Zargarlik uchun yog'och shkatulka", unit: 'dona',
    purchasePrice: 38000, sellingPrice: 70000, currentQuantity: 44, minQuantity: 10,
    createdAt: DateTime(2025, 1, 25), updatedAt: DateTime(2025, 10, 23),
  ),
  ProductModel(
    id: 'prod_021', name: "Yog'och shkatulka (katta)", sku: 'JB-LRG-001',
    categoryId: 'cat_07', unit: 'dona',
    purchasePrice: 65000, sellingPrice: 120000, currentQuantity: 19, minQuantity: 8,
    createdAt: DateTime(2025, 1, 28), updatedAt: DateTime(2025, 10, 22),
  ),
  ProductModel(
    id: 'prod_022', name: "Latun shkatulka", sku: 'JB-BR-001',
    categoryId: 'cat_07', unit: 'dona',
    purchasePrice: 90000, sellingPrice: 165000, currentQuantity: 11, minQuantity: 5,
    createdAt: DateTime(2025, 2, 1), updatedAt: DateTime(2025, 10, 21),
  ),

  // --- cat_08: Bosh kiyimlar ---
  ProductModel(
    id: 'prod_023', name: "Doppi (oq, klassik)", sku: 'HW-DPP-001',
    barcode: '4600000000023', categoryId: 'cat_08',
    description: "Klassik o'zbek doppisi", unit: 'dona',
    purchasePrice: 28000, sellingPrice: 52000, currentQuantity: 78, minQuantity: 20,
    createdAt: DateTime(2025, 3, 10), updatedAt: DateTime(2025, 10, 20),
  ),
  ProductModel(
    id: 'prod_024', name: "Ro'mol (atlas)", sku: 'HW-SCF-001',
    categoryId: 'cat_08', unit: 'dona',
    purchasePrice: 22000, sellingPrice: 40000, currentQuantity: 35, minQuantity: 15,
    createdAt: DateTime(2025, 3, 15), updatedAt: DateTime(2025, 10, 19),
  ),
  ProductModel(
    id: 'prod_025', name: "Bosh kiyim (qishki, jun)", sku: 'HW-WNT-001',
    categoryId: 'cat_08', unit: 'dona',
    purchasePrice: 45000, sellingPrice: 82000, currentQuantity: 4, minQuantity: 10,
    createdAt: DateTime(2025, 3, 20), updatedAt: DateTime(2025, 10, 18),
  ),

  // --- cat_09: Magnitlar ---
  ProductModel(
    id: 'prod_026', name: "Magnit (Registon, kichik)", sku: 'MG-REG-001',
    barcode: '4600000000026', categoryId: 'cat_09',
    description: "Registon suratlari bilan magnit", unit: 'dona',
    purchasePrice: 4500, sellingPrice: 9000, currentQuantity: 320, minQuantity: 50,
    createdAt: DateTime(2025, 1, 10), updatedAt: DateTime(2025, 10, 17),
  ),
  ProductModel(
    id: 'prod_027', name: "Magnit (xarita, O'zbekiston)", sku: 'MG-MAP-001',
    categoryId: 'cat_09', unit: 'dona',
    purchasePrice: 5500, sellingPrice: 11000, currentQuantity: 215, minQuantity: 50,
    createdAt: DateTime(2025, 1, 12), updatedAt: DateTime(2025, 10, 16),
  ),
  ProductModel(
    id: 'prod_028', name: "Magnit (milliy naqsh)", sku: 'MG-PTN-001',
    categoryId: 'cat_09', unit: 'dona',
    purchasePrice: 6000, sellingPrice: 12000, currentQuantity: 9, minQuantity: 30,
    createdAt: DateTime(2025, 1, 15), updatedAt: DateTime(2025, 10, 15),
  ),

  // --- cat_10: Sumkalar ---
  ProductModel(
    id: 'prod_029', name: "Teri sumka (qo'l sumkasi)", sku: 'BG-LTH-001',
    barcode: '4600000000029', categoryId: 'cat_10',
    description: "Tabiiy teridan tikilgan qo'l sumkasi", unit: 'dona',
    purchasePrice: 150000, sellingPrice: 270000, currentQuantity: 16, minQuantity: 5,
    createdAt: DateTime(2025, 4, 20), updatedAt: DateTime(2025, 10, 14),
  ),
  ProductModel(
    id: 'prod_030', name: "Namat sumka (katta)", sku: 'BG-FLT-001',
    categoryId: 'cat_10', unit: 'dona',
    purchasePrice: 65000, sellingPrice: 115000, currentQuantity: 27, minQuantity: 8,
    createdAt: DateTime(2025, 4, 22), updatedAt: DateTime(2025, 10, 13),
  ),
  ProductModel(
    id: 'prod_031', name: "Jute sumka (ekologik)", sku: 'BG-JUT-001',
    categoryId: 'cat_10', unit: 'dona',
    purchasePrice: 28000, sellingPrice: 50000, currentQuantity: 2, minQuantity: 10,
    createdAt: DateTime(2025, 4, 25), updatedAt: DateTime(2025, 10, 12),
  ),

  // --- cat_11: Sharflar ---
  ProductModel(
    id: 'prod_032', name: "Ipak sharf (ko'k)", sku: 'SC-SLK-001',
    barcode: '4600000000032', categoryId: 'cat_11',
    description: "Tabiiy ipakdan to'qilgan sharf", unit: 'dona',
    purchasePrice: 55000, sellingPrice: 98000, currentQuantity: 31, minQuantity: 10,
    createdAt: DateTime(2025, 3, 1), updatedAt: DateTime(2025, 10, 11),
  ),
  ProductModel(
    id: 'prod_033', name: "Jun sharf (qizil naqshli)", sku: 'SC-WOL-001',
    categoryId: 'cat_11', unit: 'dona',
    purchasePrice: 42000, sellingPrice: 75000, currentQuantity: 0, minQuantity: 8,
    createdAt: DateTime(2025, 3, 5), updatedAt: DateTime(2025, 10, 10),
  ),
  ProductModel(
    id: 'prod_034', name: "Atlas sharf (milliy naqsh)", sku: 'SC-ATL-001',
    categoryId: 'cat_11', unit: 'dona',
    purchasePrice: 48000, sellingPrice: 85000, currentQuantity: 14, minQuantity: 8,
    createdAt: DateTime(2025, 3, 8), updatedAt: DateTime(2025, 10, 9),
  ),

  // --- cat_12: Panolar ---
  ProductModel(
    id: 'prod_035', name: "Panel (suzani, 50x70)", sku: 'PL-SZN-001',
    barcode: '4600000000035', categoryId: 'cat_12',
    description: "Qo'lda tikilgan suzani panel", unit: 'dona',
    purchasePrice: 350000, sellingPrice: 620000, currentQuantity: 6, minQuantity: 3,
    createdAt: DateTime(2025, 2, 20), updatedAt: DateTime(2025, 10, 8),
  ),
  ProductModel(
    id: 'prod_036', name: "Panel (yog'och, o'yma naqsh)", sku: 'PL-WD-001',
    categoryId: 'cat_12', unit: 'dona',
    purchasePrice: 180000, sellingPrice: 320000, currentQuantity: 12, minQuantity: 4,
    createdAt: DateTime(2025, 2, 22), updatedAt: DateTime(2025, 10, 7),
  ),
  ProductModel(
    id: 'prod_037', name: "Panel (keramika, mozaika)", sku: 'PL-CR-001',
    categoryId: 'cat_12', unit: 'dona',
    purchasePrice: 220000, sellingPrice: 390000, currentQuantity: 4, minQuantity: 3,
    createdAt: DateTime(2025, 2, 25), updatedAt: DateTime(2025, 10, 6),
  ),
];
