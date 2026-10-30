import 'package:flutter/material.dart';
import '../constants/app_design_tokens.dart';
import '../models/discussion_model.dart';
import '../services/discussion_service.dart';
import '../services/lms_progress_service.dart';

class CreateDiscussionBottomSheet extends StatefulWidget {
  const CreateDiscussionBottomSheet({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const CreateDiscussionBottomSheet(),
    );
  }

  @override
  State<CreateDiscussionBottomSheet> createState() =>
      _CreateDiscussionBottomSheetState();
}

class _CreateDiscussionBottomSheetState
    extends State<CreateDiscussionBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  DiscussionCategory _selectedCategory = DiscussionCategory.architecture;
  bool _includeCodeSnippet = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _codeController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _submitDiscussion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final tags = _tagsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final studentName = LmsProgressService.instance.studentName;

    await DiscussionService.instance.addThread(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      codeSnippet: _includeCodeSnippet ? _codeController.text.trim() : null,
      category: _selectedCategory,
      authorName: studentName.isEmpty ? 'Siswa Pembelajar' : studentName,
      tags: tags,
    );

    if (!mounted) return;

    Navigator.pop(context, true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.stars_rounded, color: Color(0xFFF59E0B), size: 20),
            SizedBox(width: 8),
            Text('Pertanyaan berhasil diterbitkan! (+30 XP)'),
          ],
        ),
        backgroundColor: AppColors.rankDark,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderMedium,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Title Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primarySubtle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add_comment_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tanya Komunitas',
                          style: AppTypography.headingTitle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Dapatkan solusi dari mentor & sesama developer (+30 XP)',
                          style: AppTypography.bodyText(
                            fontSize: 11.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 1. Kategori Selector Chips
              Text(
                'KATEGORI DISKUSI',
                style: AppTypography.labelText(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: DiscussionCategory.values.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, idx) {
                    final cat = DiscussionCategory.values[idx];
                    final isSelected = cat == _selectedCategory;
                    return ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            cat.icon,
                            size: 14,
                            color: isSelected ? Colors.white : cat.color,
                          ),
                          const SizedBox(width: 6),
                          Text(cat.title),
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        fontSize: 11.5,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                      backgroundColor: AppColors.surface,
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.borderSubtle,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedCategory = cat);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // 2. Judul Pertanyaan
              Text(
                'JUDUL PERTANYAAN',
                style: AppTypography.labelText(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Misal: Kapan sebaiknya memakai InheritedWidget vs BLoC?',
                  hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.backgroundSubtle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                validator: (val) {
                  if (val == null || val.trim().length < 6) {
                    return 'Judul pertanyaan minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // 3. Detail Penjelasan
              Text(
                'DETAIL PERTANYAAN',
                style: AppTypography.labelText(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _contentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Jelaskan konteks masalah, perilaku yang diharapkan, dan apa yang sudah kamu coba...',
                  hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.backgroundSubtle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.all(14),
                ),
                validator: (val) {
                  if (val == null || val.trim().length < 10) {
                    return 'Detail pertanyaan minimal 10 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 4. Toggle Sertakan Snippet Kode
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.code_rounded, size: 16, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Sertakan Contoh Kode Dart',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _includeCodeSnippet,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) => setState(() => _includeCodeSnippet = val),
                  ),
                ],
              ),

              if (_includeCodeSnippet) ...[
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: TextFormField(
                    controller: _codeController,
                    maxLines: 5,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Color(0xFF38BDF8),
                    ),
                    decoration: const InputDecoration(
                      hintText: '// Masukkan kode widget atau method Dart di sini...',
                      hintStyle: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 14),

              // 5. Tags
              Text(
                'TAG (PISAH DENGAN KOMA)',
                style: AppTypography.labelText(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _tagsController,
                decoration: InputDecoration(
                  hintText: 'Misal: BLoC, Riverpod, State',
                  hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.backgroundSubtle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Submit
              ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submitDiscussion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded, size: 18),
                label: Text(
                  _isSubmitting
                      ? 'Menerbitkan...'
                      : 'Publikasikan Pertanyaan (+30 XP)',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
