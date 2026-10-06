import 'package:flutter/material.dart';

class MovieCardShowcase extends StatefulWidget {
  const MovieCardShowcase({super.key});

  @override
  State<MovieCardShowcase> createState() => _MovieCardShowcaseState();
}

class _MovieCardShowcaseState extends State<MovieCardShowcase> {
  final Set<String> _bookmarkedIds = {'m1'};

  final List<Map<String, dynamic>> _movies = [
    {
      'id': 'm1',
      'title': 'Dune: Part Two',
      'genre': 'Sci-Fi / Adventure',
      'year': '2024',
      'rating': 8.6,
      'duration': '2j 46m',
      'synopsis':
          'Paul Atreides bersatu dengan Chani dan suku Fremen sambil membalas dendam terhadap para konspirator yang menghancurkan keluarganya.',
      'accentColor': const Color(0xFFD97706),
      'icon': Icons.public_rounded,
    },
    {
      'id': 'm2',
      'title': 'Spider-Man: Across Spider-Verse',
      'genre': 'Animation / Action',
      'year': '2023',
      'rating': 8.7,
      'duration': '2j 20m',
      'synopsis':
          'Miles Morales terlempar melintasi Multiverse, tempat ia bertemu dengan tim Spider-People yang bertugas melindungi keberadaannya.',
      'accentColor': const Color(0xFFDC2626),
      'icon': Icons.hub_rounded,
    },
    {
      'id': 'm3',
      'title': 'Oppenheimer',
      'genre': 'Biography / Drama',
      'year': '2023',
      'rating': 8.9,
      'duration': '3j 00m',
      'synopsis':
          'Kisah fisikawan teoretis J. Robert Oppenheimer yang memimpin Proyek Manhattan dalam pengembangan senjata nuklir pertama.',
      'accentColor': const Color(0xFFEA580C),
      'icon': Icons.science_rounded,
    },
  ];

  void _showMovieDetail(Map<String, dynamic> movie) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final bookmarked = _bookmarkedIds.contains(movie['id']);
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 72,
                      decoration: BoxDecoration(
                        color: (movie['accentColor'] as Color).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: (movie['accentColor'] as Color).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(
                        movie['icon'] as IconData,
                        color: movie['accentColor'] as Color,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie['title'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${movie['year']} • ${movie['duration']} • ${movie['genre']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Color(0xFFF59E0B),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${movie['rating']} / 10',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Sinopsis',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  movie['synopsis'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF475569),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            if (bookmarked) {
                              _bookmarkedIds.remove(movie['id']);
                            } else {
                              _bookmarkedIds.add(movie['id'] as String);
                            }
                          });
                          setModalState(() {});
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: bookmarked
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF0F172A),
                          side: BorderSide(
                            color: bookmarked
                                ? const Color(0xFFFCA5A5)
                                : const Color(0xFFCBD5E1),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: Icon(
                          bookmarked
                              ? Icons.bookmark_remove_rounded
                              : Icons.bookmark_add_outlined,
                          size: 18,
                        ),
                        label: Text(
                          bookmarked ? 'Hapus Watchlist' : 'Tambah Watchlist',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF02569B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.play_arrow_rounded, size: 18),
                        label: const Text(
                          'Tonton Trailer',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
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
                Icons.movie_filter_rounded,
                size: 18,
                color: Color(0xFF02569B),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Movie Discovery Card & Watchlist',
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
                  '${_bookmarkedIds.length} Tersimpan',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D4ED8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Komponen kartu film interaktif dengan rating TMDB, genre tag, toggle watchlist instan, dan preview detail modal.',
            style: TextStyle(
              fontSize: 11.5,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 14),

          // Horizontal Movie Cards List
          SizedBox(
            height: 236,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _movies.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final movie = _movies[index];
                final isBookmarked = _bookmarkedIds.contains(movie['id']);

                return Container(
                  width: 156,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster Art Mockup
                      Stack(
                        children: [
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: (movie['accentColor'] as Color).withValues(alpha: 0.12),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(11),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                movie['icon'] as IconData,
                                size: 40,
                                color: movie['accentColor'] as Color,
                              ),
                            ),
                          ),
                          // Rating Badge
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2.5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A).withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 11,
                                    color: Color(0xFFF59E0B),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${movie['rating']}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Bookmark Button
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isBookmarked) {
                                      _bookmarkedIds.remove(movie['id']);
                                    } else {
                                      _bookmarkedIds.add(movie['id'] as String);
                                    }
                                  });
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFE2E8F0),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Icon(
                                    isBookmarked
                                        ? Icons.bookmark_rounded
                                        : Icons.bookmark_border_rounded,
                                    size: 15,
                                    color: isBookmarked
                                        ? const Color(0xFFDC2626)
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Info Content
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie['title'] as String,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              movie['genre'] as String,
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _showMovieDetail(movie),
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Lihat Detail',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF334155),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
