import 'package:flutter/material.dart';

enum SandboxCategory {
  layout(title: 'Layout & Box', icon: Icons.crop_square_rounded, color: Color(0xFF0284C7)),
  flex(title: 'Flex & Alignment', icon: Icons.view_column_rounded, color: Color(0xFF6366F1)),
  lifecycle(title: 'State & Lifecycle', icon: Icons.loop_rounded, color: Color(0xFF10B981)),
  painter(title: 'Custom Canvas', icon: Icons.brush_rounded, color: Color(0xFF8B5CF6)),
  asyncLogic(title: 'Async & Timeline', icon: Icons.schedule_rounded, color: Color(0xFFF59E0B)),
  oopData(title: 'Dart OOP & Model', icon: Icons.data_object_rounded, color: Color(0xFFEC4899));

  final String title;
  final IconData icon;
  final Color color;

  const SandboxCategory({
    required this.title,
    required this.icon,
    required this.color,
  });
}

class SandboxPreset {
  final String id;
  final String title;
  final String subtitle;
  final SandboxCategory category;
  final IconData icon;
  final Map<String, dynamic> initialParameters;
  final String Function(Map<String, dynamic> params) codeGenerator;
  final List<String> Function(Map<String, dynamic> params) consoleOutputGenerator;
  final Widget Function(BuildContext context, Map<String, dynamic> params) visualWidgetBuilder;

  const SandboxPreset({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.icon,
    required this.initialParameters,
    required this.codeGenerator,
    required this.consoleOutputGenerator,
    required this.visualWidgetBuilder,
  });
}
