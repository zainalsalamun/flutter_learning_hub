import 'package:flutter/material.dart';
import '../models/discussion_model.dart';
import 'lms_progress_service.dart';

class DiscussionService extends ChangeNotifier {
  static final DiscussionService instance = DiscussionService._internal();

  DiscussionService._internal() {
    _initDefaultThreads();
  }

  factory DiscussionService() => instance;

  final List<DiscussionThread> _threads = [];

  List<DiscussionThread> get threads => List.unmodifiable(_threads);

  int get totalThreadsCount => _threads.length;

  int get totalSolvedCount => _threads.where((t) => t.isSolved).length;

  int get totalRepliesCount =>
      _threads.fold<int>(0, (sum, t) => sum + t.replies.length);

  void _initDefaultThreads() {
    _threads.addAll([
      DiscussionThread(
        id: 'disc_1',
        title: 'Kapan sebaiknya menggunakan InheritedWidget murni vs ChangeNotifier / ValueNotifier?',
        content:
            'Halo rekan developer, saya sedang mempelajari sistem state bawaan Flutter. Saya sering melihat framework internal seperti Theme atau MediaQuery memakai InheritedWidget, sedangkan state aplikasi di tutorial sering memakai ChangeNotifier atau ValueNotifier. Kapan use-case terbaik masing-masing?',
        codeSnippet: '''// Contoh InheritedWidget bawaan
class ConfigScope extends InheritedWidget {
  final AppConfig config;
  const ConfigScope({super.key, required this.config, required super.child});

  static AppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ConfigScope>()!.config;
  }

  @override
  bool updateShouldNotify(ConfigScope oldWidget) => config != oldWidget.config;
}''',
        authorName: 'Fikri Pratama',
        authorRole: 'Flutter Enthusiast',
        authorAvatarColor: const Color(0xFF02569B),
        category: DiscussionCategory.architecture,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        upvotes: 18,
        viewCount: 142,
        isSolved: true,
        tags: const ['InheritedWidget', 'ChangeNotifier', 'Architecture'],
        replies: [
          DiscussionReply(
            id: 'rep_1_1',
            authorName: 'Budi Santoso',
            authorRole: 'Senior Mobile Architect',
            authorAvatarColor: const Color(0xFF10B981),
            content:
                'Secara singkat: InheritedWidget adalah mekanisme **distribusi data turun ke bawah (Dependency Injection)** di widget tree secara O(1). Namun InheritedWidget sendiri immutable (tidak menyimpan mutable state).\n\nChangeNotifier / ValueNotifier adalah **state holder reaktif**. Pola terbaik adalah menggabungkan keduanya: simpan ValueNotifier atau Controller di dalam State, lalu sebarkan instance-nya melalui InheritedWidget (inilah cara kerja package Provider di balik layar)!',
            codeSnippet: '''// Pola gabungan (best practice)
class CartScope extends InheritedNotifier<ValueNotifier<int>> {
  const CartScope({
    super.key,
    required ValueNotifier<int> notifier,
    required super.child,
  }) : super(notifier: notifier);

  static int of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CartScope>()!.notifier!.value;
  }
}''',
            createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 40)),
            upvotes: 14,
            isSolution: true,
          ),
          DiscussionReply(
            id: 'rep_1_2',
            authorName: 'Siti Rahma',
            authorRole: 'Flutter Developer',
            authorAvatarColor: const Color(0xFF6366F1),
            content:
                'Setuju dengan jawaban Pak Budi. Jika datanya jarang berubah (misal konfigurasi tema, API endpoint, atau user auth token), InheritedWidget murni sangat efisien dan 0 dependensi tambahan.',
            createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 10)),
            upvotes: 5,
            isSolution: false,
          ),
        ],
      ),
      DiscussionThread(
        id: 'disc_2',
        title: 'Mengapa didUpdateWidget() terpanggil saat parent widget memanggil setState()?',
        content:
            'Saya membuat widget child berstatus StatefulWidget. Ketika parent widget-nya memanggil setState(), lifecycle method didUpdateWidget() di child selalu terpanggil padahal parameter child tidak saya ubah. Apakah ini normal di element tree Flutter?',
        codeSnippet: '''@override
void didUpdateWidget(covariant UserProfileCard oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (oldWidget.userId != widget.userId) {
    _fetchUserData(); // Terpanggil ulang padahal userId sama?
  }
}''',
        authorName: 'Rian Kurniawan',
        authorRole: 'Junior Developer',
        authorAvatarColor: const Color(0xFFF59E0B),
        category: DiscussionCategory.lifecycle,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        upvotes: 12,
        viewCount: 98,
        isSolved: true,
        tags: ['Lifecycle', 'StatefulWidget', 'ElementTree'],
        replies: [
          DiscussionReply(
            id: 'rep_2_1',
            authorName: 'Ahmad Fauzi',
            authorRole: 'Flutter Lead',
            authorAvatarColor: const Color(0xFF10B981),
            content:
                'Ini sepenuhnya normal! Dalam Flutter, saat parent memanggil setState(), parent akan membuat konfigurasi Widget baru (instance baru). Element tree memeriksa `Widget.canUpdate(oldWidget, newWidget)` berdasarkan runtimeType dan Key.\n\nKarena type & key sama, Element TIDAK dibongkar, melainkan mempertahankan State lama dan meng-update referensi widget-nya dengan memanggil `didUpdateWidget(oldWidget)`. Makanya selalu pastikan membandingkan nilainya `if (oldWidget.userId != widget.userId)` agar tidak trigger logic duplikat.',
            createdAt: DateTime.now().subtract(const Duration(hours: 4)),
            upvotes: 10,
            isSolution: true,
          ),
        ],
      ),
      DiscussionThread(
        id: 'disc_3',
        title: 'Optimasi CustomPainter: Bagaimana RepaintBoundary bekerja secara internal?',
        content:
            'Canvas painter di aplikasi saya terasa lag saat ada scrolling list di sekitarnya. Saya disarankan membungkus CustomPaint dengan RepaintBoundary. Sebenarnya apa yang terjadi di layer Skia / Impeller saat RepaintBoundary digunakan?',
        codeSnippet: '''RepaintBoundary(
  child: CustomPaint(
    size: const Size(300, 200),
    painter: ComplexParticlePainter(),
  ),
)''',
        authorName: 'Dewi Anggraini',
        authorRole: 'UI/UX Specialist',
        authorAvatarColor: const Color(0xFF8B5CF6),
        category: DiscussionCategory.renderTree,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        upvotes: 24,
        viewCount: 210,
        isSolved: true,
        tags: ['CustomPainter', 'RepaintBoundary', 'Impeller'],
        replies: [
          DiscussionReply(
            id: 'rep_3_1',
            authorName: 'Eko Prasetyo',
            authorRole: 'Engine Specialist',
            authorAvatarColor: const Color(0xFF0284C7),
            content:
                'RepaintBoundary menginstruksikan rendering pipeline untuk membuat **DisplayList / Layer terpisah** di GPU. Ketika bagian lain di layar (misal scrollable list) di-render ulang, GPU cukup mengomposisikan ulang bitmap layer cache tanpa perlu mengeksekusi instruksi paint canvas kamu dari awal!\n\nCatatan penting: Jangan gunakan RepaintBoundary jika canvas-nya dianimasikan 60 FPS tanpa henti, karena biaya pembuatan layer GPU justru menambah overhead jika tidak ada yang di-cache.',
            createdAt: DateTime.now().subtract(const Duration(hours: 22)),
            upvotes: 19,
            isSolution: true,
          ),
        ],
      ),
      DiscussionThread(
        id: 'disc_4',
        title: 'Best practice pemisahan Domain Layer & Data Layer pada Flutter Clean Architecture',
        content:
            'Apakah model entity di domain layer boleh memiliki method `fromJson` / `toJson`, ataukah harus dipisah ke Model DTO di data layer dan di-mapping manual?',
        codeSnippet: '''// Opsi A: Entity bersih tanpa JSON
class UserEntity {
  final String id;
  final String name;
  const UserEntity({required this.id, required this.name});
}

// Opsi B: DTO di data layer
class UserModel extends UserEntity {
  UserModel({required super.id, required super.name});
  factory UserModel.fromJson(Map<String, dynamic> json) => ...;
}''',
        authorName: 'Aris Wicaksono',
        authorRole: 'Software Engineer',
        authorAvatarColor: const Color(0xFF6366F1),
        category: DiscussionCategory.cleanCode,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        upvotes: 31,
        viewCount: 340,
        isSolved: true,
        tags: ['CleanArchitecture', 'DDD', 'RepositoryPattern'],
        replies: [
          DiscussionReply(
            id: 'rep_4_1',
            authorName: 'Hendra Gunawan',
            authorRole: 'Enterprise Consultant',
            authorAvatarColor: const Color(0xFF059669),
            content:
                'Opsi B adalah standar industri (Robert C. Martin Clean Architecture). **Domain Layer tidak boleh tahu menahu tentang format data luar (JSON, XML, SQLite)**. Domain adalah inti aturan bisnis murni.\n\nData layer meng-extend atau me-map Entity menjadi DTO dengan mapper. Jika besok API kamu berganti dari REST JSON ke gRPC Protobuf atau Supabase, Domain Layer tidak tersentuh sama sekali.',
            createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 20)),
            upvotes: 27,
            isSolution: true,
          ),
        ],
      ),
      DiscussionThread(
        id: 'disc_5',
        title: 'Cara paling elegan mengatasi error "A RenderFlex overflowed by 8.7 pixels on the right"?',
        content:
            'Saya memiliki Row yang berisi Icon, Text panjang judul, dan Badge status. Di layar kecil atau saat font scaling aktif, terjadi RenderFlex overflow garis kuning-hitam. Bagaimana solusi teraman tanpa merusak proporsi badge?',
        codeSnippet: '''Row(
  children: [
    Icon(Icons.star),
    Text(longTitle), // Overflow terjadi di sini!
    Chip(label: Text('Status')),
  ],
)''',
        authorName: 'Nadia Putri',
        authorRole: 'Mobile Developer',
        authorAvatarColor: const Color(0xFFEF4444),
        category: DiscussionCategory.debugging,
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        upvotes: 15,
        viewCount: 165,
        isSolved: true,
        tags: ['RenderFlex', 'Overflow', 'Layout', 'Expanded'],
        replies: [
          DiscussionReply(
            id: 'rep_5_1',
            authorName: 'Zainal Naltech',
            authorRole: 'Flutter Instructor',
            authorAvatarColor: const Color(0xFF02569B),
            content:
                'Solusi tepat: Bungkus `Text` dengan `Expanded` dan tambahkan `overflow: TextOverflow.ellipsis` serta `maxLines: 1`. Dengan begitu, Row memberikan sisa lebar ruang (*tight constraint*) kepada Text, sedangkan Icon dan Chip tetap mendapatkan ukuran alaminya.',
            codeSnippet: '''Row(
  children: [
    const Icon(Icons.star),
    const SizedBox(width: 8),
    Expanded(
      child: Text(
        longTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    const SizedBox(width: 8),
    const Chip(label: Text('Status')),
  ],
)''',
            createdAt: DateTime.now().subtract(const Duration(hours: 7)),
            upvotes: 16,
            isSolution: true,
          ),
        ],
      ),
      DiscussionThread(
        id: 'disc_6',
        title: 'Perbandingan performa & Developer Experience: BLoC vs Riverpod 2.0 untuk aplikasi skala besar',
        content:
            'Untuk aplikasi fintech dengan 50+ screen, tim kami sedang mengevaluasi antara Flutter BLoC (Cubit + Event-State) dan Riverpod 2.0 dengan code-generation. Bagaimana pengalaman rekan-rekan mengenai maintainability dan testing?',
        authorName: 'Ilham Saputra',
        authorRole: 'Tech Lead',
        authorAvatarColor: const Color(0xFF10B981),
        category: DiscussionCategory.stateManagement,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        upvotes: 42,
        viewCount: 480,
        isSolved: false,
        tags: ['BLoC', 'Riverpod', 'StateManagement', 'Enterprise'],
        replies: [
          DiscussionReply(
            id: 'rep_6_1',
            authorName: 'Bagus Tri',
            authorRole: 'Fintech Mobile Lead',
            authorAvatarColor: const Color(0xFF6366F1),
            content:
                'Untuk skala fintech dengan regulasi audit ketat, BLoC sangat unggul karena aliran aksi tercatat rapi via `BlocObserver` (time-travel debugging & analytic logging otomatis). Namun jika tim mengutamakan kecepatan rilis (*time-to-market*) dan kemudahan async cache invalidation, Riverpod 2.x dengan `AsyncNotifier` jauh lebih ringkas.',
            createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 18)),
            upvotes: 21,
            isSolution: false,
          ),
        ],
      ),
    ]);
  }

  // =========================================================================
  // ACTIONS
  // =========================================================================

  Future<void> addThread({
    required String title,
    required String content,
    String? codeSnippet,
    required DiscussionCategory category,
    required String authorName,
    List<String> tags = const [],
  }) async {
    final newThread = DiscussionThread(
      id: 'disc_${DateTime.now().millisecondsSinceEpoch}',
      title: title.trim(),
      content: content.trim(),
      codeSnippet: codeSnippet?.trim().isEmpty == true ? null : codeSnippet?.trim(),
      authorName: authorName.trim().isEmpty ? 'Siswa Pembelajar' : authorName.trim(),
      authorRole: 'Siswa Aktif',
      authorAvatarColor: const Color(0xFF02569B),
      category: category,
      createdAt: DateTime.now(),
      upvotes: 1,
      userUpvoted: true,
      isSolved: false,
      viewCount: 1,
      tags: tags,
      replies: const [],
    );

    _threads.insert(0, newThread);
    notifyListeners();

    // Award +30 XP for asking a valuable question
    await LmsProgressService.instance.recordCommunityDiscussionCreated(bonusXp: 30);
  }

  Future<void> addReply({
    required String threadId,
    required String content,
    String? codeSnippet,
    required String authorName,
  }) async {
    final index = _threads.indexWhere((t) => t.id == threadId);
    if (index == -1) return;

    final newReply = DiscussionReply(
      id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
      authorName: authorName.trim().isEmpty ? 'Siswa Pembelajar' : authorName.trim(),
      authorRole: 'Kontributor Komunitas',
      authorAvatarColor: const Color(0xFF10B981),
      content: content.trim(),
      codeSnippet: codeSnippet?.trim().isEmpty == true ? null : codeSnippet?.trim(),
      createdAt: DateTime.now(),
      upvotes: 0,
      isSolution: false,
    );

    final thread = _threads[index];
    final updatedReplies = List<DiscussionReply>.from(thread.replies)..add(newReply);
    _threads[index] = thread.copyWith(replies: updatedReplies);
    notifyListeners();

    // Award +15 XP for answering/helping peers
    await LmsProgressService.instance.recordCommunityReplyCreated(bonusXp: 15);
  }

  void toggleUpvoteThread(String threadId) {
    final index = _threads.indexWhere((t) => t.id == threadId);
    if (index == -1) return;

    final t = _threads[index];
    final isUpvoted = t.userUpvoted;
    _threads[index] = t.copyWith(
      userUpvoted: !isUpvoted,
      upvotes: isUpvoted ? t.upvotes - 1 : t.upvotes + 1,
    );
    notifyListeners();
  }

  void toggleUpvoteReply(String threadId, String replyId) {
    final threadIndex = _threads.indexWhere((t) => t.id == threadId);
    if (threadIndex == -1) return;

    final thread = _threads[threadIndex];
    final replyIndex = thread.replies.indexWhere((r) => r.id == replyId);
    if (replyIndex == -1) return;

    final reply = thread.replies[replyIndex];
    final isUpvoted = reply.userUpvoted;
    final updatedReply = reply.copyWith(
      userUpvoted: !isUpvoted,
      upvotes: isUpvoted ? reply.upvotes - 1 : reply.upvotes + 1,
    );

    final updatedReplies = List<DiscussionReply>.from(thread.replies);
    updatedReplies[replyIndex] = updatedReply;

    _threads[threadIndex] = thread.copyWith(replies: updatedReplies);
    notifyListeners();
  }

  void toggleMarkSolution(String threadId, String replyId) {
    final threadIndex = _threads.indexWhere((t) => t.id == threadId);
    if (threadIndex == -1) return;

    final thread = _threads[threadIndex];
    final updatedReplies = thread.replies.map((r) {
      if (r.id == replyId) {
        return r.copyWith(isSolution: !r.isSolution);
      }
      return r;
    }).toList();

    final hasSolution = updatedReplies.any((r) => r.isSolution);
    _threads[threadIndex] = thread.copyWith(
      replies: updatedReplies,
      isSolved: hasSolution,
    );
    notifyListeners();
  }

  void incrementViewCount(String threadId) {
    final index = _threads.indexWhere((t) => t.id == threadId);
    if (index == -1) return;

    final t = _threads[index];
    _threads[index] = t.copyWith(viewCount: t.viewCount + 1);
    notifyListeners();
  }

  List<DiscussionThread> getFilteredThreads({
    String? query,
    DiscussionCategory? category,
    String sortBy = 'popular', // 'popular', 'recent', 'unsolved'
  }) {
    var result = List<DiscussionThread>.from(_threads);

    if (category != null) {
      result = result.where((t) => t.category == category).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      result = result.where((t) {
        return t.title.toLowerCase().contains(q) ||
            t.content.toLowerCase().contains(q) ||
            t.authorName.toLowerCase().contains(q) ||
            t.tags.any((tag) => tag.toLowerCase().contains(q));
      }).toList();
    }

    if (sortBy == 'popular') {
      result.sort((a, b) => b.upvotes.compareTo(a.upvotes));
    } else if (sortBy == 'recent') {
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (sortBy == 'unsolved') {
      result = result.where((t) => !t.isSolved).toList();
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return result;
  }
}
