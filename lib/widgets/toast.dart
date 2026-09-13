import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/toast_provider.dart';
import '../models/toast.dart';
import '../theme/app_colors.dart';

class ToastOverlay extends StatelessWidget {
  const ToastOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final toasts = context.watch<ToastProvider>().toasts;

    return Positioned(
      left: 16,
      right: 16,
      bottom: MediaQuery.of(context).padding.bottom + 90,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: toasts.map((t) => _ToastItem(toast: t)).toList(),
      ),
    );
  }
}

class _ToastItem extends StatefulWidget {
  final ToastMessage toast;

  const _ToastItem({required this.toast});

  @override
  State<_ToastItem> createState() => _ToastItemState();
}

class _ToastItemState extends State<_ToastItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _bgColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (widget.toast.type) {
      case ToastType.success:
        return isDark
            ? RomanticColors.romantic700
            : RomanticColors.romantic600;
      case ToastType.info:
        return isDark ? const Color(0xFF2A2A2E) : const Color(0xFF3A3A3E);
      case ToastType.error:
        return const Color(0xFFB71C1C);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(_animation),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _bgColor(context),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (widget.toast.type == ToastType.success)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.check_circle, color: Colors.white, size: 18),
                ),
              Expanded(
                child: Text(
                  widget.toast.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    context.read<ToastProvider>().dismiss(widget.toast.id),
                child: const Icon(Icons.close, color: Colors.white70, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
