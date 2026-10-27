import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/luxury_certificate_painter.dart';
import '../widgets/online_credential_verification_dialog.dart';
import '../../services/lms_progress_service.dart';

class CertificateLandscapePreviewPage extends StatefulWidget {
  final LmsProgressService lmsService;

  const CertificateLandscapePreviewPage({super.key, required this.lmsService});

  @override
  State<CertificateLandscapePreviewPage> createState() =>
      _CertificateLandscapePreviewPageState();
}

class _CertificateLandscapePreviewPageState
    extends State<CertificateLandscapePreviewPage> {
  final TransformationController _transformController =
      TransformationController();

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
  }

  void _copyCredential() {
    final certId = widget.lmsService.certificateId ?? 'FL-LMS-2026-PREVIEW';
    final text =
        'Verifikasi Kredensial Flutter Learning Hub\nNama: ${widget.lmsService.studentName}\nCredential ID: $certId\nStatus: TERVERIFIKASI RESMI';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kredensial sertifikat berhasil disalin!'),
        backgroundColor: Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.lmsService;
    final certId = s.certificateId ?? 'FL-LMS-2026-PREVIEW';
    final issueDate = s.certificateIssuedDate ?? DateTime.now();
    final formattedDate = '${issueDate.day} ${_getMonthName(issueDate.month)} ${issueDate.year}';

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark presentation cinema background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pratinjau Sertifikat Resmi (High-Res)',
          style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 20),
            tooltip: 'Reset Zoom',
            onPressed: _resetZoom,
          ),
          IconButton(
            icon: const Icon(Icons.verified_user_rounded, color: Color(0xFF34D399), size: 20),
            tooltip: 'Cek Verifikasi Kredensial',
            onPressed: () {
              OnlineCredentialVerificationDialog.show(
                context,
                certId: certId,
                studentName: s.studentName,
                issueDateText: formattedDate,
                completedLessonsCount: s.completedLessonsCount,
                completedCapstonesCount: s.completedCapstoneIds.length,
                totalXp: s.earnedXp,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded, size: 20),
            tooltip: 'Salin ID',
            onPressed: _copyCredential,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Hint Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: const Color(0xFF1E293B),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pinch_rounded, size: 14, color: Color(0xFF94A3B8)),
                  SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Pinch atau scroll untuk memperbesar detail ornamen guilloche & stempel segel',
                      style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Certificate Presentation Canvas
            Expanded(
              child: Center(
                child: InteractiveViewer(
                  transformationController: _transformController,
                  boundaryMargin: const EdgeInsets.all(40),
                  minScale: 0.5,
                  maxScale: 3.5,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: 580,
                      height: 390,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                            blurRadius: 36,
                            spreadRadius: 4,
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 28,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CustomPaint(
                          painter: LuxuryCertificatePainter(
                            certId: certId,
                            studentName: s.studentName,
                            issueDateText: formattedDate,
                            isEligible: s.hasClaimedCertificate,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(36, 32, 36, 26),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Header Organization
                                const Text(
                                  'NALTECH FLUTTER ENGINEERING ACADEMY',
                                  style: TextStyle(
                                    fontSize: 10,
                                    letterSpacing: 2.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'CERTIFICATE OF MASTERY',
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Dengan bangga dan kehormatan tinggi dianugerahkan kepada:',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFF475569),
                                  ),
                                ),
                                const Spacer(),

                                // Candidate Name
                                Text(
                                  s.studentName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1E3A8A),
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFF93C5FD),
                                    decorationThickness: 1.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),

                                // Citation text
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(
                                    'Atas keberhasilan menuntaskan seluruh 24 modul materi arsitektur lanjutan, meluluskan 4 Ujian Jalur Karir, serta membangun solusi Capstone berskala industri.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: Color(0xFF334155),
                                      height: 1.45,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Spacer(),

                                // Bottom Row info
                                Row(
                                  children: [
                                    const SizedBox(width: 90), // Offset for the drawn gold seal
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Lead Technical Instructor        Dean of Mobile Eng.',
                                            style: TextStyle(
                                              fontSize: 8.5,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'TERBIT: $formattedDate • ID: $certId',
                                            style: const TextStyle(
                                              fontSize: 8,
                                              fontFamily: 'monospace',
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF94A3B8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 80), // Offset for the drawn QR code
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
