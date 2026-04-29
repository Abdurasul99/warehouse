enum UserRole { admin, warehouseManager, warehouseWorker }

enum MovementType {
  inbound,
  outbound,
  transfer,
  adjustment,
  returned,
  damaged,
  inventory,
}

enum StockStatus { ok, low, critical }

extension UserRoleLabel on UserRole {
  String get labelUz {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.warehouseManager:
        return 'Ombor boshqaruvchisi';
      case UserRole.warehouseWorker:
        return 'Ombor xodimi';
    }
  }

  String get labelRu {
    switch (this) {
      case UserRole.admin:
        return 'Администратор';
      case UserRole.warehouseManager:
        return 'Менеджер склада';
      case UserRole.warehouseWorker:
        return 'Сотрудник склада';
    }
  }
}

extension MovementTypeLabel on MovementType {
  String get dbValue {
    switch (this) {
      case MovementType.inbound:
        return 'IN';
      case MovementType.outbound:
        return 'OUT';
      case MovementType.transfer:
        return 'TRANSFER';
      case MovementType.adjustment:
        return 'ADJUSTMENT';
      case MovementType.returned:
        return 'RETURN';
      case MovementType.damaged:
        return 'DAMAGED';
      case MovementType.inventory:
        return 'INVENTORY';
    }
  }

  String get labelUz {
    switch (this) {
      case MovementType.inbound:
        return 'Kirim';
      case MovementType.outbound:
        return 'Chiqim';
      case MovementType.transfer:
        return "Ko'chirish";
      case MovementType.adjustment:
        return 'Inventarizatsiya';
      case MovementType.returned:
        return 'Qaytarish';
      case MovementType.damaged:
        return 'Yaroqsiz';
      case MovementType.inventory:
        return 'Inventar';
    }
  }

  String get labelRu {
    switch (this) {
      case MovementType.inbound:
        return 'Приход';
      case MovementType.outbound:
        return 'Расход';
      case MovementType.transfer:
        return 'Перемещение';
      case MovementType.adjustment:
        return 'Корректировка';
      case MovementType.returned:
        return 'Возврат';
      case MovementType.damaged:
        return 'Брак';
      case MovementType.inventory:
        return 'Инвентарь';
    }
  }
}

MovementType movementTypeFromDbValue(String value) {
  final normalized = value.trim().toUpperCase();
  for (final type in MovementType.values) {
    if (type.dbValue == normalized || type.name.toUpperCase() == normalized) {
      return type;
    }
  }
  throw ArgumentError.value(value, 'value', 'Unknown movement type');
}
