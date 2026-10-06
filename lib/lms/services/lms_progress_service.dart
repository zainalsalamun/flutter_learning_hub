import 'package:flutter/foundation.dart';
import '../../fundamentals/data/lessons_repository.dart';
import '../../fundamentals/models/fundamental_module.dart';
import '../../fundamentals/models/lesson_item.dart';
import '../data/learning_tracks_data.dart';
import '../data/lms_badges_data.dart';
import '../models/learning_track.dart';
import '../models/lms_badge.dart';
import '../models/user_progress.dart';
import '../quiz/data/assessments_data.dart';
import '../quiz/models/assessment_model.dart';
import 'lms_storage.dart';

class LmsProgressService extends ChangeNotifier {
  static final LmsProgressService instance = LmsProgressService._internal();

  final LmsStorage _storage;
  UserProgress _progress = const UserProgress();
  bool _isInitialized = false;

  LmsProgressService._internal({LmsStorage? storage})
      : _storage = storage ?? LocalFileLmsStorage();

  factory LmsProgressService({LmsStorage? storage}) =>
      LmsProgressService._internal(storage: storage);

  UserProgress get progress => _progress;
  bool get isInitialized => _isInitialized;

  // Shortcut getters
  int get earnedXp => _progress.earnedXp;
  int get currentLevel => _progress.currentLevel;
  String get levelTitle => _progress.levelTitle;
  double get levelProgressFraction => _progress.levelProgressFraction;
  int get xpNeededForNextLevel => _progress.xpNeededForNextLevel;
  int get streakDays => _progress.streakDays;
  int get completedLessonsCount => _progress.completedLessonIds.length;
  int get totalLessonsCount => LessonsRepository.allLessons.length;

  Future<void> init() async {
    if (_isInitialized) return;

    final loaded = await _storage.loadProgress();
    if (loaded != null) {
      _progress = loaded;
    }

    _updateStreakOnActive();
    _isInitialized = true;
    notifyListeners();
  }

