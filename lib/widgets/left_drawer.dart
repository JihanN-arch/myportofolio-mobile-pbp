import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/app_text_styles.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

enum DrawerDestination { home, addProject, addExperience }

class LeftDrawer extends StatelessWidget {
  final DrawerDestination current;

  const LeftDrawer({super.key, this.current = DrawerDestination.home});

  Future<void> _navigate(
    BuildContext context,
    DrawerDestination destination,
    Widget page, {
    bool requiresLogin = false,
  }) async {
    if (destination == current) {
      Navigator.pop(context);
      return;
    }

    final navigator = Navigator.of(context);
    if (requiresLogin && !await ensureLoggedIn(context)) return;

    navigator.pushReplacement(MaterialPageRoute(builder: (context) => page));
  }

  Future<void> _login(BuildContext context) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    navigator.pop();
    final loggedIn = await navigator.push<bool>(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
    if (loggedIn == true) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Login berhasil!')));
    }
  }

  Future<void> _logout(BuildContext context) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final auth = context.read<AuthState>();

    navigator.pop();
    await auth.logout();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Berhasil logout.')));
  }

  @override
  Widget build(BuildContext context) {
    // watch: drawer otomatis dibangun ulang saat status login berubah.
    final auth = context.watch<AuthState>();

    return Drawer(
      backgroundColor: AppColors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.red,
              border: Border(
                bottom: BorderSide(color: AppColors.red, width: 1.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('JIHAN', style: AppTextStyles.logo),
                const SizedBox(height: 8),
                Text(
                  auth.isLoggedIn
                      ? 'Login sebagai ${auth.username}'
                      : 'Explore my projects and experiences!',
                  style: const TextStyle(color: AppColors.muted, fontSize: 14),
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
              requiresLogin: true,
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
              requiresLogin: true,
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Divider(color: AppColors.border),
          ),

          if (auth.isLoggedIn)
            _DrawerItem(
              icon: Icons.logout_rounded,
              label: 'Logout',
              selected: false,
              onTap: () => _logout(context),
            )
          else
            _DrawerItem(
              icon: Icons.login_rounded,
              label: 'Login',
              selected: false,
              onTap: () => _login(context),
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
