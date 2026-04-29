import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/models/user_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/widgets/logout_action_button.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user =
        ref.watch(authProvider).maybeWhen(data: (u) => u, orElse: () => null);
    final localeAsync = ref.watch(localeProvider);
    final currentLocale =
        localeAsync.maybeWhen(data: (l) => l.languageCode, orElse: () => 'uz');

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings_title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoutes.dashboard),
        ),
        actions: const [LogoutActionButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDim.paddingM),
        children: [
          if (user != null) _ProfileCard(user: user),
          const SizedBox(height: AppDim.paddingM),
          _SectionCard(
            title: context.l10n.settings_language_label,
            children: [
              _LanguageTile(
                flag: '🇺🇿',
                label: context.l10n.settings_language_uz,
                selected: currentLocale == 'uz',
                onTap: () => ref.read(localeProvider.notifier).setLocale('uz'),
              ),
              const Divider(height: 1),
              _LanguageTile(
                flag: '🇷🇺',
                label: context.l10n.settings_language_ru,
                selected: currentLocale == 'ru',
                onTap: () => ref.read(localeProvider.notifier).setLocale('ru'),
              ),
            ],
          ),
          const SizedBox(height: AppDim.paddingM),
          _SectionCard(
            title: context.l10n.settings_app_section,
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(context.l10n.settings_version_label),
                trailing: const Text('1.0.0', style: AppTextStyles.body2),
              ),
            ],
          ),
          const SizedBox(height: AppDim.paddingL),
          OutlinedButton.icon(
            onPressed: () => confirmLogout(context, ref),
            icon: const Icon(Icons.logout, color: AppColors.statusCritical),
            label: Text(context.l10n.settings_btn_logout),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.statusCritical,
              side: const BorderSide(color: AppColors.statusCritical),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final UserModel user;
  const _ProfileCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDim.paddingM),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style:
                    AppTextStyles.heading2.copyWith(color: AppColors.primary),
              ),
            ),
            const SizedBox(width: AppDim.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: AppTextStyles.heading3),
                  Text('@${user.username}', style: AppTextStyles.body2),
                  const SizedBox(height: 2),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDim.radiusRound),
                    ),
                    child: Text(
                      locale == 'ru' ? user.role.labelRu : user.role.labelUz,
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: AppDim.paddingXS, bottom: AppDim.paddingXS),
          child: Text(
            title.toUpperCase(),
            style: AppTextStyles.label.copyWith(color: AppColors.primary),
          ),
        ),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String flag;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _LanguageTile(
      {required this.flag,
      required this.label,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(label, style: AppTextStyles.body1),
      trailing: selected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : const Icon(Icons.radio_button_unchecked,
              color: AppColors.textDisabled),
      onTap: onTap,
    );
  }
}
