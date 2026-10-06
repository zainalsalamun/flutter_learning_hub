import 'package:flutter/material.dart';

class WargaKitaKasCardShowcase extends StatefulWidget {
  const WargaKitaKasCardShowcase({super.key});

  @override
  State<WargaKitaKasCardShowcase> createState() =>
      _WargaKitaKasCardShowcaseState();
}

class _WargaKitaKasCardShowcaseState extends State<WargaKitaKasCardShowcase> {
  bool _isPaid = false;
  int _balance = 14850000;

  final List<Map<String, dynamic>> _recentTransactions = [
    {
      'title': 'Iuran Bulanan Blok A & B',
      'category': 'Pemasukan',
      'date': '04 Okt 2026',
      'amount': 850000,
      'isIncome': true,
      'icon': Icons.arrow_downward_rounded,
    },
    {
      'title': 'Perbaikan Lampu Pos Ronda',
      'category': 'Operasional',
      'date': '02 Okt 2026',
      'amount': 240000,
      'isIncome': false,
      'icon': Icons.arrow_upward_rounded,
    },
    {
      'title': 'Dana Jimpitan Kematian',
      'category': 'Sosial',
      'date': '29 Sep 2026',
      'amount': 300000,
      'isIncome': false,
      'icon': Icons.favorite_border_rounded,
    },
  ];

  String _formatRupiah(int value) {
    return 'Rp ${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_rounded,
                size: 18,
                color: Color(0xFF0F766E),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Warga Kita Kas & Jimpitan Ledger',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: const Text(
                  'RT 04 / RW 08',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF15803D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Kartu transparansi kas warga, pencatatan iuran jimpitan digital, indikator cashflow bulanan, dan aksi bayar iuran interaktif.',
            style: TextStyle(
              fontSize: 11.5,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 14),

          // Main Treasury Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Saldo Kas RT',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _formatRupiah(_balance),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isPaid = !_isPaid;
                          if (_isPaid) {
                            _balance += 50000;
                          } else {
                            _balance -= 50000;
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _isPaid
                              ? const Color(0xFFF0FDF4)
                              : const Color(0xFF0F766E),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _isPaid
                                ? const Color(0xFFBBF7D0)
                                : const Color(0xFF0F766E),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isPaid
                                  ? Icons.check_circle_rounded
                                  : Icons.payment_rounded,
                              size: 14,
                              color: _isPaid
                                  ? const Color(0xFF15803D)
                                  : Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _isPaid ? 'Lunas (Okt)' : 'Bayar Rp 50rb',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: _isPaid
                                    ? const Color(0xFF15803D)
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Cashflow Breakdown Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.arrow_downward_rounded,
                                  size: 12,
                                  color: Color(0xFF16A34A),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'Masuk Bulan Ini',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: Color(0xFF15803D),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatRupiah(2450000),
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF166534),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.arrow_upward_rounded,
                                  size: 12,
                                  color: Color(0xFFDC2626),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'Keluar Bulan Ini',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: Color(0xFFB91C1C),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatRupiah(780000),
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF991B1B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Micro Ledger list
          const Text(
            '3 Transaksi Terakhir',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 6),
          Column(
            children: _recentTransactions.map((tx) {
              final isIncome = tx['isIncome'] as bool;
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isIncome
                            ? const Color(0xFFF0FDF4)
                            : const Color(0xFFFEF2F2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        tx['icon'] as IconData,
                        size: 14,
                        color: isIncome
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFDC2626),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx['title'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            '${tx['date']} • ${tx['category']}',
                            style: const TextStyle(
                              fontSize: 9.5,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${isIncome ? '+' : '-'} ${_formatRupiah(tx['amount'] as int)}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isIncome
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFDC2626),
                      ),
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
