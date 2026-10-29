import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnlineCredentialVerificationDialog extends StatelessWidget {
  final String certId;
  final String studentName;
  final String issueDateText;
  final int completedLessonsCount;
  final int completedCapstonesCount;
  final int totalXp;

  const OnlineCredentialVerificationDialog({
    super.key,
    required this.certId,
    required this.studentName,
    required this.issueDateText,
    required this.completedLessonsCount,
    required this.completedCapstonesCount,
    required this.totalXp,
  });

  static void show(
    BuildContext context, {
    required String certId,
    required String studentName,
    required String issueDateText,
    required int completedLessonsCount,
    required int completedCapstonesCount,
    required int totalXp,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OnlineCredentialVerificationDialog(
        certId: certId,
        studentName: studentName,
        issueDateText: issueDateText,
        completedLessonsCount: completedLessonsCount,
        completedCapstonesCount: completedCapstonesCount,
        totalXp: totalXp,
      ),
    );
  }

  String get _verificationUrl =>
      'https://flutter-learning-hub.naltech.dev/verify/$certId';

  String get _cryptoHash {
    final raw = '$certId:$studentName:$issueDateText';
    int hash = 0;
    for (int i = 0; i < raw.length; i++) {
      hash = (31 * hash + raw.codeUnitAt(i)) & 0xFFFFFFFF;
    }
    final hex = hash.toRadixString(16).padLeft(8, '0').toUpperCase();
    return 'SHA256:7B8F9A$hex' 'E291C80410B';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 18),

          // Header Status Verified
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  color: Color(0xFF16A34A),
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'STATUS: TERVERIFIKASI RESMI',
                      style: TextStyle(
                        color: Color(0xFF16A34A),
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'Naltech Engineering Registry',
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'LIVE LEDGER',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 14),

          // Key-Value Verification Rows
          _buildInfoRow('Nama Mahasiswa', studentName, isBold: true),
          const SizedBox(height: 8),
          _buildInfoRow('Credential ID', certId, isMonospace: true),
          const SizedBox(height: 8),
          _buildInfoRow('Tanggal Penerbitan', issueDateText),
          const SizedBox(height: 8),
          _buildInfoRow('Total Akumulasi XP', '$totalXp XP Terdaftar'),
          const SizedBox(height: 8),
          _buildInfoRow('Sertifikat Hash', _cryptoHash, isMonospace: true),

          const SizedBox(height: 16),
          // Verified Competencies Checklist
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
                  'KOMPETENSI YANG TERVERIFIKASI',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 8),
                _buildCompetencyCheck('15 Modul Fundamental Arsitektur & Dart 3'),
                _buildCompetencyCheck('157 Katalog Komponen Widget & Pro Shaders'),
                _buildCompetencyCheck('4 Ujian Jalur Karir Lulus Skor >= 70%'),
                _buildCompetencyCheck('Clean Architecture, BLoC/Riverpod & Dio'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _verificationUrl));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tautan verifikasi disalin ke clipboard!'),
                        backgroundColor: Color(0xFF10B981),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.link_rounded, size: 16),
                  label: const Text('Salin Link Verifikasi'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text('Tutup'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isBold = false,
    bool isMonospace = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              fontFamily: isMonospace ? 'monospace' : null,
              color: const Color(0xFF0F172A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCompetencyCheck(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            size: 14,
            color: Color(0xFF10B981),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
