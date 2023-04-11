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
  var noDataLeft = false.obs;

  ChartSeriesController? seriesController;

  var intervalList = [
    ["1m", 1, DateTimeIntervalType.minutes],
    ["5m", 5, DateTimeIntervalType.minutes],
    ["15m", 15, DateTimeIntervalType.minutes],
    ["30m", 30, DateTimeIntervalType.minutes],
    ["1h", 1, DateTimeIntervalType.hours],
    ["1d", 1, DateTimeIntervalType.days],
    ["1w", 7, DateTimeIntervalType.days],
    ["1M", 1, DateTimeIntervalType.months],
  ];

  Future<void> getBinanceData(
      {required String interval, required bool isChangeInterval}) async {
    try {
      if (noDataLeft.value == false) {
        count.value += 200;
        var limit = count;
        var url =
            'https://api.binance.com/api/v3/klines?symbol=BTCUSDT&interval=$interval&limit=$limit';
        var response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (isChangeInterval) {
            dataList.clear();
          }
          if (dataList.length == (data as List).length) {
            noDataLeft.value = true;
          } else {
            if (data.length < 200) {
              noDataLeft.value = true;
            }
            dataList.value = data;
            if (dataList.length == 200) {
              minCount.value = dataList.length - 39;
              maxCount.value = dataList.length - 1;
            } else {
              if (dataList.length < 200) {
                minCount.value = dataList.length - 39;
                maxCount.value = dataList.length - 1;
              } else {
                minCount.value = 200;
                maxCount.value = 238;
              }
            }
          }
        } else {
          debugPrint('Hata! ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint('Hata! $e');
    }
  }
}
