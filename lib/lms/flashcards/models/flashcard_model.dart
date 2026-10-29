import 'package:flutter/material.dart';

enum FlashcardCategory {
  architecture(
    title: 'Arsitektur & Render Tree',
    shortLabel: 'Arsitektur',
    icon: Icons.account_tree_rounded,
    color: Color(0xFF0284C7),
  ),
  dartConcurrency(
    title: 'Dart & Asinkronus',
    shortLabel: 'Dart Async',
    icon: Icons.bolt_rounded,
    color: Color(0xFFF59E0B),
  ),
  stateManagement(
    title: 'State Management & Rebuilds',
    shortLabel: 'State Mgmt',
    icon: Icons.dynamic_feed_rounded,
    color: Color(0xFF8B5CF6),
  ),
  performance(
    title: 'Performa, Memori & Profiling',
    shortLabel: 'Performa',
    icon: Icons.speed_rounded,
    color: Color(0xFF10B981),
  ),
  platformNative(
    title: 'Platform Channel & Native',
    shortLabel: 'Native & FFI',
    icon: Icons.devices_other_rounded,
    color: Color(0xFF6366F1),
  ),
  interviewGotchas(
    title: 'Gotchas & Anti-Patterns',
    shortLabel: 'Gotchas',
    icon: Icons.warning_amber_rounded,
    color: Color(0xFFEF4444),
  );

  final String title;
  final String shortLabel;
  final IconData icon;
  final Color color;

  const FlashcardCategory({
    required this.title,
    required this.shortLabel,
    required this.icon,
    required this.color,
  });
}

enum FlashcardDifficulty {
  junior(
    label: 'Junior',
    color: Color(0xFF10B981),
    xp: 10,
  ),
  mid(
    label: 'Mid-Level',
    color: Color(0xFFF59E0B),
    xp: 15,
  ),
  senior(
    label: 'Senior',
    color: Color(0xFFEF4444),
    xp: 25,
  );

  final String label;
  final Color color;
  final int xp;

  const FlashcardDifficulty({
    required this.label,
    required this.color,
    required this.xp,
  });
}

class FlashcardItem {
  final String id;
  final String question;
  final FlashcardCategory category;
  final FlashcardDifficulty difficulty;
  final String keyConcept;
  final String detailedAnswer;
  final String? codeSnippet;
  final String interviewerTips;
  final List<String> tags;

  const FlashcardItem({
    required this.id,
    required this.question,
    required this.category,
    required this.difficulty,
    required this.keyConcept,
    required this.detailedAnswer,
    this.codeSnippet,
    required this.interviewerTips,
    required this.tags,
  });
}
