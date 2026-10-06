import 'package:flutter/material.dart';

class InteractiveRatingShowcase extends StatefulWidget {
  const InteractiveRatingShowcase({super.key});

  @override
  State<InteractiveRatingShowcase> createState() =>
      _InteractiveRatingShowcaseState();
}

class _InteractiveRatingShowcaseState extends State<InteractiveRatingShowcase> {
  int _rating = 4;

  final Map<int, (IconData, Color, String)> _ratingFeelings = {
    1: (
      Icons.sentiment_very_dissatisfied_rounded,
      const Color(0xFFEF4444),
      'Terrible experience',
    ),
    2: (
      Icons.sentiment_dissatisfied_rounded,
      const Color(0xFFF97316),
      'Needs improvement',
    ),
    3: (
      Icons.sentiment_neutral_rounded,
      const Color(0xFFF59E0B),
      'Average / Okay',
    ),
    4: (
      Icons.sentiment_satisfied_rounded,
      const Color(0xFF10B981),
      'Great experience!',
    ),
    5: (
      Icons.sentiment_very_satisfied_rounded,
      const Color(0xFF059669),
      'Absolutely Fantastic!',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final (sentimentIcon, sentimentColor, sentimentText) =
        _ratingFeelings[_rating] ??
            (Icons.star_rounded, Colors.amber, 'Rating');

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder:
                  (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Icon(
                sentimentIcon,
                key: ValueKey('icon_$_rating'),
                size: 54,
                color: sentimentColor,
              ),
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                sentimentText,
                key: ValueKey('text_$_rating'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                final starNumber = index + 1;
                final isFilled = starNumber <= _rating;

                return GestureDetector(
                  onTap: () => setState(() => _rating = starNumber),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      isFilled
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: isFilled ? Colors.amber : Colors.grey.shade300,
                      size: 36,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
