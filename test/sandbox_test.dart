import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_learning_hub/fundamentals/sandbox/data/sandbox_presets_data.dart';
import 'package:flutter_learning_hub/fundamentals/sandbox/pages/lesson_code_sandbox_page.dart';
import 'package:flutter_learning_hub/fundamentals/sandbox/widgets/sandbox_console_terminal.dart';

void main() {
  group('SandboxPresetsData Tests', () {
    test('contains all 6 required interactive presets', () {
      final presets = SandboxPresetsData.allPresets;
      expect(presets.length, 6);

      final expectedIds = [
        'layout_box',
        'flex_alignment',
        'state_lifecycle',
        'custom_painter',
        'async_stream',
        'oop_immutable',
      ];

      for (final id in expectedIds) {
        final preset = SandboxPresetsData.getById(id);
        expect(preset, isNotNull, reason: 'Preset $id should exist');
        expect(preset!.id, equals(id));
      }
    });

    test('code generator and console output generator work for all presets', () {
      for (final preset in SandboxPresetsData.allPresets) {
        final generatedCode = preset.codeGenerator(preset.initialParameters);
        expect(generatedCode, isNotEmpty);

        final consoleLogs = preset.consoleOutputGenerator(preset.initialParameters);
        expect(consoleLogs, isNotEmpty);
        expect(consoleLogs.any((l) => l.contains('[') && l.contains(']')), isTrue);
      }
    });

    test('getById returns null for unknown preset ID', () {
      expect(SandboxPresetsData.getById('non_existent_preset'), isNull);
    });
  });

  group('SandboxConsoleTerminal Widget Tests', () {
    testWidgets('renders terminal title and log lines properly', (WidgetTester tester) async {
      bool clearCalled = false;
      bool rerunCalled = false;

      final logs = [
        '[DART VM] Initializing VM...',
        '[LAYOUT] BoxConstraints evaluated.',
        '[STATUS] 0 layout overflow errors detected.',
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SandboxConsoleTerminal(
              logs: logs,
              onClear: () => clearCalled = true,
              onRerun: () => rerunCalled = true,
            ),
          ),
        ),
      );

      expect(find.text('dart test/sandbox_runner.dart'), findsOneWidget);
      expect(find.textContaining('Initializing VM...'), findsOneWidget);
      expect(find.textContaining('BoxConstraints evaluated.'), findsOneWidget);

      // Tap clear
      await tester.tap(find.byTooltip('Bersihkan Log'));
      await tester.pump();
      expect(clearCalled, isTrue);

      // Tap rerun
      await tester.tap(find.byTooltip('Re-run Terminal'));
      await tester.pump();
      expect(rerunCalled, isTrue);
    });
  });

  group('LessonCodeSandboxPage Widget Tests', () {
    testWidgets('renders tabs, preset title, and parameter controls', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LessonCodeSandboxPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify title & tabs
      expect(find.text('Interactive Code Sandbox'), findsOneWidget);
      expect(find.text('Live Canvas'), findsOneWidget);
      expect(find.text('Kode Dart'), findsOneWidget);
      expect(find.text('Terminal Log'), findsOneWidget);

      // Verify initial active preset
      expect(find.text('Layout Box & Container Bounds'), findsOneWidget);

      // Switch to Kode Dart tab
      await tester.tap(find.text('Kode Dart'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Container('), findsOneWidget);

      // Switch to Terminal Log tab
      await tester.tap(find.text('Terminal Log'));
      await tester.pumpAndSettle();
      expect(find.textContaining('BoxConstraints'), findsOneWidget);
    });
  });
}
