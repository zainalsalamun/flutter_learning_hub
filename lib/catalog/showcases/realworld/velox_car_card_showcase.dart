import 'package:flutter/material.dart';

class VeloxCarCardShowcase extends StatefulWidget {
  const VeloxCarCardShowcase({super.key});

  @override
  State<VeloxCarCardShowcase> createState() => _VeloxCarCardShowcaseState();
}

class _VeloxCarCardShowcaseState extends State<VeloxCarCardShowcase> {
  String? _selectedCarId;

  final List<Map<String, dynamic>> _cars = [
    {
      'id': 'v1',
      'name': 'Hyundai IONIQ 5 Prime',
      'type': 'Electric SUV',
      'seats': 5,
      'transmission': 'Otomatis',
      'range': '481 km',
      'dailyRate': 850000,
      'rating': 4.9,
      'trips': 142,
      'accentColor': const Color(0xFF1E40AF),
      'icon': Icons.electric_car_rounded,
    },
    {
      'id': 'v2',
      'name': 'Toyota Innova Zenix Hybrid',
      'type': 'Hybrid MPV',
      'seats': 7,
      'transmission': 'CVT Otomatis',
      'range': '800 km',
      'dailyRate': 650000,
      'rating': 4.8,
      'trips': 288,
      'accentColor': const Color(0xFF0369A1),
      'icon': Icons.directions_car_rounded,
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
                Icons.directions_car_filled_rounded,
                size: 18,
                color: Color(0xFF1E40AF),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Velox Car Rental Mobility Card',
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
                child: const Text(
                  'Lepas Kunci',
                  style: TextStyle(
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
            'Kartu sewa kendaraan modern dengan spesifikasi mesin/daya, kapasitas penumpang, rating penyewa, dan pemilihan armada.',
            style: TextStyle(
              fontSize: 11.5,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 14),

          // Vehicle List
          Column(
            children: _cars.map((car) {
              final id = car['id'] as String;
              final isSelected = _selectedCarId == id;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1E40AF)
                        : const Color(0xFFE2E8F0),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row: Vehicle Name & Rating
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: (car['accentColor'] as Color)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            car['icon'] as IconData,
                            size: 24,
                            color: car['accentColor'] as Color,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                car['name'] as String,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                car['type'] as String,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${car['rating']}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              ' (${car['trips']} trip)',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Specs Pills Wrap
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _buildSpecPill(
                          Icons.people_alt_outlined,
                          '${car['seats']} Seat',
                        ),
                        _buildSpecPill(
                          Icons.speed_rounded,
                          car['transmission'] as String,
                        ),
                        _buildSpecPill(
                          Icons.bolt_rounded,
                          car['range'] as String,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Pricing & Select Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatRupiah(car['dailyRate'] as int),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const Text(
                              '/ 24 Jam • Termasuk Asuransi',
                              style: TextStyle(
                                fontSize: 9.5,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCarId = isSelected ? null : id;
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF1E40AF)
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isSelected ? 'Terpilih' : 'Pilih Unit',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF334155),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildSpecPill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF64748B)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}
