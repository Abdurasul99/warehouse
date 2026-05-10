import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/mock_data/mock_database.dart';
import '../../../../shared/models/branch_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ManagerDashboardPage extends ConsumerStatefulWidget {
  const ManagerDashboardPage({super.key});

  @override
  ConsumerState<ManagerDashboardPage> createState() => _ManagerDashboardPageState();
}

class _ManagerDashboardPageState extends ConsumerState<ManagerDashboardPage> {
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
      _CashTab(branch: branch),
      _WarehouseTab(branch: branch),
      _DeliveryTab(branch: branch),
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
          NavigationDestination(icon: Icon(Icons.delivery_dining_outlined), selectedIcon: Icon(Icons.delivery_dining), label: 'Доставка'),
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
    final planRevK = (branch.revenuePlanToday / 1000).round();
    final actualRevK = (branch.revenueToday / 1000).round();
    final progress = (branch.revenueToday / branch.revenuePlanToday).clamp(0.0, 1.0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDim.paddingM),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // Header
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Менеджер · ${branch.name}', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            Text(user?.name ?? 'Менеджер', style: AppTextStyles.heading2),
          ])),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
            child: const Text('Смена'),
          ),
        ]),
        const SizedBox(height: AppDim.paddingM),

        // Plan card
        Container(
          padding: const EdgeInsets.all(AppDim.paddingL),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppDim.radiusL),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('План на сегодня',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
            const SizedBox(height: 4),
            Text(
              '$actualRevK / $planRevK тыс',
              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 6,
              ),
            ),
          ]),
        ),
        const SizedBox(height: AppDim.paddingM),

        // КАССА section
        _SectionLabel('КАССА'),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDim.radiusM),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(children: [
            _CashRow('Приход', '${fmt.format(branch.revenueToday.round())}', AppColors.statusOk),
            const Divider(height: 1),
            _CashRow('Расход', '${fmt.format(branch.expenseToday.round())}', AppColors.statusCritical),
            const Divider(height: 1),
            _CashRow('План расходов',
                '${fmt.format(branch.expenseToday.round())} / ${fmt.format(branch.expensePlan.round())}',
                AppColors.textSecondary),
          ]),
        ),
        const SizedBox(height: AppDim.paddingM),

        // СКЛАД section
        _SectionLabel('СКЛАД'),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDim.radiusM),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(AppDim.paddingM),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Остаток', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                Text(
                  '${fmt.format(branch.stockTotal)} шт · ${(branch.stockValueSum / 1000000).round()} М сум',
                  style: AppTextStyles.heading3,
                ),
              ]),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDim.paddingM),
              child: Row(children: [
                _StockStat('Закончилось', '${branch.stockEnded}', AppColors.statusCritical),
                _VertDivider(),
                _StockStat('Кончается', '${branch.stockLow}', AppColors.statusLow),
                _VertDivider(),
                _StockStat('Заказать', '${branch.stockToOrder}', AppColors.primary),
                _VertDivider(),
                _StockStat('Норма', '${branch.stockNorm}', AppColors.statusOk),
              ]),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppDim.paddingM),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Рекомендации системы',
                    style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary)),
                const SizedBox(height: 6),
                _Rec('· Закупить: магниты Регистан (200 шт)', AppColors.primary),
                _Rec('· Убрать: брелок «Ташкент-2019»', AppColors.primary),
                _Rec('· Увеличить: открытки Самарканд +50%', AppColors.primary),
                _Rec('· Теряем деньги: керамика — маржа 8%', AppColors.statusCritical),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: AppDim.paddingM),

        // КОМАНДА section
        _SectionLabel('КОМАНДА'),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDim.radiusM),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(AppDim.paddingM),
              child: Row(children: [
                Text('Кто что продал', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                const Spacer(),
                Text('3 продавца', style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary)),
              ]),
            ),
            const Divider(height: 1),
            _TeamRow('Дилноза К.', '3 850 тыс (магниты)'),
            _TeamRow('Азиз Т.', '2 700 тыс (керамика)'),
            _TeamRow('Малика У.', '1 900 тыс (сувениры)'),
            const SizedBox(height: AppDim.paddingS),
          ]),
        ),
        const SizedBox(height: AppDim.paddingM),

        // ДОСТАВКА section
        _SectionLabel('ДОСТАВКА'),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDim.radiusM),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(AppDim.paddingM),
              child: Row(children: [
                Expanded(child: Column(children: [
                  Text('Курьеры', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  Text('${branch.couriersOnRoute} на маршруте',
                      style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                ])),
                Expanded(child: Column(children: [
                  Text('Время', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  Text('~${branch.deliveryAvgMinutes} мин',
                      style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                ])),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppDim.paddingM, 0, AppDim.paddingM, AppDim.paddingM),
              child: Row(children: [
                _DelivBadge('${branch.deliveriesInProgress} в пути', AppColors.primary),
                const SizedBox(width: 8),
                _DelivBadge('${branch.deliveriesReady} готово', AppColors.statusOk),
                const SizedBox(width: 8),
                _DelivBadge('${branch.deliveriesLate} опаздывают', AppColors.statusCritical),
              ]),
            ),
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
              Text('«Что закупить на эту неделю?»',
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
  final BranchModel branch;
  const _CashTab({required this.branch});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,###', 'ru');
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDim.paddingM),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('Касса', style: AppTextStyles.heading2),
        const SizedBox(height: AppDim.paddingM),
        Container(
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppDim.radiusM), border: Border.all(color: AppColors.divider)),
          child: Column(children: [
            _CashRow('Приход', '${fmt.format(branch.revenueToday.round())} сум', AppColors.statusOk),
            const Divider(height: 1),
            _CashRow('Расход', '${fmt.format(branch.expenseToday.round())} сум', AppColors.statusCritical),
            const Divider(height: 1),
            _CashRow('Чеков', '${branch.receiptsToday}', AppColors.textSecondary),
          ]),
        ),
        const SizedBox(height: AppDim.paddingM),
        _SectionLabel('ОПЕРАЦИИ'),
        _ActionGrid(items: const [
          _ActionItem(icon: Icons.qr_code_scanner, label: 'Сканер', color: AppColors.primary),
          _ActionItem(icon: Icons.assignment_return_outlined, label: 'Возврат', color: AppColors.statusLow),
          _ActionItem(icon: Icons.receipt_long_outlined, label: 'Z-отчёт', color: AppColors.statusOk),
          _ActionItem(icon: Icons.access_time_outlined, label: 'Смена', color: AppColors.movementTransfer),
        ]),
      ]),
    );
  }
}

