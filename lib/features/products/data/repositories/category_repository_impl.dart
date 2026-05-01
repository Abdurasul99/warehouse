import '../../../../shared/mock_data/mock_database.dart';
import '../../../../shared/models/category_model.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final MockDatabase _db = MockDatabase();

  @override
  Future<List<CategoryModel>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_db.categories);
  }

  @override
  Future<CategoryModel?> getById(String id) async {
    try {
      return _db.categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<CategoryModel> create(CategoryModel category) async {
    _db.categories.add(category);
    return category;
  }

  @override
  Future<bool> isNameUnique(
    String nameUz,
    String nameRu, {
    String? excludeId,
  }) async {
    final uz = nameUz.trim().toLowerCase();
    final ru = nameRu.trim().toLowerCase();
    return !_db.categories.any(
      (c) =>
          c.id != excludeId &&
          (c.nameUz.trim().toLowerCase() == uz ||
              c.nameRu.trim().toLowerCase() == ru),
    );
  }
}
