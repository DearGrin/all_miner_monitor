import 'dart:async';
import 'dart:io';
import 'package:AllMinerMonitor/models/device_model.dart';
import 'package:AllMinerMonitor/scan_list/scanner_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:AllMinerMonitor/antminer/antminer_model.dart';
import 'package:AllMinerMonitor/avalon_10xx/api_commands.dart';
import 'package:AllMinerMonitor/avalon_10xx/model_avalon.dart';
import 'package:AllMinerMonitor/control_panel/reboot_ui.dart';
import 'package:AllMinerMonitor/ip_section/ip_management_controller.dart';
import 'package:AllMinerMonitor/ip_section/ip_range_model.dart';
import 'package:AllMinerMonitor/miner_overview/miner_overview_screen.dart';
import 'package:AllMinerMonitor/pools_editor/pool_model.dart';
import 'package:AllMinerMonitor/pools_editor/set_pool.dart';
import 'package:AllMinerMonitor/scan_list/event_model.dart';
import 'package:AllMinerMonitor/scan_list/scanner.dart';
import 'package:AllMinerMonitor/scan_list/summary_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../visual_layout/more_dialog.dart';

class ScanListController extends GetxController{
  late Scanner scanner;
  List<dynamic> devices = <dynamic>[];
  List<String> selectedIps = <String>[].obs;
  bool isSelected = false;
  late IpManagementController ipManagementController;
  SummaryModel summary = SummaryModel(speedErrors: [], fanErrors: [], tempErrors: [],  chipCountErrors: [], chipsSErrors: [], hashCountErrors: []);
  StreamSubscription? scanResult;
  late StreamController progress;
  Rx<AvalonData> currentDevice = AvalonData().obs;
  Rx<AntMinerModel> currentAntDevice = AntMinerModel().obs;
  //dynamic currentDevice;
  RxInt displayMode = 0.obs;
  final CommandConstructor commandConstructor = CommandConstructor();
  List<dynamic> apiToDo = [];
  List<Function> toDo = [];
 // Rx<General> generalInfo = General().obs;
 // Rx<Speed> speedInfo = Speed().obs;
  List<int> expandedRasp = [];
  bool isActive = true;
  RxList<String> errors = <String>[].obs;
  RxInt isPopupVisible = (-1).obs;
  RxDouble mousePosition = 0.0.obs;
  int summaryViewMode = 0;
  DateTime? lastScanTime;
  ScannerController scannerController = Get.put(ScannerController());

  @override
  Future<void> onInit() async {
    ipManagementController = Get.put(IpManagementController());
    scanner = Get.put(Scanner());
    scanResult ??= scanner.scanResult.stream.listen((event) {
        handleEvent(event);
      });
   progress = scanner.progressStream;

   scannerController.progress.listen((event) { });
   scannerController.device.listen((event) {handleDevice(event);});

   // await Raspberry().printData('1');

    /*
    try{
    AntMinerModel model = AntMinerModel.fromString(mockAnt, '10.10.10.10');
    print(model);}
    catch(e){
      print(e);
    }


     */

    super.onInit();
  }

  handleDevice(DeviceModel event){
    if(isActive) {
        devices.add(event);
        if (event.isScrypt!) {
          summary.countSCRYPT ++;
          if (event.data.currentSpeed != null) {
            summary.totalHashSCRYPT += event.data.currentSpeed!;
          }
          if (event.data.averageSpeed != null) {
            summary.averageHashSCRYPT += event.data.averageSpeed!;
          }
        }
        else {
          summary.countSHA256 ++;
          if (event.data.currentSpeed != null) {
            summary.totalHashSHA256 += event.data.currentSpeed!;
          }
          if (event.data.averageSpeed != null) {
            summary.averageHashSHA256 += event.data.averageSpeed!;
          }
          if (event.data.tMax != null && summary.maxTemp < event.data.tMax!) {
            summary.maxTemp = event.data.tMax!;
          }

        }
        if(event.data.status=='with problems'){
          summary.withErrors++;
        }
        event.data.speedError==true?summary.speedErrors.add(event.ip!):null;
        event.data.fanError==true?summary.fanErrors.add(event.ip!):null;
        event.data.tempError==true?summary.tempErrors.add(event.ip!):null;
        event.data.chipCountError==true?summary.chipCountErrors.add(event.ip!):null;
        event.data.chipsSError==true?summary.chipsSErrors.add(event.ip!):null;
        event.data.hashCountError==true?summary.hashCountErrors.add(event.ip!):null;
        update(['list', 'summary']);
      }

  }

