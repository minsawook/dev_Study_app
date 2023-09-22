import 'package:dev_studygroup_app/common/common.dart';
import 'package:dev_studygroup_app/component/textView.dart';
import 'package:dev_studygroup_app/controller/auth_controller.dart';
import 'package:dev_studygroup_app/scene/home/home.dart';
import 'package:dev_studygroup_app/util/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Sign extends StatefulWidget {
  const Sign({super.key});

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  bool _signAgree = false;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String pw = '';
  String pwCheck ='';

  void _tryValidation(){
    final isValid =_formKey.currentState!.validate();
    if(isValid){
       _formKey.currentState!.save();
    }
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 40,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,color: Colors.white,),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        backgroundColor: Common.iconColor,
        title: Text(
          '회원가입',
          style: TextStyle(
            color: Colors.white,
          ),

        ),
      ),
      backgroundColor: Common.iconColor,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Divider(
                  color: Colors.white24,
                ),
                globalPadding(
                  backColor: true,
                  topPadding: 20,
                  leftPadding: 50,
                  rightPadding: 50,
                  child: Column(
                    children: [
                      //이메일
                      TextView(
                        txt: '  E-Mail',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        size: 20,
                      ),
                      const SizedBox(height: 15,),
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
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              )
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                            ),
                            contentPadding: const EdgeInsets.all(10)
                        ),
                      ),
                      const SizedBox(height: 18,),

                      //pw
                      TextView(
                        txt: '  PW',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        size: 20,
                      ),
                      SizedBox(height: 15,),
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
                            hintText: "패스워드",
                            hintStyle: TextStyle(
                              color: Common.disableColor,
                              fontWeight: FontWeight.normal,
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                )
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(10)
                        ),
                      ),
                      const SizedBox(height: 18,),
                      //폰
                      // TextView(
                      //   txt: '  Phone',
                      //   color: Colors.white,
                      //   fontWeight: FontWeight.bold,
                      //   size: 20,
                      // ),
                      // SizedBox(height: 15,),
                      // TextFormField(
                      //   key: ValueKey(3),
                      //   style: const TextStyle(
                      //       color: Colors.white
                      //   ),
                      //   decoration: InputDecoration(
                      //       hintText: "E-Mail",
                      //       hintStyle: TextStyle(
                      //         color: Common.disableColor,
                      //         fontWeight: FontWeight.normal,
                      //       ),
                      //       enabledBorder: const OutlineInputBorder(
                      //           borderSide: BorderSide(
                      //             color: Colors.white,
                      //           )
                      //       ),
                      //       focusedBorder: const OutlineInputBorder(
                      //         borderSide: BorderSide(
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //       contentPadding: const EdgeInsets.all(10)
                      //   ),
                      // ),
                      // const SizedBox(height: 18,),

                      //체크
                      TextView(
                        txt: '  PW Check',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        size: 20,
                      ),
                      SizedBox(height: 15,),
                      TextFormField(
                        key: ValueKey(4),
                        obscureText: true,
                        validator: (value) {
                          if(pw != pwCheck) {
                            return '패스워드와 입력값이 다릅니다.';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          pwCheck = value!;
                        },
                        onChanged: (value) {
                          pwCheck = value;
                        },
                        style: const TextStyle(
                            color: Colors.white
                        ),
                        decoration: InputDecoration(
                            hintText: "패스워드를 다시한번 입력해 주세요",
                            hintStyle: TextStyle(
                              color: Common.disableColor,
                              fontWeight: FontWeight.normal,
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                )
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(10)
                        ),
                      ),
                      const SizedBox(height: 35,),
                      Row(
                        children: [
                          Checkbox(value: _signAgree, onChanged: (value){
                            setState(() {
                              _signAgree = value!;
                            });
                          },
                            checkColor: Common.iconColor,
                            activeColor: Colors.white,
                            side: const BorderSide(color: Colors
                                .white60,width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),),),
                          TextView(txt: '회원가입에 동의 합니다.',color: Colors.white,)
                        ],
                      ),
                      FilledButton.tonal(
                          onPressed: () async{
                            if(_signAgree && pw ==pwCheck){
                              _tryValidation();
                              AuthController.instance.register(email, pw);
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  _signAgree? Colors.white : Colors.grey[400])
                          ),
                          child: TextView(
                            txt: '회원가입',
                            color: Common.iconColor,
                            size: 20,
                            align: Alignment.center,
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
