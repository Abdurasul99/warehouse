import '../../../../shared/models/category_model.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> getAll();
  Future<CategoryModel?> getById(String id);
  Future<CategoryModel> create(CategoryModel category);
  Future<bool> isNameUnique(
    String nameUz,
    String nameRu, {
    String? excludeId,
  });
}
