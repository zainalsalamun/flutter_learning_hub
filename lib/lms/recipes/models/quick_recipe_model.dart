import 'package:flutter/material.dart';

enum RecipeCategory {
  dart3Patterns(
    title: 'Dart 3 Patterns & Records',
    shortLabel: 'Dart 3',
    icon: Icons.psychology_rounded,
    color: Color(0xFF0284C7),
  ),
  dioHttp(
    title: 'Dio HTTP & Interceptors',
    shortLabel: 'Dio & API',
    icon: Icons.cloud_sync_rounded,
    color: Color(0xFF6366F1),
  ),
  jsonSerialization(
    title: 'JSON & Serialization',
    shortLabel: 'JSON',
    icon: Icons.data_object_rounded,
    color: Color(0xFF10B981),
  ),
  asyncEventLoop(
    title: 'Async, Stream & Debounce',
    shortLabel: 'Async & Stream',
    icon: Icons.speed_rounded,
    color: Color(0xFFF59E0B),
  ),
  stateManagement(
    title: 'State Management (Riverpod / BLoC)',
    shortLabel: 'State Mgmt',
    icon: Icons.account_tree_rounded,
    color: Color(0xFF8B5CF6),
  ),
  layoutConstraints(
    title: 'RenderFlex & Constraints Fixes',
    shortLabel: 'Layout Fixes',
    icon: Icons.aspect_ratio_rounded,
    color: Color(0xFFEF4444),
  ),
  localStorage(
    title: 'Local Storage (Prefs & Hive)',
    shortLabel: 'Storage',
    icon: Icons.folder_zip_rounded,
    color: Color(0xFF0D9488),
  ),
  canvasPaths(
    title: 'Custom Canvas & Paths',
    shortLabel: 'Canvas',
    icon: Icons.brush_rounded,
    color: Color(0xFFEC4899),
  );

  final String title;
  final String shortLabel;
  final IconData icon;
  final Color color;

  const RecipeCategory({
    required this.title,
    required this.shortLabel,
    required this.icon,
    required this.color,
  });
}

class QuickRecipe {
  final String id;
  final String title;
  final RecipeCategory category;
  final String description;
  final String codeSnippet;
  final List<String> keyPoints;
  final List<String> tags;
  final String? sandboxPresetId;
  final String? bestPracticeNote;

  const QuickRecipe({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.codeSnippet,
    required this.keyPoints,
    required this.tags,
    this.sandboxPresetId,
    this.bestPracticeNote,
  });
}
