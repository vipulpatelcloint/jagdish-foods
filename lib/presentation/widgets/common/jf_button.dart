// lib/presentation/widgets/common/jf_button.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class JFButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isOutlined;
  final Color? bgColor;
  final Color? fgColor;
  final double height;

  const JFButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.isLoading = false,
    this.isOutlined = false,
    this.bgColor,
    this.fgColor,
    this.height = 52,
  });

  const JFButton.outline({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.isLoading = false,
    this.bgColor,
    this.fgColor,
    this.height = 52,
  }) : isOutlined = true;

  @override
  State<JFButton> createState() => _JFButtonState();
}

class _JFButtonState extends State<JFButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.bgColor ?? (widget.isOutlined ? Colors.transparent : AppColors.primary);
    final fgColor = widget.fgColor ?? (widget.isOutlined ? AppColors.primary : Colors.white);

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) { _controller.reverse(); widget.onTap?.call(); },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: widget.isOutlined ? Border.all(color: AppColors.primary, width: 2) : null,
            boxShadow: widget.isOutlined ? null : AppColors.primaryShadow,
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 22, height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation(fgColor),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: fgColor, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Text(widget.label, style: AppTextStyles.buttonLarge.copyWith(color: fgColor)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// Shimmer loader widget
class JFShimmer extends StatelessWidget {
  final double width, height;
  final double radius;
  const JFShimmer({super.key, required this.width, required this.height, this.radius = 8});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, height: height,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// No internet widget
class NoInternetWidget extends StatelessWidget {
  final VoidCallback onRetry;
  const NoInternetWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('📶', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          const Text('No Internet Connection',
              style: TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textDark)),
          const SizedBox(height: 8),
          const Text('Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'DMSans', fontSize: 13, color: AppColors.textMedium)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ]),
      ),
    );
  }
}
