import 'package:equatable/equatable.dart';

class WarehouseModel extends Equatable {
  final String id;
  final String name;
  final String location;

  const WarehouseModel({
    required this.id,
    required this.name,
    required this.location,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
      };

  factory WarehouseModel.fromJson(Map<String, dynamic> json) => WarehouseModel(
        id: json['id'] as String,
        name: json['name'] as String,
        location: json['location'] as String,
      );

  @override
  List<Object?> get props => [id, name, location];
}