  void _updateStreakOnActive() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_progress.lastActiveDate == null) {
      _progress = _progress.copyWith(
        streakDays: 1,
        lastActiveDate: today,
      );
      _storage.saveProgress(_progress);
      return;
    }

    final last = DateTime(
      _progress.lastActiveDate!.year,
      _progress.lastActiveDate!.month,
      _progress.lastActiveDate!.day,
    );

    final differenceInDays = today.difference(last).inDays;

    if (differenceInDays == 1) {
      // Continued streak from yesterday
      _progress = _progress.copyWith(
        streakDays: _progress.streakDays + 1,
        lastActiveDate: today,
      );
      _storage.saveProgress(_progress);
    } else if (differenceInDays > 1) {
      // Streak broken
      _progress = _progress.copyWith(
        streakDays: 1,
        lastActiveDate: today,
      );
      _storage.saveProgress(_progress);
    }
  }

  // =========================================================================
  // LESSON COMPLETION
  // =========================================================================

  bool isLessonCompleted(String lessonId) {
    return _progress.completedLessonIds.contains(lessonId);
  }

  Future<bool> toggleLessonCompleted(String lessonId) async {
    final isDone = isLessonCompleted(lessonId);
    final currentSet = Set<String>.from(_progress.completedLessonIds);

    int newXp = _progress.earnedXp;
    bool markedAsComplete;

    if (isDone) {
      currentSet.remove(lessonId);
      newXp = (newXp - 50).clamp(0, 999999);
      markedAsComplete = false;
    } else {
      currentSet.add(lessonId);
      newXp += 50; // +50 XP per completed lesson
      markedAsComplete = true;
    }

    _progress = _progress.copyWith(
      completedLessonIds: currentSet,
      earnedXp: newXp,
      lastActiveDate: DateTime.now(),
    );

    await _storage.saveProgress(_progress);
    notifyListeners();
    return markedAsComplete;
  }

  // =========================================================================
  // BOOKMARK MANAGEMENT
  // =========================================================================

  bool isLessonBookmarked(String lessonId) {
    return _progress.bookmarkedLessonIds.contains(lessonId);
  }

  Future<bool> toggleLessonBookmark(String lessonId) async {
    final isBookmarked = isLessonBookmarked(lessonId);
    final currentSet = Set<String>.from(_progress.bookmarkedLessonIds);

    if (isBookmarked) {
      currentSet.remove(lessonId);
    } else {
      currentSet.add(lessonId);
    }

    _progress = _progress.copyWith(bookmarkedLessonIds: currentSet);
    await _storage.saveProgress(_progress);
    notifyListeners();
    return !isBookmarked;
  }

  bool isWidgetBookmarked(String widgetId) {
    return _progress.bookmarkedWidgetIds.contains(widgetId);
  }

  Future<bool> toggleWidgetBookmark(String widgetId) async {
    final isBookmarked = isWidgetBookmarked(widgetId);
    final currentSet = Set<String>.from(_progress.bookmarkedWidgetIds);

    if (isBookmarked) {
      currentSet.remove(widgetId);
    } else {
      currentSet.add(widgetId);
    }

    _progress = _progress.copyWith(bookmarkedWidgetIds: currentSet);
    await _storage.saveProgress(_progress);
    notifyListeners();
    return !isBookmarked;
  }

  // =========================================================================
  // NOTES MANAGEMENT
  // =========================================================================

  String? getLessonNote(String lessonId) {
    return _progress.lessonNotes[lessonId];
  }

  Future<void> saveLessonNote(String lessonId, String note) async {
    final newNotes = Map<String, String>.from(_progress.lessonNotes);
    final wasEmpty = !newNotes.containsKey(lessonId) || newNotes[lessonId]!.trim().isEmpty;

    if (note.trim().isEmpty) {
      newNotes.remove(lessonId);
    } else {
      newNotes[lessonId] = note.trim();
    }

    int xp = _progress.earnedXp;
    // Reward note-taking once per lesson (+25 XP)
    if (wasEmpty && note.trim().isNotEmpty) {
      xp += 25;
    }

    _progress = _progress.copyWith(
      lessonNotes: newNotes,
      earnedXp: xp,
    );

    await _storage.saveProgress(_progress);
    notifyListeners();
  }

  // =========================================================================
  // QUIZ PROGRESS
  // =========================================================================

  Future<void> recordQuizCompleted(String lessonId, int score) async {
    final currentScores = Map<String, int>.from(_progress.quizScores);
    final hadPreviousScore = currentScores.containsKey(lessonId);

    currentScores[lessonId] = score;

    int xp = _progress.earnedXp;
    if (!hadPreviousScore) {
      xp += 30; // +30 XP for passing check quiz
    }

    _progress = _progress.copyWith(
      quizScores: currentScores,
      earnedXp: xp,
    );

    await _storage.saveProgress(_progress);
    notifyListeners();
  }

  // =========================================================================
  // ASSESSMENT SUBMISSION & SCORING
  // =========================================================================

  int? getAssessmentScore(String assessmentId) {
    return _progress.quizScores[assessmentId];
  }

  bool isAssessmentPassed(String assessmentId, {int passingScore = 70}) {
    final score = getAssessmentScore(assessmentId);
    return score != null && score >= passingScore;
  }

  int get totalAssessmentsPassed {
    int count = 0;
    for (final assessment in AssessmentsData.allAssessments) {
      if (isAssessmentPassed(assessment.id, passingScore: assessment.passingScore)) {
        count++;
      }
    }
    return count;
  }

  Future<void> recordAssessmentSubmission(
    AssessmentSubmission submission, {
    int rewardXp = 150,
  }) async {
    final currentScores = Map<String, int>.from(_progress.quizScores);
    final previousScore = currentScores[submission.assessmentId];
    final wasPassed = previousScore != null && previousScore >= 70;

    currentScores[submission.assessmentId] = submission.scorePercentage;

    int xp = _progress.earnedXp;
    // Award reward XP only on the first passing submission
    if (submission.isPassed && !wasPassed) {
      xp += rewardXp;
    }

    _progress = _progress.copyWith(
      quizScores: currentScores,
      earnedXp: xp,
      lastActiveDate: DateTime.now(),
    );

    await _storage.saveProgress(_progress);
    notifyListeners();
  }

  // =========================================================================
  // INSPECTOR STUDIO EXPERIMENT
  // =========================================================================

  bool get hasExperimentedWithInspector =>
      _progress.quizScores.containsKey('inspector_experiment');

  Future<void> recordInspectorExperiment() async {
    final hadExperimented = hasExperimentedWithInspector;
    final currentScores = Map<String, int>.from(_progress.quizScores);
    currentScores['inspector_experiment'] = 100;

    int xp = _progress.earnedXp;
    if (!hadExperimented) {
      xp += 50; // +50 XP bonus for using property inspector studio
    }

    _progress = _progress.copyWith(
      quizScores: currentScores,
      earnedXp: xp,
      lastActiveDate: DateTime.now(),
    );

    await _storage.saveProgress(_progress);
    notifyListeners();
  }

  // =========================================================================
  // STUDENT PROFILE & CAPSTONE
  // =========================================================================

  String get studentName => _progress.studentName;

  Future<void> updateStudentName(String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;
    _progress = _progress.copyWith(studentName: trimmed);
    await _storage.saveProgress(_progress);
    notifyListeners();
  }

  Set<String> get completedCapstoneIds => _progress.completedCapstoneIds;

  bool isCapstoneCompleted(String capstoneId) =>
      _progress.completedCapstoneIds.contains(capstoneId);

  Future<void> completeCapstoneProject(
    String capstoneId, {
    int bonusXp = 250,
  }) async {
    final current = Set<String>.from(_progress.completedCapstoneIds);
    final alreadyDone = current.contains(capstoneId);
    current.add(capstoneId);

    int xp = _progress.earnedXp;
    if (!alreadyDone) {
      xp += bonusXp;
    }

    _progress = _progress.copyWith(
      completedCapstoneIds: current,
      earnedXp: xp,
      lastActiveDate: DateTime.now(),
    );

    await _storage.saveProgress(_progress);
    notifyListeners();
  }

  // =========================================================================
  // CERTIFICATE OF COMPLETION
  // =========================================================================

  String? get certificateId => _progress.certificateId;
  DateTime? get certificateIssuedDate => _progress.certificateIssuedDate;
  bool get hasClaimedCertificate => _progress.certificateId != null;

  /// Certificate Eligibility:
  /// 1. Passed all 4 career track assessments (totalAssessmentsPassed >= 4)
  /// 2. Finished at least 18 lessons OR finished at least 1 capstone project
  bool get isEligibleForCertificate {
    return totalAssessmentsPassed >= 4 &&
        (completedLessonsCount >= 18 ||
            _progress.completedCapstoneIds.isNotEmpty);
  }

  Future<String> issueCertificate({String? customStudentName}) async {
    final existingId = _progress.certificateId;
    if (existingId != null) return existingId;

    final now = DateTime.now();
    final randomSuffix = (now.millisecondsSinceEpoch % 100000)
        .toString()
        .padLeft(5, '0');
    final certId = 'FL-LMS-2026-$randomSuffix';

    int xp = _progress.earnedXp + 300; // +300 XP Graduation Bonus

    _progress = _progress.copyWith(
      studentName: customStudentName?.trim().isNotEmpty == true
          ? customStudentName!.trim()
          : _progress.studentName,
      certificateId: certId,
      certificateIssuedDate: now,
      earnedXp: xp,
      lastActiveDate: now,
    );

    await _storage.saveProgress(_progress);
    notifyListeners();
    return certId;
  }

  // =========================================================================
  // METRICS & PROGRESS TRACKING
  // =========================================================================

  double getOverallProgress() {
    if (totalLessonsCount == 0) return 0.0;
    return (completedLessonsCount / totalLessonsCount).clamp(0.0, 1.0);
  }

  double getTrackProgress(LearningTrack track) {
    final trackLessons = LessonsRepository.allLessons
        .where((l) => track.includedModules.contains(l.module))
        .toList();

    if (trackLessons.isEmpty) return 0.0;

    final completedCount = trackLessons
        .where((l) => _progress.completedLessonIds.contains(l.id))
        .length;

    return (completedCount / trackLessons.length).clamp(0.0, 1.0);
  }

  double getModuleProgress(FundamentalModule module) {
    final moduleLessons = LessonsRepository.allLessons
        .where((l) => l.module == module)
        .toList();

    if (moduleLessons.isEmpty) return 0.0;

    final completedCount = moduleLessons
        .where((l) => _progress.completedLessonIds.contains(l.id))
        .length;

    return (completedCount / moduleLessons.length).clamp(0.0, 1.0);
  }

  /// Finds next unfinished lesson in syllabus to guide student
  LessonItem? getNextRecommendedLesson() {
    for (final lesson in LessonsRepository.allLessons) {
      if (!isLessonCompleted(lesson.id)) {
        return lesson;
      }
    }
    return LessonsRepository.allLessons.isNotEmpty
        ? LessonsRepository.allLessons.first
        : null;
  }

  // =========================================================================
  // BADGES EVALUATION
  // =========================================================================

  bool isBadgeUnlocked(String badgeId) {
    switch (badgeId) {
      case 'first_step':
        return completedLessonsCount >= 1;
      case 'foundation_master':
        final foundations = LearningTracksData.allTracks.firstWhere(
          (t) => t.id == 'track_foundations',
        );
        return getTrackProgress(foundations) >= 0.8;
      case 'tree_whisperer':
        return isLessonCompleted('the_three_trees') &&
            isLessonCompleted('widget_lifecycle');
      case 'state_architect':
        return isLessonCompleted('bloc_cubit_patterns') &&
            isLessonCompleted('riverpod_modern_patterns');
      case 'canvas_wizard':
        return isLessonCompleted('custom_painter_canvas_art');
      case 'production_ready':
        return isLessonCompleted('api_rest_dio_interceptors') &&
            (isLessonCompleted('unit_testing_mocktail') ||
                isLessonCompleted('widget_integration_testing'));
      case 'note_taker':
        return _progress.lessonNotes.length >= 3;
      case 'streak_warrior':
        return _progress.streakDays >= 3;
      case 'quiz_whiz':
        return totalAssessmentsPassed >= 1;
      case 'quiz_champion':
        return totalAssessmentsPassed >= 4;
      case 'lab_experimenter':
        return hasExperimentedWithInspector;
      case 'capstone_architect':
        return _progress.completedCapstoneIds.isNotEmpty;
      case 'certified_engineer':
        return _progress.certificateId != null;
      case 'flutter_grandmaster':
        return completedLessonsCount >= totalLessonsCount &&
            totalLessonsCount > 0;
      default:
        return false;
    }
  }

  int get unlockedBadgesCount {
    return LmsBadgesData.allBadges
        .where((b) => isBadgeUnlocked(b.id))
        .length;
  }
}
