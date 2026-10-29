import 'package:flutter/material.dart';
import '../../constants/app_design_tokens.dart';
import '../../services/lms_progress_service.dart';
import '../models/flashcard_model.dart';
import '../widgets/flip_flashcard_view.dart';

class FlashcardStudyDeckPage extends StatefulWidget {
  final List<FlashcardItem> deck;
  final String deckTitle;

  const FlashcardStudyDeckPage({
    super.key,
    required this.deck,
    this.deckTitle = 'Sesi Review Flashcard',
  });

  @override
  State<FlashcardStudyDeckPage> createState() => _FlashcardStudyDeckPageState();
}

class _FlashcardStudyDeckPageState extends State<FlashcardStudyDeckPage> {
  final LmsProgressService _lmsService = LmsProgressService.instance;
  late List<FlashcardItem> _activeDeck;
  int _currentIndex = 0;
  bool _isCurrentCardBack = false;
  int _sessionCardsReviewed = 0;
  int _sessionCardsMastered = 0;
  bool _isSessionFinished = false;

  final GlobalKey<FlipFlashcardViewState> _cardKey =
      GlobalKey<FlipFlashcardViewState>();

  @override
  void initState() {
    super.initState();
    _activeDeck = List.from(widget.deck);
    _lmsService.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _lmsService.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  FlashcardItem? get _currentCard {
    if (_currentIndex < _activeDeck.length) {
      return _activeDeck[_currentIndex];
    }
    return null;
  }

  void _onCardFlipped(bool isBack) {
    setState(() {
      _isCurrentCardBack = isBack;
    });
  }

  void _handleFlipTap() {
    _cardKey.currentState?.flip();
  }

  void _onEvaluateAgain() {
    final current = _currentCard;
    if (current == null) return;

    setState(() {
      _sessionCardsReviewed++;
      // Move this card to end of deck to review again in this session
      _activeDeck.add(current);
      _nextCard();
    });
  }

  void _onEvaluateGood() {
    setState(() {
      _sessionCardsReviewed++;
      _nextCard();
    });
  }

  Future<void> _onEvaluateMastered() async {
    final current = _currentCard;
    if (current == null) return;

    setState(() {
      _sessionCardsReviewed++;
      _sessionCardsMastered++;
    });

    await _lmsService.masterFlashcard(current.id);

    if (mounted) {
      _nextCard();
    }
  }

  void _nextCard() {
    if (_currentIndex + 1 < _activeDeck.length) {
      setState(() {
        _currentIndex++;
        _isCurrentCardBack = false;
      });
    } else {
      setState(() {
        _isSessionFinished = true;
      });
    }
  }

  void _restartSession() {
    setState(() {
      _activeDeck = List.from(widget.deck);
      _currentIndex = 0;
      _isCurrentCardBack = false;
      _sessionCardsReviewed = 0;
      _sessionCardsMastered = 0;
      _isSessionFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              widget.deckTitle,
              style: AppTypography.headingTitle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            if (!_isSessionFinished && _activeDeck.isNotEmpty)
              Text(
                'Kartu ${_currentIndex + 1} dari ${_activeDeck.length}',
                style: AppTypography.bodyText(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(color: AppColors.borderSubtle, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.style_rounded,
                  size: 15,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 5),
                Text(
                  '${_lmsService.masteredFlashcardsCount} Mastered',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isSessionFinished
          ? _buildCompletionView()
          : _activeDeck.isEmpty
              ? _buildEmptyDeckView()
              : _buildStudyView(),
    );
  }

  Widget _buildEmptyDeckView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.style_outlined,
              size: 54,
              color: Color(0xFFCBD5E1),
            ),
            const SizedBox(height: 16),
            Text(
              'Deck Masih Kosong',
              style: AppTypography.headingTitle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Tidak ada kartu pintar di deck ini.',
              style: AppTypography.bodyText(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyView() {
    final currentCard = _currentCard!;
    final isMastered = _lmsService.isFlashcardMastered(currentCard.id);
    final progressFraction = (_currentIndex + 1) / _activeDeck.length;

    return Column(
      children: [
        // Top Progress Line
        LinearProgressIndicator(
          value: progressFraction,
          backgroundColor: const Color(0xFFE2E8F0),
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          minHeight: 3.5,
        ),

        // Main Card Section
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: FlipFlashcardView(
              key: _cardKey,
              item: currentCard,
              isMastered: isMastered,
              onFlipStateChanged: _onCardFlipped,
            ),
          ),
        ),

        // Bottom Controls Container
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              top: BorderSide(color: AppColors.borderSubtle, width: 1),
            ),
          ),
          child: SafeArea(
            top: false,
            child: _isCurrentCardBack
                ? _buildSpacedRepetitionButtons()
                : _buildFrontSideButton(),
          ),
        ),
      ],
    );
  }

  Widget _buildFrontSideButton() {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton.icon(
        onPressed: _handleFlipTap,
        icon: const Icon(Icons.flip_to_back_rounded, size: 18),
        label: const Text(
          'Balik & Lihat Jawaban',
          style: TextStyle(
            fontSize: 14,
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
    );
  }

  Widget _buildSpacedRepetitionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'Seberapa yakin Anda dengan pertanyaan ini?',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          children: [
            // 1. Perlu Review Lagi
            Expanded(
              child: OutlinedButton(
                onPressed: _onEvaluateAgain,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFDC2626),
                  side: const BorderSide(color: Color(0xFFFCA5A5), width: 1),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.replay_rounded, size: 16),
                    SizedBox(height: 2),
                    Text(
                      'Ulangi Nanti',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // 2. Cukup Paham
            Expanded(
              child: OutlinedButton(
                onPressed: _onEvaluateGood,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD97706),
                  side: const BorderSide(color: Color(0xFFFCD34D), width: 1),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_rounded, size: 16),
                    SizedBox(height: 2),
                    Text(
                      'Cukup Paham',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // 3. Sangat Menguasai
            Expanded(
              child: ElevatedButton(
                onPressed: _onEvaluateMastered,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_rounded, size: 16),
                    SizedBox(height: 2),
                    Text(
                      'Kuasai (+15 XP)',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompletionView() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.borderSubtle, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.military_tech_rounded,
                  color: Color(0xFF16A34A),
                  size: 36,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Sesi Review Selesai!',
                style: AppTypography.headingTitle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Luar biasa! Konsistensi belajar harian adalah kunci sukses menaklukkan wawancara teknis Flutter.',
                style: AppTypography.bodyText(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              // Stats Container
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.borderSubtle, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCol(
                      label: 'Direview',
                      value: '$_sessionCardsReviewed',
                      color: AppColors.primary,
                    ),
                    Container(
                      width: 1,
                      height: 32,
                      color: const Color(0xFFE2E8F0),
                    ),
                    _buildStatCol(
                      label: 'Dikuasai',
                      value: '$_sessionCardsMastered',
                      color: const Color(0xFF10B981),
                    ),
                    Container(
                      width: 1,
                      height: 32,
                      color: const Color(0xFFE2E8F0),
                    ),
                    _buildStatCol(
                      label: 'Bonus XP',
                      value: '+${_sessionCardsMastered * 15} XP',
                      color: const Color(0xFFF59E0B),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _restartSession,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(
                          color: AppColors.borderMedium,
                          width: 1,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: const Text(
                        'Ulangi Sesi',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: const Text(
                        'Selesai',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCol({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
