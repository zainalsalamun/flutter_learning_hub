import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/lms_progress_service.dart';
import '../models/inspector_preset.dart';
import '../widgets/property_color_picker.dart';
import '../widgets/property_dropdown.dart';
import '../widgets/property_slider.dart';
import '../widgets/property_switch.dart';

class WidgetInspectorStudioPage extends StatefulWidget {
  final InspectorCategory initialCategory;

  const WidgetInspectorStudioPage({
    super.key,
    this.initialCategory = InspectorCategory.boxContainer,
  });

  @override
  State<WidgetInspectorStudioPage> createState() =>
      _WidgetInspectorStudioPageState();
}

class _WidgetInspectorStudioPageState extends State<WidgetInspectorStudioPage>
    with SingleTickerProviderStateMixin {
  late InspectorCategory _selectedCategory;
  late TabController _tabController;
  bool _isDarkStage = false;

  // ==========================================
  // STATE: 1. Box & Container
  // ==========================================
  double _boxWidth = 200;
  double _boxHeight = 120;
  double _boxPadding = 16;
  double _boxRadius = 16;
  double _boxElevation = 8;
  double _boxBorderWidth = 1.5;
  Color _boxColor = const Color(0xFF6366F1);
  Color _boxBorderColor = const Color(0xFF818CF8);
  bool _boxHasGradient = true;
  bool _boxHasShadow = true;

  // ==========================================
  // STATE: 2. Button & Material
  // ==========================================
  String _buttonType = 'FilledButton';
  double _btnRadius = 12;
  double _btnElevation = 4;
  double _btnPaddingH = 20;
  double _btnPaddingV = 12;
  Color _btnColor = const Color(0xFF0284C7);
  bool _btnHasIcon = true;
  IconData _btnIcon = Icons.rocket_launch_rounded;
  String _btnLabel = 'Klik Saya Sekarang';

  // ==========================================
  // STATE: 3. Text & Typography
  // ==========================================
  double _fontSize = 20;
  FontWeight _fontWeight = FontWeight.bold;
  double _letterSpacing = 1.0;
  double _lineHeight = 1.3;
  Color _textColor = const Color(0xFF0F172A);
  bool _textIsItalic = false;
  bool _textHasUnderline = false;
  TextAlign _textAlign = TextAlign.center;
  String _textContent = 'Flutter UI Mastery Studio';

  // ==========================================
  // STATE: 4. Card & Glassmorphism
  // ==========================================
  double _glassBlur = 12;
  double _glassOpacity = 0.25;
  double _glassRadius = 20;
  double _glassBorderOpacity = 0.3;
  Color _glassTint = const Color(0xFFDB2777);

  // ==========================================
  // STATE: 5. Flex & Alignment
  // ==========================================
  Axis _flexDirection = Axis.horizontal;
  MainAxisAlignment _flexMainAlign = MainAxisAlignment.center;
  CrossAxisAlignment _flexCrossAlign = CrossAxisAlignment.center;
  int _flexItemCount = 3;
  double _flexSpacing = 10;

  // ==========================================
  // STATE: 6. Animated Motion
  // ==========================================
  bool _motionExpanded = false;
  int _motionDurationMs = 500;
  Curve _motionCurve = Curves.easeInOutBack;
  Color _motionColorA = const Color(0xFFF59E0B);
  Color _motionColorB = const Color(0xFF10B981);

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // =========================================================================
  // CODE SNIPPET GENERATOR
  // =========================================================================

  String _generateDartCode() {
    switch (_selectedCategory) {
      case InspectorCategory.boxContainer:
        return '''
Container(
  width: ${_boxWidth.toStringAsFixed(0)},
  height: ${_boxHeight.toStringAsFixed(0)},
  padding: const EdgeInsets.all(${_boxPadding.toStringAsFixed(0)}),
  decoration: BoxDecoration(
${_boxHasGradient ? '    gradient: const LinearGradient(\n      colors: [Color(0x${_boxColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}), Color(0xFF4338CA)],\n      begin: Alignment.topLeft,\n      end: Alignment.bottomRight,\n    ),\n' : '    color: const Color(0x${_boxColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}),\n'}    borderRadius: BorderRadius.circular(${_boxRadius.toStringAsFixed(0)}),
    border: Border.all(
      color: const Color(0x${_boxBorderColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}),
      width: ${_boxBorderWidth.toStringAsFixed(1)},
    ),
${_boxHasShadow ? '    boxShadow: [\n      BoxShadow(\n        color: Colors.black.withValues(alpha: 0.2),\n        blurRadius: ${_boxElevation.toStringAsFixed(0)},\n        offset: const Offset(0, 4),\n      ),\n    ],\n' : ''}  ),
  child: const Center(
    child: Text(
      'Custom Container',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  ),
)''';

      case InspectorCategory.button:
        final iconPart = _btnHasIcon ? '.icon' : '';
        final iconParam = _btnHasIcon ? '\n  icon: const Icon(Icons.rocket_launch_rounded),' : '';
        final labelParam = _btnHasIcon ? 'label' : 'child';
        final labelWidget = _btnHasIcon ? 'const Text("$_btnLabel")' : 'const Text("$_btnLabel")';

        return '''
$_buttonType$iconPart(
  onPressed: () {
    // Action handler
  },$iconParam
  $labelParam: $labelWidget,
  style: $_buttonType.styleFrom(
    backgroundColor: const Color(0x${_btnColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}),
    foregroundColor: Colors.white,
    elevation: ${_btnElevation.toStringAsFixed(0)},
    padding: const EdgeInsets.symmetric(
      horizontal: ${_btnPaddingH.toStringAsFixed(0)},
      vertical: ${_btnPaddingV.toStringAsFixed(0)},
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(${_btnRadius.toStringAsFixed(0)}),
    ),
  ),
)''';

      case InspectorCategory.typography:
        return '''
Text(
  "$_textContent",
  textAlign: TextAlign.${_textAlign.name},
  style: TextStyle(
    fontSize: ${_fontSize.toStringAsFixed(0)},
    fontWeight: FontWeight.w${_fontWeight.index * 100 + 100},
    color: const Color(0x${_textColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}),
    letterSpacing: ${_letterSpacing.toStringAsFixed(1)},
    height: ${_lineHeight.toStringAsFixed(1)},
    fontStyle: ${_textIsItalic ? 'FontStyle.italic' : 'FontStyle.normal'},
    decoration: ${_textHasUnderline ? 'TextDecoration.underline' : 'TextDecoration.none'},
  ),
)''';

      case InspectorCategory.glassCard:
        return '''
ClipRRect(
  borderRadius: BorderRadius.circular(${_glassRadius.toStringAsFixed(0)}),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: ${_glassBlur.toStringAsFixed(1)}, sigmaY: ${_glassBlur.toStringAsFixed(1)}),
    child: Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0x${_glassTint.value.toRadixString(16).padLeft(8, '0').toUpperCase()}).withValues(alpha: ${_glassOpacity.toStringAsFixed(2)}),
        borderRadius: BorderRadius.circular(${_glassRadius.toStringAsFixed(0)}),
        border: Border.all(
          color: Colors.white.withValues(alpha: ${_glassBorderOpacity.toStringAsFixed(2)}),
          width: 1.5,
        ),
      ),
      child: const Text("Frosted Glass Card", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    ),
  ),
)''';

      case InspectorCategory.flexLayout:
        final widgetName = _flexDirection == Axis.horizontal ? 'Row' : 'Column';
        return '''
$widgetName(
  mainAxisAlignment: MainAxisAlignment.${_flexMainAlign.name},
  crossAxisAlignment: CrossAxisAlignment.${_flexCrossAlign.name},
  children: [
${List.generate(_flexItemCount, (i) => '    Container(width: 40, height: 40, color: Colors.indigo, child: Center(child: Text("${i + 1}", style: const TextStyle(color: Colors.white))))').join(',\n')},
  ],
)''';

      case InspectorCategory.motion:
        return '''
GestureDetector(
  onTap: () => setState(() => isExpanded = !isExpanded),
  child: AnimatedContainer(
    duration: const Duration(milliseconds: $_motionDurationMs),
    curve: Curves.${_motionCurve.runtimeType},
    width: isExpanded ? 220 : 120,
    height: isExpanded ? 140 : 80,
    decoration: BoxDecoration(
      color: isExpanded ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
      borderRadius: BorderRadius.circular(isExpanded ? 30 : 12),
    ),
    child: const Center(child: Text("Tap Me", style: TextStyle(color: Colors.white))),
  ),
)''';
    }
  }

  void _copyGeneratedCode() {
    final code = _generateDartCode().trim();
    Clipboard.setData(ClipboardData(text: code));

    // Award +50 XP and unlock lab_experimenter badge!
    LmsProgressService.instance.recordInspectorExperiment();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.science_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Kode berhasil disalin. +50 XP & Lencana Laboran',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Color(0xFF06B6D4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // =========================================================================
  // BUILD METHOD
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(_selectedCategory.icon,
                color: _selectedCategory.color, size: 22),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Live Property Inspector Studio',
                style: TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isDarkStage
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              color: const Color(0xFF6366F1),
            ),
            tooltip: 'Toggle Stage Theme',
            onPressed: () => setState(() => _isDarkStage = !_isDarkStage),
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded, color: Color(0xFF0F172A)),
            tooltip: 'Salin Kode Dart',
            onPressed: _copyGeneratedCode,
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Horizontal Category Selector
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: InspectorCategory.values.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = InspectorCategory.values[index];
                  final isSelected = _selectedCategory == cat;

                  return InkWell(
                    onTap: () => setState(() => _selectedCategory = cat),
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? cat.color
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? cat.color
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            cat.icon,
                            size: 15,
                            color: isSelected ? Colors.white : cat.color,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            cat.title,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 2. Interactive Visual Stage Canvas (Top Viewport)
          Container(
            height: 220,
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            decoration: BoxDecoration(
              color: _isDarkStage
                  ? const Color(0xFF090D16)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isDarkStage
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Stage Watermark Label
                Positioned(
                  top: 10,
                  left: 12,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF22C55E),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'LIVE STAGE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: _isDarkStage
                              ? Colors.white54
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Rendered live widget
                Center(child: _buildLiveWidgetStage()),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 3. Tab Bar (Controls vs Code Generator)
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: _selectedCategory.color,
              unselectedLabelColor: const Color(0xFF64748B),
              indicatorColor: _selectedCategory.color,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(
                  icon: Icon(Icons.tune_rounded, size: 18),
                  text: 'Property Inspector',
                ),
                Tab(
                  icon: Icon(Icons.code_rounded, size: 18),
                  text: 'Dart Generator',
                ),
              ],
            ),
          ),

          // 4. Tab Content (Controls or Live Generated Code)
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInspectorControlsTab(),
                _buildGeneratedCodeTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // LIVE RENDERING STAGE
  // =========================================================================

  Widget _buildLiveWidgetStage() {
    switch (_selectedCategory) {
      case InspectorCategory.boxContainer:
        return Container(
          width: _boxWidth,
          height: _boxHeight,
          padding: EdgeInsets.all(_boxPadding),
          decoration: BoxDecoration(
            gradient: _boxHasGradient
                ? LinearGradient(
                    colors: [_boxColor, const Color(0xFF4338CA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: _boxHasGradient ? null : _boxColor,
            borderRadius: BorderRadius.circular(_boxRadius),
            border: Border.all(
              color: _boxBorderColor,
              width: _boxBorderWidth,
            ),
            boxShadow: _boxHasShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: _boxElevation,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: const Center(
            child: Text(
              'Custom Container',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        );

      case InspectorCategory.button:
        final style = FilledButton.styleFrom(
          backgroundColor: _btnColor,
          elevation: _btnElevation,
          padding: EdgeInsets.symmetric(
            horizontal: _btnPaddingH,
            vertical: _btnPaddingV,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_btnRadius),
          ),
        );

        if (_buttonType == 'ElevatedButton') {
          return _btnHasIcon
              ? ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(_btnIcon, size: 18),
                  label: Text(_btnLabel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _btnColor,
                    foregroundColor: Colors.white,
                    elevation: _btnElevation,
                    padding: EdgeInsets.symmetric(
                      horizontal: _btnPaddingH,
                      vertical: _btnPaddingV,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_btnRadius),
                    ),
                  ),
                )
              : ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _btnColor,
                    foregroundColor: Colors.white,
                    elevation: _btnElevation,
                    padding: EdgeInsets.symmetric(
                      horizontal: _btnPaddingH,
                      vertical: _btnPaddingV,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_btnRadius),
                    ),
                  ),
                  child: Text(_btnLabel),
                );
        } else if (_buttonType == 'OutlinedButton') {
          return _btnHasIcon
              ? OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(_btnIcon, size: 18, color: _btnColor),
                  label: Text(_btnLabel, style: TextStyle(color: _btnColor)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: _btnColor, width: 2),
                    padding: EdgeInsets.symmetric(
                      horizontal: _btnPaddingH,
                      vertical: _btnPaddingV,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_btnRadius),
                    ),
                  ),
                )
              : OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: _btnColor, width: 2),
                    padding: EdgeInsets.symmetric(
                      horizontal: _btnPaddingH,
                      vertical: _btnPaddingV,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_btnRadius),
                    ),
                  ),
                  child: Text(_btnLabel, style: TextStyle(color: _btnColor)),
                );
        }

        return _btnHasIcon
            ? FilledButton.icon(
                onPressed: () {},
                icon: Icon(_btnIcon, size: 18),
                label: Text(_btnLabel),
                style: style,
              )
            : FilledButton(
                onPressed: () {},
                style: style,
                child: Text(_btnLabel),
              );

      case InspectorCategory.typography:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            _textContent,
            textAlign: _textAlign,
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: _fontWeight,
              color: _textColor,
              letterSpacing: _letterSpacing,
              height: _lineHeight,
              fontStyle: _textIsItalic ? FontStyle.italic : FontStyle.normal,
              decoration: _textHasUnderline
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
          ),
        );

      case InspectorCategory.glassCard:
        return Stack(
          alignment: Alignment.center,
          children: [
            // Colorful background blobs for glass demonstration
            Container(
              width: 240,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(_glassRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: _glassBlur, sigmaY: _glassBlur),
                child: Container(
                  width: 220,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: _glassTint.withValues(alpha: _glassOpacity),
                    borderRadius: BorderRadius.circular(_glassRadius),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: _glassBorderOpacity),
                      width: 1.5,
                    ),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.blur_on_rounded, color: Colors.white, size: 28),
                      SizedBox(height: 6),
                      Text(
                        'Frosted Glass Card',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );

      case InspectorCategory.flexLayout:
        final items = List.generate(
          _flexItemCount,
          (i) => Container(
            width: 44,
            height: 44,
            margin: EdgeInsets.all(_flexSpacing / 2),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              '${i + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        );

        return Container(
          width: 260,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
          child: _flexDirection == Axis.horizontal
              ? Row(
                  mainAxisAlignment: _flexMainAlign,
                  crossAxisAlignment: _flexCrossAlign,
                  children: items,
                )
              : Column(
                  mainAxisAlignment: _flexMainAlign,
                  crossAxisAlignment: _flexCrossAlign,
                  children: items,
                ),
        );

      case InspectorCategory.motion:
        return GestureDetector(
          onTap: () {
            setState(() => _motionExpanded = !_motionExpanded);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: _motionDurationMs),
            curve: _motionCurve,
            width: _motionExpanded ? 220 : 130,
            height: _motionExpanded ? 130 : 80,
            decoration: BoxDecoration(
              color: _motionExpanded ? _motionColorB : _motionColorA,
              borderRadius: BorderRadius.circular(_motionExpanded ? 32 : 12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: _motionExpanded ? 16 : 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _motionExpanded
                      ? Icons.check_circle_rounded
                      : Icons.touch_app_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  _motionExpanded ? 'Expanded!' : 'Ketuk Saya',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  // =========================================================================
  // PROPERTY INSPECTOR CONTROLS TAB
  // =========================================================================

  Widget _buildInspectorControlsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_selectedCategory == InspectorCategory.boxContainer) ...[
          PropertySlider(
            label: 'Width (Lebar)',
            value: _boxWidth,
            min: 80,
            max: 300,
            onChanged: (val) => setState(() => _boxWidth = val),
          ),
          PropertySlider(
            label: 'Height (Tinggi)',
            value: _boxHeight,
            min: 60,
            max: 200,
            onChanged: (val) => setState(() => _boxHeight = val),
          ),
          PropertySlider(
            label: 'Padding Internal',
            value: _boxPadding,
            min: 0,
            max: 36,
            onChanged: (val) => setState(() => _boxPadding = val),
          ),
          PropertySlider(
            label: 'Border Radius (Sudut Lengkung)',
            value: _boxRadius,
            min: 0,
            max: 48,
            onChanged: (val) => setState(() => _boxRadius = val),
          ),
          PropertySlider(
            label: 'Shadow Elevation (Bayangan)',
            value: _boxElevation,
            min: 0,
            max: 24,
            onChanged: (val) => setState(() => _boxElevation = val),
          ),
          PropertySlider(
            label: 'Border Width (Ketebalan Garis)',
            value: _boxBorderWidth,
            min: 0,
            max: 6,
            onChanged: (val) => setState(() => _boxBorderWidth = val),
          ),
          PropertyColorPicker(
            label: 'Warna Container Utama',
            selectedColor: _boxColor,
            onColorChanged: (c) => setState(() => _boxColor = c),
          ),
          PropertyColorPicker(
            label: 'Warna Garis Tepi (Border)',
            selectedColor: _boxBorderColor,
            onColorChanged: (c) => setState(() => _boxBorderColor = c),
          ),
          PropertySwitch(
            label: 'Linear Gradient',
            value: _boxHasGradient,
            onChanged: (val) => setState(() => _boxHasGradient = val),
          ),
          PropertySwitch(
            label: 'Bayangan (BoxShadow)',
            value: _boxHasShadow,
            onChanged: (val) => setState(() => _boxHasShadow = val),
          ),
        ],

        if (_selectedCategory == InspectorCategory.button) ...[
          PropertyDropdown<String>(
            label: 'Tipe Button',
            value: _buttonType,
            items: const [
              DropdownMenuItem(value: 'FilledButton', child: Text('FilledButton (M3)')),
              DropdownMenuItem(value: 'ElevatedButton', child: Text('ElevatedButton')),
              DropdownMenuItem(value: 'OutlinedButton', child: Text('OutlinedButton')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _buttonType = val);
            },
          ),
          PropertySlider(
            label: 'Border Radius',
            value: _btnRadius,
            min: 0,
            max: 32,
            onChanged: (val) => setState(() => _btnRadius = val),
          ),
          PropertySlider(
            label: 'Horizontal Padding',
            value: _btnPaddingH,
            min: 8,
            max: 40,
            onChanged: (val) => setState(() => _btnPaddingH = val),
          ),
          PropertySlider(
            label: 'Vertical Padding',
            value: _btnPaddingV,
            min: 6,
            max: 24,
            onChanged: (val) => setState(() => _btnPaddingV = val),
          ),
          PropertyColorPicker(
            label: 'Warna Button',
            selectedColor: _btnColor,
            onColorChanged: (c) => setState(() => _btnColor = c),
          ),
          PropertySwitch(
            label: 'Tampilkan Icon Button',
            value: _btnHasIcon,
            onChanged: (val) => setState(() => _btnHasIcon = val),
          ),
        ],

        if (_selectedCategory == InspectorCategory.typography) ...[
          PropertySlider(
            label: 'Font Size',
            value: _fontSize,
            min: 12,
            max: 32,
            onChanged: (val) => setState(() => _fontSize = val),
          ),
          PropertySlider(
            label: 'Letter Spacing',
            value: _letterSpacing,
            min: -1,
            max: 6,
            onChanged: (val) => setState(() => _letterSpacing = val),
          ),
          PropertySlider(
            label: 'Line Height',
            value: _lineHeight,
            min: 0.8,
            max: 2.2,
            unit: 'x',
            onChanged: (val) => setState(() => _lineHeight = val),
          ),
          PropertyColorPicker(
            label: 'Warna Teks',
            selectedColor: _textColor,
            onColorChanged: (c) => setState(() => _textColor = c),
          ),
          PropertySwitch(
            label: 'Italic (Miring)',
            value: _textIsItalic,
            onChanged: (val) => setState(() => _textIsItalic = val),
          ),
          PropertySwitch(
            label: 'Underline (Garis Bawah)',
            value: _textHasUnderline,
            onChanged: (val) => setState(() => _textHasUnderline = val),
          ),
        ],

        if (_selectedCategory == InspectorCategory.glassCard) ...[
          PropertySlider(
            label: 'Blur Intensity (Sigma)',
            value: _glassBlur,
            min: 1,
            max: 25,
            onChanged: (val) => setState(() => _glassBlur = val),
          ),
          PropertySlider(
            label: 'Fill Opacity (Transparansi)',
            value: _glassOpacity,
            min: 0.05,
            max: 0.85,
            unit: '',
            onChanged: (val) => setState(() => _glassOpacity = val),
          ),
          PropertySlider(
            label: 'Border Radius',
            value: _glassRadius,
            min: 0,
            max: 36,
            onChanged: (val) => setState(() => _glassRadius = val),
          ),
          PropertyColorPicker(
            label: 'Warna Glass Tint',
            selectedColor: _glassTint,
            onColorChanged: (c) => setState(() => _glassTint = c),
          ),
        ],

        if (_selectedCategory == InspectorCategory.flexLayout) ...[
          PropertyDropdown<Axis>(
            label: 'Arah Fleksibel (Direction)',
            value: _flexDirection,
            items: const [
              DropdownMenuItem(value: Axis.horizontal, child: Text('Row (Horizontal)')),
              DropdownMenuItem(value: Axis.vertical, child: Text('Column (Vertical)')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _flexDirection = val);
            },
          ),
          PropertyDropdown<MainAxisAlignment>(
            label: 'MainAxisAlignment',
            value: _flexMainAlign,
            items: MainAxisAlignment.values.map((a) {
              return DropdownMenuItem(value: a, child: Text(a.name));
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _flexMainAlign = val);
            },
          ),
          PropertySlider(
            label: 'Jumlah Item Anak',
            value: _flexItemCount.toDouble(),
            min: 2,
            max: 5,
            unit: 'item',
            onChanged: (val) => setState(() => _flexItemCount = val.toInt()),
          ),
        ],

        if (_selectedCategory == InspectorCategory.motion) ...[
          PropertySlider(
            label: 'Durasi Animasi (Duration)',
            value: _motionDurationMs.toDouble(),
            min: 200,
            max: 1500,
            unit: 'ms',
            onChanged: (val) => setState(() => _motionDurationMs = val.toInt()),
          ),
          PropertyDropdown<Curve>(
            label: 'Kurva Transisi (Curve)',
            value: _motionCurve,
            items: const [
              DropdownMenuItem(value: Curves.linear, child: Text('Curves.linear')),
              DropdownMenuItem(value: Curves.easeInOut, child: Text('Curves.easeInOut')),
              DropdownMenuItem(value: Curves.bounceOut, child: Text('Curves.bounceOut')),
              DropdownMenuItem(value: Curves.elasticOut, child: Text('Curves.elasticOut')),
              DropdownMenuItem(value: Curves.easeInOutBack, child: Text('Curves.easeInOutBack')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _motionCurve = val);
            },
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              setState(() => _motionExpanded = !_motionExpanded);
            },
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Trigger Animasi Sekarang'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
        const SizedBox(height: 30),
      ],
    );
  }

  // =========================================================================
  // DART CODE GENERATOR TAB
  // =========================================================================

  Widget _buildGeneratedCodeTab() {
    final code = _generateDartCode().trim();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFF6366F1), size: 18),
              const SizedBox(width: 8),
              const Text(
                'Live Generated Code:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: _copyGeneratedCode,
                icon: const Icon(Icons.copy_rounded, size: 14),
                label: const Text('Salin Kode (+50 XP)', style: TextStyle(fontSize: 11)),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: SelectableText(
              code,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Color(0xFF38BDF8),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
