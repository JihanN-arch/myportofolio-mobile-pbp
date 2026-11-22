import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';

/// Dekorasi input yang dipakai bersama oleh semua form.
/// [accent] adalah warna saat field sedang aktif (merah untuk Project,
/// hijau untuk Experience), supaya setiap form punya identitas warnanya sendiri.
InputDecoration appInputDecoration(
  String label, {
  required Color accent,
  String? hint,
  Widget? suffixIcon,
}) {
  const radius = BorderRadius.all(Radius.circular(12));

  return InputDecoration(
    labelText: label,
    hintText: hint,
    suffixIcon: suffixIcon,
    labelStyle: WidgetStateTextStyle.resolveWith((states) {
      if (states.contains(WidgetState.error)) {
        return const TextStyle(
          color: AppColors.gold,
          fontWeight: FontWeight.w600,
        );
      }
      return const TextStyle(fontWeight: FontWeight.w600);
    }),
    floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
      if (states.contains(WidgetState.error)) {
        return const TextStyle(
          color: AppColors.gold,
          fontWeight: FontWeight.bold,
        );
      }
      if (states.contains(WidgetState.focused)) {
        return TextStyle(color: accent, fontWeight: FontWeight.bold);
      }
      return const TextStyle(
        color: AppColors.muted,
        fontWeight: FontWeight.bold,
      );
    }),
    errorStyle: const TextStyle(color: AppColors.gold),
    hintStyle: const TextStyle(color: AppColors.muted),
    border: const OutlineInputBorder(borderRadius: radius),
    enabledBorder: const OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: AppColors.muted),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: accent, width: 1.5),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: AppColors.gold),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: AppColors.gold, width: 1.5),
    ),
  );
}

class AppSelectField extends StatelessWidget {
  final String label;
  final Color accent;
  final Map<String, String> options;
  final String value;
  final ValueChanged<String> onChanged;

  const AppSelectField({
    super.key,
    required this.label,
    required this.accent,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return MenuAnchor(
          alignmentOffset: const Offset(0, 6),
          style: MenuStyle(
            backgroundColor: const WidgetStatePropertyAll(
              AppColors.carbonBlack,
            ),
            minimumSize: WidgetStatePropertyAll(Size(width, 0)),
            maximumSize: WidgetStatePropertyAll(Size(width, 320)),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 6),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                side: BorderSide(color: accent),
              ),
            ),
          ),
          menuChildren: options.entries.map((entry) {
            final selected = entry.key == value;
            return MenuItemButton(
              onPressed: () => onChanged(entry.key),
              style: ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size(width, 48)),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16),
                ),
                foregroundColor: WidgetStatePropertyAll(
                  selected ? accent : AppColors.white,
                ),
                overlayColor: WidgetStatePropertyAll(accent.withAlpha(30)),
              ),
              trailingIcon: selected
                  ? Icon(Icons.check_rounded, color: accent, size: 18)
                  : null,
              child: Text(
                entry.value,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
          builder: (context, controller, child) {
            return InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              onTap: () =>
                  controller.isOpen ? controller.close() : controller.open(),
              child: InputDecorator(
                isFocused: controller.isOpen,
                decoration: appInputDecoration(
                  label,
                  accent: accent,
                  suffixIcon: Icon(
                    controller.isOpen
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                  ),
                ),
                child: Text(options[value] ?? value),
              ),
            );
          },
        );
      },
    );
  }
}
