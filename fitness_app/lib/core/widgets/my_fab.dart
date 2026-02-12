import 'package:flutter/material.dart';

class MyFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const MyFAB({
    super.key,
    required this.onPressed,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton(
      backgroundColor: theme.colorScheme.primary,
      elevation: 4,
      // Consistent rounded design
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onPressed: onPressed,
      child: Icon(icon, color: Colors.white),
    );
  }
}