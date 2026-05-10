import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/mock_data/mock_database.dart';
import '../../../../shared/models/branch_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class CashierDashboardPage extends ConsumerStatefulWidget {
  const CashierDashboardPage({super.key});

  @override
  ConsumerState<CashierDashboardPage> createState() => _CashierDashboardPageState();
}

class _CashierDashboardPageState extends ConsumerState<CashierDashboardPage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).valueOrNull;
    final branch = MockDatabase().branches.firstWhere(
      (b) => b.id == (user?.branchId ?? 'branch_01'),
      orElse: () => MockDatabase().branches.first,
    );

    final tabs = [
      _MainTab(branch: branch, user: user),
      _CashTab(),
      _WarehouseTab(),
      const _ChatTab(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: tabs[_tabIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Главная'),
          NavigationDestination(icon: Icon(Icons.point_of_sale_outlined), selectedIcon: Icon(Icons.point_of_sale), label: 'Касса'),
          NavigationDestination(icon: Icon(Icons.warehouse_outlined), selectedIcon: Icon(Icons.warehouse), label: 'Склад'),
          NavigationDestination(icon: Icon(Icons.chat_outlined), selectedIcon: Icon(Icons.chat), label: 'Чат'),
        ],
      ),
    );
  }
}

class _MainTab extends StatelessWidget {
  final BranchModel branch;
  final dynamic user;
  const _MainTab({required this.branch, required this.user});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,###', 'ru');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDim.paddingM),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // Header
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Касса + Склад · ${branch.name}',
                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            Text(user?.name ?? 'Бекзод Р.', style: AppTextStyles.heading2),
          ])),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
            child: const Text('Смена'),
          ),
        ]),
        const SizedBox(height: AppDim.paddingM),

        // Big Продажа button
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppDim.radiusL),
            ),
            child: Column(children: [
              const Text('Продажа',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(
                '${fmt.format(branch.revenueToday.round())} сум · ${branch.receiptsToday} чека',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
              ),
            ]),
          ),
        ),
        const SizedBox(height: AppDim.paddingM),

        // КАССА section
        _SectionLabel('КАССА'),
        _OperationsGrid(items: const [
          _OpItem(icon: Icons.qr_code_scanner, label: 'Сканер'),
          _OpItem(icon: Icons.assignment_return_outlined, label: 'Возврат'),
          _OpItem(icon: Icons.receipt_long_outlined, label: 'Z-отчёт'),
          _OpItem(icon: Icons.access_time_outlined, label: 'Смена'),
        ]),
        const SizedBox(height: AppDim.paddingM),

        // СКЛАД section
        _SectionLabel('СКЛАД'),
        _OperationsGrid(items: const [
          _OpItem(icon: Icons.add_box_outlined, label: 'Приёмка'),
          _OpItem(icon: Icons.qr_code_outlined, label: 'Штрихкоды'),
          _OpItem(icon: Icons.fact_check_outlined, label: 'Инвентаризация'),
          _OpItem(icon: Icons.delete_outline, label: 'Списание'),
        ]),
        const SizedBox(height: AppDim.paddingM),

        // Low stock alert
        Container(
          padding: const EdgeInsets.all(AppDim.paddingM),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(AppDim.radiusM),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${branch.stockLow} товаров заканчиваются',
                style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600, color: const Color(0xFFE65100))),
            const SizedBox(height: 2),
            const Text('Магниты Регистан, открытки набор',
                style: TextStyle(color: Color(0xFFE65100), fontSize: 13)),
          ]),
        ),
        const SizedBox(height: AppDim.paddingM),

        // AI button
        Container(
          padding: const EdgeInsets.all(AppDim.paddingM),
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppDim.radiusM)),
          child: Row(children: [
            const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('ИИ-помощник', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              Text('«Как сделать возврат?»',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
            ]),
          ]),
        ),
        const SizedBox(height: AppDim.paddingXL),
      ]),
    );
  }
}

class _CashTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppDim.paddingM),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Касса', style: AppTextStyles.heading2),
      const SizedBox(height: AppDim.paddingM),
      _OperationsGrid(items: const [
        _OpItem(icon: Icons.qr_code_scanner, label: 'Сканер'),
        _OpItem(icon: Icons.assignment_return_outlined, label: 'Возврат'),
        _OpItem(icon: Icons.receipt_long_outlined, label: 'Z-отчёт'),
        _OpItem(icon: Icons.access_time_outlined, label: 'Смена'),
      ]),
    ]),
  );
}

class _WarehouseTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppDim.paddingM),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Склад', style: AppTextStyles.heading2),
      const SizedBox(height: AppDim.paddingM),
      _OperationsGrid(items: const [
        _OpItem(icon: Icons.add_box_outlined, label: 'Приёмка'),
        _OpItem(icon: Icons.qr_code_outlined, label: 'Штрихкоды'),
        _OpItem(icon: Icons.fact_check_outlined, label: 'Инвентаризация'),
        _OpItem(icon: Icons.delete_outline, label: 'Списание'),
      ]),
    ]),
  );
}

class _ChatTab extends StatelessWidget {
  const _ChatTab();

  @override
  Widget build(BuildContext context) => const Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.smart_toy_outlined, size: 64, color: AppColors.primary),
      SizedBox(height: 16),
      Text('ИИ-помощник', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      SizedBox(height: 8),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Text('Подсказывает по операциям — как оформить возврат, где штрихкод',
            textAlign: TextAlign.center),
      ),
    ]),
  );
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppDim.paddingS),
    child: Text(text, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5)),
  );
}

class _OpItem {
  final IconData icon;
  final String label;
  const _OpItem({required this.icon, required this.label});
}

class _OperationsGrid extends StatelessWidget {
  final List<_OpItem> items;
  const _OperationsGrid({required this.items});

  @override
  Widget build(BuildContext context) => GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisSpacing: AppDim.paddingS,
    mainAxisSpacing: AppDim.paddingS,
    childAspectRatio: 3.2,
    children: items.map((item) => InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(AppDim.radiusM),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDim.radiusM),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(item.icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 8),
          Text(item.label, style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w500)),
        ]),
      ),
    )).toList(),
  );
}
