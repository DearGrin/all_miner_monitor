import 'package:avalon_tool/ip_section/ip_range_model.dart';
import 'package:avalon_tool/visual_constructor/constructor_model.dart';
import 'package:avalon_tool/visual_constructor/wizard_model.dart';
import 'package:avalon_tool/visual_constructor/wizard_warning.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class WizardController extends GetxController{
  String? tag;
  int counter = 0;
  WizardModel model = WizardModel(rigs: []);
  RxBool tagError = false.obs;
  onEditTag(String value){
    print('tag is $value');
    tag = value;
    final RegExp validate = RegExp('[A-Za-z0-9_:-]+');
    print(validate.hasMatch(value));
    if(value!=''&&validate.hasMatch(value)){
      tagError.value = false;
    }
    else{
      tagError.value = true;
    }
  }
  addItem(){
    model.rigs?.add(WizardRig(id: generateId()));
    update(['rig_wizard']);
  }
  int generateId(){
    counter++;
    return counter;
  }
  deleteItem(int id){
    model.rigs?.removeWhere((element) => element.id==id);
    update(['rig_wizard']);
  }
  setIpRang(int rigId, String value){
    WizardRig? rig = model.rigs?.firstWhere((element) => element.id==rigId);
    rig?.ip = value;
  }
  setShelfCount(int rigId, int value){
    WizardRig? rig = model.rigs?.firstWhere((element) => element.id==rigId);
    rig?.shelfCount = value;
  }
  setPlaceCount(int rigId, int value){
    WizardRig? rig = model.rigs?.firstWhere((element) => element.id==rigId);
    rig?.placePerShelf = value;
  }
  validateData(){}
  onSaveClick() async {
    Layout _model = generateLayout();
    print(_model.tag);
    if(_model.tag ==null || _model.rigs!.isEmpty){
      Get.defaultDialog(
          title: '',
          content: const WizardWarning('Layout is empty or no tag provided')
      );
    }
    else if(_model.tag=='Ip range does not match rig parameters'){
      Get.defaultDialog(
          title: '',
          content: const WizardWarning('Ip range does not match rig parameters')
      );
    }
    else{
      Box box = await Hive.openBox('layouts');
      bool _overwrite = box.keys.contains(tag);
      if(_overwrite){
        Get.defaultDialog(
            title: '',
            content: const WizardWarning('This tag already exists')
        );
      }
      else{
        try{
          Box box = await Hive.openBox('layouts');
          box.put(tag, _model);
         // box.close();
          Get.defaultDialog(
              title: '',
              content: const WizardWarning('Save complete')
          );
        }
        catch(e){
          Get.defaultDialog(
              title: '',
              content:  WizardWarning(e.toString())
          );
        }
      }
    }
  }
  generateLayout(){
    Layout _model= Layout(tag: null, rigs: []);
    bool matchError = false;
    try {
      _model.tag = tag;
      for (var rig in model.rigs!) {
        //TODO add ip check
        List<String> _ips = getIpList([IpRangeModel.fromString(rig.ip!, '')]);
        List<Shelf> _shelves = [];
        for (int i = 0; i < rig.shelfCount!; i++) {
          List<Place> _places = [];
          List<String> _ipOnShelf = [];
          if(_ipOnShelf.length!=rig.placePerShelf!*rig.shelfCount!){
            matchError = true;
          }
          if (rig.fromTop!) {
            _ipOnShelf = _ips.skip(rig.placePerShelf! * i).take(
                rig.placePerShelf!).toList();
          }
          else {
            _ipOnShelf =
                _ips.skip(rig.placePerShelf! * (rig.shelfCount! - i)).take(
                    rig.placePerShelf!).toList();
          }
          if (!rig.fromLeft!) {
            _ipOnShelf = _ipOnShelf.reversed.toList();
          }
          for (int p = 0; p < rig.placePerShelf!; p++) {
            String _ip = '';
            try {
              _ip = _ipOnShelf[p]; //TODO get correct id
            }
            catch (e) {
              print(e);
            }
            _places.add(Place(generateId(), 'miner', ip: _ip));
          }
          _shelves.add(Shelf(generateId(), places: _places));
        }
        _model.rigs?.add(Rig(rig.id!, shelves: _shelves));
      }
      print(matchError);
      if(!matchError) {
        return _model;
      }
      else{
        return Layout(tag: 'Ip range does not match rig parameters', rigs: [Rig(123)]);
      }
    }
    catch(e){
      print(e);
      Get.defaultDialog(
        title: '',
        content: const WizardWarning('Failed to generate layout')
      );
    }
  }
  List<String> getIpList(List<IpRangeModel>? scanList) {
    List<String> _tmp = [];
    if (scanList != null) {
      for (int i = 0; i < scanList.length; i++) {
        List<int>? _start = scanList[i].startIp?.split('.').map((e) =>
        int.tryParse(e)!).toList();
        List<int>? _end = scanList[i].endIp?.split('.').map((e) =>
        int.tryParse(e)!).toList();
        while (_start![3] <= _end![3]) {
          String _ip = _start[0].toString() + '.' + _start[1].toString() + '.' +
              _start[2].toString() + '.' + _start[3].toString();
          _tmp.add(_ip);
          if (_start[3] != _end[3]) {
            _start[3]++;
          }
          else {
            if (_start[2] < _end[2]) {
              _start[3] = 1;
              _start[2] ++;
            }
            else {
              _start[3]++;
            }
          }
        }
      }
    }
    return _tmp;
  }
  Future<bool> checkTag(String tag) async {
    Box box = await Hive.openBox('layouts');
    bool overwrite = box.keys.contains(tag);
    box.close();
    return overwrite;
  }
}