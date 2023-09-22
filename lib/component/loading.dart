import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingUtils {
  static bool showLoading= false;
  static void showLoadingPopup() {
    showLoading = true;
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
  }

  static void close() {
    if(showLoading) {
      Get.back();
      if (Get.isSnackbarOpen) {
        Get.back();
      }
    }
  }
}