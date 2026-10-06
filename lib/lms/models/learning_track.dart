import 'package:flutter/material.dart';
import '../../fundamentals/models/fundamental_module.dart';

/// Represents a career-oriented learning pathway in Flutter LMS
class LearningTrack {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final List<FundamentalModule> includedModules;

  const LearningTrack({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.includedModules,
  });
}
