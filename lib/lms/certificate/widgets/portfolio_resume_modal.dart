import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../capstone/data/capstone_projects_data.dart';
import '../../services/lms_progress_service.dart';

class PortfolioResumeModal extends StatefulWidget {
  final LmsProgressService lmsService;

  const PortfolioResumeModal({super.key, required this.lmsService});

  static void show(BuildContext context, LmsProgressService lmsService) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PortfolioResumeModal(lmsService: lmsService),
    );
  }

  @override
  State<PortfolioResumeModal> createState() => _PortfolioResumeModalState();
}

class _PortfolioResumeModalState extends State<PortfolioResumeModal> {
  int _selectedFormatIndex = 0; // 0: Plain Text (LinkedIn), 1: Markdown (GitHub)

  String _generateMarkdownResume() {
    final s = widget.lmsService;
    final name = s.studentName;
    final certId = s.certificateId ?? 'FL-LMS-2026-PENDING';
    final levelTitle = s.levelTitle;
    final xp = s.earnedXp;

    final buffer = StringBuffer();
    buffer.writeln('# 🎓 $name - Flutter & Dart Engineer Portfolio');
    buffer.writeln('**Credential ID:** `$certId` | **Level:** $levelTitle ($xp XP)');
    buffer.writeln('**Program:** Flutter Learning Hub Professional Curriculum');
    buffer.writeln();
    buffer.writeln('## 🚀 Executive Summary');
    buffer.writeln(
        'Verified Flutter & Dart software engineer with hands-on proficiency in production Clean Architecture, state orchestration (BLoC & Riverpod), responsive UI systems, custom graphics via CustomPainter, and network resiliency.');
    buffer.writeln();
    buffer.writeln('## 🛠️ Verified Technical Competencies');
    buffer.writeln('- **Core Flutter & Dart 3:** OOP, Patterns, Records, Isolates, BuildOwner/PipelineOwner');
    buffer.writeln('- **Architecture:** Clean Architecture (Data-Domain-Presentation layers), Repository Pattern');
    buffer.writeln('- **State Management:** BLoC / Cubit, Riverpod 2.x, InheritedWidget mechanics');
    buffer.writeln('- **Networking & Storage:** Dio with JWT Interceptors, SQLite/Drift, Local Caching');
    buffer.writeln('- **Graphics & Animation:** Canvas CustomPainter, Bezier curves, Shaders, 60 FPS optimization');
    buffer.writeln('- **Quality Assurance:** Unit Tests, Widget Tests, Automated CI validation');
    buffer.writeln();
    buffer.writeln('## 📦 Capstone Projects Showcase');

    final capstones = CapstoneProjectsData.allProjects;
    for (final cap in capstones) {
      final isDone = s.completedCapstoneIds.contains(cap.id);
      final statusMark = isDone ? '✅ [COMPLETED]' : '⏳ [IN-PROGRESS]';
      buffer.writeln('### $statusMark ${cap.title}');
      buffer.writeln('*${cap.tagline}*');
      buffer.writeln('- **Tech Stack:** ${cap.techStack.join(', ')}');
      buffer.writeln('- **Estimated Build Effort:** ${cap.estimatedHours}');
      buffer.writeln('- **Key Deliverables:**');
      for (final arch in cap.architecturePoints.take(2)) {
        buffer.writeln('  * $arch');
      }
      buffer.writeln();
    }

    buffer.writeln('---');
    buffer.writeln('🔍 *Verified by Naltech Engineering Registry: https://flutter-learning-hub.naltech.dev/verify/$certId*');

    return buffer.toString();
  }

  String _generatePlainTextResume() {
    final s = widget.lmsService;
    final name = s.studentName;
    final certId = s.certificateId ?? 'FL-LMS-2026-PENDING';
    final levelTitle = s.levelTitle;

    final buffer = StringBuffer();
    buffer.writeln('FLUTTER ENGINEER PORTFOLIO & VERIFIED CREDENTIALS');
    buffer.writeln('Nama: $name');
    buffer.writeln('Peringkat: $levelTitle | Credential ID: $certId');
    buffer.writeln('Status: Lulusan Tersertifikasi Resmi (Naltech Learning Hub)');
    buffer.writeln('--------------------------------------------------');
    buffer.writeln('KOMPETENSI TEKNIS:');
    buffer.writeln('• Clean Architecture (Data, Domain, Presentation)');
    buffer.writeln('• BLoC & Riverpod State Management');
    buffer.writeln('• Dio Network Interceptors & Token Refresh');
    buffer.writeln('• Custom Canvas Graphics & Interactive Shaders');
    buffer.writeln('• Automated Widget & Unit Testing');
    buffer.writeln('--------------------------------------------------');
    buffer.writeln('CAPSTONE PROJECTS:');
    for (final cap in CapstoneProjectsData.allProjects) {
      final isDone = s.completedCapstoneIds.contains(cap.id);
      final status = isDone ? '[Selesai]' : '[Sedang Berjalan]';
      buffer.writeln('• $status ${cap.title} (${cap.techStack.take(3).join(', ')})');
    }
    buffer.writeln('--------------------------------------------------');
    buffer.writeln('Verifikasi online: https://flutter-learning-hub.naltech.dev/verify/$certId');

    return buffer.toString();
  }

  void _copyToClipboard() {
    final text = _selectedFormatIndex == 0
        ? _generatePlainTextResume()
        : _generateMarkdownResume();

    Clipboard.setData(ClipboardData(text: text));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _selectedFormatIndex == 0
              ? 'Resume Plain Text disalin! Siap ditempel ke LinkedIn / CV.'
              : 'Resume Markdown disalin! Siap ditempel ke GitHub / README.',
        ),
        backgroundColor: const Color(0xFF4F46E5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final previewText = _selectedFormatIndex == 0
        ? _generatePlainTextResume()
        : _generateMarkdownResume();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.assignment_ind_rounded,
                  color: Color(0xFF4F46E5),
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan Portofolio & CV',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Format siap pakai untuk LinkedIn, GitHub, dan Resume kerja',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Format Segmented Toggle
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedFormatIndex = 0),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedFormatIndex == 0
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _selectedFormatIndex == 0
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'LinkedIn & Plain Text',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: _selectedFormatIndex == 0
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: _selectedFormatIndex == 0
                              ? const Color(0xFF4F46E5)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedFormatIndex = 1),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedFormatIndex == 1
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _selectedFormatIndex == 1
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'GitHub Markdown',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: _selectedFormatIndex == 1
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: _selectedFormatIndex == 1
                              ? const Color(0xFF4F46E5)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Code / Text Preview Container
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  previewText,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: Color(0xFFE2E8F0),
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _copyToClipboard,
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: Text(
                    _selectedFormatIndex == 0
                        ? 'Salin Teks LinkedIn'
                        : 'Salin Teks Markdown',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Batal'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
