import 'dart:math';
import 'package:flutter/material.dart';

import '../models/volcano_model.dart';
import '../routes/app_routing.dart';
import '../services/volcano_image_service.dart';
import '../services/volcano_service.dart';
import '../widgets/mountain_bottom_navigation_bar.dart';
import '../widgets/mountain_loading_view.dart';
import '../widgets/volcano_favorite_button.dart';

const _inkColor = Color(0xFF17201B);
const _paperColor = Color(0xFFF3F0E7);
const _orangeColor = Color(0xFFE97845);
const _oliveColor = Color(0xFF56614C);
const _homeImageUrl =
    'https://thumb.wikimedia.org/wikipedia/commons/thumb/c/cd/Gunung_Merapi_from_Merbabu.jpg/960px-Gunung_Merapi_from_Merbabu.jpg';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.currentIndex = 0, this.focusSearch = false});

  final int currentIndex;
  final bool focusSearch;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final VolcanoService _volcanoService = VolcanoService();
  final VolcanoImageService _volcanoImageService = VolcanoImageService();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Volcano>> _futureVolcanoes;
  String _searchQuery = '';
  String _selectedShape = 'Semua';

  @override
  void initState() {
    super.initState();
    _futureVolcanoes = _volcanoService.fetchVolcanoes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadData() {
    setState(() {
      _futureVolcanoes = _volcanoService.fetchVolcanoes();
    });
  }

  void _openRandomVolcano(List<Volcano> volcanoes) {
    if (volcanoes.isEmpty) return;
    final randomVolcano = volcanoes[Random().nextInt(volcanoes.length)];
    Navigator.pushNamed(context, AppRouting.detail, arguments: randomVolcano);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _paperColor,
      body: FutureBuilder<List<Volcano>>(
        future: _futureVolcanoes,
        builder: (context, snapshot) {
          final volcanoes = snapshot.data ?? [];

          return Stack(
            children: [
              if (snapshot.connectionState == ConnectionState.waiting)
                const MountainLoadingView(message: 'Memuat data gunung...')
              else if (snapshot.hasError)
                _buildErrorState()
              else if (volcanoes.isEmpty)
                const Center(child: Text('Data gunung berapi kosong.'))
              else () {
                final filteredVolcanoes = volcanoes.where((volcano) {
                  final query = _searchQuery.toLowerCase();
                  final nameMatches = volcano.nama.toLowerCase().contains(query);
                  final shapeMatches = volcano.bentuk.toLowerCase().contains(query);
                  final categoryMatches =
                      _selectedShape == 'Semua' ||
                      volcano.bentuk.toLowerCase().contains(
                        _selectedShape.toLowerCase(),
                      );
                  return (nameMatches || shapeMatches) && categoryMatches;
                }).toList();

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildHero(context, volcanoes.length)),
                    SliverToBoxAdapter(child: _buildSearchField()),
                    SliverToBoxAdapter(child: _buildShapeFilters()),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Jelajahi gunung',
                                style: TextStyle(
                                  color: _inkColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              '${filteredVolcanoes.length} lokasi',
                              style: TextStyle(
                                color: _inkColor.withValues(alpha: 0.58),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (filteredVolcanoes.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(
                            'Gunung tidak ditemukan.',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 170),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                _buildVolcanoCard(context, filteredVolcanoes[index]),
                            childCount: filteredVolcanoes.length,
                          ),
                        ),
                      ),
                  ],
                );
              }(),

              // 1. Floating Card Interaktif (Gunung Acak Pilihan)
              Positioned(
                left: 20,
                right: 20,
                bottom: 86,
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  elevation: 6,
                  shadowColor: Colors.black26,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _openRandomVolcano(volcanoes),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: _orangeColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.casino_rounded,
                              color: _orangeColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gunung Acak Pilihan',
                                  style: TextStyle(
                                    color: _inkColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Bingung mau jelajahi mana dulu?',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: _orangeColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 2. Mountain Bottom Navigation Bar Melayang di Paling Bawah
              const Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: MountainBottomNavigationBar(currentIndex: 0),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHero(BuildContext context, int volcanoCount) {
    return SizedBox(
      height: 390,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            _homeImageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(color: _inkColor);
            },
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x990B1410),
                  Color(0x160B1410),
                  Color(0xF20B1410),
                ],
                stops: [0, 0.38, 1],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 16,
            child: Row(
              children: [
                const Icon(Icons.landscape_rounded, color: _orangeColor),
                const SizedBox(width: 7),
                const Text(
                  'NUSANTARA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                _RoundActionButton(
                  icon: Icons.info_outline_rounded,
                  tooltip: 'Tentang aplikasi',
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouting.about);
                  },
                ),
              ],
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
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: _orangeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$volcanoCount GUNUNG TERDATA',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Temukan\npuncak Nusantara',
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
                const SizedBox(height: 10),
                Text(
                  'Jelajahi gunung berapi dan cerita di baliknya.',
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

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      child: TextField(
        controller: _searchController,
        autofocus: widget.focusSearch,
        onChanged: (value) => setState(() => _searchQuery = value),
        style: const TextStyle(color: _inkColor, fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Cari nama atau bentuk gunung...',
          hintStyle: TextStyle(color: _inkColor.withValues(alpha: 0.48)),
          prefixIcon: const Icon(Icons.search_rounded, color: _oliveColor),
          suffixIcon: _searchQuery.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildShapeFilters() {
    const categories = ['Semua', 'Stratovulkan', 'Kompleks', 'Perisai'];
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = _selectedShape == category;
          return ChoiceChip(
            label: Text(category),
            selected: selected,
            showCheckmark: false,
            onSelected: (_) => setState(() => _selectedShape = category),
            selectedColor: _oliveColor,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: selected ? Colors.white : _inkColor.withValues(alpha: 0.7),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          );
        },
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
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        FutureBuilder<String>(
                          future: _volcanoImageService.getImageUrl(volcano),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const ColoredBox(
                                color: Color(0xFFE3E1D8),
                                child: Icon(
                                  Icons.landscape_rounded,
                                  color: _oliveColor,
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
                                    color: _oliveColor,
                                    size: 32,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: VolcanoFavoriteButton(
                            volcano: volcano,
                            size: 34,
                          ),
                        ),
                      ],
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
                          color: _inkColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECEFE7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          volcano.bentuk,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _oliveColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ketinggian  ${volcano.tinggiMeter}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // <-- DIPERBAIKI DI SINI
                        style: TextStyle(
                          color: _inkColor.withValues(alpha: 0.58),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _orangeColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: _orangeColor, size: 54),
            const SizedBox(height: 14),
            const Text(
              'Data gunung berapi belum dapat dimuat.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _inkColor,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _loadData,
              style: FilledButton.styleFrom(
                backgroundColor: _orangeColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  const _RoundActionButton({
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