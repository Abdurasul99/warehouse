import '../models/user_model.dart';
import '../../core/utils/enums.dart';

const List<UserModel> mockUsers = [
  // Новые роли
  UserModel(
    id: 'usr_01',
    name: 'Mirsaid Karimov',
    role: UserRole.founder,
    language: 'ru',
    username: 'founder',
    password: 'founder123',
    branchId: null,
  ),
  UserModel(
    id: 'usr_02',
    name: 'Shahnoза Alimova',
    role: UserRole.branchManager,
    language: 'ru',
    username: 'manager',
    password: 'manager123',
    branchId: 'branch_01',
  ),
  UserModel(
    id: 'usr_03',
    name: 'Bekzod Rahimov',
    role: UserRole.cashierWarehouse,
    language: 'ru',
    username: 'cashier',
    password: 'cashier123',
    branchId: 'branch_01',
  ),
  UserModel(
    id: 'usr_04',
    name: 'Dilnoza Karimova',
    role: UserRole.salesperson,
    language: 'ru',
    username: 'seller',
    password: 'seller123',
    branchId: 'branch_01',
  ),
  // Старые роли (для совместимости)
  UserModel(
    id: 'usr_05',
    name: 'Admin Adminov',
    role: UserRole.admin,
    language: 'uz',
    username: 'admin',
    password: 'admin123',
    branchId: null,
  ),
];
