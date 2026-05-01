import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../providers/assistant_provider.dart';

class AssistantPage extends ConsumerStatefulWidget {
  const AssistantPage({super.key});

  @override
  ConsumerState<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends ConsumerState<AssistantPage> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    _controller.clear();
    final locale = Localizations.localeOf(context).languageCode;
    await ref.read(assistantProvider.notifier).send(text, locale: locale);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(assistantProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.assistant_title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (state.messages.isNotEmpty)
            IconButton(
              tooltip: context.l10n.assistant_clear,
              icon: const Icon(Icons.delete_outline),
              onPressed: () =>
                  ref.read(assistantProvider.notifier).clear(),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: state.messages.isEmpty
                ? _EmptyState()
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.all(AppDim.paddingM),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final m = state.messages[index];
                      return _Bubble(
                        text: m.content,
                        isUser: m.role == 'user',
                      );
                    },
                  ),
          ),
          if (state.error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDim.paddingS),
              color: AppColors.statusCritical.withValues(alpha: 0.12),
              child: Text(
                state.error!,
                style: AppTextStyles.body2
                    .copyWith(color: AppColors.statusCritical),
              ),
            ),
          if (state.isSending)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppDim.paddingS),
              child: SizedBox(
                height: 2,
                child: LinearProgressIndicator(),
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDim.paddingS),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      maxLines: 4,
                      minLines: 1,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: context.l10n.assistant_input_hint,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppDim.radiusL),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppDim.paddingM,
                          vertical: AppDim.paddingS,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDim.paddingS),
                  IconButton.filled(
                    onPressed: state.isSending ? null : _send,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final String text;
  final bool isUser;
  const _Bubble({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final bg = isUser
        ? AppColors.primary
        : AppColors.primary.withValues(alpha: 0.08);
    final fg = isUser ? Colors.white : AppColors.textPrimary;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        margin: const EdgeInsets.symmetric(vertical: AppDim.paddingXS),
        padding: const EdgeInsets.all(AppDim.paddingM),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppDim.radiusL),
            topRight: const Radius.circular(AppDim.radiusL),
            bottomLeft: Radius.circular(isUser ? AppDim.radiusL : 4),
            bottomRight: Radius.circular(isUser ? 4 : AppDim.radiusL),
          ),
        ),
        child: SelectableText(
          text,
          style: AppTextStyles.body1.copyWith(color: fg),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final suggestions = [
      context.l10n.assistant_suggestion_low_stock,
      context.l10n.assistant_suggestion_recommendations,
      context.l10n.assistant_suggestion_top_categories,
    ];
    return Padding(
      padding: const EdgeInsets.all(AppDim.paddingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.auto_awesome,
            color: AppColors.primary.withValues(alpha: 0.4),
            size: 64,
          ),
          const SizedBox(height: AppDim.paddingM),
          Text(
            context.l10n.assistant_welcome_title,
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDim.paddingS),
          Text(
            context.l10n.assistant_welcome_subtitle,
            style: AppTextStyles.body2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDim.paddingL),
          for (final s in suggestions)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDim.paddingS),
              child: _SuggestionChip(text: s),
            ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends ConsumerWidget {
  final String text;
  const _SuggestionChip({required this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDim.radiusM),
      onTap: () {
        final locale = Localizations.localeOf(context).languageCode;
        ref.read(assistantProvider.notifier).send(text, locale: locale);
      },
      child: Container(
        padding: const EdgeInsets.all(AppDim.paddingM),
        decoration: BoxDecoration(
          border:
              Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(AppDim.radiusM),
          color: AppColors.primary.withValues(alpha: 0.04),
        ),
        child: Row(
          children: [
            const Icon(Icons.tips_and_updates_outlined,
                size: 18, color: AppColors.primary),
            const SizedBox(width: AppDim.paddingS),
            Expanded(
              child: Text(text, style: AppTextStyles.body2),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
