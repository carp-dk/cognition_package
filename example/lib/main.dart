import 'package:research_package/research_package.dart';
import 'package:cognition_package/cognition_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_themes_package/carp_themes_package.dart';
import 'package:flutter/services.dart';

part 'cognition_config.dart';
part 'cognition_page.dart';
part 'user_demographics_page.dart';

Future main() async {
  // Initialize cognition package.
  // Needed if you load a cognition configurations from a json file
  CognitionPackage.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('en'),
        Locale('da'),
        Locale('fr'),
        Locale('pt'),
      ],
      localizationsDelegates: [
        // Research Package (RP) and Cognition Package (CP) translations.
        // Supports translation of both the RP and CP specific text as well as
        // app-specific text.
        // Read more about localization at https://carp.cachet.dk/localization/
        RPLocalizations.delegate,
        CPLocalizations.delegate,

        // Built-in localization of basic text for Cupertino widgets
        GlobalCupertinoLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode) {
            return supportedLocale;
          }
        }
        // if the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },

      theme: carpTheme,
      title: 'Cognition Package Demo',
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var locale = RPLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xff003F6E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(height: 50),
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Image.asset(
                "assets/images/mcat-logo.png",
                height: 80,
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: Column(
                  children: <Widget>[
                    Text(
                      locale?.translate("home.welcome") ?? "Welcome",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Container(height: 5),
                    Text(
                      locale?.translate("home.questions") ?? "Questions?",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Container(height: 5),
                    const Text(
                      "support@carp.dk",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          decoration: TextDecoration.underline),
                    ),
                    //Container(height: 50),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffC32C39),
                  fixedSize: const Size(300, 60),
                ),
                child: Text(
                  locale?.translate("home.start") ?? "Get started",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute<dynamic>(
                      builder: (context) => const CognitionPage()));
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Image.asset(
          "assets/images/carp_logo.png",
          height: 50,
        ),
      )),
    );
  }
}
