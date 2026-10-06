import 'dart:convert';

class UserProgress {
  final Set<String> completedLessonIds;
  final Set<String> bookmarkedLessonIds;
  final Set<String> bookmarkedWidgetIds;
  final Set<String> completedCapstoneIds;
  final Map<String, String> lessonNotes;
  final Map<String, int> quizScores;
  final int earnedXp;
  final int streakDays;
  final DateTime? lastActiveDate;
  final String studentName;
  final String? certificateId;
  final DateTime? certificateIssuedDate;

  const UserProgress({
    this.completedLessonIds = const {},
    this.bookmarkedLessonIds = const {},
    this.bookmarkedWidgetIds = const {},
    this.completedCapstoneIds = const {},
    this.lessonNotes = const {},
    this.quizScores = const {},
    this.earnedXp = 0,
    this.streakDays = 1,
    this.lastActiveDate,
    this.studentName = 'Flutter Engineer',
    this.certificateId,
    this.certificateIssuedDate,
  });

  /// Calculate level based on XP (every 150 XP increases 1 level)
  int get currentLevel => (earnedXp ~/ 150) + 1;

  int get currentLevelBaseXp => (currentLevel - 1) * 150;
  int get nextLevelTargetXp => currentLevel * 150;

  double get levelProgressFraction {
    final progressInLevel = earnedXp - currentLevelBaseXp;
    return (progressInLevel / 150.0).clamp(0.0, 1.0);
  }

  int get xpNeededForNextLevel => nextLevelTargetXp - earnedXp;

  String get levelTitle {
    switch (currentLevel) {
      case 1:
        return 'Flutter Novice';
      case 2:
        return 'Dart Apprentice';
      case 3:
        return 'Widget Builder';
      case 4:
        return 'Layout Craftsman';
      case 5:
        return 'State Architect';
      case 6:
        return 'Reactive Specialist';
      case 7:
        return 'Canvas Alchemist';
      case 8:
        return 'Ecosystem Engineer';
      case 9:
        return 'Senior Flutterist';
      default:
        return 'Flutter Grandmaster';
    }
  }

  UserProgress copyWith({
    Set<String>? completedLessonIds,
    Set<String>? bookmarkedLessonIds,
    Set<String>? bookmarkedWidgetIds,
    Set<String>? completedCapstoneIds,
    Map<String, String>? lessonNotes,
    Map<String, int>? quizScores,
    int? earnedXp,
    int? streakDays,
    DateTime? lastActiveDate,
    String? studentName,
    String? certificateId,
    DateTime? certificateIssuedDate,
  }) {
    return UserProgress(
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      bookmarkedLessonIds: bookmarkedLessonIds ?? this.bookmarkedLessonIds,
      bookmarkedWidgetIds: bookmarkedWidgetIds ?? this.bookmarkedWidgetIds,
      completedCapstoneIds: completedCapstoneIds ?? this.completedCapstoneIds,
      lessonNotes: lessonNotes ?? this.lessonNotes,
      quizScores: quizScores ?? this.quizScores,
      earnedXp: earnedXp ?? this.earnedXp,
      streakDays: streakDays ?? this.streakDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      studentName: studentName ?? this.studentName,
      certificateId: certificateId ?? this.certificateId,
      certificateIssuedDate: certificateIssuedDate ?? this.certificateIssuedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'completedLessonIds': completedLessonIds.toList(),
      'bookmarkedLessonIds': bookmarkedLessonIds.toList(),
      'bookmarkedWidgetIds': bookmarkedWidgetIds.toList(),
      'completedCapstoneIds': completedCapstoneIds.toList(),
      'lessonNotes': lessonNotes,
      'quizScores': quizScores,
      'earnedXp': earnedXp,
      'streakDays': streakDays,
      'lastActiveDate': lastActiveDate?.toIso8601String(),
      'studentName': studentName,
      'certificateId': certificateId,
      'certificateIssuedDate': certificateIssuedDate?.toIso8601String(),
    };
  }

  factory UserProgress.fromMap(Map<String, dynamic> map) {
    return UserProgress(
      completedLessonIds: Set<String>.from(map['completedLessonIds'] ?? []),
      bookmarkedLessonIds: Set<String>.from(map['bookmarkedLessonIds'] ?? []),
      bookmarkedWidgetIds: Set<String>.from(map['bookmarkedWidgetIds'] ?? []),
      completedCapstoneIds: Set<String>.from(map['completedCapstoneIds'] ?? []),
      lessonNotes: Map<String, String>.from(map['lessonNotes'] ?? {}),
      quizScores: Map<String, int>.from(map['quizScores'] ?? {}),
      earnedXp: (map['earnedXp'] as num?)?.toInt() ?? 0,
      streakDays: (map['streakDays'] as num?)?.toInt() ?? 1,
      lastActiveDate: map['lastActiveDate'] != null
          ? DateTime.tryParse(map['lastActiveDate'] as String)
          : null,
      studentName: (map['studentName'] as String?) ?? 'Flutter Engineer',
      certificateId: map['certificateId'] as String?,
      certificateIssuedDate: map['certificateIssuedDate'] != null
          ? DateTime.tryParse(map['certificateIssuedDate'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProgress.fromJson(String source) =>
      UserProgress.fromMap(json.decode(source) as Map<String, dynamic>);
}
