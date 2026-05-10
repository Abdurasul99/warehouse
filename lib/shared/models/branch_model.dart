class BranchModel {
  final String id;
  final String name;
  final double revenueToday;
  final int receiptsToday;
  final int employeeCount;
  final double marginPercent;
  final double growthPercent;
  final double revenuePlanToday;
  final double expenseToday;
  final double expensePlan;
  final int stockTotal;
  final double stockValueSum;
  final int stockEnded;
  final int stockLow;
  final int stockToOrder;
  final int stockNorm;
  final int couriersOnRoute;
  final int deliveryAvgMinutes;
  final int deliveriesInProgress;
  final int deliveriesReady;
  final int deliveriesLate;

  const BranchModel({
    required this.id,
    required this.name,
    required this.revenueToday,
    required this.receiptsToday,
    required this.employeeCount,
    required this.marginPercent,
    required this.growthPercent,
    this.revenuePlanToday = 10000000,
    this.expenseToday = 1200000,
    this.expensePlan = 1500000,
    this.stockTotal = 2847,
    this.stockValueSum = 42000000,
    this.stockEnded = 12,
    this.stockLow = 28,
    this.stockToOrder = 47,
    this.stockNorm = 2760,
    this.couriersOnRoute = 4,
    this.deliveryAvgMinutes = 38,
    this.deliveriesInProgress = 8,
    this.deliveriesReady = 14,
    this.deliveriesLate = 2,
  });
}
