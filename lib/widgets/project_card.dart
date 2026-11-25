import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

/// Model untuk setiap tombol aksi di halaman utama.
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;
  final Color foregroundColor;
  final Color? borderColor;
  final Widget? page;

  /// True jika halaman tujuan hanya boleh dibuka setelah login.
  final bool requiresLogin;

  /// True untuk tombol Logout.
  final bool isLogout;

  const ItemHomepage(
    this.name,
    this.icon,
    this.color, {
    this.foregroundColor = AppColors.white,
    this.borderColor,
    this.page,
    this.requiresLogin = false,
    this.isLogout = false,
  });
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  void _showSnackBar(ScaffoldMessengerState messenger, String message) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _logout(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final auth = context.read<AuthState>();

    if (!auth.isLoggedIn) {
      _showSnackBar(messenger, 'Kamu belum login.');
      return;
    }
    await auth.logout();
    _showSnackBar(messenger, 'Berhasil logout. Sampai jumpa!');
  }

  Future<void> _onTap(BuildContext context) async {
    if (item.isLogout) {
      await _logout(context);
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    _showSnackBar(messenger, "Kamu telah menekan tombol ${item.name}!");

    final page = item.page;
    if (page == null) return;

    if (item.requiresLogin && !await ensureLoggedIn(context)) return;

    navigator.push(MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = item.borderColor;

    return Material(
      color: item.color,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        side: borderColor == null
            ? BorderSide.none
            : BorderSide(color: borderColor, width: 1.5),
      ),
      child: InkWell(
        onTap: () => _onTap(context),
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
