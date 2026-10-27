import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/fundamental_module.dart';
import '../../models/lesson_item.dart';
import '../../../lms/services/lms_progress_service.dart';
import '../data/sandbox_presets_data.dart';
import '../models/sandbox_preset.dart';
import '../widgets/sandbox_console_terminal.dart';
import '../widgets/sandbox_parameter_controls.dart';

class LessonCodeSandboxPage extends StatefulWidget {
  final LessonItem? initialLesson;
  final String? initialPresetId;

  const LessonCodeSandboxPage({
    super.key,
    this.initialLesson,
    this.initialPresetId,
  });

  @override
  State<LessonCodeSandboxPage> createState() => _LessonCodeSandboxPageState();
}

class _LessonCodeSandboxPageState extends State<LessonCodeSandboxPage>
    with SingleTickerProviderStateMixin {
  final LmsProgressService _lmsService = LmsProgressService.instance;
  late TabController _tabController;

  late SandboxPreset _activePreset;
  late Map<String, dynamic> _currentParams;
  List<String> _consoleLogs = [];
  bool _isRunning = false;
  bool _hasAwardedXp = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Resolve initial preset
    _activePreset = _resolveInitialPreset();
    _currentParams = Map<String, dynamic>.from(_activePreset.initialParameters);
    _consoleLogs = _activePreset.consoleOutputGenerator(_currentParams);
  }

  SandboxPreset _resolveInitialPreset() {
    if (widget.initialPresetId != null) {
      final p = SandboxPresetsData.getById(widget.initialPresetId!);
      if (p != null) return p;
    }

    if (widget.initialLesson != null) {
      final mod = widget.initialLesson!.module;
      switch (mod) {
        case FundamentalModule.layoutRules:
          return SandboxPresetsData.allPresets[0]; // layout_box
        case FundamentalModule.architecture:
          return SandboxPresetsData.allPresets[1]; // flex_alignment
        case FundamentalModule.lifecycle:
        case FundamentalModule.stateManagement:
        case FundamentalModule.advancedState:
          return SandboxPresetsData.allPresets[2]; // state_lifecycle
        case FundamentalModule.animationsCustomPainter:
          return SandboxPresetsData.allPresets[3]; // custom_painter
        case FundamentalModule.asyncNetworking:
        case FundamentalModule.networkingApi:
          return SandboxPresetsData.allPresets[4]; // async_stream
        case FundamentalModule.dartBasics:
        case FundamentalModule.cleanArchitecture:
        case FundamentalModule.themingResponsive:
        case FundamentalModule.localStorage:
        case FundamentalModule.navigation:
        case FundamentalModule.testingQa:
        case FundamentalModule.all:
        default:
          return SandboxPresetsData.allPresets[5]; // oop_immutable
      }
    }

    return SandboxPresetsData.allPresets[0];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _switchPreset(SandboxPreset preset) {
    setState(() {
      _activePreset = preset;
      _currentParams = Map<String, dynamic>.from(preset.initialParameters);
      _consoleLogs = preset.consoleOutputGenerator(_currentParams);
    });
  }

  void _runCodeExecution() {
    setState(() {
      _isRunning = true;
    });

    Future.delayed(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      setState(() {
        _isRunning = false;
        _consoleLogs = _activePreset.consoleOutputGenerator(_currentParams);
      });

      // Award XP for experiment
      if (!_hasAwardedXp) {
        _hasAwardedXp = true;
        _lmsService.recordInspectorExperiment();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.stars_rounded, color: Color(0xFFFBBF24), size: 20),
                SizedBox(width: 8),
                Text(
                  'Hebat! +50 XP dari Eksperimen Code Sandbox',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF0F172A),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _copyGeneratedCode() {
    final code = _activePreset.codeGenerator(_currentParams);
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kode Dart sandbox berhasil disalin ke clipboard!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final generatedCode = _activePreset.codeGenerator(_currentParams);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _activePreset.category.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(_activePreset.icon, color: _activePreset.category.color, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Interactive Code Sandbox',
                    style: TextStyle(color: Color(0xFF0F172A), fontSize: 14.5, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _activePreset.title,
                    style: TextStyle(color: _activePreset.category.color, fontSize: 11, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_rounded, size: 18, color: Colors.black87),
            tooltip: 'Salin Kode',
            onPressed: _copyGeneratedCode,
          ),
          IconButton(
            icon: const Icon(Icons.restart_alt_rounded, size: 20, color: Colors.black87),
            tooltip: 'Reset Preset',
            onPressed: () {
              setState(() {
                _currentParams = Map<String, dynamic>.from(_activePreset.initialParameters);
                _consoleLogs = _activePreset.consoleOutputGenerator(_currentParams);
              });
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          // 1. Preset Selector Carousel
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: SandboxPresetsData.allPresets.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final preset = SandboxPresetsData.allPresets[idx];
                final isSelected = preset.id == _activePreset.id;

                return InkWell(
                  onTap: () => _switchPreset(preset),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF0F172A) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          preset.icon,
                          size: 14,
                          color: isSelected ? Colors.white : preset.category.color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          preset.category.title,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : const Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // 2. Tab Bar: Live Canvas vs Editor Kode vs Terminal
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF02569B),
              labelColor: const Color(0xFF02569B),
              unselectedLabelColor: const Color(0xFF64748B),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              tabs: const [
                Tab(icon: Icon(Icons.visibility_outlined, size: 16), text: 'Live Canvas'),
                Tab(icon: Icon(Icons.code_rounded, size: 16), text: 'Kode Dart'),
                Tab(icon: Icon(Icons.terminal_rounded, size: 16), text: 'Terminal Log'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3. Tab Content View
          SizedBox(
            height: 240,
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 0: Visual Stage
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Stack(
                    children: [
                      // Stage Background Grid Hint
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Visual Stage • Hot Reload',
                            style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Center(
                        child: _activePreset.visualWidgetBuilder(context, _currentParams),
                      ),
                    ],
                  ),
                ),

                // Tab 1: Dart Code Editor View
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E293B),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.flutter_dash_rounded, size: 15, color: Color(0xFF38BDF8)),
                            const SizedBox(width: 6),
                            const Text(
                              'main_preview.dart',
                              style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: Colors.white70),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF059669).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Auto-Generated',
                                style: TextStyle(fontSize: 9.5, color: Color(0xFF34D399), fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(12),
                          child: SelectableText(
                            generatedCode.trim(),
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11.5,
                              color: Color(0xFF38BDF8),
                              height: 1.45,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Tab 2: Terminal Console
                SandboxConsoleTerminal(
                  logs: _consoleLogs,
                  onClear: () => setState(() => _consoleLogs = []),
                  onRerun: _runCodeExecution,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 4. Parameter Tweak Section Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.tune_rounded, size: 17, color: Color(0xFF02569B)),
                    const SizedBox(width: 8),
                    const Text(
                      'Tweak Parameter Live',
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Interactive Controls',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _activePreset.subtitle,
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                ),
                const Divider(height: 20),
                SandboxParameterControls(
                  preset: _activePreset,
                  params: _currentParams,
                  onChanged: (updated) {
                    setState(() {
                      _currentParams = updated;
                      _consoleLogs = _activePreset.consoleOutputGenerator(_currentParams);
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 5. Execution Action Bar
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isRunning ? null : _runCodeExecution,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF02569B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  icon: _isRunning
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.play_arrow_rounded, size: 20),
                  label: Text(
                    _isRunning ? 'Mengeksekusi Kode...' : 'Jalankan Kode & Evaluasi',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