  handleEvent(EventModel event){

  //  RaspberryAva ava = event.data;
   // print(ava.devices?.length);
    if(isActive) {
      errors.add('${event.ip} ${event.type}');
      errors.add(event.rawData.toString());
      if (event.runtimeType == EventModel && event.type == 'device') {
       devices.add(event.data);
        if (event.data.isScrypt) {
          summary.countSCRYPT ++;
          if (event.data.currentSpeed != null) {
            summary.totalHashSCRYPT += event.data.currentSpeed!;
          }
          if (event.data.averageSpeed != null) {
            summary.averageHashSCRYPT += event.data.averageSpeed!;
          }
        }
        else {
          summary.countSHA256 ++;
          if (event.data.currentSpeed != null) {
            summary.totalHashSHA256 += event.data.currentSpeed!;
          }
          if (event.data.averageSpeed != null) {
            summary.averageHashSHA256 += event.data.averageSpeed!;
          }
          if (event.data.tMax != null && summary.maxTemp < event.data.tMax!) {
            summary.maxTemp = event.data.tMax!;
          }

        }
        if(event.data.status=='with problems'){
          summary.withErrors++;
        }
        event.data.speedError==true?summary.speedErrors.add(event.ip):null;
        event.data.fanError==true?summary.fanErrors.add(event.ip):null;
        event.data.tempError==true?summary.tempErrors.add(event.ip):null;
        event.data.chipCountError==true?summary.chipCountErrors.add(event.ip):null;
        event.data.chipsSError==true?summary.chipsSErrors.add(event.ip):null;
        event.data.hashCountError==true?summary.hashCountErrors.add(event.ip):null;
        update(['list', 'summary']);
      }
      else if (event.runtimeType == EventModel && event.type == 'update') {
        var _d = devices.where((element) => element.ip == event.ip);
        for (var element in _d) {
          element.status = event.data;
        }
      }
      else if (event.runtimeType == EventModel && event.type == 'pool') {
        var _d = devices.where((element) => element.ip == event.ip);
        for (var element in _d) {
          element.pools.add(event.data);
        }
      }
      else if (event.runtimeType == EventModel && event.type == 'error') {
        //   errors.add('received something');
        //   errors.add(event.rawData.toString());
        //  var _d =devices.where((element) => element.ip == event.ip);
        //  for (var element in _d) {element.status = event.data;}
      }
    }
  }
  /*
  startScan() async {
    Get.snackbar('Scan', ipManagementController.ips.length.toString());
    errors.value = [];
    scannerController.scan(scanList: ipManagementController.ips);
    //summary.totalProgress =  await scanner.newScan(scanList: ipManagementController.ips);
  }

   */
  selectIp(String ip, bool value){
    if(value)
      {
        selectedIps.add(ip);
      }
    else{
      selectedIps.remove(ip);
    }
    update(['ips']);
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
    update(['list', 'header','ips']);
  }
  onScanClick()async{
    if(lastScanTime!=null&&(DateTime.now().difference(lastScanTime!)<const Duration(seconds: 3))){
      Get.snackbar('Scan is already in process', 'Please wait');
    }
    else{
      lastScanTime = DateTime.now();
      clearQuery();
      List<IpRangeModel> ipsToScan = ipManagementController.getIpToScan();
      Get.snackbar('Scan', '${ipsToScan.length}');
      errors.clear();
      //scannerController.scan(scanList: ipsToScan);
      //summary.totalProgress = await scanner.newScan(scanList: ipsToScan);
      await scanner.scanStart(scanList: ipsToScan, commandList: ['stats']);
      summary.totalProgress = scanner.commands.length;
      update(['list', 'summary']);
    }
  }
  clearQuery(){
    devices.clear();
    summary.clear();
    selectedIps.clear();
    isSelected = false;
    update(['list', 'summary', 'ips', 'header']);
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
        devices.sort((a,b)=>a.manufacture!.compareTo(b.manufacture!));
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
        devices.sort((a,b)=>a.tInput!.compareTo(b.tInput!));
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
        devices.sort((a,b)=>a.errors!.first.id.toString().compareTo(b.errors!.first.id.toString())); //TODO check for null
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
    List<String> _commands = [];
    List<String> _manufac = [];
    for(int i =0; i < devices.length; i++)
    {
      String _suffix = '';
      if(suffixMode[0]==1) {
        _suffix = pools[0]!.addr!.contains('.')? '':'.'; //TODO nul check?
        List<String> _octet = devices[i].ip.split('.');
        if(_octetCount == 4){
          _suffix +=  _octet[0] +'x' + _octet[1] + 'x' + _octet[2] + 'x' + _octet[3];
        }
        else if(_octetCount==3) {
            _suffix += _octet[1] + 'x' + _octet[2] + 'x' + _octet[3];
        }
          else if (_octetCount==2){
            _suffix += _octet[2] + 'x' + _octet[3];
          }
          else{
            _suffix += _octet[3];
          }
        }
      _manufac.add(devices[i].manufacture);
        if(devices[i].manufacture=='Antminer'){
          Map<String,dynamic> _json = {
            '_ant_pool1url' : pools[0]?.fullAdr??'', '_ant_pool1user' : '${pools[0]?.worker}'+_suffix, '_ant_pool1pw' : pools[0]?.passwd??'',
            '_ant_pool2url' : pools[1]?.fullAdr??'', '_ant_pool2user' : '${pools[1]?.worker}'+_suffix, '_ant_pool2pw' : pools[1]?.passwd??'',
            '_ant_pool3url' : pools[2]?.fullAdr??'', '_ant_pool3user' : '${pools[2]?.worker}'+_suffix, '_ant_pool3pw' : pools[2]?.passwd??''
          };
          _commands.add(_json.toString());
        }
        else{
          String _command = 'ascset|0,setpool'
              ',${ pools[0]?.fullAdr??''}'',${pools[0]?.worker}'+_suffix+',${pools[0]?.passwd??''}'
              ',${ pools[1]?.fullAdr??''}'',${pools[1]?.worker}'+_suffix+',${pools[1]?.passwd??''}'
              ',${ pools[2]?.fullAdr??''}'',${pools[2]?.worker}'+_suffix+',${pools[2]?.passwd??''}';
          _commands.add(_command);
        }


    }
    List<String> _ips = [];
    for(var _ip in devices){
      _ips.add(_ip.ip);
    }
   // scanner.universalCreate(_ips, ['setpool'], addCommands: _commands, manufactures: _manufac, tag: null);
   await scanner.scanStart(ips: _ips, commandList: ['setpool'],  scanTag: null, addCommandList: _commands, manufactureList: _manufac, );
    Get.snackbar('set_pool'.tr, '');
   // scanner.startToChangePools(ips, _pools);
   // create();
  }
  openInBrowser(int index)async{
    String _ip = devices[index].ip;
    final Uri _url = Uri.parse('http://$_ip');
    if (!await launchUrl(_url)) throw 'Could not launch $_ip';
  }
  saveOffset(PointerEvent event){
    mousePosition.value = event.position.dx;
  }
  submitPoolsSelected(List<Pool> pools, List<int> suffixMode) async {
    Box box = await Hive.openBox('settings');
    int? _octetCount = box.get('octet_count');
    List<String> _commands = [];
    List<String> _manufac = [];
    for(int i =0; i < selectedIps.length; i++)
    {
      String _suffix = '';
      if(suffixMode[0]==1) {
        _suffix = pools[0].addr!.contains('.')? '':'.'; //TODO nul check?
       // List<String> _octet = devices[i].ip.split('.');
       var _ = devices.firstWhere((element) => element.ip==selectedIps[i]);
        List<String> _octet = _.ip.split('.');
        if(_octetCount == 4){
          _suffix +=  _octet[0] +'x' + _octet[1] + 'x' + _octet[2] + 'x' + _octet[3];
        }
        else if(_octetCount==3) {
          _suffix += _octet[1] + 'x' + _octet[2] + 'x' + _octet[3];
        }
        else if (_octetCount==2){
          _suffix += _octet[2] + 'x' + _octet[3];
        }
        else{
          _suffix += _octet[3];
        }
      }

      dynamic _device = devices.firstWhere((element) => element.ip==selectedIps[i]);
      String manufacture = _device.manufacture;
      _manufac.add(manufacture);
      if(manufacture=='Antminer'){
        String _ = '${pools[0].fullAdr??''} ${pools[0].worker??'' + _suffix} ${pools[0].passwd??''} '
            '${pools[1].fullAdr??''} ${pools[1].worker??'' + _suffix} ${pools[1].passwd??''} '
            '${pools[2].fullAdr??''} ${pools[2].worker??'' + _suffix} ${pools[2].passwd??''}   '
            '${_device.data.frequency??''}';
        _commands.add(_);
      }
      else{
        String _command = 'ascset|0,setpool'
            ',${ pools[0].fullAdr??''}'',${pools[0].worker}'+_suffix+',${pools[0].passwd??''}'
            ',${ pools[1].fullAdr??''}'',${pools[1].worker}'+_suffix+',${pools[1].passwd??''}'
            ',${ pools[2].fullAdr??''}'',${pools[2].worker}'+_suffix+',${pools[2].passwd??''}';
        _commands.add(_command);
      }
    }
    List<String> _ips = [];
    for(var _ip in selectedIps){
      _ips.add(_ip);
    }
    //scanner.universalCreate(_ips, ['setpool'],addCommands: _commands, manufactures: _manufac, tag: null);
    await scanner.scanStart(ips: _ips, commandList: ['setpool'],  scanTag: null, addCommandList: _commands, manufactureList: _manufac, );
    Get.snackbar('set_pool'.tr, '');

   // scanner.universalCreate(_ips, ['setpool'], commands);




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
  onDoubleTap(dynamic data){
    Get.to(()=>const MinerOverviewScreen(), arguments: data);
    if(data.runtimeType==AvalonData) {
      currentDevice.value = data;
      //Get.dialog(const MinerOverviewScreen(), arguments: data);
    }
    else if(data.runtimeType==AntMinerModel){
      currentAntDevice.value = data;
      //Get.dialog(const MinerOverviewScreen(), arguments: data);
    }
    else{
      //TODO add unknown support
    }
     //TODO change to go to named with params and keep alive
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
  rebootAll() async {
    List<String> _ips = [];
    for(var _ip in devices){
      _ips.add(_ip.ip);
    }
    List<String> _commands = [];
    List<String> _manufac = [];
    for(var i in devices){
      _commands.add(commandConstructor.reboot());
      String manufacture = i.manufacture;
      _manufac.add(manufacture);
    }
    print(_ips);
    print(_commands);
    print(_manufac);
   // scanner.universalCreate(_ips, ['reboot'],addCommands: _commands, manufactures: _manufac, tag: null);
    await scanner.scanStart(ips: _ips, commandList: ['reboot'],  scanTag: null, addCommandList: _commands, manufactureList: _manufac, );
    Get.snackbar('reboot'.tr, '');
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
  rebootSelected() async {
    //scanner.universalCreate(selectedIps, [commandConstructor.reboot()]);
    print('reboot sel and $selectedIps');
    List<String> _commands = [];
    List<String> _manufac = [];
    for(var i in selectedIps){
      _commands.add(commandConstructor.reboot());
      dynamic _device = devices.firstWhere((element) => element.ip==i);
      String manufacture = _device.manufacture;
      _manufac.add(manufacture);
    }
    await scanner.scanStart(ips: selectedIps, commandList: ['reboot'],  scanTag: null, addCommandList: _commands, manufactureList: _manufac, );
  //  scanner.universalCreate(selectedIps, ['reboot'],addCommands: _commands, manufactures: _manufac, tag: null);
    Get.snackbar('reboot'.tr, '');
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
  showPopup(int index){
    isPopupVisible.value = index;
    update(['popup','mouse']);
  }
  showLog(){
    Get.defaultDialog(
        title: '',
        content: SelectableText('${currentAntDevice.value.rawData}')
    );
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
  setActive(bool value){
    isActive = value;
    print('is active $value');
  }
  sendCommandToAll(String command) async {
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
   // scanner.universalCreate(_ips, [command]);
    await scanner.scanStart(ips: _ips, commandList: [command],  scanTag: null);
  }
  sendCommandToSelected(String command) async {
   // apiToDo.clear();
    /*
    for(int i =0; i < selectedIps.length; i++)
    {
      apiToDo.add(Api.sendCommand(selectedIps[i], 4028, command, 1));
    }

     */
    await scanner.scanStart(ips: selectedIps, commandList: [command],  scanTag: null);
 //  scanner.universalCreate(selectedIps, [command]);
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
  saveLog()async{
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    if(!Directory('$appDocumentsPath/All Miner/logs').existsSync()) {
      Directory('$appDocumentsPath/All Miner/logs').create();
    }
    String filePath = '$appDocumentsPath/All Miner/logs/all_miner_log_${DateTime.now()}.txt';
    File file = File(filePath); // 1
   // file.writeAsString(); // 2
    String _path = filePath.replaceAll('\\', '/');
    Get.snackbar('Save complete', _path,);
  }
  switchViewSummaryMode(){
    summaryViewMode==0? summaryViewMode=1:summaryViewMode=0;
    update(['summary_view']);
  }
  showProblemList(){
    List<List<String>> _tmp =[
      summary.tempErrors,
      summary.fanErrors,
      summary.speedErrors,
      summary.hashCountErrors,
      summary.chipCountErrors,
      summary.chipsSErrors
    ];
    Get.defaultDialog(
      title: 'ip_list'.tr,
      content: MoreDialog(_tmp, ''),
    );
  }
}