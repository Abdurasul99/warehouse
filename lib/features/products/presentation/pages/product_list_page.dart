import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/search_bar_widget.dart';
import '../../../../shared/models/category_model.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card_widget.dart';

class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredProductsProvider);
    final filter = ref.watch(productFilterProvider);
    final categoriesAsync = ref.watch(categoryListProvider);
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.products_list_title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoutes.dashboard),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(AppRoutes.productCreate),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.products_btn_add),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _SearchFilterBar(filter: filter, ref: ref, locale: locale,
              categoriesAsync: categoriesAsync),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(productListProvider.notifier).refresh(),
              child: filteredAsync.when(
                data: (products) {
                  if (products.isEmpty) {
                    return EmptyStateWidget(
                      message: context.l10n.products_empty,
                      icon: Icons.inventory_2_outlined,
                      actionLabel: context.l10n.products_btn_add,
                      onAction: () => context.goNamed(AppRoutes.productCreate),
                    );
                  }
                  final categories = categoriesAsync.maybeWhen(
                      data: (c) => c, orElse: () => <CategoryModel>[]);
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                        AppDim.paddingM, AppDim.paddingS, AppDim.paddingM, 80),
                    itemCount: products.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppDim.paddingS),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        categories: categories,
                        onTap: () => context.goNamed(
                          AppRoutes.productDetail,
                          pathParameters: {'id': product.id},
                        ),
                      );
                    },
                  );
                },
                loading: () => const LoadingWidget(),
                error: (e, _) => AppErrorWidget(
                  message: e.toString(),
                  onRetry: () =>
                      ref.read(productListProvider.notifier).refresh(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchFilterBar extends StatelessWidget {
  final ProductFilter filter;
  final WidgetRef ref;
  final String locale;
  final AsyncValue categoriesAsync;

  const _SearchFilterBar({
    required this.filter,
    required this.ref,
    required this.locale,
    required this.categoriesAsync,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
          AppDim.paddingM, AppDim.paddingS, AppDim.paddingM, 0),
      child: Column(
        children: [
          AppSearchBar(
            hint: context.l10n.products_search_hint,
            onChanged: (q) =>
                ref.read(productFilterProvider.notifier).setSearch(q),
          ),
          const SizedBox(height: AppDim.paddingS),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FilterChip(
                  label: context.l10n.products_filter_category_all,
                  selected: filter.categoryId == null && !filter.lowStockOnly,
                  onTap: () {
                    ref.read(productFilterProvider.notifier).setCategory(null);
                    if (filter.lowStockOnly) {
                      ref.read(productFilterProvider.notifier).toggleLowStock();
                    }
                  },
                ),
                const SizedBox(width: AppDim.paddingXS),
                _FilterChip(
                  label: context.l10n.products_filter_low_stock,
                  selected: filter.lowStockOnly,
                  color: AppColors.statusLow,
                  onTap: () =>
                      ref.read(productFilterProvider.notifier).toggleLowStock(),
                ),
                const SizedBox(width: AppDim.paddingXS),
                ...categoriesAsync.maybeWhen(
                  data: (categories) => categories.map((cat) {
                    final selected = filter.categoryId == cat.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppDim.paddingXS),
                      child: _FilterChip(
                        label: cat.localizedName(locale),
                        selected: selected,
                        onTap: () => ref
                            .read(productFilterProvider.notifier)
                            .setCategory(selected ? null : cat.id),
                      ),
                    );
                  }).toList(),
                  orElse: () => <Widget>[],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDim.paddingS),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDim.radiusRound),
          border: Border.all(
            color: selected ? activeColor : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body2.copyWith(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
