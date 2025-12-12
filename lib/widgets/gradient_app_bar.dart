import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GradientAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  });

  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      actions: actions,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
        ),
      ),
      foregroundColor: Colors.white,
    );
  }
}
