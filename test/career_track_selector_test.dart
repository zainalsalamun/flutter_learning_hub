import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_learning_hub/lms/data/learning_tracks_data.dart';
import 'package:flutter_learning_hub/lms/models/learning_track.dart';
import 'package:flutter_learning_hub/lms/pages/career_tracks_hub_page.dart';
import 'package:flutter_learning_hub/lms/services/lms_progress_service.dart';
import 'package:flutter_learning_hub/lms/widgets/learning_track_selector.dart';

void main() {
  group('LearningTrackSelector Widget Tests', () {
    testWidgets('clicking Lihat Semua opens CareerTracksHubPage and can select a track', (WidgetTester tester) async {
      LearningTrack? currentSelectedTrack;
      final lmsService = LmsProgressService.instance;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: LearningTrackSelector(
                  selectedTrack: currentSelectedTrack,
                  onTrackSelected: (track) {
                    setState(() {
                      currentSelectedTrack = track;
                    });
                  },
                  lmsService: lmsService,
                ),
              );
            },
          ),
        ),
      );

      // Verify header and button exists
      expect(find.text('Jalur Pembelajaran (Career Tracks)'), findsOneWidget);
      expect(find.text('Lihat Semua'), findsOneWidget);

      // Tap 'Lihat Semua'
      await tester.tap(find.text('Lihat Semua'));
      await tester.pumpAndSettle();

      // Verify we are now on CareerTracksHubPage
      expect(find.byType(CareerTracksHubPage), findsOneWidget);
      expect(find.text('Jalur Pembelajaran & Karir'), findsOneWidget);
      expect(find.text('Peta Kompetensi Flutter'), findsOneWidget);
      expect(find.text('TRACK TERSEDIA'), findsOneWidget);

      // Select the first track (Dart & Core Foundations)
      final firstTrack = LearningTracksData.allTracks.first;
      expect(find.text(firstTrack.title), findsAtLeastNWidgets(1));

      // Tap the track to select it and pop back
      await tester.tap(find.text(firstTrack.title).first);
      await tester.pumpAndSettle();

      // Verify we popped back to previous screen and track is selected
      expect(find.byType(CareerTracksHubPage), findsNothing);
      expect(currentSelectedTrack?.id, equals(firstTrack.id));
    });
  });
}
