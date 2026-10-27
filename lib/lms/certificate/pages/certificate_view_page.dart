import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../capstone/data/capstone_projects_data.dart';
import '../../capstone/pages/capstone_project_detail_page.dart';
import '../../capstone/pages/capstone_projects_hub_page.dart';
import '../../quiz/pages/assessment_arena_page.dart';
import '../../services/lms_progress_service.dart';
import '../widgets/luxury_certificate_painter.dart';
import '../widgets/online_credential_verification_dialog.dart';
import '../widgets/portfolio_resume_modal.dart';
import 'certificate_landscape_preview_page.dart';

class CertificateViewPage extends StatefulWidget {
  const CertificateViewPage({super.key});

  @override
  State<CertificateViewPage> createState() => _CertificateViewPageState();
}

class _CertificateViewPageState extends State<CertificateViewPage>
    with SingleTickerProviderStateMixin {
  final LmsProgressService _lmsService = LmsProgressService.instance;
  final TextEditingController _nameController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _nameController.text = _lmsService.studentName;
    _lmsService.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _lmsService.removeListener(_onServiceUpdate);
    _nameController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  Future<void> _claimCertificate() async {
    final certId = await _lmsService.issueCertificate();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selamat atas kelulusan Anda! ID Sertifikat: $certId (+300 XP).',
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showEditNameDialog() {
    _nameController.text = _lmsService.studentName;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Nama pada Sertifikat'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Nama Lengkap Siswa',
            hintText: 'Contoh: Alex Pratama, S.Kom',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_nameController.text.trim().isNotEmpty) {
                await _lmsService.updateStudentName(_nameController.text.trim());
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _copyCredential() {
    final certId = _lmsService.certificateId ?? 'FL-LMS-2026-PENDING';
    final text =
        'Verifikasi Kredensial Flutter Learning Hub\nNama: ${_lmsService.studentName}\nCredential ID: $certId\nStatus: TERVERIFIKASI RESMI';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kredensial sertifikat berhasil disalin ke clipboard.'),
        backgroundColor: Color(0xFF4F46E5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openVerificationDialog() {
    final certId = _lmsService.certificateId ?? 'FL-LMS-2026-PREVIEW';
    final issueDate = _lmsService.certificateIssuedDate ?? DateTime.now();
    final formattedDate =
        '${issueDate.day} ${_getMonthName(issueDate.month)} ${issueDate.year}';

    OnlineCredentialVerificationDialog.show(
      context,
      certId: certId,
      studentName: _lmsService.studentName,
      issueDateText: formattedDate,
      completedLessonsCount: _lmsService.completedLessonsCount,
      completedCapstonesCount: _lmsService.completedCapstoneIds.length,
      totalXp: _lmsService.earnedXp,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0F172A),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sertifikat & Portofolio Kelulusan',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_rounded, color: Color(0xFF64748B), size: 20),
            tooltip: 'Salin ID Kredensial',
            onPressed: _copyCredential,
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF4F46E5), size: 21),
            tooltip: 'Validasi Kredensial',
            onPressed: _openVerificationDialog,
          ),
          IconButton(
            icon: const Icon(Icons.fullscreen_rounded, color: Color(0xFF0F172A), size: 24),
            tooltip: 'Layar Penuh (Landscape)',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CertificateLandscapePreviewPage(lmsService: _lmsService),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF4F46E5),
          unselectedLabelColor: const Color(0xFF64748B),
          indicatorColor: const Color(0xFF4F46E5),
          indicatorWeight: 2.5,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          tabs: const [
            Tab(
              icon: Icon(Icons.workspace_premium_rounded, size: 18),
              text: 'Sertifikat Digital',
            ),
            Tab(
              icon: Icon(Icons.badge_rounded, size: 18),
              text: 'Portofolio & Resume',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCertificateTab(),
          _buildPortfolioResumeTab(),
        ],
      ),
    );
  }

  // =========================================================================
  // TAB 1: SERTIFIKAT DIGITAL RESMI
  // =========================================================================
  Widget _buildCertificateTab() {
    final isEligible = _lmsService.isEligibleForCertificate;
    final hasClaimed = _lmsService.hasClaimedCertificate;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isEligible && !hasClaimed)
            _buildIneligibleRequirementsCard()
          else ...[
            if (!hasClaimed) _buildClaimBanner(),
            _buildLuxuryDigitalCertificateCard(),
            const SizedBox(height: 16),
            _buildActionButtons(),
          ],
        ],
      ),
    );
  }

  // =========================================================================
  // REQUIREMENTS CARD WHEN INELIGIBLE
  // =========================================================================
  Widget _buildIneligibleRequirementsCard() {
    final passedAssessments = _lmsService.totalAssessmentsPassed;
    final completedLessons = _lmsService.completedLessonsCount;
    final completedCapstones = _lmsService.completedCapstoneIds.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_clock_rounded,
                color: Color(0xFFD97706),
                size: 42,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Center(
            child: Text(
              'Sertifikat Masih Terkunci',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              'Selesaikan persyaratan kelulusan berikut untuk membuka sertifikat digital resmi Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 16),

          // Prerequisite 1: All 4 Assessments
          _buildPrerequisiteItem(
            title: 'Lulus 4 Ujian Evaluasi Jalur Karir',
            current: passedAssessments,
            target: 4,
            unit: 'Ujian',
            actionText: 'Buka Arena Kuis',
            onAction: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AssessmentArenaPage()),
              );
            },
          ),
          const SizedBox(height: 14),

          // Prerequisite 2: 18 Lessons OR 1 Capstone
          _buildPrerequisiteItem(
            title: 'Minimal 18 Materi Tuntas ATAU 1 Capstone Selesai',
            current: (completedLessons >= 18 || completedCapstones >= 1) ? 1 : 0,
            target: 1,
            unit: 'Syarat',
            subtitle:
                'Saat ini: $completedLessons/18 materi & $completedCapstones capstone selesai.',
            actionText: 'Lanjut Belajar',
            onAction: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPrerequisiteItem({
    required String title,
    required int current,
    required int target,
    required String unit,
    String? subtitle,
    required String actionText,
    required VoidCallback onAction,
  }) {
    final isDone = current >= target;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDone ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDone ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isDone
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isDone ? const Color(0xFF10B981) : Colors.grey,
                size: 19,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5,
                    color: isDone
                        ? const Color(0xFF166534)
                        : const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '$current/$target',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: isDone ? const Color(0xFF10B981) : Colors.grey.shade700,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.only(left: 27),
              child: Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          if (!isDone) ...[
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(actionText, style: const TextStyle(fontSize: 11)),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 9),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================================
  // CLAIM BANNER
  // =========================================================================
  Widget _buildClaimBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF4338CA)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.celebration_rounded, color: Colors.white, size: 26),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Syarat Kelulusan Terpenuhi!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Klaim sertifikat kelulusan resmi & raih bonus +300 XP.',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _claimCertificate,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4F46E5),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Klaim',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // LUXURIOUS DIGITAL CERTIFICATE CARD WITH CUSTOM PAINTER
  // =========================================================================
  Widget _buildLuxuryDigitalCertificateCard() {
    final certId = _lmsService.certificateId ?? 'FL-LMS-2026-PREVIEW';
    final issueDate = _lmsService.certificateIssuedDate ?? DateTime.now();
    final formattedDate =
        '${issueDate.day} ${_getMonthName(issueDate.month)} ${issueDate.year}';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CustomPaint(
          painter: LuxuryCertificatePainter(
            certId: certId,
            studentName: _lmsService.studentName,
            issueDateText: formattedDate,
            isEligible: _lmsService.hasClaimedCertificate,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Seal / Crest
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: Color(0xFFD97706),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 8),

                // Organization & Title
                const Text(
                  'NALTECH FLUTTER ACADEMY',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 2.2,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'CERTIFICATE OF MASTERY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Diberikan dengan kehormatan tertinggi kepada:',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 10),

                // Student Name with Edit Action
                InkWell(
                  onTap: _showEditNameDialog,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            _lmsService.studentName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4338CA),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.edit_outlined,
                          size: 13,
                          color: Color(0xFF6366F1),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Citation
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    'Atas keberhasilan menuntaskan kurikulum Flutter Engineering, meluluskan seluruh Ujian Jalur Karir, serta membangun arsitektur portofolio Clean Architecture.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Colors.grey.shade700,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 12),

                // Bottom Credential Row with Interactive Tap-to-Verify
                InkWell(
                  onTap: _openVerificationDialog,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TANGGAL TERBIT',
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'CREDENTIAL ID',
                                  style: TextStyle(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                                SizedBox(width: 3),
                                Icon(Icons.verified_rounded, size: 10, color: Color(0xFF10B981)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                certId,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CertificateLandscapePreviewPage(lmsService: _lmsService),
                    ),
                  );
                },
                icon: const Icon(Icons.fullscreen_rounded, size: 18),
                label: const Text('Layar Penuh'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  foregroundColor: const Color(0xFF0F172A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _openVerificationDialog,
                icon: const Icon(Icons.verified_user_rounded, size: 16),
                label: const Text('Cek Verifikasi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () => PortfolioResumeModal.show(context, _lmsService),
            icon: const Icon(Icons.badge_rounded, size: 16, color: Color(0xFF4F46E5)),
            label: const Text(
              'Buka Generator Resume Portofolio (LinkedIn / GitHub)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4F46E5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // TAB 2: PORTOFOLIO & RESUME CAPSTONE SHOWCASE
  // =========================================================================
  Widget _buildPortfolioResumeTab() {
    final capstones = CapstoneProjectsData.allProjects;
    final completedCapstones = _lmsService.completedCapstoneIds;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.rocket_launch_rounded,
                        color: Color(0xFF4F46E5),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _lmsService.studentName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Peringkat: ${_lmsService.levelTitle} (${_lmsService.earnedXp} XP)',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4F46E5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Portofolio ini mengombinasikan proyek Capstone berskala industri, modul fundamental, dan bukti kredensial tersertifikasi.',
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B), height: 1.4),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  onPressed: () => PortfolioResumeModal.show(context, _lmsService),
                  icon: const Icon(Icons.share_rounded, size: 16),
                  label: const Text('Ekspor Resume (LinkedIn & GitHub Ready)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Capstone Projects Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CAPSTONE PORTFOLIO PROJECTS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '${completedCapstones.length} / ${capstones.length} Selesai',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Capstone Project Cards
          for (final cap in capstones)
            _buildCapstoneResumeCard(cap, completedCapstones.contains(cap.id)),

          const SizedBox(height: 14),

          // Hub Navigation Link
          Center(
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CapstoneProjectsHubPage()),
                );
              },
              icon: const Icon(Icons.open_in_new_rounded, size: 15),
              label: const Text(
                'Buka Studio Capstone Projects Lengkap',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapstoneResumeCard(dynamic cap, bool isDone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDone ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
          width: isDone ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: isDone ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  cap.icon,
                  size: 18,
                  color: isDone ? const Color(0xFF16A34A) : const Color(0xFF475569),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cap.title,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      cap.tagline,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: isDone ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isDone ? 'Selesai' : 'Tersedia',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: isDone ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Tech stack tags
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              for (final tech in (cap.techStack as List<String>).take(4))
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    tech,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CapstoneProjectDetailPage(project: cap),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 14),
              label: const Text('Buka Proyek', style: TextStyle(fontSize: 11.5)),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return (month >= 1 && month <= 12) ? months[month - 1] : '';
  }
}
