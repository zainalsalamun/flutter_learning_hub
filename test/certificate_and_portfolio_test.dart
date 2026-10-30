import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_learning_hub/lms/services/lms_storage.dart';
import 'package:flutter_learning_hub/lms/certificate/pages/certificate_landscape_preview_page.dart';
import 'package:flutter_learning_hub/lms/certificate/pages/certificate_view_page.dart';
import 'package:flutter_learning_hub/lms/certificate/widgets/luxury_certificate_painter.dart';
import 'package:flutter_learning_hub/lms/certificate/widgets/online_credential_verification_dialog.dart';
import 'package:flutter_learning_hub/lms/certificate/widgets/portfolio_resume_modal.dart';
import 'package:flutter_learning_hub/lms/models/user_progress.dart';
import 'package:flutter_learning_hub/lms/search/models/search_result_item.dart';
import 'package:flutter_learning_hub/lms/search/services/global_search_service.dart';
import 'package:flutter_learning_hub/lms/services/lms_progress_service.dart';

class MockLmsStorage implements LmsStorage {
  UserProgress? progress;

  @override
  Future<UserProgress?> loadProgress() async => progress;

  @override
  Future<void> saveProgress(UserProgress p) async {
    progress = p;
  }
}

void main() {
  group('LuxuryCertificatePainter Unit Tests', () {
    test('paints without throwing exceptions on valid canvas', () {
      final painter = LuxuryCertificatePainter(
        certId: 'FL-LMS-2026-TEST1',
        studentName: 'Alex Pratama, S.Kom',
        issueDateText: '27 Oktober 2026',
        isEligible: true,
      );

      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      const size = Size(580, 390);

      expect(() => painter.paint(canvas, size), returnsNormally);

      final picture = recorder.endRecording();
      picture.dispose();
    });

    test('shouldRepaint returns true when properties change', () {
      final p1 = LuxuryCertificatePainter(
        certId: 'ID-1',
        studentName: 'Name 1',
        issueDateText: 'Date 1',
        isEligible: true,
      );
      final p2 = LuxuryCertificatePainter(
        certId: 'ID-2',
        studentName: 'Name 1',
        issueDateText: 'Date 1',
        isEligible: true,
      );
      final p3 = LuxuryCertificatePainter(
        certId: 'ID-1',
        studentName: 'Name 1',
        issueDateText: 'Date 1',
        isEligible: true,
      );

      expect(p1.shouldRepaint(p2), isTrue);
      expect(p1.shouldRepaint(p3), isFalse);
    });
  });

  group('GlobalSearchService Certificate Indexing Tests', () {
    test('search for "sertifikat" returns certificate result item', () {
      final results = GlobalSearchService.instance.search('sertifikat');
      expect(results, isNotEmpty);
      expect(
        results.any((r) => r.type == SearchResultType.certificate),
        isTrue,
      );
    });

    test('search for "portofolio" returns portfolio resume result item', () {
      final results = GlobalSearchService.instance.search('portofolio');
      expect(results, isNotEmpty);
      expect(
        results.any((r) => r.type == SearchResultType.certificate),
        isTrue,
      );
    });
  });

  group('Certificate & Portfolio Widget Tests', () {
    testWidgets('CertificateViewPage renders tabs, claim banner, and certificate card',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CertificateViewPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sertifikat & Portofolio Kelulusan'), findsOneWidget);
      expect(find.text('Sertifikat Digital'), findsOneWidget);
      expect(find.text('Portofolio & Resume'), findsOneWidget);

      // Tap on Tab 2
      await tester.tap(find.text('Portofolio & Resume'));
      await tester.pumpAndSettle();

      expect(find.text('CAPSTONE PORTFOLIO PROJECTS'), findsOneWidget);
      expect(
        find.text('Ekspor Resume (LinkedIn & GitHub Ready)'),
        findsOneWidget,
      );
    });

    testWidgets('CertificateViewPage does not overflow on narrow screens (360x640)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: CertificateViewPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('CertificateViewPage does not overflow on ultra-compact screens (320x568)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: CertificateViewPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('OnlineCredentialVerificationDialog displays verified details',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnlineCredentialVerificationDialog(
              certId: 'FL-LMS-2026-99999',
              studentName: 'Alex Pratama, S.Kom',
              issueDateText: '27 Oktober 2026',
              completedLessonsCount: 15,
              completedCapstonesCount: 2,
              totalXp: 1850,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('STATUS: TERVERIFIKASI RESMI'), findsOneWidget);
      expect(find.text('FL-LMS-2026-99999'), findsOneWidget);
      expect(find.text('Alex Pratama, S.Kom'), findsOneWidget);
      expect(find.text('Salin Link Verifikasi'), findsOneWidget);
    });

    testWidgets('PortfolioResumeModal renders format toggles and copy button',
        (WidgetTester tester) async {
      final mockStorage = MockLmsStorage();
      final service = LmsProgressService(storage: mockStorage);
      await service.init();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PortfolioResumeModal(lmsService: service),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ringkasan Portofolio & CV'), findsOneWidget);
      expect(find.text('LinkedIn & Plain Text'), findsOneWidget);
      expect(find.text('GitHub Markdown'), findsOneWidget);
      expect(find.text('Salin Teks LinkedIn'), findsOneWidget);

      // Switch to Markdown tab
      await tester.tap(find.text('GitHub Markdown'));
      await tester.pumpAndSettle();

      expect(find.text('Salin Teks Markdown'), findsOneWidget);
    });

    testWidgets('CertificateLandscapePreviewPage renders with pinch zoom hint and actions',
        (WidgetTester tester) async {
      final mockStorage = MockLmsStorage();
      final service = LmsProgressService(storage: mockStorage);
      await service.init();

      await tester.pumpWidget(
        MaterialApp(
          home: CertificateLandscapePreviewPage(lmsService: service),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Pratinjau Sertifikat Resmi (High-Res)'), findsOneWidget);
      expect(find.byType(InteractiveViewer), findsOneWidget);
    });
  });
}
