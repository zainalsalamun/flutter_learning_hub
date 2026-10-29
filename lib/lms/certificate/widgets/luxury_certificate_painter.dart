import 'dart:math' as math;
import 'package:flutter/material.dart';

/// CustomPainter that renders a high-fidelity luxury graduation certificate
/// with ornate guilloche borders, corner filigrees, background security guilloche watermark,
/// gold ribbon seal, simulated QR verification matrix, and vector signatures.
class LuxuryCertificatePainter extends CustomPainter {
  final String certId;
  final String studentName;
  final String issueDateText;
  final bool isEligible;

  LuxuryCertificatePainter({
    required this.certId,
    required this.studentName,
    required this.issueDateText,
    this.isEligible = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final w = size.width;
    final h = size.height;

    // 1. Subtle Paper Background & Gradient
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFFDF9), // Warm antique paper
          Color(0xFFFBF8F1),
          Color(0xFFFFFDF8),
        ],
      ).createShader(rect);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)), bgPaint);

    // 2. Translucent Security Watermark Pattern
    _drawSecurityWatermark(canvas, size);

    // 3. Ornate Outer & Inner Gold Border
    _drawOrnateBorders(canvas, size);

    // 4. Filigree Corner Ornaments
    _drawCornerFiligrees(canvas, size);

    // 5. Official Gold Ribbon Seal Emblem (Lower Left)
    _drawOfficialGoldSeal(canvas, Offset(w * 0.16, h * 0.76), radius: math.min(w, h) * 0.11);

    // 6. Vector Signatures (Instructor & Academic Dean)
    _drawSignatures(canvas, size);

    // 7. QR Code Canvas (Lower Right)
    _drawQrCodeMatrix(canvas, Offset(w * 0.84, h * 0.76), size: math.min(w, h) * 0.17);
  }

  void _drawSecurityWatermark(Canvas canvas, Size size) {
    final patternPaint = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final center = Offset(size.width / 2, size.height / 2);
    final maxR = math.min(size.width, size.height) * 0.45;

    // Concentric Guilloche rosettes
    for (int r = 20; r <= maxR.toInt(); r += 18) {
      canvas.drawCircle(center, r.toDouble(), patternPaint);
    }

    // Crossed diamond lattice
    final step = 28.0;
    for (double x = 16; x < size.width - 16; x += step) {
      canvas.drawLine(
        Offset(x, 16),
        Offset(x + size.height - 32, size.height - 16),
        patternPaint,
      );
      canvas.drawLine(
        Offset(x, size.height - 16),
        Offset(x + size.height - 32, 16),
        patternPaint,
      );
    }
  }

  void _drawOrnateBorders(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Outer Primary Gold Line
    final outerGoldPaint = Paint()
      ..color = const Color(0xFFC59B27)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final outerRect = Rect.fromLTRB(14, 14, w - 14, h - 14);
    canvas.drawRRect(RRect.fromRectAndRadius(outerRect, const Radius.circular(10)), outerGoldPaint);

    // Secondary Fine Navy Border
    final innerNavyPaint = Paint()
      ..color = const Color(0xFF1E293B).withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final innerRect = Rect.fromLTRB(20, 20, w - 20, h - 20);
    canvas.drawRRect(RRect.fromRectAndRadius(innerRect, const Radius.circular(8)), innerNavyPaint);

    // Thin Inner Gold Accent
    final accentGoldPaint = Paint()
      ..color = const Color(0xFFE5C07B).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final accentRect = Rect.fromLTRB(24, 24, w - 24, h - 24);
    canvas.drawRRect(RRect.fromRectAndRadius(accentRect, const Radius.circular(6)), accentGoldPaint);
  }

  void _drawCornerFiligrees(Canvas canvas, Size size) {
    final cornerPaint = Paint()
      ..color = const Color(0xFFB48A1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = const Color(0xFFD4AF37)
      ..style = PaintingStyle.fill;

    const margin = 20.0;
    const len = 22.0;

    // Helper for 4 corners
    void drawCorner(double x, double y, double dx, double dy) {
      final path = Path();
      path.moveTo(x + dx * len, y);
      path.quadraticBezierTo(x, y, x, y + dy * len);
      canvas.drawPath(path, cornerPaint);

      // Inner floral leaf loop
      final loopPath = Path();
      loopPath.moveTo(x + dx * (len * 0.7), y + dy * 4);
      loopPath.cubicTo(
        x + dx * 8, y + dy * 8,
        x + dx * 8, y + dy * 8,
        x + dx * 4, y + dy * (len * 0.7),
      );
      canvas.drawPath(loopPath, cornerPaint);

      // Corner bead
      canvas.drawCircle(Offset(x + dx * 6, y + dy * 6), 2.2, dotPaint);
    }

    drawCorner(margin, margin, 1, 1); // Top Left
    drawCorner(size.width - margin, margin, -1, 1); // Top Right
    drawCorner(margin, size.height - margin, 1, -1); // Bottom Left
    drawCorner(size.width - margin, size.height - margin, -1, -1); // Bottom Right
  }

  void _drawOfficialGoldSeal(Canvas canvas, Offset center, {required double radius}) {
    if (radius <= 0) return;

    final sealShadow = Paint()
      ..color = const Color(0xFF78350F).withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(center.translate(0, 3), radius, sealShadow);

    // Serrated 16-point Star Ribbon Rays
    final raysPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.fill;

    final rayPath = Path();
    const points = 16;
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi) / points;
      final r = (i % 2 == 0) ? radius : radius * 0.88;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        rayPath.moveTo(x, y);
      } else {
        rayPath.lineTo(x, y);
      }
    }
    rayPath.close();
    canvas.drawPath(rayPath, raysPaint);

    // Inner Gold Gradient Circle
    final innerGoldPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFDE68A),
          const Color(0xFFD97706),
          const Color(0xFF92400E),
        ],
        stops: const [0.0, 0.75, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.82));
    canvas.drawCircle(center, radius * 0.82, innerGoldPaint);

    // Double Ring
    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, radius * 0.74, ringPaint);
    canvas.drawCircle(center, radius * 0.66, ringPaint);

    // Center Star Symbol
    final starPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final starPath = Path();
    final starR = radius * 0.38;
    for (int i = 0; i < 10; i++) {
      final angle = (i * math.pi) / 5 - math.pi / 2;
      final r = (i % 2 == 0) ? starR : starR * 0.45;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
    }
    starPath.close();
    canvas.drawPath(starPath, starPaint);
  }

  void _drawSignatures(Canvas canvas, Size size) {
    final sigPaint = Paint()
      ..color = const Color(0xFF1E3A8A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Center Left Signature Line & Ink Flow (Lead Instructor)
    final sigCenterX = w * 0.40;
    final sigBaseY = h * 0.78;

    final sigPath = Path();
    sigPath.moveTo(sigCenterX - 35, sigBaseY - 14);
    sigPath.cubicTo(
      sigCenterX - 15, sigBaseY - 32,
      sigCenterX - 5, sigBaseY - 2,
      sigCenterX + 10, sigBaseY - 18,
    );
    sigPath.cubicTo(
      sigCenterX + 20, sigBaseY - 28,
      sigCenterX + 25, sigBaseY - 8,
      sigCenterX + 38, sigBaseY - 12,
    );
    sigPath.moveTo(sigCenterX - 20, sigBaseY - 10);
    sigPath.lineTo(sigCenterX + 30, sigBaseY - 8);
    canvas.drawPath(sigPath, sigPaint);

    // Center Right Signature Line & Ink Flow (Chief Academic Officer)
    final sig2CenterX = w * 0.62;
    final sig2Path = Path();
    sig2Path.moveTo(sig2CenterX - 32, sigBaseY - 8);
    sig2Path.cubicTo(
      sig2CenterX - 22, sigBaseY - 28,
      sig2CenterX - 5, sigBaseY - 22,
      sig2CenterX + 5, sigBaseY - 6,
    );
    sig2Path.cubicTo(
      sig2CenterX + 14, sigBaseY - 26,
      sig2CenterX + 24, sigBaseY - 4,
      sig2CenterX + 35, sigBaseY - 16,
    );
    canvas.drawPath(sig2Path, sigPaint);
  }

  void _drawQrCodeMatrix(Canvas canvas, Offset center, {required double size}) {
    if (size <= 0) return;

    final half = size / 2;
    final qrRect = Rect.fromLTWH(center.dx - half, center.dy - half, size, size);

    // White Card Background for QR
    final qrBg = Paint()..color = Colors.white;
    final qrBorder = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(RRect.fromRectAndRadius(qrRect, const Radius.circular(6)), qrBg);
    canvas.drawRRect(RRect.fromRectAndRadius(qrRect, const Radius.circular(6)), qrBorder);

    final dotPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.fill;

    const int modules = 17; // 17x17 matrix
    final double moduleSize = (size - 6) / modules;
    final double originX = qrRect.left + 3;
    final double originY = qrRect.top + 3;

    // Helper to draw standard Finder Pattern (7x7 outer, 5x5 white, 3x3 black)
    void drawFinder(int startRow, int startCol) {
      // 7x7 black
      for (int r = 0; r < 7; r++) {
        for (int c = 0; c < 7; c++) {
          final isBorder = r == 0 || r == 6 || c == 0 || c == 6;
          final isCenter = (r >= 2 && r <= 4) && (c >= 2 && c <= 4);
          if (isBorder || isCenter) {
            final dotRect = Rect.fromLTWH(
              originX + (startCol + c) * moduleSize,
              originY + (startRow + r) * moduleSize,
              moduleSize,
              moduleSize,
            );
            canvas.drawRect(dotRect, dotPaint);
          }
        }
      }
    }

    // Top-left, Top-right, Bottom-left Finders
    drawFinder(0, 0);
    drawFinder(0, modules - 7);
    drawFinder(modules - 7, 0);

    // Deterministic Data dots from certId
    int seed = certId.hashCode.abs();
    for (int r = 0; r < modules; r++) {
      for (int c = 0; c < modules; c++) {
        // Skip finders
        final isTl = r < 7 && c < 7;
        final isTr = r < 7 && c >= modules - 7;
        final isBl = r >= modules - 7 && c < 7;
        if (isTl || isTr || isBl) continue;

        // Linear Congruential Generator step
        seed = (seed * 1103515245 + 12345) & 0x7fffffff;
        if (seed % 3 == 0) {
          final dotRect = Rect.fromLTWH(
            originX + c * moduleSize,
            originY + r * moduleSize,
            moduleSize - 0.3,
            moduleSize - 0.3,
          );
          canvas.drawRect(dotRect, dotPaint);
        }
      }
    }

    // Center flutter brand dot
    final centerDotPaint = Paint()..color = const Color(0xFF0284C7);
    canvas.drawCircle(center, moduleSize * 1.2, centerDotPaint);
  }

  @override
  bool shouldRepaint(covariant LuxuryCertificatePainter oldDelegate) {
    return oldDelegate.certId != certId ||
        oldDelegate.studentName != studentName ||
        oldDelegate.issueDateText != issueDateText ||
        oldDelegate.isEligible != isEligible;
  }
}
