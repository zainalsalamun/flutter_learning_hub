import 'package:flutter/material.dart';

enum DiscussionCategory {
  architecture(
    title: 'Arsitektur',
    icon: Icons.account_tree_rounded,
    color: Color(0xFF0284C7),
  ),
  lifecycle(
    title: 'Lifecycle',
    icon: Icons.sync_rounded,
    color: Color(0xFFF59E0B),
  ),
  renderTree(
    title: 'Render Tree',
    icon: Icons.brush_rounded,
    color: Color(0xFF8B5CF6),
  ),
  stateManagement(
    title: 'State Management',
    icon: Icons.dynamic_feed_rounded,
    color: Color(0xFF10B981),
  ),
  cleanCode(
    title: 'Clean Code',
    icon: Icons.verified_rounded,
    color: Color(0xFF6366F1),
  ),
  debugging(
    title: 'Bug & Debugging',
    icon: Icons.pest_control_rounded,
    color: Color(0xFFEF4444),
  ),
  performance(
    title: 'Performa',
    icon: Icons.speed_rounded,
    color: Color(0xFFEC4899),
  );

  final String title;
  final IconData icon;
  final Color color;

  const DiscussionCategory({
    required this.title,
    required this.icon,
    required this.color,
  });
}

class DiscussionReply {
  final String id;
  final String authorName;
  final String authorRole;
  final Color authorAvatarColor;
  final String content;
  final String? codeSnippet;
  final DateTime createdAt;
  final int upvotes;
  final bool isSolution;
  final bool userUpvoted;

  const DiscussionReply({
    required this.id,
    required this.authorName,
    required this.authorRole,
    required this.authorAvatarColor,
    required this.content,
    this.codeSnippet,
    required this.createdAt,
    this.upvotes = 0,
    this.isSolution = false,
    this.userUpvoted = false,
  });

  DiscussionReply copyWith({
    String? id,
    String? authorName,
    String? authorRole,
    Color? authorAvatarColor,
    String? content,
    String? codeSnippet,
    DateTime? createdAt,
    int? upvotes,
    bool? isSolution,
    bool? userUpvoted,
  }) {
    return DiscussionReply(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorRole: authorRole ?? this.authorRole,
      authorAvatarColor: authorAvatarColor ?? this.authorAvatarColor,
      content: content ?? this.content,
      codeSnippet: codeSnippet ?? this.codeSnippet,
      createdAt: createdAt ?? this.createdAt,
      upvotes: upvotes ?? this.upvotes,
      isSolution: isSolution ?? this.isSolution,
      userUpvoted: userUpvoted ?? this.userUpvoted,
    );
  }
}

class DiscussionThread {
  final String id;
  final String title;
  final String content;
  final String? codeSnippet;
  final String authorName;
  final String authorRole;
  final Color authorAvatarColor;
  final DiscussionCategory category;
  final DateTime createdAt;
  final int upvotes;
  final bool userUpvoted;
  final bool isSolved;
  final int viewCount;
  final List<DiscussionReply> replies;
  final List<String> tags;

  const DiscussionThread({
    required this.id,
    required this.title,
    required this.content,
    this.codeSnippet,
    required this.authorName,
    required this.authorRole,
    required this.authorAvatarColor,
    required this.category,
    required this.createdAt,
    this.upvotes = 0,
    this.userUpvoted = false,
    this.isSolved = false,
    this.viewCount = 0,
    this.replies = const [],
    this.tags = const [],
  });

  DiscussionThread copyWith({
    String? id,
    String? title,
    String? content,
    String? codeSnippet,
    String? authorName,
    String? authorRole,
    Color? authorAvatarColor,
    DiscussionCategory? category,
    DateTime? createdAt,
    int? upvotes,
    bool? userUpvoted,
    bool? isSolved,
    int? viewCount,
    List<DiscussionReply>? replies,
    List<String>? tags,
  }) {
    return DiscussionThread(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      codeSnippet: codeSnippet ?? this.codeSnippet,
      authorName: authorName ?? this.authorName,
      authorRole: authorRole ?? this.authorRole,
      authorAvatarColor: authorAvatarColor ?? this.authorAvatarColor,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      upvotes: upvotes ?? this.upvotes,
      userUpvoted: userUpvoted ?? this.userUpvoted,
      isSolved: isSolved ?? this.isSolved,
      viewCount: viewCount ?? this.viewCount,
      replies: replies ?? this.replies,
      tags: tags ?? this.tags,
    );
  }
}
