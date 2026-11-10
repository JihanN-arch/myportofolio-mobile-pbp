import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/widgets/section_placeholder.dart';

/// Halaman Projects (nantinya full CRUD).
class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionPlaceholder(
      title: 'Projects',
      description: 'Ntar daftar proyek bakal tampil di sini.',
      icon: Icons.folder_rounded,
      accent: AppColors.red,
      onAccent: AppColors.white,
      addLabel: 'Tambah Project',
    );
  }
}
