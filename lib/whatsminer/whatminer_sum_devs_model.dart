import 'package:AllMinerMonitor/pools_editor/pool_model.dart';

import '../isolates/int_to_date.dart';

class WhatsminerModel {
  ///general data
  String? status;//
  String? ip;//
  int? ipInt;//
  String? manufacture;//
  String? model;//
  bool? isScrypt;//
  int? elapsed;//
  String? elapsedString;//
  double? currentSpeed;//
  double? averageSpeed;//
  int? tMax;//
  int? tInput;//
  String? mm;//
  List<int?>? fans;//
  List<int?>? errors;//
  List<Pool>? pools;//
  String? rawData;//
  List<dynamic>? ps;//
  List<int?>? netFail;//
  bool? speedError;
  bool? fanError;
  bool? tempError;
  bool? chipCountError;
  bool? chipsSError;
  bool? hashCountError;
  int? hashBoardCount;
  ///manufacture specific data
  List<Summary>? summary;
  List<Devs>? devs;
  int? id;

  WhatsminerModel({this.summary, this.devs, this.id, this.netFail, this.rawData, this.pools,
    this.errors, this.fans, this.elapsed, this.model, this.manufacture, this.elapsedString,
    this.ip, this.tInput, this.ps, this.mm, this.isScrypt, this.averageSpeed, this.tMax,
    this.currentSpeed, this.ipInt, this.status, this.chipCountError, this.speedError,
    this.chipsSError, this.hashCountError, this.fanError, this.tempError, this.hashBoardCount});

