import 'package:rated_locksmith/model/lead_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as sys;
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rated_locksmith/Home/splashscreen.dart';
import 'package:rated_locksmith/theme/themeProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  SharedPreferences sp = await SharedPreferences.getInstance();
  int count = sp.getInt("count")! + 1;
  if (kDebugMode) print("Handling a background message: ${message.messageId}");
  FlutterAppBadger.updateBadgeCount(count);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  sys.SystemChrome.setPreferredOrientations([
    sys.DeviceOrientation.portraitUp,
    sys.DeviceOrientation.portraitDown
  ]).then((_) {
    // runApp(
    //   DevicePreview(
    // enabled: !kReleaseMode,
    // builder: (context) => MyApp(), // Wrap your app
    // ),
    // );
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  // User user;
  SharedPreferences? sp;
  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    // user = FirebaseAuth.instance.currentUser;

    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
    // setState(() async{
    sp = await SharedPreferences.getInstance();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(414, 896),
        builder: (_, child) {
          return MultiProvider(
            providers: [ChangeNotifierProvider<Lead>(create: (_) => Lead())],
            child: GetMaterialApp(
              title: 'Rated Locksmiths',
              // builder: DevicePreview.appBuilder,
              theme: Styles.themeData(false, context),
              builder: (context, widget) {
                // ScreenUtil.setContext(context);

                return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: widget!);
              },
              home: SplashScreen(),
              debugShowCheckedModeBanner: false,
            ),
          );
        });
  }
}
