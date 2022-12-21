import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphic_example/controller/rss_controller.dart';
import 'package:graphic_example/view/lazy_loading_chart/lazy_loading_chart.dart';
import 'package:graphic_example/view/rss_api/rss_api.dart';
import 'package:graphic_example/widgets/loading_animation.dart';

RssController _rssController = Get.put(RssController());

class RssLanding extends StatelessWidget {
  const RssLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_rssController.rssIsLoading.value) {
        _rssController
            .getRssData(interval: '1g', dateTime: DateTime.now())
            .then((value) {
          _rssController.rssIsLoading.value = false;
        });
        return loadingAnimation();
      } else {
        return const RssApi();
      }
    });
  }
}
