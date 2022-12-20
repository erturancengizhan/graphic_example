import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget loadingAnimation() {
  return Scaffold(
    body: SizedBox(
      width: Get.width,
      height: Get.height,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );
}
