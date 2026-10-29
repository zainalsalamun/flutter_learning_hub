import 'package:flutter/material.dart';
import '../constants/app_design_tokens.dart';
import '../models/discussion_model.dart';
import '../services/discussion_service.dart';
import '../widgets/create_discussion_bottom_sheet.dart';
import 'discussion_thread_detail_page.dart';

class CommunityDiscussionPage extends StatefulWidget {
  const CommunityDiscussionPage({super.key});

  @override
  State<CommunityDiscussionPage> createState() =>
      _CommunityDiscussionPageState();
}

class _CommunityDiscussionPageState extends State<CommunityDiscussionPage> {
  final DiscussionService _service = DiscussionService.instance;
  final TextEditingController _searchController = TextEditingController();

  DiscussionCategory? _selectedCategory;
  String _sortBy = 'popular'; // 'popular', 'recent', 'unsolved'
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    _searchController.dispose();
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}j lalu';
    } else {
      return '${diff.inDays}h lalu';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredThreads = _service.getFilteredThreads(
      query: _searchQuery,
      category: _selectedCategory,
      sortBy: _sortBy,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diskusi Komunitas',
              style: AppTypography.headingTitle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Tanya jawab & bedah arsitektur Flutter',
              style: AppTypography.bodyText(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_rounded, color: AppColors.primary, size: 22),
            tooltip: 'Tanya Komunitas',
            onPressed: () => CreateDiscussionBottomSheet.show(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          // 1. Stats Overview Banner
          _buildStatsBanner(),
          const SizedBox(height: 12),

          // 2. Search Box
          _buildSearchBox(),
          const SizedBox(height: 10),

          // 3. Category Horizontal Filters
          _buildCategoryFilters(),
          const SizedBox(height: 10),

          // 4. Sort Options Row
          _buildSortRow(filteredThreads.length),
          const SizedBox(height: 10),

          // 5. Discussion Threads List or Empty State
          if (filteredThreads.isEmpty)
            _buildEmptyState()
          else
            ...filteredThreads.map((thread) => _buildThreadCard(thread)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CreateDiscussionBottomSheet.show(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_note_rounded, size: 20),
        label: const Text(
          'Tanya Komunitas',
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildStatsBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.forum_outlined,
            iconColor: AppColors.primary,
            label: 'Total Diskusi',
            value: '${_service.totalThreadsCount}',
          ),
          Container(height: 30, width: 1, color: AppColors.borderSubtle),
          _buildStatItem(
            icon: Icons.check_circle_outline_rounded,
            iconColor: const Color(0xFF10B981),
            label: 'Terpecahkan',
            value: '${_service.totalSolvedCount}',
          ),
          Container(height: 30, width: 1, color: AppColors.borderSubtle),
          _buildStatItem(
            icon: Icons.chat_bubble_outline_rounded,
            iconColor: const Color(0xFFF59E0B),
            label: 'Tanggapan',
            value: '${_service.totalRepliesCount}',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBox() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        decoration: InputDecoration(
          hintText: 'Cari topik, masalah error, atau kata kunci...',
          hintStyle: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
          prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textSecondary),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 1 + DiscussionCategory.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, idx) {
          if (idx == 0) {
            final isSelected = _selectedCategory == null;
            return ChoiceChip(
              label: const Text('Semua Topik'),
              selected: isSelected,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
              backgroundColor: AppColors.surface,
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.borderSubtle,
              ),
              onSelected: (val) {
                if (val) setState(() => _selectedCategory = null);
              },
            );
          }

          final cat = DiscussionCategory.values[idx - 1];
          final isSelected = _selectedCategory == cat;

          return ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(cat.icon, size: 13, color: isSelected ? Colors.white : cat.color),
                const SizedBox(width: 5),
                Text(cat.title),
              ],
            ),
            selected: isSelected,
            selectedColor: AppColors.primary,
            labelStyle: TextStyle(
              fontSize: 11.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
            backgroundColor: AppColors.surface,
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.borderSubtle,
            ),
            onSelected: (val) {
              setState(() => _selectedCategory = val ? cat : null);
            },
          );
        },
      ),
    );
  }

  Widget _buildSortRow(int count) {
    return Row(
      children: [
        Text(
          '$count Diskusi Ditemukan',
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        _buildSortPill('Terpopuler', 'popular'),
        const SizedBox(width: 6),
        _buildSortPill('Terbaru', 'recent'),
        const SizedBox(width: 6),
        _buildSortPill('Belum Selesai', 'unsolved'),
      ],
    );
  }

  Widget _buildSortPill(String title, String sortKey) {
    final isSelected = _sortBy == sortKey;
    return InkWell(
      onTap: () => setState(() => _sortBy = sortKey),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.rankDark : AppColors.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? AppColors.rankDark : AppColors.borderSubtle,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildThreadCard(DiscussionThread thread) {
    final hasCode = thread.codeSnippet != null && thread.codeSnippet!.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: thread.isSolved ? const Color(0xFFBBF7D0) : AppColors.borderSubtle,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DiscussionThreadDetailPage(threadId: thread.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tags Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: thread.category.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(thread.category.icon, size: 12, color: thread.category.color),
                          const SizedBox(width: 4),
                          Text(
                            thread.category.title,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: thread.category.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (thread.isSolved) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_rounded, size: 11, color: Color(0xFF15803D)),
                            SizedBox(width: 3),
                            Text(
                              'Solusi Terverifikasi',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (hasCode) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.code_rounded, size: 11, color: Color(0xFF38BDF8)),
                            SizedBox(width: 3),
                            Text(
                              'Kode Dart',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF38BDF8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      _formatTimeAgo(thread.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Question Title
                Text(
                  thread.title,
                  style: AppTypography.headingTitle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),

                // Preview Content
                Text(
                  thread.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyText(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),

                // Author & Interaction Row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: thread.authorAvatarColor,
                      child: Text(
                        thread.authorName.isNotEmpty
                            ? thread.authorName[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      thread.authorName,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    // Upvote Button
                    InkWell(
                      onTap: () => _service.toggleUpvoteThread(thread.id),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: thread.userUpvoted
                              ? AppColors.primarySubtle
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              thread.userUpvoted
                                  ? Icons.thumb_up_rounded
                                  : Icons.thumb_up_outlined,
                              size: 13,
                              color: thread.userUpvoted
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${thread.upvotes}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: thread.userUpvoted
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Replies
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.mode_comment_outlined, size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '${thread.replies.length}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Views
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.remove_red_eye_outlined, size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '${thread.viewCount}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 44, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          Text(
            'Tidak Ada Diskusi yang Cocok',
            style: AppTypography.headingTitle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Coba ubah kata kunci pencarian atau ganti filter kategori topik.',
            style: AppTypography.bodyText(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
                _selectedCategory = null;
              });
            },
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Reset Filter'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.borderSubtle),
            ),
          ),
        ],
      ),
    );
  }
}
