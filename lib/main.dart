import 'package:flutter/material.dart';
import 'package:flutter_internationalization_practice/gen/strings.g.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences sharedPreferences;

const localeIndexKey = 'LOCALE_INDEX';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();

  final localeIndex = sharedPreferences.getInt(localeIndexKey);
  if (localeIndex == null) {
    await LocaleSettings.useDeviceLocale();
  } else {
    final locale = AppLocale.values[localeIndex];
    await LocaleSettings.setLocale(locale);
  }

  runApp(TranslationProvider(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      locale: TranslationProvider.of(context).flutterLocale,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: AppLocaleUtils.supportedLocales,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            // tooltip
            BackButton(),
            Text(t.hello.world),
            Text(t.hello.name(name: 'gurasan0110')),
            DropdownMenu(
              initialSelection: sharedPreferences.getInt(localeIndexKey) == null
                  ? null
                  : LocaleSettings.currentLocale,
              onSelected: (locale) async {
                if (locale == null) {
                  await sharedPreferences.remove(localeIndexKey);
                  await LocaleSettings.useDeviceLocale();
                } else {
                  await sharedPreferences.setInt(localeIndexKey, locale.index);
                  await LocaleSettings.setLocale(locale);
                }
              },
              dropdownMenuEntries: [
                DropdownMenuEntry(value: null, label: 'device'),
                for (final locale in AppLocale.values)
                  DropdownMenuEntry(value: locale, label: locale.name),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
