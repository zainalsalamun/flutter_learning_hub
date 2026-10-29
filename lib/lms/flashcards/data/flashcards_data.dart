import '../models/flashcard_model.dart';

class FlashcardsData {
  static const List<FlashcardItem> allFlashcards = [
    // =========================================================================
    // 1. ARSITEKTUR & RENDER TREE
    // =========================================================================
    FlashcardItem(
      id: 'fc_arch_three_trees',
      question:
          'Apa perbedaan mendasar antara Widget, Element, dan RenderObject dalam arsitektur rendering Flutter?',
      category: FlashcardCategory.architecture,
      difficulty: FlashcardDifficulty.mid,
      keyConcept:
          'Widget adalah konfigurasi deklaratif immutable, Element adalah jembatan mutable yang mengelola lifecycle, dan RenderObject adalah komputasi layout, paint, dan hit-testing.',
      detailedAnswer:
          '1. Widget Tree: Merupakan blueprint konfigurasi UI yang murah (lightweight) dan bersifat immutable (dibuat ulang setiap frame saat build).\n\n'
          '2. Element Tree: Merupakan representasi live dari Widget. Element memegang state (StatefulElement), mengelola siklus hidup, dan bertindak sebagai penentu apakah RenderObject perlu dibuat baru atau cukup di-update (Widget.canUpdate).\n\n'
          '3. RenderObject Tree: Bertanggung jawab atas komputasi fisik: menghitung constraints & ukuran (layout), menggambar piksel ke layar (paint), dan menangani sentuhan (hit-testing). Objek ini sangat mahal, sehingga Flutter mempertahankannya selama konfigurasi widget cocok.',
      codeSnippet: '''
// Contoh mekanisme reconciliasi di balik layar:
static bool canUpdate(Widget oldWidget, Widget newWidget) {
  return oldWidget.runtimeType == newWidget.runtimeType
      && oldWidget.key == newWidget.key;
}''',
      interviewerTips:
          'Tekankan bahwa Widget murah untuk di-rebuild, sedangkan RenderObject mahal. Jelaskan bahwa Element Tree adalah otak yang menghindari overhead komputasi ulang RenderObject yang tidak perlu.',
      tags: ['Three Trees', 'Widget', 'Element', 'RenderObject', 'Architecture'],
    ),
    FlashcardItem(
      id: 'fc_arch_build_pipeline_owner',
      question:
          'Apa peran BuildOwner dan PipelineOwner dalam frame pipeline Flutter?',
      category: FlashcardCategory.architecture,
      difficulty: FlashcardDifficulty.senior,
      keyConcept:
          'BuildOwner mengorkestrasi pembuatan dan pembaruan Element (dirty elements), sedangkan PipelineOwner mengendalikan layout, compositing, dan painting pada RenderObject.',
      detailedAnswer:
          'Dalam setiap VSYNC frame (16.6ms pada 60Hz):\n'
          '1. BuildOwner: Menampung daftar "dirty elements" yang memanggil markNeedsBuild() (akibat setState, Provider, dll) dan memicu pemanggilan build() secara teratur tanpa loop tak terbatas.\n\n'
          '2. PipelineOwner: Menampung RenderObject yang memanggil markNeedsLayout() atau markNeedsPaint(). PipelineOwner memproses flushLayout(), flushCompositingBits(), flushPaint(), dan mengirimkan Layer Tree ke RenderView untuk diserahkan ke mesin grafis (Impeller/Skia).',
      codeSnippet: '''
// Siklus frame Flutter engine:
// 1. Vsync pulse -> Animate (Ticker)
// 2. BuildOwner.buildScope() (Rebuild dirty elements)
// 3. PipelineOwner.flushLayout() (Ukuran & constraints)
// 4. PipelineOwner.flushCompositingBits()
// 5. PipelineOwner.flushPaint() (Draw commands ke SceneBuilder)
// 6. Window.render(scene) -> GPU Engine''',
      interviewerTips:
          'Interviewer level Senior mencari pemahaman tentang pemisahan fase build (Dart logic) vs fase render (geometry & paint), serta bagaimana frame scheduling mencegah micro-stuttering.',
      tags: ['BuildOwner', 'PipelineOwner', 'Engine', 'Frame Pipeline'],
    ),
    FlashcardItem(
      id: 'fc_arch_impeller_vs_skia',
      question:
          'Mengapa Flutter beralih dari Skia ke Impeller sebagai rendering runtime bawaan?',
      category: FlashcardCategory.architecture,
      difficulty: FlashcardDifficulty.mid,
      keyConcept:
          'Impeller melakukan AOT pre-compilation seluruh shader saat build time, melenyapkan shader compilation jank yang sebelumnya terjadi di Skia runtime.',
      detailedAnswer:
          'Skia mengkompilasi shader secara JIT (Just-In-Time) saat aplikasi pertama kali menemukan efek visual tertentu (bayangan, blur, clipping) di layar pengguna. Kompilasi JIT ini memakan waktu beberapa puluh milidetik yang melebihi batas 16ms, menyebabkan frame drop ("Shader Jank").\n\n'
          'Impeller mengatasi ini dengan:\n'
          '1. Mengompilasi seluruh pipeline shader secara AOT (Ahead-of-Time) saat tahap build aplikasi.\n'
          '2. Arsitektur langsung di atas API grafis modern: Metal di iOS dan Vulkan di Android.\n'
          '3. Seluruh alokasi resource GPU terikat ke batas per-frame, mengurangi memory overhead.',
      interviewerTips:
          'Sebutkan kata kunci "Shader Compilation Jank" dan "AOT Pre-compilation". Ini adalah poin krusial yang menunjukkan Anda mengikuti perkembangan arsitektur Flutter 3+.',
      tags: ['Impeller', 'Skia', 'Rendering Engine', 'GPU', 'Jank'],
    ),

    // =========================================================================
    // 2. DART & ASINKRONUS
    // =========================================================================
    FlashcardItem(
      id: 'fc_dart_event_loop_microtask',
      question:
          'Bagaimana cara kerja Event Loop di Dart dan apa bedanya Event Queue vs Microtask Queue?',
      category: FlashcardCategory.dartConcurrency,
      difficulty: FlashcardDifficulty.junior,
      keyConcept:
          'Dart bersifat single-threaded dengan 2 antrean: Microtask Queue selalu dieksekusi tuntas terlebih dahulu sebelum Event Loop mengambil item dari Event Queue.',
      detailedAnswer:
          'Event Loop Dart berputar terus-menerus memeriksa dua antrean:\n\n'
          '1. Microtask Queue (Prioritas Tertinggi): Digunakan untuk operasi internal cepat yang harus diselesaikan sebelum menyerahkan kontrol kembali ke event lain (contoh: scheduleMicrotask).\n\n'
          '2. Event Queue (Prioritas Normal): Menampung event eksternal seperti I/O, timer (Future.delayed), sentuhan layar user, dan pesan dari Isolate lain.\n\n'
          'Penting: Jika Microtask Queue terus-menerus diisi tanpa henti, Event Queue akan mengalami starvation (aplikasi macet tidak merespons sentuhan).',
      codeSnippet: '''
void testOrder() {
  print('1: Main');
  scheduleMicrotask(() => print('2: Microtask'));
  Future(() => print('3: Event Queue'));
  print('4: Main End');
}
// Output: 1: Main -> 4: Main End -> 2: Microtask -> 3: Event Queue''',
      interviewerTips:
          'Jawablah dengan menulis urutan eksekusi print jika interviewer memberikan tes kode async. Ingat: synchronous code jalan dulu, lalu microtasks, baru events.',
      tags: ['Dart', 'Event Loop', 'Microtask', 'Future', 'Concurrency'],
    ),
    FlashcardItem(
      id: 'fc_dart_isolates_vs_future',
      question:
          'Kapan wajib menggunakan Isolate alih-alih Future (async/await) di Flutter?',
      category: FlashcardCategory.dartConcurrency,
      difficulty: FlashcardDifficulty.mid,
      keyConcept:
          'Future hanya menunda eksekusi pada thread utama, sedangkan Isolate menjalankan komputasi berat pada thread OS terpisah dengan memori terisolasi.',
      detailedAnswer:
          '1. Future (async/await): Tidak membuat thread baru! Future hanya memanfaatkan non-blocking I/O pada single event loop. Jika Anda melakukan komputasi CPU berat (misal parsing JSON 50MB, enkripsi gambar, atau algoritma sorting besar) di dalam Future, UI thread akan tetap freeze (jank).\n\n'
          '2. Isolate: Memiliki memori terpisah (tidak share memory) dan event loop sendiri. Komputasi di Isolate berjalan di thread OS latar belakang tanpa mengganggu rendering 60/120fps UI.\n\n'
          'Gunakan `Isolate.run()` di Flutter modern untuk mengeksekusi komputasi berat dengan praktis.',
      codeSnippet: '''
// Parsing JSON raksasa tanpa memblokir animasi UI:
Future<List<Product>> parseLargePayload(String jsonString) async {
  return await Isolate.run(() {
    final decoded = jsonDecode(jsonString) as List;
    return decoded.map((e) => Product.fromJson(e)).toList();
  });
}''',
      interviewerTips:
          'Jelaskan bahwa Isolate tidak berbagi memori (memory isolated), komunikasi antar-isolate terjadi melalui message passing (Port), dan sebutkan helper Isolate.run().',
      tags: ['Isolate', 'Future', 'Multi-threading', 'Performance'],
    ),

    // =========================================================================
    // 3. STATE MANAGEMENT & REBUILDS
    // =========================================================================
    FlashcardItem(
      id: 'fc_state_inherited_widget_internals',
      question:
          'Bagaimana cara kerja InheritedWidget dan metode updateShouldNotify()?',
      category: FlashcardCategory.stateManagement,
      difficulty: FlashcardDifficulty.mid,
      keyConcept:
          'InheritedWidget memungkinkan data mengalir ke bawah pohon widget dengan O(1) look-up, dan hanya merebuild widget yang terdaftar via dependOnInheritedWidgetOfExactType.',
      detailedAnswer:
          'InheritedWidget adalah fondasi dari hampir semua state management di Flutter (Provider, Theme, MediaQuery, Navigator).\n\n'
          '1. O(1) Lookup: Setiap Element menyimpan peta hash (Map) dari semua InheritedElement leluhurnya, sehingga pencarian ke atas tidak perlu menelusuri parent secara rekursif (O(1) bukan O(N)).\n\n'
          '2. updateShouldNotify(covariant InheritedWidget oldWidget): Mengembalikan boolean. Jika true, semua Element turunan yang memanggil dependOnInheritedWidgetOfExactType() akan otomatis dipanggil didChangeDependencies() dan di-rebuild.',
      codeSnippet: '''
class CartScope extends InheritedWidget {
  final int itemCount;
  const CartScope({super.key, required this.itemCount, required super.child});

  static CartScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CartScope>();
  }

  @override
  bool updateShouldNotify(CartScope oldWidget) {
    return oldWidget.itemCount != itemCount;
  }
}''',
      interviewerTips:
          'Beri tahu pewawancara perbedaan context.dependOnInheritedWidgetOfExactType (mendaftarkan dependency dan rebuild) vs context.getInheritedWidgetOfExactType (hanya membaca tanpa rebuild).',
      tags: ['InheritedWidget', 'State', 'BuildContext', 'Rebuild Optimization'],
    ),
    FlashcardItem(
      id: 'fc_state_bloc_vs_riverpod_tradeoffs',
      question:
          'Bandingkan kelebihan dan kekurangan arsitektur BLoC vs Riverpod 2.x untuk aplikasi skala enterprise.',
      category: FlashcardCategory.stateManagement,
      difficulty: FlashcardDifficulty.senior,
      keyConcept:
          'BLoC menawarkan alur event-state unidirectional yang sangat ketat dan mudah diaudit, sedangkan Riverpod menawarkan compile-time safety tanpa keterikatan BuildContext serta kemudahan async caching.',
      detailedAnswer:
          '1. Flutter BLoC (Business Logic Component):\n'
          '  • Kelebihan: Sangat terstruktur, memisahkan Event (input) dan State (output), pelacakan state stream transparan dengan BlocObserver, sangat cocok untuk tim besar dengan kepatuhan audit tinggi.\n'
          '  • Kekurangan: Lebih banyak boilerplate class (Event, State, Bloc), membutuhkan BuildContext untuk read/watch.\n\n'
          '2. Riverpod 2.x:\n'
          '  • Kelebihan: Compile-time safety (tidak ada ProviderNotFoundException), tidak terikat BuildContext, auto-dispose, caching async canggih dengan AsyncNotifier/family providers.\n'
          '  • Kekurangan: Memerlukan WidgetRef atau ConsumerWidget, kurva pembelajaran pemahaman provider modifiers.',
      interviewerTips:
          'Hindari jawaban fanatik "satu library selalu lebih baik". Senior engineer selalu mengevaluasi berdasarkan ukuran tim, kompleksitas domain, kemudahan unit testing, dan standar maintainability.',
      tags: ['BLoC', 'Riverpod', 'Architecture', 'Trade-offs', 'Senior'],
    ),

    // =========================================================================
    // 4. PERFORMA, MEMORI & PROFILING
    // =========================================================================
    FlashcardItem(
      id: 'fc_perf_const_constructors',
      question:
          'Mengapa penggunaan "const" constructor sangat krusial untuk performa Flutter?',
      category: FlashcardCategory.performance,
      difficulty: FlashcardDifficulty.junior,
      keyConcept:
          'Const widget di-instansiasi sekali saat compile-time dan di-reuse di memori kanonik, sehingga Flutter langsung melewati (short-circuit) proses rebuild sub-tree tersebut.',
      detailedAnswer:
          'Saat build() dipanggil pada parent widget:\n'
          '1. Tanpa const: Setiap widget anak akan dialokasikan sebagai instance objek baru di memori heap, memicu Element untuk membandingkan widget baru vs lama.\n\n'
          '2. Dengan const: Objek sudah dibuat saat kompilasi (canonicalized instance). Element membandingkan identitas pointer (identical(oldWidget, newWidget)) bernilai true. Flutter langsung melompati rekursi build pada rantai widget tersebut, menghemat garbage collector dan siklus CPU.',
      codeSnippet: '''
// ✅ Flutter short-circuit subtree ini:
const ComplexCard(
  title: 'Statistik Belajar',
  padding: EdgeInsets.all(16),
);''',
      interviewerTips:
          'Jelaskan konsep "canonical instance" di Dart dan fakta bahwa const widget meringankan kerja Garbage Collector (GC) dari alokasi memori berulang.',
      tags: ['Performance', 'Const', 'Memory', 'Garbage Collector'],
    ),
    FlashcardItem(
      id: 'fc_perf_repaint_boundary',
      question:
          'Kapan dan bagaimana cara menggunakan RepaintBoundary untuk mengoptimalkan FPS?',
      category: FlashcardCategory.performance,
      difficulty: FlashcardDifficulty.mid,
      keyConcept:
          'RepaintBoundary membuat RenderLayer terpisah di GPU sehingga animasi lokal tidak memaksa seluruh layar di-paint ulang.',
      detailedAnswer:
          'Secara default, jika sebuah widget di-paint ulang (misal widget jam berdetik atau animasi loading kecil), RenderObject leluhurnya dan saudara-saudaranya di layer yang sama bisa ikut di-paint ulang (Repaint cascade).\n\n'
          'RepaintBoundary memutus rantai ini:\n'
          '1. Membuat RenderRepaintBoundary yang memiliki Layer tersendiri.\n'
          '2. Mengisolasi dirty paint area sehingga hanya widget di dalam boundary yang dipanggil paint().\n'
          '3. Cocok untuk: CustomPainter yang kompleks, barcode scanner, animasi berulang di dalam item ListView.',
      codeSnippet: '''
// Mengisolasi canvas chart yang berat agar tidak repaint saat scroll:
RepaintBoundary(
  child: CustomPaint(
    painter: ComplexCandlestickChartPainter(),
  ),
);''',
      interviewerTips:
          'Sebutkan alat Flutter DevTools: "Highlight Repaints" untuk melihat visualisasi warna kotak repaint cascade di layar secara nyata.',
      tags: ['RepaintBoundary', 'Canvas', 'DevTools', 'FPS Optimization'],
    ),
    FlashcardItem(
      id: 'fc_perf_detect_memory_leaks',
      question:
          'Bagaimana cara mendeteksi dan menyelesaikan Memory Leaks pada aplikasi Flutter?',
      category: FlashcardCategory.performance,
      difficulty: FlashcardDifficulty.senior,
      keyConcept:
          'Memory leak terjadi saat objek yang sudah tidak dipakai (State/Controller) masih di-retain oleh listener atau closure aktif; diagnosis dilakukan via DevTools Memory Tab.',
      detailedAnswer:
          'Penyebab paling umum:\n'
          '1. Lupa memanggil dispose() pada AnimationController, TextEditingController, StreamSubscription, atau ScrollController.\n'
          '2. Menambahkan listener ke global singleton ChangeNotifier tanpa pernah me-remove listener saat widget di-unmount.\n'
          '3. Closure callback yang menangkap BuildContext/State lama.\n\n'
          'Cara mendeteksi via Flutter DevTools Memory:\n'
          '• Ambil Memory Snapshot sebelum dan sesudah membuka-tutup halaman 5 kali.\n'
          '• Cari class State yang jumlah instance-nya terus bertambah (retained count > 0) padahal halaman sudah di-pop.',
      interviewerTips:
          'Tekankan disiplin selalu menggunakan method dispose() dan jelaskan alur pemeriksaan heap snapshot via DevTools Memory Profile.',
      tags: ['Memory Leak', 'DevTools', 'Dispose', 'Profiling', 'Senior'],
    ),

    // =========================================================================
    // 5. PLATFORM CHANNEL & NATIVE INTEROP
    // =========================================================================
    FlashcardItem(
      id: 'fc_native_method_channel_types',
      question:
          'Jelaskan perbedaan antara MethodChannel, EventChannel, dan BasicMessageChannel.',
      category: FlashcardCategory.platformNative,
      difficulty: FlashcardDifficulty.mid,
      keyConcept:
          'MethodChannel untuk pemanggilan request-response sekali jalan, EventChannel untuk streaming event berkelanjutan dari native, dan BasicMessageChannel untuk pertukaran pesan semi-kustom.',
      detailedAnswer:
          '1. MethodChannel: Pola RPC (Remote Procedure Call) asinkronus dua arah untuk aksi satu kali (misal: cek level baterai, buka kamera native, ambil lokasi GPS saat ini).\n\n'
          '2. EventChannel: Digunakan untuk streaming data kontinu dari platform native ke Flutter (misal: sensor akselerometer 60Hz, event koneksi bluetooth, stream status jaringan).\n\n'
          '3. BasicMessageChannel: Digunakan untuk pengiriman pesan string atau binary kustom dengan encoder yang dapat dikonfigurasi.',
      codeSnippet: '''
// Contoh EventChannel untuk sensor native:
static const eventChannel = EventChannel('com.naltech.sensor/gyroscope');

Stream<SensorData> get sensorStream {
  return eventChannel.receiveBroadcastStream().map((data) => SensorData.fromMap(data));
}''',
      interviewerTips:
          'Sebutkan bahwa komunikasi platform channel melewati asynchronous message passing yang melibatkan serialisasi JSON/StandardMessageCodec, sehingga ada overhead latency mikro.',
      tags: ['MethodChannel', 'EventChannel', 'Platform Channel', 'Android', 'iOS'],
    ),
    FlashcardItem(
      id: 'fc_native_pigeon_and_ffi',
      question:
          'Apa keunggulan tool Pigeon dan Dart FFI dibanding standard MethodChannel untuk integrasi native?',
      category: FlashcardCategory.platformNative,
      difficulty: FlashcardDifficulty.senior,
      keyConcept:
          'Pigeon memberikan type-safe code generation tanpa stringly-typed bugs, sementara Dart FFI mengeksekusi C/C++/Rust library secara synchronous tanpa overhead channel.',
      detailedAnswer:
          '1. Kelemahan standard MethodChannel:\n'
          '  • Menggunakan nama string untuk method ("getBatteryLevel"). Rentan typo dan tidak ada peringatan saat kompilasi jika native signature berubah.\n\n'
          '2. Solusi Pigeon:\n'
          '  • Tool code-generation dari tim Flutter yang mengubah file antarmuka Dart menjadi kode Kotlin/Swift/Dart yang 100% type-safe saat compile time.\n\n'
          '3. Dart FFI (Foreign Function Interface):\n'
          '  • Berkomunikasi langsung ke C/C++/Rust dynamic libraries (.so / .dylib) tanpa melibatkan Java/Kotlin/Swift bridge.\n'
          '  • Eksekusi synchronous berkecepatan native murni (cocok untuk library kriptografi, audio processing, machine learning TensorFlow Lite).',
      interviewerTips:
          'Pigeon dan Dart FFI adalah topik pembeda utama antara Flutter engineer junior vs senior yang berpengalaman dalam arsitektur platform.',
      tags: ['Pigeon', 'Dart FFI', 'Native Interop', 'C++', 'Type Safety'],
    ),

    // =========================================================================
    // 6. GOTCHAS & ANTI-PATTERNS
    // =========================================================================
    FlashcardItem(
      id: 'fc_gotcha_async_gap_context',
      question:
          'Apa bahaya menggunakan BuildContext setelah "await" (Asynchronous Gap) dan bagaimana solusinya?',
      category: FlashcardCategory.interviewGotchas,
      difficulty: FlashcardDifficulty.junior,
      keyConcept:
          'Widget bisa saja sudah di-unmount dari tree saat operasi async selesai, sehingga pemanggilan Navigator/Theme lewat context usang akan melempar error atau memory leak.',
      detailedAnswer:
          'Ketika memanggil `await someApiCall()`:\n'
          'Pengguna bisa saja menekan tombol back atau pindah halaman saat request jaringan masih berlangsung. Ketika await selesai, BuildContext yang lama bisa dalam keadaan "unmounted" atau tidak valid lagi.\n\n'
          'Solusi Standar:\n'
          '1. Selalu periksa `if (!context.mounted) return;` (di Flutter 3.7+) sebelum menggunakan context setelah await.\n'
          '2. Di dalam State object, gunakan `if (!mounted) return;`.',
      codeSnippet: '''
Future<void> submitOrder(BuildContext context) async {
  await checkoutService.pay();

  // ❌ SALAH: context bisa unmounted!
  // Navigator.pop(context);

  //  BENAR & AMAN:
  if (!context.mounted) return;
  Navigator.pushNamed(context, '/success');
}''',
      interviewerTips:
          'Sebutkan linter rule "use_build_context_synchronously" dan jelaskan context.mounted vs State.mounted.',
      tags: ['BuildContext', 'Async Gap', 'Mounted', 'Gotcha', 'Linter'],
    ),
    FlashcardItem(
      id: 'fc_gotcha_flutter_keys_usage',
      question:
          'Kapan penggunaan Key (ValueKey, ObjectKey, UniqueKey, GlobalKey) wajib dilakukan di Flutter?',
      category: FlashcardCategory.interviewGotchas,
      difficulty: FlashcardDifficulty.mid,
      keyConcept:
          'Key wajib digunakan ketika memodifikasi koleksi widget stateful bertipe sama (reordering, filtering, removing) agar Flutter mencocokkan Element ke Widget yang benar.',
      detailedAnswer:
          'Flutter membandingkan runtimeType dan Key untuk menentukan apakah Element yang ada bisa dipertahankan:\n\n'
          '1. Tanpa Key: Jika Anda menghapus item pertama di dalam ListView stateful, Flutter akan mencocokkan widget baru ke Element lama berdasarkan urutan indeks, sehingga state item lama tertinggal di posisi baru (Bug state swap)!\n\n'
          '2. ValueKey: Berdasarkan nilai unik (ID database, string unik).\n'
          '3. UniqueKey: Menghasilkan key unik setiap instansiasi, memaksa element dibuat ulang.\n'
          '4. GlobalKey: Mempertahankan state saat widget berpindah parent di widget tree, atau untuk mengakses State eksternal (contoh FormState.validate).',
      codeSnippet: '''
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    // ValueKey memastikan state checklist terikat ke ID item, bukan ke indeks!
    return TodoTile(key: ValueKey(items[index].id), item: items[index]);
  },
);''',
      interviewerTips:
          'Gambarkan analogi barisan siswa bertopi: jika siswa berganti tempat tanpa nomor punggung (Key), guru mengira siswa tetap sama karena topinya (runtimeType) identik.',
      tags: ['Keys', 'ValueKey', 'GlobalKey', 'Widget Reordering'],
    ),
    FlashcardItem(
      id: 'fc_gotcha_layout_constraints_rule',
      question:
          'Jelaskan kaidah emas layout Flutter: "Constraints go down, Sizes go up, Parents set positions".',
      category: FlashcardCategory.interviewGotchas,
      difficulty: FlashcardDifficulty.junior,
      keyConcept:
          'Parent mengirimkan batasan ukuran (min/max) ke child, child menentukan ukuran konkretnya sendiri, dan parent menentukan koordinat posisi child.',
      detailedAnswer:
          'Tiga aturan mutlak sistem layout Flutter:\n'
          '1. Constraints go down: Widget induk memberikan BoxConstraints (minWidth, maxWidth, minHeight, maxHeight) kepada widget anak.\n\n'
          '2. Sizes go up: Widget anak memutuskan ukurannya sendiri (Size) berdasarkan constraint yang diizinkan induknya, lalu melaporkan ukuran tersebut kembali ke induk.\n\n'
          '3. Parent sets position: Widget anak tidak pernah bisa menentukan posisinya sendiri di layar. Hanya widget induk yang menentukan koordinat Offset(x, y) di mana anak diletakkan.',
      interviewerTips:
          'Hafalkan slogan 3 kalimat ini karena sering ditanyakan oleh interviewer untuk menguji apakah Anda benar-benar paham akar dari error RenderFlex overflow.',
      tags: ['Layout', 'Constraints', 'BoxConstraints', 'RenderBox'],
    ),
  ];

  static List<FlashcardItem> getByCategory(FlashcardCategory category) {
    return allFlashcards.where((fc) => fc.category == category).toList();
  }

  static FlashcardItem? getById(String id) {
    try {
      return allFlashcards.firstWhere((fc) => fc.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Curates a daily 5-minute study deck prioritizing unmastered cards
  static List<FlashcardItem> getDailyStudyDeck(Set<String> masteredIds, {int count = 6}) {
    final unmastered =
        allFlashcards.where((fc) => !masteredIds.contains(fc.id)).toList();
    final mastered =
        allFlashcards.where((fc) => masteredIds.contains(fc.id)).toList();

    unmastered.shuffle();
    mastered.shuffle();

    final result = [...unmastered, ...mastered].take(count).toList();
    return result;
  }
}
