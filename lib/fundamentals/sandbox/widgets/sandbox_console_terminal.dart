import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SandboxConsoleTerminal extends StatelessWidget {
  final List<String> logs;
  final VoidCallback onClear;
  final VoidCallback onRerun;

  const SandboxConsoleTerminal({
    super.key,
    required this.logs,
    required this.onClear,
    required this.onRerun,
  });

  Color _resolveLogColor(String line) {
    if (line.contains('[ERROR') || line.contains('Exception')) {
      return const Color(0xFFF87171); // Red
    }
    if (line.contains('[STATUS]') ||
        line.contains('[RESOLVED]') ||
        line.contains('clean') ||
        line.contains('success')) {
      return const Color(0xFF4ADE80); // Green
    }
    if (line.contains('[RENDER]') ||
        line.contains('[LAYOUT]') ||
        line.contains('[PAINT]') ||
        line.contains('[FLEX]')) {
      return const Color(0xFF38BDF8); // Sky blue
    }
    if (line.contains('[LIFECYCLE]') ||
        line.contains('[EVENT LOOP]') ||
        line.contains('[MUTATION]')) {
      return const Color(0xFFFBBF24); // Amber
    }
    if (line.contains('[DART VM]') ||
        line.contains('[HEAP') ||
        line.contains('[SKIA')) {
      return const Color(0xFFC084FC); // Purple
    }
    return const Color(0xFFCBD5E1); // Muted white
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Terminal Top Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                // 3 macOS style dots
                Row(
                  children: [
                    Container(width: 9, height: 9, decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle)),
                    const SizedBox(width: 5),
                    Container(width: 9, height: 9, decoration: const BoxDecoration(color: Color(0xFFF59E0B), shape: BoxShape.circle)),
                    const SizedBox(width: 5),
                    Container(width: 9, height: 9, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(width: 10),
                const Text(
                  'dart test/sandbox_runner.dart',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, size: 15, color: Color(0xFF94A3B8)),
                  tooltip: 'Re-run Terminal',
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onRerun,
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 15, color: Color(0xFF94A3B8)),
                  tooltip: 'Salin Log',
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: logs.join('\n')));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Log terminal berhasil disalin!'),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.delete_sweep_rounded, size: 16, color: Color(0xFF94A3B8)),
                  tooltip: 'Bersihkan Log',
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onClear,
                ),
              ],
            ),
          ),

          // Terminal Output Stream
          Container(
            padding: const EdgeInsets.all(12),
            height: 180,
            child: logs.isEmpty
                ? const Center(
                    child: Text(
                      'Terminal bersih. Tekan "Jalankan Kode" untuk mengeksekusi.',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final line = logs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          line,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: _resolveLogColor(line),
                            height: 1.4,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
