import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_learning_hub/lms/bughunt/data/bug_challenges_data.dart';
import 'package:flutter_learning_hub/lms/bughunt/models/bug_challenge_model.dart';
import 'package:flutter_learning_hub/lms/models/user_progress.dart';
import 'package:flutter_learning_hub/lms/services/lms_progress_service.dart';
import 'package:flutter_learning_hub/lms/services/lms_storage.dart';

class MockLmsStorage implements LmsStorage {
  UserProgress? savedProgress;

  @override
  Future<UserProgress?> loadProgress() async => savedProgress;

  @override
  Future<bool> saveProgress(UserProgress progress) async {
    savedProgress = progress;
    return true;
  }
}

void main() {
  group('Bug Hunt Lab Data & Model Integrity Tests', () {
    test('All 5 bug challenges exist with unique IDs and valid configuration', () {
      final challenges = BugChallengesData.allChallenges;
      expect(challenges.length, 5);

      final ids = challenges.map((c) => c.id).toSet();
      expect(ids.length, 5, reason: 'Every bug challenge must have a unique ID');

      for (final challenge in challenges) {
        expect(challenge.title.isNotEmpty, isTrue);
        expect(challenge.scenario.isNotEmpty, isTrue);
        expect(challenge.flutterErrorSnippet.isNotEmpty, isTrue);
        expect(challenge.buggyCode.isNotEmpty, isTrue);
        expect(challenge.cleanFixedCode.isNotEmpty, isTrue);
        expect(challenge.rootCauseAnalysis.isNotEmpty, isTrue);
        expect(challenge.bestPracticeGuide.isNotEmpty, isTrue);
        expect(challenge.xpReward, greaterThan(0));

        // Must have at least 1 correct fix option and at least 1 incorrect fix option
        final correctOptions =
            challenge.fixOptions.where((opt) => opt.isCorrect).toList();
        final incorrectOptions =
            challenge.fixOptions.where((opt) => !opt.isCorrect).toList();

        expect(correctOptions.isNotEmpty, isTrue,
            reason: '${challenge.id} must have at least one correct fix option');
        expect(incorrectOptions.isNotEmpty, isTrue,
            reason: '${challenge.id} must have at least one incorrect fix option');
      }
    });

    test('All bug categories are represented in challenges', () {
      final categories =
          BugChallengesData.allChallenges.map((c) => c.category).toSet();
      expect(categories.contains(BugCategory.layout), isTrue);
      expect(categories.contains(BugCategory.memory), isTrue);
      expect(categories.contains(BugCategory.statePhase), isTrue);
      expect(categories.contains(BugCategory.overflow), isTrue);
      expect(categories.contains(BugCategory.asyncSafety), isTrue);
    });
  });

  group('Bug Hunt Gamification & Progress Tests', () {
    late MockLmsStorage mockStorage;
    late LmsProgressService service;

    setUp(() async {
      mockStorage = MockLmsStorage();
      service = LmsProgressService(storage: mockStorage);
      await service.init();
    });

    test('Initial state has 0 completed bug challenges', () {
      expect(service.completedBugChallengesCount, 0);
      expect(service.isBugChallengeCompleted('bug_unbounded_height'), isFalse);
      expect(service.isBadgeUnlocked('bug_hunter'), isFalse);
    });

    test('Solving a bug challenge awards XP and unlocks Bug Hunter badge', () async {
      final initialXp = service.earnedXp;
      const challengeId = 'bug_unbounded_height';
      const rewardXp = 80;

      await service.completeBugChallenge(challengeId, rewardXp);

      expect(service.completedBugChallengesCount, 1);
      expect(service.isBugChallengeCompleted(challengeId), isTrue);
      expect(service.earnedXp, initialXp + rewardXp);
      expect(service.isBadgeUnlocked('bug_hunter'), isTrue);

      // Solving again should not duplicate XP
      await service.completeBugChallenge(challengeId, rewardXp);
      expect(service.completedBugChallengesCount, 1);
      expect(service.earnedXp, initialXp + rewardXp);
    });

    test('UserProgress serialization persists completedBugChallengeIds correctly', () {
      const progress = UserProgress(
        completedBugChallengeIds: {'bug_unbounded_height', 'bug_animation_leak'},
        earnedXp: 180,
      );

      final map = progress.toMap();
      final restored = UserProgress.fromMap(map);

      expect(restored.completedBugChallengeIds.length, 2);
      expect(restored.completedBugChallengeIds.contains('bug_unbounded_height'),
          isTrue);
      expect(restored.completedBugChallengeIds.contains('bug_animation_leak'),
          isTrue);
      expect(restored.earnedXp, 180);
    });
  });
}
