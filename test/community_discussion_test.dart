import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_learning_hub/lms/models/discussion_model.dart';
import 'package:flutter_learning_hub/lms/pages/community_discussion_page.dart';
import 'package:flutter_learning_hub/lms/pages/discussion_thread_detail_page.dart';
import 'package:flutter_learning_hub/lms/services/discussion_service.dart';
import 'package:flutter_learning_hub/lms/services/lms_progress_service.dart';

void main() {
  group('DiscussionService Unit Tests', () {
    test('contains initial seed discussion threads', () {
      final service = DiscussionService.instance;
      expect(service.threads.length, greaterThanOrEqualTo(6));
      expect(service.totalSolvedCount, greaterThanOrEqualTo(1));
      expect(service.totalRepliesCount, greaterThanOrEqualTo(1));
    });

    test('addThread increases total threads and awards XP', () async {
      final service = DiscussionService.instance;
      final initialCount = service.totalThreadsCount;
      final initialXp = LmsProgressService.instance.earnedXp;

      await service.addThread(
        title: 'Bagaimana cara mock Dio HTTP Client di unit test?',
        content: 'Saya ingin menguji interceptor dan retry logic tanpa network nyata.',
        category: DiscussionCategory.cleanCode,
        authorName: 'Test Student',
        tags: ['Dio', 'Mock', 'Testing'],
      );

      expect(service.totalThreadsCount, equals(initialCount + 1));
      expect(LmsProgressService.instance.earnedXp, equals(initialXp + 30));

      final newest = service.threads.first;
      expect(newest.title, contains('mock Dio'));
      expect(newest.tags, contains('Dio'));
    });

    test('addReply increases replies count and awards XP', () async {
      final service = DiscussionService.instance;
      final firstThread = service.threads.first;
      final initialReplies = firstThread.replies.length;
      final initialXp = LmsProgressService.instance.earnedXp;

      await service.addReply(
        threadId: firstThread.id,
        content: 'Gunakan package http_mock_adapter atau mockito!',
        authorName: 'Mentor Flutter',
      );

      final updatedThread = service.threads.firstWhere((t) => t.id == firstThread.id);
      expect(updatedThread.replies.length, equals(initialReplies + 1));
      expect(LmsProgressService.instance.earnedXp, equals(initialXp + 15));
    });

    test('toggleUpvoteThread updates upvote count', () {
      final service = DiscussionService.instance;
      final thread = service.threads.first;
      final initialUpvotes = thread.upvotes;
      final initialUserUpvoted = thread.userUpvoted;

      service.toggleUpvoteThread(thread.id);
      final updated = service.threads.firstWhere((t) => t.id == thread.id);

      if (initialUserUpvoted) {
        expect(updated.upvotes, equals(initialUpvotes - 1));
        expect(updated.userUpvoted, isFalse);
      } else {
        expect(updated.upvotes, equals(initialUpvotes + 1));
        expect(updated.userUpvoted, isTrue);
      }
    });

    test('toggleMarkSolution updates reply solution and thread solved status', () {
      final service = DiscussionService.instance;
      // Thread with replies
      final thread = service.threads.firstWhere((t) => t.replies.isNotEmpty);
      final firstReply = thread.replies.first;
      final initialSolution = firstReply.isSolution;

      service.toggleMarkSolution(thread.id, firstReply.id);
      final updated = service.threads.firstWhere((t) => t.id == thread.id);
      final updatedReply = updated.replies.firstWhere((r) => r.id == firstReply.id);

      expect(updatedReply.isSolution, equals(!initialSolution));
    });

    test('getFilteredThreads filters by category and search query correctly', () {
      final service = DiscussionService.instance;

      final archThreads = service.getFilteredThreads(
        category: DiscussionCategory.architecture,
      );
      expect(archThreads.every((t) => t.category == DiscussionCategory.architecture), isTrue);

      final searchResults = service.getFilteredThreads(query: 'InheritedWidget');
      expect(searchResults.isNotEmpty, isTrue);
      expect(searchResults.any((t) => t.title.contains('InheritedWidget')), isTrue);
    });
  });

  group('CommunityDiscussionPage Widget Tests', () {
    testWidgets('renders forum stats, category chips, and thread cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CommunityDiscussionPage(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Diskusi Komunitas'), findsOneWidget);
      expect(find.text('Total Diskusi'), findsOneWidget);
      expect(find.text('Terpecahkan'), findsOneWidget);
      expect(find.text('Semua Topik'), findsOneWidget);

      // Verify thread cards are rendered (top voted thread is BLoC)
      expect(find.textContaining('BLoC'), findsAtLeastNWidgets(1));

      // Tap on a thread card to navigate to detail
      await tester.tap(find.textContaining('BLoC').first);
      await tester.pumpAndSettle();

      // Verify detail page is opened
      expect(find.byType(DiscussionThreadDetailPage), findsOneWidget);
      expect(find.text('Tanggapan (1)'), findsOneWidget);
      expect(find.text('Tulis balasan atau solusi...'), findsOneWidget);
    });

    testWidgets('detail page allows submitting a reply', (WidgetTester tester) async {
      final service = DiscussionService.instance;
      final threadId = service.threads.first.id;

      await tester.pumpWidget(
        MaterialApp(
          home: DiscussionThreadDetailPage(threadId: threadId),
        ),
      );

      await tester.pumpAndSettle();

      // Enter reply text
      await tester.enterText(
        find.widgetWithText(TextField, 'Tulis balasan atau solusi...'),
        'Solusi ini sangat membantu, terima kasih banyak!',
      );
      await tester.pump();

      // Tap send button
      await tester.tap(find.byIcon(Icons.send_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Solusi ini sangat membantu, terima kasih banyak!'), findsOneWidget);

      // Dismiss snackbar
      await tester.pump(const Duration(seconds: 3));
    });
  });
}
