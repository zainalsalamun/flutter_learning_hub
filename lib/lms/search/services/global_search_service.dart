import '../../../basics/data/basic_widgets_data.dart';
import '../../../catalog/data/widget_catalog_registry.dart';
import '../../../fundamentals/data/lessons_repository.dart';
import '../../bughunt/data/bug_challenges_data.dart';
import '../../capstone/data/capstone_projects_data.dart';
import '../../recipes/data/quick_recipes_data.dart';
import '../../services/discussion_service.dart';
import '../../flashcards/data/flashcards_data.dart';
import '../models/search_result_item.dart';

class GlobalSearchService {
  static final GlobalSearchService instance = GlobalSearchService._();
  GlobalSearchService._();

  List<SearchResultItem> _getAllItems() {
    final List<SearchResultItem> items = [];

    // 1. Lessons
    for (final lesson in LessonsRepository.allLessons) {
      items.add(
        SearchResultItem(
          id: 'lesson_${lesson.id}',
          title: lesson.title,
          subtitle: '${lesson.subtitle} • ${lesson.summary}',
          type: SearchResultType.lesson,
          categoryName: lesson.module.title,
          tags: [
            lesson.module.name,
            ...lesson.keyTakeaways,
          ],
          rawData: lesson,
        ),
      );
    }

    // 2. Basic Widgets
    for (final widget in BasicWidgetsData.allWidgets) {
      items.add(
        SearchResultItem(
          id: 'basic_${widget.id}',
          title: widget.name,
          subtitle: widget.summary,
          type: SearchResultType.basicWidget,
          categoryName: widget.category.title,
          tags: [
            widget.category.name,
            ...widget.usageTips,
          ],
          rawData: widget,
        ),
      );
    }

    // 3. Pro Widget Catalog
    for (final proWidget in WidgetCatalogRegistry.allWidgets) {
      items.add(
        SearchResultItem(
          id: 'pro_${proWidget.id}',
          title: proWidget.title,
          subtitle: proWidget.description,
          type: SearchResultType.proWidget,
          categoryName: proWidget.category.title,
          tags: proWidget.tags,
          rawData: proWidget,
        ),
      );
    }

    // 4. Bug Hunt Challenges
    for (final bug in BugChallengesData.allChallenges) {
      items.add(
        SearchResultItem(
          id: 'bug_${bug.id}',
          title: bug.title,
          subtitle: bug.scenario,
          type: SearchResultType.bugHunt,
          categoryName: bug.category.title,
          tags: [
            bug.difficulty.name,
            'Bug Hunt',
            'Debugging',
          ],
          rawData: bug,
        ),
      );
    }

    // 5. Capstone Projects
    for (final capstone in CapstoneProjectsData.allProjects) {
      items.add(
        SearchResultItem(
          id: 'capstone_${capstone.id}',
          title: capstone.title,
          subtitle: '${capstone.tagline} • ${capstone.description}',
          type: SearchResultType.capstone,
          categoryName: 'Capstone Project',
          tags: [
            ...capstone.techStack,
            ...capstone.architecturePoints,
          ],
          rawData: capstone,
        ),
      );
    }

    // 6. Community Discussions
    for (final thread in DiscussionService.instance.threads) {
      items.add(
        SearchResultItem(
          id: 'thread_${thread.id}',
          title: thread.title,
          subtitle: thread.content,
          type: SearchResultType.discussion,
          categoryName: thread.category.title,
          tags: thread.tags,
          rawData: thread,
        ),
      );
    }

    // 7. Quick Recipes
    for (final recipe in QuickRecipesData.allRecipes) {
      items.add(
        SearchResultItem(
          id: 'recipe_${recipe.id}',
          title: recipe.title,
          subtitle: recipe.description,
          type: SearchResultType.recipe,
          categoryName: recipe.category.title,
          tags: recipe.tags,
          rawData: recipe,
        ),
      );
    }

    // 8. Flashcards
    for (final fc in FlashcardsData.allFlashcards) {
      items.add(
        SearchResultItem(
          id: 'fc_${fc.id}',
          title: fc.question,
          subtitle: '${fc.keyConcept} • ${fc.detailedAnswer}',
          type: SearchResultType.flashcard,
          categoryName: fc.category.title,
          tags: [
            ...fc.tags,
            fc.difficulty.label,
            'Flashcard',
            'Interview',
          ],
          rawData: fc,
        ),
      );
    }

    // 9. Certificate & Portfolio Showcase
    items.add(
      const SearchResultItem(
        id: 'cert_official_graduation',
        title: 'Sertifikat Kelulusan Resmi (Certificate of Mastery)',
        subtitle:
            'Klaim sertifikat resmi, ornamen guilloche, QR code verifier, dan ekspor resume portofolio.',
        type: SearchResultType.certificate,
        categoryName: 'Kredensial & Karir',
        tags: [
          'sertifikat',
          'certificate',
          'kelulusan',
          'kredensial',
          'verifikasi',
          'ijazah',
          'mastery',
        ],
        rawData: 'certificate',
      ),
    );
    items.add(
      const SearchResultItem(
        id: 'cert_portfolio_resume',
        title: 'Portofolio Resume Capstone & Skill Showcase',
        subtitle:
            'Generator resume Markdown & Plain Text untuk LinkedIn, CV, dan GitHub README.',
        type: SearchResultType.certificate,
        categoryName: 'Kredensial & Karir',
        tags: [
          'portofolio',
          'portfolio',
          'resume',
          'cv',
          'linkedin',
          'github',
          'showcase',
        ],
        rawData: 'portfolio',
      ),
    );

    return items;
  }

