import 'package:flutter/material.dart';
import '../constants/app_design_tokens.dart';
import '../data/learning_tracks_data.dart';
import '../models/learning_track.dart';
import '../services/lms_progress_service.dart';

class LearningTrackSelector extends StatelessWidget {
  final LearningTrack? selectedTrack;
  final ValueChanged<LearningTrack?> onTrackSelected;
  final LmsProgressService lmsService;

  const LearningTrackSelector({
    super.key,
    required this.selectedTrack,
    required this.onTrackSelected,
    required this.lmsService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Icon(
                  Icons.timeline_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Jalur Pembelajaran (Career Tracks)',
                  style: AppTypography.headingTitle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => onTrackSelected(null),
                  child: Text(
                    'Lihat Semua',
                    style: AppTypography.labelText(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Horizontal Track Chips
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 1 + LearningTracksData.allTracks.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  final isAllSelected = selectedTrack == null;
                  return _buildTrackChip(
                    title: 'Semua Modul',
                    icon: Icons.layers_outlined,
                    isSelected: isAllSelected,
                    progressPercent: (lmsService.getOverallProgress() * 100).toInt(),
                    onTap: () => onTrackSelected(null),
                  );
                }

                final track = LearningTracksData.allTracks[index - 1];
                final isSelected = selectedTrack?.id == track.id;
                final percent = (lmsService.getTrackProgress(track) * 100).toInt();

                return _buildTrackChip(
                  title: track.title,
                  icon: track.icon,
                  isSelected: isSelected,
                  progressPercent: percent,
                  onTap: () => onTrackSelected(track),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackChip({
    required String title,
    required IconData icon,
    required bool isSelected,
    required int progressPercent,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.rankDark : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.rankDark : AppColors.borderSubtle,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF334155),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.18)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$progressPercent%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
