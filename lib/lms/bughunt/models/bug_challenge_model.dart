import 'package:flutter/material.dart';

enum BugDifficulty {
  easy('Mudah', Color(0xFF10B981), 75),
  medium('Menengah', Color(0xFFF59E0B), 100),
  hard('Sulit', Color(0xFFEF4444), 150);

  final String label;
  final Color color;
  final int defaultXp;

  const BugDifficulty(this.label, this.color, this.defaultXp);
}

enum BugCategory {
  layout('Layout & Constraints', Icons.view_quilt_rounded),
  memory('Memory & Lifecycle', Icons.memory_rounded),
  statePhase('State & Build Phase', Icons.sync_problem_rounded),
  overflow('RenderFlex Overflow', Icons.aspect_ratio_rounded),
  asyncSafety('Async & Null Safety', Icons.safety_check_rounded);

  final String title;
  final IconData icon;

  const BugCategory(this.title, this.icon);
}

class BugFixOption {
  final String id;
  final String description;
  final String modifiedCode;
  final bool isCorrect;
  final String critique;

  const BugFixOption({
    required this.id,
    required this.description,
    required this.modifiedCode,
    required this.isCorrect,
    required this.critique,
  });
}

class BugChallengeModel {
  final String id;
  final String title;
  final String scenario;
  final BugCategory category;
  final BugDifficulty difficulty;
  final int xpReward;
  final String flutterErrorSnippet;
  final String buggyCode;
  final List<BugFixOption> fixOptions;
  final String rootCauseAnalysis;
  final String bestPracticeGuide;
  final String cleanFixedCode;

  const BugChallengeModel({
    required this.id,
    required this.title,
    required this.scenario,
    required this.category,
    required this.difficulty,
    required this.xpReward,
    required this.flutterErrorSnippet,
    required this.buggyCode,
    required this.fixOptions,
    required this.rootCauseAnalysis,
    required this.bestPracticeGuide,
    required this.cleanFixedCode,
  });
}
