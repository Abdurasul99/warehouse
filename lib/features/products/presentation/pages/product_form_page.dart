import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/models/category_model.dart';
import '../../../../shared/services/barcode_service.dart';
import '../../../../shared/services/photo_service.dart';
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
  final _photoService = PhotoService();
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

  void _generateBarcode() {
    final products = ref.read(productListProvider).valueOrNull ?? const [];
    final code = BarcodeScannerService.generateUniqueEan13(products);
    setState(() => _barcodeCtrl.text = code);
    ref
        .read(productFormProvider(widget.productId).notifier)
        .update((s) => s.copyWith(barcode: code));
  }

  Future<void> _scanBarcode() async {
    final code = await BarcodeScannerService().scanBarcode(context);
    if (code != null) {
      setState(() => _barcodeCtrl.text = code);
      ref
          .read(productFormProvider(widget.productId).notifier)
          .update((s) => s.copyWith(barcode: code));
    }
  }

  Future<void> _openCreateCategoryDialog() async {
    final uzCtrl = TextEditingController();
    final ruCtrl = TextEditingController();
    final dialogKey = GlobalKey<FormState>();
    final created = await showDialog<CategoryModel>(
      context: context,
      builder: (dctx) => AlertDialog(
        title: Text(dctx.l10n.products_category_add),
        content: Form(
          key: dialogKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: uzCtrl,
                decoration: InputDecoration(
                  labelText: dctx.l10n.products_category_name_uz,
                ),
                validator: (v) => Validators.required(
                  v,
                  message: dctx.l10n.products_error_category_name_required,
                ),
              ),
              const SizedBox(height: AppDim.paddingM),
              TextFormField(
                controller: ruCtrl,
                decoration: InputDecoration(
                  labelText: dctx.l10n.products_category_name_ru,
                ),
                validator: (v) => Validators.required(
                  v,
                  message: dctx.l10n.products_error_category_name_required,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dctx),
            child: Text(dctx.l10n.btn_cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!dialogKey.currentState!.validate()) return;
              final cat = await ref
                  .read(categoryListProvider.notifier)
                  .createCategory(
                    nameUz: uzCtrl.text,
                    nameRu: ruCtrl.text,
                  );
              if (dctx.mounted) Navigator.pop(dctx, cat);
            },
            child: Text(dctx.l10n.btn_save),
          ),
        ],
      ),
    );
    uzCtrl.dispose();
    ruCtrl.dispose();
    if (!mounted) return;
    if (created != null) {
      ref
          .read(productFormProvider(widget.productId).notifier)
          .update((s) => s.copyWith(categoryId: created.id));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.products_category_created)),
      );
    }
  }

  Future<void> _showPhotoPicker() async {
    final hasPhoto = ref
        .read(productFormProvider(widget.productId))
        .photoPath
        .isNotEmpty;
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(sheetCtx.l10n.products_photo_take),
              onTap: () async {
                Navigator.pop(sheetCtx);
                await _pickPhoto(camera: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(sheetCtx.l10n.products_photo_pick),
              onTap: () async {
                Navigator.pop(sheetCtx);
                await _pickPhoto(camera: false);
              },
            ),
            if (hasPhoto)
              ListTile(
                leading: const Icon(Icons.delete_outline,
                    color: AppColors.statusCritical),
                title: Text(
                  sheetCtx.l10n.products_photo_remove,
                  style: const TextStyle(color: AppColors.statusCritical),
                ),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  ref
                      .read(productFormProvider(widget.productId).notifier)
                      .update((s) => s.copyWith(photoPath: ''));
                  setState(() {});
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPhoto({required bool camera}) async {
    final path = camera
        ? await _photoService.pickFromCamera()
        : await _photoService.pickFromGallery();
    if (path == null || !mounted) return;
    ref
        .read(productFormProvider(widget.productId).notifier)
        .update((s) => s.copyWith(photoPath: path));
    setState(() {});
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
            _SectionLabel(context.l10n.products_photo_label),
            const SizedBox(height: AppDim.paddingS),
            _PhotoPicker(
              photoPath: formState.photoPath,
              onTap: _showPhotoPicker,
            ),
            const SizedBox(height: AppDim.paddingL),
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
              data: (cats) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: formState.categoryId.isEmpty
                          ? null
                          : formState.categoryId,
                      decoration: InputDecoration(
                          labelText: context.l10n.products_category_label),
                      hint: Text(context.l10n.products_category_hint),
                      items: cats
                          .map((c) => DropdownMenuItem<String>(
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
                  ),
                  const SizedBox(width: AppDim.paddingS),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: IconButton.filledTonal(
                      tooltip: context.l10n.products_category_add,
                      icon: const Icon(Icons.add),
                      onPressed: _openCreateCategoryDialog,
                    ),
                  ),
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppDim.paddingM),
            TextFormField(
              controller: _skuCtrl,
              decoration: const InputDecoration(labelText: 'SKU'),
              validator: (v) =>
                  Validators.required(v, message: 'SKU majburiy') ??
                  Validators.sku(v),
            ),
            const SizedBox(height: AppDim.paddingM),
            TextFormField(
              controller: _barcodeCtrl,
              decoration: InputDecoration(
                labelText: context.l10n.products_barcode_label,
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: context.l10n.products_barcode_generate,
                      icon: const Icon(Icons.auto_awesome),
                      onPressed: _generateBarcode,
                    ),
                    IconButton(
                      tooltip: context.l10n.products_barcode_scan,
                      icon: const Icon(Icons.qr_code_scanner),
                      onPressed: _scanBarcode,
                    ),
                  ],
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            if (_barcodeCtrl.text.trim().length == 13) ...[
              const SizedBox(height: AppDim.paddingS),
              SizedBox(
                height: 70,
                child: BarcodeWidget(
                  barcode: Barcode.ean13(),
                  data: _barcodeCtrl.text.trim(),
                  drawText: true,
                  errorBuilder: (_, __) => const SizedBox.shrink(),
                ),
              ),
            ],
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
                  child: DropdownButtonFormField<String>(
                    initialValue: ProductUnits.all.contains(formState.unit)
                        ? formState.unit
                        : ProductUnits.all.first,
                    decoration: InputDecoration(
                        labelText: context.l10n.products_unit_label),
                    items: ProductUnits.all
                        .map((u) => DropdownMenuItem<String>(
                              value: u,
                              child: Text(u),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      ref
                          .read(productFormProvider(widget.productId).notifier)
                          .update((s) => s.copyWith(unit: v));
                    },
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

class _PhotoPicker extends StatelessWidget {
  final String photoPath;
  final VoidCallback onTap;
  const _PhotoPicker({required this.photoPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoPath.isNotEmpty;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDim.radiusM),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppDim.radiusM),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.4),
            width: 1.2,
            style: hasPhoto ? BorderStyle.solid : BorderStyle.solid,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        child: hasPhoto
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(photoPath), fit: BoxFit.cover),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_a_photo_outlined,
                      size: 40, color: AppColors.primary),
                  const SizedBox(height: AppDim.paddingS),
                  Text(
                    context.l10n.products_photo_label,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
