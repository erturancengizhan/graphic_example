import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphic_example/controller/lazy_loading_controller.dart';
import 'package:graphic_example/view/lazy_loading_chart/lazy_loading_landing.dart';

LazyLoadingController _lazyLoadingController = Get.put(LazyLoadingController());

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Graphic Example'),
      ),
      body: SafeArea(
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  _lazyLoadingController.lazyIsLoading.value = true;
                  Get.to(() => const LazyLoadingLanding())!.then((value) {
                    _lazyLoadingController.dataList.value.clear();
                    _lazyLoadingController.count.value = 0;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.pink,
                  ),
                  child: const Text(
                    'Chart',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ).paddingSymmetric(horizontal: 24.0, vertical: 8.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
