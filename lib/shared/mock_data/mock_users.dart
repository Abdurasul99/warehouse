import '../models/user_model.dart';
import '../../core/utils/enums.dart';

const List<UserModel> mockUsers = [
  UserModel(
    id: 'usr_01',
    name: 'Admin Adminov',
    role: UserRole.admin,
    language: 'uz',
    username: 'admin',
    password: 'admin123',
  ),
  UserModel(
    id: 'usr_02',
    name: 'Mansur Yusupov',
    role: UserRole.warehouseManager,
    language: 'uz',
    username: 'manager',
    password: 'manager123',
  ),
  UserModel(
    id: 'usr_03',
    name: 'Sherzod Toshmatov',
    role: UserRole.warehouseWorker,
    language: 'uz',
    username: 'worker',
    password: 'worker123',
  ),
  UserModel(
    id: 'usr_04',
    name: 'Sotuv Xodimi',
    role: UserRole.warehouseWorker,
    language: 'uz',
    username: 'sotuv1',
    password: 'Sotuv12026!',
  ),
];
