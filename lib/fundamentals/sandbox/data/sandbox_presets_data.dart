import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/sandbox_preset.dart';

class SandboxPresetsData {
  static const List<Color> themePalette = [
    Color(0xFF02569B), // Blue Primary
    Color(0xFF059669), // Emerald
    Color(0xFFD97706), // Amber
    Color(0xFF7C3AED), // Violet
    Color(0xFFDC2626), // Rose
  ];

  static final List<SandboxPreset> allPresets = [
    _layoutBoxPreset,
    _flexAlignmentPreset,
    _stateLifecyclePreset,
    _customPainterPreset,
    _asyncStreamPreset,
    _oopImmutablePreset,
  ];

  static SandboxPreset? getById(String id) {
    try {
      return allPresets.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // =========================================================================
  // 1. LAYOUT BOX & CONSTRAINTS
  // =========================================================================
  static final SandboxPreset _layoutBoxPreset = SandboxPreset(
    id: 'layout_box',
    title: 'Layout Box & Container Bounds',
    subtitle: 'Tweak lebar, tinggi, radius sudut, bayangan, dan padding secara instan',
    category: SandboxCategory.layout,
    icon: Icons.crop_square_rounded,
    initialParameters: {
      'width': 220.0,
      'height': 120.0,
      'padding': 16.0,
      'borderRadius': 12.0,
      'elevation': 4.0,
      'colorIndex': 0,
      'textLabel': 'Container Preview',
      'showBorder': true,
    },
    codeGenerator: (params) {
      final w = (params['width'] as num? ?? 220.0).toDouble();
      final h = (params['height'] as num? ?? 120.0).toDouble();
      final p = (params['padding'] as num? ?? 16.0).toDouble();
      final r = (params['borderRadius'] as num? ?? 12.0).toDouble();
      final e = (params['elevation'] as num? ?? 4.0).toDouble();
      final colorIdx = (params['colorIndex'] as int? ?? 0).clamp(0, themePalette.length - 1);
      final colorHex = themePalette[colorIdx].toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
      final label = params['textLabel'] as String? ?? 'Container Preview';
      final showBorder = params['showBorder'] as bool? ?? true;

      return '''
Container(
  width: ${w.toStringAsFixed(1)},
  height: ${h.toStringAsFixed(1)},
  padding: const EdgeInsets.all(${p.toStringAsFixed(1)}),
  decoration: BoxDecoration(
    color: const Color(0x$colorHex),
    borderRadius: BorderRadius.circular(${r.toStringAsFixed(1)}),
    ${showBorder ? 'border: Border.all(color: Colors.white30, width: 1.5),' : ''}
    boxShadow: const [
      BoxShadow(
        color: Color(0x33000000),
        blurRadius: ${e * 2},
        offset: Offset(0, ${e.toStringAsFixed(1)}),
      ),
    ],
  ),
  child: const Center(
    child: Text(
      "$label",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
)''';
    },
    consoleOutputGenerator: (params) {
      final w = (params['width'] as num? ?? 220.0).toDouble();
      final h = (params['height'] as num? ?? 120.0).toDouble();
      final r = (params['borderRadius'] as num? ?? 12.0).toDouble();
      final p = (params['padding'] as num? ?? 16.0).toDouble();

      return [
        '[DART VM] Compiling BoxConstraints widget tree...',
        '[LAYOUT] Parent passed tight constraints: minW=0, maxW=360, minH=0, maxH=400',
        '[RENDER] Container resolved size: ${w.toStringAsFixed(1)}px x ${h.toStringAsFixed(1)}px',
        '[PAINT] DecoratedBox applied: borderRadius=${r.toStringAsFixed(1)}, padding=${p.toStringAsFixed(1)}',
        '[STATUS] 0 layout overflow errors detected. Stage clean.',
      ];
    },
    visualWidgetBuilder: (context, params) {
      final w = (params['width'] as num? ?? 220.0).toDouble();
      final h = (params['height'] as num? ?? 120.0).toDouble();
      final p = (params['padding'] as num? ?? 16.0).toDouble();
      final r = (params['borderRadius'] as num? ?? 12.0).toDouble();
      final e = (params['elevation'] as num? ?? 4.0).toDouble();
      final colorIdx = (params['colorIndex'] as int? ?? 0).clamp(0, themePalette.length - 1);
      final color = themePalette[colorIdx];
      final label = params['textLabel'] as String? ?? 'Container Preview';
      final showBorder = params['showBorder'] as bool? ?? true;

      return Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: w,
          height: h,
          padding: EdgeInsets.all(p),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(r),
            border: showBorder ? Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: e * 2,
                offset: Offset(0, e),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      );
    },
  );

  // =========================================================================
  // 2. FLEX & ALIGNMENT
  // =========================================================================
  static final SandboxPreset _flexAlignmentPreset = SandboxPreset(
    id: 'flex_alignment',
    title: 'Flex Layout & Axis Alignment',
    subtitle: 'Uji interaksi MainAxisAlignment & CrossAxisAlignment pada Row/Column',
    category: SandboxCategory.flex,
    icon: Icons.view_column_rounded,
    initialParameters: {
      'isRow': true,
      'mainAxisIndex': 1, // 0: start, 1: center, 2: end, 3: spaceBetween, 4: spaceAround
      'crossAxisIndex': 1, // 0: start, 1: center, 2: end, 3: stretch
      'itemCount': 3,
      'useExpanded': false,
      'spacing': 8.0,
    },
    codeGenerator: (params) {
      final isRow = params['isRow'] as bool? ?? true;
      final mainIndex = params['mainAxisIndex'] as int? ?? 1;
      final crossIndex = params['crossAxisIndex'] as int? ?? 1;
      final count = params['itemCount'] as int? ?? 3;
      final useExpanded = params['useExpanded'] as bool? ?? false;

      const mainAligns = [
        'MainAxisAlignment.start',
        'MainAxisAlignment.center',
        'MainAxisAlignment.end',
        'MainAxisAlignment.spaceBetween',
        'MainAxisAlignment.spaceAround',
      ];

      const crossAligns = [
        'CrossAxisAlignment.start',
        'CrossAxisAlignment.center',
        'CrossAxisAlignment.end',
        'CrossAxisAlignment.stretch',
      ];

      final mainStr = mainAligns[mainIndex.clamp(0, mainAligns.length - 1)];
      final crossStr = crossAligns[crossIndex.clamp(0, crossAligns.length - 1)];

      return '''
${isRow ? 'Row' : 'Column'}(
  mainAxisAlignment: $mainStr,
  crossAxisAlignment: $crossStr,
  children: [
    ${List.generate(count, (i) {
      final child = 'Container(width: 44, height: 44, color: Colors.indigo)';
      return useExpanded ? 'Expanded(child: $child),' : '$child,';
    }).join('\n    ')}
  ],
)''';
    },
    consoleOutputGenerator: (params) {
      final isRow = params['isRow'] as bool? ?? true;
      final count = params['itemCount'] as int? ?? 3;
      final useExp = params['useExpanded'] as bool? ?? false;

      return [
        '[FLEX] Instantiated RenderFlex(direction: ${isRow ? "horizontal" : "vertical"})',
        '[CHILDREN] $count children registered into child list',
        '[FLEX FACTOR] ${useExp ? "Each child assigned flex=1 (Expanded)" : "Children sized intrinsically without flex expansion"}',
        '[PIPELINE] MultiChildLayout passes completed with 0 errors.',
      ];
    },
    visualWidgetBuilder: (context, params) {
      final isRow = params['isRow'] as bool? ?? true;
      final mainIndex = params['mainAxisIndex'] as int? ?? 1;
      final crossIndex = params['crossAxisIndex'] as int? ?? 1;
      final count = (params['itemCount'] as int? ?? 3).clamp(1, 4);
      final useExpanded = params['useExpanded'] as bool? ?? false;

      final mainAlignments = [
        MainAxisAlignment.start,
        MainAxisAlignment.center,
        MainAxisAlignment.end,
        MainAxisAlignment.spaceBetween,
        MainAxisAlignment.spaceAround,
      ];

      final crossAlignments = [
        CrossAxisAlignment.start,
        CrossAxisAlignment.center,
        CrossAxisAlignment.end,
        CrossAxisAlignment.stretch,
      ];

      final mainAlign = mainAlignments[mainIndex.clamp(0, mainAlignments.length - 1)];
      final crossAlign = crossAlignments[crossIndex.clamp(0, crossAlignments.length - 1)];

      final colors = [
        const Color(0xFF6366F1),
        const Color(0xFF06B6D4),
        const Color(0xFF10B981),
        const Color(0xFFF59E0B),
      ];

      List<Widget> children = List.generate(count, (i) {
        Widget box = Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colors[i % colors.length],
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            String.fromCharCode(65 + i),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        );
        return useExpanded ? Expanded(child: Padding(padding: const EdgeInsets.all(4), child: box)) : box;
      });

      return Container(
        height: 180,
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: isRow
            ? Row(
                mainAxisAlignment: mainAlign,
                crossAxisAlignment: crossAlign,
                children: children,
              )
            : Column(
                mainAxisAlignment: mainAlign,
                crossAxisAlignment: crossAlign,
                children: children,
              ),
      );
    },
  );

