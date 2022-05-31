import 'package:AllMinerMonitor/pools_editor/pool_model.dart';

import '../isolates/int_to_date.dart';

class WhatsminerDevsModel {
  ///general data
  String? status;//
  String? ip;//
  int? ipInt;//
  String? manufacture;//
  String? model;//
  bool isScrypt = false;//
  int? elapsed;//
  String? elapsedString;//
  double? currentSpeed;
  double? averageSpeed;
  int? tMax;
  int? tInput;
  String? mm;
  List<int?>? fans;//
  List<int?>? errors;//
  List<Pool>? pools;//
  String? rawData;
  List<dynamic>? ps;
  List<int?>? netFail;
  ///manufacture specific data
  List<STATUS>? statusMsg;
  List<DEVS>? devs;

  WhatsminerDevsModel({this.status, this.devs, this.ip, this.ipInt, this.statusMsg,
    this.errors, this.model, this.currentSpeed, this.tMax, this.manufacture,
    this.pools, this.averageSpeed, this.elapsed, this.elapsedString, this.fans,
    this.isScrypt=false, this.mm, this.netFail, this.ps, this.rawData, this.tInput});

  WhatsminerDevsModel.fromJson(Map<String, dynamic> json, String _ip) {
    if (json['STATUS'] != null) {
      statusMsg = <STATUS>[];
      for(var v in json['STATUS']){
        statusMsg!.add(STATUS.fromJson(v));
      }
    }
    if (json['DEVS'] != null) {
      devs = <DEVS>[];
      for(var v in json['DEVS']){
        print(v);
        devs!.add(DEVS.fromJson(v));
      }
    }
    ip = _ip;
    List<String> _octet = _ip.split('.');
    if(_octet[3].length==1){
      _octet[3] = '00${_octet[3]}';
    }
    else if(_octet[3].length==2){
      _octet[3] = '0${_octet[3]}';
    }
    ipInt = int.tryParse(_octet.join());
    elapsed = devs?[0].elapsed;
    elapsedString = intToDate(elapsed);
    manufacture = 'Whatsminer';
    model = devs?[0].name;
    status = '';
    fans = [devs?[0].fanIn,devs?[0].fanOut];
    errors = [];
    pools = [];
    rawData = json.toString();
    netFail = [];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (status != null) {
      data['STATUS'] = statusMsg!.map((v) => v.toJson()).toList();
    }
    if (devs != null) {
      data['DEVS'] = devs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class STATUS {
  String? status;
  String? msg;

  STATUS({this.status, this.msg});

  STATUS.fromJson(Map<String, dynamic> json) {
    status = json['STATUS'];
    msg = json['Msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['STATUS'] = status;
    data['Msg'] = msg;
    return data;
  }
}

class DEVS {
  int? aSC;
  int? slot;
  String? enabled;
  String? status;
  double? temperature;
  int? chipFrequency;
  double? mHSAv;
  double? mHS5s;
  double? mHS1m;
  double? mHS5m;
  double? mHS15m;
  double? hSRT;
  int? accepted;
  int? rejected;
  int? lastValidWork;
  int? upfreqComplete;
  int? effectiveChips;
  String? pCBSN;
  String? chipData;
  double? chipTempMin;
  double? chipTempMax;
  double? chipTempAvg;
  int? chipVolDiff;
  int? elapsed;
  String? name;
  int? fanIn;
  int? fanOut;
  DEVS(
      {this.aSC,
        this.slot,
        this.enabled,
        this.status,
        this.temperature,
        this.chipFrequency,
        this.mHSAv,
        this.mHS5s,
        this.mHS1m,
        this.mHS5m,
        this.mHS15m,
        this.hSRT,
        this.accepted,
        this.rejected,
        this.lastValidWork,
        this.upfreqComplete,
        this.effectiveChips,
        this.pCBSN,
        this.chipData,
        this.chipTempMin,
        this.chipTempMax,
        this.chipTempAvg,
        this.chipVolDiff,
        this.elapsed,
        this.name,
        this.fanIn,
        this.fanOut,
      });

  DEVS.fromJson(Map<String, dynamic> json) {
    aSC = json['ASC'];
    print(aSC);
    slot = json['Slot'];
    print(slot);
    enabled = json['Enabled'];
    print(enabled);
    status = json['Status'];
    print(status);
    temperature = json['Temperature'];
    elapsed = json[' Device Elapsed'];
    print(elapsed);
    name = json['Name'];
    print(name);
    fanIn = json['Fan Speed In'];
    print(fanIn);
    fanOut = json['Fan Speed Out'];
    print(fanOut);
    chipFrequency = json['Chip Frequency'];
    mHSAv = json['MHS av'];
    mHS5s = json['MHS 5s'];
    mHS1m = json['MHS 1m'];
    mHS5m = json['MHS 5m'];
    mHS15m = json['MHS 15m'];
    hSRT = json['HS RT'];
    accepted = json['Accepted'];
    rejected = json['Rejected'];
    lastValidWork = json['Last Valid Work'];
    upfreqComplete = json['Upfreq Complete'];
    effectiveChips = json['Effective Chips'];
    pCBSN = json['PCB SN'];
    chipData = json['Chip Data'];
    chipTempMin = json['Chip Temp Min'];
    chipTempMax = json['Chip Temp Max'];
    chipTempAvg = json['Chip Temp Avg'];
    chipVolDiff = json['chip_vol_diff'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ASC'] = this.aSC;
    data['Slot'] = this.slot;
    data['Enabled'] = this.enabled;
    data['Status'] = this.status;
    data['Temperature'] = this.temperature;
    data['Chip Frequency'] = this.chipFrequency;
    data['MHS av'] = this.mHSAv;
    data['MHS 5s'] = this.mHS5s;
    data['MHS 1m'] = this.mHS1m;
    data['MHS 5m'] = this.mHS5m;
    data['MHS 15m'] = this.mHS15m;
    data['HS RT'] = this.hSRT;
    data['Accepted'] = this.accepted;
    data['Rejected'] = this.rejected;
    data['Last Valid Work'] = this.lastValidWork;
    data['Upfreq Complete'] = this.upfreqComplete;
    data['Effective Chips'] = this.effectiveChips;
    data['PCB SN'] = this.pCBSN;
    data['Chip Data'] = this.chipData;
    data['Chip Temp Min'] = this.chipTempMin;
    data['Chip Temp Max'] = this.chipTempMax;
    data['Chip Temp Avg'] = this.chipTempAvg;
    data['chip_vol_diff'] = this.chipVolDiff;
    return data;
  }
}

