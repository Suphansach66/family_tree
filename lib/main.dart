import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/family_provider.dart';
import 'screens/home.dart';
import 'screens/member_list.dart';
import 'screens/detail.dart';
import 'screens/add_edit.dart';
import 'screens/settings.dart';
import 'utils/app_theme.dart';
import 'utils/app_localizations.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FamilyProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FamilyProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          title: 'Family Tree',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: provider.themeMode,
          locale: provider.locale,
          
          localizationsDelegates: const [
            AppLocalizations.delegate,  
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          
          supportedLocales: const [
            Locale('th', 'TH'),
            Locale('en', 'US'),
          ],
          initialRoute: '/',
          routes: {
            '/': (context) => const HomeScreen(),
            '/members': (context) => const MemberListScreen(),
            '/detail': (context) => const DetailScreen(),
            '/add_edit': (context) => const AddEditScreen(),
            '/settings': (context) => const SettingsScreen(),
          },
        );
      },
    );
  }
}