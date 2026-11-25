import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/app_text_styles.dart';
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/project.dart';

/// Halaman detail satu project.
class ProjectDetailPage extends StatelessWidget {
  final Project project;

  const ProjectDetailPage({super.key, required this.project});

  /// Gambar dari API bisa berupa path relatif (/static/...) atau URL penuh.
  String? get _imageUrl {
    final image = project.image;
    if (image == null || image.isEmpty) return null;
    return image.startsWith('/') ? '$apiBaseUrl$image' : image;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _imageUrl;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Project', style: AppTextStyles.logo),
        titleSpacing: 0,
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(color: AppColors.red, width: 1.5),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (imageUrl != null) ...[
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const ColoredBox(
                        color: AppColors.carbonBlack,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.red,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const ColoredBox(
                        color: AppColors.carbonBlack,
                        child: Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 48,
                            color: AppColors.muted,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            Text(project.title, style: AppTextStyles.h1),
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.category_outlined,
              label: 'Kategori',
              value: project.categoryDisplay.isEmpty
                  ? project.category
                  : project.categoryDisplay,
            ),
            _DetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Tahun',
              value: project.year?.toString() ?? '-',
            ),
            _DetailRow(
              icon: Icons.code_rounded,
              label: 'GitHub',
              value: project.githubUrl ?? '-',
            ),
            _DetailRow(
              icon: Icons.open_in_new_rounded,
              label: 'Demo',
              value: project.demoUrl ?? '-',
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                SelectableText(value, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
