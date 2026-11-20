import 'package:flutter/material.dart';

const _loadingBackground = Color(0xFF14211C);
const _loadingAccent = Color(0xFFE97845);
const _loadingLime = Color(0xFFD8F238);

class MountainLoadingView extends StatelessWidget {
  const MountainLoadingView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _loadingBackground,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const CustomPaint(painter: _MountainBackdropPainter()),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        color: _loadingAccent,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: _loadingAccent.withValues(alpha: 0.3),
                            blurRadius: 28,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.terrain_rounded,
                        color: Colors.white,
                        size: 46,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'NUSANTARA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.84),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const SizedBox(
                      width: 34,
                      height: 34,
                      child: CircularProgressIndicator(
                        color: _loadingLime,
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'MENYIAPKAN JELAJAH',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.58),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MountainBackdropPainter extends CustomPainter {
  const _MountainBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF263A34), _loadingBackground],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final distantMountain = Path()
      ..moveTo(0, size.height * 0.68)
      ..lineTo(size.width * 0.2, size.height * 0.38)
      ..lineTo(size.width * 0.35, size.height * 0.58)
      ..lineTo(size.width * 0.58, size.height * 0.28)
      ..lineTo(size.width * 0.83, size.height * 0.61)
      ..lineTo(size.width, size.height * 0.42)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      distantMountain,
      Paint()..color = const Color(0xFF354B43).withValues(alpha: 0.72),
    );

    final foregroundMountain = Path()
      ..moveTo(0, size.height * 0.82)
      ..lineTo(size.width * 0.22, size.height * 0.59)
      ..lineTo(size.width * 0.43, size.height * 0.78)
      ..lineTo(size.width * 0.7, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.78)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      foregroundMountain,
      Paint()..color = const Color(0xFF1D3029).withValues(alpha: 0.9),
    );

    final ridgePaint = Paint()
      ..color = _loadingLime.withValues(alpha: 0.32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final ridge = Path()
      ..moveTo(size.width * 0.2, size.height * 0.38)
      ..lineTo(size.width * 0.27, size.height * 0.48)
      ..lineTo(size.width * 0.35, size.height * 0.58)
      ..moveTo(size.width * 0.58, size.height * 0.28)
      ..lineTo(size.width * 0.67, size.height * 0.42)
      ..lineTo(size.width * 0.83, size.height * 0.61);
    canvas.drawPath(ridge, ridgePaint);
  }

  @override
  bool shouldRepaint(covariant _MountainBackdropPainter oldDelegate) => false;
}
