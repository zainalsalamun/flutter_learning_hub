import 'package:flutter/material.dart';
import '../data/sandbox_presets_data.dart';
import '../models/sandbox_preset.dart';

class SandboxParameterControls extends StatelessWidget {
  final SandboxPreset preset;
  final Map<String, dynamic> params;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const SandboxParameterControls({
    super.key,
    required this.preset,
    required this.params,
    required this.onChanged,
  });

  void _update(String key, dynamic value) {
    final updated = Map<String, dynamic>.from(params);
    updated[key] = value;
    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    switch (preset.id) {
      case 'layout_box':
        return _buildLayoutBoxControls(context);
      case 'flex_alignment':
        return _buildFlexControls(context);
      case 'state_lifecycle':
        return _buildLifecycleControls(context);
      case 'custom_painter':
        return _buildPainterControls(context);
      case 'async_stream':
        return _buildAsyncControls(context);
      case 'oop_immutable':
        return _buildOopControls(context);
      default:
        return const SizedBox.shrink();
    }
  }

  // 1. Layout Box Controls
  Widget _buildLayoutBoxControls(BuildContext context) {
    final w = (params['width'] as num? ?? 220.0).toDouble();
    final h = (params['height'] as num? ?? 120.0).toDouble();
    final r = (params['borderRadius'] as num? ?? 12.0).toDouble();
    final p = (params['padding'] as num? ?? 16.0).toDouble();
    final colorIdx = (params['colorIndex'] as int? ?? 0).clamp(0, SandboxPresetsData.themePalette.length - 1);
    final showBorder = params['showBorder'] as bool? ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSliderRow('Lebar (Width)', '${w.toInt()} px', w, 80, 280, (val) => _update('width', val)),
        _buildSliderRow('Tinggi (Height)', '${h.toInt()} px', h, 40, 180, (val) => _update('height', val)),
        _buildSliderRow('Border Radius', '${r.toInt()} px', r, 0, 36, (val) => _update('borderRadius', val)),
        _buildSliderRow('Padding', '${p.toInt()} px', p, 4, 32, (val) => _update('padding', val)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tampilkan Border', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
            Switch(
              value: showBorder,
              onChanged: (val) => _update('showBorder', val),
              activeThumbColor: const Color(0xFF02569B),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text('Pilihan Warna Tema:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
        const SizedBox(height: 8),
        Row(
          children: List.generate(SandboxPresetsData.themePalette.length, (idx) {
            final col = SandboxPresetsData.themePalette[idx];
            final isSelected = colorIdx == idx;
            return GestureDetector(
              onTap: () => _update('colorIndex', idx),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: col,
                  shape: BoxShape.circle,
                  border: isSelected ? Border.all(color: Colors.white, width: 2.5) : null,
                  boxShadow: isSelected
                      ? [BoxShadow(color: col.withValues(alpha: 0.6), blurRadius: 6, spreadRadius: 1)]
                      : null,
                ),
                child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
              ),
            );
          }),
        ),
      ],
    );
  }

  // 2. Flex Controls
  Widget _buildFlexControls(BuildContext context) {
    final isRow = params['isRow'] as bool? ?? true;
    final mainIdx = (params['mainAxisIndex'] as int? ?? 1).clamp(0, 4);
    final count = (params['itemCount'] as int? ?? 3).toDouble();
    final useExpanded = params['useExpanded'] as bool? ?? false;

    const mainLabels = ['Start', 'Center', 'End', 'Between', 'Around'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Arah Flex (Direction)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Row')),
                ButtonSegment(value: false, label: Text('Column')),
              ],
              selected: {isRow},
              onSelectionChanged: (val) => _update('isRow', val.first),
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text('MainAxisAlignment:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(mainLabels.length, (i) {
              final isSel = mainIdx == i;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text(mainLabels[i], style: TextStyle(fontSize: 11, color: isSel ? Colors.white : const Color(0xFF0F172A))),
                  selected: isSel,
                  selectedColor: const Color(0xFF6366F1),
                  onSelected: (_) => _update('mainAxisIndex', i),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        _buildSliderRow('Jumlah Child Items', '${count.toInt()}', count, 1, 4, (val) => _update('itemCount', val.toInt())),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Gunakan Expanded (flex=1)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
            Switch(
              value: useExpanded,
              onChanged: (val) => _update('useExpanded', val),
              activeThumbColor: const Color(0xFF6366F1),
            ),
          ],
        ),
      ],
    );
  }

  // 3. Lifecycle Controls
  Widget _buildLifecycleControls(BuildContext context) {
    final counter = params['counter'] as int? ?? 0;
    final rebuilds = params['rebuildCount'] as int? ?? 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Counter State Saat Ini', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                Text('$counter (Total Rebuild: $rebuilds)', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              ],
            ),
            OutlinedButton.icon(
              onPressed: () {
                _update('counter', 0);
                _update('rebuildCount', 1);
              },
              icon: const Icon(Icons.restart_alt_rounded, size: 16),
              label: const Text('Reset', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
      ],
    );
  }

  // 4. Painter Controls
  Widget _buildPainterControls(BuildContext context) {
    final stroke = (params['strokeWidth'] as num? ?? 4.0).toDouble();
    final shapeIdx = (params['shapeIndex'] as int? ?? 0).clamp(0, 3);
    final rot = (params['rotationDeg'] as num? ?? 45.0).toDouble();
    final isFill = params['isFill'] as bool? ?? false;
    final colorIdx = (params['colorIndex'] as int? ?? 3).clamp(0, SandboxPresetsData.themePalette.length - 1);

    const shapes = ['Circle', 'Star', 'Hexagon', 'Wave'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Bentuk Geometris Canvas:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(shapes.length, (i) {
              final isSel = shapeIdx == i;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text(shapes[i], style: TextStyle(fontSize: 11, color: isSel ? Colors.white : const Color(0xFF0F172A))),
                  selected: isSel,
                  selectedColor: const Color(0xFF8B5CF6),
                  onSelected: (_) => _update('shapeIndex', i),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        _buildSliderRow('Ketebalan Kuas (Stroke)', '${stroke.toStringAsFixed(1)} px', stroke, 1, 12, (v) => _update('strokeWidth', v)),
        _buildSliderRow('Rotasi Kanvas', '${rot.toInt()}°', rot, 0, 360, (v) => _update('rotationDeg', v)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Gaya Warna (Fill vs Stroke)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
            Switch(
              value: isFill,
              onChanged: (val) => _update('isFill', val),
              activeThumbColor: const Color(0xFF8B5CF6),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text('Pilihan Warna Kuas:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
        const SizedBox(height: 6),
        Row(
          children: List.generate(SandboxPresetsData.themePalette.length, (idx) {
            final col = SandboxPresetsData.themePalette[idx];
            final isSelected = colorIdx == idx;
            return GestureDetector(
              onTap: () => _update('colorIndex', idx),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: col,
                  shape: BoxShape.circle,
                  border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                ),
                child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
              ),
            );
          }),
        ),
      ],
    );
  }

  // 5. Async Controls
  Widget _buildAsyncControls(BuildContext context) {
    final ms = (params['delayMs'] as num? ?? 800).toDouble();
    final isSuccess = params['isSuccess'] as bool? ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSliderRow('Simulasi Latensi Future', '${ms.toInt()} ms', ms, 100, 2000, (v) => _update('delayMs', v.toInt())),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Status Response (200 OK vs Error)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
            Switch(
              value: isSuccess,
              onChanged: (val) => _update('isSuccess', val),
              activeThumbColor: const Color(0xFF10B981),
            ),
          ],
        ),
      ],
    );
  }

  // 6. OOP Controls
  Widget _buildOopControls(BuildContext context) {
    final name = params['name'] as String? ?? 'Zainal Salamun';
    final role = params['role'] as String? ?? 'Flutter Architect';
    final isActive = params['isActive'] as bool? ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: name,
          decoration: const InputDecoration(
            labelText: 'Nama Objek (Student.name)',
            isDense: true,
            border: OutlineInputBorder(),
          ),
          onChanged: (val) => _update('name', val),
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: role,
          decoration: const InputDecoration(
            labelText: 'Peran Objek (Student.role)',
            isDense: true,
            border: OutlineInputBorder(),
          ),
          onChanged: (val) => _update('role', val),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Status Keaktifan (Student.isActive)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
            Switch(
              value: isActive,
              onChanged: (val) => _update('isActive', val),
              activeThumbColor: const Color(0xFFEC4899),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSliderRow(
    String label,
    String valueText,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569))),
              Text(valueText, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: const Color(0xFF02569B),
              thumbColor: const Color(0xFF02569B),
              inactiveTrackColor: Colors.grey.shade200,
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
