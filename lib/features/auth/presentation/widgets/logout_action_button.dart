import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../providers/auth_provider.dart';

class LogoutActionButton extends ConsumerWidget {
  const LogoutActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: context.l10n.settings_btn_logout,
      icon: const Icon(Icons.logout_outlined),
      onPressed: () => confirmLogout(context, ref),
    );
  }
}

Future<void> confirmLogout(BuildContext context, WidgetRef ref) async {
  final confirmed = await ConfirmationDialog.show(
    context,
    title: context.l10n.settings_btn_logout,
    message: context.l10n.settings_logout_confirm,
    confirmLabel: context.l10n.settings_btn_logout,
    cancelLabel: context.l10n.btn_cancel,
    isDestructive: true,
  );

  if (!confirmed) return;

  await ref.read(authProvider.notifier).logout();
  if (context.mounted) {
    context.goNamed(AppRoutes.login);
  }
}
