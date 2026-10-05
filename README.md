# 🚀 Flutter Learning Hub & Widget Mastery

A comprehensive, interactive Flutter mastery platform combining in-depth theoretical fundamentals with interactive visualizers, an essential widget catalog, and an advanced component laboratory.

---

## 🌟 Fitur Utama (3 Pilar Modul)

### 📘 1. Fundamentals (Konsep & Materi Inti)
- **8 Modul Teori Lengkap:**
  1. *Flutter Architecture & Rendering Pipeline*
  2. *Widget Lifecycle (Stateless vs Stateful)*
  3. *The Three Trees (Widget, Element, RenderObject)*
  4. *Constraints & Layout Rules (BoxConstraints & Slivers)*
  5. *State Management Essentials (InheritedWidget, ValueNotifier, Provider, BLoC)*
  6. *Async & Reactive Programming (Future, Stream, Isolate)*
  7. *Custom Painting & Canvas Mastery (CustomPainter, Shader, Path)*
  8. *Networking & API Communication (Dio, Http, WebSocket)*
- **9 Interactive Canvas Visualizers:** Diagram interaktif real-time untuk memahami lifecycle, tree structure, constraint propagation, dan alur state.

### 📱 2. Basic Widgets Catalog (30+ Essential Widgets)
- **Kategori:** *Layout*, *Buttons*, *Inputs*, *Typography & Display*, *Feedback & Dialogs*, *Lists & Scrolling*.
- **Interactive Playground:** Coba interaksi live dan salin kode snippet instan dengan fitur 1-tap copy.
- **Tampilan Fleksibel:** Mode Grid dan List dengan search real-time dan category filters.

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
│   └── catalog/                               # 🧪 Modul 3: Pro Catalog & Lab
│       ├── data/                              # Pro Widget Registry
│       ├── models/                            # Model kategori & filter tags
│       ├── pages/                             # Pro Showcase & Detail Playground
│       ├── widgets/                           # Custom Card, Filter Chips, Search Bar
│       └── showcases/                         # 45+ Advanced Component Showcases
│
├── test/
│   └── widget_test.dart                       # Unit & Widget Smoke Tests
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
