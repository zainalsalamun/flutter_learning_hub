# 🚀 Flutter Learning Hub & LMS Mastery

A comprehensive, interactive Flutter Learning Management System (LMS) and widget laboratory combining in-depth theoretical fundamentals, interactive canvas visualizers, structured career learning tracks, student progress tracking, gamification (XP, levels & badges), and an essential-to-advanced component catalog.

---

## 🌟 Fitur Utama (Pilar LMS & Laboratorium)

### 🎓 1. LMS Mastery & Career Tracks (24 Modul Lengkap)
- **4 Career Learning Tracks:**
  1. *Dart & Core Foundations* (Dart OOP, Null Safety, Mixins, The Three Trees, Lifecycle, Layout Rules).
  2. *Architecture & State Mastery* (Navigation, Ephemeral State, Clean Arch, BLoC/Cubit, Riverpod 2.x).
  3. *UI Mastery & Canvas Art* (Theming, Responsive Design, Explicit Animation, CustomPainter Canvas).
  4. *Production Ecosystem & QA* (Async/Streams, Dio REST API, Local Storage, Unit & Widget Testing).
- **Gamifikasi Siswa (XP, Level & Streaks):**
  - Perolehan XP: +50 XP per materi tuntas, +150-160 XP per kelulusan ujian evaluasi track, +30 XP per checkpoint kuis benar, +25 XP per catatan rangkuman.
  - 10 Tingkat Keahlian (Level 1: *Flutter Novice* hingga Level 10: *Flutter Grandmaster*).
  - Daily Streak Flame Tracker untuk menjaga konsistensi belajar harian.
  - 14 Lencana Pencapaian (*Badges*) termasuk *Pakar Kuis*, *Laboran Flutter*, *Arsitek Portofolio*, dan *Certified Flutter Engineer*.
- **🎯 Arena Kuis & Ujian Kompetensi (Assessment Engine):**
  - Ujian evaluasi berdurasi dengan batas waktu (Countdown Timer) per Career Track.
  - Tantangan tebak output kode Dart & penyelesaian kasus riil industri.
  - Penilaian kelulusan otomatis (*Passing Score 70%*) dengan perolehan XP.
  - Layar pembahasan jawaban mendalam (*Detailed Review & Explanation*) untuk setiap nomor soal.
- **🎛️ Live Code Tweaker & Property Inspector Studio:**
  - **Interactive Visual Canvas Stage:** Studio pengujian properti widget secara visual dengan switch *Dark/Light Viewport* dan live preview.
  - **6 Preset Kategori Widget:** *Box & Container*, *Button & Material*, *Text & Typography*, *Card & Glassmorphism*, *Flex & Alignment*, dan *Animated Motion*.
  - **Dynamic Dart Code Generator:** Panel tab generator kode Dart otomatis yang menghasilkan kode rapi dan siap di-copy ke project Flutter siswa.
  - **Gamifikasi Inspector:** 1-tap copy kode memberikan reward +50 XP dan membuka lencana *Laboran Flutter* (`lab_experimenter`).
- **🚀 Capstone Projects Portfolio Lab:**
  - 3 Proyek portofolio produksi nyata:
    1. *FinTech Portfolio & Crypto Vault:* Clean Architecture, Dio Interceptor, BLoC Pattern, CustomPainter Sparkline.
    2. *Omnichannel E-Commerce Marketplace:* Riverpod 2.x, Dynamic Slivers, Hero Animations, Optimistic UI.
    3. *HealthPulse Biometric Dashboard:* Triple Concentric Activity Rings Canvas, Real-time Sensor Stream, Glassmorphism, Mocktail Unit Tests.
  - Setiap proyek dilengkapi *Live Interactive Simulation Demo*, *Folder Tree Blueprint*, *Source Code Snippets*, dan *Milestone Checklist (+250 XP)*.
- **📜 Sertifikat Kelulusan Resmi Digital (Certificate of Completion):**
  - Sistem validasi kelulusan otomatis berdasarkan capaian 4 Ujian Jalur Karir dan Capstone Portofolio.
  - Kartu sertifikat mewah dengan seal emas, nomor kredensial unik (`FL-LMS-2026-XXXXX`), tanggal kelulusan, dan tautan verifikasi resmi.
  - Fitur personalisasi nama siswa secara live dan klaim reward kelulusan +300 XP.
- **Rapor & Profil Siswa (Student Dashboard):**
  - 4 Tab komprehensif: *Lencana (Badges)*, *Ujian (Assessments)*, *Tersimpan (Bookmarks)*, dan *Catatan Saya (Notes)*, dilengkapi banner status kelulusan fast-track.
- **9 Interactive Canvas Visualizers:** Diagram interaktif real-time untuk memahami lifecycle, tree structure, constraint propagation, dan alur state.

### 📱 2. Basic Widgets Catalog (30+ Essential Widgets)
- **Kategori:** *Layout*, *Buttons*, *Inputs*, *Typography & Display*, *Feedback & Dialogs*, *Lists & Scrolling*.
- **Interactive Playground:** Coba interaksi live dan salin kode snippet instan dengan fitur 1-tap copy & bookmark ke rapor belajar.

