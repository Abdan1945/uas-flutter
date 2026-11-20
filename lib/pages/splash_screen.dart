import 'dart:async';

import 'package:flutter/material.dart';

import '../routes/app_routing.dart';
import '../widgets/mountain_loading_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouting.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const MountainLoadingView(
        message: 'Menyiapkan informasi gunung...',
      ),
    );
  }
}
