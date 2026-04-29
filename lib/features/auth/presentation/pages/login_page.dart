import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _errorMessage = null);

    final success = await ref
        .read(authProvider.notifier)
        .login(_usernameController.text.trim(), _passwordController.text.trim());

    if (!mounted) return;
    if (success) {
      context.goNamed(AppRoutes.dashboard);
    } else {
      setState(() => _errorMessage = context.l10n.auth_error_invalid_credentials);
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
              const SizedBox(height: 48),
              _buildHeader(context),
              const SizedBox(height: AppDim.paddingXL),
              _buildForm(isLoading),
              if (_errorMessage != null) ...[
                const SizedBox(height: AppDim.paddingM),
                _buildErrorBanner(),
              ],
              const SizedBox(height: AppDim.paddingL),
              _buildLoginButton(isLoading),
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
          child: const Icon(Icons.warehouse_rounded, size: 48, color: Colors.white),
        ),
        const SizedBox(height: AppDim.paddingM),
        Text(context.l10n.app_title, style: AppTextStyles.heading1),
        const SizedBox(height: AppDim.paddingXS),
        Text(
          context.l10n.auth_login_subtitle,
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
            validator: (v) =>
                v == null || v.trim().isEmpty ? context.l10n.auth_error_field_required : null,
          ),
        ],
      ),
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

  Widget _buildLoginButton(bool isLoading) {
    return ElevatedButton(
      onPressed: isLoading ? null : _submit,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : Text(context.l10n.auth_btn_login),
    );
  }
}
