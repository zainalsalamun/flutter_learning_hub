import 'package:flutter/material.dart';

enum InspectorCategory {
  boxContainer('Box & Container', Icons.check_box_outline_blank_rounded, Color(0xFF6366F1)),
  button('Button & Material', Icons.smart_button_rounded, Color(0xFF0284C7)),
  typography('Text & Typography', Icons.text_fields_rounded, Color(0xFF10B981)),
  glassCard('Card & Glassmorphism', Icons.crop_portrait_rounded, Color(0xFFDB2777)),
  flexLayout('Flex & Alignment', Icons.view_quilt_rounded, Color(0xFF8B5CF6)),
  motion('Animated Motion', Icons.animation_rounded, Color(0xFFF59E0B));

  final String title;
  final IconData icon;
  final Color color;

  const InspectorCategory(this.title, this.icon, this.color);
}
