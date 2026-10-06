import 'package:flutter/material.dart';
import 'fundamentals/pages/fundamentals_home_page.dart';
import 'lms/constants/app_design_tokens.dart';
import 'lms/pages/career_tracks_hub_page.dart';
import 'lms/pages/community_discussion_page.dart';
import 'lms/pages/student_profile_dashboard_page.dart';
import 'lms/quiz/pages/assessment_arena_page.dart';

class FlutterLearningHubPage extends StatefulWidget {
  final int initialTabIndex;

  const FlutterLearningHubPage({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<FlutterLearningHubPage> createState() => _FlutterLearningHubPageState();
}

class _FlutterLearningHubPageState extends State<FlutterLearningHubPage> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    FundamentalsHomePage(),
    CareerTracksHubPage(),
    AssessmentArenaPage(),
    CommunityDiscussionPage(),
    StudentProfileDashboardPage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(
              color: AppColors.borderSubtle,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.menu_book_outlined,
                  activeIcon: Icons.menu_book_rounded,
                  label: "Belajar",
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.timeline_rounded,
                  activeIcon: Icons.timeline_rounded,
                  label: "Jalur Karir",
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.help_outline_rounded,
                  activeIcon: Icons.help_rounded,
                  label: "Kuis",
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.chat_bubble_outline_rounded,
                  activeIcon: Icons.chat_bubble_rounded,
                  label: "Diskusi",
                ),
                _buildNavItem(
                  index: 4,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: "Profil",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () {
        if (_currentIndex != index) {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
