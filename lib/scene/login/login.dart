import 'package:dev_studygroup_app/component/loading.dart';
import 'package:dev_studygroup_app/component/textView.dart';
import 'package:dev_studygroup_app/controller/auth_controller.dart';
import 'package:dev_studygroup_app/scene/home/home.dart';
import 'package:dev_studygroup_app/scene/login/sign.dart';
import 'package:dev_studygroup_app/util/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/common.dart';
import '../../util/Dimensions.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String pw = '';
  bool autoLogin = false;

  void _tryValidation(){
    final isValid =_formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: Dimensions.screenWidth,
        height: Dimensions.screenHeight,
        color: Common.iconColor,
        child: globalPadding(
          backColor: true,
          leftPadding: 50,
          rightPadding: 50,
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   width: Dimensions.screenHeight*0.2,
              //   child: Image.asset('${Common.iconImgPath}profile_empty.png'),
              // ),
              Container(
                child: Form(
                    key: _formKey,
                    child: Column(
                  children: [
                    TextFormField(
                      key: ValueKey(1),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value){
                        if(value!.isEmpty || !value.contains('@')){
                          return '유효한 이메일을 입력해 주세요';
                        }
                        return null;
                      },
                      onSaved: (value){
                        email = value!;
                      },
                      onChanged: (value){
                        email = value;
                      },
                      style: const TextStyle(
                          color: Colors.white
                      ),
                      decoration: InputDecoration(
                          hintText: "E-Mail",
                          hintStyle: TextStyle(
                            color: Common.disableColor,
                            fontWeight: FontWeight.normal,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white38)
                          ),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                          )
                      ),
                    ),
                    const SizedBox(height: 20,),
                    TextFormField(
                      key: ValueKey(2),
                      obscureText: true,
                      validator: (value){
                        if(value!.isEmpty || value.length <6){
                          return '6글자 이상의 패스워드가 필요합니다.';
                        }
                        return null;
                      },
                      onSaved: (value){
                        pw = value!;
                      },
                      onChanged: (value){
                        pw = value;
                      },
                      style: const TextStyle(
                          color: Colors.white
                      ),
                      decoration: InputDecoration(
                          hintText: "PW",
                          hintStyle: TextStyle(
                            color: Common.disableColor,
                            fontWeight: FontWeight.normal,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white38)
                          ),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                          )
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(value: autoLogin, onChanged: (value){
                          setState(() {
                            autoLogin = value!;
                          });
                        },
                        checkColor: Common.iconColor,
                        activeColor: Colors.white,
                        side: const BorderSide(color: Colors
                            .white60,width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),),),
                        TextView(txt: '자동 로그인',color: Colors.white,)
                      ],
                    ),
                      FilledButton.tonal(
                          onPressed: (){
                            _tryValidation();
                            AuthController.instance.login(email, pw, autoLogin);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white)
                          ),
                          child: TextView(
                            txt: '로그인',
                            color: Common.iconColor,
                            size: 20,
                            align: Alignment.center,
                          )),
                    const SizedBox(height: 2,),

                    OutlinedButton(
                        onPressed: (){
                          Get.to(Sign());
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Colors.white
                          )
                        ),
                        child: TextView(
                          txt: '회원가입',
                          color: Colors.white,
                          size: 20,
                          align: Alignment.center,
                        )),
                    const SizedBox(height: 15,),
                    GestureDetector(
                        onTap: (){
                        },
                        child: Container(
                          child: TextView(
                            txt: '계정을 잊으셨나요? 아이디 비밀번호 찾기',
                            size: 12,
                            color: Colors.white,
                            align: Alignment.center,
                          ),
                        )),
                    const SizedBox(height: 70,),
                    TextView(
                      txt: '계정 연동',
                      size: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      align: Alignment.center,
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async{
                            await AuthController.instance.signInWithGoogle();

                          },
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white,
                            child: Image.asset('assets/Icons/icon_google.png'),
                          ),
                        ),

                        // const SizedBox(width: 20,),
                        // GestureDetector(
                        //   onTap: (){
                        //
                        //   },
                        //   child: CircleAvatar(
                        //     radius: 28,
                        //     backgroundColor: Colors.white,
                        //     child: Image.asset('assets/Icons/facebookLogo.png'),
                        //   ),
                        // ),

                        // const SizedBox(width: 20,),
                        // GestureDetector(
                        //   onTap: (){
                        //
                        //   },
                        //   child: CircleAvatar(
                        //     radius: 28,
                        //   ),
                        //),

                      ],
                    )
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