### 🧪 3. Pro Widget Catalog & Advanced Lab (45+ Showcases)
- **Kategori Pro:**
  - *Complex Animations & Canvas:* Candlestick Chart, Apple Watch Activity Rings, Lucky Wheel, Claw Machine, Particle Fireworks, 360 Turntable.
  - *Biometrics & Security:* Face ID Scanner, Biometric Fingerprint, Pattern Lock, Signature Pad.
  - *Financial & Web3:* Staking Yield Calculator, Order Book Depth Chart, AMM Curve, Web3 Wallet Connect Sheet.
  - *Interactive Cards & Navigation:* Spatial Parallax Tilt Card, Origami Fold Card, Kanban Drag & Drop, Vision Spatial HUD Window.

---

## 📁 Struktur Proyek

```
flutter_learning_hub/
├── lib/
│   ├── main.dart                              # Application Entry Point & Theme Configuration
│   ├── flutter_learning_hub_page.dart         # Bottom Navigation Hub (3 Master Tabs)
│   │
│   ├── fundamentals/                          # 📘 Modul 1: Fundamentals
│   │   ├── data/                              # Kurikulum & Lesson Repository
│   │   ├── models/                            # Model data modul & lesson
│   │   ├── pages/                             # Halaman materi & detail lesson
│   │   ├── visualizers/                       # 9 Interactive Canvas Visualizers
│   │   └── widgets/                           # Formatted Markdown & UI helpers
│   │
│   ├── basics/                                # 📱 Modul 2: Basic Widgets
│   │   ├── data/                              # Core Flutter Widget Registry
│   │   ├── models/                            # Model kategori & basic widget
│   │   ├── pages/                             # Katalog dasar & detail playground
│   │   └── showcases/                         # 30+ Interactive Widget Demos
│   │
│   ├── catalog/                               # 🧪 Modul 3: Pro Catalog & Lab
│   │   ├── data/                              # Pro Widget Registry
│   │   ├── models/                            # Model kategori & filter tags
│   │   ├── pages/                             # Pro Showcase & Detail Playground
│   │   ├── widgets/                           # Custom Card, Filter Chips, Search Bar
│   │   └── showcases/                         # 45+ Advanced Component Showcases
│   │
│   └── lms/                                   # 🎓 Sistem LMS Terintegrasi
│       ├── data/                              # Tracks & 14 Badges Registry
│       ├── models/                            # UserProgress, LmsBadge, LearningTrack
│       ├── services/                          # LmsProgressService & LmsStorage
│       ├── quiz/                              # Assessment Engine & Question Bank
│       ├── inspector/                         # Live Property Inspector Studio & Generator
│       ├── capstone/                          # Portfolio Lab (FinTech, E-Commerce, Health)
│       ├── certificate/                       # Digital Certificate of Completion Hub
│       └── pages/                             # Student Dashboard & Rapor Belajar
│
├── test/
│   ├── widget_test.dart                       # Nav Smoke Tests
│   └── lms_progress_service_test.dart         # LMS Unit & Assessment Integrity Tests
└── pubspec.yaml                               # Flutter dependencies & metadata
```

---

## 🚀 Menjalankan Proyek

### Prasyarat
- Flutter SDK `^3.7.0` (atau lebih baru)
- Dart SDK `^3.7.0`

### Langkah-langkah
```bash
# 1. Masuk ke direktori project
cd flutter_learning_hub

# 2. Ambil semua dependencies
flutter pub get

# 3. Jalankan aplikasi
flutter run
```

---

## 🛠️ Stack & Dependencies

- **Framework:** Flutter (Material 3)
- **Typography:** `google_fonts` (Plus Jakarta Sans)
- **Icons:** `cupertino_icons`, Material Icons

---

## 💡 Panduan Pengembangan Selanjutnya

1. **Menambahkan Materi Fundamental Baru:**
   - Tambahkan entri di [lessons_repository.dart](file:///Users/macbookpro/development/naltech/flutter_learning_hub/lib/fundamentals/data/lessons_repository.dart).
   - Buat visualizer custom di folder [visualizers/](file:///Users/macbookpro/development/naltech/flutter_learning_hub/lib/fundamentals/visualizers/) jika diperlukan.

2. **Menambahkan Komponen Basic Widget Baru:**
   - Tambahkan showcase di [basics/showcases/](file:///Users/macbookpro/development/naltech/flutter_learning_hub/lib/basics/showcases/).
   - Daftarkan widget ke [basic_widgets_data.dart](file:///Users/macbookpro/development/naltech/flutter_learning_hub/lib/basics/data/basic_widgets_data.dart).

3. **Menambahkan Komponen Pro / Custom Lab:**
   - Buat showcase interaktif baru di [catalog/showcases/](file:///Users/macbookpro/development/naltech/flutter_learning_hub/lib/catalog/showcases/).
   - Daftarkan ke [widget_catalog_registry.dart](file:///Users/macbookpro/development/naltech/flutter_learning_hub/lib/catalog/data/widget_catalog_registry.dart).
