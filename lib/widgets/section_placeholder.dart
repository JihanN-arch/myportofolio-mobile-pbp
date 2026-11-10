import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/app_colors.dart';

/// Halaman sementara untuk setiap bagian portofolio.
/// ntar isinya diganti dengan daftar data dan fitur CRUD.
class SectionPlaceholder extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color accent;
  final Color onAccent;

  /// Label tombol tambah. Null untuk bagian yang tidak bisa ditambah.
  final String? addLabel;

  const SectionPlaceholder({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
    this.onAccent = AppColors.black,
    this.addLabel,
  });

  @override
  Widget build(BuildContext context) {
    final label = addLabel;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        shape: Border(bottom: BorderSide(color: accent, width: 1.5)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: accent),
              const SizedBox(height: 16),
              Text(
                'Ini halaman $title',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.muted),
              ),
              if (label != null) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('Kamu telah menekan tombol $label!'),
                        ),
                      );
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: Text(label),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: onAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
