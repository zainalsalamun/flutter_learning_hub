import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../fundamentals/sandbox/pages/lesson_code_sandbox_page.dart';
import '../../constants/app_design_tokens.dart';
import '../data/quick_recipes_data.dart';
import '../models/quick_recipe_model.dart';

class QuickRecipesHubPage extends StatefulWidget {
  final RecipeCategory? initialCategory;
  final String? initialSearchQuery;

  const QuickRecipesHubPage({
    super.key,
    this.initialCategory,
    this.initialSearchQuery,
  });

  @override
  State<QuickRecipesHubPage> createState() => _QuickRecipesHubPageState();
}

class _QuickRecipesHubPageState extends State<QuickRecipesHubPage> {
  late RecipeCategory? _selectedCategory;
  late final TextEditingController _searchController;
  String _searchQuery = '';
  final Set<String> _expandedCodeRecipeIds = {};

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _searchQuery = widget.initialSearchQuery ?? '';
    _searchController = TextEditingController(text: _searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<QuickRecipe> get _filteredRecipes {
    final query = _searchQuery.trim().toLowerCase();
    return QuickRecipesData.allRecipes.where((recipe) {
      final matchesCategory = _selectedCategory == null ||
          recipe.category == _selectedCategory;

      final matchesQuery = query.isEmpty ||
          recipe.title.toLowerCase().contains(query) ||
          recipe.description.toLowerCase().contains(query) ||
          recipe.tags.any((t) => t.toLowerCase().contains(query)) ||
          recipe.category.title.toLowerCase().contains(query);

      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _copyToClipboard(String code, String recipeTitle) {
    Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kode "$recipeTitle" berhasil disalin ke clipboard!'),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'OK',
          textColor: const Color(0xFF38BDF8),
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipes = _filteredRecipes;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Flutter & Dart Recipes Hub',
              style: AppTypography.headingTitle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Cheat Sheet & Solusi Kode Produksi',
              style: AppTypography.bodyText(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Header info banner
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: const Color(0xFFBBF7D0),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.electric_bolt_rounded,
                      color: Color(0xFF16A34A),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Koleksi Resep Kode Siap Pakai',
                          style: AppTypography.headingTitle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF14532D),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Pola arsitektur, fix RenderFlex overflow, Interceptor Dio, hingga CustomPainter langsung salin atau uji di Sandbox.',
                          style: AppTypography.bodyText(
                            fontSize: 11.5,
                            color: const Color(0xFF166534),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Field
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.borderSubtle, width: 1),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Cari resep (RenderFlex, Riverpod, Dio, Bezier...)',
                    hintStyle: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF94A3B8),
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: Color(0xFF94A3B8),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Horizontal Category Filter Pills
          SliverToBoxAdapter(
            child: SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryChip(
                    label: 'Semua Resep (${QuickRecipesData.allRecipes.length})',
                    isSelected: _selectedCategory == null,
                    onTap: () => setState(() => _selectedCategory = null),
                  ),
                  ...RecipeCategory.values.map((cat) {
                    final count = QuickRecipesData.getByCategory(cat).length;
                    return _buildCategoryChip(
                      label: '${cat.shortLabel} ($count)',
                      icon: cat.icon,
                      color: cat.color,
                      isSelected: _selectedCategory == cat,
                      onTap: () => setState(() => _selectedCategory = cat),
                    );
                  }),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),

          // Results counter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text(
                    'Menampilkan ${recipes.length} Resep',
                    style: AppTypography.headingTitle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (_selectedCategory != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedCategory!.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedCategory!.color.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _selectedCategory!.title,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: _selectedCategory!.color,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Recipe List
          if (recipes.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.menu_book_rounded,
                        size: 48,
                        color: Color(0xFFCBD5E1),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Tidak ada resep yang sesuai',
                        style: AppTypography.headingTitle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Coba kata kunci lain atau pilih kategori "Semua Resep".',
                        style: AppTypography.bodyText(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final recipe = recipes[index];
                    return _buildRecipeCard(recipe);
                  },
                  childCount: recipes.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    IconData? icon,
    Color? color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final activeColor = color ?? AppColors.primary;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        avatar: icon != null
            ? Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : activeColor,
              )
            : null,
        label: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: activeColor,
        backgroundColor: AppColors.surface,
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? activeColor
                : AppColors.borderSubtle,
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(QuickRecipe recipe) {
    final isExpanded = _expandedCodeRecipeIds.contains(recipe.id);
    final lines = recipe.codeSnippet.trim().split('\n');
    final displayCode = isExpanded
        ? recipe.codeSnippet.trim()
        : lines.take(12).join('\n') +
            (lines.length > 12 ? '\n// ... (${lines.length - 12} baris lainnya)' : '');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: recipe.category.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: recipe.category.color.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            recipe.category.icon,
                            size: 13,
                            color: recipe.category.color,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            recipe.category.title,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: recipe.category.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.content_copy_rounded,
                        size: 17,
                        color: AppColors.textSecondary,
                      ),
                      tooltip: 'Salin Seluruh Kode',
                      onPressed: () =>
                          _copyToClipboard(recipe.codeSnippet, recipe.title),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  recipe.title,
                  style: AppTypography.headingTitle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  recipe.description,
                  style: AppTypography.bodyText(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Key points bullet list
          if (recipe.keyPoints.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Poin Penting & Implementasi:',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...recipe.keyPoints.map(
                    (point) => Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              point,
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF334155),
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 10),

          // Code Box
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1E293B), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Code box header
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
                  ),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEF4444),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF59E0B),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Dart / Flutter Code',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () =>
                            _copyToClipboard(recipe.codeSnippet, recipe.title),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.copy_rounded,
                              size: 12,
                              color: Color(0xFF94A3B8),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Salin',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Code body
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SelectableText(
                    displayCode,
                    style: const TextStyle(
                      color: Color(0xFFE2E8F0),
                      fontSize: 11.5,
                      height: 1.45,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),

                // Expand/collapse code if > 12 lines
                if (lines.length > 12)
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          _expandedCodeRecipeIds.remove(recipe.id);
                        } else {
                          _expandedCodeRecipeIds.add(recipe.id);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E293B),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(7),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 15,
                            color: const Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isExpanded
                                ? 'Ringkas Kode'
                                : 'Tampilkan Seluruh Kode (${lines.length} baris)',
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Best practice note
          if (recipe.bestPracticeNote != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.tips_and_updates_outlined,
                    size: 14,
                    color: Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Best Practice: ${recipe.bestPracticeNote}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Bottom Action Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Row(
              children: [
                // Tag chips
                Expanded(
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 4,
                    children: recipe.tags.take(3).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '#$tag',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Sandbox Launcher Button
                if (recipe.sandboxPresetId != null) ...[
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LessonCodeSandboxPage(
                            initialPresetId: recipe.sandboxPresetId,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.terminal_rounded, size: 14),
                    label: const Text(
                      'Coba di Sandbox',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 1,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
