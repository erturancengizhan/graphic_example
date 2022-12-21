import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RssController extends GetxController {
  var baseURL = "https://api.rss.com.tr/api/foreks/graph/USD-TRL/";
  var dataList = [].obs;
  var maxCount = 0.obs;
  var minCount = 0.obs;
  var oldMinIndex = 0.obs;
  var oldMaxIndex = 0.obs;
  var rssIsLoading = false.obs;
  var selectedInterval = 0.obs;

  var intervalList = [
    "1g",
    "1h",
    "1a",
    "3a",
    "1y",
  ];

  Future<void> getRssData(
      {required String interval, required DateTime dateTime}) async {
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
        if (dataList.isNotEmpty) {
          dataList.removeAt(0);
        }
        dataList.value.insertAll(0, data);
        if (dataList.length == 500) {
          minCount.value = dataList.length - 41;
          maxCount.value = dataList.length - 1;
        } else {
          minCount.value = 499;
          maxCount.value = 539;
        }

        debugPrint('Başarılı! $dataList');
        debugPrint('dataList lenght: ${dataList.length}');
        debugPrint('data lenght: ${data.length}');
        debugPrint('minCount: ${minCount.value}');
        debugPrint('maxCount: ${maxCount.value}');
      } else {
        debugPrint('Hata! ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Hata! $e');
    }
  }
}
