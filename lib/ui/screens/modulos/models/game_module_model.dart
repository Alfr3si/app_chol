import 'package:flutter/material.dart';

class GameModuleCardData {
  final String title;
  final String subtitle;
  final String chokName;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  GameModuleCardData({
    required this.title,
    required this.subtitle,
    required this.chokName,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
  });
}
