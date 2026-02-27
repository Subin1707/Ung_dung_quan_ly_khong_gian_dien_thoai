import 'package:flutter/material.dart';

class NutTuyChinh extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;

  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double elevation;
  final EdgeInsets padding;

  const NutTuyChinh({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.backgroundColor = Colors.deepPurple,
    this.textColor = Colors.white,
    this.borderRadius = 15,
    this.elevation = 4,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onPressed,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: onPressed == null
                ? Colors.grey.shade400
                : backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: textColor),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}