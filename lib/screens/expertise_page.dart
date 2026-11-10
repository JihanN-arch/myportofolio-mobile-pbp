import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/widgets/section_placeholder.dart';

/// Halaman Expertise (hanya tampil, tanpa CRUD).
class ExpertisePage extends StatelessWidget {
  const ExpertisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionPlaceholder(
      title: 'Expertise',
      description: 'Espertise bkl tampil disini',
      icon: Icons.bolt_rounded,
      accent: AppColors.gold,
    );
  }
}
