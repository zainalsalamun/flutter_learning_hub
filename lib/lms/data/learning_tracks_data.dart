import 'package:flutter/material.dart';
import '../../fundamentals/models/fundamental_module.dart';
import '../models/learning_track.dart';

class LearningTracksData {
  static const List<LearningTrack> allTracks = [
    LearningTrack(
      id: 'track_foundations',
      title: 'Dart & Core Foundations',
      subtitle: 'Sintaks Dart Modern, Lifecycle & Render Trees',
      description:
          'Fondasi wajib untuk setiap engineer Flutter: menguasai Dart OOP, Null Safety, alur siklus hidup widget, serta hierarki Three Trees.',
      icon: Icons.foundation_rounded,
      color: Color(0xFF0284C7),
      includedModules: [
        FundamentalModule.dartBasics,
        FundamentalModule.architecture,
        FundamentalModule.lifecycle,
        FundamentalModule.layoutRules,
      ],
    ),
    LearningTrack(
      id: 'track_state_arch',
      title: 'Architecture & State Mastery',
      subtitle: 'Navigasi, Clean Architecture, BLoC & Riverpod',
      description:
          'Kuasai manajemen status skala industri: dari ephemeral state dasar, pola BLoC/Cubit event-driven, hingga Riverpod 2.x modern.',
      icon: Icons.hub_rounded,
      color: Color(0xFF6366F1),
      includedModules: [
        FundamentalModule.navigation,
        FundamentalModule.stateManagement,
        FundamentalModule.advancedState,
        FundamentalModule.cleanArchitecture,
      ],
    ),
    LearningTrack(
      id: 'track_ui_canvas',
      title: 'UI Mastery & Canvas Art',
      subtitle: 'Material 3 Theming, Animasi & CustomPainter',
      description:
          'Menjadi ahli antarmuka: bangun layout responsif, animasi controller kompleks, serta lukis grafik visual kustom menggunakan Canvas.',
      icon: Icons.palette_rounded,
      color: Color(0xFFDB2777),
      includedModules: [
        FundamentalModule.themingResponsive,
        FundamentalModule.animationsCustomPainter,
      ],
    ),
    LearningTrack(
      id: 'track_production',
      title: 'Production Ecosystem & QA',
      subtitle: 'Dio API, Local Storage, Testing & Quality Assurance',
      description:
          'Standar aplikasi production: integrasi REST API dengan interceptor, offline caching data, serta Unit dan Widget testing otomatis.',
      icon: Icons.rocket_launch_rounded,
      color: Color(0xFF059669),
      includedModules: [
        FundamentalModule.asyncNetworking,
        FundamentalModule.networkingApi,
        FundamentalModule.localStorage,
        FundamentalModule.testingQa,
      ],
    ),
  ];
}