  // =========================================================================
  // 3. STATE LIFECYCLE & REBUILD SIMULATOR
  // =========================================================================
  static final SandboxPreset _stateLifecyclePreset = SandboxPreset(
    id: 'state_lifecycle',
    title: 'State Lifecycle & Rebuild Simulator',
    subtitle: 'Simulasikan setState, initState, dan pantau mutasi rebuild counter secara live',
    category: SandboxCategory.lifecycle,
    icon: Icons.loop_rounded,
    initialParameters: {
      'counter': 0,
      'rebuildCount': 1,
      'isActive': true,
      'stepName': 'build() executed',
    },
    codeGenerator: (params) {
      final counter = params['counter'] as int? ?? 0;
      final rebuilds = params['rebuildCount'] as int? ?? 1;

      return '''
class _CounterWidgetState extends State<CounterWidget> {
  int _counter = $counter; // Rebuild pass #$rebuilds

  @override
  void initState() {
    super.initState();
    print("1. initState() triggered");
  }

  void _increment() {
    setState(() {
      _counter += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _increment,
      child: Text("Nilai Counter: \$_counter"),
    );
  }
}''';
    },
    consoleOutputGenerator: (params) {
      final counter = params['counter'] as int? ?? 0;
      final rebuilds = params['rebuildCount'] as int? ?? 1;

      return [
        '[LIFECYCLE] 1. initState() -> State instance created in memory',
        '[LIFECYCLE] 2. didChangeDependencies() -> InheritedContext bound',
        '[RENDER] 3. build(BuildContext context) -> Rebuild #$rebuilds executed',
        '[MUTATION] setState() invoked: _counter state value is now $counter',
        '[ELEMENT] Element marked dirty -> scheduleFrame() completed in 0.8ms',
      ];
    },
    visualWidgetBuilder: (context, params) {
      final counter = params['counter'] as int? ?? 0;
      final rebuilds = params['rebuildCount'] as int? ?? 1;

      return Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [
              BoxShadow(color: Color(0x0D000000), blurRadius: 8, offset: Offset(0, 3)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: const Text(
                      'StatefulWidget Lifecycle',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF047857)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Text(
                      'Rebuild #$rebuilds',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '$counter',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const Text(
                'Nilai Variabel State Saat Ini',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  params['counter'] = counter + 1;
                  params['rebuildCount'] = rebuilds + 1;
                  (context as Element).markNeedsBuild();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Panggil setState(() { counter++ })', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    },
  );

  // =========================================================================
  // 4. CUSTOM PAINTER LIVE CANVAS
  // =========================================================================
  static final SandboxPreset _customPainterPreset = SandboxPreset(
    id: 'custom_painter',
    title: 'CustomPainter Live Canvas & Shader',
    subtitle: 'Kendalikan brush stroke, bentuk geometris, dan transformasi sudut kanvas',
    category: SandboxCategory.painter,
    icon: Icons.brush_rounded,
    initialParameters: {
      'strokeWidth': 4.0,
      'shapeIndex': 0, // 0: Circle, 1: Star, 2: Hexagon, 3: Wave
      'colorIndex': 3,
      'isFill': false,
      'rotationDeg': 45.0,
    },
    codeGenerator: (params) {
      final stroke = (params['strokeWidth'] as num? ?? 4.0).toDouble();
      final shapeIdx = params['shapeIndex'] as int? ?? 0;
      final colorIdx = (params['colorIndex'] as int? ?? 3).clamp(0, themePalette.length - 1);
      final colorHex = themePalette[colorIdx].toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
      final isFill = params['isFill'] as bool? ?? false;
      final rot = (params['rotationDeg'] as num? ?? 45.0).toDouble();

      const shapeNames = ['Circle', 'Star', 'Hexagon', 'Wave'];

      return '''
class GeometricPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x$colorHex)
      ..style = ${isFill ? 'PaintingStyle.fill' : 'PaintingStyle.stroke'}
      ..strokeWidth = ${stroke.toStringAsFixed(1)};

    // Gambarkan ${shapeNames[shapeIdx.clamp(0, shapeNames.length - 1)]} dengan rotasi ${rot.toStringAsFixed(0)}°
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(${rot.toStringAsFixed(0)} * math.pi / 180);
    // Draw geometry onto canvas...
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}''';
    },
    consoleOutputGenerator: (params) {
      final stroke = (params['strokeWidth'] as num? ?? 4.0).toDouble();
      final isFill = params['isFill'] as bool? ?? false;

      return [
        '[SKIA / IMPELER] Native Canvas handle acquired',
        '[PAINT] Paint initialized: style=${isFill ? "PaintingStyle.fill" : "PaintingStyle.stroke"}, strokeWidth=${stroke.toStringAsFixed(1)}',
        '[MATRIX] canvas.translate() & canvas.rotate() applied onto 2D matrix',
        '[FRAME] Canvas draw calls flushed to GPU backend without jank.',
      ];
    },
    visualWidgetBuilder: (context, params) {
      final stroke = (params['strokeWidth'] as num? ?? 4.0).toDouble();
      final shapeIdx = params['shapeIndex'] as int? ?? 0;
      final colorIdx = (params['colorIndex'] as int? ?? 3).clamp(0, themePalette.length - 1);
      final color = themePalette[colorIdx];
      final isFill = params['isFill'] as bool? ?? false;
      final rot = (params['rotationDeg'] as num? ?? 45.0).toDouble();

      return Center(
        child: Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: CustomPaint(
            painter: _SandboxLivePainter(
              strokeWidth: stroke,
              shapeIndex: shapeIdx,
              color: color,
              isFill: isFill,
              rotationDeg: rot,
            ),
          ),
        ),
      );
    },
  );

  // =========================================================================
  // 5. ASYNC EVENT LOOP & STREAM SIMULATOR
  // =========================================================================
  static final SandboxPreset _asyncStreamPreset = SandboxPreset(
    id: 'async_stream',
    title: 'Async Event Loop & Stream Dispatcher',
    subtitle: 'Simulasikan latency Future.delayed dan observasi urutan antrian event queue',
    category: SandboxCategory.asyncLogic,
    icon: Icons.schedule_rounded,
    initialParameters: {
      'delayMs': 800,
      'emittedEvents': 3,
      'isSuccess': true,
      'lastEvent': 'Ready',
    },
    codeGenerator: (params) {
      final ms = params['delayMs'] as int? ?? 800;
      final isSuccess = params['isSuccess'] as bool? ?? true;

      return '''
Future<String> fetchUserTelemetry() async {
  print("1. [Sync] Memulai permintaan network...");
  
  // Mensimulasikan delay event queue
  await Future.delayed(const Duration(milliseconds: $ms));
  
  ${isSuccess ? 'return "Data Berhasil Diterima (Status 200 OK)";' : 'throw Exception("Koneksi Timeout (504)");'}
}

// Stream Generator
Stream<int> countStream() async* {
  for (int i = 1; i <= 3; i++) {
    await Future.delayed(const Duration(milliseconds: 300));
    yield i; // Emit event ke StreamListener
  }
}''';
    },
    consoleOutputGenerator: (params) {
      final ms = params['delayMs'] as int? ?? 800;
      final isSuccess = params['isSuccess'] as bool? ?? true;

      return [
        '[DART EVENT LOOP] Sync code executed on main isolate thread',
        '[MICROTASK QUEUE] Schedule microtask passed with priority 0',
        '[EVENT QUEUE] Future timer scheduled for ${ms}ms in background',
        isSuccess
            ? '[RESOLVED] Future completed with success: 200 OK (${ms}ms)'
            : '[ERROR HANDLED] Future caught error: Network Timeout Handled',
        '[STREAM] StreamSubscription.onData() dispatched payload.',
      ];
    },
    visualWidgetBuilder: (context, params) {
      return StatefulBuilder(
        builder: (ctx, setLocalState) {
          final ms = params['delayMs'] as int? ?? 800;
          final isSuccess = params['isSuccess'] as bool? ?? true;
          final lastEvent = params['lastEvent'] as String? ?? 'Ready';

          return Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer_outlined, size: 16, color: Color(0xFFD97706)),
                      const SizedBox(width: 6),
                      Text(
                        'Simulasi Latensi: ${ms}ms',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSuccess ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isSuccess ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA)),
                    ),
                    child: Text(
                      'Status Payload: $lastEvent',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: isSuccess ? const Color(0xFF15803D) : const Color(0xFFDC2626),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      setLocalState(() {
                        params['lastEvent'] = 'Fetching... (${ms}ms)';
                      });

                      Future.delayed(Duration(milliseconds: ms), () {
                        setLocalState(() {
                          params['lastEvent'] = isSuccess ? 'Payload Diterima (200 OK)' : 'Error Timeout Terpicu';
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.send_rounded, size: 15),
                    label: const Text('Kirim Request Async', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );

  // =========================================================================
  // 6. DART OOP & IMMUTABLE DATA CLASS
  // =========================================================================
  static final SandboxPreset _oopImmutablePreset = SandboxPreset(
    id: 'oop_immutable',
    title: 'Dart OOP & Immutable copyWith',
    subtitle: 'Pahami konsep immutabilitas, final fields, dan instansiasi state aman',
    category: SandboxCategory.oopData,
    icon: Icons.data_object_rounded,
    initialParameters: {
      'name': 'Zainal Salamun',
      'role': 'Flutter Architect',
      'xp': 1450,
      'isActive': true,
      'instanceHash': '#0x7A9B',
    },
    codeGenerator: (params) {
      final name = params['name'] as String? ?? 'Zainal';
      final role = params['role'] as String? ?? 'Architect';
      final xp = params['xp'] as int? ?? 1450;
      final isActive = params['isActive'] as bool? ?? true;

      return '''
class StudentProfile {
  final String name;
  final String role;
  final int earnedXp;
  final bool isActive;

  const StudentProfile({
    required this.name,
    required this.role,
    required this.earnedXp,
    required this.isActive,
  });

  // Immutability: Mengembalikan instance baru tanpa mengubah objek asal
  StudentProfile copyWith({
    String? name,
    String? role,
    int? earnedXp,
    bool? isActive,
  }) {
    return StudentProfile(
      name: name ?? this.name,
      role: role ?? this.role,
      earnedXp: earnedXp ?? this.earnedXp,
      isActive: isActive ?? this.isActive,
    );
  }
}

// Eksekusi mutasi:
final original = StudentProfile(name: "$name", role: "$role", earnedXp: $xp, isActive: $isActive);
final updated = original.copyWith(earnedXp: ${xp + 50});''';
    },
    consoleOutputGenerator: (params) {
      final hash = params['instanceHash'] as String? ?? '#0x7A9B';
      final name = params['name'] as String? ?? 'Zainal';

      return [
        '[HEAP ALLOCATION] StudentProfile instance created in memory: $hash',
        '[IMMUTABILITY CHECK] All member variables marked final -> Compile-time safe',
        '[COPYWITH] Executed copyWith(name: "$name") -> Preserved original reference',
        '[GARBAGE COLLECTOR] Previous unreferenced states swept cleanly without leak.',
      ];
    },
    visualWidgetBuilder: (context, params) {
      final name = params['name'] as String? ?? 'Zainal Salamun';
      final role = params['role'] as String? ?? 'Flutter Architect';
      final xp = params['xp'] as int? ?? 1450;
      final isActive = params['isActive'] as bool? ?? true;
      final hash = params['instanceHash'] as String? ?? '#0x7A9B';

      return Center(
        child: Container(
          width: 240,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFFEC4899).withValues(alpha: 0.15),
                    child: const Icon(Icons.person_rounded, size: 18, color: Color(0xFFEC4899)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                        Text(role, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(hash, style: const TextStyle(fontSize: 9, fontFamily: 'monospace', color: Color(0xFF475569))),
                  ),
                ],
              ),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('XP Reward: $xp XP', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isActive ? 'Status Aktif' : 'Non-aktif',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: isActive ? const Color(0xFF15803D) : const Color(0xFFDC2626),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _SandboxLivePainter extends CustomPainter {
  final double strokeWidth;
  final int shapeIndex;
  final Color color;
  final bool isFill;
  final double rotationDeg;

  _SandboxLivePainter({
    required this.strokeWidth,
    required this.shapeIndex,
    required this.color,
    required this.isFill,
    required this.rotationDeg,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = isFill ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationDeg * math.pi / 180);

    switch (shapeIndex) {
      case 0: // Circle
        canvas.drawCircle(Offset.zero, radius, paint);
        break;
      case 1: // Star
        final path = Path();
        for (int i = 0; i < 5; i++) {
          final double angle = (i * 4 * math.pi) / 5 - math.pi / 2;
          final double x = radius * math.cos(angle);
          final double y = radius * math.sin(angle);
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
        break;
      case 2: // Hexagon
        final path = Path();
        for (int i = 0; i < 6; i++) {
          final double angle = (i * 2 * math.pi) / 6;
          final double x = radius * math.cos(angle);
          final double y = radius * math.sin(angle);
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
        break;
      case 3: // Sine Wave
      default:
        final path = Path();
        path.moveTo(-radius, 0);
        path.quadraticBezierTo(-radius / 2, -radius, 0, 0);
        path.quadraticBezierTo(radius / 2, radius, radius, 0);
        canvas.drawPath(path, paint);
        break;
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SandboxLivePainter oldDelegate) {
    return oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.shapeIndex != shapeIndex ||
        oldDelegate.color != color ||
        oldDelegate.isFill != isFill ||
        oldDelegate.rotationDeg != rotationDeg;
  }
}
