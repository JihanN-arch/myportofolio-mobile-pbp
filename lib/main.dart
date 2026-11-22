import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/screens/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JN Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'SpaceGrotesk',
        scaffoldBackgroundColor: AppColors.black,
        // ngikutin color portofolio web
        colorScheme: const ColorScheme.dark(
          primary: AppColors.red,
          onPrimary: AppColors.white,
          secondary: AppColors.green,
          onSecondary: AppColors.black,
          tertiary: AppColors.gold,
          onTertiary: AppColors.black,
          error: AppColors.pinkRed,
          surface: AppColors.carbonBlack,
          onSurface: AppColors.white,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.carbonBlack,
          contentTextStyle: TextStyle(color: AppColors.white),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}
