// voice_fab.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_theme.dart';
import 'voice_page.dart';

class VoiceFAB extends StatelessWidget {
  const VoiceFAB({super.key});

  void _openVoicePage() {
    Get.to(() => const VoicePage());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 56.0), // Positions FAB above bottom navigation
      child: FloatingActionButton(
        onPressed: _openVoicePage,
        backgroundColor: AppTheme.accentOrange,
        elevation: 8,
        child: const Icon(Icons.mic_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}