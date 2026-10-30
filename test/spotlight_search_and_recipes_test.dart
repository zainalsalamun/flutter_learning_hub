import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_learning_hub/fundamentals/sandbox/data/sandbox_presets_data.dart';
import 'package:flutter_learning_hub/lms/recipes/data/quick_recipes_data.dart';
import 'package:flutter_learning_hub/lms/recipes/models/quick_recipe_model.dart';
import 'package:flutter_learning_hub/lms/recipes/pages/quick_recipes_hub_page.dart';
import 'package:flutter_learning_hub/lms/search/models/search_result_item.dart';
import 'package:flutter_learning_hub/lms/search/pages/global_spotlight_search_page.dart';
import 'package:flutter_learning_hub/lms/search/services/global_search_service.dart';

void main() {
  group('GlobalSearchService Unit Tests', () {
    final searchService = GlobalSearchService.instance;

    test('popularSuggestedQueries is non-empty and contains key topics', () {
      final suggestions = searchService.popularSuggestedQueries;
      expect(suggestions.isNotEmpty, isTrue);
      expect(suggestions, contains('Riverpod'));
      expect(suggestions, contains('RenderFlex'));
      expect(suggestions, contains('State'));
    });

    test('search with empty query returns default curated results', () {
      final results = searchService.search('');
      expect(results.isNotEmpty, isTrue);
      expect(results.length, lessThanOrEqualTo(15));
    });

    test('search across pillars finds results in multiple categories', () {
      // Searching 'state' should find lessons, widgets, discussions, and recipes
      final results = searchService.search('state');
      expect(results.isNotEmpty, isTrue);

      final types = results.map((r) => r.type).toSet();
      expect(types.length, greaterThan(1));
    });

    test('search with typeFilter filters out other categories', () {
      final lessonResults = searchService.search(
        'widget',
        typeFilter: SearchResultType.lesson,
      );
      for (final item in lessonResults) {
        expect(item.type, equals(SearchResultType.lesson));
      }

      final recipeResults = searchService.search(
        'code',
        typeFilter: SearchResultType.recipe,
      );
      for (final item in recipeResults) {
        expect(item.type, equals(SearchResultType.recipe));
      }
    });

    test('search for RenderFlex finds bug challenges and layout recipes', () {
      final results = searchService.search('RenderFlex');
      expect(results.isNotEmpty, isTrue);
      final hasBugOrRecipe = results.any(
        (r) =>
            r.type == SearchResultType.bugHunt ||
            r.type == SearchResultType.recipe,
      );
      expect(hasBugOrRecipe, isTrue);
    });
  });

  group('QuickRecipesData Integrity Tests', () {
    test('all 8 categories have at least one production recipe', () {
      for (final category in RecipeCategory.values) {
        final recipes = QuickRecipesData.getByCategory(category);
        expect(
          recipes.isNotEmpty,
          isTrue,
          reason: 'Kategori ${category.name} harus memiliki minimal 1 resep.',
        );
      }
    });

    test('every recipe has valid fields, non-empty code, and takeaways', () {
      for (final recipe in QuickRecipesData.allRecipes) {
        expect(recipe.id.trim().isNotEmpty, isTrue);
        expect(recipe.title.trim().isNotEmpty, isTrue);
        expect(recipe.description.trim().isNotEmpty, isTrue);
        expect(recipe.codeSnippet.trim().isNotEmpty, isTrue);
        expect(recipe.keyPoints.isNotEmpty, isTrue);
        expect(recipe.tags.isNotEmpty, isTrue);
      }
    });

    test('every sandboxPresetId corresponds to a real Sandbox Preset', () {
      final validPresetIds =
          SandboxPresetsData.allPresets.map((p) => p.id).toSet();

      for (final recipe in QuickRecipesData.allRecipes) {
        if (recipe.sandboxPresetId != null) {
          expect(
            validPresetIds.contains(recipe.sandboxPresetId),
            isTrue,
            reason:
                'Recipe "${recipe.title}" merujuk ke preset ID "${recipe.sandboxPresetId}" yang tidak ada.',
          );
        }
      }
    });

    test('getById returns correct recipe and null for invalid id', () {
      final recipe =
          QuickRecipesData.getById('recipe_renderflex_overflow_row_fix');
      expect(recipe, isNotNull);
      expect(recipe!.category, equals(RecipeCategory.layoutConstraints));

      final invalid = QuickRecipesData.getById('non_existent_recipe_id');
      expect(invalid, isNull);
    });
  });

  group('GlobalSpotlightSearchPage Widget Tests', () {
    testWidgets('renders search text field, filter chips, and suggested tags',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GlobalSpotlightSearchPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Check text field
      expect(find.byType(TextField), findsOneWidget);
      expect(
        find.text('Cari materi, widget, bug hunt, capstone, diskusi...'),
        findsOneWidget,
      );

      // Check filter chips
      expect(find.text('Semua'), findsOneWidget);
      expect(find.text('Materi Fundamental'), findsWidgets);
      expect(find.text('Resep Kode'), findsWidgets);

      // Check popular suggested query tag
      expect(find.text('Riverpod'), findsWidgets);
    });

    testWidgets('typing query updates search results dynamically',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GlobalSpotlightSearchPage(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'RenderFlex');
      await tester.pumpAndSettle();

      expect(find.textContaining('Hasil Pencarian'), findsOneWidget);
      expect(find.textContaining('RenderFlex'), findsWidgets);
    });
  });

  group('QuickRecipesHubPage Widget Tests', () {
    testWidgets('renders recipe hub, categories, and recipe cards',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: QuickRecipesHubPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Flutter & Dart Recipes Hub'), findsOneWidget);
      expect(find.textContaining('Semua Resep'), findsOneWidget);
      expect(find.text('Poin Penting & Implementasi:'), findsWidgets);
      expect(find.text('Dart / Flutter Code'), findsWidgets);
      expect(find.text('Salin'), findsWidgets);
    });

    testWidgets('allows filtering by category chip', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: QuickRecipesHubPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap first category chip: 'Dart 3 (2)'
      final dart3Filter = find.text('Dart 3 (2)');
      expect(dart3Filter, findsOneWidget);
      await tester.tap(dart3Filter);
      await tester.pumpAndSettle();

      expect(find.textContaining('Sealed Class'), findsWidgets);
    });
  });
}