class _WarehouseTab extends StatelessWidget {
  final BranchModel branch;
  const _WarehouseTab({required this.branch});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,###', 'ru');
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDim.paddingM),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('Склад · ${branch.name}', style: AppTextStyles.heading2),
        const SizedBox(height: AppDim.paddingM),
        Container(
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppDim.radiusM), border: Border.all(color: AppColors.divider)),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(AppDim.paddingM),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Остаток', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                Text('${fmt.format(branch.stockTotal)} шт · ${(branch.stockValueSum / 1000000).round()} М сум', style: AppTextStyles.heading3),
              ]),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDim.paddingM),
              child: Row(children: [
                _StockStat('Закончилось', '${branch.stockEnded}', AppColors.statusCritical),
                _VertDivider(),
                _StockStat('Кончается', '${branch.stockLow}', AppColors.statusLow),
                _VertDivider(),
                _StockStat('Заказать', '${branch.stockToOrder}', AppColors.primary),
                _VertDivider(),
                _StockStat('Норма', '${branch.stockNorm}', AppColors.statusOk),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: AppDim.paddingM),
        _SectionLabel('ОПЕРАЦИИ'),
        _ActionGrid(items: const [
          _ActionItem(icon: Icons.add_box_outlined, label: 'Приёмка', color: AppColors.statusOk),
          _ActionItem(icon: Icons.qr_code_outlined, label: 'Штрихкоды', color: AppColors.primary),
          _ActionItem(icon: Icons.fact_check_outlined, label: 'Инвентаризация', color: AppColors.movementAdjustment),
          _ActionItem(icon: Icons.delete_outline, label: 'Списание', color: AppColors.statusCritical),
        ]),
      ]),
    );
  }
}

class _DeliveryTab extends StatelessWidget {
  final BranchModel branch;
  const _DeliveryTab({required this.branch});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppDim.paddingM),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Доставка', style: AppTextStyles.heading2),
      const SizedBox(height: AppDim.paddingM),
      Container(
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppDim.radiusM), border: Border.all(color: AppColors.divider)),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(AppDim.paddingM),
            child: Row(children: [
              Expanded(child: Column(children: [
                Text('Курьеры', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                Text('${branch.couriersOnRoute} на маршруте', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
              ])),
              Expanded(child: Column(children: [
                Text('Время', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                Text('~${branch.deliveryAvgMinutes} мин', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
              ])),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppDim.paddingM, 0, AppDim.paddingM, AppDim.paddingM),
            child: Row(children: [
              _DelivBadge('${branch.deliveriesInProgress} в пути', AppColors.primary),
              const SizedBox(width: 8),
              _DelivBadge('${branch.deliveriesReady} готово', AppColors.statusOk),
              const SizedBox(width: 8),
              _DelivBadge('${branch.deliveriesLate} опаздывают', AppColors.statusCritical),
            ]),
          ),
        ]),
      ),
    ]),
  );
}

// ---- Shared widgets ----
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppDim.paddingS),
    child: Text(text, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5)),
  );
}

class _CashRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _CashRow(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppDim.paddingM, vertical: 12),
    child: Row(children: [
      Text(label, style: AppTextStyles.body2),
      const Spacer(),
      Text(value, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: color)),
    ]),
  );
}

class _StockStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StockStat(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [
    Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 18)),
    Text(label, style: AppTextStyles.caption, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
  ]));
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 40, color: AppColors.divider);
}

class _Rec extends StatelessWidget {
  final String text;
  final Color color;
  const _Rec(this.text, this.color);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 2),
    child: Text(text, style: AppTextStyles.body2.copyWith(color: color)),
  );
}

class _TeamRow extends StatelessWidget {
  final String name;
  final String result;
  const _TeamRow(this.name, this.result);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppDim.paddingM, vertical: 6),
    child: Row(children: [
      Text(name, style: AppTextStyles.body2),
      const Spacer(),
      Text(result, style: AppTextStyles.body2.copyWith(color: AppColors.primary)),
    ]),
  );
}

class _DelivBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _DelivBadge(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
  );
}

class _ActionItem {
  final IconData icon;
  final String label;
  final Color color;
  const _ActionItem({required this.icon, required this.label, required this.color});
}

class _ActionGrid extends StatelessWidget {
  final List<_ActionItem> items;
  const _ActionGrid({required this.items});

  @override
  Widget build(BuildContext context) => GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisSpacing: AppDim.paddingS,
    mainAxisSpacing: AppDim.paddingS,
    childAspectRatio: 2.8,
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
          Icon(item.icon, color: item.color, size: 20),
          const SizedBox(width: 8),
          Text(item.label, style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 13)),
        ]),
      ),
    )).toList(),
  );
}
