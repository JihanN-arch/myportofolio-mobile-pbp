import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp(apiClient: ApiClient()));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.apiClient, super.key});

  final ApiClient apiClient;

  @override
  Widget build(BuildContext context) {
    // MultiProvider menyisipkan ApiClient dan AuthState ke widget tree,
    // sehingga semua halaman bisa memakainya lewat context.read / watch.
    return MultiProvider(
      providers: [
        Provider.value(value: apiClient),
        ChangeNotifierProvider(create: (context) => AuthState(apiClient)),
      ],
      child: MaterialApp(
        title: 'JN Portfolio',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          fontFamily: 'SpaceGrotesk',
          scaffoldBackgroundColor: AppColors.black,
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
      ),
    );
  }
}
