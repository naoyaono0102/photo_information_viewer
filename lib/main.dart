import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_information_viewer/utils/style.dart';
import 'package:photo_information_viewer/view/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'di/providers.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 画像のキャッシュを上限を30MiBに抑える
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 30;
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: globalProviders,
        child: MyApp(),
      ),
    );
  });
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: darkTheme.copyWith(
            primaryColor: kScaffoldBackgroundColor,
            textTheme: GoogleFonts.ibmPlexSansTextTheme(
            //     Theme.of(context).textTheme.copyWith(
            //       bodyText1: TextStyle(
            //         fontSize: 18,
            //         color: kBase2TextColor,
            //       ),
            //       bodyText2: TextStyle(
            //         fontSize: 16,
            //         color: kBase2TextColor,
            //       ),
            //     )
            ),
        ),
        home: const HomeScreen()
    );
  }
}