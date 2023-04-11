import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RssController extends GetxController {
  var baseURL = "https://api.rss.com.tr/api/app/foreks/graph/currency1/";
  var dataList = [].obs;
  var maxCount = 0.obs;
  var minCount = 0.obs;
  var oldMinIndex = 0.obs;
  var oldMaxIndex = 0.obs;
  var rssIsLoading = false.obs;
  var selectedInterval = 0.obs;
  var isSwipe = false;

  var intervalList = [
    ["1g", 1, DateTimeIntervalType.days],
    ["1h", 7, DateTimeIntervalType.days],
    ["1a", 1, DateTimeIntervalType.months],
    ["1y", 1, DateTimeIntervalType.years],
  ];

  void toolText(TrackballArgs args) {
    var index = args.chartPointInfo.dataPointIndex;
    if (index! >= 0 && index <= 40 && !isSwipe) {
      index = minCount.value + index;
    }
    var symbol = 'USD/TRY';
    if (dataList.isNotEmpty && dataList.length >= index) {
      var data = dataList[index];
      var formattedDate = '';
      if (data['d'] != null) {
        formattedDate = DateFormat.yMMMMd()
            .add_jm()
            .format(DateTime.fromMillisecondsSinceEpoch(data['d']))
            .toString();
      }
      var format = '$formattedDate\n$symbol: ${data["c"]}';

      args.chartPointInfo.label = format;
    }
  }

  Future<void> getRssData(
      {required String interval,
      required DateTime dateTime,
      required bool isChangeInterval}) async {
    try {
      List timeList = dateTime.toString().split(' ');
      String date = timeList[0];
      List dateSplitList = date.split('-');
      String time = timeList[1];
      List timeSplitList = time.split(':');
      String fullTime =
          '${dateSplitList[0]}${dateSplitList[1]}${dateSplitList[2]}${timeSplitList[0]}${timeSplitList[1]}';
      var url = '$baseURL$interval/$fullTime';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (isChangeInterval) {
          dataList.clear();
        }
        if (dataList.isNotEmpty) {
          dataList.removeAt(0);
        }
        dataList.insertAll(0, data);

        if (dataList.length < 41) {
          minCount.value = 0;
          maxCount.value = dataList.length - 1;
        } else {
          if (dataList.length == (data as List).length) {
            minCount.value = dataList.length - 41;
            maxCount.value = dataList.length - 1;
          } else {
            minCount.value = data.length - 1;
            maxCount.value = data.length + 39;
          }
        }
        debugPrint('Basarılı! $dataList');
      } else {
        debugPrint('Hata! ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Hata! $e');
    }
  }
}
