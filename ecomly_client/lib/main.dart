import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomly_client/core/common/app/cache_helper.dart';
import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/services/injection_container.dart';
import 'package:ecomly_client/core/services/router.dart' show router;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await init();
  sl<CacheHelper>().getThemeMode();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
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
    return ValueListenableBuilder(
      valueListenable: Cache.instance.themeModeNotifier,
      builder: (_, themeMode, __) {
        return MaterialApp.router(
          title: 'Ecomly',
          routerConfig: router,
          themeMode: themeMode,
          theme: theme,
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
