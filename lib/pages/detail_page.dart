import 'package:flutter/material.dart';

import '../models/volcano_model.dart';
import '../services/volcano_image_service.dart';
import '../services/volcano_location_service.dart';
import '../widgets/mountain_bottom_navigation_bar.dart';
import '../widgets/volcano_favorite_button.dart';

const _detailPaperColor = Color(0xFFF3F0E7);
const _detailInkColor = Color(0xFF17201B);
const _detailOrangeColor = Color(0xFFE97845);
const _detailOliveColor = Color(0xFF56614C);

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  static final _locationService = VolcanoLocationService();

  @override
  Widget build(BuildContext context) {
    final volcano = ModalRoute.of(context)!.settings.arguments as Volcano;
    final imageUrl = VolcanoImageService().getImageUrl(volcano);
    final area = _locationService.getAdministrativeArea(volcano);

    return Scaffold(
      backgroundColor: _detailPaperColor,
      bottomNavigationBar: const MountainBottomNavigationBar(currentIndex: -1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHero(context, volcano, imageUrl),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  VolcanoFavoriteButton(volcano: volcano, showLabel: true),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: _detailOrangeColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'RINGKASAN GUNUNG',
                        style: TextStyle(
                          color: _detailOliveColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.height_rounded,
                          label: 'KETINGGIAN',
                          value: volcano.tinggiMeter,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.history_rounded,
                          label: 'LETUSAN TERAKHIR',
                          value: volcano.estimasiLetusanTerakhir,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildAreaCard(area),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tentang gunung ini',
                          style: TextStyle(
                            color: _detailInkColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _buildDescription(volcano),
                          style: TextStyle(
                            color: _detailInkColor.withValues(alpha: 0.72),
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECEFE7),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            'Bentuk: ${volcano.bentuk}',
                            style: const TextStyle(
                              color: _detailOliveColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoTile(
                    icon: Icons.location_on_outlined,
                    title: 'Koordinat',
                    value: volcano.geolokasi,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(
    BuildContext context,
    Volcano volcano,
    Future<String> imageUrl,
  ) {
    return SizedBox(
      height: 370,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FutureBuilder<String>(
            future: imageUrl,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const ColoredBox(color: _detailInkColor);
              }
              return Image.network(
                snapshot.data!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const ColoredBox(
                    color: _detailInkColor,
                    child: Icon(
                      Icons.landscape_rounded,
                      color: Colors.white54,
                      size: 72,
                    ),
                  );
                },
              );
            },
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x770B1410),
                  Color(0x080B1410),
                  Color(0xE60B1410),
                ],
                stops: [0, 0.38, 1],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: _HeroActionButton(
              icon: Icons.arrow_back_rounded,
              tooltip: 'Kembali',
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
          Positioned(
            left: 22,
            right: 22,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _detailOrangeColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'VOLCANO PROFILE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  volcano.nama,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    height: 1.05,
                    fontWeight: FontWeight.w800,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 16,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Jelajahi bentang alam Indonesia',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.84),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      height: 126,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _detailOrangeColor, size: 21),
          const Spacer(),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _detailInkColor.withValues(alpha: 0.52),
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _detailInkColor,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaCard(Future<String?> area) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _detailOliveColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.place_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DAERAH ASAL',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                FutureBuilder<String?>(
                  future: area,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text(
                        'Daerah tidak dapat dimuat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        'Mencari daerah...',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      );
                    }
                    return Text(
                      snapshot.data ?? 'Daerah tidak tersedia',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildDescription(Volcano volcano) {
    final sentences = <String>[
      '${volcano.nama} merupakan gunung berapi.',
      if (_hasValue(volcano.bentuk))
        'Bentuknya ${volcano.bentuk.toLowerCase()}.',
      if (_hasValue(volcano.tinggiMeter))
        'Ketinggiannya ${volcano.tinggiMeter}.',
      if (_hasValue(volcano.estimasiLetusanTerakhir))
        'Catatan letusan terakhir: ${volcano.estimasiLetusanTerakhir}.',
      if (_hasValue(volcano.geolokasi)) 'Koordinatnya ${volcano.geolokasi}.',
    ];

    return sentences.join(' ');
  }

  bool _hasValue(String value) =>
      value.trim().isNotEmpty && value != '-' && value.toLowerCase() != 'n/a';

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFECEFE7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: _detailOliveColor, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    color: _detailInkColor.withValues(alpha: 0.52),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: _detailInkColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroActionButton extends StatelessWidget {
  const _HeroActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.28),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24),
      ),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }
}