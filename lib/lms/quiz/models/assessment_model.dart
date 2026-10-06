import 'package:flutter/material.dart';

enum QuestionDifficulty {
  beginner,
  intermediate,
  advanced,
}

class AssessmentQuestion {
  final String id;
  final String question;
  final String? codeSnippet;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String topic;
  final QuestionDifficulty difficulty;

  const AssessmentQuestion({
    required this.id,
    required this.question,
    this.codeSnippet,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.topic,
    this.difficulty = QuestionDifficulty.intermediate,
  });
}

class AssessmentTrackModel {
  final String id;
  final String trackId;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final int passingScore; // e.g. 70 (%)
  final int rewardXp; // e.g. 150
  final int timeLimitMinutes;
  final List<AssessmentQuestion> questions;

  const AssessmentTrackModel({
    required this.id,
    required this.trackId,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    this.passingScore = 70,
    this.rewardXp = 150,
    this.timeLimitMinutes = 10,
    required this.questions,
  });
}

class AssessmentSubmission {
  final String assessmentId;
  final Map<int, int> userAnswers; // questionIndex -> selectedOptionIndex
  final int scorePercentage;
  final int correctCount;
  final int totalCount;
  final bool isPassed;
  final DateTime completedAt;

  const AssessmentSubmission({
    required this.assessmentId,
    required this.userAnswers,
    required this.scorePercentage,
    required this.correctCount,
    required this.totalCount,
    required this.isPassed,
    required this.completedAt,
  });
}
