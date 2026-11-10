import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/widgets/section_placeholder.dart';

/// Halaman Experience (nantinya full CRUD).
class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionPlaceholder(
      title: 'Experience',
      description: 'Y ntar experience muncul disni',
      icon: Icons.work_rounded,
      accent: AppColors.green,
      addLabel: 'Tambah Experience',
    );
  }
}
