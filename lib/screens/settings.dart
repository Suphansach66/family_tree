import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/family_provider.dart';
import '../utils/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final provider = context.watch<FamilyProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.settings,
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
          ),
      ),
      body: ListView(
        children: [
          _buildLanguageSection(context, loc, provider),
          const Divider(),
          _buildThemeSection(context, loc, provider),
          const Divider(),
          _buildAboutTile(context, loc),
          const Divider(),
          _buildExitTile(context, loc),
        ],
      ),
    );
  }

  Widget _buildLanguageSection(
    BuildContext context,
    AppLocalizations loc,
    FamilyProvider provider,
  ) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(loc.language),
      subtitle: Text(provider.locale.languageCode == 'th' ? loc.thai : loc.english),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(loc.language),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: Text(loc.thai),
                  value: 'th',
                  groupValue: provider.locale.languageCode,
                  onChanged: (value) {
                    provider.setLocale(const Locale('th', 'TH'));
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<String>(
                  title: Text(loc.english),
                  value: 'en',
                  groupValue: provider.locale.languageCode,
                  onChanged: (value) {
                    provider.setLocale(const Locale('en', 'US'));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeSection(
    BuildContext context,
    AppLocalizations loc,
    FamilyProvider provider,
  ) {
    return ListTile(
      leading: const Icon(Icons.palette),
      title: Text(loc.theme),
      subtitle: Text(
        provider.themeMode == ThemeMode.dark ? loc.dark : loc.light,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(loc.theme),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(loc.light),
                  value: ThemeMode.light,
                  groupValue: provider.themeMode,
                  onChanged: (value) {
                    provider.setTheme(ThemeMode.light);
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: Text(loc.dark),
                  value: ThemeMode.dark,
                  groupValue: provider.themeMode,
                  onChanged: (value) {
                    provider.setTheme(ThemeMode.dark);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAboutTile(BuildContext context, AppLocalizations loc) {
    return ListTile(
      leading: const Icon(Icons.info),
      title: Text(loc.about),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(loc.about),
            content: Text(loc.aboutText),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExitTile(BuildContext context, AppLocalizations loc) {
    return ListTile(
      leading: const Icon(Icons.exit_to_app, color: Colors.red),
      title: Text(
        loc.exit,
        style: const TextStyle(color: Colors.red),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(loc.exit),
            content: Text(loc.exit),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(loc.no),
              ),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text(loc.yes),
              ),
            ],
          ),
        );
      },
    );
  }
}