import 'package:avalon_tool/analyzator/analyse_resolver.dart';
import 'package:avalon_tool/miner_overview/overview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AntminerInfo extends StatelessWidget {
  const AntminerInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final OverviewController controller = Get.put(OverviewController());
    final AnalyseResolver analyseResolver = Get.put(AnalyseResolver());
    return SingleChildScrollView(
        controller: scrollController,
        child: Column(
            children: [
              ///General Info
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Get.theme.cardTheme.color,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('general'.tr, style: Theme.of(context).textTheme.bodyText2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0, left: 12.0, right: 8.0, bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('model'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].model ?? '', style: Theme.of(context).textTheme.bodyText2),
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('version'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].mm ?? '', style: Theme.of(context).textTheme.bodyText2),
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('elapsed'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].elapsedString.toString(), style: Theme.of(context).textTheme.bodyText2),
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('fans'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText.rich(
                                  TextSpan(
                                    children: fans(controller.device[0].fans, context, analyseResolver),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ///Hashboard info
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Get.theme.cardTheme.color,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('hashboards'.tr, style: Theme.of(context).textTheme.bodyText2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0, left: 12.0, right: 8.0, bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('board_count'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].data.hashCount.toString(),
                                    style: Theme.of(context).textTheme.bodyText2?.
                                    copyWith(color: analyseResolver.getColor(
                                        'hash_count', controller.device[0].data.hashCount,
                                        controller.device[0].model))
                                ),
                              ],
                            ),
                            //TODO chip count
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('chips_by_board'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText.rich(
                                  TextSpan(
                                    children: chipByChain(controller.device[0].data.chipPerChain,controller.device[0].model ,context, analyseResolver),
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('temps chip'.tr, style: Theme.of(context).textTheme.bodyText1,),

                                SelectableText.rich(
                                  TextSpan(
                                    children: tempsByBoard(controller.device[0].data.tChipO, context, analyseResolver),
                                  ),
                                ),



                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('temps_by_boards'.tr, style: Theme.of(context).textTheme.bodyText1,),

                                SelectableText.rich(
                                  TextSpan(
                                    children: tempsByBoard(controller.device[0].data.tPcbO, context, analyseResolver),
                                  ),
                                ),

                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('hard_errors'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText.rich(
                                  TextSpan(
                                    children: hardwareErrors(controller.device[0].data.hwPerChain, context),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              /// Speed info
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Get.theme.cardTheme.color,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('speed'.tr, style: Theme.of(context).textTheme.bodyText2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0, left: 12.0, right: 8.0, bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('frequency'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].data.freqs.toString(), style: Theme.of(context).textTheme.bodyText2),
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('current_speed'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].data.currentSpeed?.toStringAsFixed(2) ?? '' '${controller.device[0].isScrypt? ' Gh/s':' Th/s'}',
                                    style: Theme.of(context).textTheme.bodyText2?.
                                    copyWith(color: analyseResolver.getColor('min_speed', controller.device[0].data.currentSpeed, controller.device[0].data.model))
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              /// Power Supply info
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Get.theme.cardTheme.color,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('power_supply'.tr, style: Theme.of(context).textTheme.bodyText2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0, left: 12.0, right: 8.0, bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('voltage'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].data.volt.toString(), style: Theme.of(context).textTheme.bodyText2), //TODO add some check?
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('hash_consumption'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].data.watt.toString(), style: Theme.of(context).textTheme.bodyText2),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]
        )
    );
  }
  List<InlineSpan> fans(List<int?> data, BuildContext context, AnalyseResolver analyseResolver){
    List<InlineSpan> _tmp = [];
    if(data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        _tmp.add(
            TextSpan(
              text: data[i].toString(),
              style: Theme.of(context).textTheme.bodyText2?.copyWith(color:
              analyseResolver.getColor('null', data[i])),
            )
        );
        if(i+1 < data.length)
        {
          _tmp.add(TextSpan(text: '/', style: Theme.of(context).textTheme.bodyText2));
        }
      }
    }
    return _tmp;
  }
  List<InlineSpan> tempsByBoard(List<int?> temps, BuildContext context, AnalyseResolver analyseResolver){
    List<InlineSpan> _tmp = [];
    if(temps!=null) {
      for (int i = 0; i < temps.length; i++) {
        _tmp.add(TextSpan(
          text: temps[i].toString(),
          style: Theme.of(context).textTheme.bodyText2?.copyWith(color:
          analyseResolver.getColor('temp_max', temps[i])),
        ));
        if(i+1 < temps.length)
        {
          _tmp.add(TextSpan(
            text: '/',
            style: Theme.of(context).textTheme.bodyText2,
          ));
        }
      }
    }
    return _tmp;
  }
  List<InlineSpan> hardwareErrors(List<int?> hw, BuildContext context){
    print(hw);
    List<InlineSpan> _tmp = [];
    if(hw.isNotEmpty){
      for(int i = 0; i < hw.length; i++){
        _tmp.add(TextSpan(
          text: hw[i].toString(),
          style: Theme.of(context).textTheme.bodyText2?.
          copyWith(color: hw[i]!=null? hw[i]!<5000? null:Colors.red:null), //TODO get some formula
        ));
        if(i+1 < hw.length)
        {
          _tmp.add(TextSpan(
            text: '/',
            style: Theme.of(context).textTheme.bodyText2,
          ));
        }
      }
    }
    return _tmp;
  }
  List<InlineSpan> chipByChain(List<int?> chips, String model, BuildContext context, AnalyseResolver analyseResolver){
    List<InlineSpan> _tmp = [];
    if(chips!=null) {
      for (int i = 0; i < chips.length; i++) {
        _tmp.add(TextSpan(
          text: chips[i].toString(),
          style: Theme.of(context).textTheme.bodyText2?.copyWith(color:
          analyseResolver.getColor('chip_count', chips[i], model)),
        ));
        if(i+1 < chips.length)
        {
          _tmp.add(TextSpan(
            text: '/',
            style: Theme.of(context).textTheme.bodyText2,
          ));
        }
      }
    }
    return _tmp;
  }
}
