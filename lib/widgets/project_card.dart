import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/app_colors.dart';

/// Model untuk setiap tombol aksi di halaman utama.
class ItemHomepage {
  final String name;
  final IconData icon;

  /// Warna latar kartu tombol.
  final Color color;

  /// Warna ikon dan teks agar tetap terbaca di atas [color].
  final Color foregroundColor;

  /// Warna garis tepi kartu (null = tanpa garis tepi).
  final Color? borderColor;

  /// Halaman tujuan saat tombol ditekan (null = hanya SnackBar).
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
          // Navigator.push agar pengguna bisa kembali dengan tombol Back.
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
