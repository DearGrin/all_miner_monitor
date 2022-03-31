import 'package:avalon_tool/avalon_10xx/api.dart';
import 'package:avalon_tool/avalon_10xx/api_commands.dart';
import 'package:avalon_tool/avalon_10xx/mock_data.dart';
import 'package:avalon_tool/avalon_10xx/model_avalon.dart';
import 'package:avalon_tool/avalon_10xx/regexp_parser.dart';
import 'package:get/get.dart';

class AvalonController extends GetxController{
  final Api api = Api();
  final CommandConstructor command = CommandConstructor();
  final RegExpHelper regExpHelper = RegExpHelper();
  final String address;
  final int port;
  int hashBoardCount =0;
  AvalonController(this.address, this.port);
 // Rx<AvalonModel> model = AvalonModel().obs;
  Rx<AvalonData> data = AvalonData().obs;
  @override
  void onInit() {
    // TODO: implement onInit
    getInfo(); //TODO is await needed?
    super.onInit();
  }
  getInfo() {
    //String? info = await api.sendCommand(address, port, command.getStats(), 10);
    //final AvalonModel model = AvalonModel(general: General.fromString(mockData));
    data.value = AvalonData.fromString(mockData, '10.10.10.10');

   // print('current speed ' + data.value.currentSpeed.toString());
   // model.value.general = General.fromString(mockData);
    //model.value.speed = Speed.fromString(mockData);
    //model.value.powerSupply = PowerSupply.fromString(mockData);
    //model.value.hashboards = Hashboards.fromString(mockData);
    hashBoardCount = RegExpHelper().pvtT.allMatches(mockData).length;
   // model.value.hashboard = [];
    for(int i = 0; i < hashBoardCount!; i++)
      {
        Hashboard _ = Hashboard.fromString(i, mockData);
     //   model.value.hashboard!.add(_);
      }
  }
  /*
  String getEchuString(int boardIndex){
    String _ = '';
    model.value.hashboard?[boardIndex]?.errors?.forEach((element) {
      _ = _ + element.id.toString() + ' - ' + element.descr + '\n';
    });
    return _;
  }

   */
}