  /// Popular suggested keywords when the search bar is empty
  List<String> get popularSuggestedQueries => const [
        'State',
        'Riverpod',
        'Sertifikat',
        'Portofolio',
        'RenderFlex',
        'Lifecycle',
        'CustomPainter',
        'Dio',
        'BLoC',
        'InheritedWidget',
      ];

  /// Core search logic with relevance scoring
  List<SearchResultItem> search(
    String rawQuery, {
    SearchResultType typeFilter = SearchResultType.all,
  }) {
    final all = _getAllItems();
    final query = rawQuery.trim().toLowerCase();

    // If query is empty, return featured items across types
    if (query.isEmpty) {
      if (typeFilter == SearchResultType.all) {
        return all.take(15).toList();
      }
      return all.where((item) => item.type == typeFilter).toList();
    }

    final queryWords = query.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

    final List<MapEntry<SearchResultItem, int>> scored = [];

    for (final item in all) {
      if (typeFilter != SearchResultType.all && item.type != typeFilter) {
        continue;
      }

      int score = 0;
      final lowerTitle = item.title.toLowerCase();
      final lowerSubtitle = item.subtitle.toLowerCase();
      final lowerCat = item.categoryName.toLowerCase();
      final lowerTags = item.tags.map((t) => t.toLowerCase()).toList();

      // Check exact query
      if (lowerTitle == query) {
        score += 120;
      } else if (lowerTitle.startsWith(query)) {
        score += 90;
      } else if (lowerTitle.contains(query)) {
        score += 60;
      }

      if (lowerCat.contains(query)) {
        score += 35;
      }

      for (final tag in lowerTags) {
        if (tag == query) {
          score += 50;
        } else if (tag.contains(query)) {
          score += 30;
        }
      }

      if (lowerSubtitle.contains(query)) {
        score += 20;
      }

      // Check multi-word matching
      if (queryWords.length > 1) {
        bool allWordsPresent = true;
        for (final word in queryWords) {
          final wordMatches = lowerTitle.contains(word) ||
              lowerSubtitle.contains(word) ||
              lowerCat.contains(word) ||
              lowerTags.any((t) => t.contains(word));
          if (!wordMatches) {
            allWordsPresent = false;
            break;
          }
        }
        if (allWordsPresent) {
          score += 40;
        }
      }

      if (score > 0) {
        scored.add(MapEntry(item, score));
      }
    }

    // Sort descending by score
    scored.sort((a, b) => b.value.compareTo(a.value));

    return scored.map((e) => e.key).toList();
  }
}
