import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:vama_mobile/theme/light_theme.dart';


class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: LightTheme.text, 
      unselectedItemColor: LightTheme.textSecondary, 
      items: const [
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.home),
          label: 'Glowna',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.users),
          label: 'Subskrypcje',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.plusCircle),
          label: 'Dodaj Artykuł',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.heart),
          label: 'Polubione',
        ),
      ],
    );
  }
}
