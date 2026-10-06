import 'package:flutter/material.dart';
import '../constants/app_design_tokens.dart';

class CommunityDiscussionPage extends StatelessWidget {
  const CommunityDiscussionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final discussions = [
      {
        'title': 'Kapan sebaiknya menggunakan InheritedWidget vs ChangeNotifier?',
        'author': 'Fikri Dev',
        'category': 'Architecture',
        'replies': 8,
        'time': '2 jam lalu',
      },
      {
        'title': 'Mengapa didUpdateWidget() terpanggil saat parent setState()?',
        'author': 'Rian Flutter',
        'category': 'Lifecycle',
        'replies': 14,
        'time': '5 jam lalu',
      },
      {
        'title': 'Optimasi CustomPainter: Bagaimana repaintBoundary bekerja?',
        'author': 'Dewi Code',
        'category': 'Render Tree',
        'replies': 6,
        'time': '1 hari lalu',
      },
      {
        'title': 'Best practice pemisahan domain layer & data layer pada Flutter clean arch',
        'author': 'Aris Engineer',
        'category': 'Clean Code',
        'replies': 19,
        'time': '2 hari lalu',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        title: Text(
          'Diskusi Komunitas',
          style: AppTypography.headingTitle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header info box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.borderSubtle, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primarySubtle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Forum Diskusi & Tanya Jawab',
                        style: AppTypography.headingTitle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Diskusikan arsitektur, bug runtime, dan optimasi performa bersama sesama pengembang.',
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
          ),
          const SizedBox(height: 16),

          Text(
            'DISKUSI TERPOPULER',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),

          ...discussions.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primarySubtle,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item['category'] as String,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        item['time'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['title'] as String,
                    style: AppTypography.headingTitle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.person_outline_rounded, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        item['author'] as String,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.mode_comment_outlined, size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${item['replies']} tanggapan',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
