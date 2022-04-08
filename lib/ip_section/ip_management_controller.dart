import 'dart:async';

import 'package:avalon_tool/ip_section/add_ip.dart';
import 'package:avalon_tool/ip_section/ip_range_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class IpManagementController extends GetxController{
  List<IpRangeModel> ips = <IpRangeModel>[].obs;
  String? newIp;
  String? newComment;
  RxBool isNewIpValid = false.obs;
  List<int> selectedIps = <int>[].obs;
  bool editOrAdd = false;
  bool selection = false;
  int currentIndex = 0;
  late Box<IpRangeModel> box;
  //StreamSubscription? sub;
  @override
  Future<void> onInit() async {
    await Hive.openBox<IpRangeModel>('IpRange');
    box = Hive.box<IpRangeModel>('IpRange');
    getInitValues();
    /*
    sub ??= box.watch().listen((event) {
        handleEvent(event.value);
      });
    */
    super.onInit();
  }
  getInitValues(){
    for(int i =0; i < box.values.length; i++)
    {
      if(box.getAt(i)!=null)
        {
          ips.add(box.getAt(i)!);
        }
    }
  }
  handleEvent(IpRangeModel ip){
    ips.add(ip);
  }

  onNewIpChange(String? ip){
    newIp = ip;
    validateNewIp();
  }
  onNewCommentChange(String? comment){
    newComment = comment;
  }
  validateNewIp(){
    final RegExp _startIp = RegExp(r'^((25[0-5]|(2[0-4]|1[0-9]|[1-9]|)[0-9])(\.(?!$)|$)){4}$');
    final RegExp _endIp = RegExp(r'\d|\d\.\d');
    if(newIp!=null && newIp!.contains('-') &&
        _startIp.hasMatch(newIp!.split('-')[0]) &&
        _endIp.hasMatch(newIp!.split('-')[1]))
    {
      isNewIpValid.value = true;
    }
    else{
      isNewIpValid.value = false;
    }
  }
  onCancelNewIp(){
    newIp = null;
    newComment = null;
    isNewIpValid.value = false;
    Get.back();
  }
  onSaveNewIp(){
    IpRangeModel ip = IpRangeModel.fromString(newIp!, newComment);
    if(editOrAdd){
      box.putAt(currentIndex, ip);
      ips[currentIndex] = ip;
    }
    else{
      box.add(ip);
      ips.add(ip);
    }
    Get.back();
  }
  onDeleteSelectedIps(){
    for(int i = 0; i < selectedIps.length; i++)
      {
        box.deleteAt(i);
        ips.removeAt(i);
        selectedIps.clear();
      }

  }
  onTap(int index){
    if(selectedIps.contains(index)){
      selectedIps.remove(index);
      selection = false;
    }
    else{
      selectedIps.add(index);
      selection = true;
    }
    update(['$index']);
  }
  onSelectIp(int index, bool value){
    if(value){
      selectedIps.add(index);
      selection = true;
    }
    else{
      selectedIps.remove(index);
      selection = false;
    }
    update(['$index']);
  }
  onAddNewIp(BuildContext context){
    editOrAdd = false;
    newIp = '';
    newComment = '';
    openDialog(context);
  }
  onEditIp(int index, BuildContext context){
    editOrAdd = true;
    IpRangeModel ip = ips[index];
    currentIndex = index;
    newIp = ip.rawIpRange;
    newComment = ip.comment;
    openDialog(context);
    isNewIpValid.value = true;
  }
  List<IpRangeModel> getIpToScan(){
    List<IpRangeModel> _tmp = [];
    for(int i = 0; i<selectedIps.length; i++)
      {
        _tmp.add(ips[selectedIps[i]]);
      }
    return _tmp;
  }
  openDialog(BuildContext context){
    Get.defaultDialog(
        title: 'ip_edit'.tr,
        titleStyle: Theme.of(context).textTheme.bodyText2,
        content: const AddIp()
    );
  }
}