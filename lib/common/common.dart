
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Common{

  //테마 색상
  static Color basicColor = const Color(0xFFf5f6fc);
  static Color iconColor = const Color(0xFF6ca3dc);

  static String iconImgPath = "assets/Icons/";
  static String loginImgPath = "assets/login/";

  static Color? disableColor = Colors.white38;

  static bool _autoLogin = false;

  static bool get autoLogin => _autoLogin;

  static set autoLogin(bool value) {
    _autoLogin = value;
  }

  static List<String> categoryList = ['자유게시판','유머','궁금해요','취업/면접','멘토링','직무'];

//기기저장  자동 로그인
}