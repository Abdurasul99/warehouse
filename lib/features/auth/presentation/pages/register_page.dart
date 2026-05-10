import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/extensions.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  UserRole _selectedRole = UserRole.salesperson;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _errorMessage = null);

    final username = _usernameController.text.trim();
    if (ref.read(authProvider.notifier).isUsernameTaken(username)) {
      setState(() => _errorMessage = context.l10n.auth_error_username_taken);
      return;
    }

    final locale = ref.read(localeProvider).maybeWhen(
      data: (l) => l.languageCode,
      orElse: () => 'uz',
    );

    await ref.read(authProvider.notifier).register(
          name: _nameController.text.trim(),
          username: username,
          password: _passwordController.text.trim(),
          role: _selectedRole,
          language: locale,
        );

    if (!mounted) return;
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.auth_success_registered)),
      );
      context.goNamed(AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDim.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              _buildHeader(context),
              const SizedBox(height: AppDim.paddingXL),
              _buildForm(isLoading),
              if (_errorMessage != null) ...[
                const SizedBox(height: AppDim.paddingM),
                _buildErrorBanner(),
              ],
              const SizedBox(height: AppDim.paddingL),
              _buildRegisterButton(isLoading),
              const SizedBox(height: AppDim.paddingM),
              _buildLoginLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppDim.radiusXL),
          ),
          child: const Icon(Icons.person_add_rounded, size: 48, color: Colors.white),
        ),
        const SizedBox(height: AppDim.paddingM),
        Text(context.l10n.auth_register_title, style: AppTextStyles.heading1),
        const SizedBox(height: AppDim.paddingXS),
        Text(
          context.l10n.auth_register_subtitle,
          style: AppTextStyles.body2,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            enabled: !isLoading,
            decoration: InputDecoration(
              labelText: context.l10n.auth_name_label,
              hintText: context.l10n.auth_name_hint,
              prefixIcon: const Icon(Icons.badge_outlined),
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? context.l10n.auth_error_name_required : null,
          ),
          const SizedBox(height: AppDim.paddingM),
          TextFormField(
            controller: _usernameController,
            enabled: !isLoading,
            decoration: InputDecoration(
              labelText: context.l10n.auth_username_label,
              hintText: context.l10n.auth_username_hint,
              prefixIcon: const Icon(Icons.person_outline),
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? context.l10n.auth_error_field_required : null,
          ),
          const SizedBox(height: AppDim.paddingM),
          TextFormField(
            controller: _passwordController,
            enabled: !isLoading,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: context.l10n.auth_password_label,
              hintText: context.l10n.auth_password_hint,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return context.l10n.auth_error_field_required;
              if (v.trim().length < 6) return context.l10n.auth_error_password_short;
              return null;
            },
          ),
          const SizedBox(height: AppDim.paddingM),
          TextFormField(
            controller: _confirmPasswordController,
            enabled: !isLoading,
            obscureText: _obscureConfirm,
            decoration: InputDecoration(
              labelText: context.l10n.auth_confirm_password_label,
              hintText: context.l10n.auth_confirm_password_hint,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                ),
                onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return context.l10n.auth_error_field_required;
              if (v.trim() != _passwordController.text.trim()) {
                return context.l10n.auth_error_password_mismatch;
              }
              return null;
            },
          ),
          const SizedBox(height: AppDim.paddingM),
          _buildRoleDropdown(isLoading),
        ],
      ),
    );
  }

  Widget _buildRoleDropdown(bool isLoading) {
    final locale = ref.watch(localeProvider).maybeWhen(
      data: (l) => l.languageCode,
      orElse: () => 'uz',
    );
    return DropdownButtonFormField<UserRole>(
      initialValue: _selectedRole,
      decoration: InputDecoration(
        labelText: context.l10n.auth_role_label,
        prefixIcon: const Icon(Icons.work_outline),
      ),
      items: [
        UserRole.salesperson,
        UserRole.cashierWarehouse,
        UserRole.branchManager,
        UserRole.founder,
      ].map((role) {
        final label = locale == 'ru' ? role.labelRu : role.labelUz;
        return DropdownMenuItem(value: role, child: Text(label));
      }).toList(),
      onChanged: isLoading ? null : (v) => setState(() => _selectedRole = v!),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.all(AppDim.paddingM),
      decoration: BoxDecoration(
        color: AppColors.statusCritical.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDim.radiusM),
        border: Border.all(color: AppColors.statusCritical.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.statusCritical, size: 18),
          const SizedBox(width: AppDim.paddingS),
          Expanded(
            child: Text(
              _errorMessage!,
              style: AppTextStyles.body2.copyWith(color: AppColors.statusCritical),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(bool isLoading) {
    return ElevatedButton(
      onPressed: isLoading ? null : _submit,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : Text(context.l10n.auth_btn_register),
    );
  }

  Widget _buildLoginLink() {
    return TextButton(
      onPressed: () => context.goNamed(AppRoutes.login),
      child: Text(context.l10n.auth_btn_have_account),
    );
  }
}
