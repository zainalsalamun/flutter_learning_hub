import 'package:flutter/material.dart';
import '../../constants/app_design_tokens.dart';
import '../../services/lms_progress_service.dart';
import '../data/bug_challenges_data.dart';
import '../models/bug_challenge_model.dart';
import 'bug_challenge_detail_page.dart';

class BugHuntLabPage extends StatefulWidget {
  const BugHuntLabPage({super.key});

  @override
  State<BugHuntLabPage> createState() => _BugHuntLabPageState();
}

class _BugHuntLabPageState extends State<BugHuntLabPage> {
  final LmsProgressService _lmsService = LmsProgressService.instance;
  BugCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _lmsService.addListener(_onUpdate);
  }

  @override
  void dispose() {
    _lmsService.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    if (mounted) setState(() {});
  }

  List<BugChallengeModel> get _filteredChallenges {
    if (_selectedCategory == null) {
      return BugChallengesData.allChallenges;
    }
    return BugChallengesData.allChallenges
        .where((c) => c.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final solvedCount = _lmsService.completedBugChallengesCount;
    final totalCount = BugChallengesData.allChallenges.length;
    final isHunterUnlocked = _lmsService.isBadgeUnlocked('bug_hunter');
    final filtered = _filteredChallenges;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bug Hunt Lab',
              style: AppTypography.headingTitle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Tantangan Debugging Runtime Flutter',
              style: AppTypography.bodyText(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero Overview Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.borderSubtle, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.pest_control_rounded,
                        color: Color(0xFFEF4444),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Bug Hunt & Crash Solver',
                            style: AppTypography.headingTitle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Diagnosis dan perbaiki error runtime nyata untuk memperkuat insting arsitektur.',
                            style: AppTypography.bodyText(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: totalCount > 0 ? (solvedCount / totalCount) : 0,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFEAEDFF),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$solvedCount dari $totalCount Kasus Selesai',
                      style: AppTypography.bodyText(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isHunterUnlocked
                            ? const Color(0xFFF0FDF4)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isHunterUnlocked
                              ? const Color(0xFFBBF7D0)
                              : AppColors.borderSubtle,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isHunterUnlocked
                                ? Icons.verified_rounded
                                : Icons.lock_outline_rounded,
                            size: 11,
                            color: isHunterUnlocked
                                ? const Color(0xFF16A34A)
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isHunterUnlocked
                                ? 'Badge Bug Hunter Aktif'
                                : 'Badge Terkunci',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: isHunterUnlocked
                                  ? const Color(0xFF15803D)
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Category Filter Pills
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryPill(
                  label: 'Semua Kategori',
                  icon: Icons.layers_outlined,
                  isSelected: _selectedCategory == null,
                  onTap: () => setState(() => _selectedCategory = null),
                ),
                ...BugCategory.values.map((cat) {
                  return _buildCategoryPill(
                    label: cat.title,
                    icon: cat.icon,
                    isSelected: _selectedCategory == cat,
                    onTap: () => setState(() => _selectedCategory = cat),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Section Title
          Text(
            'KASUS TERSEDIA (${filtered.length})',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),

          // Challenges List
          ...filtered.map((challenge) {
            final isDone = _lmsService.isBugChallengeCompleted(challenge.id);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: isDone
                      ? const Color(0xFFBBF7D0)
                      : AppColors.borderSubtle,
                  width: 1,
                ),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          BugChallengeDetailPage(challenge: challenge),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Category tag, Difficulty badge, XP reward pill
                      Row(
                        children: [
                          Icon(challenge.category.icon,
                              size: 15, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            challenge.category.title.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: challenge.difficulty.color
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: challenge.difficulty.color
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              challenge.difficulty.label,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: challenge.difficulty.color,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isDone
                                  ? const Color(0xFFF0FDF4)
                                  : const Color(0xFFFFFBEB),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isDone
                                    ? const Color(0xFFBBF7D0)
                                    : const Color(0xFFFDE68A),
                              ),
                            ),
                            child: Text(
                              isDone ? 'Tuntas' : '+${challenge.xpReward} XP',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: isDone
                                    ? const Color(0xFF15803D)
                                    : const Color(0xFFB45309),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Error title
                      Text(
                        challenge.title,
                        style: AppTypography.headingTitle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Scenario summary
                      Text(
                        challenge.scenario,
                        style: AppTypography.bodyText(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),

                      // Bottom CTA
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isDone
                                    ? Icons.check_circle_rounded
                                    : Icons.play_circle_outline_rounded,
                                size: 14,
                                color: isDone
                                    ? const Color(0xFF16A34A)
                                    : AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isDone ? 'Telah Diperbaiki' : 'Buka Studio Debug',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: isDone
                                      ? const Color(0xFF16A34A)
                                      : AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 12,
                            color: Color(0xFF94A3B8),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryPill({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.borderSubtle,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
