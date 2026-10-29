import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../fundamentals/sandbox/pages/lesson_code_sandbox_page.dart';
import '../constants/app_design_tokens.dart';
import '../models/discussion_model.dart';
import '../services/discussion_service.dart';
import '../services/lms_progress_service.dart';

class DiscussionThreadDetailPage extends StatefulWidget {
  final String threadId;

  const DiscussionThreadDetailPage({
    super.key,
    required this.threadId,
  });

  @override
  State<DiscussionThreadDetailPage> createState() =>
      _DiscussionThreadDetailPageState();
}

class _DiscussionThreadDetailPageState
    extends State<DiscussionThreadDetailPage> {
  final DiscussionService _service = DiscussionService.instance;
  final TextEditingController _replyController = TextEditingController();
  final TextEditingController _replyCodeController = TextEditingController();

  bool _showCodeInput = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
    // Increment view count when user opens thread
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _service.incrementViewCount(widget.threadId);
    });
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    _replyController.dispose();
    _replyCodeController.dispose();
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  DiscussionThread? get _thread {
    try {
      return _service.threads.firstWhere((t) => t.id == widget.threadId);
    } catch (_) {
      return null;
    }
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam lalu';
    } else {
      return '${diff.inDays} hari lalu';
    }
  }

  Future<void> _submitReply() async {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    final studentName = LmsProgressService.instance.studentName;

    await _service.addReply(
      threadId: widget.threadId,
      content: text,
      codeSnippet: _showCodeInput ? _replyCodeController.text.trim() : null,
      authorName: studentName.isEmpty ? 'Siswa Pembelajar' : studentName,
    );

    _replyController.clear();
    _replyCodeController.clear();

    if (!mounted) return;

    setState(() {
      _showCodeInput = false;
      _isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.stars_rounded, color: Color(0xFFF59E0B), size: 20),
            SizedBox(width: 8),
            Text('Jawaban berhasil dikirim! (+15 XP)'),
          ],
        ),
        backgroundColor: AppColors.rankDark,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final thread = _thread;

    if (thread == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Diskusi')),
        body: const Center(child: Text('Utas diskusi tidak ditemukan')),
      );
    }

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
        title: Text(
          thread.category.title,
          style: AppTypography.headingTitle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          if (thread.isSolved)
            Container(
              margin: const EdgeInsets.only(right: 14),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(color: const Color(0xFF86EFAC)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded,
                      size: 14, color: Color(0xFF15803D)),
                  SizedBox(width: 4),
                  Text(
                    'Terpecahkan',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF15803D),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Main Scrollable Area
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                // 1. Question Card
                _buildQuestionCard(thread),
                const SizedBox(height: 20),

                // 2. Replies Header Row
                Row(
                  children: [
                    const Icon(
                      Icons.forum_outlined,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tanggapan (${thread.replies.length})',
                      style: AppTypography.headingTitle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    if (thread.replies.any((r) => r.isSolution))
                      const Text(
                        '1 Solusi Terverifikasi',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF15803D),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // 3. Replies List
                if (thread.replies.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: AppColors.borderSubtle, width: 1),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.mark_chat_unread_outlined,
                          size: 36,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Belum Ada Tanggapan',
                          style: AppTypography.headingTitle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Jadilah yang pertama membantu menjawab pertanyaan ini dan raih +15 XP!',
                          style: AppTypography.bodyText(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  ...thread.replies.map((reply) => _buildReplyCard(thread, reply)),
              ],
            ),
          ),

          // Bottom Reply Input Bar
          _buildBottomReplyInput(),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(DiscussionThread thread) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author & Metadata Row
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: thread.authorAvatarColor,
                child: Text(
                  thread.authorName.isNotEmpty
                      ? thread.authorName[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      thread.authorName,
                      style: AppTypography.headingTitle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          thread.authorRole,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('•',
                            style: TextStyle(
                                fontSize: 11, color: AppColors.textSecondary)),
                        const SizedBox(width: 6),
                        Text(
                          _formatTimeAgo(thread.createdAt),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: thread.category.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: thread.category.color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(thread.category.icon,
                        size: 12, color: thread.category.color),
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
            ],
          ),
          const SizedBox(height: 14),

          // Question Title
          Text(
            thread.title,
            style: AppTypography.headingTitle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),

          // Question Content
          Text(
            thread.content,
            style: AppTypography.bodyText(
              fontSize: 13.5,
              color: const Color(0xFF334155),
              height: 1.5,
            ),
          ),

          // Code Snippet (if available)
          if (thread.codeSnippet != null &&
              thread.codeSnippet!.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            _buildCodeSnippetBox(thread.codeSnippet!),
          ],

          // Tags
          if (thread.tags.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: thread.tags.map((tag) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '#$tag',
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.borderSubtle),
          const SizedBox(height: 12),

          // Interaction Bar (Upvote, View count, Share)
          Row(
            children: [
              InkWell(
                onTap: () => _service.toggleUpvoteThread(thread.id),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: thread.userUpvoted
                        ? AppColors.primarySubtle
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: thread.userUpvoted
                          ? AppColors.primary
                          : AppColors.borderSubtle,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        thread.userUpvoted
                            ? Icons.thumb_up_rounded
                            : Icons.thumb_up_outlined,
                        size: 15,
                        color: thread.userUpvoted
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${thread.upvotes} Suka',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: thread.userUpvoted
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  const Icon(Icons.remove_red_eye_outlined,
                      size: 15, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    '${thread.viewCount} pembaca',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCodeSnippetBox(String code) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                const Icon(Icons.code_rounded,
                    size: 14, color: Color(0xFF38BDF8)),
                const SizedBox(width: 6),
                const Text(
                  'Dart Snippet',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LessonCodeSandboxPage(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF02569B).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: const Color(0xFF02569B).withValues(alpha: 0.6)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.terminal_rounded,
                            size: 11, color: Color(0xFF38BDF8)),
                        SizedBox(width: 4),
                        Text(
                          'Sandbox',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF38BDF8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.copy_rounded,
                      size: 15, color: Color(0xFF94A3B8)),
                  tooltip: 'Salin Kode',
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kode berhasil disalin!'),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Code Text Area
          Padding(
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              code.trim(),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Color(0xFF38BDF8),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyCard(DiscussionThread thread, DiscussionReply reply) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: reply.isSolution ? const Color(0xFFF0FDF4) : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: reply.isSolution
              ? const Color(0xFF86EFAC)
              : AppColors.borderSubtle,
          width: reply.isSolution ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Solution Banner (if verified solution)
          if (reply.isSolution) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded,
                      size: 14, color: Color(0xFF15803D)),
                  SizedBox(width: 6),
                  Text(
                    'Solusi Terverifikasi',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF15803D),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Reply Author Info Row
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: reply.authorAvatarColor,
                child: Text(
                  reply.authorName.isNotEmpty
                      ? reply.authorName[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reply.authorName,
                      style: AppTypography.headingTitle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${reply.authorRole} • ${_formatTimeAgo(reply.createdAt)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Reply Content
          Text(
            reply.content,
            style: AppTypography.bodyText(
              fontSize: 13,
              color: const Color(0xFF334155),
              height: 1.45,
            ),
          ),

          // Reply Code Snippet (if any)
          if (reply.codeSnippet != null &&
              reply.codeSnippet!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildCodeSnippetBox(reply.codeSnippet!),
          ],

          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.borderSubtle),
          const SizedBox(height: 10),

          // Action Buttons: Upvote reply & Mark as solution
          Row(
            children: [
              InkWell(
                onTap: () => _service.toggleUpvoteReply(thread.id, reply.id),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: reply.userUpvoted
                        ? AppColors.primarySubtle
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: reply.userUpvoted
                          ? AppColors.primary
                          : AppColors.borderSubtle,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        reply.userUpvoted
                            ? Icons.thumb_up_rounded
                            : Icons.thumb_up_outlined,
                        size: 13,
                        color: reply.userUpvoted
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${reply.upvotes}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: reply.userUpvoted
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Mark as Verified Solution Toggle
              TextButton.icon(
                onPressed: () => _service.toggleMarkSolution(thread.id, reply.id),
                icon: Icon(
                  reply.isSolution
                      ? Icons.check_circle_rounded
                      : Icons.check_circle_outline_rounded,
                  size: 15,
                  color: reply.isSolution
                      ? const Color(0xFF15803D)
                      : AppColors.textSecondary,
                ),
                label: Text(
                  reply.isSolution ? 'Batal Solusi' : 'Tandai Solusi',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: reply.isSolution
                        ? const Color(0xFF15803D)
                        : AppColors.textSecondary,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomReplyInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_showCodeInput) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: TextField(
                  controller: _replyCodeController,
                  maxLines: 3,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11.5,
                    color: Color(0xFF38BDF8),
                  ),
                  decoration: const InputDecoration(
                    hintText: '// Masukkan kode solusi Dart opsional...',
                    hintStyle: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11.5,
                      color: Color(0xFF64748B),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
            ],
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    _showCodeInput ? Icons.code_off_rounded : Icons.code_rounded,
                    size: 20,
                    color: _showCodeInput
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  tooltip: _showCodeInput ? 'Tutup Kode' : 'Tambah Kode Dart',
                  onPressed: () {
                    setState(() {
                      _showCodeInput = !_showCodeInput;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Tulis balasan atau solusi...',
                      hintStyle: const TextStyle(
                          fontSize: 12.5, color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.backgroundSubtle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: AppColors.borderSubtle),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: AppColors.borderSubtle),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.send_rounded, size: 18),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isSubmitting ? null : _submitReply,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
