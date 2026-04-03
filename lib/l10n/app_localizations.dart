import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('uk'),
  ];

  String get appTitle;
  String get play;
  String get continueGame;
  String get level;
  String get score;
  String get time;
  String get hint;
  String get hints;
  String get across;
  String get down;
  String get correct;
  String get incorrect;
  String get complete;
  String get levelComplete;
  String get nextLevel;
  String get backToMenu;
  String get settings;
  String get shop;
  String get soundEffects;
  String get hapticFeedback;
  String get language;
  String get preferences;
  String get purchases;
  String get store;
  String get purchased;
  String get removeAds;
  String get removeAdsDescription;
  String get restore;
  String get back;
  String get puzzlesCompleted;
  String get highestLevel;
  String get totalScore;
  String get bestScore;
  String get hintsUsed;
  String get totalPlayTime;
  String get cancel;
  String get confirm;
  String get stats;
  String get watchAdForHints;
  String get noHintsAvailable;
  String get hintRevealed;
  String get tapCellToFill;
  String get wellDone;
  String get timeBonus;
  String get newBest;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale".',
  );
}
