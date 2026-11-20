import 'package:flutter/material.dart';

import '../models/volcano_model.dart';
import '../routes/app_routing.dart';
import '../services/volcano_image_service.dart';
import '../services/wishlist_service.dart';
import '../widgets/mountain_bottom_navigation_bar.dart';
import '../widgets/mountain_loading_view.dart';
import '../widgets/volcano_favorite_button.dart';

const _wishlistPaper = Color(0xFFF3F0E7);
const _wishlistInk = Color(0xFF17201B);
const _wishlistOrange = Color(0xFFE97845);
const _wishlistOlive = Color(0xFF56614C);

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  static final _wishlist = WishlistService.instance;
  static final _imageService = VolcanoImageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _wishlistPaper,
      bottomNavigationBar: const MountainBottomNavigationBar(currentIndex: 2),
      body: FutureBuilder<void>(
        future: _wishlist.ready,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MountainLoadingView(message: 'Memuat wishlist...');
          }
          if (snapshot.hasError) {
            return _buildError();
          }
          return AnimatedBuilder(
            animation: _wishlist,
            builder: (context, child) {
              final volcanoes = _wishlist.items;
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader(volcanoes.length)),
                  if (volcanoes.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildEmptyState(context),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              _buildVolcanoCard(context, volcanoes[index]),
                          childCount: volcanoes.length,
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(int count) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 58, 24, 28),
      decoration: const BoxDecoration(
        color: _wishlistInk,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.favorite_rounded, color: _wishlistOrange, size: 28),
          const SizedBox(height: 18),
          const Text(
            'Gunung\nFavorit Saya',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              height: 1.05,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$count gunung tersimpan',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: _wishlistOrange.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                color: _wishlistOrange,
                size: 40,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Wishlist masih kosong',
              style: TextStyle(
                color: _wishlistInk,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tekan ikon hati pada gunung yang ingin kamu simpan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _wishlistInk.withValues(alpha: 0.62),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(AppRouting.home, (route) => false);
              },
              style: FilledButton.styleFrom(
                backgroundColor: _wishlistOrange,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.explore_rounded),
              label: const Text('Jelajahi gunung'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolcanoCard(BuildContext context, Volcano volcano) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            Navigator.pushNamed(context, AppRouting.detail, arguments: volcano);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 96,
                    height: 104,
                    child: FutureBuilder<String>(
                      future: _imageService.getImageUrl(volcano),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const ColoredBox(
                            color: Color(0xFFE3E1D8),
                            child: Icon(
                              Icons.landscape_rounded,
                              color: _wishlistOlive,
                              size: 32,
                            ),
                          );
                        }
                        return Image.network(
                          snapshot.data!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const ColoredBox(
                              color: Color(0xFFE3E1D8),
                              child: Icon(
                                Icons.landscape_rounded,
                                color: _wishlistOlive,
                                size: 32,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        volcano.nama,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _wishlistInk,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        volcano.bentuk,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _wishlistOlive,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        volcano.tinggiMeter,
                        style: TextStyle(
                          color: _wishlistInk.withValues(alpha: 0.58),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                VolcanoFavoriteButton(volcano: volcano, size: 38),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Wishlist tidak dapat dimuat. Coba buka ulang halaman.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}