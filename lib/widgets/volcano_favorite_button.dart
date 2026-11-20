import 'package:flutter/material.dart';

import '../models/volcano_model.dart';
import '../services/wishlist_service.dart';

class VolcanoFavoriteButton extends StatelessWidget {
  const VolcanoFavoriteButton({
    super.key,
    required this.volcano,
    this.size = 42,
    this.showLabel = false,
  });

  final Volcano volcano;
  final double size;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final wishlist = WishlistService.instance;
    return AnimatedBuilder(
      animation: wishlist,
      builder: (context, child) {
        final isFavorite = wishlist.contains(volcano);
        Future<void> toggle() async {
          try {
            await wishlist.toggle(volcano);
          } on Exception catch (error) {
            if (!context.mounted) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Wishlist gagal diperbarui: $error')),
            );
          }
        }

        if (showLabel) {
          return SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: toggle,
              icon: Icon(
                isFavorite ? Icons.favorite_rounded : Icons.favorite_border,
              ),
              label: Text(
                isFavorite ? 'Tersimpan di wishlist' : 'Tambahkan ke wishlist',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: isFavorite
                    ? const Color(0xFFE97845)
                    : const Color(0xFF17201B),
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: isFavorite
                      ? const Color(0xFFE97845)
                      : const Color(0xFF56614C),
                ),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          );
        }

        return Material(
          color: Colors.white.withValues(alpha: 0.94),
          shape: const CircleBorder(),
          child: IconButton(
            tooltip: isFavorite
                ? 'Hapus dari wishlist'
                : 'Tambahkan ke wishlist',
            constraints: BoxConstraints.tightFor(width: size, height: size),
            padding: EdgeInsets.zero,
            onPressed: toggle,
            icon: Icon(
              isFavorite ? Icons.favorite_rounded : Icons.favorite_border,
              color: isFavorite
                  ? const Color(0xFFE97845)
                  : const Color(0xFF303A32),
              size: 21,
            ),
          ),
        );
      },
    );
  }
}