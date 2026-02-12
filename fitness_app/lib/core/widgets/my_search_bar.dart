import 'package:flutter/material.dart';
import 'my_text_field.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onChanged;
  final bool enabled;

  const MySearchBar({
    super.key,
    required this.controller,
    this.hintText = "Pesquisar...",
    this.padding,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding 24 R&L and 12B&T
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: MyTextField(
        controller: controller,
        label: hintText,
        prefixIcon: Icons.search,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        enabled: enabled,
      ),
    );
  }
}