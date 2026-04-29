import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String nameUz;
  final String nameRu;

  const CategoryModel({
    required this.id,
    required this.nameUz,
    required this.nameRu,
  });

  String localizedName(String locale) => locale == 'ru' ? nameRu : nameUz;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_uz': nameUz,
        'name_ru': nameRu,
      };

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] as String,
        nameUz: json['name_uz'] as String,
        nameRu: json['name_ru'] as String,
      );

  @override
  List<Object?> get props => [id, nameUz, nameRu];
}
