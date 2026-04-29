import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/services/barcode_service.dart';
import '../providers/product_form_provider.dart';
import '../providers/product_provider.dart';

class ProductFormPage extends ConsumerWidget {
  final String? productId;
  const ProductFormPage({super.key, this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(productFormProvider(productId));
    final categoriesAsync = ref.watch(categoryListProvider);
    final locale = Localizations.localeOf(context).languageCode;
    final isEdit = productId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit
            ? context.l10n.products_form_title_edit
            : context.l10n.products_form_title_create),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: formState.success
          ? _SuccessView(context: context, isEdit: isEdit)
          : _FormBody(
              productId: productId,
              formState: formState,
              categoriesAsync: categoriesAsync,
              locale: locale,
              ref: ref,
            ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final BuildContext context;
  final bool isEdit;
  const _SuccessView({required this.context, required this.isEdit});

  @override
  Widget build(BuildContext ctx) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline,
              size: 72, color: AppColors.statusOk),
          const SizedBox(height: AppDim.paddingM),
          Text(
            isEdit ? 'Mahsulot yangilandi!' : 'Mahsulot qo\'shildi!',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: AppDim.paddingL),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDim.paddingXL),
            child: ElevatedButton(
              onPressed: () => ctx.goNamed(AppRoutes.productList),
              child: Text(ctx.l10n.products_list_title),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormBody extends ConsumerStatefulWidget {
  final String? productId;
  final ProductFormState formState;
  final AsyncValue categoriesAsync;
  final String locale;
  final WidgetRef ref;

  const _FormBody({
    required this.productId,
    required this.formState,
    required this.categoriesAsync,
    required this.locale,
    required this.ref,
  });

  @override
  ConsumerState<_FormBody> createState() => _FormBodyState();
}

class _FormBodyState extends ConsumerState<_FormBody> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController(text: widget.formState.name);
  late final _skuCtrl = TextEditingController(text: widget.formState.sku);
  late final _barcodeCtrl =
      TextEditingController(text: widget.formState.barcode);
  late final _descCtrl =
      TextEditingController(text: widget.formState.description);
  late final _purchasePriceCtrl =
      TextEditingController(text: widget.formState.purchasePrice);
  late final _sellingPriceCtrl =
      TextEditingController(text: widget.formState.sellingPrice);
  late final _qtyCtrl =
      TextEditingController(text: widget.formState.currentQuantity);
  late final _minQtyCtrl =
      TextEditingController(text: widget.formState.minQuantity);

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _skuCtrl,
      _barcodeCtrl,
      _descCtrl,
      _purchasePriceCtrl,
      _sellingPriceCtrl,
      _qtyCtrl,
      _minQtyCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _syncToProvider() {
    ref
        .read(productFormProvider(widget.productId).notifier)
        .update((s) => s.copyWith(
              name: _nameCtrl.text,
              sku: _skuCtrl.text,
              barcode: _barcodeCtrl.text,
              description: _descCtrl.text,
              purchasePrice: _purchasePriceCtrl.text,
              sellingPrice: _sellingPriceCtrl.text,
              currentQuantity: _qtyCtrl.text,
              minQuantity: _minQtyCtrl.text,
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _syncToProvider();
    await ref.read(productFormProvider(widget.productId).notifier).submit();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(productFormProvider(widget.productId));
    final categoriesAsync = ref.watch(categoryListProvider);
    final locale = Localizations.localeOf(context).languageCode;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDim.paddingM),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (formState.errorMessage != null)
              _ErrorBanner(message: formState.errorMessage!),
            _SectionLabel(context.l10n.products_section_basic),
            const SizedBox(height: AppDim.paddingS),
            TextFormField(
              controller: _nameCtrl,
              decoration:
                  InputDecoration(labelText: context.l10n.products_name_label),
              validator: (v) => Validators.required(v,
                  message: context.l10n.products_error_name_required),
            ),
            const SizedBox(height: AppDim.paddingM),
            categoriesAsync.when(
              data: (cats) => DropdownButtonFormField<String>(
                initialValue:
                    formState.categoryId.isEmpty ? null : formState.categoryId,
                decoration: InputDecoration(
                    labelText: context.l10n.products_category_label),
                hint: Text(context.l10n.products_category_hint),
                items: cats
                    .map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(c.localizedName(locale)),
                        ))
                    .toList(),
                onChanged: (v) => ref
                    .read(productFormProvider(widget.productId).notifier)
                    .update((s) => s.copyWith(categoryId: v ?? '')),
                validator: (v) => v == null || v.isEmpty
                    ? context.l10n.products_error_category_required
                    : null,
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppDim.paddingM),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _skuCtrl,
                    decoration: const InputDecoration(labelText: 'SKU'),
                    validator: (v) =>
                        Validators.required(v, message: 'SKU majburiy') ??
                        Validators.sku(v),
                  ),
                ),
                const SizedBox(width: AppDim.paddingM),
                Expanded(
                  child: TextFormField(
                    controller: _barcodeCtrl,
                    decoration: InputDecoration(
                      labelText: context.l10n.products_barcode_label,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: () async {
                          final code = await BarcodeScannerService()
                              .scanBarcode(context);
                          if (code != null) _barcodeCtrl.text = code;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDim.paddingL),
            _SectionLabel(context.l10n.products_section_pricing),
            const SizedBox(height: AppDim.paddingS),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _purchasePriceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: context.l10n.products_purchase_price_label,
                        suffixText: "so'm"),
                    validator: Validators.price,
                  ),
                ),
                const SizedBox(width: AppDim.paddingM),
                Expanded(
                  child: TextFormField(
                    controller: _sellingPriceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: context.l10n.products_selling_price_label,
                        suffixText: "so'm"),
                    validator: Validators.price,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDim.paddingL),
            _SectionLabel(context.l10n.products_section_stock),
            const SizedBox(height: AppDim.paddingS),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _qtyCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: context.l10n.products_qty_label),
                    validator: (v) =>
                        Validators.positiveInt(v,
                            message: 'Miqdor noto\'g\'ri') ??
                        (int.tryParse(v ?? '') == null ? 'Musbat son' : null),
                  ),
                ),
                const SizedBox(width: AppDim.paddingM),
                Expanded(
                  child: TextFormField(
                    controller: _minQtyCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: context.l10n.products_min_qty_label),
                  ),
                ),
                const SizedBox(width: AppDim.paddingM),
                Expanded(
                  child: TextFormField(
                    initialValue: formState.unit,
                    decoration: InputDecoration(
                        labelText: context.l10n.products_unit_label),
                    onChanged: (v) => ref
                        .read(productFormProvider(widget.productId).notifier)
                        .update((s) => s.copyWith(unit: v)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDim.paddingL),
            _SectionLabel(context.l10n.products_section_details),
            const SizedBox(height: AppDim.paddingS),
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                  labelText: context.l10n.products_description_label),
            ),
            const SizedBox(height: AppDim.paddingXL),
            ElevatedButton(
              onPressed: formState.isSubmitting ? null : _submit,
              child: formState.isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(context.l10n.btn_save),
            ),
            const SizedBox(height: AppDim.paddingM),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTextStyles.label.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDim.paddingM),
      padding: const EdgeInsets.all(AppDim.paddingM),
      decoration: BoxDecoration(
        color: AppColors.statusCritical.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDim.radiusM),
        border:
            Border.all(color: AppColors.statusCritical.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline,
              color: AppColors.statusCritical, size: 18),
          const SizedBox(width: AppDim.paddingS),
          Expanded(
            child: Text(message,
                style: AppTextStyles.body2
                    .copyWith(color: AppColors.statusCritical)),
          ),
        ],
      ),
    );
  }
}
