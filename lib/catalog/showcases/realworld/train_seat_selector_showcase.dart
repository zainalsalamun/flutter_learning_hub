import 'package:flutter/material.dart';

class TrainSeatSelectorShowcase extends StatefulWidget {
  const TrainSeatSelectorShowcase({super.key});

  @override
  State<TrainSeatSelectorShowcase> createState() =>
      _TrainSeatSelectorShowcaseState();
}

class _TrainSeatSelectorShowcaseState extends State<TrainSeatSelectorShowcase> {
  int _selectedCoach = 1;
  final Set<String> _selectedSeats = {'2A', '2B'};
  final Set<String> _bookedSeats = {'1A', '1C', '3D', '4B', '4C'};

  static const int _seatPrice = 385000;

  String _formatRupiah(int value) {
    return 'Rp ${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  void _toggleSeat(String seatCode) {
    if (_bookedSeats.contains(seatCode)) return;
    setState(() {
      if (_selectedSeats.contains(seatCode)) {
        _selectedSeats.remove(seatCode);
      } else {
        _selectedSeats.add(seatCode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _selectedSeats.length * _seatPrice;

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
                Icons.train_rounded,
                size: 18,
                color: Color(0xFF02569B),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Train Coach 2x2 Seat Selector',
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
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Text(
                  '${_selectedSeats.length} Kursi Dipilih',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D4ED8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Layout denah kursi kereta api 2x2 dengan status interaktif (Tersedia, Terisi, Dipilih) dan kalkulasi total tarif.',
            style: TextStyle(
              fontSize: 11.5,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 14),

          // Coach Switcher
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedCoach = 1),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: _selectedCoach == 1 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Eksekutif 1 (Argo Bromo)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _selectedCoach == 1
                              ? const Color(0xFF0F172A)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedCoach = 2),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: _selectedCoach == 2 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Eksekutif 2 (Panoramic)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _selectedCoach == 2
                              ? const Color(0xFF0F172A)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Seat Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend(
                color: Colors.white,
                borderColor: const Color(0xFFCBD5E1),
                label: 'Tersedia',
              ),
              const SizedBox(width: 14),
              _buildLegend(
                color: const Color(0xFF02569B),
                borderColor: const Color(0xFF02569B),
                textColor: Colors.white,
                label: 'Dipilih',
              ),
              const SizedBox(width: 14),
              _buildLegend(
                color: const Color(0xFFE2E8F0),
                borderColor: const Color(0xFFCBD5E1),
                label: 'Terisi',
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Train Interior Mockup with Rows 1 to 4
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                // Column letters header
                const Row(
                  children: [
                    SizedBox(width: 24),
                    Expanded(
                      child: Center(
                        child: Text(
                          'A',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'B',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      child: Center(
                        child: Icon(
                          Icons.swap_vert_rounded,
                          size: 14,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'C',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'D',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 4 Rows
                for (int row = 1; row <= 4; row++) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Text(
                            '$row',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                        Expanded(child: _buildSeat('${row}A')),
                        const SizedBox(width: 6),
                        Expanded(child: _buildSeat('${row}B')),
                        const SizedBox(
                          width: 26,
                          child: Center(
                            child: Text(
                              '•',
                              style: TextStyle(color: Color(0xFFCBD5E1)),
                            ),
                          ),
                        ),
                        Expanded(child: _buildSeat('${row}C')),
                        const SizedBox(width: 6),
                        Expanded(child: _buildSeat('${row}D')),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Total & Checkout Action
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatRupiah(totalPrice),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _selectedSeats.isEmpty
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Kursi ${_selectedSeats.join(", ")} siap diproses (${_formatRupiah(totalPrice)})',
                              ),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF02569B),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFCBD5E1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Pesan Kursi',
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend({
    required Color color,
    required Color borderColor,
    Color textColor = const Color(0xFF0F172A),
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: borderColor),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF475569),
          ),
        ),
      ],
    );
  }

  Widget _buildSeat(String seatCode) {
    final isBooked = _bookedSeats.contains(seatCode);
    final isSelected = _selectedSeats.contains(seatCode);

    Color bgColor = Colors.white;
    Color borderColor = const Color(0xFFCBD5E1);
    Color textColor = const Color(0xFF334155);

    if (isBooked) {
      bgColor = const Color(0xFFE2E8F0);
      borderColor = const Color(0xFFCBD5E1);
      textColor = const Color(0xFF94A3B8);
    } else if (isSelected) {
      bgColor = const Color(0xFF02569B);
      borderColor = const Color(0xFF02569B);
      textColor = Colors.white;
    }

    return InkWell(
      onTap: () => _toggleSeat(seatCode),
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 38,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        alignment: Alignment.center,
        child: Text(
          seatCode,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
