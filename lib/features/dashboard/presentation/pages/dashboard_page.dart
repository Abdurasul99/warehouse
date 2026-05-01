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
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_card_widget.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final statsAsync = ref.watch(dashboardStatsProvider);
    final user = authState.maybeWhen(data: (u) => u, orElse: () => null);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(context.l10n.app_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.goNamed(AppRoutes.settings),
          ),
          const LogoutActionButton(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(dashboardStatsProvider.future),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context, user?.name)),
            SliverToBoxAdapter(
              child: statsAsync.when(
                data: (stats) => _buildStatsRow(context, stats),
                loading: () =>
                    const SizedBox(height: 80, child: LoadingWidget()),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                  AppDim.paddingM, 0, AppDim.paddingM, AppDim.paddingM),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppDim.paddingM,
                  crossAxisSpacing: AppDim.paddingM,
                  childAspectRatio: 1.2,
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

  Widget _buildHeader(BuildContext context, String? userName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppDim.paddingM, AppDim.paddingM, AppDim.paddingM, AppDim.paddingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.dashboard_greeting(userName ?? ''),
            style: AppTextStyles.heading2,
          ),
          Text(context.l10n.dashboard_subtitle, style: AppTextStyles.body2),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, DashboardStats stats) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDim.paddingM, vertical: AppDim.paddingS),
      child: Row(
        children: [
          _StatChip(
            label: context.l10n.dashboard_stat_total,
            value: stats.totalProducts.toString(),
            color: AppColors.primary,
          ),
          const SizedBox(width: AppDim.paddingS),
          _StatChip(
            label: context.l10n.dashboard_stat_low,
            value: stats.lowStockCount.toString(),
            color: AppColors.statusLow,
          ),
          const SizedBox(width: AppDim.paddingS),
          _StatChip(
            label: context.l10n.dashboard_stat_out,
            value: stats.outOfStockCount.toString(),
            color: AppColors.statusCritical,
          ),
          const SizedBox(width: AppDim.paddingS),
          _StatChip(
            label: context.l10n.dashboard_stat_today,
            value: stats.todayMovements.toString(),
            color: AppColors.movementIn,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCards(BuildContext context, DashboardStats? stats) {
    return [
      DashboardCard(
        icon: Icons.inventory_2_outlined,
        title: context.l10n.dashboard_card_products,
        subtitle: stats != null ? '${stats.totalProducts} ta' : null,
        color: AppColors.primary,
        onTap: () => context.goNamed(AppRoutes.productList),
      ),
      DashboardCard(
        icon: Icons.add_box_outlined,
        title: context.l10n.dashboard_card_add_product,
        color: AppColors.primaryLight,
        onTap: () => context.goNamed(AppRoutes.productCreate),
      ),
      DashboardCard(
        icon: Icons.arrow_circle_down_outlined,
        title: context.l10n.dashboard_card_stock_in,
        color: AppColors.movementIn,
        onTap: () => context.goNamed(AppRoutes.stockIn),
      ),
      DashboardCard(
        icon: Icons.arrow_circle_up_outlined,
        title: context.l10n.dashboard_card_stock_out,
        color: AppColors.movementOut,
        onTap: () => context.goNamed(AppRoutes.stockOut),
      ),
      DashboardCard(
        icon: Icons.fact_check_outlined,
        title: context.l10n.dashboard_card_inventory,
        color: AppColors.movementAdjustment,
        onTap: () => context.goNamed(AppRoutes.inventory),
      ),
      DashboardCard(
        icon: Icons.history_outlined,
        title: context.l10n.dashboard_card_history,
        color: AppColors.accent,
        onTap: () => context.goNamed(AppRoutes.movements),
      ),
      DashboardCard(
        icon: Icons.auto_awesome,
        title: context.l10n.dashboard_card_assistant,
        color: AppColors.movementIn,
        onTap: () => context.goNamed(AppRoutes.assistant),
      ),
      DashboardCard(
        icon: Icons.settings_outlined,
        title: context.l10n.dashboard_card_settings,
        color: AppColors.textSecondary,
        onTap: () => context.goNamed(AppRoutes.settings),
      ),
    ];
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: AppDim.paddingS, horizontal: AppDim.paddingXS),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDim.radiusM),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(value,
                style: AppTextStyles.heading3
                    .copyWith(color: color, fontSize: 18)),
            Text(label,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
