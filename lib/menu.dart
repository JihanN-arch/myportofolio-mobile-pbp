import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/screens/experience_page.dart';
import 'package:myportofolio_mobile/screens/expertise_page.dart';
import 'package:myportofolio_mobile/screens/project_page.dart';

//!! AI ATTRIBUTION & ASSISTANCE
//!! - UI Styling & Widget Design : Assisted by Claude AI for visual styling & layout refinement
//!! - Code Refactoring           : Claude AI-assisted optimization for widget hierarchy & relationships
//!! - Logic & Flow Debugging     : Assisted by Claude AI for troubleshooting application logic

/// Model untuk setiap tombol aksi di halaman utama.
class ItemHomepage {
  final String name;
  final IconData icon;

  final Color color;

  final Color foregroundColor;

  final Color? borderColor;

  final Widget? page;

  const ItemHomepage(
    this.name,
    this.icon,
    this.color, {
    this.foregroundColor = AppColors.white,
    this.borderColor,
    this.page,
  });
}

// Halaman utama
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  final String npm = "2506549026";
  final String nama = "Jihan Nabiilah Permata Sukma";
  final String jurusan = "Computer Science";
  final String kelas = "PBP C";

  final List<ItemHomepage> items = const [
    // projek
    ItemHomepage(
      "Lihat Projects",
      Icons.folder_rounded,
      AppColors.red,
      page: ProjectsPage(),
    ),
    // experise
    ItemHomepage(
      "Lihat Expertise",
      Icons.bolt_rounded,
      AppColors.gold,
      foregroundColor: AppColors.black,
      page: ExpertisePage(),
    ),
    // experience
    ItemHomepage(
      "Lihat Experience",
      Icons.work_rounded,
      AppColors.green,
      foregroundColor: AppColors.black,
      page: ExperiencePage(),
    ),

    // logout
    ItemHomepage(
      "Logout",
      Icons.logout_rounded,
      AppColors.carbonBlack,
      foregroundColor: AppColors.pinkRed,
      borderColor: AppColors.pinkRed,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'JIHAN',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 4),
        ),
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(color: AppColors.red, width: 1.5),
        ),
      ),
      // SingleChildScrollView biar halaman bisa digulir
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            HeroSection(name: nama),
            const SizedBox(height: 24),

            // Tiga IngfoCard
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: InfoCard(title: 'NPM', content: npm),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InfoCard(title: 'Jurusan', content: jurusan),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InfoCard(title: 'Class', content: kelas),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            const Text(
              'MENU',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.muted,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 12),

            // Wrap 3 kolom
            LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 12.0;
                final itemWidth = ((constraints.maxWidth - spacing * 2) / 3)
                    .floorToDouble();
                return Wrap(
                  alignment: WrapAlignment.center,
                  spacing: spacing,
                  runSpacing: spacing,
                  children: items.map((ItemHomepage item) {
                    return SizedBox(
                      width: itemWidth,
                      height: itemWidth,
                      child: ItemCard(item),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

///   Hero section ikutin web
class HeroSection extends StatelessWidget {
  final String name;

  const HeroSection({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'HEY, MY NAME IS....',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.green,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.red,
            fontSize: 30,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 20),
        // Foto profil
        Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.white, width: 3),
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [
                BoxShadow(color: AppColors.red, offset: Offset(14, 14)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'assets/images/noodle.jpg',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        const Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
            children: [
              TextSpan(
                text: 'RESISTANT. ',
                style: TextStyle(color: AppColors.white),
              ),
              TextSpan(
                text: 'CREATIVITY. ',
                style: TextStyle(color: AppColors.green),
              ),
              TextSpan(
                text: 'NOLIFE.',
                style: TextStyle(color: AppColors.white),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Kartu kecil buat nampilininformasi profil
class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.fromBorderSide(BorderSide(color: AppColors.border)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(fontSize: 11, letterSpacing: 1.5),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu tombol aksi. Warna dan perilakunya diatur lewat [ItemHomepage].
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final borderColor = item.borderColor;

    return Material(
      // Warna latar diambil dari atribut color milik ItemHomepage.
      color: item.color,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        side: borderColor == null
            ? BorderSide.none
            : BorderSide(color: borderColor, width: 1.5),
      ),
      child: InkWell(
        onTap: () {
          // Menampilkan SnackBar sesuai nama tombol yang ditekan.
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!"),
              ),
            );

          // Pindah ke halaman tujuan jika tombol punya halaman.
          final page = item.page;
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, color: item.foregroundColor, size: 30),
              const SizedBox(height: 6),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: item.foregroundColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
