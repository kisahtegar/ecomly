import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomly_client/core/common/app/cache_helper.dart';
import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/services/injection_container.dart';
import 'package:ecomly_client/core/services/router.dart' show router;

/// The entry point of the Ecomly client app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (e.g., API keys, base URLs).
  await dotenv.load(fileName: ".env");

  // Initialize services and dependency injection.
  await init();

  // Restore previously selected theme mode.
  sl<CacheHelper>().getThemeMode();

  // Launch the app with Riverpod provider scope.
  runApp(const ProviderScope(child: MainApp()));
}

/// The root widget of the application.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// Base light theme configuration.
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colours.lightThemePrimaryColour,
      ),
      fontFamily: 'Switzer',
      scaffoldBackgroundColor: Colours.lightThemeTintStockColour,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colours.lightThemeTintStockColour,
        foregroundColor: Colours.lightThemePrimaryTextColour,
      ),
      chipTheme: const ChipThemeData(
        padding: EdgeInsets.symmetric(horizontal: 8),
      ),
      useMaterial3: true,
    );

    // Reactively rebuilds the app when the theme mode changes.
    return ValueListenableBuilder(
      valueListenable: Cache.instance.themeModeNotifier,
      builder: (_, themeMode, __) {
        return MaterialApp.router(
          title: 'Ecomly',
          routerConfig: router,
          themeMode: themeMode,
          theme: theme,
          debugShowCheckedModeBanner: false,

          /// Dark theme customization with Ecomly colors.
          darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
            scaffoldBackgroundColor: Colours.darkThemeBGDark,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colours.darkThemeBGDark,
              foregroundColor: Colours.lightThemeWhiteColour,
            ),
            colorScheme: theme.colorScheme,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colours.lightThemePrimaryColour,
              ),
            ),
            chipTheme: theme.chipTheme,
            textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Switzer'),
          ),
        );
      },
    );
  }
}
