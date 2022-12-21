import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphic_example/controller/rss_controller.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

RssController _rssController = Get.put(RssController());

class RssApi extends StatelessWidget {
  const RssApi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('RSS API Chart'),
      ),
      body: SafeArea(
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Column(
            children: [
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _rssController.intervalList.length,
                  (index) {
                    return Row(
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            _rssController.selectedInterval.value = index;
                          },
                          child: Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: _rssController.selectedInterval.value ==
                                        index
                                    ? Colors.pink
                                    : Colors.white,
                                border: Border.all(
                                  color: Colors.pink,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Text(
                                _rssController.intervalList[index],
                                style: TextStyle(
                                    color:
                                        _rssController.selectedInterval.value ==
                                                index
                                            ? Colors.white
                                            : Colors.pink),
                              ).paddingSymmetric(
                                  horizontal: 8.0, vertical: 2.0),
                            ),
                          ),
                        ),
                        6.width,
                      ],
                    );
                  },
                ),
              ),
              16.height,
              Obx(
                () => SfCartesianChart(
                  trackballBehavior: TrackballBehavior(
                    activationMode: ActivationMode.singleTap,
                    enable: true,
                    tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                    tooltipSettings: const InteractiveTooltip(
                      enable: true,
                      /* color: Colors.white
                          .withOpacity(.8), // ChartInfoCard bg color
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      borderColor: Colors.grey, */
                    ),
                  ),
                  loadMoreIndicatorBuilder:
                      (BuildContext context, ChartSwipeDirection direction) {
                    if (direction == ChartSwipeDirection.start) {
                      debugPrint('Yeni data getiriliyor...');
                      Future.delayed(const Duration(seconds: 10)).then((value) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) async {
                            await _rssController.getRssData(
                                interval: _rssController.intervalList[
                                    _rssController.selectedInterval.value],
                                dateTime: DateTime.fromMillisecondsSinceEpoch(
                                    _rssController.dataList.value.first["d"]));
                          },
                        );
                      });
                      return SizedBox.fromSize(size: Size.zero);
                    } else {
                      return SizedBox.fromSize(size: Size.zero);
                    }
                  },
                  plotAreaBorderWidth: 0,
                  plotAreaBorderColor: Colors.transparent,
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePanning: true,
                    zoomMode: ZoomMode.x,
                  ),
                  primaryXAxis: DateTimeCategoryAxis(
                    rangePadding: ChartRangePadding.auto,
                    autoScrollingMode: AutoScrollingMode.start,
                    labelPosition: ChartDataLabelPosition.outside,
                    axisLine: const AxisLine(color: Colors.transparent),
                    majorGridLines:
                        const MajorGridLines(color: Colors.transparent),
                    majorTickLines: const MajorTickLines(
                      color: Colors.transparent,
                      size: 0,
                      width: 0,
                    ),
                    interval: 1,
                    intervalType: DateTimeIntervalType.days,
                    //maximumLabels: 2,
                    labelAlignment: LabelAlignment.end,
                    //edgeLabelPlacement: EdgeLabelPlacement.hide,
                    visibleMinimum: DateTime.fromMillisecondsSinceEpoch(
                        _rssController.dataList[_rssController.minCount.value]
                            ["d"]),
                    visibleMaximum: DateTime.fromMillisecondsSinceEpoch(
                        _rssController.dataList[_rssController.maxCount.value]
                            ["d"]),
                  ),
                  primaryYAxis: NumericAxis(
                    anchorRangeToVisiblePoints: true,
                    opposedPosition: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    axisLine: const AxisLine(color: Colors.transparent),
                    majorTickLines: const MajorTickLines(
                      color: Colors.transparent,
                      size: 0,
                      width: 0,
                    ),
                    edgeLabelPlacement: EdgeLabelPlacement.hide,
                    labelAlignment: LabelAlignment.end,
                    placeLabelsNearAxisLine: true,
                  ),
                  series: <ChartSeries>[
                    AreaSeries<dynamic, DateTime>(
                      animationDuration: 0,
                      dataSource: _rssController.dataList.value,
                      xValueMapper: (chartData, _) => DateTime.parse(
                          DateFormat("yyyy-MM-dd HH:mm").format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  chartData["d"]))),
                      yValueMapper: (chartData, _) =>
                          double.parse(chartData["o"].toString()),
                      borderColor: Colors.green,
                      borderWidth: 3,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.green.withOpacity(0.75),
                          Colors.green.withOpacity(0.15),
                          Colors.green.withOpacity(0),
                        ],
                      ),
                    ),
                    /* CandleSeries<dynamic, DateTime>(
                      /* onRendererCreated: (ChartSeriesController controller) {
                        _lazyLoadingController.seriesController = controller;
                      }, */
                      enableSolidCandles: true,
                      animationDuration: 0,
                      xValueMapper: (chartData, _) => DateTime.parse(
                          DateFormat("yyyy-MM-dd HH:mm").format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  chartData["d"]))),
                      highValueMapper: (chartData, _) =>
                          double.parse(chartData["h"].toString()),
                      lowValueMapper: (chartData, _) =>
                          double.parse(chartData["l"].toString()),
                      openValueMapper: (chartData, _) =>
                          double.parse(chartData["o"].toString()),
                      closeValueMapper: (chartData, _) =>
                          double.parse(chartData["c"].toString()),
                      /* emptyPointSettings:
                          EmptyPointSettings(mode: EmptyPointMode.drop), */
                      dataSource: _rssController.dataList.value,
                      enableTooltip: true,
                      name: 'Price',
                    ), */
                    /* HiloOpenCloseSeries<dynamic, DateTime>(
                      animationDuration: 0,
                      xValueMapper: (chartData, _) => DateTime.parse(
                          DateFormat("yyyy-MM-dd HH:mm").format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  chartData[0]))),
                      highValueMapper: (chartData, _) =>
                          double.parse(chartData[2]),
                      lowValueMapper: (chartData, _) =>
                          double.parse(chartData[3]),
                      openValueMapper: (chartData, _) =>
                          double.parse(chartData[1]),
                      closeValueMapper: (chartData, _) =>
                          double.parse(chartData[4]),
                      dataSource: _lazyLoadingController.dataList.value,
                      emptyPointSettings:
                          EmptyPointSettings(mode: EmptyPointMode.drop),
                      enableTooltip: true,
                    ), */
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
