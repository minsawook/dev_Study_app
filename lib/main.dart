import 'package:dev_studygroup_app/color_schemes.g.dart';
import 'package:dev_studygroup_app/controller/InitialViewModel.dart';
import 'package:dev_studygroup_app/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common/common.dart';
import 'common/route/page.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(AuthController()));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Common.autoLogin = prefs.getBool('isAutoLogin')?? false;
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //FlutterNativeSplash.remove();
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return GetMaterialApp(
      title: 'DevStudyApp',
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        splashColor: Colors.transparent,
        fontFamily: 'NotoSanceKr',
        colorScheme: lightColorScheme,
        //brightness: Brightness.light,
        useMaterial3: true,
      ),
      // darkTheme:  ThemeData(
      //   colorScheme: darkColorScheme,
      //   brightness: Brightness.dark,
      //   useMaterial3: true,
      // ),
      //home: const Splash(),
    );
  }
}

