import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_learning_hub/lms/data/lms_badges_data.dart';
import 'package:flutter_learning_hub/lms/flashcards/data/flashcards_data.dart';
import 'package:flutter_learning_hub/lms/flashcards/models/flashcard_model.dart';
import 'package:flutter_learning_hub/lms/flashcards/pages/flashcard_study_deck_page.dart';
import 'package:flutter_learning_hub/lms/flashcards/pages/flashcards_hub_page.dart';
import 'package:flutter_learning_hub/lms/flashcards/widgets/flip_flashcard_view.dart';
import 'package:flutter_learning_hub/lms/services/lms_progress_service.dart';

void main() {
  group('FlashcardsData Integrity Tests', () {
    test('all 6 categories have at least 2 interview flashcards', () {
      for (final cat in FlashcardCategory.values) {
        final cards = FlashcardsData.getByCategory(cat);
        expect(
          cards.length,
          greaterThanOrEqualTo(2),
          reason: 'Kategori ${cat.name} harus memiliki minimal 2 kartu.',
        );
      }
    });

    test('every card has valid question, key concept, and interviewer tips', () {
      for (final card in FlashcardsData.allFlashcards) {
        expect(card.id.trim().isNotEmpty, isTrue);
        expect(card.question.trim().isNotEmpty, isTrue);
        expect(card.keyConcept.trim().isNotEmpty, isTrue);
        expect(card.detailedAnswer.trim().isNotEmpty, isTrue);
        expect(card.interviewerTips.trim().isNotEmpty, isTrue);
        expect(card.tags.isNotEmpty, isTrue);
      }
    });

    test('getDailyStudyDeck returns requested count', () {
      final deck = FlashcardsData.getDailyStudyDeck({'fc_arch_three_trees'}, count: 5);
      expect(deck.length, equals(5));
    });

    test('getById returns card or null for non-existent id', () {
      final card = FlashcardsData.getById('fc_arch_three_trees');
      expect(card, isNotNull);
      expect(card!.category, equals(FlashcardCategory.architecture));

      final invalid = FlashcardsData.getById('non_existent_fc');
      expect(invalid, isNull);
    });
  });

  group('LmsProgressService Flashcard Mastery Tests', () {
    test('mastering and unmastering flashcards updates progress and awards XP', () async {
      final service = LmsProgressService.instance;
      final initialXp = service.earnedXp;

      expect(service.isFlashcardMastered('fc_test_dummy_1'), isFalse);

      // Master card 1
      await service.masterFlashcard('fc_test_dummy_1', rewardXp: 15);
      expect(service.isFlashcardMastered('fc_test_dummy_1'), isTrue);
      expect(service.earnedXp, equals(initialXp + 15));

      // Master again should not duplicate XP
      await service.masterFlashcard('fc_test_dummy_1', rewardXp: 15);
      expect(service.earnedXp, equals(initialXp + 15));

      // Unmaster
      await service.unmasterFlashcard('fc_test_dummy_1');
      expect(service.isFlashcardMastered('fc_test_dummy_1'), isFalse);
    });

    test('flashcard_master badge unlocks when 10 cards are mastered', () async {
      final service = LmsProgressService.instance;

      for (int i = 1; i <= 10; i++) {
        await service.masterFlashcard('fc_badge_dummy_$i', rewardXp: 0);
      }

      expect(service.isBadgeUnlocked('flashcard_master'), isTrue);

      final badge = LmsBadgesData.allBadges.firstWhere((b) => b.id == 'flashcard_master');
      expect(badge.title, equals('Interview Ace'));

      // Clean up dummy cards
      for (int i = 1; i <= 10; i++) {
        await service.unmasterFlashcard('fc_badge_dummy_$i');
      }
    });
  });

  group('FlipFlashcardView Widget Tests', () {
    testWidgets('renders front side initially with question and flips on tap', (tester) async {
      final testCard = FlashcardsData.allFlashcards.first;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlipFlashcardView(item: testCard),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Front side visible
      expect(find.text(testCard.question), findsOneWidget);
      expect(find.text('Ketuk kartu untuk melihat jawaban teknis & tips wawancara'), findsOneWidget);

      // Tap card to flip
      await tester.tap(find.byType(FlipFlashcardView));
      await tester.pumpAndSettle();

      // Back side visible
      expect(find.text('Inti Konsep (Core Concept):'), findsOneWidget);
      expect(find.text('Tips Menjawab saat Wawancara:'), findsOneWidget);
    });
  });

  group('FlashcardStudyDeckPage Widget Tests', () {
    testWidgets('renders study deck, flip button, and spaced repetition actions', (tester) async {
      final sampleCards = FlashcardsData.allFlashcards.take(2).toList();

      await tester.pumpWidget(
        MaterialApp(
          home: FlashcardStudyDeckPage(
            deck: sampleCards,
            deckTitle: 'Test Study Deck',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Study Deck'), findsOneWidget);
      expect(find.text('Kartu 1 dari 2'), findsOneWidget);
      expect(find.text('Balik & Lihat Jawaban'), findsOneWidget);

      // Tap flip button
      await tester.tap(find.text('Balik & Lihat Jawaban'));
      await tester.pumpAndSettle();

      // Spaced repetition buttons should appear
      expect(find.text('Ulangi Nanti'), findsOneWidget);
      expect(find.text('Cukup Paham'), findsOneWidget);
      expect(find.textContaining('Kuasai'), findsOneWidget);

      // Tap 'Cukup Paham' to advance to card 2
      await tester.tap(find.text('Cukup Paham'));
      await tester.pumpAndSettle();

      expect(find.text('Kartu 2 dari 2'), findsOneWidget);
    });
  });

  group('FlashcardsHubPage Widget Tests', () {
    testWidgets('renders mastery progress, daily review button, and categories', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FlashcardsHubPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Flashcard Wawancara Kerja'), findsWidgets);
      expect(find.text('Target Penguasaan Wawancara'), findsOneWidget);
      expect(find.text('Mulai Sesi Harian (Daily 5-Min Review)'), findsOneWidget);
      expect(find.text('Pilih Deck Kategori Spesifik'), findsOneWidget);
      expect(find.textContaining('Arsitektur'), findsWidgets);
    });
  });
}
