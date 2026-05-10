import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/mock_data/mock_database.dart';
import '../../../../shared/models/branch_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SalespersonDashboardPage extends ConsumerStatefulWidget {
  const SalespersonDashboardPage({super.key});

  @override
  ConsumerState<SalespersonDashboardPage> createState() => _SalespersonDashboardPageState();
}

class _SalespersonDashboardPageState extends ConsumerState<SalespersonDashboardPage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).valueOrNull;
    final branch = MockDatabase().branches.firstWhere(
      (b) => b.id == (user?.branchId ?? 'branch_01'),
      orElse: () => MockDatabase().branches.first,
    );
    final products = MockDatabase().products;

    final tabs = [
      _MainTab(branch: branch, user: user, products: products),
      const _SaleTab(),
      _StockTab(products: products),
      _KpiTab(user: user),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: tabs[_tabIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Главная'),
          NavigationDestination(icon: Icon(Icons.point_of_sale_outlined), selectedIcon: Icon(Icons.point_of_sale), label: 'Продажа'),
          NavigationDestination(icon: Icon(Icons.inventory_outlined), selectedIcon: Icon(Icons.inventory), label: 'Остатки'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: 'Мои KPI'),
        ],
      ),
    );
  }
}

class _MainTab extends StatelessWidget {
  final BranchModel branch;
  final dynamic user;
  final List products;
  const _MainTab({required this.branch, required this.user, required this.products});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,###', 'ru');
    const todaySales = 3850000.0;
    const todayTarget = 3200000.0;
    const progress = todaySales / todayTarget;
    const bonus = 385000;
    final initials = (user?.name ?? 'ДК').split(' ').take(2).map((w) => w[0]).join();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDim.paddingM),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // Header
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Продавец · ${branch.name}',
                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            Text(user?.name ?? 'Дилноза К.', style: AppTextStyles.heading2),
          ])),
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary,
            child: Text(initials,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
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
              Text('Сканировать или выбрать товар',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
            ]),
          ),
        ),
        const SizedBox(height: AppDim.paddingM),

        // СКОЛЬКО Я ПРОДАЛ
        Text('СКОЛЬКО Я ПРОДАЛ',
            style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5)),
        const SizedBox(height: AppDim.paddingS),
        Container(
          padding: const EdgeInsets.all(AppDim.paddingM),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDim.radiusM),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('Сегодня', style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary)),
              const Spacer(),
              Text('Цель ${fmt.format(todayTarget.round())} тыс',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            ]),
            const SizedBox(height: 4),
            Text('${fmt.format(todaySales.round())} сум',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: AppColors.divider,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.statusOk),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Text('56 чеков · бонус ${fmt.format(bonus)} сум',
                  style: AppTextStyles.body2),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.statusOk.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('120%',
                    style: TextStyle(color: AppColors.statusOk, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ]),
          ]),
        ),
        const SizedBox(height: AppDim.paddingS),

        // Week / Month
        Row(children: [
          Expanded(child: Container(
            padding: const EdgeInsets.all(AppDim.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDim.radiusM),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(children: [
              Text('Неделя', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              const Text('18 200 тыс', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ]),
          )),
          const SizedBox(width: AppDim.paddingS),
          Expanded(child: Container(
            padding: const EdgeInsets.all(AppDim.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDim.radiusM),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(children: [
              Text('Месяц', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              const Text('68 400 тыс', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ]),
          )),
        ]),
        const SizedBox(height: AppDim.paddingM),

        // ОСТАТКИ СКЛАДА
        Text('ОСТАТКИ СКЛАДА',
            style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5)),
        const SizedBox(height: AppDim.paddingS),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDim.radiusM),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(children: [
            const TextField(
              decoration: InputDecoration(
                hintText: 'Найти товар или сканировать',
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const Divider(height: 1),
            ...products.take(3).map((p) {
              final stockColor = p.currentQuantity == 0
                  ? AppColors.statusCritical
                  : p.currentQuantity <= p.minQuantity
                      ? AppColors.statusLow
                      : AppColors.statusOk;
              return Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDim.paddingM, vertical: 10),
                  child: Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p.name, style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w500)),
                      Text('${NumberFormat('#,###', 'ru').format(p.sellingPrice.round())} сум',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    ])),
                    Text(
                      '${p.currentQuantity} шт',
                      style: TextStyle(color: stockColor, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ]),
                ),
                const Divider(height: 1),
              ]);
            }),
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
              Text('«Что предложить туристу?»',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
            ]),
          ]),
        ),
        const SizedBox(height: AppDim.paddingXL),
      ]),
    );
  }
}

class _SaleTab extends StatelessWidget {
  const _SaleTab();

  @override
  Widget build(BuildContext context) => const Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.point_of_sale, size: 80, color: AppColors.primary),
      SizedBox(height: 16),
      Text('Продажа', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      SizedBox(height: 8),
      Text('Сканировать штрихкод или найти товар', textAlign: TextAlign.center),
    ]),
  );
}

class _StockTab extends StatelessWidget {
  final List products;
  const _StockTab({required this.products});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,###', 'ru');
    return Column(children: [
      Container(
        color: AppColors.surface,
        padding: const EdgeInsets.all(AppDim.paddingM),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Найти товар или сканировать',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
      Expanded(child: ListView.separated(
        itemCount: products.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final p = products[i];
          final stockColor = p.currentQuantity == 0
              ? AppColors.statusCritical
              : p.currentQuantity <= p.minQuantity
                  ? AppColors.statusLow
                  : AppColors.statusOk;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDim.paddingM, vertical: 10),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.name, style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w500)),
                Text('${fmt.format(p.sellingPrice.round())} сум',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              ])),
              Text('${p.currentQuantity} шт',
                  style: TextStyle(color: stockColor, fontWeight: FontWeight.bold, fontSize: 15)),
            ]),
          );
        },
      )),
    ]);
  }
}

class _KpiTab extends StatelessWidget {
  final dynamic user;
  const _KpiTab({required this.user});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppDim.paddingM),
    children: [
      Text('Мои KPI', style: AppTextStyles.heading2),
      const SizedBox(height: AppDim.paddingM),
      _KpiCard(title: 'Сегодня', value: '3 850 000 сум', sub: '120% от плана · бонус 385 000 сум', color: AppColors.statusOk),
      const SizedBox(height: AppDim.paddingS),
      _KpiCard(title: 'Эта неделя', value: '18 200 000 сум', sub: '56 чеков', color: AppColors.primary),
      const SizedBox(height: AppDim.paddingS),
      _KpiCard(title: 'Этот месяц', value: '68 400 000 сум', sub: 'Бонус: 385 000 сум', color: AppColors.movementAdjustment),
      const SizedBox(height: AppDim.paddingS),
      _KpiCard(title: 'Средний чек', value: '68 750 сум', sub: 'Норма: 50 000 сум', color: AppColors.statusLow),
    ],
  );
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String sub;
  final Color color;
  const _KpiCard({required this.title, required this.value, required this.sub, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppDim.paddingM),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppDim.radiusM),
      border: Border.all(color: AppColors.divider),
    ),
    child: Row(children: [
      Container(
        width: 4, height: 50,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: color)),
        Text(sub, style: AppTextStyles.body2),
      ])),
    ]),
  );
}
