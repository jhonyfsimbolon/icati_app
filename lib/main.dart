import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:icati_app/module/splash/SplashMain.dart';
// import 'package:icati_app/module/stories/Stories.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId("c61809bc-3374-4041-96f0-f3ed6096f8e1");
  // OneSignal.shared.init("7d338039-a1d9-466f-b89e-82fb4dd2f381", iOSSettings: {OSiOSSettings.autoPrompt: false, OSiOSSettings.inAppLaunchUrl: false});
  // OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

  if (Platform.isIOS) {
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
  }
  await OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true);
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

FirebaseAnalytics analytics = FirebaseAnalytics();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      builder: () => MaterialApp(
        title: 'ICATI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          backgroundColor: Colors.white,
          focusColor: Color(0xff0094C6).withOpacity(0.5),
          buttonColor: Color(0xAA9f1c2a),
          textTheme: TextTheme(
              headline1: GoogleFonts.roboto(
                  fontSize: ScreenUtil().setSp(ScreenUtil().setSp(15)),
                  fontWeight: FontWeight.w500,
                  color: Color(0XFF324A5F)),
              headline2: GoogleFonts.roboto(
                  fontSize: ScreenUtil().setSp(14),
                  fontWeight: FontWeight.w400),
              bodyText2: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
              button: GoogleFonts.roboto(
                  fontSize: ScreenUtil().setSp(12),
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
        ),
        home: SplashMain(),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('id'),
          const Locale('en'),
        ],
      ),
    );
  }
}
