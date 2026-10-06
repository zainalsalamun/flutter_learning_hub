import 'package:flutter/material.dart';
import '../../lms/capstone/pages/capstone_projects_hub_page.dart';
import '../../lms/certificate/pages/certificate_view_page.dart';
import '../../lms/constants/app_design_tokens.dart';
import '../../lms/inspector/pages/widget_inspector_studio_page.dart';
import '../../lms/models/learning_track.dart';
import '../../lms/pages/student_profile_dashboard_page.dart';
import '../../lms/quiz/pages/assessment_arena_page.dart';
import '../../lms/services/lms_progress_service.dart';
import '../../lms/widgets/learning_track_selector.dart';
import '../../lms/widgets/lms_student_header_card.dart';
import '../data/lessons_repository.dart';
import '../models/fundamental_module.dart';
import '../models/lesson_item.dart';
import 'lesson_detail_page.dart';

class FundamentalsHomePage extends StatefulWidget {
  const FundamentalsHomePage({super.key});

  @override
  State<FundamentalsHomePage> createState() => _FundamentalsHomePageState();
}

class _FundamentalsHomePageState extends State<FundamentalsHomePage> {
  final LmsProgressService _lmsService = LmsProgressService.instance;
  final TextEditingController _searchController = TextEditingController();
  FundamentalModule _selectedModule = FundamentalModule.all;
  LearningTrack? _selectedTrack;
  String _searchQuery = '';

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

  List<LessonItem> get _filteredLessons {
    return LessonsRepository.allLessons.where((lesson) {
      // 1. Track filter
      final matchesTrack = _selectedTrack == null ||
          _selectedTrack!.includedModules.contains(lesson.module);

      // 2. Module filter
      final matchesModule = _selectedModule == FundamentalModule.all ||
          lesson.module == _selectedModule;

      // 3. Search query
      final q = _searchQuery.toLowerCase().trim();
      final matchesQuery = q.isEmpty ||
          lesson.title.toLowerCase().contains(q) ||
          lesson.subtitle.toLowerCase().contains(q) ||
          lesson.summary.toLowerCase().contains(q);

      return matchesTrack && matchesModule && matchesQuery;
    }).toList();
  }

