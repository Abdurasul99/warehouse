import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/mock_data/mock_database.dart';
import '../../../../shared/models/branch_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class FounderDashboardPage extends ConsumerStatefulWidget {
  const FounderDashboardPage({super.key});

  @override
  ConsumerState<FounderDashboardPage> createState() => _FounderDashboardPageState();
}

class _FounderDashboardPageState extends ConsumerState<FounderDashboardPage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).valueOrNull;
    final branches = MockDatabase().branches;
    final totalRevenue = branches.fold<double>(0, (s, b) => s + b.revenueToday);
    final totalReceipts = branches.fold<int>(0, (s, b) => s + b.receiptsToday);
    final avgMargin = branches.isEmpty ? 0.0 : branches.fold<double>(0, (s, b) => s + b.marginPercent) / branches.length;
    final avgGrowth = branches.isEmpty ? 0.0 : branches.fold<double>(0, (s, b) => s + b.growthPercent) / branches.length;
    final fmt = NumberFormat('#,###', 'ru');

    final tabs = [
      _SvodkaTab(
        user: user,
        branches: branches,
        totalRevenue: totalRevenue,
        totalReceipts: totalReceipts,
        avgMargin: avgMargin,
        avgGrowth: avgGrowth,
        fmt: fmt,
      ),
      _BranchesTab(branches: branches, fmt: fmt),
      const _SimulationsTab(),
      const _AiTab(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: tabs[_tabIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Сводка'),
          NavigationDestination(icon: Icon(Icons.store_outlined), selectedIcon: Icon(Icons.store), label: 'Филиалы'),
          NavigationDestination(icon: Icon(Icons.auto_graph_outlined), selectedIcon: Icon(Icons.auto_graph), label: 'Симуляции'),
          NavigationDestination(icon: Icon(Icons.smart_toy_outlined), selectedIcon: Icon(Icons.smart_toy), label: 'ИИ'),
        ],
      ),
    );
  }
}

class _SvodkaTab extends StatelessWidget {
  final dynamic user;
  final List<BranchModel> branches;
  final double totalRevenue;
  final int totalReceipts;
  final double avgMargin;
  final double avgGrowth;
  final NumberFormat fmt;

  const _SvodkaTab({
    required this.user,
    required this.branches,
    required this.totalRevenue,
    required this.totalReceipts,
    required this.avgMargin,
    required this.avgGrowth,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    final problemBranches = branches.where((b) => b.growthPercent < 0).toList();
    final growthSign = avgGrowth >= 0 ? '+' : '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDim.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Учредитель', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    Text(user?.name ?? 'Мирсаид', style: AppTextStyles.heading2),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.textSecondary.withValues(alpha: 0.2),
                child: Text(
                  (user?.name ?? 'М').substring(0, 1),
                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDim.paddingM),

          // Revenue card
          Container(
            padding: const EdgeInsets.all(AppDim.paddingL),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppDim.radiusL),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Выручка сети сегодня',
                    style: AppTextStyles.body2.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                const SizedBox(height: 6),
                Text(
                  '${fmt.format(totalRevenue.round())} сум',
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Row(children: [
                  _RevenueChip('$growthSign${avgGrowth.toStringAsFixed(0)}%'),
                  const SizedBox(width: 8),
                  _RevenueChip('$totalReceipts чеков'),
                  const SizedBox(width: 8),
                  _RevenueChip('маржа ${avgMargin.toStringAsFixed(0)}%'),
                ]),
              ],
            ),
          ),
          const SizedBox(height: AppDim.paddingM),

          // Branches section
          Text('ФИЛИАЛЫ · НАЖМИ ЧТОБЫ ОТКРЫТЬ',
              style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5)),
          const SizedBox(height: AppDim.paddingS),
          ...branches.map((b) => Padding(
            padding: const EdgeInsets.only(bottom: AppDim.paddingS),
            child: _BranchCard(branch: b, fmt: fmt),
          )),

          // ЧТО БУДЕТ ЕСЛИ section
          const SizedBox(height: AppDim.paddingS),
          Text('ЧТО БУДЕТ ЕСЛИ',
              style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5)),
          const SizedBox(height: AppDim.paddingS),
          Container(
            padding: const EdgeInsets.all(AppDim.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDim.radiusM),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Симуляции', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary)),
                const SizedBox(height: 4),
                Text(
                  'Изменю цену → прибыль · увеличу закуп → деньги\nРиск отсутствия / переполнение склада / падение продаж',
                  style: AppTextStyles.body2.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDim.paddingM),

          // Problem branch alert
          if (problemBranches.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(AppDim.paddingM),
              decoration: BoxDecoration(
                color: AppColors.statusCritical.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(AppDim.radiusM),
                border: Border.all(color: AppColors.statusCritical.withValues(alpha: 0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                      '${problemBranches.first.name} ${problemBranches.first.growthPercent.toStringAsFixed(0)}%',
                      style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.w600, color: AppColors.statusCritical),
                    ),
                  ]),
                  const SizedBox(height: 2),
                  Text('Открой филиал чтобы посмотреть где теряем',
                      style: AppTextStyles.body2),
                ],
              ),
            ),

          const SizedBox(height: AppDim.paddingM),

          // AI button
          Container(
            padding: const EdgeInsets.all(AppDim.paddingM),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppDim.radiusM),
            ),
            child: Row(children: [
              const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('ИИ-помощник', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                Text('«Сравни прибыль филиалов»',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
              ]),
            ]),
          ),
          const SizedBox(height: AppDim.paddingXL),
        ],
      ),
    );
  }
}

