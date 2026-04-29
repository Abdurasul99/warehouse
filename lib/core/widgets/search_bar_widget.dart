import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class AppSearchBar extends StatefulWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final Duration debounce;

  const AppSearchBar({
    super.key,
    required this.hint,
    required this.onChanged,
    this.debounce = const Duration(milliseconds: 300),
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  final _controller = TextEditingController();
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _timer?.cancel();
    _timer = Timer(widget.debounce, () => widget.onChanged(value));
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: AppDim.iconSizeS),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppDim.paddingM, vertical: 12),
      ),
    );
  }
}
