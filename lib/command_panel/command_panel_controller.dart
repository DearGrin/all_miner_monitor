import 'package:avalon_tool/avalon_10xx/api.dart';
import 'package:avalon_tool/avalon_10xx/api_commands.dart';
import 'package:avalon_tool/command_panel/command_list.dart';
import 'package:avalon_tool/scan_list/scan_list_controller.dart';
import 'package:get/get.dart';

class CommandPanelController extends GetxController{
  RxString command ='-'.obs;
  RxString rawCommand = ''.obs;
  int? valueToSet;
  List<List<int>> freqToSet = [[500,525,650],[00,525,650],[00,525,650]].obs;
  final CommandConstructor commandConstructor = CommandConstructor();
  final Api api = Api();
  late ScanListController scanListController;
  //RxString withOptions = false.obs;
  @override
  onInit(){
    scanListController =  Get.put(ScanListController());
    super.onInit();
  }
  onCommandSelect(String? value){
    String _rawCommand =  commands.firstWhere((element) => element.keys.first==value).values.first.keys.first;
    String _withOptions =  commands.firstWhere((element) => element.keys.first==value).values.first.values.first;
    command.value = value??'';
    //withOptions.value = _withOptions=='none'? false:true;
    rawCommand.value = _rawCommand??''; //TODO get list of commands
  }
  onInputChange(String value){
    rawCommand.value = value??'';
  }
  onTempChange(String value){
    int? _value = int.tryParse(value);
      valueToSet = _value;
     rawCommand.value = commandConstructor.setTemp(_value);
  }
  onVoltChange(String value){
    int? _value = int.tryParse(value);
    valueToSet = _value;
    rawCommand.value = commandConstructor.setVoltage(_value);
  }
  onChipTempChange(String value){
    int? _value = int.tryParse(value);
    valueToSet = _value;
    rawCommand.value = commandConstructor.setChipMaxTemp(_value);
  }
  onFreqSelect(int value, int index, int hashBoard){
    freqToSet[hashBoard][index]=value;
    //rawCommand.value = commandConstructor.setFreq(freq1, freq2, freq3, freq4, hash_no);
  }
  submitAll(){
    scanListController.sendCommandToAll(rawCommand.value);
  }
  submitSelected(){
    scanListController.sendCommandToSelected(rawCommand.value);
  }
}