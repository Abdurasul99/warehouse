import '../../../shared/models/product_model.dart';

enum HealthLevel { green, yellow, red }

class StockHealthBreakdown {
  final int okCount;
  final int lowCount;
  final int criticalCount;

  const StockHealthBreakdown({
    required this.okCount,
    required this.lowCount,
    required this.criticalCount,
  });

  int get total => okCount + lowCount + criticalCount;
  double get okRatio => total == 0 ? 0 : okCount / total;
  double get lowRatio => total == 0 ? 0 : lowCount / total;
  double get criticalRatio => total == 0 ? 0 : criticalCount / total;

  HealthLevel get level {
    if (total == 0) return HealthLevel.green;
    if (okRatio >= 0.7) return HealthLevel.green;
    if (okRatio >= 0.4) return HealthLevel.yellow;
    return HealthLevel.red;
  }
}

class FlowDelta {
  final int unitsIn;
  final int unitsOut;
  final DateTime referenceDay;
  final bool fromFallback;

  const FlowDelta({
    required this.unitsIn,
    required this.unitsOut,
    required this.referenceDay,
    this.fromFallback = false,
  });

  int get net => unitsIn - unitsOut;
  HealthLevel get level {
    if (net > 0) return HealthLevel.green;
    if (net == 0) return HealthLevel.yellow;
    return HealthLevel.red;
  }
}

class ReorderItem {
  final ProductModel product;
  final double ratio;

  const ReorderItem({required this.product, required this.ratio});

  HealthLevel get level {
    if (ratio <= 0) return HealthLevel.red;
    if (ratio <= 0.5) return HealthLevel.yellow;
    return HealthLevel.green;
  }
}

class AnalyticsSummary {
  final StockHealthBreakdown health;
  final List<ProductModel> criticalItems;
  final FlowDelta todayFlow;
  final double inventoryValue;
  final List<ReorderItem> reorderQueue;
  final int slowMoverCount;

  const AnalyticsSummary({
    required this.health,
    required this.criticalItems,
    required this.todayFlow,
    required this.inventoryValue,
    required this.reorderQueue,
    required this.slowMoverCount,
  });
}
