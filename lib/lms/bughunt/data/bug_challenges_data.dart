import '../models/bug_challenge_model.dart';

class BugChallengesData {
  static const List<BugChallengeModel> allChallenges = [
    // -------------------------------------------------------------------------
    // BUG 1: Unbounded Height di ListView dalam Column
    // -------------------------------------------------------------------------
    BugChallengeModel(
      id: 'bug_unbounded_height',
      title: 'Vertical viewport was given unbounded height',
      scenario:
          'Pada halaman Detail Siswa, developer meletakkan header informasi di atas sebuah daftar aktivitas belajar menggunakan Column dan ListView.builder. Aplikasi langsung melempar Red Screen of Death.',
      category: BugCategory.layout,
      difficulty: BugDifficulty.easy,
      xpReward: 80,
      flutterErrorSnippet:
          'FlutterError: Vertical viewport was given unbounded height.\n'
          'Viewports expand in the scrolling direction to fill their container;\n'
          'having an unbounded container, such as a Column with default mainAxisSize,\n'
          'does not provide enough information for how big the viewport should be.\n'
          'The offending RenderViewport was:\n'
          '  RenderViewport#7a32e NEEDS-LAYOUT NEEDS-PAINT ...',
      buggyCode: '''
class StudentActivityPage extends StatelessWidget {
  final List<String> activities;
  const StudentActivityPage({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aktivitas Siswa')),
      body: Column(
        children: [
          const ProfileHeaderCard(),
          const SectionTitle('Riwayat Modul'),
          // ⚠️ BUG: ListView di dalam Column tanpa constraint vertikal
          ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              return ActivityTile(title: activities[index]);
            },
          ),
        ],
      ),
    );
  }
}
''',
      fixOptions: [
        BugFixOption(
          id: 'fix_1a',
          description:
              'Membungkus ListView.builder dengan Expanded agar mengambil sisa ruang vertikal Column yang pasti.',
          modifiedCode: '''
          const SectionTitle('Riwayat Modul'),
          Expanded(
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                return ActivityTile(title: activities[index]);
              },
            ),
          ),
''',
          isCorrect: true,
          critique:
              'Tepat sekali! Expanded memberikan bounded BoxConstraints vertikal (maxHeight = sisa layar) sehingga Viewport RenderObject dapat menghitung scrollable area dengan efisien dan aman.',
        ),
        BugFixOption(
          id: 'fix_1b',
          description:
              'Menambahkan shrinkWrap: true dan physics: NeverScrollableScrollPhysics() pada ListView.',
          modifiedCode: '''
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            itemBuilder: (context, index) => ActivityTile(title: activities[index]),
          ),
''',
          isCorrect: true,
          critique:
              'Solusi ini bekerja jika Column dibungkus SingleChildScrollView. Namun untuk daftar panjang tanpa scroll parent, Expanded lebih efisien secara performa rendering memori.',
        ),
        BugFixOption(
          id: 'fix_1c',
          description:
              'Mengubah Column menjadi Row agar arah scroll vertikal tidak berbenturan.',
          modifiedCode: '''
      body: Row(
        children: [
          const ProfileHeaderCard(),
          ListView.builder(...),
        ],
      ),
''',
          isCorrect: false,
          critique:
              'Keliru. Mengubah menjadi Row justru membuat layout menjadi horizontal dan tetap menimbulkan unbounded horizontal constraints pada ListView vertikal.',
        ),
        BugFixOption(
          id: 'fix_1d',
          description:
              'Menambahkan Container dengan width: double.infinity pada ListView.',
          modifiedCode: '''
          Container(
            width: double.infinity,
            child: ListView.builder(...),
          ),
''',
          isCorrect: false,
          critique:
              'Tidak menyelesaikan masalah. Error terjadi karena ketinggian vertikal (height) yang unbounded, bukan lebar (width).',
        ),
      ],
      rootCauseAnalysis:
          'Aturan utama layout Flutter adalah "Constraints go down, Sizes go up, Parent sets position". '
          'Sebuah Column memberikan constraint maxHeight: double.infinity ke anak-anaknya. '
          'Sementara ListView secara alami ingin meregang tak terhingga ke arah scroll-nya. '
          'Dua komponen tak terhingga ini menghasilkan konflik logis tanpa solusi ukuran definitif.',
      bestPracticeGuide:
          '1. Gunakan Expanded(child: ListView) jika ListView adalah area scroll utama.\n'
          '2. Gunakan CustomScrollView dengan SliverList dan SliverToBoxAdapter untuk halaman berstruktur heterogen.\n'
          '3. Hindari shrinkWrap: true pada daftar yang memiliki lebih dari 20 item karena menonaktifkan virtualisasi render window.',
      cleanFixedCode: '''
class StudentActivityPage extends StatelessWidget {
  final List<String> activities;
  const StudentActivityPage({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aktivitas Siswa')),
      body: Column(
        children: [
          const ProfileHeaderCard(),
          const SectionTitle('Riwayat Modul'),
          Expanded(
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                return ActivityTile(title: activities[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
''',
    ),

    // -------------------------------------------------------------------------
    // BUG 2: Memory Leak & Disposed AnimationController
    // -------------------------------------------------------------------------
    BugChallengeModel(
      id: 'bug_animation_leak',
      title: 'AnimationController used after being disposed / missing dispose',
      scenario:
          'Saat berpindah halaman dengan cepat, aplikasi mengalami lonjakan RAM dan melempar error karena listener animasi tetap mencoba memanggil setState setelah State widget dilepas dari tree.',
      category: BugCategory.memory,
      difficulty: BugDifficulty.medium,
      xpReward: 100,
      flutterErrorSnippet:
          'FlutterError: A AnimationController was used after being disposed.\n'
          'Once you have called dispose() on a AnimationController, it can no longer be used.\n'
          'Unhandled Exception: setState() called after dispose(): _PulsingBadgeState#4f12a(lifecycle state: defunct, not mounted)',
      buggyCode: '''
class PulsingBadgeWidget extends StatefulWidget {
  const PulsingBadgeWidget({super.key});
  @override
  State<PulsingBadgeWidget> createState() => _PulsingBadgeState();
}

class _PulsingBadgeState extends State<PulsingBadgeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _controller.addListener(() {
      // ⚠️ BUG: Memanggil setState tanpa memeriksa mounted
      setState(() {});
    });
  }

  // ⚠️ BUG: Tidak ada override method dispose()!
  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: _controller.value, child: const Icon(Icons.star));
  }
}
''',
      fixOptions: [
        BugFixOption(
          id: 'fix_2a',
          description:
              'Implementasikan method dispose() untuk melepaskan controller dan gunakan AnimatedBuilder agar tidak perlu manual listener & setState().',
          modifiedCode: '''
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _controller.value,
        child: child,
      ),
      child: const Icon(Icons.star),
    );
  }
''',
          isCorrect: true,
          critique:
              'Solusi arsitektur terbaik! AnimatedBuilder mengisolasi rebuild hanya pada widget target dan menghapus kebutuhan listener manual, serta dispose() mencegah memory leak secara mutlak.',
        ),
        BugFixOption(
          id: 'fix_2b',
          description:
              'Hapus SingleTickerProviderStateMixin agar controller tidak terikat ke vsync.',
          modifiedCode: '''
class _PulsingBadgeState extends State<PulsingBadgeWidget> {
  late AnimationController _controller;
  // tanpa vsync
''',
          isCorrect: false,
          critique:
              'Salah. AnimationController membutuhkan TickerProvider (vsync) untuk menyinkronkan frame rate layar dan mencegah pemborosan GPU.',
        ),
        BugFixOption(
          id: 'fix_2c',
          description:
              'Cukup tambahkan if (mounted) setState(...) di dalam listener tanpa perlu dispose.',
          modifiedCode: '''
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
''',
          isCorrect: false,
          critique:
              'Separuh benar untuk mencegah crash defunct, tapi Controller tetap terus berputar di background memori (Ticker leak) karena tidak pernah di-dispose.',
        ),
      ],
      rootCauseAnalysis:
          'Setiap objek native Flutter yang memegang resource eksternal atau stream (seperti AnimationController, TextEditingController, ScrollController, StreamSubscription) wajib ditutup saat widget unmount. '
          'Jika tidak di-dispose, Ticker akan terus berjalan di memori OS dan mencoba memanggil callback pada widget yang sudah mati.',
      bestPracticeGuide:
          '1. Selalu pasangkan inisialisasi controller di initState() dengan controller.dispose() di dispose().\n'
          '2. Gunakan AnimatedBuilder atau FadeTransition daripada controller.addListener(() => setState()).\n'
          '3. Gunakan devtools Memory Tab untuk memonitor kebocoran Objek Ticker.',
      cleanFixedCode: '''
class PulsingBadgeWidget extends StatefulWidget {
  const PulsingBadgeWidget({super.key});
  @override
  State<PulsingBadgeWidget> createState() => _PulsingBadgeState();
}

class _PulsingBadgeState extends State<PulsingBadgeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _controller.value,
        child: child,
      ),
      child: const Icon(Icons.star),
    );
  }
}
''',
    ),

    // -------------------------------------------------------------------------
    // BUG 3: setState() or markNeedsBuild() during build
    // -------------------------------------------------------------------------
    BugChallengeModel(
      id: 'bug_setstate_during_build',
      title: 'setState() or markNeedsBuild() called during build',
      scenario:
          'Developer ingin menampilkan dialog konfirmasi otomatis ketika status siswa terdeteksi kadaluarsa langsung di dalam blok build(), memicu crash fase pipeline.',
      category: BugCategory.statePhase,
      difficulty: BugDifficulty.medium,
      xpReward: 95,
      flutterErrorSnippet:
          'FlutterError: setState() or markNeedsBuild() called during build.\n'
          'This StudentPortalWidget widget cannot be marked as needing to build\n'
          'because the framework is already in the process of building widgets.\n'
          'A widget can be marked as needing to be built during the run of\n'
          'the build methods only if the call comes from an ancestor...',
      buggyCode: '''
class StudentPortalWidget extends StatelessWidget {
  final bool isSessionExpired;
  const StudentPortalWidget({super.key, required this.isSessionExpired});

  @override
  Widget build(BuildContext context) {
    // ⚠️ BUG: Memanggil navigasi/dialog yang mengubah state saat pipeline build berlangsung
    if (isSessionExpired) {
      Navigator.pushNamed(context, '/login');
    }

    return Scaffold(
      body: Center(child: Text('Dashboard Pembelajaran')),
    );
  }
}
''',
      fixOptions: [
        BugFixOption(
          id: 'fix_3a',
          description:
              'Jadwalkan navigasi ke microtask setelah frame selesai dirender menggunakan WidgetsBinding.instance.addPostFrameCallback.',
          modifiedCode: '''
    if (isSessionExpired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.pushNamed(context, '/login');
        }
      });
    }
''',
          isCorrect: true,
          critique:
              'Tepat sekali! addPostFrameCallback menunda eksekusi navigasi hingga pipeline layout dan paint frame saat ini selesai 100%, sehingga aman memodifikasi tree.',
        ),
        BugFixOption(
          id: 'fix_3b',
          description:
              'Bungkus Navigator dengan Future.delayed(Duration.zero).',
          modifiedCode: '''
    if (isSessionExpired) {
      Future.delayed(Duration.zero, () {
        Navigator.pushNamed(context, '/login');
      });
    }
''',
          isCorrect: true,
          critique:
              'Bekerja karena memasukkan task ke Event Queue setelah frame, namun addPostFrameCallback lebih presisi dan idiomatik dalam Flutter rendering lifecycle.',
        ),
        BugFixOption(
          id: 'fix_3c',
          description:
              'Pindahkan logika pengecekan ke dalam Stateful Widget dan panggil setState() di initState.',
          modifiedCode: '''
  @override
  void initState() {
    super.initState();
    setState(() {
      Navigator.pushNamed(context, '/login');
    });
  }
''',
          isCorrect: false,
          critique:
              'Salah. Memanggil Navigator di initState tanpa frame delay juga dapat menimbulkan exception karena context belum sepenuhnya siap di render tree.',
        ),
      ],
      rootCauseAnalysis:
          'Flutter memisahkan fase pipeline menjadi: Build -> Layout -> Paint. '
          'Selama fase Build berlangsung, tree sedang dikonstruksi secara rekursif. '
          'Memicu perubahan state atau navigasi saat fase ini dilarang keras demi menjaga determinisme rendering.',
      bestPracticeGuide:
          '1. Method build() harus murni (pure function): hanya mengembalikan UI representation, tanpa side-effects.\n'
          '2. Navigasi dan dialog harus dipicu oleh User Event (onTap) atau lifecycle hooks dengan addPostFrameCallback.\n'
          '3. Gunakan state management listener (seperti BlocListener atau ref.listen di Riverpod).',
      cleanFixedCode: '''
class StudentPortalWidget extends StatelessWidget {
  final bool isSessionExpired;
  const StudentPortalWidget({super.key, required this.isSessionExpired});

  @override
  Widget build(BuildContext context) {
    if (isSessionExpired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    }

    return const Scaffold(
      body: Center(child: Text('Dashboard Pembelajaran')),
    );
  }
}
''',
    ),

    // -------------------------------------------------------------------------
    // BUG 4: RenderFlex Overflow di Row Teks
    // -------------------------------------------------------------------------
    BugChallengeModel(
      id: 'bug_renderflex_overflow',
      title: 'A RenderFlex overflowed by 48 pixels on the right',
      scenario:
          'Pada kartu materi, judul materi panjang yang disandingkan dengan tag status di dalam Row menyebabkan garis hitam-kuning overflow di perangkat berspesifikasi layar kecil.',
      category: BugCategory.overflow,
      difficulty: BugDifficulty.easy,
      xpReward: 75,
      flutterErrorSnippet:
          '══╡ EXCEPTION CAUGHT BY RENDERING LIBRARY ╞═════════════════════════════════════════════════════════\n'
          'The following assertion was thrown during layout:\n'
          'A RenderFlex overflowed by 48.0 pixels on the right.\n'
          'The relevant error-causing widget was: Row\n'
          'The overflowing RenderFlex has an orientation of Axis.horizontal.',
      buggyCode: '''
class LessonHeaderCard extends StatelessWidget {
  final String title; // Contoh: "Arsitektur Tiga Pohon: Widget, Element, dan RenderObject Secara Mendalam"
  const LessonHeaderCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(Icons.bookmark),
          const SizedBox(width: 8),
          // ⚠️ BUG: Text tanpa Flexible/Expanded di dalam Row
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          const Chip(label: Text('PRO')),
        ],
      ),
    );
  }
}
''',
      fixOptions: [
        BugFixOption(
          id: 'fix_4a',
          description:
              'Bungkus widget Text dengan Expanded dan tentukan TextOverflow.ellipsis serta maxLines: 1.',
          modifiedCode: '''
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
''',
          isCorrect: true,
          critique:
              'Solusi sempurna! Expanded membatasi ukuran teks sesuai sisa lebar Row dan TextOverflow.ellipsis memotong teks panjang secara elegan dengan titik-titik (...).',
        ),
        BugFixOption(
          id: 'fix_4b',
          description:
              'Kecilkan ukuran fontSize teks menjadi 10 agar muat di semua layar.',
          modifiedCode: '''
          Text(
            title,
            style: const TextStyle(fontSize: 10),
          ),
''',
          isCorrect: false,
          critique:
              'Sangat buruk secara UX dan aksesibilitas. Jika judul materi lebih panjang lagi atau pengguna mengaktifkan font scale besar di pengaturan HP, teks tetap akan overflow.',
        ),
        BugFixOption(
          id: 'fix_4c',
          description:
              'Bungkus Row dengan SingleChildScrollView berarah horizontal.',
          modifiedCode: '''
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(...),
      ),
''',
          isCorrect: false,
          critique:
              'Bisa menghilangkan overflow, namun kartu materi tidak seharusnya di-scroll horizontal secara kikuk hanya untuk membaca judul.',
        ),
      ],
      rootCauseAnalysis:
          'Row memberikan unconstrained width kepada Text. Teks akan mencoba mengambil lebar sebesar panjang string tanpa batas. '
          'Jika total lebar melebihi lebar layar, RenderFlex tidak dapat mengompres teks secara otomatis kecuali diberi instruksi Expanded/Flexible.',
      bestPracticeGuide:
          '1. Selalu gunakan Expanded atau Flexible pada widget Text fleksibel di dalam Row.\n'
          '2. Pasangkan dengan overflow: TextOverflow.ellipsis dan batasan maxLines yang jelas.\n'
          '3. Uji tampilan dengan berbagai variasi panjang teks dan resolusi layar sempit (misal 320px).',
      cleanFixedCode: '''
class LessonHeaderCard extends StatelessWidget {
  final String title;
  const LessonHeaderCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(Icons.bookmark),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          const Chip(label: Text('PRO')),
        ],
      ),
    );
  }
}
''',
    ),

    // -------------------------------------------------------------------------
    // BUG 5: LateInitializationError Race Condition
    // -------------------------------------------------------------------------
    BugChallengeModel(
      id: 'bug_late_init_race_condition',
      title: "LateInitializationError: Field '_userData' has not been initialized",
      scenario:
          'Developer menggunakan kata kunci late pada variabel model user dan memanggil API di initState(), namun method build() sudah berjalan sebelum network request selesai.',
      category: BugCategory.asyncSafety,
      difficulty: BugDifficulty.hard,
      xpReward: 120,
      flutterErrorSnippet:
          '══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞═════════════════════════════════════════════════════════\n'
          'The following LateError was thrown building UserProfileScreen:\n'
          'LateInitializationError: Field \'_userData\' has not been initialized.\n'
          'The compiler cannot guarantee that the variable has been initialized before access.',
      buggyCode: '''
class UserProfileScreen extends StatefulWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // ⚠️ BUG: Penggunaan late tanpa jaminan synchronous initialization
  late UserData _userData;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final data = await ApiService.getUser(widget.userId);
    setState(() {
      _userData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ⚠️ CRASH: build() terpanggil pertama kali saat _userData belum di-assign!
    return Scaffold(
      body: Text('Nama Siswa: \${_userData.name}'),
    );
  }
}
''',
      fixOptions: [
        BugFixOption(
          id: 'fix_5a',
          description:
              'Jadikan variabel nullable (UserData? _userData) dan tampilkan indikator loading jika bernilai null.',
          modifiedCode: '''
  UserData? _userData;
  bool _isLoading = true;

  Future<void> _fetchProfile() async {
    final data = await ApiService.getUser(widget.userId);
    if (mounted) {
      setState(() {
        _userData = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _userData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(body: Text('Nama Siswa: \${_userData!.name}'));
  }
''',
          isCorrect: true,
          critique:
              'Solusi ideal untuk pattern StatefulWidget! State null mewakili kondisi sebelum data tersedia, dan UI menampilkan loading state yang anggun.',
        ),
        BugFixOption(
          id: 'fix_5b',
          description:
              'Gunakan FutureBuilder<UserData> untuk menangani state asynchronous secara deklaratif.',
          modifiedCode: '''
  late final Future<UserData> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = ApiService.getUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        return Text('Nama Siswa: \${snapshot.data!.name}');
      },
    );
  }
''',
          isCorrect: true,
          critique:
              'Sangat bersih dan idiomatik! Menghilangkan kebutuhan setState manual dan mengeliminasi risiko LateInitializationError secara permanen.',
        ),
        BugFixOption(
          id: 'fix_5c',
          description:
              'Ubah initState() menjadi async agar menunggu fetch selesai sebelum build().',
          modifiedCode: '''
  @override
  Future<void> initState() async {
    super.initState();
    _userData = await ApiService.getUser(widget.userId);
  }
''',
          isCorrect: false,
          critique:
              'Tidak bisa dilakukan di Flutter! Method initState() tidak boleh dijadikan async karena framework harus menyinkronkan siklus hidup widget secara synchronous.',
        ),
      ],
      rootCauseAnalysis:
          'Kata kunci late adalah janji compiler bahwa developer bertanggung jawab menjamin variabel terisi sebelum diakses. '
          'Karena operasi network bersifat asynchronous, method build() akan selalu berjalan terlebih dahulu sebelum callback network selesai.',
      bestPracticeGuide:
          '1. Jangan gunakan late untuk data asynchronous yang berasal dari network, file, atau database.\n'
          '2. Gunakan tipe nullable (T?) dengan loading state atau FutureBuilder / StreamBuilder.\n'
          '3. Jika menggunakan state management (Riverpod/BLoC), manfaatkan pattern AsyncValue / States (Initial, Loading, Success, Error).',
      cleanFixedCode: '''
class UserProfileScreen extends StatefulWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late final Future<UserData> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ApiService.getUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Siswa')),
      body: FutureBuilder<UserData>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat: \${snapshot.error}'));
          }
          final user = snapshot.data!;
          return Center(child: Text('Nama Siswa: \${user.name}'));
        },
      ),
    );
  }
}
''',
    ),
  ];
}
