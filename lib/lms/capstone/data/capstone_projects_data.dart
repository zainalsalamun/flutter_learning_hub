import 'package:flutter/material.dart';
import '../models/capstone_project_model.dart';

class CapstoneProjectsData {
  static final List<CapstoneProject> allProjects = [
    _fintechProject,
    _ecommerceProject,
    _healthPulseProject,
  ];

  static CapstoneProject? getById(String id) {
    try {
      return allProjects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // =========================================================================
  // 1. FINTECH CRYPTO PORTFOLIO
  // =========================================================================
  static final CapstoneProject _fintechProject = CapstoneProject(
    id: 'capstone_fintech',
    title: 'FinTech Portfolio & Crypto Vault',
    tagline: 'Clean Architecture, BLoC Pattern & Interactive Financial Canvas',
    description:
        'Aplikasi pelacak portofolio aset kripto dan finansial skala produksi. Mengimplementasikan pembagian lapis Data-Domain-Presentation, network interceptor dengan Dio, penanganan state kompleks BLoC/Cubit, dan grafik visual custom dengan CustomPainter.',
    difficulty: 'Production-Grade',
    estimatedHours: '14 - 18 Jam',
    themeColor: const Color(0xFF10B981),
    icon: Icons.account_balance_wallet_rounded,
    techStack: [
      'Clean Architecture',
      'BLoC / Cubit Pattern',
      'Dio + JWT Interceptor',
      'CustomPainter Canvas',
      'Hydrated BLoC Caching',
    ],
    architecturePoints: [
      'Layer Data: Model DTO, Remote DataSource (Dio), Local Hive/SecureStorage, Repository Implementation.',
      'Layer Domain: Pure Dart Entities, Repository Contract Interfaces, Use Cases (GetPortfolioUseCase, BuyAssetUseCase).',
      'Layer Presentation: BLoC Event/State, UI Screens, Interactive Sparkline Canvas, Custom Dialogs.',
      'Resilient Error Handling: Either<Failure, Success> functional error handling pattern.',
    ],
    folderStructureTree: '''lib/
├── core/
│   ├── network/
│   │   ├── api_client.dart
│   │   └── auth_interceptor.dart
│   ├── error/
│   │   └── failures.dart
│   └── utils/
│       └── currency_formatter.dart
├── features/
│   └── portfolio/
│       ├── data/
│       │   ├── datasources/portfolio_remote_datasource.dart
│       │   ├── models/asset_model.dart
│       │   └── repositories/portfolio_repository_impl.dart
│       ├── domain/
│       │   ├── entities/asset_entity.dart
│       │   ├── repositories/portfolio_repository.dart
│       │   └── usecases/get_portfolio_usecase.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── portfolio_bloc.dart
│           │   ├── portfolio_event.dart
│           │   └── portfolio_state.dart
│           ├── widgets/
│           │   └── sparkline_canvas_chart.dart
│           └── pages/
│               └── portfolio_dashboard_page.dart
└── main.dart''',
    milestones: const [
      CapstoneMilestone(
        id: 'fintech_m1',
        title: 'Milestone 1: Fondasi Domain & Network Core',
        description:
            'Menyiapkan Entity, Failure classes, Either functional error type, serta Dio ApiClient dengan JWT token interceptor.',
        keyConcepts: ['Domain Entities', 'Either Monad', 'Dio Interceptor'],
      ),
      CapstoneMilestone(
        id: 'fintech_m2',
        title: 'Milestone 2: Data Source & Repository Implementation',
        description:
            'Mengimplementasikan Remote DataSource berbasis REST endpoint dan Repository Implementation dengan fail-safe offline cache.',
        keyConcepts: ['DTO to Entity Mapping', 'Repository Pattern', 'Local Storage'],
      ),
      CapstoneMilestone(
        id: 'fintech_m3',
        title: 'Milestone 3: State Management BLoC & Cubit',
        description:
            'Membangun PortfolioBloc dengan event FetchPortfolio, RefreshRates, dan BuyOrder, serta status Loading/Success/Failure.',
        keyConcepts: ['BLoC State Streams', 'Event Transformer', 'Debounce'],
      ),
      CapstoneMilestone(
        id: 'fintech_m4',
        title: 'Milestone 4: Interactive Canvas Chart & Order Sheet',
        description:
            'Membuat grafik area interaktif menggunakan CustomPainter, scrubber touch indicator, dan modal transaksi buy/sell.',
        keyConcepts: ['CustomPainter Path', 'Touch Scrubber', 'Modal BottomSheet'],
      ),
    ],
    snippets: const [
      CapstoneSnippetItem(
        title: 'PortfolioBloc & State Implementation',
        filePath: 'lib/features/portfolio/presentation/bloc/portfolio_bloc.dart',
        description: 'BLoC pengelola stream portofolio dengan async/await dan emit state terstruktur.',
        code: '''class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final GetPortfolioUseCase getPortfolio;

  PortfolioBloc({required this.getPortfolio}) : super(PortfolioInitial()) {
    on<LoadPortfolioEvent>(_onLoadPortfolio);
    on<RefreshPricesEvent>(_onRefreshPrices);
  }

  Future<void> _onLoadPortfolio(
    LoadPortfolioEvent event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(PortfolioLoading());
    final result = await getPortfolio();
    result.fold(
      (failure) => emit(PortfolioError(failure.message)),
      (portfolio) => emit(PortfolioLoaded(portfolio)),
    );
  }
}''',
      ),
      CapstoneSnippetItem(
        title: 'Sparkline Canvas Painter',
        filePath: 'lib/features/portfolio/presentation/widgets/sparkline_canvas.dart',
        description: 'Custom painter untuk rendering grafik area kurva aset finansial.',
        code: '''class SparklinePainter extends CustomPainter {
  final List<double> prices;
  final Color lineColor;

  SparklinePainter({required this.prices, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (prices.isEmpty) return;
    final min = prices.reduce((a, b) => a < b ? a : b);
    final max = prices.reduce((a, b) => a > b ? a : b);
    final range = (max - min == 0) ? 1.0 : (max - min);

    final path = Path();
    for (int i = 0; i < prices.length; i++) {
      final x = (i / (prices.length - 1)) * size.width;
      final y = size.height - ((prices[i] - min) / range) * size.height;
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SparklinePainter old) => old.prices != prices;
}''',
      ),
    ],
    liveSimulationBuilder: (context) => const _FintechSimulationWidget(),
  );

  // =========================================================================
  // 2. E-COMMERCE MOBILE SHOP
  // =========================================================================
  static final CapstoneProject _ecommerceProject = CapstoneProject(
    id: 'capstone_ecommerce',
    title: 'Omnichannel E-Commerce Marketplace',
    tagline: 'Riverpod 2.x, Slivers & Animations with Cart Optimization',
    description:
        'Aplikasi marketplace modern lengkap dengan katalog produk interaktif, collapse header dinamis (SliverAppBar), keranjang belanja dengan optimistic UI, serta animasi transisi mulus hero & modal checkout.',
    difficulty: 'Advanced',
    estimatedHours: '12 - 15 Jam',
    themeColor: const Color(0xFF6366F1),
    icon: Icons.storefront_rounded,
    techStack: [
      'Riverpod 2.x Notifier',
      'CustomScrollView & Slivers',
      'Hero & Implicit Animation',
      'Optimistic State UI',
      'Local Cart Persistence',
    ],
    architecturePoints: [
      'State Management berbasis AsyncNotifier (Riverpod) yang mendukung pull-to-refresh dan auto-dispose.',
      'Desain antarmuka performa tinggi: SliverGrid dengan cached memory builder untuk 60 FPS scrolling.',
      'Sistem Cart global yang sinkron antara badge keranjang, modal checkout, dan halaman produk.',
      'Pemisahan arsitektur feature-first: `products`, `cart`, `checkout`.',
    ],
    folderStructureTree: '''lib/
├── app.dart
├── features/
│   ├── products/
│   │   ├── data/product_repository.dart
│   │   ├── models/product_item.dart
│   │   ├── providers/products_provider.dart
│   │   └── presentation/pages/product_catalog_page.dart
│   ├── cart/
│   │   ├── models/cart_item.dart
│   │   ├── providers/cart_provider.dart
│   │   └── presentation/widgets/cart_bottom_sheet.dart
│   └── checkout/
│       ├── models/order_summary.dart
│       └── presentation/pages/checkout_page.dart
└── main.dart''',
    milestones: const [
      CapstoneMilestone(
        id: 'ecom_m1',
        title: 'Milestone 1: Dynamic Slivers & Responsive Catalog Grid',
        description:
            'Menyusun CustomScrollView dengan SliverAppBar collapsible banner dan SliverGrid produk responsif.',
        keyConcepts: ['SliverAppBar', 'SliverGrid', 'CustomScrollView'],
      ),
      CapstoneMilestone(
        id: 'ecom_m2',
        title: 'Milestone 2: Riverpod Cart Notifier & Badges',
        description:
            'Membangun CartNotifier untuk menambah, mengubah kuantitas, dan menghitung total belanja secara reaktif.',
        keyConcepts: ['AsyncNotifier', 'Ref Listen', 'Badge Floating'],
      ),
      CapstoneMilestone(
        id: 'ecom_m3',
        title: 'Milestone 3: Hero Transitions & Product Detail Sheet',
        description:
            'Membuat transisi buka detail produk dengan Hero widget dan animasi kurva halus.',
        keyConcepts: ['Hero Animation', 'ModalBottomSheet', 'ClipRRect'],
      ),
      CapstoneMilestone(
        id: 'ecom_m4',
        title: 'Milestone 4: Checkout Flow & Optimistic Order Confirmation',
        description:
            'Merancang alur pembayaran dengan pemilihan kurir, perhitungan diskon kupon, dan dialog sukses konfirmasi.',
        keyConcepts: ['Form Validation', 'Optimistic UI', 'SnackBar Action'],
      ),
    ],
    snippets: const [
      CapstoneSnippetItem(
        title: 'Riverpod Cart Notifier',
        filePath: 'lib/features/cart/providers/cart_provider.dart',
        description: 'Notifier untuk manipulasi keranjang belanja tanpa reload layar.',
        code: '''@riverpod
class CartNotifier extends _\$CartNotifier {
  @override
  Map<String, int> build() => {};

  void addItem(String productId) {
    state = {
      ...state,
      productId: (state[productId] ?? 0) + 1,
    };
  }

  void removeItem(String productId) {
    if (!state.containsKey(productId)) return;
    final current = state[productId]!;
    if (current <= 1) {
      final copy = Map<String, int>.from(state)..remove(productId);
      state = copy;
    } else {
      state = {...state, productId: current - 1};
    }
  }

  int get totalCount => state.values.fold(0, (a, b) => a + b);
}''',
      ),
    ],
    liveSimulationBuilder: (context) => const _EcommerceSimulationWidget(),
  );

  // =========================================================================
  // 3. HEALTHPULSE FITNESS DASHBOARD
  // =========================================================================
  static final CapstoneProject _healthPulseProject = CapstoneProject(
    id: 'capstone_healthpulse',
    title: 'HealthPulse Biometric & Activity Dashboard',
    tagline: 'Multi-Ring Canvas, Sensors Stream & Glassmorphism Design',
    description:
        'Aplikasi kesehatan dan kebugaran komprehensif. Menampilkan cincin aktivitas Apple Watch 3-layer (Gerak, Olahraga, Berdiri) yang digambar dengan CustomPainter, simulasi streaming sensor detak jantung real-time, dan desain Glassmorphic mutakhir.',
    difficulty: 'Advanced',
    estimatedHours: '10 - 14 Jam',
    themeColor: const Color(0xFFDB2777),
    icon: Icons.monitor_heart_rounded,
    techStack: [
      'Multi-Ring Canvas Art',
      'StreamBuilder Real-time',
      'Glassmorphic Backdrop',
      'Unit & Widget Testing (Mocktail)',
      'Adaptive Dark Theme',
    ],
    architecturePoints: [
      'Custom canvas rendering 3 busur lingkaran konsentris dengan rounded stroke caps dan bayangan dinamis.',
      'Simulasi biometrik menggunakan asynchronous Stream generator untuk pulse rate (bpm) dan calorie burn.',
      'Glassmorphism visual hierarchy: BackdropFilter sigma blur, bordered specular highlights, dan kontras gelap.',
      'Suite pengujian otomatis: Mocking sensor stream data dan verifikasi rendering widget ring.',
    ],
    folderStructureTree: '''lib/
├── core/
│   ├── theme/glassmorphism_theme.dart
│   └── sensors/sensor_stream_service.dart
├── features/
│   └── fitness/
│       ├── models/daily_activity.dart
│       ├── presentation/
│       │   ├── widgets/
│       │   │   ├── triple_activity_rings_canvas.dart
│       │   │   └── biometric_glass_card.dart
│       │   └── pages/fitness_dashboard_page.dart
└── main.dart
test/
└── features/fitness/triple_activity_rings_test.dart''',
    milestones: const [
      CapstoneMilestone(
        id: 'hp_m1',
        title: 'Milestone 1: Triple Concentric Activity Rings Painter',
        description:
            'Menulis formula trigonometri dan Canvas.drawArc untuk tiga cincin aktivitas dengan radius dan ketebalan dinamis.',
        keyConcepts: ['Trigonometry', 'drawArc', 'StrokeCap.round'],
      ),
      CapstoneMilestone(
        id: 'hp_m2',
        title: 'Milestone 2: Real-time Biometric Stream Engine',
        description:
            'Membuat simulasi sensor detak jantung berbasis periodic Stream dengan random noise realistis.',
        keyConcepts: ['Stream.periodic', 'StreamBuilder', 'Subscription Lifecycle'],
      ),
      CapstoneMilestone(
        id: 'hp_m3',
        title: 'Milestone 3: Glassmorphism Glass HUD Interface',
        description:
            'Merancang kartu metrik kaca transparan dengan BackdropFilter blur dan specular highlight borders.',
        keyConcepts: ['BackdropFilter', 'BoxDecoration Border', 'Color.withOpacity'],
      ),
      CapstoneMilestone(
        id: 'hp_m4',
        title: 'Milestone 4: Comprehensive Unit & Mocktail Tests',
        description:
            'Menulis unit test kalkulasi persentase cincin dan widget test verifikasi elemen UI.',
        keyConcepts: ['flutter_test', 'Mocktail', 'Widget Tester pump'],
      ),
    ],
    snippets: const [
      CapstoneSnippetItem(
        title: 'Concentric Rings CustomPainter',
        filePath: 'lib/features/fitness/presentation/widgets/rings_painter.dart',
        description: 'Formula render 3 busur cincin aktivitas dengan rounded ends.',
        code: '''class TripleRingsPainter extends CustomPainter {
  final double movePercent;
  final double exercisePercent;
  final double standPercent;

  TripleRingsPainter({
    required this.movePercent,
    required this.exercisePercent,
    required this.standPercent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final stroke = size.width * 0.08;

    _drawRing(canvas, center, size.width * 0.42, stroke, movePercent, Colors.redAccent);
    _drawRing(canvas, center, size.width * 0.32, stroke, exercisePercent, Colors.greenAccent);
    _drawRing(canvas, center, size.width * 0.22, stroke, standPercent, Colors.cyanAccent);
  }

  void _drawRing(Canvas c, Offset center, double r, double w, double p, Color color) {
    final bgPaint = Paint()..color = color.withOpacity(0.2)..style = PaintingStyle.stroke..strokeWidth = w;
    c.drawCircle(center, r, bgPaint);

    final fgPaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = w..strokeCap = StrokeCap.round;
    c.drawArc(Rect.fromCircle(center: center, radius: r), -1.5708, p * 6.28318, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant TripleRingsPainter old) => true;
}''',
      ),
    ],
    liveSimulationBuilder: (context) => const _HealthPulseSimulationWidget(),
  );
}

// =============================================================================
// INTERACTIVE MINI SIMULATIONS FOR THE 3 PROJECTS
// =============================================================================

class _FintechSimulationWidget extends StatefulWidget {
  const _FintechSimulationWidget();

  @override
  State<_FintechSimulationWidget> createState() => _FintechSimulationWidgetState();
}

class _FintechSimulationWidgetState extends State<_FintechSimulationWidget> {
  double _balance = 14850.50;
  String _selectedCoin = 'BTC';
  final Map<String, double> _rates = {
    'BTC': 67420.00,
    'ETH': 3580.00,
    'SOL': 182.50,
  };

  void _buyAsset() {
    setState(() {
      _balance -= 100.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order Buy \$100 $_selectedCoin Berhasil dieksekusi!'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.shield_rounded, color: Color(0xFF10B981), size: 18),
                  SizedBox(width: 6),
                  Text(
                    'FinTech Vault Simulator',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Clean Arch Active',
                  style: TextStyle(color: Color(0xFF34D399), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Total Portfolio Balance',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
          ),
          const SizedBox(height: 2),
          Text(
            '\$${_balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          // Coin Selector
          Row(
            children: _rates.keys.map((coin) {
              final isSel = _selectedCoin == coin;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text('$coin (\$' + _rates[coin]!.toStringAsFixed(0) + ')'),
                  selected: isSel,
                  onSelected: (val) {
                    if (val) setState(() => _selectedCoin = coin);
                  },
                  selectedColor: const Color(0xFF10B981),
                  labelStyle: TextStyle(
                    color: isSel ? Colors.white : Colors.grey.shade300,
                    fontSize: 11,
                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                  ),
                  backgroundColor: const Color(0xFF1E293B),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: _buyAsset,
            icon: const Icon(Icons.flash_on_rounded, size: 16),
            label: Text('Simulasi Buy \$100 $_selectedCoin via BLoC'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}

class _EcommerceSimulationWidget extends StatefulWidget {
  const _EcommerceSimulationWidget();

  @override
  State<_EcommerceSimulationWidget> createState() => _EcommerceSimulationWidgetState();
}

class _EcommerceSimulationWidgetState extends State<_EcommerceSimulationWidget> {
  int _cartCount = 2;
  double _cartTotal = 159.0;

  final List<Map<String, dynamic>> _items = [
    {'name': 'Flutter Pro Hoodie', 'price': 59.0, 'icon': Icons.checkroom_rounded},
    {'name': 'Dash Plush Toy', 'price': 25.0, 'icon': Icons.pets_rounded},
    {'name': 'Mechanical Keyboard', 'price': 75.0, 'icon': Icons.keyboard_rounded},
  ];

  void _addToCart(String name, double price) {
    setState(() {
      _cartCount++;
      _cartTotal += price;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name ditambahkan ke keranjang Riverpod!'),
        backgroundColor: const Color(0xFF6366F1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'E-Commerce Catalog Demo',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shopping_bag_rounded, size: 14, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      '$_cartCount items (\$' + _cartTotal.toStringAsFixed(0) + ')',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: _items.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  children: [
                    Icon(item['icon'] as IconData, color: const Color(0xFF818CF8), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item['name'] as String,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    Text(
                      '\$${item['price']}',
                      style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 18),
                      onPressed: () => _addToCart(item['name'] as String, item['price'] as double),
                      tooltip: 'Tambah ke Cart',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _HealthPulseSimulationWidget extends StatefulWidget {
  const _HealthPulseSimulationWidget();

  @override
  State<_HealthPulseSimulationWidget> createState() => _HealthPulseSimulationWidgetState();
}

class _HealthPulseSimulationWidgetState extends State<_HealthPulseSimulationWidget> {
  int _steps = 8420;
  int _calories = 490;
  int _bpm = 74;

  void _recordWorkout() {
    setState(() {
      _steps += 500;
      _calories += 45;
      _bpm = 112;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Workout tercatat: +500 steps, +45 kCal!'),
        backgroundColor: const Color(0xFFDB2777),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.favorite_rounded, color: Color(0xFFF43F5E), size: 18),
                  SizedBox(width: 6),
                  Text(
                    'HealthPulse Live Ring HUD',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Text(
                '$_bpm BPM',
                style: const TextStyle(
                  color: Color(0xFFFB7185),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: 'Calories',
                  val: '$_calories / 600',
                  color: const Color(0xFFF43F5E),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  label: 'Steps',
                  val: '$_steps / 10k',
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  label: 'Exercise',
                  val: '35 / 30m',
                  color: const Color(0xFF06B6D4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: _recordWorkout,
            icon: const Icon(Icons.directions_run_rounded, size: 16),
            label: const Text('Simulasi HIIT Workout Sensor (+500 Steps)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDB2777),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({required String label, required String val, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 10)),
          const SizedBox(height: 4),
          Text(
            val,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