  WhatsminerModel.fromJson(Map<String, dynamic> json, String _ip, String? _model) {
    print('lets do whats');
    print(json);
    if (json['summary'] != null) {
      summary = <Summary>[];
      for(var v in json['summary']){
        summary!.add(Summary.fromJson(v));
      }
    }
    print(summary);
    if (json['devs'] != null) {
      devs = <Devs>[];
      for(var v in json['devs']){
        devs!.add(Devs.fromJson(v));
      }
    }
    print(devs);
    id = json['id'];
    status = '';
    ip = _ip;
    List<String> _octet = _ip.split('.');
    if(_octet[3].length==1){
      _octet[3] = '00${_octet[3]}';
    }
    else if(_octet[3].length==2){
      _octet[3] = '0${_octet[3]}';
    }
    ipInt = int.tryParse(_octet.join());
    elapsed = summary?[0].summary?[0].elapsed;
    elapsedString = intToDate(elapsed);
    manufacture = 'Whatsminer';
    model = _model;//TODO get maodel
    print('model: $model');
    mm = summary?[0].summary?[0].firmwareVersion;
    fans = [summary?[0].summary?[0].fanSpeedIn, summary?[0].summary?[0].fanSpeedOut];
    isScrypt = false;
    currentSpeed = ((summary?[0].summary?[0].mHS1m??0)/1000000);
    averageSpeed = ((summary?[0].summary?[0].mHSAv??0)/1000000);
    tMax = summary?[0].summary?[0].temperature?.toInt();
    errors = [];
    pools = [];
    ps = [];
    netFail = [];
    rawData = json.toString();
    hashBoardCount = devs?[0].devs?.length??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (summary != null) {
      data['summary'] = summary!.map((v) => v.toJson()).toList();
    }
    if (devs != null) {
      data['devs'] = devs!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}

class Summary {
  List<STATUS>? statusMsg;
  List<SUMMARY>? summary;
  int? id;

  Summary({this.statusMsg, this.summary, this.id});

  Summary.fromJson(Map<String, dynamic> json) {
    print(json);
    if (json['STATUS'] != null) {
      statusMsg = <STATUS>[];
      for(var v in json['STATUS']){
        statusMsg!.add(STATUS.fromJson(v));
      }
    }
    print(statusMsg);
    if (json['SUMMARY'] != null) {
      summary = <SUMMARY>[];
      for(var v in json['SUMMARY']){
        summary!.add(SUMMARY.fromJson(v));
      }
    }
    print(summary);
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (statusMsg != null) {
      data['STATUS'] = statusMsg!.map((v) => v.toJson()).toList();
    }
    if (summary != null) {
      data['SUMMARY'] = summary!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}

class STATUS {
  String? status;
  int? when;
  int? code;
  String? msg;
  String? description;

  STATUS({this.status, this.when, this.code, this.msg, this.description});

  STATUS.fromJson(Map<String, dynamic> json) {
    status = json['STATUS'];
    when = json['When'];
    code = json['Code'];
    msg = json['Msg'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['STATUS'] = status;
    data['When'] = when;
    data['Code'] = code;
    data['Msg'] = msg;
    data['Description'] = description;
    return data;
  }
}

class SUMMARY {
  int? elapsed;
  double? mHSAv;
  double? mHS5s;
  double? mHS1m;
  double? mHS5m;
  double? mHS15m;
  double? hSRT;
  int? foundBlocks;
  int? getworks;
  int? accepted;
  int? rejected;
  int? hardwareErrors;
  double? utility;
  int? discarded;
  int? stale;
  int? getFailures;
  int? localWork;
  int? remoteFailures;
  int? networkBlocks;
  double? totalMH;
  double? workUtility;
  double? difficultyAccepted;
  double? difficultyRejected;
  double? difficultyStale;
  int? bestShare;
  double? temperature;
  int? freqAvg;
  int? fanSpeedIn;
  int? fanSpeedOut;
  int? voltage;
  int? power;
  int? powerRT;
  double? deviceHardware;
  double? deviceRejected;
  double? poolRejected;
  double? poolStale;
  int? lastGetwork;
  int? uptime;
  String? chipData;
  int? powerCurrent;
  int? powerFanspeed;
  int? errorCodeCount;
  int? factoryErrorCodeCount;
  int? securityMode;
  bool? liquidCooling;
  bool? hashStable;
  int? hashStableCostSeconds;
  double? hashDeviation;
  int? targetFreq;
  int? targetMHS;
  String? powerMode;
  String? firmwareVersion;
  String? cBPlatform;
  String? cBVersion;
  String? mAC;
  int? factoryGHS;
  int? powerLimit;
  double? chipTempMin;
  double? chipTempMax;
  double? chipTempAvg;

  SUMMARY(
      {this.elapsed,
        this.mHSAv,
        this.mHS5s,
        this.mHS1m,
        this.mHS5m,
        this.mHS15m,
        this.hSRT,
        this.foundBlocks,
        this.getworks,
        this.accepted,
        this.rejected,
        this.hardwareErrors,
        this.utility,
        this.discarded,
        this.stale,
        this.getFailures,
        this.localWork,
        this.remoteFailures,
        this.networkBlocks,
        this.totalMH,
        this.workUtility,
        this.difficultyAccepted,
        this.difficultyRejected,
        this.difficultyStale,
        this.bestShare,
        this.temperature,
        this.freqAvg,
        this.fanSpeedIn,
        this.fanSpeedOut,
        this.voltage,
        this.power,
        this.powerRT,
        this.deviceHardware,
        this.deviceRejected,
        this.poolRejected,
        this.poolStale,
        this.lastGetwork,
        this.uptime,
        this.chipData,
        this.powerCurrent,
        this.powerFanspeed,
        this.errorCodeCount,
        this.factoryErrorCodeCount,
        this.securityMode,
        this.liquidCooling,
        this.hashStable,
        this.hashStableCostSeconds,
        this.hashDeviation,
        this.targetFreq,
        this.targetMHS,
        this.powerMode,
        this.firmwareVersion,
        this.cBPlatform,
        this.cBVersion,
        this.mAC,
        this.factoryGHS,
        this.powerLimit,
        this.chipTempMin,
        this.chipTempMax,
        this.chipTempAvg});

  SUMMARY.fromJson(Map<String, dynamic> json) {
    elapsed = json['Elapsed'];
    print(elapsed);
    mHSAv = json['MHS av'];
    print(mHSAv);
    mHS5s = json['MHS 5s'];
    mHS1m = json['MHS 1m'];
    mHS5m = json['MHS 5m'];
    mHS15m = json['MHS 15m'];
    hSRT = json['HS RT'];
    foundBlocks = json['Found Blocks'];
    getworks = json['Getworks'];
    accepted = json['Accepted'];
    rejected = json['Rejected'];
    hardwareErrors = json['Hardware Errors'];
    utility = json['Utility'];
    discarded = json['Discarded'];
    stale = json['Stale'];
    getFailures = json['Get Failures'];
    localWork = json['Local Work'];
    print(localWork);
    remoteFailures = json['Remote Failures'];
    networkBlocks = json['Network Blocks'];
    totalMH = json['Total MH'];
    print(totalMH);
    workUtility = json['Work Utility'];
    print(1);
    difficultyAccepted = json['Difficulty Accepted'];
    print(2);
    difficultyRejected = json['Difficulty Rejected'];
    print(3);
    difficultyStale = json['Difficulty Stale'];
    print(4);
    bestShare = json['Best Share'];
    print(5);
    temperature = json['Temperature'];
    print(6);
    freqAvg = json['freq_avg'];
    print(7);
    fanSpeedIn = json['Fan Speed In'];
    print(8);
    fanSpeedOut = json['Fan Speed Out'];
    print(fanSpeedOut);
    voltage = json['Voltage'];
    power = json['Power'];
    powerRT = json['Power_RT'];
    deviceHardware = json['Device Hardware%'];
    deviceRejected = json['Device Rejected%'];
    poolRejected = json['Pool Rejected%'];
    print(poolRejected);
    poolStale = json['Pool Stale%'];
    print(poolStale);
    lastGetwork = json['Last getwork'];
    uptime = json['Uptime'];
    chipData = json['Chip Data'];
    powerCurrent = json['Power Current'];
    powerFanspeed = json['Power Fanspeed'];
    errorCodeCount = json['Error Code Count'];
    factoryErrorCodeCount = json['Factory Error Code Count'];
    securityMode = json['Security Mode'];
    print(securityMode);
    liquidCooling = json['Liquid Cooling'];
    hashStable = json['Hash Stable'];
    hashStableCostSeconds = json['Hash Stable Cost Seconds'];
    hashDeviation = json['Hash Deviation%'];
    targetFreq = json['Target Freq'];
    print(9);
    targetMHS = json['Target MHS'];
    print(10);
    powerMode = json['Power Mode'];
    print(11);
    firmwareVersion = json['Firmware Version'];
    print(12);
    cBPlatform = json['CB Platform'];
    print(13);
    cBVersion = json['CB Version'];
    print(14);
    mAC = json['MAC'];
    print(15);
    factoryGHS = json['Factory GHS'];
    print(16);
    powerLimit = json['Power Limit'];
    print(17);
    chipTempMin = json['Chip Temp Min'];
    print(18);
    chipTempMax = json['Chip Temp Max'];
    print(19);
    chipTempAvg = json['Chip Temp Avg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Elapsed'] = elapsed;
    data['MHS av'] = mHSAv;
    data['MHS 5s'] = mHS5s;
    data['MHS 1m'] = mHS1m;
    data['MHS 5m'] = mHS5m;
    data['MHS 15m'] = mHS15m;
    data['HS RT'] = hSRT;
    data['Found Blocks'] = foundBlocks;
    data['Getworks'] = getworks;
    data['Accepted'] = accepted;
    data['Rejected'] = rejected;
    data['Hardware Errors'] = hardwareErrors;
    data['Utility'] = utility;
    data['Discarded'] = discarded;
    data['Stale'] = stale;
    data['Get Failures'] = getFailures;
    data['Local Work'] = localWork;
    data['Remote Failures'] = remoteFailures;
    data['Network Blocks'] = networkBlocks;
    data['Total MH'] = totalMH;
    data['Work Utility'] = workUtility;
    data['Difficulty Accepted'] = difficultyAccepted;
    data['Difficulty Rejected'] = difficultyRejected;
    data['Difficulty Stale'] = difficultyStale;
    data['Best Share'] = bestShare;
    data['Temperature'] = temperature;
    data['freq_avg'] = freqAvg;
    data['Fan Speed In'] = fanSpeedIn;
    data['Fan Speed Out'] = fanSpeedOut;
    data['Voltage'] = voltage;
    data['Power'] = power;
    data['Power_RT'] = powerRT;
    data['Device Hardware%'] = deviceHardware;
    data['Device Rejected%'] = deviceRejected;
    data['Pool Rejected%'] = poolRejected;
    data['Pool Stale%'] = poolStale;
    data['Last getwork'] = lastGetwork;
    data['Uptime'] = uptime;
    data['Chip Data'] = chipData;
    data['Power Current'] = powerCurrent;
    data['Power Fanspeed'] = powerFanspeed;
    data['Error Code Count'] = errorCodeCount;
    data['Factory Error Code Count'] = factoryErrorCodeCount;
    data['Security Mode'] = securityMode;
    data['Liquid Cooling'] = liquidCooling;
    data['Hash Stable'] = hashStable;
    data['Hash Stable Cost Seconds'] = hashStableCostSeconds;
    data['Hash Deviation%'] = hashDeviation;
    data['Target Freq'] = targetFreq;
    data['Target MHS'] = targetMHS;
    data['Power Mode'] = powerMode;
    data['Firmware Version'] = firmwareVersion;
    data['CB Platform'] = cBPlatform;
    data['CB Version'] = cBVersion;
    data['MAC'] = mAC;
    data['Factory GHS'] = factoryGHS;
    data['Power Limit'] = powerLimit;
    data['Chip Temp Min'] = chipTempMin;
    data['Chip Temp Max'] = chipTempMax;
    data['Chip Temp Avg'] = chipTempAvg;
    return data;
  }
}

class Devs {
  List<STATUS>? statusMsg;
  List<DEVS>? devs;
  int? id;

  Devs({this.statusMsg, this.devs, this.id});

  Devs.fromJson(Map<String, dynamic> json) {
    if (json['STATUS'] != null) {
      statusMsg = <STATUS>[];
      for(var v in json['STATUS']){
        statusMsg!.add(STATUS.fromJson(v));
      }
    }
    print(statusMsg);
    if (json['DEVS'] != null) {
      devs = <DEVS>[];
      for(var v in json['DEVS']){
        devs!.add(DEVS.fromJson(v));
      }
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (statusMsg != null) {
      data['STATUS'] = statusMsg!.map((v) => v.toJson()).toList();
    }
    if (devs != null) {
      data['DEVS'] = devs!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}

class DEVS {
  int? aSC;
  String? name;
  int? iD;
  int? slot;
  String? enabled;
  String? status;
  double? temperature;
  int? chipFrequency;
  int? fanSpeedIn;
  int? fanSpeedOut;
  double? mHSAv;
  double? mHS5s;
  double? mHS1m;
  double? mHS5m;
  double? mHS15m;
  int? accepted;
  int? rejected;
  int? hardwareErrors;
  double? utility;
  int? lastSharePool;
  int? lastShareTime;
  double? totalMH;
  int? diff1Work;
  double? difficultyAccepted;
  double? difficultyRejected;
  double? lastShareDifficulty;
  int? lastValidWork;
  double? deviceHardware;
  double? deviceRejected;
  int? deviceElapsed;
  int? upfreqComplete;
  int? effectiveChips;
  String? pCBSN;
  String? chipData;
  double? chipTempMin;
  double? chipTempMax;
  double? chipTempAvg;

  DEVS(
      {this.aSC,
        this.name,
        this.iD,
        this.slot,
        this.enabled,
        this.status,
        this.temperature,
        this.chipFrequency,
        this.fanSpeedIn,
        this.fanSpeedOut,
        this.mHSAv,
        this.mHS5s,
        this.mHS1m,
        this.mHS5m,
        this.mHS15m,
        this.accepted,
        this.rejected,
        this.hardwareErrors,
        this.utility,
        this.lastSharePool,
        this.lastShareTime,
        this.totalMH,
        this.diff1Work,
        this.difficultyAccepted,
        this.difficultyRejected,
        this.lastShareDifficulty,
        this.lastValidWork,
        this.deviceHardware,
        this.deviceRejected,
        this.deviceElapsed,
        this.upfreqComplete,
        this.effectiveChips,
        this.pCBSN,
        this.chipData,
        this.chipTempMin,
        this.chipTempMax,
        this.chipTempAvg});

  DEVS.fromJson(Map<String, dynamic> json) {
    print(json);
    aSC = json['ASC'];
    name = json['Name'];
    iD = json['ID'];
    slot = json['Slot'];
    enabled = json['Enabled'];
    status = json['Status'];
    print(1);
    temperature = json['Temperature'];
    print(2);
    chipFrequency = json['Chip Frequency'];
    print(3);
    fanSpeedIn = json['Fan Speed In'];
    fanSpeedOut = json['Fan Speed Out'];
    print(4);
    mHSAv = json['MHS av'];
    mHS5s = json['MHS 5s'];
    mHS1m = json['MHS 1m'];
    mHS5m = json['MHS 5m'];
    mHS15m = json['MHS 15m'];
    print(5);
    accepted = json['Accepted'];
    rejected = json['Rejected'];
    hardwareErrors = json['Hardware Errors'];
    utility = json['Utility'];
    lastSharePool = json['Last Share Pool'];
    lastShareTime = json['Last Share Time'];
    print(6);
    totalMH = json['Total MH'];
    diff1Work = json['Diff1 Work'];
    difficultyAccepted = json['Difficulty Accepted'];
    difficultyRejected = json['Difficulty Rejected'];
    lastShareDifficulty = json['Last Share Difficulty'];
    lastValidWork = json['Last Valid Work'];
    print(7);
    deviceHardware = json['Device Hardware%'];
    deviceRejected = json['Device Rejected%'];
    deviceElapsed = json['Device Elapsed'];
    upfreqComplete = json['Upfreq Complete'];
    effectiveChips = json['Effective Chips'];
    print(8);
    pCBSN = json['PCB SN'];
    chipData = json['Chip Data'];
    chipTempMin = json['Chip Temp Min'];
    chipTempMax = json['Chip Temp Max'];
    chipTempAvg = json['Chip Temp Avg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ASC'] = aSC;
    data['Name'] = name;
    data['ID'] = iD;
    data['Slot'] = slot;
    data['Enabled'] = enabled;
    data['Status'] = status;
    data['Temperature'] = temperature;
    data['Chip Frequency'] = chipFrequency;
    data['Fan Speed In'] = fanSpeedIn;
    data['Fan Speed Out'] = fanSpeedOut;
    data['MHS av'] = mHSAv;
    data['MHS 5s'] = mHS5s;
    data['MHS 1m'] = mHS1m;
    data['MHS 5m'] = mHS5m;
    data['MHS 15m'] = mHS15m;
    data['Accepted'] = accepted;
    data['Rejected'] = rejected;
    data['Hardware Errors'] = hardwareErrors;
    data['Utility'] = utility;
    data['Last Share Pool'] = lastSharePool;
    data['Last Share Time'] = lastShareTime;
    data['Total MH'] = totalMH;
    data['Diff1 Work'] = diff1Work;
    data['Difficulty Accepted'] = difficultyAccepted;
    data['Difficulty Rejected'] = difficultyRejected;
    data['Last Share Difficulty'] = lastShareDifficulty;
    data['Last Valid Work'] = lastValidWork;
    data['Device Hardware%'] = deviceHardware;
    data['Device Rejected%'] = deviceRejected;
    data['Device Elapsed'] = deviceElapsed;
    data['Upfreq Complete'] = upfreqComplete;
    data['Effective Chips'] = effectiveChips;
    data['PCB SN'] = pCBSN;
    data['Chip Data'] = chipData;
    data['Chip Temp Min'] = chipTempMin;
    data['Chip Temp Max'] = chipTempMax;
    data['Chip Temp Avg'] = chipTempAvg;
    return data;
  }
}
