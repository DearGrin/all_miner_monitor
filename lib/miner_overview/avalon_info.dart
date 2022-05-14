import 'package:avalon_tool/utils/analyse_resolver.dart';
import 'package:avalon_tool/avalon_10xx/avalon_error_codes.dart';
import 'package:avalon_tool/avalon_10xx/model_avalon.dart';
import 'package:avalon_tool/miner_overview/overview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvalonInfo extends StatelessWidget {
  const AvalonInfo({Key? key}) : super(key: key);

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
                                Text('version'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].data.version ?? '', style: Theme.of(context).textTheme.bodyText2),
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('elapsed'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].data.elapsedString.toString(), style: Theme.of(context).textTheme.bodyText2),
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('dna'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].data.dna ?? '', style: Theme.of(context).textTheme.bodyText2),
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('work_mode'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].data.workMode ?? '', style: Theme.of(context).textTheme.bodyText2),
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('temp_input'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].data.tInput.toString(),
                                    style: Theme.of(context).textTheme.bodyText1?.
                                    copyWith(color: analyseResolver.getColor(
                                        'temp_input', controller.device[0].data.tInput))
                                ), //TODO get color scheme
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('fans'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText.rich(
                                  TextSpan(
                                    children: fans(controller.device[0].data.fans, controller.device[0].data.fanR, context, analyseResolver),
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('errors_ecmm'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText.rich(
                                  TextSpan(
                                    children: errors(controller.device[0].data.ECMM, context),
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

                                SelectableText(controller.device[0].data.hashBoardCount.toString(),
                                    style: Theme.of(context).textTheme.bodyText2?.
                                    copyWith(color: controller.device[0].data.hashBoardCount!
                                        < controller.device[0].data.maxHashBoards!
                                        ? Colors.red:null)),


                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('temps'.tr, style: Theme.of(context).textTheme.bodyText1,),

                                SelectableText.rich(
                                  TextSpan(
                                      children: [
                                        TextSpan(
                                            text: controller.device[0].data.tAvg.toString(),
                                            style: Theme.of(context).textTheme.bodyText2!.
                                            copyWith(color: analyseResolver.getColor(
                                                'temp_max', controller.device[0].data.tAvg))
                                        ),
                                        TextSpan(text: '/', style: Theme.of(context).textTheme.bodyText2),
                                        TextSpan(
                                            text: controller.device[0].data.tMax.toString(),
                                            style: Theme.of(context).textTheme.bodyText2!.
                                            copyWith(color:analyseResolver.getColor(
                                                'max_temp', controller.device[0].data.tMax))
                                        ),
                                      ]
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
                                    children: tempsByBoard(controller.device[0].data.tMaxByHashBoard,controller.device[0].data.hashBoards,  context, analyseResolver),
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
                                    children: hardwareErrors(controller.device[0].data.dh, controller.device[0].data.hw, context, analyseResolver),
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
                                SelectableText(controller.device[0].data.freq.toString(), style: Theme.of(context).textTheme.bodyText2),
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('current_speed'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].data.currentSpeed?.toStringAsFixed(2) ?? '' 'Th/s',
                                    style: Theme.of(context).textTheme.bodyText2?.
                                    copyWith(color: analyseResolver.getColor('min_speed', controller.device[0].currentSpeed))
                                ),
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('average_speed'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].data.averageSpeed?.toStringAsFixed(2) ?? '' 'Th/s',
                                    style: Theme.of(context).textTheme.bodyText2?.
                                    copyWith(color: analyseResolver.getColor('min_speed', controller.device[0].data.averageSpeed))
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
                                Text('voltage_mm'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].data.voltageMM.toString()+ 'V', style: Theme.of(context).textTheme.bodyText2), //TODO add some check?
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('voltage_out'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].data.voltageOutput.toString()+ 'V', style: Theme.of(context).textTheme.bodyText2), //TODO add some check?
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('voltage_req'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].data.voltageOutput.toString()+'V', style: Theme.of(context).textTheme.bodyText2), //TODO add some check?
                              ],
                            ),

                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('hash_consumption'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].data.powerHashBoards.toString() +
                                    'A/' + controller.device[0].data.consumption.toString() +
                                    'W', style: Theme.of(context).textTheme.bodyText2),
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('total_consumption'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].data.consumption.toString()+ 'W', style: Theme.of(context).textTheme.bodyText2), //TODO add some check?
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('ps_communication'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].data.psCommunication.toString(), style: Theme.of(context).textTheme.bodyText2), //TODO add some check?
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              /// Extras info
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
                          child: Text('extras'.tr, style: Theme.of(context).textTheme.bodyText2),
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
                                Text('aging'.tr, style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(controller.device[0].data.aging.toString(), style: Theme.of(context).textTheme.bodyText2),
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
  List<InlineSpan> errors(List<AvalonError>? errors, BuildContext context){
    List<InlineSpan> _tmp = [];
    if(errors!=null){
      for(int i = 0; i<errors.length; i++){
        _tmp.add(TextSpan(
          text: errors[i].id.toString() + ' - ' + errors[i].descr +'\n',
          style: Theme.of(context).textTheme.bodyText2?.copyWith(color:
          null // TODO get from analyze
          ),
        ));
      }
    }
    return _tmp;
  }
  List<InlineSpan> tempsByBoard(List<int?>? temps, List<Hashboard>? hashboards, BuildContext context,AnalyseResolver analyseResolver){
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
    else{
      for(int i =0; i < hashboards!.length; i++){
        int _t = 0;
        for(int n=0; n< hashboards[i].chips!.length; n++){
          if(hashboards[i].chips![n].temp!=null &&  hashboards[i].chips![n].temp!>0)
          {
            _t +=hashboards[i].chips![n].temp!;
          }
        }
        int _tA = (_t/hashboards[i].chips!.length).floor();
        _tmp.add(TextSpan(
          text: _tA.toString(),
          style: Theme.of(context).textTheme.bodyText2?.copyWith(color:
          analyseResolver.getColor('temp_max', _tA)),
        ));
        if(i+1 < hashboards!.length)
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
  List<InlineSpan> hardwareErrors(double? dh, int? hw, BuildContext context, AnalyseResolver analyseResolver){
    List<InlineSpan> _tmp = [];
    _tmp.add(TextSpan(
      text: dh.toString() +'%',
      style: Theme.of(context).textTheme.bodyText2?.
      copyWith(color: analyseResolver.getColor('dh', dh)),
    ));
    _tmp.add(TextSpan(
      text: '/',
      style: Theme.of(context).textTheme.bodyText2,
    ));
    _tmp.add(TextSpan(
      text: hw.toString(),
      style: Theme.of(context).textTheme.bodyText2?.
      copyWith(color: hw!=null? hw<10000? null:Colors.red:null), //TODO get some formula
    ));


    return _tmp;
  }
  List<InlineSpan> fans(List<int?> fans, int? fanR, BuildContext context, AnalyseResolver analyseResolver){
    List<InlineSpan> _tmp = [];
    if(fans !=null) {
      for (int i = 0; i < fans!.length; i++) {
        _tmp.add(
            TextSpan(
              text: fans?[i].toString(),
              style: Theme.of(context).textTheme.bodyText2?.copyWith(color:
              analyseResolver.getColor('null', fans?[i])),
            )
        );
        if(i+1 < fans!.length)
        {
          _tmp.add(TextSpan(text: '/', style: Theme.of(context).textTheme.bodyText2));
        }
      }
    }
    _tmp.add(
        TextSpan(text: ' - ' + fanR.toString()  + '%',
            style: Theme.of(context).textTheme.bodyText2?.copyWith(color:
            analyseResolver.getColor('null', fanR)))
    );
    return _tmp;
  }
}
