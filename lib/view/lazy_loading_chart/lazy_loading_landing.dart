import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphic_example/controller/lazy_loading_controller.dart';
import 'package:graphic_example/view/lazy_loading_chart/lazy_loading_chart.dart';
import 'package:graphic_example/widgets/loading_animation.dart';

LazyLoadingController _lazyLoadingController =
    Get.find<LazyLoadingController>();

class LazyLoadingLanding extends StatelessWidget {
  const LazyLoadingLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_lazyLoadingController.lazyIsLoading.value) {
        _lazyLoadingController
            .getBinanceData(
                interval: _lazyLoadingController.intervalList[
                    _lazyLoadingController.selectedInterval.value])
            .then((value) {
          _lazyLoadingController.lazyIsLoading.value = false;
        });
        return loadingAnimation();
      } else {
        return const LazyLoadingChart();
      }
    });
  }
}
