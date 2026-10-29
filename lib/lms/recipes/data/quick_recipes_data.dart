import '../models/quick_recipe_model.dart';

class QuickRecipesData {
  static const List<QuickRecipe> allRecipes = [
    // =========================================================================
    // 1. DART 3 PATTERNS & RECORDS
    // =========================================================================
    QuickRecipe(
      id: 'recipe_dart3_sealed_results',
      title: 'Sealed Class Network Result & Exhaustive Switch',
      category: RecipeCategory.dart3Patterns,
      description:
          'Pola arsitektur standar industri Dart 3 untuk memodelkan state API (Success, Error, Loading) dengan jaminan exhaustive pattern matching saat kompilasi tanpa perlu fallback default.',
      codeSnippet: '''
// 1. Definisi hirarki sealed class
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final String message;
  final int? statusCode;
  const Failure(this.message, [this.statusCode]);
}

final class Loading<T> extends Result<T> {
  const Loading();
}

// 2. Exhaustive pattern matching dengan Switch Expression
Widget renderUI(Result<User> state) {
  return switch (state) {
    Loading() => const CircularProgressIndicator.adaptive(),
    Success(:final data) => UserProfileView(user: data),
    Failure(:final message, :final statusCode) => ErrorBanner(
        message: '[\$statusCode] \$message',
      ),
  }; // Kompiler akan melempar compile-error jika ada case terlewat!
}''',
      keyPoints: [
        'Sealed class mengunci inheritance hanya dalam library/file yang sama.',
        'Switch expression menjamin compiler memeriksa kelengkapan cabang (exhaustiveness checking).',
        'Sintaks destructuring ":final data" mengekstrak properti objek secara instan.',
      ],
      tags: ['Dart 3', 'Sealed Class', 'Pattern Matching', 'Architecture'],
      sandboxPresetId: 'oop_immutable',
      bestPracticeNote:
          'Hindari menambahkan case _ (wildcard/default) pada sealed class agar Anda selalu diingatkan kompiler saat menambahkan state baru.',
    ),
    QuickRecipe(
      id: 'recipe_dart3_record_destructuring',
      title: 'Record Types & Multiple Return Values',
      category: RecipeCategory.dart3Patterns,
      description:
          'Mengembalikan multiple value dari fungsi tanpa perlu membuat DTO/Class wrapper sementara, lengkap dengan positional dan named field destructuring.',
      codeSnippet: '''
// Mengembalikan positional + named fields dalam satu Record
({double latitude, double longitude, String city, bool isCached}) getCoordinates() {
  return (
    latitude: -6.2088,
    longitude: 106.8456,
    city: 'Jakarta',
    isCached: true,
  );
}

// 1. Destructuring langsung pada variabel penampung
void loadMap() {
  final (:latitude, :longitude, :city) = getCoordinates();
  print('Lokasi: \$city (\$latitude, \$longitude)');
}

// 2. Multi-return tuple positional untuk parsing cepat
(int min, int max, double avg) calculateStats(List<int> numbers) {
  if (numbers.isEmpty) return (0, 0, 0.0);
  final min = numbers.reduce((a, b) => a < b ? a : b);
  final max = numbers.reduce((a, b) => a > b ? a : b);
  final avg = numbers.reduce((a, b) => a + b) / numbers.length;
  return (min, max, avg);
}

void printReport() {
  final (minVal, maxVal, avgVal) = calculateStats([12, 45, 68, 80, 23]);
  print('Min: \$minVal, Max: \$maxVal, Rata-rata: \$avgVal');
}''',
      keyPoints: [
        'Record bersifat immutable, type-safe, dan memiliki kesetaraan nilai struktural bawaan (value equality).',
        'Menghemat pembuatan class DTO sementara yang hanya digunakan sekali pada satu method.',
        'Sangat optimal untuk operasi kalkulasi dan validasi multi-parameter.',
      ],
      tags: ['Dart 3', 'Records', 'Tuples', 'Destructuring'],
      sandboxPresetId: 'oop_immutable',
      bestPracticeNote:
          'Gunakan named record fields untuk fungsi yang mengembalikan lebih dari 2 nilai agar pembacaan kode tetap intuitif.',
    ),

    // =========================================================================
    // 2. DIO HTTP & INTERCEPTORS
    // =========================================================================
    QuickRecipe(
      id: 'recipe_dio_jwt_auth_interceptor',
      title: 'Dio Auth Interceptor dengan Token Refresh Otomatis & Queue',
      category: RecipeCategory.dioHttp,
      description:
          'Implementasi Interceptor Dio tingkat produksi yang menyisipkan Bearer JWT Token pada setiap request, menangkap response 401 Unauthorized, memperbarui refresh token, dan melakukan replay request yang gagal secara transparan.',
      codeSnippet: '''
import 'package:dio/dio.dart';

class AuthInterceptor extends QueuedInterceptor {
  final Dio dio;
  final SecureTokenStorage tokenStorage;

  AuthInterceptor({required this.dio, required this.tokenStorage});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer \$token';
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Tangani HTTP 401 Unauthorized
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await tokenStorage.getRefreshToken();
        if (refreshToken == null) {
          return handler.next(err);
        }

        // Request refresh token baru menggunakan client Dio terpisah
        final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));
        final response = await refreshDio.post(
          '/api/v1/auth/refresh',
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = response.data['accessToken'] as String;
        await tokenStorage.saveAccessToken(newAccessToken);

        // Update header authorization pada request yang sempat gagal
        final retryOptions = err.requestOptions;
        retryOptions.headers['Authorization'] = 'Bearer \$newAccessToken';

        // Replay request original
        final originResponse = await dio.fetch(retryOptions);
        return handler.resolve(originResponse);
      } catch (refreshErr) {
        // Refresh token kedaluwarsa -> paksa logout user
        await tokenStorage.clearAll();
        return handler.next(err);
      }
    }

    return handler.next(err);
  }
}''',
      keyPoints: [
        'Gunakan QueuedInterceptor agar request concurrent lainnya antre saat refresh token sedang berlangsung.',
        'Gunakan instance Dio terpisah saat memanggil endpoint refresh token untuk mencegah infinite loop interceptor.',
        'handler.resolve() menyelesaikan request lama tanpa melempar exception ke sisi caller UI.',
      ],
      tags: ['Dio', 'HTTP', 'JWT', 'Interceptor', 'Network'],
      bestPracticeNote:
          'Selalu terapkan batas timeout (connectTimeout & receiveTimeout) minimal 10-15 detik di BaseOptions Dio Anda.',
    ),

    // =========================================================================
    // 3. JSON SERIALIZATION & PARSING
    // =========================================================================
    QuickRecipe(
      id: 'recipe_json_safe_parsing',
      title: 'Bulletproof Null-Safe JSON Deserialization',
      category: RecipeCategory.jsonSerialization,
      description:
          'Teknik parsing JSON manual yang aman dari TypeError, menangani tipe data inkonsisten dari backend (misal integer dikirim string, null list, format tanggal dinamis).',
      codeSnippet: '''
class ProductDto {
  final String id;
  final String title;
  final double price;
  final List<String> tags;
  final DateTime createdAt;
  final bool isAvailable;

  const ProductDto({
    required this.id,
    required this.title,
    required this.price,
    required this.tags,
    required this.createdAt,
    required this.isAvailable,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    // 1. Parsing double aman (bisa menerima num, String, atau null)
    final rawPrice = json['price'];
    final parsedPrice = switch (rawPrice) {
      num n => n.toDouble(),
      String s => double.tryParse(s) ?? 0.0,
      _ => 0.0,
    };

    // 2. Parsing List aman dari null & tipe dynamic
    final rawTags = json['tags'];
    final parsedTags = rawTags is List
        ? rawTags.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList()
        : <String>[];

    // 3. Parsing DateTime aman dengan fallback DateTime.now()
    final rawDate = json['created_at']?.toString();
    final parsedDate = rawDate != null
        ? DateTime.tryParse(rawDate) ?? DateTime.now()
        : DateTime.now();

    return ProductDto(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? 'Tanpa Nama',
      price: parsedPrice,
      tags: parsedTags,
      createdAt: parsedDate,
      isAvailable: json['is_available'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'tags': tags,
    'created_at': createdAt.toIso8601String(),
    'is_available': isAvailable,
  };
}''',
      keyPoints: [
        'Jangan pernah gunakan cast keras "(json[\'price\'] as double)" karena backend rentan mengirim integer 10 alih-alih 10.0.',
        'Konversi aman list menggunakan .where() dan fallback list kosong mencegah List<dynamic> cast error.',
        'DateTime.tryParse() mencegah format timestamp invalid melempar unhandled FormatException.',
      ],
      tags: ['JSON', 'Parsing', 'Null Safety', 'DTO', 'Clean Code'],
      bestPracticeNote:
          'Untuk project berskala menengah ke atas, gunakan "freezed" bersama "json_serializable" untuk menghemat boilerplate.',
    ),

    // =========================================================================
    // 4. ASYNC, STREAM & DEBOUNCE
    // =========================================================================
    QuickRecipe(
      id: 'recipe_async_search_debouncer',
      title: 'Debounce Search Input & Stream Cancellation',
      category: RecipeCategory.asyncEventLoop,
      description:
          'Mencegah spam API search saat pengguna mengetik dengan timer debounce 300-500ms dan membatalkan network request sebelumnya yang masih pending agar tidak terjadi race condition.',
      codeSnippet: '''
import 'dart:async';

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 400)});

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

// Penerapan pada StatefulWidget Flutter
class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onSearch;
  const SearchBarWidget({super.key, required this.onSearch});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 350));
  final _controller = TextEditingController();

  void _onQueryChanged(String query) {
    _debouncer.run(() {
      if (mounted) {
        widget.onSearch(query.trim());
      }
    });
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onQueryChanged,
      decoration: const InputDecoration(
        hintText: 'Cari data...',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}''',
      keyPoints: [
        'Setiap keystroke baru mereset timer lama, hanya mengeksekusi request saat pengguna berhenti mengetik.',
        'Mereduksi beban traffic server backend hingga 80-90% pada fitur autocomplete.',
        'Selalu periksa "if (mounted)" sebelum memicu callback UI dari dalam timer asinkron.',
      ],
      tags: ['Async', 'Stream', 'Debounce', 'Timer', 'Performance'],
      sandboxPresetId: 'async_stream',
      bestPracticeNote:
          'Jangan lupa memanggil debouncer.dispose() di lifecycle dispose() widget untuk mencegah memory leak.',
    ),

    // =========================================================================
    // 5. STATE MANAGEMENT (RIVERPOD / BLOC)
    // =========================================================================
    QuickRecipe(
      id: 'recipe_riverpod_async_notifier',
      title: 'Riverpod 2.x AsyncNotifier Pattern (Clean Architecture)',
      category: RecipeCategory.stateManagement,
      description:
          'Pola state management Riverpod 2 modern menggunakan AsyncNotifier untuk menangani lifecycle data async (Loading, Error, Data, Refreshing, Optimistic Updates) secara type-safe.',
      codeSnippet: '''
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Notifier mengelola state AsyncValue<List<Course>>
class CourseListNotifier extends AsyncNotifier<List<Course>> {
  @override
  FutureOr<List<Course>> build() async {
    // Load initial data
    return _fetchCoursesFromApi();
  }

  Future<List<Course>> _fetchCoursesFromApi() async {
    final repository = ref.read(courseRepositoryProvider);
    return repository.getAllCourses();
  }

  // Mutasi: Refresh data manual
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchCoursesFromApi());
  }

  // Mutasi: Tambah item baru
  Future<void> addCourse(Course newCourse) async {
    state = await AsyncValue.guard(() async {
      final repository = ref.read(courseRepositoryProvider);
      await repository.createCourse(newCourse);
      final currentList = state.value ?? [];
      return [...currentList, newCourse];
    });
  }
}

// 2. Provider declaration
final courseListProvider =
    AsyncNotifierProvider<CourseListNotifier, List<Course>>(
  CourseListNotifier.new,
);

// 3. UI Consumer
class CourseListView extends ConsumerWidget {
  const CourseListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCourses = ref.watch(courseListProvider);

    return asyncCourses.when(
      data: (courses) => ListView.builder(
        itemCount: courses.length,
        itemBuilder: (_, i) => ListTile(title: Text(courses[i].name)),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: ElevatedButton(
          onPressed: () => ref.read(courseListProvider.notifier).refresh(),
          child: Text('Gagal memuat: \$err. Coba lagi'),
        ),
      ),
    );
  }
}''',
      keyPoints: [
        'AsyncValue.guard() secara otomatis menangkap exception dan mengubah state menjadi AsyncError tanpa try-catch berulang.',
        'asyncCourses.when() memaksa pengembang menangani seluruh state UI (data, loading, error).',
        'ref.read(provider.notifier) digunakan untuk memanggil method aksi/mutasi tanpa memicu rebuild.',
      ],
      tags: ['Riverpod', 'State Management', 'AsyncNotifier', 'Architecture'],
      sandboxPresetId: 'state_lifecycle',
      bestPracticeNote:
          'Gunakan autoDispose jika provider hanya dibutuhkan pada halaman tertentu dan datanya ingin di-cache ulang saat user meninggalkan halaman.',
    ),
    QuickRecipe(
      id: 'recipe_valuenotifier_micro_state',
      title: 'Lightweight Micro-State dengan ValueNotifier & ValueListenableBuilder',
      category: RecipeCategory.stateManagement,
      description:
          'Mengelola state lokal yang sering berubah (counter, toggle password, progress bar) secara efisien tanpa rebuild seluruh widget tree dan tanpa dependency external pihak ketiga.',
      codeSnippet: '''
class PasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  const PasswordInputField({super.key, required this.controller});

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  // Micro-state lokal untuk visibility password
  final ValueNotifier<bool> _isObscured = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _isObscured.dispose(); // Wajib di-dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hanya ValueListenableBuilder yang rebuild saat _isObscured berubah!
    // TextFormField dan parent Container tetap diam tidak re-render.
    return ValueListenableBuilder<bool>(
      valueListenable: _isObscured,
      builder: (context, isObscured, child) {
        return TextField(
          controller: widget.controller,
          obscureText: isObscured,
          decoration: InputDecoration(
            labelText: 'Kata Sandi',
            suffixIcon: IconButton(
              icon: Icon(
                isObscured ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () => _isObscured.value = !_isObscured.value,
            ),
          ),
        );
      },
    );
  }
}''',
      keyPoints: [
        'Performa 60-120fps maksimal karena membatasi scope rebuild hanya pada child spesifik.',
        'Solusi ideal untuk input form, toggle ekspansi card, audio playback slider, dan timer stopwatch.',
        'Zero 3rd party dependency — merupakan komponen bawaan dari Flutter Foundation.',
      ],
      tags: ['ValueNotifier', 'Performance', 'Micro State', 'No Dependency'],
      sandboxPresetId: 'state_lifecycle',
      bestPracticeNote:
          'Gunakan parameter "child" di builder untuk widget berat yang statis agar tidak ikut dirender ulang.',
    ),

    // =========================================================================
    // 6. RENDERFLEX & CONSTRAINTS FIXES
    // =========================================================================
    QuickRecipe(
      id: 'recipe_renderflex_overflow_row_fix',
      title: 'Solusi Definitif RenderFlex Overflow pada Row & Badges',
      category: RecipeCategory.layoutConstraints,
      description:
          'Memperbaiki assertion error "A RenderFlex overflowed by X pixels on the right" saat teks judul berdampingan dengan badge atau tombol aksi di dalam Row.',
      codeSnippet: '''
// ❌ KODE BERMASALAH (Penyebab RenderFlex Overflow):
// Row(
//   children: [
//     Text(longTitle), // Teks panjang meminta lebar tak terbatas!
//     ActionBadge(),
//   ],
// )

//  SOLUSI BENAR & REKOMENDASI PRODUKSI:
Widget buildProductHeader({
  required String longTitle,
  required String statusBadgeText,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // 1. Bungkus teks fleksibel dengan Expanded
      Expanded(
        child: Text(
          longTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          maxLines: 1, // Batasi jumlah baris
          overflow: TextOverflow.ellipsis, // Tampilkan titik tiga (...) jika terlalu panjang
        ),
      ),
      const SizedBox(width: 8),
      // 2. Widget dengan ukuran intrinsik pasti tetap utuh
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.green.shade300),
        ),
        child: Text(
          statusBadgeText,
          style: TextStyle(color: Colors.green.shade800, fontSize: 12),
        ),
      ),
    ],
  );
}''',
      keyPoints: [
        'Row memberikan tight vertical constraint dan unconstrained horizontal width kepada anak-anaknya.',
        'Text widget secara default tidak membatasi dirinya sendiri dan meminta lebar selebar kalimatnya.',
        'Expanded memaksa Text widget mengikuti lebar sisa yang tersedia pada Row.',
      ],
      tags: ['RenderFlex', 'Overflow', 'Row', 'Expanded', 'Layout Constraints'],
      sandboxPresetId: 'flex_alignment',
      bestPracticeNote:
          'Gunakan Flexible(fit: FlexFit.loose) jika Anda ingin teks membungkus sesuai panjang aslinya selama belum melebihi sisa ruang layar.',
    ),
    QuickRecipe(
      id: 'recipe_unbounded_height_column_listview_fix',
      title: 'Fix "Vertical viewport was given unbounded height"',
      category: RecipeCategory.layoutConstraints,
      description:
          'Menghilangkan error saat meletakkan ListView atau GridView di dalam Column, dengan perbandingan solusi shrinkWrap vs Expanded vs CustomScrollView.',
      codeSnippet: '''
// Kasus: Ada Header statis, lalu daftar list scrollable di bawahnya.

//  SOLUSI A: Expanded (Jika seluruh layar tidak perlu scroll bersama header)
Widget buildExpandedSolution() {
  return Column(
    children: [
      const CustomHeaderCard(),
      Expanded(
        child: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, i) => ListTile(title: Text('Item \$i')),
        ),
      ),
    ],
  );
}

//  SOLUSI B: CustomScrollView + Slivers (Performa Tinggi & Scroll Satu Kesatuan)
Widget buildSliverSolution() {
  return CustomScrollView(
    slivers: [
      const SliverToBoxAdapter(
        child: CustomHeaderCard(),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => ListTile(title: Text('Item \$i')),
          childCount: 100,
        ),
      ),
    ],
  );
}

// ⚠️ SOLUSI C: shrinkWrap: true (Hanya untuk list kecil < 10 item, JANGAN untuk list panjang!)
Widget buildSmallListSolution() {
  return SingleChildScrollView(
    child: Column(
      children: [
        const CustomHeaderCard(),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, i) => ListTile(title: Text('Item \$i')),
        ),
      ],
    ),
  );
}''',
      keyPoints: [
        'Column memberikan unbounded height (infinity), sedangkan ListView membutuhkan bounded height untuk scrolling viewport.',
        'Expanded mengikat tinggi ListView ke sisa tinggi layar perangkat.',
        'CustomScrollView + Slivers adalah pendekatan terbaik standar Flutter untuk performa tinggi dan animasi sticky header.',
      ],
      tags: ['ListView', 'Column', 'Unbounded Height', 'Slivers', 'Viewport'],
      sandboxPresetId: 'layout_box',
      bestPracticeNote:
          'Hindari shrinkWrap: true pada dataset dinamis karena Flutter akan merender seluruh item sekaligus di memori, menghilangkan virtualisasi lazy loading.',
    ),

    // =========================================================================
    // 7. LOCAL STORAGE & CACHING
    // =========================================================================
    QuickRecipe(
      id: 'recipe_local_storage_cache_manager',
      title: 'Type-Safe SharedPreferences Cache Wrapper dengan TTL',
      category: RecipeCategory.localStorage,
      description:
          'Wrapper penyimpanan lokal sederhana yang mendukung Time-To-Live (TTL) kedaluwarsa data, serialisasi JSON otomatis, dan fallback aman saat data stale.',
      codeSnippet: '''
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalCacheService {
  final SharedPreferences _prefs;
  LocalCacheService(this._prefs);

  static Future<LocalCacheService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalCacheService(prefs);
  }

  // Simpan data dengan masa berlaku (contoh: 2 jam)
  Future<bool> setWithTtl({
    required String key,
    required dynamic data,
    Duration ttl = const Duration(hours: 2),
  }) async {
    final expiryTime = DateTime.now().add(ttl).millisecondsSinceEpoch;
    final payload = jsonEncode({
      'expiry': expiryTime,
      'payload': data,
    });
    return _prefs.setString('cache_\$key', payload);
  }

  // Ambil data (mengembalikan null otomatis jika sudah expired)
  T? getWithTtl<T>(String key) {
    final raw = _prefs.getString('cache_\$key');
    if (raw == null) return null;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final expiry = decoded['expiry'] as int;
      if (DateTime.now().millisecondsSinceEpoch > expiry) {
        // Data expired -> hapus dari storage di latar belakang
        _prefs.remove('cache_\$key');
        return null;
      }
      return decoded['payload'] as T?;
    } catch (_) {
      return null;
    }
  }

  Future<void> clearAllCache() async {
    final keys = _prefs.getKeys().where((k) => k.startsWith('cache_'));
    for (final k in keys) {
      await _prefs.remove(k);
    }
  }
}''',
      keyPoints: [
        'Menyimpan timestamp expiration di dalam payload wrapper JSON.',
        'Pembersihan pasif (lazy evict) saat pembacaan data kadaluwarsa menghemat komputasi.',
        'Mencegah aplikasi menampilkan konten lama pada jaringan offline/stale.',
      ],
      tags: ['LocalStorage', 'SharedPreferences', 'Cache', 'TTL', 'JSON'],
      bestPracticeNote:
          'Untuk data sensitif seperti token otentikasi atau PIN perbankan, gunakan flutter_secure_storage yang memanfaatkan Android Keystore dan iOS Keychain.',
    ),

    // =========================================================================
    // 8. CUSTOM CANVAS & PATHS
    // =========================================================================
    QuickRecipe(
      id: 'recipe_canvas_smooth_wave_path',
      title: 'Smooth Wave Curve Generator Menggunakan Bezier Curves',
      category: RecipeCategory.canvasPaths,
      description:
          'Formula CustomPainter untuk menggambar gelombang kurva estetis (Wave header background) menggunakan quadraticBezierTo dan path clipping dinamis.',
      codeSnippet: '''
import 'package:flutter/material.dart';

class WaveHeaderPainter extends CustomPainter {
  final Color waveColor;
  final double waveAmplitude; // Tinggi puncak ombak

  WaveHeaderPainter({
    required this.waveColor,
    this.waveAmplitude = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;

    final path = Path();
    // Mulai dari sudut kiri atas
    path.lineTo(0, size.height - waveAmplitude);

    // Titik kontrol ombak pertama (Lembah)
    final firstControlPoint = Offset(size.width * 0.25, size.height);
    final firstEndPoint = Offset(size.width * 0.5, size.height - waveAmplitude);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Titik kontrol ombak kedua (Puncak)
    final secondControlPoint = Offset(size.width * 0.75, size.height - (waveAmplitude * 2));
    final secondEndPoint = Offset(size.width, size.height - waveAmplitude);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    // Tutup path ke sudut kanan atas dan kembali ke awal
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WaveHeaderPainter oldDelegate) {
    return oldDelegate.waveColor != waveColor ||
        oldDelegate.waveAmplitude != waveAmplitude;
  }
}''',
      keyPoints: [
        'quadraticBezierTo(controlPointX, controlPointY, endPointX, endPointY) menghasilkan lengkungan organik yang mulus.',
        'Membagi lebar canvas menjadi persentase (0.25, 0.5, 0.75, 1.0) menjaga responsivitas di semua ukuran layar smartphone dan tablet.',
        'shouldRepaint harus mengembalikan true hanya bila ada properti visual yang berubah.',
      ],
      tags: ['CustomPainter', 'Canvas', 'Wave Path', 'Bezier', 'UI Design'],
      sandboxPresetId: 'custom_painter',
      bestPracticeNote:
          'Bungkus widget dengan RepaintBoundary jika canvas berada di dalam list atau sering dipicu animasi yang tidak berkaitan dengannya.',
    ),
    QuickRecipe(
      id: 'recipe_canvas_dashed_line_painter',
      title: 'Dashed & Dotted Line CustomPainter',
      category: RecipeCategory.canvasPaths,
      description:
          'Membuat garis putus-putus atau titik-titik kustom untuk voucher border, invoice divider, atau timeline tracker.',
      codeSnippet: '''
import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  DashedLinePainter({
    this.color = const Color(0xFF94A3B8),
    this.dashWidth = 6.0,
    this.dashSpace = 4.0,
    this.strokeWidth = 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final y = size.height / 2;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + dashWidth, y),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant DashedLinePainter oldDelegate) => false;
}''',
      keyPoints: [
        'Loop kalkulasi jarak garis (startX += dashWidth + dashSpace) menghasilkan jarak yang presisi secara matematis.',
        'StrokeCap.round memberikan tampilan ujung titik/garis yang halus dan estetik.',
        'Performa sangat ringan dengan overhead memori mendekati nol.',
      ],
      tags: ['CustomPainter', 'Dashed Line', 'Voucher', 'Divider', 'Canvas'],
      sandboxPresetId: 'custom_painter',
      bestPracticeNote:
          'Gunakan SizedBox(width: double.infinity, height: strokeWidth) sebagai container DashedLinePainter.',
    ),
  ];

  static QuickRecipe? getById(String id) {
    try {
      return allRecipes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<QuickRecipe> getByCategory(RecipeCategory category) {
    return allRecipes.where((r) => r.category == category).toList();
  }
}
