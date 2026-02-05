import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../core/themes/tenant.dart';

class HomeNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const HomeNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    // Swap bettwen themes
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      // Vertical padding
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        // Background color from theme
        color: theme.scaffoldBackgroundColor,
        
        // Superior border
        border: Border(
          top: BorderSide(
            color: isDark 
                ? Colors.white.withValues(alpha: 0.1) // Dark mode border
                : Colors.grey.withValues(alpha: 0.08), // Light mode border
            width: 1.5,
          ),
        ),
        
        // Shadow only in light mode
        boxShadow: isDark 
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                )
              ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: GNav(
            haptic: true,
            gap: 10, // Gap between Icon and Text
            iconSize: 24,
            
            // Active button design
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            duration: const Duration(milliseconds: 300),
            
            // Inactive button color
            color: theme.hintColor.withValues(alpha: 0.5), 
            
            // Active color -> button and text
            activeColor: tenant.mainColor, 
            
            // Active background -> button color
            tabBackgroundColor: tenant.mainColor.withValues(alpha: 0.1), 
            
            textStyle: TextStyle(
              color: tenant.mainColor, // Text with color brand
              fontFamily: tenant.fontFamily, // Font from tentat
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),

            selectedIndex: selectedIndex,
            onTabChange: onTabChange,

            tabs: const [
              GButton(
                icon: Icons.home_rounded,
                text: 'Início',
              ),
              GButton(
                icon: Icons.chat_bubble_outline_rounded,
                text: 'Chat',
              ),
              GButton(
                icon: Icons.person_outline_rounded,
                text: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}