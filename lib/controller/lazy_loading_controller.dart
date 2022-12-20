import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class LazyLoadingController extends GetxController {
  var dataList = [].obs;
  var count = 0.obs;
  var lazyIsLoading = false.obs;
  var selectedInterval = 5.obs;
  var minCount = 0.obs;
  var maxCount = 0.obs;

  ChartSeriesController? seriesController;

  get getDataList => dataList.value;
  int get getCount => count.value;

  var intervalList = [
    "1m",
    "5m",
    "15m",
    "30m",
    "1h",
    "1d",
    "1w",
    "1M",
  ];

  Future<void> getBinanceData({required String interval}) async {
    try {
      if (count.value == dataList.length) {
        count.value += 200;
        var limit = count;
        var url =
            'https://api.binance.com/api/v3/klines?symbol=BTCUSDT&interval=$interval&limit=$limit';
        var response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          dataList.value = data;
          debugPrint('count: ' + count.value.toString());
          if (limit.value == 200) {
            debugPrint('if');
            minCount.value = dataList.length - 39;
            maxCount.value = dataList.length - 1;
            debugPrint('minCount: ' + minCount.value.toString());
            debugPrint('maxCount: ' + maxCount.value.toString());
            debugPrint('dataList.length: ' + dataList.value.length.toString());
          } else {
            debugPrint('else');
            minCount.value = 200;
            maxCount.value = 238;
            /* minCount.value = dataList.length - (count.value - 200);
          maxCount.value = dataList.length - 1 - (count.value - 200) + 39; */
            debugPrint('minCount: ' + minCount.value.toString());
            debugPrint('maxCount: ' + maxCount.value.toString());
            debugPrint('dataList.length: ' + dataList.value.length.toString());
          }

          debugPrint('Başarılı! $dataList');
        } else {
          debugPrint('Hata! ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint('Hata! $e');
    }
  }
}
