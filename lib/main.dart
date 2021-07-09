
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'as sys;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:autolocksmith/Home/splashscreen.dart';
import 'package:autolocksmith/model/leads.dart';
import 'package:autolocksmith/theme/themeProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future firebaseMessagingBackgroundHandler(Map<String, dynamic> message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message}");
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  sys.SystemChrome.setPreferredOrientations([
    sys.DeviceOrientation.portraitUp, sys.DeviceOrientation.portraitDown])
      .then((_) {
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
  SharedPreferences sp;
  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async
  {
    // user = FirebaseAuth.instance.currentUser;


    themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getTheme();
    // setState(() async{
    sp =await SharedPreferences.getInstance();
    // });
  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(414, 896),
        // allowFontScaling: false,
        builder: () {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<Lead>(create: (_) => Lead())
            ],
            child:
            MaterialApp(
              title: 'Auto Locksmiths',
              // builder: DevicePreview.appBuilder,
              theme: Styles.themeData(false, context),
              home: SplashScreen(),
              debugShowCheckedModeBanner: false,
            ),
          );
        }
    );
  }
}


