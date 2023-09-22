import 'package:dev_studygroup_app/controller/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/common.dart';
import '../home/home.dart';
import '../login/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  Stream<User?> authStateStream = FirebaseAuth.instance.authStateChanges();

  bool next = false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authStateStream.listen((event) async{
      if(event != null && Common.autoLogin){
        await AuthController.instance.initUser();
        next = true;
      }
      else{
        next= false;
      }
    });

    nextPage();
  }
  
  nextPage(){
    Future.delayed(Duration(seconds: 3)).then((value) {
      next? Get.offAll(Home()) : Get.offAll(Login());
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset('${Common.loginImgPath}splash.gif',fit: BoxFit.cover),
      ),
    );
  }
}