class _RevenueChip extends StatelessWidget {
  final String label;
  const _RevenueChip(this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
  );
}

class _BranchCard extends StatelessWidget {
  final BranchModel branch;
  final NumberFormat fmt;
  const _BranchCard({required this.branch, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final isNeg = branch.growthPercent < 0;
    final growthColor = isNeg ? AppColors.statusCritical : AppColors.statusOk;
    final sign = isNeg ? '' : '+';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDim.radiusM),
        border: Border.all(color: AppColors.divider),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(AppDim.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppDim.paddingM),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(branch.name, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  '${fmt.format(branch.revenueToday.round())} сум · ${branch.receiptsToday} чеков · ${branch.employeeCount} чел',
                  style: AppTextStyles.body2,
                ),
                const SizedBox(height: 2),
                Text('Касса · Склад · Сотрудники · Доставка',
                    style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
              ]),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: growthColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$sign${branch.growthPercent.toStringAsFixed(0)}%',
                style: TextStyle(color: growthColor, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _BranchesTab extends StatelessWidget {
  final List<BranchModel> branches;
  final NumberFormat fmt;
  const _BranchesTab({required this.branches, required this.fmt});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppDim.paddingM),
    children: [
      Text('Все филиалы', style: AppTextStyles.heading2),
      const SizedBox(height: AppDim.paddingM),
      ...branches.map((b) => Padding(
        padding: const EdgeInsets.only(bottom: AppDim.paddingS),
        child: _BranchCard(branch: b, fmt: fmt),
      )),
    ],
  );
}

class _SimulationsTab extends StatelessWidget {
  const _SimulationsTab();

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppDim.paddingM),
    children: [
      Text('Симуляции', style: AppTextStyles.heading2),
      const SizedBox(height: AppDim.paddingS),
      Text('ЧТО БУДЕТ ЕСЛИ', style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
      const SizedBox(height: AppDim.paddingM),
      _SimCard(icon: Icons.price_change_outlined, title: 'Изменю цену', subtitle: 'Рассчитать как изменится прибыль', color: AppColors.primary),
      const SizedBox(height: AppDim.paddingS),
      _SimCard(icon: Icons.shopping_cart_outlined, title: 'Увеличу закуп', subtitle: 'Сколько денег нужно и что вернётся', color: AppColors.statusOk),
      const SizedBox(height: AppDim.paddingS),
      _SimCard(icon: Icons.inventory_2_outlined, title: 'Риск отсутствия товара', subtitle: 'Когда закончится и сколько потеряем', color: AppColors.statusLow),
      const SizedBox(height: AppDim.paddingS),
      _SimCard(icon: Icons.trending_down_outlined, title: 'Падение продаж', subtitle: 'Анализ устойчивости при −20% выручки', color: AppColors.statusCritical),
      const SizedBox(height: AppDim.paddingS),
      _SimCard(icon: Icons.warehouse_outlined, title: 'Переполнение склада', subtitle: 'Когда товар залёживается', color: AppColors.movementAdjustment),
    ],
  );
}

class _SimCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  const _SimCard({required this.icon, required this.title, required this.subtitle, required this.color});

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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 22),
      ),
      const SizedBox(width: AppDim.paddingM),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
        Text(subtitle, style: AppTextStyles.body2),
      ])),
      Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
    ]),
  );
}

class _AiTab extends StatelessWidget {
  const _AiTab();

  @override
  Widget build(BuildContext context) => const Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.smart_toy_outlined, size: 64, color: AppColors.primary),
      SizedBox(height: 16),
      Text('ИИ-помощник по всей сети', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      SizedBox(height: 8),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Text('Спрашивайте о состоянии сети, сравнении филиалов, рекомендациях',
            textAlign: TextAlign.center),
      ),
    ]),
  );
}
