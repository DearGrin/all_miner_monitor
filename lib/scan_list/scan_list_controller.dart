import 'dart:async';

import 'package:avalon_tool/avalon_10xx/api.dart';
import 'package:avalon_tool/avalon_10xx/api_commands.dart';
import 'package:avalon_tool/avalon_10xx/model_avalon.dart';
import 'package:avalon_tool/avalon_10xx/overview_screen.dart';
import 'package:avalon_tool/ip_section/ip_management_controller.dart';
import 'package:avalon_tool/ip_section/ip_range_model.dart';
import 'package:avalon_tool/pools_editor/pool_model.dart';
import 'package:avalon_tool/scan_list/event_model.dart';
import 'package:avalon_tool/scan_list/scanner.dart';
import 'package:avalon_tool/scan_list/summary_model.dart';
import 'package:avalon_tool/pools_editor/set_pool.dart';
import 'package:avalon_tool/control_panel/reboot_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ScanListController extends GetxController{
  late Scanner scanner;
  List<dynamic> devices = <dynamic>[];
  List<String> selectedIps = <String>[].obs;
  bool isSelected = false;
  late IpManagementController ipManagementController;
  SummaryModel summary = SummaryModel();
  StreamSubscription? scanResult;
  late StreamController progress;
  Rx<AvalonData> currentDevice = AvalonData().obs;
  RxInt displayMode = 0.obs;
  final Api api = Api();
  final CommandConstructor commandConstructor = CommandConstructor();
  List<dynamic> apiToDo = [];
  List<Function> toDo = [];
 // Rx<General> generalInfo = General().obs;
 // Rx<Speed> speedInfo = Speed().obs;
  List<int> expandedRasp = [];

  List<String> errors = <String>[].obs;

  @override
  Future<void> onInit() async {
    ipManagementController = Get.put(IpManagementController());
    scanner = Get.put(Scanner());
    scanResult ??= scanner.scanResult.stream.listen((event) {
        handleEvent(event);
      });
   progress = scanner.progressStream;
   // await Raspberry().printData('1');
    super.onInit();
  }

  handleEvent(dynamic event){
    if(event.runtimeType==EventModel && event.type=='device')
      {
        devices.add(event.data);
        summary.count ++;
        if(event.data.currentSpeed!=null)
        {
          summary.totalHash +=event.data.currentSpeed!;
        }
        if(event.data.averageSpeed!=null)
        {
          summary.averageHash += event.data.averageSpeed!;
        }
        if(event.data.ECMM!.isNotEmpty) // TODO add into count ECHU errors and PS
            {
          summary.withErrors ++;
        }
        if(event.data.tMax!=null && summary.maxTemp < event.data.tMax!)
        {
          summary.maxTemp = event.data.tMax!;
        }
        update(['list', 'summary']);
      }
    else if(event.runtimeType==EventModel && event.type=='update'){
      var _d =devices.where((element) => element.ip == event.ip);
      for (var element in _d) {element.status = event.data;}
    }
    else if(event.runtimeType==EventModel && event.type=='pool'){
      var _d =devices.where((element) => element.ip == event.ip);
      for (var element in _d) {element.pools.add(event.data);}
    }
    else  if(event.runtimeType==EventModel && event.type=='error'){
      errors.add('received something');
      errors.add(event.data.toString());
    //  var _d =devices.where((element) => element.ip == event.ip);
    //  for (var element in _d) {element.status = event.data;}
    }

  }
  startScan(String startIp, String endIp) async {
    await scanner.newScan(ipManagementController.ips);
  }
  selectIp(String ip, bool value){
    if(value)
      {
        selectedIps.add(ip);
      }
    else{
      selectedIps.remove(ip);
    }
  }
  selectAll(bool value){
    selectedIps = [];
    if(value)
      {
        for(int i = 0; i < devices.length; i++)
          {
            selectedIps.add(devices[i].ip!);
          }
      }
    isSelected = value;
    update(['list', 'header']);
  }
  onScanClick(){
    devices.clear();
    summary.clear();
    update(['list', 'summary']);
    List<IpRangeModel> ipsToScan = ipManagementController.getIpToScan();
    scanner.newScan(ipsToScan);
  }

  sort(String type, bool reverse){
    switch(type){
      case 'status':
        devices.sort((a,b)=>a.status!.compareTo(b.status!));
        break;
      case 'ip':
        devices.sort((a,b)=>a.ipInt.compareTo(b.ipInt));
        break;
      case 'manufacture':
        devices.sort((a,b)=>a.company!.compareTo(b.company!));
        break;
      case 'model':
        devices.sort((a,b)=>a.model!.compareTo(b.model!));
        break;
      case 'elapsed':
        devices.sort((a,b)=>a.elapsed!.compareTo(b.elapsed!));
        break;
      case 'Th/s':
        devices.sort((a,b)=>a.currentSpeed!.compareTo(b.currentSpeed!));
        break;
      case 'Th/s avg':
        devices.sort((a,b)=>a.averageSpeed!.compareTo(b.averageSpeed!));
        break;
      case 'tempInput':
        devices.sort((a,b)=>a.tempInput!.compareTo(b.tempInput!));
        break;
      case 'tempMax':
        devices.sort((a,b)=>a.tMax!.compareTo(b.tMax!)); //TODO check for null
        break;
      case 'fans':
        devices.sort((a,b)=>a.fans.toString().compareTo(b.fans.toString()));
        break;
      case 'mm':
        devices.sort((a,b)=>a.mm!.compareTo(b.mm!));
        break;
      case 'errors':
        devices.sort((a,b)=>a.ECMM!.first.id.toString().compareTo(b.ECMM!.first.id.toString())); //TODO check for null
        break;
      case 'ps':
        devices.sort((a,b)=>a.ps.toString().compareTo(b.ps.toString()));
        break;
      case 'net_fail':
        devices.sort((a,b)=>a.netFail.toString().compareTo(b.netFail.toString()));
        break;
      case 'pool1':
        //devices.sort((a,b)=>a.model!.compareTo(b.model!));
        break;
      case 'pool2':
      //devices.sort((a,b)=>a.model!.compareTo(b.model!));
        break;
      case 'pool3':
      //devices.sort((a,b)=>a.model!.compareTo(b.model!));
        break;
      case 'worker1':
      //devices.sort((a,b)=>a.model!.compareTo(b.model!));
        break;
      case 'worker2':
      //devices.sort((a,b)=>a.model!.compareTo(b.model!));
        break;
      case 'worker3':
      //devices.sort((a,b)=>a.model!.compareTo(b.model!));
        break;
    }
    if(reverse)
    {
      devices = devices.reversed.toList();
    }
    update(['list']);
  }
  onEditPoolsClick(){
    Get.defaultDialog(
        title: 'pools edit',
        content: SetPool()
    );
  }
  submitPoolsAll(List<Pool?> pools, List<int> suffixMode) async {
   // apiToDo.clear();
    Box box = await Hive.openBox('settings');
    int? _octetCount = box.get('octet_count');
    List<String> commands = [];
    for(int i =0; i < devices.length; i++)
    {
      String _suffix = '';
      if(suffixMode[0]==1) {
        _suffix = pools[0]!.addr!.contains('.')? '':'.'; //TODO nul check?
        List<String> _octet = devices[i].ip.split('.');
        if(_octetCount==3) {
            _suffix += _octet[1] + 'x' + _octet[2] + 'x' + _octet[3];
        }
          else if (_octetCount==2){
            _suffix += _octet[2] + 'x' + _octet[3];
          }
          else{
            _suffix += _octet[3];
          }
        }


        commands.add(commandConstructor.setPools('root', 'root',
            pools[0]!.addr!+_suffix, pools[0]?.worker??'', pools[0]?.passwd??''));
    }
    List<String> _ips = [];
    for(var _ip in devices){
      _ips.add(_ip.ip);
    }
    scanner.universalCreate(_ips, commands);
   // scanner.startToChangePools(ips, _pools);
   // create();
  }
  submitPoolsSelected(List<Pool> pools, List<int> suffixMode) async {
    Box box = await Hive.openBox('settings');
    int? _octetCount = box.get('octet_count');
    List<String> commands = [];
    for(int i =0; i < selectedIps.length; i++)
    {
      String _suffix = '';
      if(suffixMode[0]==1) {
        _suffix = pools[0]!.addr!.contains('.')? '':'.'; //TODO nul check?
       // List<String> _octet = devices[i].ip.split('.');
       var _ = devices.firstWhere((element) => element.ip==selectedIps[i]);
        List<String> _octet = _.ip.split('.');
        if(_octetCount==3) {
          _suffix += _octet[1] + 'x' + _octet[2] + 'x' + _octet[3];
        }
        else if (_octetCount==2){
          _suffix += _octet[2] + 'x' + _octet[3];
        }
        else{
          _suffix += _octet[3];
        }
      }


      commands.add(commandConstructor.setPools('root', 'root',
          pools[0]!.addr!+_suffix, pools[0]?.worker??'', pools[0]?.passwd??''));
    }
    scanner.universalCreate(selectedIps, commands);
    /*
    apiToDo.clear();
    for(int i =0; i < selectedIps.length; i++)
    {
      apiToDo.add(Api.sendCommand(selectedIps[i], 4028,
          commandConstructor.setPools('root', 'root', pools[0]?.addr??'', pools[0]?.worker??'', pools[0]?.passwd??''), //TOD get from settings
          1));
    }
    create();

     */
   // scanner.startToChangePools(selectedIps, pools);
  }
  onDoubleTap(AvalonData data){
   // generateInfo(index);
    currentDevice.value = data;
    Get.dialog(const OverviewScreen()); //TODO change to go to named with params and keep alive
  }
  selectByClick(int index){
    String _ip = devices[index].ip!;
    bool _isSelected = selectedIps.contains(_ip);
    selectIp(_ip, !_isSelected);
  }
  onRebootPres(){
    Get.defaultDialog(
      title: 'reboot options',
      content: const RebootUI(),
    );
  }
  rebootAll(){
    List<String> _ips = [];
    for(var _ip in devices){
      _ips.add(_ip.ip);
    }
    scanner.universalCreate(_ips, [commandConstructor.reboot()]);
    /*
    apiToDo.clear();
    for(int i =0; i < devices.length; i++)
      {
        apiToDo.add(Api.sendCommand(devices[i].ip, 4028, commandConstructor.reboot(), 1));
      }
    create();

     */
    //TODO execute function
    //Get.back();
  }
  rebootSelected(){
    scanner.universalCreate(selectedIps, [commandConstructor.reboot()]);
    /*
    apiToDo.clear();
    for(int i =0; i < selectedIps.length; i++)
    {
      apiToDo.add(Api.sendCommand(selectedIps[i], 4028, commandConstructor.reboot(), 1));
    }
    create()
    ;
     */
    //Get.back();
  }
  cancel(){
    Get.back();
  }
  updateHeaders(){

    update(['headers']);
  }
  onModeSwitch(int value){
    displayMode.value = value;
  }
  expand(int index){
    if(expandedRasp.contains(index)){
      expandedRasp.remove(index);
    }
    else{
      expandedRasp.add(index);
    }
    update(['expand_$index']);
  }
  sendCommandToAll(String command){
    /*
    apiToDo.clear();
    for(int i =0; i < devices.length; i++)
    {
      apiToDo.add(Api.sendCommand(devices[i].ip, 4028, command, 1));
    }


     */
    //create();
    List<String> _ips = [];
    for(var _ip in devices){
      _ips.add(_ip.ip);
    }
    scanner.universalCreate(_ips, [command]);
  }
  sendCommandToSelected(String command){
   // apiToDo.clear();
    /*
    for(int i =0; i < selectedIps.length; i++)
    {
      apiToDo.add(Api.sendCommand(selectedIps[i], 4028, command, 1));
    }

     */

   scanner.universalCreate(selectedIps, [command]);
  }
  /*
  create(){
    toDo.clear();
    for(int i=0; i < apiToDo.length; i++){
      toDo.add(
              () async {await compute(apiToDo[i],'').whenComplete(() => null)
              ;}
      );
    }
  }


   */
}