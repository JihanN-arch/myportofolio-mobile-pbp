import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/app_text_styles.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

//!! AI ATTRIBUTION & ASSISTANCE
//!! - UI Styling & Widget Design : Assisted by Claude AI for layout refinement

enum DrawerDestination { home, addProject, addExperience }

class LeftDrawer extends StatelessWidget {
  final DrawerDestination current;

  const LeftDrawer({super.key, this.current = DrawerDestination.home});

  void _navigate(
    BuildContext context,
    DrawerDestination destination,
    Widget page,
  ) {
    if (destination == current) {
      Navigator.pop(context);
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.red,
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
                  style: TextStyle(color: AppColors.white, fontSize: 14),
                ),
              ],
            ),
          ),

          _DrawerItem(
            icon: Icons.home_outlined,
            label: 'Home',
            selected: current == DrawerDestination.home,
            onTap: () =>
                _navigate(context, DrawerDestination.home, const MyHomePage()),
          ),
          _DrawerItem(
            icon: Icons.add_circle_outline,
            label: 'Tambah Project',
            selected: current == DrawerDestination.addProject,
            onTap: () => _navigate(
              context,
              DrawerDestination.addProject,
              const ProjectFormPage(),
            ),
          ),
          _DrawerItem(
            icon: Icons.work_outline,
            label: 'Tambah Experience',
            selected: current == DrawerDestination.addExperience,
            onTap: () => _navigate(
              context,
              DrawerDestination.addExperience,
              const ExperienceFormPage(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.red : AppColors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 2,
                color: selected ? AppColors.red : Colors.transparent,
              ),
            ],
          ),
        ),
        hoverColor: AppColors.white.withAlpha(15),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        onTap: onTap,
      ),
    );
  }
}
