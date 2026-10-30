import 'package:flutter/material.dart';
import '../../../basics/models/basic_widget_model.dart';
import '../../../basics/pages/basic_widget_detail_page.dart';
import '../../../catalog/models/widget_item.dart';
import '../../../catalog/pages/widget_detail_playground_page.dart';
import '../../../fundamentals/models/lesson_item.dart';
import '../../../fundamentals/pages/lesson_detail_page.dart';
import '../../bughunt/models/bug_challenge_model.dart';
import '../../bughunt/pages/bug_challenge_detail_page.dart';
import '../../capstone/models/capstone_project_model.dart';
import '../../capstone/pages/capstone_project_detail_page.dart';
import '../../models/discussion_model.dart';
import '../../pages/discussion_thread_detail_page.dart';
import '../../recipes/models/quick_recipe_model.dart';
import '../../recipes/pages/quick_recipes_hub_page.dart';
import '../../flashcards/models/flashcard_model.dart';
import '../../flashcards/pages/flashcard_study_deck_page.dart';
import '../../certificate/pages/certificate_view_page.dart';

enum SearchResultType {
  all(
    label: 'Semua',
    icon: Icons.search_rounded,
    color: Color(0xFF02569B),
  ),
  lesson(
    label: 'Materi Fundamental',
    icon: Icons.school_rounded,
    color: Color(0xFF0284C7),
  ),
  basicWidget(
    label: 'Basic Widget',
    icon: Icons.flutter_dash_rounded,
    color: Color(0xFF0284C7),
  ),
  proWidget(
    label: 'Pro Widget Lab',
    icon: Icons.auto_awesome_motion_rounded,
    color: Color(0xFF7C3AED),
  ),
  bugHunt(
    label: 'Bug Hunt Lab',
    icon: Icons.pest_control_rounded,
    color: Color(0xFFEF4444),
  ),
  capstone(
    label: 'Capstone Project',
    icon: Icons.star_rounded,
    color: Color(0xFF10B981),
  ),
  discussion(
    label: 'Diskusi Komunitas',
    icon: Icons.chat_bubble_rounded,
    color: Color(0xFFF59E0B),
  ),
  recipe(
    label: 'Resep Kode',
    icon: Icons.code_rounded,
    color: Color(0xFF0D9488),
  ),
  flashcard(
    label: 'Flashcard Wawancara',
    icon: Icons.style_rounded,
    color: Color(0xFF8B5CF6),
  ),
  certificate(
    label: 'Sertifikat & Karir',
    icon: Icons.workspace_premium_rounded,
    color: Color(0xFFF59E0B),
  );

  final String label;
  final IconData icon;
  final Color color;

  const SearchResultType({
    required this.label,
    required this.icon,
    required this.color,
  });
}

class SearchResultItem {
  final String id;
  final String title;
  final String subtitle;
  final SearchResultType type;
  final String categoryName;
  final List<String> tags;
  final dynamic rawData;

  const SearchResultItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.categoryName,
    required this.tags,
    required this.rawData,
  });

  void navigate(BuildContext context) {
    switch (type) {
      case SearchResultType.lesson:
        if (rawData is LessonItem) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LessonDetailPage(lesson: rawData as LessonItem),
            ),
          );
        }
        break;
      case SearchResultType.basicWidget:
        if (rawData is BasicWidgetModel) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BasicWidgetDetailPage(item: rawData as BasicWidgetModel),
            ),
          );
        }
        break;
      case SearchResultType.proWidget:
        if (rawData is WidgetItem) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WidgetDetailPlaygroundPage(item: rawData as WidgetItem),
            ),
          );
        }
        break;
      case SearchResultType.bugHunt:
        if (rawData is BugChallengeModel) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BugChallengeDetailPage(challenge: rawData as BugChallengeModel),
            ),
          );
        }
        break;
      case SearchResultType.capstone:
        if (rawData is CapstoneProject) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CapstoneProjectDetailPage(project: rawData as CapstoneProject),
            ),
          );
        }
        break;
      case SearchResultType.discussion:
        if (rawData is DiscussionThread) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DiscussionThreadDetailPage(
                threadId: (rawData as DiscussionThread).id,
              ),
            ),
          );
        }
        break;
      case SearchResultType.recipe:
        if (rawData is QuickRecipe) {
          final recipe = rawData as QuickRecipe;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => QuickRecipesHubPage(
                initialCategory: recipe.category,
                initialSearchQuery: recipe.title,
              ),
            ),
          );
        }
        break;
      case SearchResultType.flashcard:
        if (rawData is FlashcardItem) {
          final fc = rawData as FlashcardItem;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FlashcardStudyDeckPage(
                deck: [fc],
                deckTitle: fc.category.shortLabel,
              ),
            ),
          );
        }
        break;
      case SearchResultType.certificate:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CertificateViewPage(),
          ),
        );
        break;
      case SearchResultType.all:
        break;
    }
  }
}
