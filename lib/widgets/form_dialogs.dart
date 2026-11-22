import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/screens/menu.dart';

/// isian yg buat ditampilkn
class SummaryItem {
  final IconData icon;
  final String label;
  final String value;

  const SummaryItem(this.icon, this.label, this.value);
}

/// Menampilkan dialog ringkasan isian form.
void showSummaryDialog(
  BuildContext context, {
  required String title,
  required Color accent,
  required List<SummaryItem> items,
  required VoidCallback onClose,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: AppColors.carbonBlack,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: accent, width: 1.5),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: accent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(color: accent.withAlpha(120), height: 1),
              const SizedBox(height: 10),
              ...items.map((item) => _SummaryRow(item: item, accent: accent)),
            ],
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: accent),
            onPressed: () {
              Navigator.pop(dialogContext);
              onClose();
            },
            child: const Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}

class _SummaryRow extends StatelessWidget {
  final SummaryItem item;
  final Color accent;

  const _SummaryRow({required this.item, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, color: accent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(item.value, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//!! AI ATTRIBUTION & ASSISTANCE
//!! - UI Styling & Widget Design : Assisted by Claude AI for visual styling & layout refinement
//!! - Code Refactoring           : Claude AI-assisted optimization for widget hierarchy & relationships

/// Menanyakan apakah pengguna yakin keluar dari form yang sudah diisi.
/// Mengembalikan true jika pengguna memilih "Buang".
Future<bool> showDiscardChangesDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: AppColors.carbonBlack,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        title: const Text(
          'Buang perubahan?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: AppColors.border, height: 1),
            SizedBox(height: 12),
            Text('Isian form belum disimpan dan akan hilang jika kamu keluar.'),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.white),
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Lanjut mengisi'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.pinkRed),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Buang',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
  // Jika dialog ditutup dengan mengetuk area luar, hasilnya null = tidak jadi keluar.
  return result ?? false;
}

/// Keluar dari form: kembali ke halaman sebelumnya, atau ke Home jika
/// form dibuka dari drawer.
void leaveForm(BuildContext context) {
  final navigator = Navigator.of(context);
  if (navigator.canPop()) {
    navigator.pop();
  } else {
    navigator.pushReplacement(
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
  }
}

/// Dipanggil saat pengguna menekan back di form yang sudah diisi.
/// Menampilkan konfirmasi, lalu keluar dari form jika pengguna setuju.
Future<void> confirmLeaveForm(BuildContext context) async {
  final leave = await showDiscardChangesDialog(context);
  if (leave && context.mounted) leaveForm(context);
}

/// Dipanggil oleh tombol Batal.
void cancelForm(BuildContext context, {required bool isDirty}) {
  if (isDirty) {
    confirmLeaveForm(context);
  } else {
    leaveForm(context);
  }
}
