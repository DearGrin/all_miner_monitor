import 'package:avalon_tool/visual_constructor/confirm_overwrite.dart';
import 'package:avalon_tool/visual_constructor/constructor_model.dart';
import 'package:avalon_tool/visual_constructor/save_result.dart';
import 'package:avalon_tool/visual_layout/layout_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ConstructorController extends GetxController{
  List<int> settings = [10, 7, 5].obs;
  //List<int> items = [0,1,2,3,4,5].obs;
  RxInt selectedItem = 0.obs; //TODO change type and track
  Rig? selectedRig;
  //String? tag = 'test';
 // final rigs = [].obs;
  final layout = Layout(tag: null, rigs: []).obs;
  int counter = 0;
 // bool canSave = false;
  String? initialTag;
  @override
  onInit() async {
    /*
    Box box = await Hive.openBox('settings');
    try {
      settings = box.get('constructor_settings');
     // generateRigs(settings[0]);
    }
    catch(e){
      print(e);
    }
    generateRigs(settings[0]);
    rigSelect(0);
    update(['rigs']);
    */
    super.onInit();
  }
  setData(String? tag)async{
    if(tag!=null && tag!='a very new layout'){
      Box box = await Hive.openBox('layouts');
      layout.value = box.get('$tag');
      counter = layout.value.counter??0;
      initialTag = tag;
    }
    else{
      Box box = await Hive.openBox('settings');
      try {
        settings = box.get('constructor_settings');
        // generateRigs(settings[0]);
      }
      catch(e){
        print(e);
      }
      generateRigs(settings[0]);
      rigSelect(0);
    }
    update(['rigs']);
  }
  int generateId(){
    counter++;
    layout.value.counter = counter;
    return counter;
  }
  generateRigs(int rigCount){
    for(int i =0; i < rigCount; i++){
      List<Shelf> _shelves = [];
      for(int i =0; i < settings[1]; i++)
      {
        _shelves.add(Shelf(generateId()));
      }
      layout.value.rigs?.add(
          Rig(generateId(), shelves: _shelves
          ));
    }
  }
  reorderRigs(int oldIndex, int newIndex){
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Rig item =  layout.value.rigs!.removeAt(oldIndex);
    layout.value.rigs!.insert(newIndex, item);
    selectedItem.value = newIndex;
    update(['rigs']);
  }
  reorderPlaces(int oldIndex, int newIndex, int rigId, int shelfId){
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    Rig _rig =  layout.value.rigs!.firstWhere((element) => element.id==rigId);
    Shelf _shelf = _rig.shelves!.firstWhere((element) => element.id==shelfId);
    final Place item = _shelf.places!.removeAt(oldIndex);
    _shelf.places!.insert(newIndex, item);
    update(['$rigId/$shelfId']);
  }
  rigSelect(int index){
    selectedItem.value = index;
    selectedRig =  layout.value.rigs![index];
    update(['rigs','stack']);
  }

  addRig(){
    settings[0]++;
    List<Shelf> _shelves = [];
    for(int i =0; i < settings[1]; i++)
    {
      _shelves.add(Shelf(generateId()));
    }
    layout.value.rigs?.add(Rig(generateId(), shelves: _shelves));
   // items.add(items.length);
    update(['rigs']);
  }

  deleteRig(int index){
    if( layout.value.rigs!.length>1) {
      settings[0]--;
      layout.value.rigs?.removeAt(index);
      if (index == selectedItem.value) {
        rigSelect(0);
      }
    }
    update(['rigs']);
  }
  onRigCountChange(String value){
    try{
      int _newVal = int.parse(value);
      settings[0] = _newVal;
    }
    catch(e){
      print(e);
    }
  }
  onRowCountChange(String value){
    try{
      int _newVal = int.parse(value);
      settings[1] = _newVal;
    }
    catch(e){
      print(e);
    }
  }
  onMinerPerAucChange(String value){
    try{
      int _newVal = int.parse(value);
      settings[2] = _newVal;
    }
    catch(e){
      print(e);
    }
  }
  onNextClick(){
   // Get.to(()=>ContConstructorScreen());
  }
  List<Place> getPlace(int rigId, int shelfId){
    Rig _rig =  layout.value.rigs!.firstWhere((element) => element.id==rigId);
    Shelf _shelf = _rig.shelves!.firstWhere((element) => element.id==shelfId);
    List<Place>? _places = _shelf.places;
    return _places??[];
  }
  addMiner(int rigId, int shelfId){
    Rig _rig =  layout.value.rigs!.firstWhere((element) => element.id==rigId);
    Shelf _shelf = _rig.shelves!.firstWhere((element) => element.id==shelfId);
    List<Place>? _places = _shelf.places;
    _places==null? _places=[Place(generateId(),'miner')]:_places.add(Place(generateId(),'miner'));
    _shelf.places = _places;
    update(['$rigId/$shelfId']);
  }
  deleteMiner(int rigId, int shelfId, int placeId){
    Rig _rig =  layout.value.rigs!.firstWhere((element) => element.id==rigId);
    Shelf _shelf = _rig.shelves!.firstWhere((element) => element.id==shelfId);
    _shelf.places?.removeWhere((element) => element.id==placeId);
    update(['$rigId/$shelfId']);
  }
  addAuc(int rigId, int shelfId){
    Rig _rig =  layout.value.rigs!.firstWhere((element) => element.id==rigId);
    Shelf _shelf = _rig.shelves!.firstWhere((element) => element.id==shelfId);
    List<Place>? _places = _shelf.places;
    _places==null? _places=[Place(generateId(),'auc', aucN: 0)]:_places.add(Place(generateId(),'auc', aucN: 0));
    _shelf.places = _places;
    update(['$rigId/$shelfId']);
  }
  addShelf(int rigId){
    Rig _rig =  layout.value.rigs!.firstWhere((element) => element.id==rigId);
    _rig.shelves?.add(Shelf(generateId()));
    update(['rig_$rigId']);
  }
  deleteShelf(int rigId, int shelfId){
    Rig _rig =  layout.value.rigs!.firstWhere((element) => element.id==rigId);
    _rig.shelves?.removeWhere((element) => element.id==shelfId);
    update(['rig_$rigId']);
  }
  editIp(int rigId, int shelfId, int placeId, String value){
    Rig _rig =  layout.value.rigs!.firstWhere((element) => element.id==rigId);
    Shelf _shelf = _rig.shelves!.firstWhere((element) => element.id==shelfId);
    Place _place = _shelf.places!.firstWhere((element) => element.id==placeId);
    _place.ip=value;
  }
  editAucNumber(int rigId, int shelfId, int placeId, int? aucN){
    Rig _rig =  layout.value.rigs!.firstWhere((element) => element.id==rigId);
    Shelf _shelf = _rig.shelves!.firstWhere((element) => element.id==shelfId);
    Place _place = _shelf.places!.firstWhere((element) => element.id==placeId);
    _place.aucN = aucN;
    update(['$rigId/$shelfId/$placeId']);
  }
  bool canSave(){
    if(layout.value.tag!=null&&layout.value.tag!=''){
      return true;
    }
    else{
      return false;
    }
  }
  onSaveClick()async{
    if(canSave()) {
      Box box = await Hive.openBox('layouts');
      var _keys = box.keys;

      print(layout.value.tag);
      if (_keys.contains(layout.value.tag)) {
        Get.defaultDialog(
          title: '',
          content: const ConfirmOverwrite(),
        );
      }
      else {
        save();
      }
    }
    else{
      print('empty tag');
    }
  }
  save() async {
    collectIps();
    Box box = await Hive.openBox('layouts');
    try {
      box.put('${layout.value.tag}', layout.value);
      Get.defaultDialog(title: '', content: const SaveResult('Save complete'));
    }
    catch(e){
      Get.defaultDialog(title: '', content: SaveResult('$e'));
    }

    if(initialTag!=null && initialTag!=layout.value.tag){
      box.delete(initialTag);
    }
  }
  editTag(String value){
    layout.value.tag = value;
  }
  collectIps(){
    List<String?> _ips = [];
    if(layout.value.rigs!=null) {
      for (Rig rig in layout.value.rigs!) {
        if(rig.shelves!=null) {
          for (Shelf shelf in rig.shelves!) {
            if(shelf.places!=null) {
              for (Place place in shelf.places!) {
                if (!_ips.contains(place.ip)) {
                  _ips.add(place.ip);
                }
              }
            }
          }
        }
      }
    }
    layout.value.ips = _ips;
  }
}