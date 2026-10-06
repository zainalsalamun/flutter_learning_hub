import 'dart:async';
import 'package:flutter/material.dart';
import '../../../fundamentals/widgets/formatted_markdown_text.dart';
import '../../services/lms_progress_service.dart';
import '../models/assessment_model.dart';
import 'assessment_result_page.dart';

class InteractiveAssessmentPlayPage extends StatefulWidget {
  final AssessmentTrackModel assessment;

  const InteractiveAssessmentPlayPage({
    super.key,
    required this.assessment,
  });

  @override
  State<InteractiveAssessmentPlayPage> createState() =>
      _InteractiveAssessmentPlayPageState();
}

class _InteractiveAssessmentPlayPageState
    extends State<InteractiveAssessmentPlayPage> {
  int _currentIndex = 0;
  final Map<int, int> _userAnswers = {}; // questionIndex -> selectedOptionIndex

  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.assessment.timeLimitMinutes * 60;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
        _handleTimeUp();
      }
    });
  }

  void _handleTimeUp() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Waktu Ujian Telah Habis'),
        content: const Text(
          'Waktu pengerjaan ujian telah selesai. Jawabanmu akan dikumpulkan secara otomatis.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _submitAssessment();
            },
            child: const Text('Lihat Hasil'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTimer() {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Batalkan Ujian?'),
        content: const Text(
          'Progres pengerjaan ujian saat ini tidak akan disimpan jika kamu keluar sekarang.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Lanjutkan Ujian'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void _submitAssessment() {
    _timer?.cancel();

    final questions = widget.assessment.questions;
    int correctCount = 0;

    for (int i = 0; i < questions.length; i++) {
      if (_userAnswers[i] == questions[i].correctIndex) {
        correctCount++;
      }
    }

    final scorePercentage = (correctCount * 100) ~/ questions.length;
    final isPassed = scorePercentage >= widget.assessment.passingScore;

    final submission = AssessmentSubmission(
      assessmentId: widget.assessment.id,
      userAnswers: Map.unmodifiable(_userAnswers),
      scorePercentage: scorePercentage,
      correctCount: correctCount,
      totalCount: questions.length,
      isPassed: isPassed,
      completedAt: DateTime.now(),
    );

    // Record progress & award XP
    LmsProgressService.instance.recordAssessmentSubmission(
      submission,
      rewardXp: widget.assessment.rewardXp,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AssessmentResultPage(
          assessment: widget.assessment,
          submission: submission,
        ),
      ),
    );
  }

  void _confirmSubmit() {
    final questions = widget.assessment.questions;
    final unansweredCount = questions.length - _userAnswers.length;

    if (unansweredCount > 0) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Masih Ada Soal Kosong'),
          content: Text(
            'Terdapat $unansweredCount soal yang belum kamu jawab. Yakin ingin mengumpulkan jawaban sekarang?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali Periksa'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _submitAssessment();
              },
              child: const Text('Kumpulkan'),
            ),
          ],
        ),
      );
    } else {
      _submitAssessment();
    }
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.assessment.questions;
    final currentQ = questions[_currentIndex];
    final isLast = _currentIndex == questions.length - 1;
    final isTimerWarning = _remainingSeconds < 120;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.black87),
            tooltip: 'Keluar dari Ujian',
            onPressed: _confirmExit,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.assessment.title,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.bold,
                  fontSize: 14.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Soal ${_currentIndex + 1} dari ${questions.length}',
                style: TextStyle(
                  color: widget.assessment.color,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          actions: [
            // Timer Badge
            Container(
              margin: const EdgeInsets.only(right: 14),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isTimerWarning
                    ? const Color(0xFFFEE2E2)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isTimerWarning
                      ? const Color(0xFFEF4444)
                      : const Color(0xFFCBD5E1),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 15,
                    color: isTimerWarning ? Colors.red : const Color(0xFF475569),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatTimer(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      color: isTimerWarning ? Colors.red : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: (_currentIndex + 1) / questions.length,
              minHeight: 4,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(widget.assessment.color),
            ),
          ),
        ),
        body: Column(
          children: [
            // Question Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question Topic Header Pill
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: widget.assessment.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            currentQ.topic,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: widget.assessment.color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            currentQ.difficulty.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Question Text
                    FormattedMarkdownText(
                      currentQ.question,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        height: 1.4,
                      ),
                      codeColor: widget.assessment.color,
                      codeBackgroundColor:
                          widget.assessment.color.withValues(alpha: 0.1),
                    ),

                    // Code Snippet Box (if available)
                    if (currentQ.codeSnippet != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFF1E293B),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.code_rounded,
                                      size: 14, color: Colors.white70),
                                  SizedBox(width: 6),
                                  Text(
                                    'Dart Code Snippet',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: SelectableText(
                                currentQ.codeSnippet!.trim(),
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
                      ),
                    ],

                    const SizedBox(height: 16),

                    const Text(
                      'Pilih salah satu jawaban yang paling tepat:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 4 Options
                    ...currentQ.options.asMap().entries.map((entry) {
                      final optIdx = entry.key;
                      final optText = entry.value;
                      final isSelected = _userAnswers[_currentIndex] == optIdx;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _userAnswers[_currentIndex] = optIdx;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? widget.assessment.color.withValues(alpha: 0.08)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? widget.assessment.color
                                  : const Color(0xFFE2E8F0),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? widget.assessment.color.withValues(alpha: 0.1)
                                    : Colors.black.withValues(alpha: 0.02),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? widget.assessment.color
                                      : const Color(0xFFF1F5F9),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  String.fromCharCode(65 + optIdx),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF475569),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: FormattedMarkdownText(
                                    optText,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isSelected
                                          ? const Color(0xFF0F172A)
                                          : const Color(0xFF334155),
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      height: 1.35,
                                    ),
                                    codeColor: widget.assessment.color,
                                    codeBackgroundColor: Colors.black.withValues(alpha: 0.05),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Bottom Navigation & Navigation Drawer Bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(
                  top: BorderSide(color: Color(0xFFE2E8F0)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Question Dots Picker
                  SizedBox(
                    height: 32,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: questions.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 6),
                      itemBuilder: (context, index) {
                        final isAnswered = _userAnswers.containsKey(index);
                        final isCurrent = index == _currentIndex;

                        return InkWell(
                          onTap: () => setState(() => _currentIndex = index),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCurrent
                                  ? widget.assessment.color
                                  : isAnswered
                                      ? const Color(0xFFDCFCE7)
                                      : const Color(0xFFF1F5F9),
                              border: Border.all(
                                color: isCurrent
                                    ? widget.assessment.color
                                    : isAnswered
                                        ? const Color(0xFF86EFAC)
                                        : const Color(0xFFCBD5E1),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: isCurrent
                                    ? Colors.white
                                    : isAnswered
                                        ? const Color(0xFF166534)
                                        : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Action Buttons: Prev & Next / Submit
                  Row(
                    children: [
                      if (_currentIndex > 0)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() => _currentIndex--);
                            },
                            icon: const Icon(Icons.arrow_back_rounded, size: 16),
                            label: const Text('Sebelumnya'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      if (_currentIndex > 0) const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: FilledButton.icon(
                          onPressed: isLast
                              ? _confirmSubmit
                              : () => setState(() => _currentIndex++),
                          icon: Icon(
                            isLast
                                ? Icons.send_rounded
                                : Icons.arrow_forward_rounded,
                            size: 16,
                          ),
                          label: Text(
                            isLast ? 'Kumpulkan Jawaban' : 'Soal Berikutnya',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: isLast
                                ? const Color(0xFF16A34A)
                                : widget.assessment.color,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
