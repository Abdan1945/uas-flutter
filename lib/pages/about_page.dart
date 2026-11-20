import 'package:flutter/material.dart';

import '../constants/api_constant.dart';
import '../widgets/mountain_bottom_navigation_bar.dart';

const _inkColor = Color(0xFF17201B);
const _paperColor = Color(0xFFF3F0E7);
const _orangeColor = Color(0xFFE97845);
const _oliveColor = Color(0xFF56614C);
const _heroImageUrl =
    'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1200&q=85';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _paperColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHero(context)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Label Section
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: _orangeColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'TENTANG APLIKASI',
                          style: TextStyle(
                            color: _oliveColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Kartu 1: Deskripsi Aplikasi
                    _buildCleanCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Jelajahi gunung berapi Indonesia',
                            style: TextStyle(
                              color: _inkColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Temukan informasi lengkap mengenai gunung berapi di Nusantara, mulai dari bentuk, ketinggian, catatan letusan terakhir, hingga lokasi geografisnya dalam satu genggaman.',
                            style: TextStyle(
                              color: _inkColor.withValues(alpha: 0.72),
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _FeatureTag(
                                icon: Icons.terrain_rounded,
                                label: 'Data Gunung',
                              ),
                              _FeatureTag(
                                icon: Icons.location_on_outlined,
                                label: 'Info Daerah',
                              ),
                              _FeatureTag(
                                icon: Icons.photo_library_outlined,
                                label: 'Galeri Foto',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Kartu 2: Profil Pembuat
                    _buildCleanCard(
                      child: Row(
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: _orangeColor.withValues(alpha: 0.14),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: _orangeColor,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'DIBUAT OLEH',
                                  style: TextStyle(
                                    color: _orangeColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Ghoyatul Abdan Kariman',
                                  style: TextStyle(
                                    color: _inkColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFECEFE7),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'Absen 11  •  Kelas XII RPL 3',
                                    style: TextStyle(
                                      color: _oliveColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Kartu 3: Sumber Data API
                    _buildCleanCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.api_rounded,
                                color: _oliveColor,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Sumber Data API',
                                style: TextStyle(
                                  color: _inkColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Data diambil secara dinamis melalui layanan REST API gunung berapi Indonesia:',
                            style: TextStyle(
                              color: _inkColor.withValues(alpha: 0.68),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _paperColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _inkColor.withValues(alpha: 0.08),
                              ),
                            ),
                            child: SelectableText(
                              ApiConstant.fullVolcanoesUrl,
                              style: const TextStyle(
                                color: _oliveColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Footer
                    Center(
                      child: Text(
                        'JELAJAHI DENGAN BIJAK  •  JAGA ALAM INDONESIA',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _inkColor.withValues(alpha: 0.45),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),

          // Floating Bottom Navigation Bar (Konsisten dengan HomePage)
          const Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: MountainBottomNavigationBar(currentIndex: 3),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            _heroImageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(
                color: _inkColor,
                child: Icon(
                  Icons.landscape_rounded,
                  color: Colors.white54,
                  size: 72,
                ),
              );
            },
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x880B1410),
                  Color(0x140B1410),
                  Color(0xEB0B1410),
                ],
                stops: [0, 0.4, 1],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
              child: IconButton(
                tooltip: 'Kembali',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _orangeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'INDONESIA  •  VOLCANO EXPLORER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Kenali\nJejak Gunung',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    height: 1.04,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 16,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Informasi gunung berapi dari berbagai penjuru Nusantara.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.86),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCleanCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: _inkColor.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FeatureTag extends StatelessWidget {
  const _FeatureTag({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFECEFE7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _oliveColor, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: _oliveColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}