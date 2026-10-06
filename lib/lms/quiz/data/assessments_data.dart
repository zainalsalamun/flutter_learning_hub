import 'package:flutter/material.dart';
import '../models/assessment_model.dart';

class AssessmentsData {
  static const List<AssessmentTrackModel> allAssessments = [
    // =========================================================================
    // 1. EVALUASI TRACK 1: DART & CORE FOUNDATIONS
    // =========================================================================
    AssessmentTrackModel(
      id: 'eval_foundations',
      trackId: 'track_foundations',
      title: 'Ujian Evaluasi: Dart & Core Foundations',
      subtitle: 'Membedah Sintaks Dart, Render Trees, Lifecycle & Constraints',
      description:
          'Uji pemahaman komprehensif mengenai Dart OOP, Null Safety, alur siklus hidup widget, hierarki Element/RenderObject, dan hukum layout Flutter.',
      icon: Icons.foundation_rounded,
      color: Color(0xFF0284C7),
      passingScore: 70,
      rewardXp: 150,
      timeLimitMinutes: 10,
      questions: [
        AssessmentQuestion(
          id: 'q_found_1',
          question: 'Perhatikan potongan kode Dart berikut. Apa output atau perilaku saat program dikompilasi/dijalankan?',
          codeSnippet: '''
void main() {
  final List<int> a = [1, 2, 3];
  const List<int> b = [1, 2, 3];

  a.add(4);
  b.add(4);
}''',
          options: [
            'Berjalan sukses tanpa error, a dan b memiliki 4 elemen.',
            'a.add(4) berhasil, tetapi b.add(4) melempar UnsupportedError saat runtime.',
            'Compile-time error langsung pada baris b.add(4).',
            'Compile-time error pada inisialisasi final List<int> a.',
          ],
          correctIndex: 1,
          explanation:
              '`final` membuat referensi variabel immutable, tetapi objek koleksi di memori tetap mutable sehingga `a.add(4)` berhasil. Sebaliknya, `const` membuat koleksi kanonikal yang sepenuhnya unmodifiable saat runtime; memodifikasinya akan melempar UnsupportedError.',
          topic: 'Dart Immutability',
          difficulty: QuestionDifficulty.intermediate,
        ),
        AssessmentQuestion(
          id: 'q_found_2',
          question: 'Dalam arsitektur Three Trees Flutter, apa yang terjadi pada Element Tree ketika sebuah StatefulWidget memanggil setState() dan mereturn Widget baru dengan `runtimeType` dan `key` yang sama persis?',
          options: [
            'Element lama dihancurkan dan dibuat Element baru beserta State baru.',
            'Element yang ada dipertahankan dan diperbarui konfigurasinya via `update()`, State tetap hidup.',
            'RenderObject langsung dibuat ulang dari awal tanpa melibatkan Element.',
            'Flutter memicu crash karena duplikasi widget di pohon hierarki.',
          ],
          correctIndex: 1,
          explanation:
              'Flutter menggunakan algoritma `Widget.canUpdate(oldWidget, newWidget)`. Jika `runtimeType` dan `key` cocok, Element tidak dihancurkan melainkan hanya memanggil `update(newWidget)`. State instance tetap terjaga di memori, menjamin performa rendering yang sangat cepat.',
          topic: 'The Three Trees',
          difficulty: QuestionDifficulty.advanced,
        ),
        AssessmentQuestion(
          id: 'q_found_3',
          question: 'Di siklus hidup State (StatefulWidget Lifecycle), metode manakah yang merupakan tempat yang tepat dan aman untuk menginisialisasi controller atau mendaftarkan Stream listener sekali saja?',
          options: [
            'build()',
            'didUpdateWidget()',
            'initState()',
            'didChangeDependencies()',
          ],
          correctIndex: 2,
          explanation:
              '`initState()` dipanggil tepat satu kali saat objek State pertama kali dimasukkan ke dalam Element tree. Ini adalah tempat standar untuk menginisialisasi controller, animasi, atau subscription.',
          topic: 'Widget Lifecycle',
          difficulty: QuestionDifficulty.beginner,
        ),
        AssessmentQuestion(
          id: 'q_found_4',
          question: 'Sesuai dengan Golden Rule Layout Flutter: *"Constraints go down. Sizes go up. Parent sets position"*, apa yang terjadi jika sebuah Container(width: 300, height: 300) diletakkan langsung di dalam widget yang memberikan Tight Constraints (misal layar penuh Scaffold body tanpa Align)?',
          options: [
            'Container akan mengabaikan constraint dan berukuran tetap 300x300.',
            'Container akan dipaksa meregang memenuhi seluruh ukuran parent (mengabaikan width/height 300).',
            'Muncul exception RenderBox was not laid out.',
            'Container akan mengecil menjadi 0x0.',
          ],
          correctIndex: 1,
          explanation:
              'Widget anak tidak dapat memilih ukurannya sendiri di luar batas constraint yang diberikan parent. Jika parent memberikan tight constraints (minWidth == maxWidth), anak harus mengambil ukuran persis tersebut, sehingga properti width/height 300 pada Container akan terabaikan kecuali dibungkus dengan widget pelepas constraint seperti `Center` atau `Align`.',
          topic: 'Constraints & Layout',
          difficulty: QuestionDifficulty.intermediate,
        ),
        AssessmentQuestion(
          id: 'q_found_5',
          question: 'Perhatikan kode Dart Null Safety berikut. Kapan Exception akan terjadi?',
          codeSnippet: '''
class ProfileService {
  late final String apiKey;

  void printKey() {
    print(apiKey.toUpperCase());
  }
}''',
          options: [
            'Saat class ProfileService dikompilasi.',
            'Saat instance ProfileService dibuat (`final s = ProfileService()`).',
            'Saat method `printKey()` dipanggil sebelum `apiKey` diinisialisasi nilai.',
            'Tidak akan pernah error karena bertipe String.',
          ],
          correctIndex: 2,
          explanation:
              'Kata kunci `late` memberitahu kompilator bahwa variabel non-nullable ini akan diisi sebelum diakses. Jika `apiKey` dibaca sebelum sempat diinisialisasi nilai, Dart akan melempar `LateInitializationError` saat runtime.',
          topic: 'Null Safety & Late',
          difficulty: QuestionDifficulty.beginner,
        ),
      ],
    ),

    // =========================================================================
    // 2. EVALUASI TRACK 2: ARCHITECTURE & STATE MASTERY
    // =========================================================================
    AssessmentTrackModel(
      id: 'eval_state_arch',
      trackId: 'track_state_arch',
      title: 'Ujian Evaluasi: Architecture & State Mastery',
      subtitle: 'Navigasi, Clean Architecture, BLoC Event Flow & Riverpod 2.x',
      description:
          'Uji kemampuan dalam merancang arsitektur aplikasi scalable, pola dependency injection, event-driven reactive state dengan BLoC, dan providers Riverpod.',
      icon: Icons.hub_rounded,
      color: Color(0xFF6366F1),
      passingScore: 70,
      rewardXp: 160,
      timeLimitMinutes: 10,
      questions: [
        AssessmentQuestion(
          id: 'q_state_1',
          question: 'Dalam InheritedWidget, metode apa yang menentukan apakah widget-widget turunan (consumers) yang bergantung pada widget ini perlu di-rebuild saat konfigurasi berubah?',
          options: [
            'createElement()',
            'updateShouldNotify()',
            'dependOnInheritedWidgetOfExactType()',
            'shouldRebuildChildren()',
          ],
          correctIndex: 1,
          explanation:
              '`updateShouldNotify(covariant InheritedWidget oldWidget)` mengembalikan nilai boolean. Jika true, semua dependent widgets yang memanggil `dependOnInheritedWidgetOfExactType` akan dijadwalkan untuk re-build.',
          topic: 'InheritedWidget Core',
          difficulty: QuestionDifficulty.intermediate,
        ),
        AssessmentQuestion(
          id: 'q_state_2',
          question: 'Pada BLoC pattern, mengapa kita sangat disarankan memancarkan state baru yang merupakan INSTANCE BARU (immutable copyWith) daripada memodifikasi properti instance state yang lama?',
          codeSnippet: '''
// Kasus A (Buruk):
state.userList.add(newUser);
emit(state);

// Kasus B (Benar):
emit(state.copyWith(userList: [...state.userList, newUser]));''',
          options: [
            'Kasus A akan menghasilkan compile-time syntax error.',
            'BLoC menggunakan kesetaraan referensi (equality). Di Kasus A, state lama == state baru bernilai true sehingga UI tidak akan memicu rebuild.',
            'Kasus B menghabiskan memori lebih sedikit dibanding Kasus A.',
            'Kasus A dilarang oleh sistem operasi Android dan iOS.',
          ],
          correctIndex: 1,
          explanation:
              'BLoC (dan Equatable) membandingkan objek state sebelumnya dengan objek state baru. Jika referensi atau properti identik (karena memodifikasi objek lama in-place), BLoC menganggap tidak ada perubahan state dan mengabaikan emisi (`distinct` stream filter), sehingga UI tidak ter-update.',
          topic: 'BLoC Pattern',
          difficulty: QuestionDifficulty.intermediate,
        ),
        AssessmentQuestion(
          id: 'q_state_3',
          question: 'Dalam Riverpod 2.x, apa perbedaan mendasar antara `ref.watch(provider)` dan `ref.read(provider)` di dalam metode `build()` sebuah ConsumerWidget?',
          options: [
            '`ref.read` mendengarkan perubahan terus menerus, sedangkan `ref.watch` hanya membaca satu kali.',
            '`ref.watch` membuat widget me-rebuild dirinya saat nilai provider berubah, sedangkan `ref.read` hanya membaca nilai saat itu tanpa me-rebuild.',
            '`ref.watch` hanya boleh dipakai di fungsi async event callback (seperti onPressed).',
            'Tidak ada perbedaan, keduanya adalah alias sinonim.',
          ],
          correctIndex: 1,
          explanation:
              '`ref.watch` mendaftarkan listener reaktif sehingga widget otomatis re-build saat data berubah. `ref.read` hanya membaca nilai saat itu dan tidak boleh digunakan di dalam metode `build()` (hanya di callback seperti onPressed).',
          topic: 'Riverpod 2.x',
          difficulty: QuestionDifficulty.beginner,
        ),
        AssessmentQuestion(
          id: 'q_state_4',
          question: 'Berdasarkan prinsip Clean Architecture pada Flutter, lapisan (layer) manakah yang TIDAK BOLEH memiliki ketergantungan (dependency) ke Flutter Framework (UI) maupun library eksternal (Dio/HTTP/SharedPreferences)?',
          options: [
            'Data Layer',
            'Presentation Layer',
            'Domain Layer (Entities & UseCases)',
            'Infrastructure Layer',
          ],
          correctIndex: 2,
          explanation:
              'Domain Layer adalah inti dari bisnis logika aplikasi (Pure Dart). Domain layer sepenuhnya independen dari UI (Presentation) dan sumber data eksternal (Data Layer) dengan menerapkan prinsip Dependency Inversion.',
          topic: 'Clean Architecture',
          difficulty: QuestionDifficulty.advanced,
        ),
        AssessmentQuestion(
          id: 'q_state_5',
          question: 'Kapan sebaiknya developer menggunakan ephemeral state (setState / ValueNotifier) dibanding global state management seperti BLoC atau Riverpod?',
          options: [
            'Untuk mengelola autentikasi pengguna dan keranjang belanja e-commerce.',
            'Untuk state lokal widget tunggal yang tidak dibutuhkan widget lain, seperti animasi toggle switch atau tab index lokal.',
            'Hanya saat aplikasi berjalan dalam mode debug.',
            'setState tidak boleh digunakan sama sekali dalam Flutter modern.',
          ],
          correctIndex: 1,
          explanation:
              'Ephemeral state (UI state lokal) sangat ideal untuk hal-hal sederhana dan terisolasi seperti form input lokal, animasi switch, atau ekspansi accordion. Menggunakan BLoC/Riverpod untuk hal tersebut seringkali over-engineering.',
          topic: 'State Decisions',
          difficulty: QuestionDifficulty.beginner,
        ),
      ],
    ),

    // =========================================================================
    // 3. EVALUASI TRACK 3: UI MASTERY & CANVAS ART
    // =========================================================================
    AssessmentTrackModel(
      id: 'eval_ui_canvas',
      trackId: 'track_ui_canvas',
      title: 'Ujian Evaluasi: UI Mastery & Canvas Art',
      subtitle: 'CustomPainter, Bezier Curves, Shaders, & Animation Optimization',
      description:
          'Uji kemampuan dalam merancang antarmuka kustom tingkat tinggi: melukis kanvas grafis 2D, optimasi repaint boundary, dan animasi controller.',
      icon: Icons.palette_rounded,
      color: Color(0xFFDB2777),
      passingScore: 70,
      rewardXp: 150,
      timeLimitMinutes: 10,
      questions: [
        AssessmentQuestion(
          id: 'q_ui_1',
          question: 'Dalam implementasi `CustomPainter`, metode `shouldRepaint(covariant CustomPainter oldDelegate)` memiliki peran krusial terhadap performa. Apa yang terjadi jika metode ini selalu mereturn `true` tanpa perbandingan nilai?',
          options: [
            'Canvas tidak akan pernah diperbarui.',
            'Flutter akan me-repaint seluruh canvas pada setiap frame pipeline rendering, berpotensi menyebabkan frame drop (UI jank).',
            'Kompilator akan melempar Exception StackOverflow.',
            'Ukuran canvas akan otomatis berlipat ganda.',
          ],
          correctIndex: 1,
          explanation:
              '`shouldRepaint` memberi sinyal ke render tree apakah paint pipeline perlu dieksekusi ulang. Mengembalikan true secara sembarangan akan memaksa canvas dilukis ulang tanpa henti setiap kali parent me-rebuild.',
          topic: 'CustomPainter Performance',
          difficulty: QuestionDifficulty.intermediate,
        ),
        AssessmentQuestion(
          id: 'q_ui_2',
          question: 'Widget apakah yang digunakan untuk mengisolasi subtree widget yang sering beranimasi (misalnya jarum speedometer atau animasi partikel) agar perubahannya TIDAK menyebabkan widget induk/tetangga di sekitarnya ikut di-paint ulang?',
          options: [
            'ClipRect',
            'RepaintBoundary',
            'Offstage',
            'DecoratedBox',
          ],
          correctIndex: 1,
          explanation:
              '`RepaintBoundary` membuat layer rendering terpisah di RenderObject. Ini mencegah repaint merambat ke atas (parent) atau ke bawah (children), sangat krusial untuk animasi 60/120 FPS yang mulus.',
          topic: 'Rendering Optimization',
          difficulty: QuestionDifficulty.advanced,
        ),
        AssessmentQuestion(
          id: 'q_ui_3',
          question: 'Metode path apa yang digunakan untuk menggambar kurva lengkung mulus (Bezier Curve) yang ditentukan oleh SATU titik kontrol (control point) dan SATU titik akhir (end point)?',
          codeSnippet: '''
final path = Path();
path.moveTo(0, 100);
// Metode kurva lengkung di sini:
path.????????(50, 0, 100, 100);''',
          options: [
            'cubicTo(x1, y1, x2, y2, x3, y3)',
            'quadraticBezierTo(x1, y1, x2, y2)',
            'arcToPoint(targetPoint)',
            'relativeLineTo(dx, dy)',
          ],
          correctIndex: 1,
          explanation:
              '`quadraticBezierTo(controlX, controlY, endX, endY)` menggambar Quadratic Bezier curve dengan 1 titik kontrol. Sedangkan `cubicTo` menggunakan 2 titik kontrol untuk kurva kubik yang lebih fleksibel.',
          topic: 'Canvas Bezier Path',
          difficulty: QuestionDifficulty.intermediate,
        ),
        AssessmentQuestion(
          id: 'q_ui_4',
          question: 'Mengapa sebuah AnimationController di dalam State sebuah StatefulWidget WAJIB selalu di-dispose di dalam metode `dispose()`?',
          options: [
            'Jika tidak, widget tidak akan bisa digambar pertama kali.',
            'Jika tidak di-dispose, TickerProvider internal akan terus aktif di memori dan menyebabkan memory leak serta exception saat hot reload/pop.',
            'Karena Dart tidak memiliki Garbage Collector.',
            'AnimationController otomatis terhapus sehingga dispose tidak wajib.',
          ],
          correctIndex: 1,
          explanation:
              'AnimationController terhubung ke sistem frame scheduling (Ticker). Tidak memanggil controller.dispose() akan membiarkan ticker aktif dan mengakibatkan memory leak serta pesan error "A AnimationController was used after being disposed".',
          topic: 'AnimationController Lifecycle',
          difficulty: QuestionDifficulty.beginner,
        ),
        AssessmentQuestion(
          id: 'q_ui_5',
          question: 'Dalam sistem Material 3 (M3) Theming Flutter, cara terbaik untuk menghasilkan palet warna yang harmonis dan konsisten secara otomatis dari satu warna utama adalah dengan menggunakan:',
          options: [
            'ThemeData(primaryColor: Colors.blue)',
            'ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1))',
            'ThemeData.fallback()',
            'ColorPalette.generateManual()',
          ],
          correctIndex: 1,
          explanation:
              '`ColorScheme.fromSeed` adalah standar Material 3 yang menggunakan algoritma warna algoritmik untuk menurunkan seluruh tonal palette (primary, secondary, surface, outline, container) dari satu warna dasar.',
          topic: 'Material 3 Theming',
          difficulty: QuestionDifficulty.beginner,
        ),
      ],
    ),

    // =========================================================================
    // 4. EVALUASI TRACK 4: PRODUCTION ECOSYSTEM & QA
    // =========================================================================
    AssessmentTrackModel(
      id: 'eval_production',
      trackId: 'track_production',
      title: 'Ujian Evaluasi: Production Ecosystem & QA',
      subtitle: 'Dio Interceptors, Local Storage, Isolates & Automated Testing',
      description:
          'Uji kemampuan dalam membangun aplikasi level production: penanganan token JWT otomatis via interceptor, background isolates, serta unit & widget testing.',
      icon: Icons.rocket_launch_rounded,
      color: Color(0xFF059669),
      passingScore: 70,
      rewardXp: 160,
      timeLimitMinutes: 10,
      questions: [
        AssessmentQuestion(
          id: 'q_prod_1',
          question: 'Dalam Dio HTTP Client, di manakah lokasi yang paling tepat untuk menangani error HTTP 401 Unauthorized guna melakukan penyegaran token JWT (Token Refresh) lalu mengulang (retry) request yang gagal?',
          options: [
            'Di dalam UI widget menggunakan try-catch di onPressed.',
            'Di dalam interceptor pada handler `onError(DioException err, ErrorInterceptorHandler handler)`.',
            'Di dalam model data JSON parsing.',
            'Di dalam file main.dart sebelum runApp.',
          ],
          correctIndex: 1,
          explanation:
              '`QueuedInterceptorsWrapper.onError` memungkinkan kita mencegat respons 401, melakukan request refresh token secara aman tanpa race condition, memperbarui header Authorization, dan memanggil `dio.fetch(err.requestOptions)` untuk retry request awal.',
          topic: 'Dio Interceptors',
          difficulty: QuestionDifficulty.intermediate,
        ),
        AssessmentQuestion(
          id: 'q_prod_2',
          question: 'Ketika aplikasi menerima respons JSON yang sangat masif (ribuan objek kompleks) dari server, mengapa disarankan mem-parsing JSON tersebut menggunakan `compute()` atau Isolate mandiri?',
          options: [
            'Karena JSON parsing di UI thread (Main Isolate) dapat menyebabkan frame drop dan UI membeku (freeze).',
            'Karena JSON tidak bisa dibaca oleh Dart tanpa isolate.',
            'Agar konsumsi baterai perangkat menjadi 0%.',
            'Karena Dio mewajibkan parsing di Isolate.',
          ],
          correctIndex: 0,
          explanation:
              'Dart berjalan pada single-thread event loop. Eksekusi deserialisasi JSON yang memakan waktu ratusan milidetik pada main isolate akan memblokir thread rendering Flutter dan menyebabkan stuttering/jank. `compute()` memindahkan kalkulasi berat ke isolate terpisah.',
          topic: 'Concurrency & Isolates',
          difficulty: QuestionDifficulty.intermediate,
        ),
        AssessmentQuestion(
          id: 'q_prod_3',
          question: 'Dalam Widget Testing Flutter, apa perbedaan mendasar antara `tester.pump()` dan `tester.pumpAndSettle()`?',
          options: [
            '`tester.pump()` menjalankan pengujian tanpa verifikasi expect.',
            '`tester.pump()` hanya memicu 1 frame rendering tunggal, sedangkan `tester.pumpAndSettle()` terus memicu frame berulang kali sampai seluruh animasi dan Future selesai.',
            '`tester.pumpAndSettle()` hanya digunakan untuk Unit Test murni tanpa widget.',
            'Keduanya identik dan tidak ada bedanya.',
          ],
          correctIndex: 1,
          explanation:
              '`pump()` hanya memajukan waktu 1 frame (100ms default jika diberikan durasi). `pumpAndSettle()` memicu frame terus-menerus hingga tidak ada lagi frame yang dijadwalkan (misal semua animasi transisi halaman atau progress indicator telah berhenti).',
          topic: 'Widget Testing',
          difficulty: QuestionDifficulty.intermediate,
        ),
        AssessmentQuestion(
          id: 'q_prod_4',
          question: 'Jika aplikasi membutuhkan basis data lokal relasional yang mendukung query SQL kompleks, relasi antar tabel (JOIN), dan migrasi skema yang type-safe, library apakah yang paling ideal di ekosistem Flutter?',
          options: [
            'SharedPreferences',
            'Drift (sebelumnya Moor) atau sqflite',
            'Flutter Secure Storage',
            'HTTP Client',
          ],
          correctIndex: 1,
          explanation:
              '`Drift` (dan sqflite) dibangun di atas SQLite dengan dukungan SQL relasional, join queries, migration hooks, dan type-safe query generator. SharedPreferences hanya cocok untuk key-value sederhana.',
          topic: 'Local Persistence',
          difficulty: QuestionDifficulty.beginner,
        ),
        AssessmentQuestion(
          id: 'q_prod_5',
          question: 'Dalam unit testing logika bisnis (BLoC / Service), teknik apakah yang digunakan untuk mengganti dependensi eksternal (seperti API client atau Database) dengan implementasi tiruan agar pengujian terisolasi dan cepat?',
          options: [
            'Hot Reloading',
            'Mocking (misal menggunakan library `mocktail` atau `mockito`)',
            'Golden Toolkit',
            'Obfuscation',
          ],
          correctIndex: 1,
          explanation:
              'Mocking memungkinkan kita menyimulasikan respons network (berhasil atau gagal) tanpa melakukan koneksi internet sungguhan, sehingga unit test berjalan deterministik, cepat, dan independen.',
          topic: 'Unit Testing & Mocks',
          difficulty: QuestionDifficulty.beginner,
        ),
      ],
    ),
  ];
}
