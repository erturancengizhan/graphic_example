import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphic_example/controller/lazy_loading_controller.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

LazyLoadingController _lazyLoadingController =
    Get.find<LazyLoadingController>();

class LazyLoadingChart extends StatelessWidget {
  const LazyLoadingChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('LazyLoading Chart'),
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
                  _lazyLoadingController.intervalList.length,
                  (index) {
                    return Row(
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            _lazyLoadingController.dataList.value.clear();
                            _lazyLoadingController.count.value = 0;
                            /* _lazyLoadingController.minCount.value = 0;
                            _lazyLoadingController.maxCount.value = 40; */
                            _lazyLoadingController.selectedInterval.value =
                                index;
                            await _lazyLoadingController.getBinanceData(
                                interval:
                                    _lazyLoadingController.intervalList[index]);
                          },
                          child: Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: _lazyLoadingController
                                            .selectedInterval.value ==
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
                                _lazyLoadingController.intervalList[index],
                                style: TextStyle(
                                    color: _lazyLoadingController
                                                .selectedInterval.value ==
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
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) async {
                          await _lazyLoadingController.getBinanceData(
                              interval: _lazyLoadingController.intervalList[
                                  _lazyLoadingController
                                      .selectedInterval.value]);
                        },
                      );
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
                  primaryXAxis: DateTimeAxis(
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
                    //maximumLabels: 2,
                    labelAlignment: LabelAlignment.end,
                    //edgeLabelPlacement: EdgeLabelPlacement.hide,
                    visibleMinimum: DateTime.fromMillisecondsSinceEpoch(
                        _lazyLoadingController
                                .dataList[_lazyLoadingController.minCount.value]
                            [0]),
                    visibleMaximum: DateTime.fromMillisecondsSinceEpoch(
                        _lazyLoadingController
                                .dataList[_lazyLoadingController.maxCount.value]
                            [0]),
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
                      dataSource: _lazyLoadingController.dataList.value,
                      xValueMapper: (chartData, _) => DateTime.parse(
                          DateFormat("yyyy-MM-dd HH:mm").format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  chartData[0]))),
                      yValueMapper: (chartData, _) =>
                          double.parse(chartData[4]),
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
                      onRendererCreated: (ChartSeriesController controller) {
                        _lazyLoadingController.seriesController = controller;
                      },
                      enableSolidCandles: true,
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
                      emptyPointSettings:
                          EmptyPointSettings(mode: EmptyPointMode.drop),
                      dataSource: _lazyLoadingController.dataList.value,
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
