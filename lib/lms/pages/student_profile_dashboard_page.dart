import 'package:flutter/material.dart';
import '../../basics/data/basic_widgets_data.dart';
import '../../basics/pages/basic_widget_detail_page.dart';
import '../../catalog/data/widget_catalog_registry.dart';
import '../../catalog/pages/widget_detail_playground_page.dart';
import '../../fundamentals/data/lessons_repository.dart';
import '../../fundamentals/models/lesson_item.dart';
import '../../fundamentals/pages/lesson_detail_page.dart';
import '../capstone/pages/capstone_projects_hub_page.dart';
import '../certificate/pages/certificate_view_page.dart';
import '../data/lms_badges_data.dart';
import '../models/lms_badge.dart';
import '../quiz/data/assessments_data.dart';
import '../quiz/models/assessment_model.dart';
import '../quiz/pages/interactive_assessment_play_page.dart';
import '../services/lms_progress_service.dart';
import '../widgets/lesson_notes_bottom_sheet.dart';

class StudentProfileDashboardPage extends StatefulWidget {
  const StudentProfileDashboardPage({super.key});

  @override
  State<StudentProfileDashboardPage> createState() =>
      _StudentProfileDashboardPageState();
}

class _StudentProfileDashboardPageState
    extends State<StudentProfileDashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final LmsProgressService _lmsService = LmsProgressService.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _lmsService.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _lmsService.removeListener(_onServiceUpdate);
    _tabController.dispose();
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final level = _lmsService.currentLevel;
    final levelTitle = _lmsService.levelTitle;
    final xp = _lmsService.earnedXp;
    final streak = _lmsService.streakDays;
    final completedCount = _lmsService.completedLessonsCount;
    final totalCount = _lmsService.totalLessonsCount;
    final fraction = _lmsService.levelProgressFraction;
    final unlockedBadges = _lmsService.unlockedBadgesCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profil & Rapor Belajar',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.rocket_launch_rounded,
                color: Color(0xFF10B981), size: 21),
            tooltip: 'Capstone Portfolio Lab',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const CapstoneProjectsHubPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.workspace_premium_rounded,
                color: Color(0xFFF59E0B), size: 23),
            tooltip: 'Sertifikat Kelulusan Resmi',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const CertificateViewPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 64,
                          height: 64,
                          child: CircularProgressIndicator(
                            value: fraction,
                            strokeWidth: 4.5,
                            backgroundColor: const Color(0xFFE2E8F0),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF6366F1),
                            ),
                          ),
                        ),
                        Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Lv.$level',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            levelTitle,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total Pengalaman: $xp XP',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // 3 Stat Chips
                Row(
                  children: [
                    _buildStatCard(
                      icon: Icons.check_circle_rounded,
                      iconColor: const Color(0xFF10B981),
                      title: 'Selesai',
                      value: '$completedCount / $totalCount',
                    ),
                    const SizedBox(width: 6),
                    _buildStatCard(
                      icon: Icons.quiz_rounded,
                      iconColor: const Color(0xFF6366F1),
                      title: 'Ujian',
                      value: '${_lmsService.totalAssessmentsPassed} / ${AssessmentsData.allAssessments.length}',
                    ),
                    const SizedBox(width: 6),
                    _buildStatCard(
                      icon: Icons.local_fire_department_rounded,
                      iconColor: const Color(0xFFF97316),
                      title: 'Streak',
                      value: '$streak d',
                    ),
                    const SizedBox(width: 6),
                    _buildStatCard(
                      icon: Icons.workspace_premium_rounded,
                      iconColor: const Color(0xFFFBBF24),
                      title: 'Lencana',
                      value: '$unlockedBadges / ${LmsBadgesData.allBadges.length}',
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Graduation & Capstone Fast Track Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: (_lmsService.hasClaimedCertificate
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFF59E0B))
                              .withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _lmsService.hasClaimedCertificate
                              ? Icons.verified_rounded
                              : Icons.workspace_premium_rounded,
                          color: _lmsService.hasClaimedCertificate
                              ? const Color(0xFF34D399)
                              : const Color(0xFFFBBF24),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _lmsService.hasClaimedCertificate
                                  ? 'Sertifikat Terbit: ${_lmsService.certificateId}'
                                  : 'Sertifikat Kelulusan Resmi',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              _lmsService.hasClaimedCertificate
                                  ? 'Terverifikasi resmi sebagai Flutter Engineer'
                                  : 'Lulus 4 ujian track & klaim kredensial resmi',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CertificateViewPage()),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _lmsService.hasClaimedCertificate ? 'Lihat' : 'Status',
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF6366F1),
              unselectedLabelColor: const Color(0xFF64748B),
              indicatorColor: const Color(0xFF6366F1),
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(icon: Icon(Icons.workspace_premium_rounded, size: 20), text: 'Lencana'),
                Tab(icon: Icon(Icons.quiz_rounded, size: 20), text: 'Ujian'),
                Tab(icon: Icon(Icons.bookmark_rounded, size: 20), text: 'Tersimpan'),
                Tab(icon: Icon(Icons.edit_note_rounded, size: 20), text: 'Catatan'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBadgesTab(),
                _buildAssessmentsTab(),
                _buildBookmarksTab(),
                _buildNotesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 14, color: iconColor),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // TAB 1: BADGES
  // =========================================================================

  Widget _buildBadgesTab() {
    final badges = LmsBadgesData.allBadges;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        final isUnlocked = _lmsService.isBadgeUnlocked(badge.id);

        return InkWell(
          onTap: () => _showBadgeDetail(badge, isUnlocked),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUnlocked ? Colors.white : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isUnlocked
                    ? badge.color.withValues(alpha: 0.4)
                    : const Color(0xFFCBD5E1),
                width: isUnlocked ? 1.5 : 1,
              ),
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                        color: badge.color.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isUnlocked
                            ? badge.color.withValues(alpha: 0.15)
                            : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        badge.icon,
                        size: 24,
                        color: isUnlocked ? badge.color : Colors.grey.shade600,
                      ),
                    ),
                    if (!isUnlocked)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock_rounded,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  badge.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? const Color(0xFF0F172A) : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isUnlocked ? 'Terbuka' : 'Terkunci',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: isUnlocked ? badge.color : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBadgeDetail(LmsBadge badge, bool isUnlocked) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? badge.color.withValues(alpha: 0.15)
                    : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                badge.icon,
                size: 36,
                color: isUnlocked ? badge.color : Colors.grey,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              badge.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569)),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Syarat Pembukaan:',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    badge.requirement,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isUnlocked ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isUnlocked ? 'Status: Telah Diraih' : 'Status: Masih Terkunci',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isUnlocked ? const Color(0xFF166534) : Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // TAB 2: ASSESSMENTS / UJIAN
  // =========================================================================

  Widget _buildAssessmentsTab() {
    final assessments = AssessmentsData.allAssessments;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: assessments.length,
      itemBuilder: (context, index) {
        final item = assessments[index];
        final score = _lmsService.getAssessmentScore(item.id);
        final isPassed = _lmsService.isAssessmentPassed(
          item.id,
          passingScore: item.passingScore,
        );

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isPassed
                  ? const Color(0xFF86EFAC)
                  : const Color(0xFFE2E8F0),
              width: isPassed ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: item.color.withValues(alpha: 0.15),
                      child: Icon(item.icon, color: item.color, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Passing grade: ${item.passingScore}% • Hadiah: +${item.rewardXp} XP',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
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
                        color: isPassed
                            ? const Color(0xFFDCFCE7)
                            : score != null
                                ? const Color(0xFFFEF3C7)
                                : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isPassed
                            ? 'Lulus ($score%)'
                            : score != null
                                ? 'Skor: $score%'
                                : 'Belum Ujian',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: isPassed
                              ? const Color(0xFF166534)
                              : score != null
                                  ? const Color(0xFFB45309)
                                  : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InteractiveAssessmentPlayPage(
                            assessment: item,
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      isPassed
                          ? Icons.refresh_rounded
                          : Icons.play_arrow_rounded,
                      size: 16,
                    ),
                    label: Text(
                      isPassed ? 'Uji Ulang / Latihan' : 'Mulai Ujian Sekarang',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          isPassed ? const Color(0xFF10B981) : item.color,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================================================================
  // TAB 3: BOOKMARKS
  // =========================================================================

  Widget _buildBookmarksTab() {
    final bookmarkedLessonIds = _lmsService.progress.bookmarkedLessonIds;
    final bookmarkedWidgetIds = _lmsService.progress.bookmarkedWidgetIds;

    final bookmarkedLessons = LessonsRepository.allLessons
        .where((l) => bookmarkedLessonIds.contains(l.id))
        .toList();

    final bookmarkedBasicWidgets = BasicWidgetsData.allWidgets
        .where((w) => bookmarkedWidgetIds.contains(w.id))
        .toList();

    final bookmarkedProWidgets = WidgetCatalogRegistry.allWidgets
        .where((w) => bookmarkedWidgetIds.contains(w.id))
        .toList();

    if (bookmarkedLessons.isEmpty &&
        bookmarkedBasicWidgets.isEmpty &&
        bookmarkedProWidgets.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bookmark_border_rounded, size: 56, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              'Belum ada materi atau widget tersimpan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tekan ikon bookmark pada materi atau widget favoritmu',
              style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (bookmarkedLessons.isNotEmpty) ...[
          const Text(
            'Materi Teori & Visualizer:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 8),
          ...bookmarkedLessons.map((lesson) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: lesson.module.color.withValues(alpha: 0.15),
                  child: Icon(lesson.icon, color: lesson.module.color, size: 20),
                ),
                title: Text(
                  lesson.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                subtitle: Text(
                  lesson.module.title,
                  style: TextStyle(color: lesson.module.color, fontSize: 11),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.bookmark_remove_rounded, color: Colors.red),
                  onPressed: () => _lmsService.toggleLessonBookmark(lesson.id),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LessonDetailPage(lesson: lesson)),
                  );
                },
              ),
            );
          }),
          const SizedBox(height: 16),
        ],

        if (bookmarkedBasicWidgets.isNotEmpty) ...[
          const Text(
            'Koleksi Basic Widgets:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 8),
          ...bookmarkedBasicWidgets.map((item) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: item.category.color.withValues(alpha: 0.15),
                  child: Icon(item.category.icon, color: item.category.color, size: 20),
                ),
                title: Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                subtitle: Text(
                  item.category.title,
                  style: TextStyle(color: item.category.color, fontSize: 11),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.bookmark_remove_rounded, color: Colors.red),
                  onPressed: () => _lmsService.toggleWidgetBookmark(item.id),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BasicWidgetDetailPage(item: item),
                    ),
                  );
                },
              ),
            );
          }),
          const SizedBox(height: 16),
        ],

        if (bookmarkedProWidgets.isNotEmpty) ...[
          const Text(
            'Koleksi Pro Widgets:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 8),
          ...bookmarkedProWidgets.map((item) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: item.category.color.withValues(alpha: 0.15),
                  child: Icon(item.category.icon, color: item.category.color, size: 20),
                ),
                title: Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                subtitle: Text(
                  item.category.title,
                  style: TextStyle(color: item.category.color, fontSize: 11),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.bookmark_remove_rounded, color: Colors.red),
                  onPressed: () => _lmsService.toggleWidgetBookmark(item.id),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WidgetDetailPlaygroundPage(item: item),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ],
    );
  }

  // =========================================================================
  // TAB 3: NOTES
  // =========================================================================

  Widget _buildNotesTab() {
    final notes = _lmsService.progress.lessonNotes;

    if (notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_note_rounded, size: 56, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              'Belum ada catatan belajar',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Buka detail materi dan tekan ikon catatan untuk menulis rangkuman',
              style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      );
    }

    final noteEntries = notes.entries.toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: noteEntries.length,
      itemBuilder: (context, index) {
        final entry = noteEntries[index];
        final lesson = LessonsRepository.allLessons.firstWhere(
          (l) => l.id == entry.key,
          orElse: () => LessonItem(
            id: entry.key,
            title: 'Materi ${entry.key}',
            subtitle: '',
            module: LessonsRepository.allLessons.first.module,
            order: 0,
            readTimeMinutes: 5,
            icon: Icons.notes_rounded,
            summary: '',
            sections: const [],
            keyTakeaways: const [],
          ),
        );

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(lesson.icon, size: 18, color: const Color(0xFF6366F1)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        lesson.title,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_rounded, size: 18, color: Color(0xFF6366F1)),
                      onPressed: () {
                        LessonNotesBottomSheet.show(
                          context,
                          lesson: lesson,
                          lmsService: _lmsService,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    entry.value,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF334155),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
