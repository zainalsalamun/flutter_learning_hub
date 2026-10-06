import 'package:flutter/material.dart';

class CapstoneMilestone {
  final String id;
  final String title;
  final String description;
  final List<String> keyConcepts;

  const CapstoneMilestone({
    required this.id,
    required this.title,
    required this.description,
    this.keyConcepts = const [],
  });
}

class CapstoneSnippetItem {
  final String title;
  final String filePath;
  final String description;
  final String code;

  const CapstoneSnippetItem({
    required this.title,
    required this.filePath,
    required this.description,
    required this.code,
  });
}

class CapstoneProject {
  final String id;
  final String title;
  final String tagline;
  final String description;
  final String difficulty;
  final String estimatedHours;
  final Color themeColor;
  final IconData icon;
  final List<String> techStack;
  final List<String> architecturePoints;
  final String folderStructureTree;
  final List<CapstoneMilestone> milestones;
  final List<CapstoneSnippetItem> snippets;
  final Widget Function(BuildContext context) liveSimulationBuilder;

  const CapstoneProject({
    required this.id,
    required this.title,
    required this.tagline,
    required this.description,
    required this.difficulty,
    required this.estimatedHours,
    required this.themeColor,
    required this.icon,
    required this.techStack,
    required this.architecturePoints,
    required this.folderStructureTree,
    required this.milestones,
    required this.snippets,
    required this.liveSimulationBuilder,
  });
}
