import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/widgets/logout_action_button.dart';
import '../../../products/presentation/providers/product_provider.dart';
import '../providers/analytics_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/action_required_banner_widget.dart';
import '../widgets/dashboard_card_widget.dart';
import '../widgets/flow_value_row_widget.dart';
import '../widgets/reorder_preview_widget.dart';
import '../widgets/stock_health_pulse_widget.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final statsAsync = ref.watch(dashboardStatsProvider);
    final analyticsAsync = ref.watch(analyticsSummaryProvider);
    final user = authState.maybeWhen(data: (u) => u, orElse: () => null);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(context.l10n.app_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.pushNamed(AppRoutes.settings),
          ),
          const LogoutActionButton(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(analyticsSummaryProvider);
          ref.invalidate(dashboardStatsProvider);
          await ref.read(dashboardStatsProvider.future);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Greeting(userName: user?.name)),
            SliverToBoxAdapter(
              child: statsAsync.when(
                data: (stats) => _StatsCard(stats: stats),
                loading: () =>
                    const SizedBox(height: 96, child: LoadingWidget()),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppDim.paddingM,
                  AppDim.paddingL, AppDim.paddingM, AppDim.paddingS),
              sliver: SliverToBoxAdapter(
                child: Text(
                  context.l10n.analytics_section_title,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: analyticsAsync.when(
                data: (a) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDim.paddingM),
                  child: Column(
                    children: [
                      StockHealthPulseWidget(
                        health: a.health,
                        slowMoverCount: a.slowMoverCount,
                      ),
                      const SizedBox(height: AppDim.paddingM),
                      ActionRequiredBannerWidget(
                        count: a.criticalItems.length,
                        onTap: () {
                          ref
                              .read(productFilterProvider.notifier)
                              .setLowStock(true);
                          context.pushNamed(AppRoutes.productList);
                        },
                      ),
                      const SizedBox(height: AppDim.paddingM),
                      FlowValueRowWidget(
                        flow: a.todayFlow,
                        inventoryValue: a.inventoryValue,
                      ),
                      const SizedBox(height: AppDim.paddingM),
                      ReorderPreviewWidget(items: a.reorderQueue),
                    ],
                  ),
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.all(AppDim.paddingM),
                  child: SizedBox(height: 80, child: LoadingWidget()),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppDim.paddingM,
                  AppDim.paddingL, AppDim.paddingM, AppDim.paddingS),
              sliver: SliverToBoxAdapter(
                child: Text(
                  context.l10n.dashboard_subtitle,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppDim.paddingM, 0,
                  AppDim.paddingM, AppDim.paddingL),
              sliver: SliverGrid(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppDim.paddingM,
                  crossAxisSpacing: AppDim.paddingM,
                  childAspectRatio: 1.05,
                ),
                delegate: SliverChildListDelegate(
                  _buildCards(context, statsAsync.valueOrNull),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCards(BuildContext context, DashboardStats? stats) {
    return [
      DashboardCard(
        icon: Icons.inventory_2_outlined,
        title: context.l10n.dashboard_card_products,
        subtitle:
            stats != null ? '${stats.totalProducts} ta' : null,
        color: AppColors.primary,
        onTap: () => context.pushNamed(AppRoutes.productList),
      ),
      DashboardCard(
        icon: Icons.add_box_outlined,
        title: context.l10n.dashboard_card_add_product,
        color: AppColors.primaryLight,
        onTap: () => context.pushNamed(AppRoutes.productCreate),
      ),
      DashboardCard(
        icon: Icons.arrow_circle_down_outlined,
        title: context.l10n.dashboard_card_stock_in,
        color: AppColors.movementIn,
        onTap: () => context.pushNamed(AppRoutes.stockIn),
      ),
      DashboardCard(
        icon: Icons.arrow_circle_up_outlined,
        title: context.l10n.dashboard_card_stock_out,
        color: AppColors.movementOut,
        onTap: () => context.pushNamed(AppRoutes.stockOut),
      ),
      DashboardCard(
        icon: Icons.fact_check_outlined,
        title: context.l10n.dashboard_card_inventory,
        color: AppColors.movementAdjustment,
        onTap: () => context.pushNamed(AppRoutes.inventory),
      ),
      DashboardCard(
        icon: Icons.history_outlined,
        title: context.l10n.dashboard_card_history,
        color: AppColors.accent,
        onTap: () => context.pushNamed(AppRoutes.movements),
      ),
      DashboardCard(
        icon: Icons.auto_awesome,
        title: context.l10n.dashboard_card_assistant,
        color: AppColors.movementTransfer,
        onTap: () => context.pushNamed(AppRoutes.assistant),
      ),
      DashboardCard(
        icon: Icons.settings_outlined,
        title: context.l10n.dashboard_card_settings,
        color: AppColors.textSecondary,
        onTap: () => context.pushNamed(AppRoutes.settings),
      ),
    ];
  }
}

class _Greeting extends StatelessWidget {
  final String? userName;
  const _Greeting({this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppDim.paddingM, AppDim.paddingS, AppDim.paddingM, AppDim.paddingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.dashboard_greeting(userName ?? ''),
            style: AppTextStyles.heading1,
          ),
          const SizedBox(height: 2),
          Text(
            context.l10n.dashboard_subtitle,
            style: AppTextStyles.body1
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final DashboardStats stats;
  const _StatsCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDim.paddingM),
      child: Container(
        padding: const EdgeInsets.all(AppDim.paddingM),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppDim.radiusL),
        ),
        child: Row(
          children: [
            _HeroStat(
              label: context.l10n.dashboard_stat_total,
              value: stats.totalProducts.toString(),
              isPrimary: true,
            ),
            Container(
              width: 1,
              height: 48,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            _HeroStat(
              label: context.l10n.dashboard_stat_low,
              value: stats.lowStockCount.toString(),
              isPrimary: false,
            ),
            Container(
              width: 1,
              height: 48,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            _HeroStat(
              label: context.l10n.dashboard_stat_out,
              value: stats.outOfStockCount.toString(),
              isPrimary: false,
            ),
            Container(
              width: 1,
              height: 48,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            _HeroStat(
              label: context.l10n.dashboard_stat_today,
              value: stats.todayMovements.toString(),
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String label;
  final String value;
  final bool isPrimary;
  const _HeroStat({
    required this.label,
    required this.value,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: isPrimary ? 24 : 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.85),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
