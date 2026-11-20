import 'dart:ui';
import 'package:flutter/material.dart';

import '../routes/app_routing.dart';

const _paperBackground = Color(0xFFF3F0E7);
const _inkColor = Color(0xFF17201B);
const _navigationAccent = Color(0xFFE97845);

class MountainBottomNavigationBar extends StatelessWidget {
  const MountainBottomNavigationBar({super.key, required this.currentIndex});

  final int currentIndex;

  static const _routes = [
    AppRouting.home,
    AppRouting.search,
    AppRouting.wishlist,
    AppRouting.about,
  ];
  static const _items = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.search_rounded, label: 'Cari'),
    (icon: Icons.favorite_rounded, label: 'Wishlist'),
    (icon: Icons.person_rounded, label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        // Efek blur kaca agar konten di belakangnya terlihat samar & menyatu
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            // Warna krem halaman Home yang dibuat semi-transparan
            color: _paperBackground.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: _inkColor.withValues(alpha: 0.08),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: List.generate(_items.length, (index) {
                  final item = _items[index];
                  final selected = index == currentIndex;
                  return Expanded(
                    child: Semantics(
                      button: true,
                      label: item.label,
                      selected: selected,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          if (selected) {
                            return;
                          }
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            _routes[index],
                            (route) => false,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          decoration: BoxDecoration(
                            color: selected
                                ? _navigationAccent.withValues(alpha: 0.14)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                item.icon,
                                color: selected
                                    ? _navigationAccent
                                    : _inkColor.withValues(alpha: 0.55),
                                size: 21,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                item.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: selected
                                      ? _inkColor
                                      : _inkColor.withValues(alpha: 0.55),
                                  fontSize: 10,
                                  fontWeight: selected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}