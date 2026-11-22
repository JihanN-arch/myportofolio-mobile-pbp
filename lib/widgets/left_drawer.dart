import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/app_text_styles.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

/// Drawer navigasi yang muncul dari sisi kiri layar.
class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Bagian header drawer.
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.carbonBlack,
              border: Border(
                bottom: BorderSide(color: AppColors.red, width: 1.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('JIHAN', style: AppTextStyles.logo),
                SizedBox(height: 8),
                Text(
                  'Explore my projects and experiences!',
                  style: TextStyle(color: AppColors.muted, fontSize: 14),
                ),
              ],
            ),
          ),

          // Bagian routing.
          ListTile(
            leading: const Icon(Icons.home_outlined, color: AppColors.white),
            title: const Text('Home'),
            // Navigasi ke halaman utama.
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.add_circle_outline,
              color: AppColors.white,
            ),
            title: const Text('Tambah Project'),
            // Navigasi ke halaman form tambah project.
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectFormPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.work_outline, color: AppColors.white),
            title: const Text("Tambah Experience"),

            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExperienceFormPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
