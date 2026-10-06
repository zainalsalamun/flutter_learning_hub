import 'package:flutter/material.dart';

enum BadgeCategory {
  milestone,
  specialist,
  streak,
  quiz,
}

class LmsBadge {
  final String id;
  final String title;
  final String description;
  final String requirement;
  final IconData icon;
  final Color color;
  final BadgeCategory category;

  const LmsBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.requirement,
    required this.icon,
    required this.color,
    this.category = BadgeCategory.milestone,
  });
}
