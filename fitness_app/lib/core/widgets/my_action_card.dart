import 'package:flutter/material.dart';

class MyActionCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? imageAsset;
  final Color color;
  final VoidCallback onTap;

  const MyActionCard({
    super.key,
    required this.title,
    this.icon,
    this.imageAsset,
    required this.color,
    required this.onTap,
  }) : assert(icon != null || imageAsset != null, 'Imagem ou Icone obrigatório');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: theme.cardColor, // or theme.colorScheme.surface
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 150,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.08),
            ),
            // Shadow removed -> dark mode 
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 50,
                width: 50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: _buildIconOrImage(),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconOrImage() {
    if (imageAsset != null) {
      return Image.asset(
        imageAsset!,
        fit: BoxFit.contain,
        //color : color,
      );
    }
    else if (icon != null) {
      return Icon(
        icon!,
        color: color,
        size: 24,
      );
    }
    else {
      return const SizedBox();
    }
  }
}
