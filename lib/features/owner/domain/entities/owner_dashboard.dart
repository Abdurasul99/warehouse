class OwnerToday {
  final double revenue;
  final int checkCount;
  final double marginPercent;
  final double deltaPercent;
  final double cogs;
  final double grossProfit;

  const OwnerToday({
    required this.revenue,
    required this.checkCount,
    required this.marginPercent,
    required this.deltaPercent,
    required this.cogs,
    required this.grossProfit,
  });
}

class OwnerBranchSummary {
  final String id;
  final String name;
  final String? address;
  final double todayRevenue;
  final int checkCount;
  final int employeeCount;
  final double deltaPercent;

  const OwnerBranchSummary({
    required this.id,
    required this.name,
    this.address,
    required this.todayRevenue,
    required this.checkCount,
    required this.employeeCount,
    required this.deltaPercent,
  });
}

class OwnerNotification {
  final String branchId;
  final String branchName;
  final double deltaPercent;
  final String message;

  const OwnerNotification({
    required this.branchId,
    required this.branchName,
    required this.deltaPercent,
    required this.message,
  });
}

class OwnerDashboard {
  final OwnerToday today;
  final List<OwnerBranchSummary> branches;
  final List<OwnerNotification> notifications;

  const OwnerDashboard({
    required this.today,
    required this.branches,
    required this.notifications,
  });
}
