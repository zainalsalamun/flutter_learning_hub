import 'package:flutter/material.dart';
import '../../services/lms_progress_service.dart';
import '../data/assessments_data.dart';
import '../models/assessment_model.dart';
import 'interactive_assessment_play_page.dart';

class AssessmentArenaPage extends StatefulWidget {
  const AssessmentArenaPage({super.key});

  @override
  State<AssessmentArenaPage> createState() => _AssessmentArenaPageState();
}

class _AssessmentArenaPageState extends State<AssessmentArenaPage> {
  final LmsProgressService _lmsService = LmsProgressService.instance;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final assessments = AssessmentsData.allAssessments;
    final passedCount = _lmsService.totalAssessmentsPassed;
    final totalCount = assessments.length;

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
        title: const Row(
          children: [
            Icon(Icons.quiz_rounded, color: Color(0xFF6366F1), size: 22),
            SizedBox(width: 8),
            Text(
              'Arena Kuis & Ujian Kompetensi',
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero Arena Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF312E81), Color(0xFF4338CA), Color(0xFF6366F1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.military_tech_rounded,
                        color: Color(0xFFFDE047),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sertifikasi & Uji Kompetensi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Selesaikan ujian evaluasi di tiap track untuk mengklaim hingga +620 XP dan membuka lencana prestasi.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 11.5,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Statistics Row
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      _buildArenaStat(
                        label: 'Ujian Lulus',
                        value: '$passedCount / $totalCount Track',
                        icon: Icons.verified_rounded,
                        color: const Color(0xFF4ADE80),
                      ),
                      Container(
                        width: 1,
                        height: 28,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      _buildArenaStat(
                        label: 'Lencana Kuis',
                        value: _lmsService.isBadgeUnlocked('quiz_champion')
                            ? 'Juara Kuis'
                            : _lmsService.isBadgeUnlocked('quiz_whiz')
                                ? 'Pakar Kuis'
                                : 'Terkunci',
                        icon: Icons.workspace_premium_rounded,
                        color: const Color(0xFFFDE047),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Daftar Ujian Evaluasi Jalur Pembelajaran:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),

          // Assessment Cards List
          ...assessments.map((item) => _buildAssessmentCard(context, item)),

          const SizedBox(height: 10),

          // Exam Tips Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_rounded, color: Color(0xFF16A34A), size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tips Pengerjaan Ujian:',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF166534),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Setiap soal dirancang menguji pemahaman kasus nyata dan jebakan sintaks kode. Jika belum mencapai 70%, kamu bisa mengulang ujian kapan saja.',
                        style: TextStyle(fontSize: 11.5, color: Color(0xFF15803D), height: 1.35),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildArenaStat({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentCard(BuildContext context, AssessmentTrackModel item) {
    final score = _lmsService.getAssessmentScore(item.id);
    final isPassed = _lmsService.isAssessmentPassed(item.id, passingScore: item.passingScore);
    final hasAttempted = score != null;

    Color badgeBg;
    Color badgeText;
    String statusLabel;
    IconData statusIcon;

    if (isPassed) {
      badgeBg = const Color(0xFFDCFCE7);
      badgeText = const Color(0xFF166534);
      statusLabel = 'Lulus ($score%)';
      statusIcon = Icons.check_circle_rounded;
    } else if (hasAttempted) {
      badgeBg = const Color(0xFFFEF3C7);
      badgeText = const Color(0xFF92400E);
      statusLabel = 'Remedial ($score%)';
      statusIcon = Icons.warning_rounded;
    } else {
      badgeBg = item.color.withValues(alpha: 0.1);
      badgeText = item.color;
      statusLabel = 'Tersedia (+${item.rewardXp} XP)';
      statusIcon = Icons.play_arrow_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isPassed
              ? const Color(0xFF86EFAC)
              : const Color(0xFFE2E8F0),
          width: isPassed ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Icon, Title & Status Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 12, color: badgeText),
                      const SizedBox(width: 4),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: badgeText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Text(
              item.description,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF475569),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),

            // Meta Info Chips
            Row(
              children: [
                _buildInfoChip(Icons.timer_outlined, '${item.timeLimitMinutes} Menit'),
                const SizedBox(width: 6),
                _buildInfoChip(Icons.help_outline_rounded, '${item.questions.length} Soal'),
                const SizedBox(width: 6),
                _buildInfoChip(Icons.verified_outlined, 'Min ${item.passingScore}%'),
                const Spacer(),
                // Start Button
                FilledButton.icon(
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
                    isPassed ? Icons.refresh_rounded : Icons.play_arrow_rounded,
                    size: 16,
                  ),
                  label: Text(
                    isPassed ? 'Uji Lagi' : (hasAttempted ? 'Remedial' : 'Mulai Ujian'),
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: isPassed
                        ? const Color(0xFF16A34A)
                        : item.color,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.5, color: const Color(0xFF64748B)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}
