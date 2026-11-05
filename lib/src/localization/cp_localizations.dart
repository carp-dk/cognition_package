part of '../../../../ui.dart';

/// Localization support for Cognition Package using [LocalizationLoader]
/// configurations.
///
/// Use [translate] to translate any text, like this:
///
/// ```
///  CPLocalizations.of(context).translate('key');
/// ```
///
class CPLocalizations extends AssetLocalizations {
  static const String assetPath = 'cognition_package/assets/lang';

  /// Create a localization based on [locale].
  CPLocalizations(super.locale);

  /// Returns the localized resources object of type [CPLocalizations] for the
  /// widget tree that corresponds to the given [context].
  ///
  /// Returns `null` if no resources object of type [CPLocalizations] exists within
  /// the given `context`.
  static CPLocalizations? of(BuildContext context) =>
      Localizations.of<CPLocalizations>(context, CPLocalizations);

  /// The name of the static localization asset.
  String get staticAssetName =>
      'packages/$assetPath/${locale.languageCode}.json';

  /// Load the translations for Cognition Package.
  ///
  /// The translations consists of the static names in the package as
  /// provided in [staticAssetName].
  @override
  Future<void> load() async {
    print("$runtimeType - loading static translations from '$staticAssetName'");
    String jsonString = '{}';

    try {
      jsonString = await rootBundle.loadString(staticAssetName, cache: false);
    } catch (_) {
      print(
        "WARNING - Failed to load RP translations for '$locale' and it seems like RP does not support this locale in the current version. "
        'If you are using this locale in your app, you should consider to make a pull request to RP so we can add this locale to the package for others to use as well. '
        'See https://carp.cachet.dk/localization for a description on how to do this. '
        'For now, translations provided in the app localization file(s) are also used for RP so you can provide translations for the RP terms there for now.',
      );
    }

    Map<String, dynamic> jsonMap =
        json.decode(jsonString) as Map<String, dynamic>;
    translations.addAll(
      jsonMap.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  /// A default [LocalizationsDelegate] for [CPLocalizations].
  static LocalizationsDelegate<CPLocalizations> delegate =
      CPLocalizationsDelegate();
}

class CPLocalizationsDelegate extends LocalizationsDelegate<CPLocalizations> {
  bool _shouldReload = false;

  /// Create a [CPLocalizationsDelegate].
  CPLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // we don't restrict the supported locales here since the user of RP
    // might create his/her own translations
    return true;
  }

  @override
  Future<CPLocalizations> load(Locale locale) async {
    final localizations = CPLocalizations(locale);
    await localizations.load();
    _shouldReload = false;
    return localizations;
  }

  /// Mark that this delegate should reload its translations.
  /// Useful if, for example, downloaded from the network.
  void reload() => _shouldReload = true;

  @override
  bool shouldReload(CPLocalizationsDelegate old) => _shouldReload;
}
