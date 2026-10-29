import 'package:flutter/material.dart';
import '../../constants/app_design_tokens.dart';
import '../../services/lms_progress_service.dart';
import '../data/flashcards_data.dart';
import '../models/flashcard_model.dart';
import 'flashcard_study_deck_page.dart';

class FlashcardsHubPage extends StatefulWidget {
  const FlashcardsHubPage({super.key});

  @override
  State<FlashcardsHubPage> createState() => _FlashcardsHubPageState();
}

class _FlashcardsHubPageState extends State<FlashcardsHubPage> {
  final LmsProgressService _lmsService = LmsProgressService.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  FlashcardCategory? _filterCategory;

  @override
  void initState() {
    super.initState();
    _lmsService.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _lmsService.removeListener(_onServiceUpdate);
    _searchController.dispose();
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  void _startDailySession() {
    final masteredIds =
        Set<String>.from(FlashcardsData.allFlashcards
            .where((c) => _lmsService.isFlashcardMastered(c.id))
            .map((c) => c.id));

    final deck = FlashcardsData.getDailyStudyDeck(masteredIds, count: 6);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FlashcardStudyDeckPage(
          deck: deck,
          deckTitle: 'Daily 5-Min Review',
        ),
      ),
    );
  }

  void _startCategorySession(FlashcardCategory category) {
    final deck = FlashcardsData.getByCategory(category);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FlashcardStudyDeckPage(
          deck: deck,
          deckTitle: category.title,
        ),
      ),
    );
  }

  List<FlashcardItem> get _filteredCards {
    final q = _searchQuery.trim().toLowerCase();
    return FlashcardsData.allFlashcards.where((card) {
      final matchesCat =
          _filterCategory == null || card.category == _filterCategory;
      final matchesQuery = q.isEmpty ||
          card.question.toLowerCase().contains(q) ||
          card.keyConcept.toLowerCase().contains(q) ||
          card.detailedAnswer.toLowerCase().contains(q) ||
          card.tags.any((t) => t.toLowerCase().contains(q));
      return matchesCat && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final totalCards = FlashcardsData.allFlashcards.length;
    final masteredCards = _lmsService.masteredFlashcardsCount;
    final progressFraction = totalCards > 0 ? (masteredCards / totalCards) : 0.0;
    final filtered = _filteredCards;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Flashcard Wawancara Kerja',
              style: AppTypography.headingTitle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Persiapan Teknis & Spaced Repetition',
              style: AppTypography.bodyText(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Mastery Status Card & Daily Action Hero
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.borderSubtle, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F3FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.psychology_rounded,
                          color: Color(0xFF7C3AED),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Target Penguasaan Wawancara',
                              style: AppTypography.headingTitle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '$masteredCards dari $totalCards kartu telah dikuasai',
                              style: AppTypography.bodyText(
                                fontSize: 11.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          '${(progressFraction * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF166534),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressFraction,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF7C3AED),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Daily Deck Hero Button
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: _startDailySession,
                      icon: const Icon(Icons.bolt_rounded, size: 18),
                      label: const Text(
                        'Mulai Sesi Harian (Daily 5-Min Review)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Section Title: Kategori Wawancara
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.dashboard_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Pilih Deck Kategori Spesifik',
                    style: AppTypography.headingTitle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Category Decks Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.25,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final cat = FlashcardCategory.values[index];
                  final cardsInCat = FlashcardsData.getByCategory(cat);
                  final masteredInCat = cardsInCat
                      .where((c) => _lmsService.isFlashcardMastered(c.id))
                      .length;

                  return InkWell(
                    onTap: () => _startCategorySession(cat),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: AppColors.borderSubtle,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: cat.color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(cat.icon, size: 16, color: cat.color),
                              ),
                              const Spacer(),
                              Text(
                                '$masteredInCat/${cardsInCat.length}',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: masteredInCat == cardsInCat.length &&
                                          cardsInCat.isNotEmpty
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            cat.title,
                            style: AppTypography.headingTitle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${cardsInCat.length} Pertanyaan Wawancara',
                            style: AppTypography.bodyText(
                              fontSize: 10.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: FlashcardCategory.values.length,
              ),
            ),
          ),

          // 4. Section Title: Jelajahi Seluruh Kartu
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.view_agenda_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Jelajahi & Cari Kartu Pintar',
                    style: AppTypography.headingTitle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${filtered.length} Kartu',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 5. Search Field
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.borderSubtle, width: 1),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Cari topik (Impeller, Isolate, RepaintBoundary...)',
                    hintStyle: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: Color(0xFF94A3B8),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 16),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 6. Cards List
          if (filtered.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'Tidak ditemukan kartu pintar untuk "$_searchQuery"',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = filtered[index];
                    final isMastered = _lmsService.isFlashcardMastered(item.id);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: isMastered
                              ? const Color(0xFF10B981).withValues(alpha: 0.4)
                              : AppColors.borderSubtle,
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FlashcardStudyDeckPage(
                                deck: [item],
                                deckTitle: item.category.shortLabel,
                              ),
                            ),
                          );
                        },
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: item.category.color.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item.category.icon,
                            size: 16,
                            color: item.category.color,
                          ),
                        ),
                        title: Text(
                          item.question,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 1.5,
                                ),
                                decoration: BoxDecoration(
                                  color: item.difficulty.color
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.difficulty.label,
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    color: item.difficulty.color,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item.keyConcept,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: isMastered
                            ? const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF10B981),
                                size: 18,
                              )
                            : const Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFFCBD5E1),
                                size: 18,
                              ),
                      ),
                    );
                  },
                  childCount: filtered.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
