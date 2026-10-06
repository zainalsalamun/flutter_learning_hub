import 'package:flutter/material.dart';
import '../../fundamentals/pages/lesson_detail_page.dart';
import '../constants/app_design_tokens.dart';
import '../pages/student_profile_dashboard_page.dart';
import '../quiz/pages/assessment_arena_page.dart';
import '../services/lms_progress_service.dart';

class LmsStudentHeaderCard extends StatelessWidget {
  final LmsProgressService lmsService;

  const LmsStudentHeaderCard({
    super.key,
    required this.lmsService,
  });

  @override
  Widget build(BuildContext context) {
    final level = lmsService.currentLevel;
    final title = lmsService.levelTitle;
    final xp = lmsService.earnedXp;
    final progressFraction = lmsService.levelProgressFraction;
    final xpNeeded = lmsService.xpNeededForNextLevel;
    final streak = lmsService.streakDays;
    final completedCount = lmsService.completedLessonsCount;
    final totalCount = lmsService.totalLessonsCount;
    final overallPercent = (lmsService.getOverallProgress() * 100).toInt();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Rank badge, level, xp tag, lesson count, and streak pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rank square badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.rankDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'RANK',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                    Text(
                      'L$level',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: AppTypography.headingTitle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$xp XP',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$completedCount dari $totalCount materi tuntas ($overallPercent%)',
                      style: AppTypography.bodyText(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Streak Pill
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const StudentProfileDashboardPage(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warningSubtle,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(color: AppColors.warningBorder, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department_rounded,
                        color: Color(0xFFD97706),
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$streak Hari',
                        style: const TextStyle(
                          color: Color(0xFFB45309),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Row 2: Curriculum Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progressFraction > 0 ? progressFraction : 0.04,
              minHeight: 5,
              backgroundColor: const Color(0xFFEAEDFF),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress kurikulum',
                style: AppTypography.bodyText(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '$xpNeeded XP ke Lv.${level + 1}',
                style: AppTypography.bodyText(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Row 3: 3 Action buttons (Lanjutkan Belajar, Kuis, Trophy)
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    final nextLesson = lmsService.getNextRecommendedLesson();
                    if (nextLesson != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LessonDetailPage(lesson: nextLesson),
                        ),
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Lanjutkan Belajar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AssessmentArenaPage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.help_outline_rounded,
                  size: 15,
                  color: Color(0xFF475569),
                ),
                label: const Text(
                  'Kuis',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.borderSubtle),
                  backgroundColor: AppColors.surface,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const StudentProfileDashboardPage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.emoji_events_outlined,
                  size: 15,
                  color: Color(0xFF475569),
                ),
                label: Text(
                  '${lmsService.unlockedBadgesCount}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.borderSubtle),
                  backgroundColor: AppColors.surface,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
