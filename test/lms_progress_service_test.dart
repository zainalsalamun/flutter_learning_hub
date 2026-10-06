import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_learning_hub/lms/data/learning_tracks_data.dart';
import 'package:flutter_learning_hub/lms/data/lms_badges_data.dart';
import 'package:flutter_learning_hub/lms/capstone/data/capstone_projects_data.dart';
import 'package:flutter_learning_hub/lms/inspector/models/inspector_preset.dart';
import 'package:flutter_learning_hub/lms/models/user_progress.dart';
import 'package:flutter_learning_hub/lms/quiz/data/assessments_data.dart';
import 'package:flutter_learning_hub/lms/services/lms_progress_service.dart';
import 'package:flutter_learning_hub/lms/services/lms_storage.dart';

class MockStorage implements LmsStorage {
  UserProgress? saved;

  @override
  Future<UserProgress?> loadProgress() async => saved;

  @override
  Future<void> saveProgress(UserProgress progress) async {
    saved = progress;
  }
}

void main() {
  group('LMS UserProgress Model & Gamification Test', () {
    test('Calculates level and XP progress fraction correctly', () {
      const progress = UserProgress(earnedXp: 200);

      expect(progress.currentLevel, 2); // (200 ~/ 150) + 1 = 2
      expect(progress.levelTitle, contains('Dart Apprentice'));
      expect(progress.xpNeededForNextLevel, 100); // 300 - 200 = 100
      expect(progress.levelProgressFraction, closeTo(50 / 150, 0.01));
    });

    test('Serializes and deserializes properly', () {
      final progress = UserProgress(
        completedLessonIds: {'lesson_1', 'lesson_2'},
        bookmarkedLessonIds: {'lesson_1'},
        bookmarkedWidgetIds: {'widget_button'},
        lessonNotes: {'lesson_1': 'Poin penting lifecycle'},
        quizScores: {'lesson_1': 100},
        earnedXp: 180,
        streakDays: 4,
        lastActiveDate: DateTime(2026, 10, 5),
      );

      final jsonStr = progress.toJson();
      final restored = UserProgress.fromJson(jsonStr);

      expect(restored.completedLessonIds, contains('lesson_1'));
      expect(restored.completedLessonIds, contains('lesson_2'));
      expect(restored.bookmarkedLessonIds, contains('lesson_1'));
      expect(restored.bookmarkedWidgetIds, contains('widget_button'));
      expect(restored.lessonNotes['lesson_1'], 'Poin penting lifecycle');
      expect(restored.quizScores['lesson_1'], 100);
      expect(restored.earnedXp, 180);
      expect(restored.streakDays, 4);
    });
  });

  group('LMS Data Integrity Test', () {
    test('All 4 career tracks exist with valid modules', () {
      expect(LearningTracksData.allTracks.length, 4);
      for (final track in LearningTracksData.allTracks) {
        expect(track.includedModules, isNotEmpty);
      }
    });

    test('All badges exist with unique IDs and requirements', () {
      expect(LmsBadgesData.allBadges, isNotEmpty);
      final ids = LmsBadgesData.allBadges.map((b) => b.id).toSet();
      expect(ids.length, LmsBadgesData.allBadges.length);
    });

    test('All assessments have questions with valid options and correctIndex', () {
      expect(AssessmentsData.allAssessments.length, 4);
      for (final a in AssessmentsData.allAssessments) {
        expect(a.questions, isNotEmpty);
        expect(a.passingScore, inInclusiveRange(50, 100));
        for (final q in a.questions) {
          expect(q.options.length, 4);
          expect(q.correctIndex, inInclusiveRange(0, 3));
          expect(q.explanation, isNotEmpty);
        }
      }
    });
  });

  group('LMS Fase 3 Inspector Studio & Gamification Test', () {
    test('All 6 Inspector presets exist with titles and icons', () {
      expect(InspectorCategory.values.length, 6);
      for (final cat in InspectorCategory.values) {
        expect(cat.title, isNotEmpty);
        expect(cat.icon, isNotNull);
        expect(cat.color, isNotNull);
      }
    });

    test('Inspector experiment unlocks lab_experimenter badge and adds 50 XP', () async {
      final mockStorage = MockStorage();
      final service = LmsProgressService(storage: mockStorage);
      await service.init();

      expect(service.hasExperimentedWithInspector, isFalse);
      expect(service.isBadgeUnlocked('lab_experimenter'), isFalse);
      final initialXp = service.progress.earnedXp;

      // Experiment in studio
      await service.recordInspectorExperiment();

      expect(service.hasExperimentedWithInspector, isTrue);
      expect(service.isBadgeUnlocked('lab_experimenter'), isTrue);
      expect(service.progress.earnedXp, initialXp + 50);

      // Re-recording should be idempotent for XP bonus
      await service.recordInspectorExperiment();
      expect(service.progress.earnedXp, initialXp + 50);
    });
  });

  group('LMS Fase 4 Capstone & Certificate of Completion Test', () {
    test('All 3 Capstone projects exist with blueprints and milestones', () {
      expect(CapstoneProjectsData.allProjects.length, 3);
      for (final project in CapstoneProjectsData.allProjects) {
        expect(project.title, isNotEmpty);
        expect(project.techStack, isNotEmpty);
        expect(project.milestones, isNotEmpty);
        expect(project.snippets, isNotEmpty);
        expect(project.folderStructureTree, contains('lib/'));
      }
    });

    test('Completing capstone awards +250 XP and unlocks capstone_architect badge', () async {
      final mockStorage = MockStorage();
      final service = LmsProgressService(storage: mockStorage);
      await service.init();

      expect(service.isCapstoneCompleted('capstone_fintech'), isFalse);
      expect(service.isBadgeUnlocked('capstone_architect'), isFalse);
      final initialXp = service.progress.earnedXp;

      await service.completeCapstoneProject('capstone_fintech');

      expect(service.isCapstoneCompleted('capstone_fintech'), isTrue);
      expect(service.isBadgeUnlocked('capstone_architect'), isTrue);
      expect(service.progress.earnedXp, initialXp + 250);

      // Idempotent bonus
      await service.completeCapstoneProject('capstone_fintech');
      expect(service.progress.earnedXp, initialXp + 250);
    });

    test('Student name update and Certificate of Completion issuance', () async {
      final mockStorage = MockStorage();
      final service = LmsProgressService(storage: mockStorage);
      await service.init();

      expect(service.studentName, 'Flutter Engineer');
      await service.updateStudentName('Budi Santoso');
      expect(service.studentName, 'Budi Santoso');

      // Before certificate
      expect(service.hasClaimedCertificate, isFalse);
      expect(service.certificateId, isNull);
      expect(service.isBadgeUnlocked('certified_engineer'), isFalse);

      final initialXp = service.progress.earnedXp;

      // Issue certificate
      final certId = await service.issueCertificate(customStudentName: 'Budi Santoso');

      expect(certId, startsWith('FL-LMS-2026-'));
      expect(service.hasClaimedCertificate, isTrue);
      expect(service.certificateId, certId);
      expect(service.certificateIssuedDate, isNotNull);
      expect(service.isBadgeUnlocked('certified_engineer'), isTrue);
      expect(service.progress.earnedXp, initialXp + 300); // +300 XP Graduation Bonus
    });
  });
}