  List<FundamentalModule> get _availableModulesForCurrentTrack {
    if (_selectedTrack == null) {
      return FundamentalModule.values;
    }
    return [FundamentalModule.all, ..._selectedTrack!.includedModules];
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredLessons;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primarySubtle,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderSubtle, width: 1),
              ),
              child: const Icon(
                Icons.flutter_dash_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Flutter LMS & Mastery',
                  style: AppTypography.headingTitle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Kurikulum Profesional',
                  style: AppTypography.bodyText(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Student Level & XP Pill
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
                    Icons.star_rounded,
                    size: 15,
                    color: Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Lv.${_lmsService.currentLevel} • ${_lmsService.earnedXp} XP',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 1. LMS Student Banner Header Card
          SliverToBoxAdapter(
            child: LmsStudentHeaderCard(lmsService: _lmsService),
          ),

          // 2. Learning Track Selector
          SliverToBoxAdapter(
            child: LearningTrackSelector(
              selectedTrack: _selectedTrack,
              onTrackSelected: (track) {
                setState(() {
                  _selectedTrack = track;
                  _selectedModule = FundamentalModule.all;
                });
              },
              lmsService: _lmsService,
            ),
          ),

          // 3. Akses Cepat (4 Column Clean Grid)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.grid_view_rounded,
                        size: 17,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Akses Cepat',
                        style: AppTypography.headingTitle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickAccessCard(
                          title: 'Arena Kuis',
                          icon: Icons.play_circle_outline_rounded,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AssessmentArenaPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildQuickAccessCard(
                          title: 'Inspector',
                          icon: Icons.tune_rounded,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const WidgetInspectorStudioPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildQuickAccessCard(
                          title: 'Capstone',
                          icon: Icons.star_border_rounded,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const CapstoneProjectsHubPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildQuickAccessCard(
                          title: 'Sertifikasi',
                          icon: Icons.north_east_rounded,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CertificateViewPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 4. Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
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
                    hintText:
                        'Cari materi (Lifecycle, Three Trees, State...)',
                    hintStyle: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF94A3B8),
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: Color(0xFF94A3B8),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 5. Category Filter Tabs (Pills)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _availableModulesForCurrentTrack.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final mod = _availableModulesForCurrentTrack[index];
                  final isSelected = _selectedModule == mod;

                  return InkWell(
                    onTap: () => setState(() => _selectedModule = mod),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.borderSubtle,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (mod != FundamentalModule.all) ...[
                            Icon(
                              _getModuleCategoryIcon(mod),
                              size: 14,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            mod.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 6. Section Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    'MODUL TERSEDIA (${_selectedModule == FundamentalModule.all ? "SEMUA MODUL" : _selectedModule.title.toUpperCase()})',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Total ${filtered.length} Materi',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 7. Lessons List
          if (filtered.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.search_off_rounded,
                      size: 48,
                      color: Color(0xFFCBD5E1),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tidak ada materi yang cocok',
                      style: AppTypography.headingTitle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final lesson = filtered[index];
                    return _buildLessonCard(context, lesson);
                  },
                  childCount: filtered.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.borderSubtle, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderSubtle, width: 1),
              ),
              child: Icon(
                icon,
                size: 18,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getModuleCategoryIcon(FundamentalModule mod) {
    return mod.icon;
  }

  Widget _buildLessonCard(BuildContext context, LessonItem lesson) {
    final isDone = _lmsService.isLessonCompleted(lesson.id);
    final isBookmarked = _lmsService.isLessonBookmarked(lesson.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDone ? const Color(0xFFBBF7D0) : AppColors.borderSubtle,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LessonDetailPage(lesson: lesson),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Order Badge (#01), Module Tag, Bookmark icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDone
                          ? const Color(0xFFF0FDF4)
                          : const Color(0xFFF0F9FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '#${lesson.order.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: isDone
                            ? const Color(0xFF16A34A)
                            : AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    lesson.module.title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      size: 20,
                      color: isBookmarked
                          ? AppColors.primary
                          : const Color(0xFFCBD5E1),
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      _lmsService.toggleLessonBookmark(lesson.id);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                lesson.title,
                style: AppTypography.headingTitle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),

              // Subtitle
              Text(
                lesson.subtitle,
                style: AppTypography.bodyText(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Footer Meta Row: Read time, XP Pill, Content Type tag
              Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${lesson.readTimeMinutes} m',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),

                  // XP Reward Pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
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
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isDone
                              ? Icons.check_circle_rounded
                              : Icons.star_rounded,
                          size: 12,
                          color: isDone
                              ? const Color(0xFF16A34A)
                              : const Color(0xFFD97706),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isDone ? 'Tuntas' : '+50 XP',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDone
                                ? const Color(0xFF15803D)
                                : const Color(0xFFB45309),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Content Type Tag (Diagram / Code Lab / Teori & Praktek)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F9FF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFFBAE6FD),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getLessonTypeIcon(lesson),
                          size: 12,
                          color: const Color(0xFF0284C7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getLessonTypeLabel(lesson),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF0284C7),
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }

  IconData _getLessonTypeIcon(LessonItem lesson) {
    if (lesson.visualizerBuilder != null) {
      return Icons.account_tree_outlined;
    } else if (lesson.sections.any((s) => s.codeSnippet != null && s.codeSnippet!.isNotEmpty)) {
      return Icons.code_rounded;
    } else {
      return Icons.article_outlined;
    }
  }

  String _getLessonTypeLabel(LessonItem lesson) {
    if (lesson.visualizerBuilder != null) {
      return 'Diagram';
    } else if (lesson.sections.any((s) => s.codeSnippet != null && s.codeSnippet!.isNotEmpty)) {
      return 'Code Lab';
    } else {
      return 'Teori & Praktek';
    }
  }
}
