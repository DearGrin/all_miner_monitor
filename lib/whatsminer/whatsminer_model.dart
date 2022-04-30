class WhatsminerModel {
  List<STATUS>? status;
  List<SUMMARY>? summary;

  WhatsminerModel({this.status, this.summary});

  WhatsminerModel.fromJson(Map<String, dynamic> json) {
    if (json['STATUS'] != null) {
      status = <STATUS>[];
      json['STATUS'].forEach((v) {
        status!.add(new STATUS.fromJson(v));
      });
    }
    if (json['SUMMARY'] != null) {
      summary = <SUMMARY>[];
      json['SUMMARY'].forEach((v) {
        summary!.add(new SUMMARY.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['STATUS'] = this.status!.map((v) => v.toJson()).toList();
    }
    if (this.summary != null) {
      data['SUMMARY'] = this.summary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class STATUS {
  String? sTATUS;
  String? msg;

  STATUS({this.sTATUS, this.msg});

  STATUS.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
    msg = json['Msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['STATUS'] = this.sTATUS;
    data['Msg'] = this.msg;
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
  int? accepted;
  int? rejected;
  int? totalMH;
  int? temperature;
  int? freqAvg;
  int? fanSpeedIn;
  int? fanSpeedOut;
  int? power;
  double? powerRate;
  int? poolRejected;
  int? poolStale;
  int? lastGetwork;
  int? uptime;
  int? securityMode;
  bool? hashStable;
  int? hashStableCostSeconds;
  double? hashDeviation;
  int? targetFreq;
  int? targetMHS;
  int? envTemp;
  String? powerMode;
  int? factoryGHS;
  int? powerLimit;
  double? chipTempMin;
  double? chipTempMax;
  double? chipTempAvg;
  String? debug;
  String? btminerFastBoot;

  SUMMARY(
      {this.elapsed,
        this.mHSAv,
        this.mHS5s,
        this.mHS1m,
        this.mHS5m,
        this.mHS15m,
        this.hSRT,
        this.accepted,
        this.rejected,
        this.totalMH,
        this.temperature,
        this.freqAvg,
        this.fanSpeedIn,
        this.fanSpeedOut,
        this.power,
        this.powerRate,
        this.poolRejected,
        this.poolStale,
        this.lastGetwork,
        this.uptime,
        this.securityMode,
        this.hashStable,
        this.hashStableCostSeconds,
        this.hashDeviation,
        this.targetFreq,
        this.targetMHS,
        this.envTemp,
        this.powerMode,
        this.factoryGHS,
        this.powerLimit,
        this.chipTempMin,
        this.chipTempMax,
        this.chipTempAvg,
        this.debug,
        this.btminerFastBoot});

  SUMMARY.fromJson(Map<String, dynamic> json) {
    elapsed = json['Elapsed'];
    mHSAv = json['MHS av'];
    mHS5s = json['MHS 5s'];
    mHS1m = json['MHS 1m'];
    mHS5m = json['MHS 5m'];
    mHS15m = json['MHS 15m'];
    hSRT = json['HS RT'];
    accepted = json['Accepted'];
    rejected = json['Rejected'];
    totalMH = json['Total MH'];
    temperature = json['Temperature'];
    freqAvg = json['freq_avg'];
    fanSpeedIn = json['Fan Speed In'];
    fanSpeedOut = json['Fan Speed Out'];
    power = json['Power'];
    powerRate = json['Power Rate'];
    poolRejected = json['Pool Rejected%'];
    poolStale = json['Pool Stale%'];
    lastGetwork = json['Last getwork'];
    uptime = json['Uptime'];
    securityMode = json['Security Mode'];
    hashStable = json['Hash Stable'];
    hashStableCostSeconds = json['Hash Stable Cost Seconds'];
    hashDeviation = json['Hash Deviation%'];
    targetFreq = json['Target Freq'];
    targetMHS = json['Target MHS'];
    envTemp = json['Env Temp'];
    powerMode = json['Power Mode'];
    factoryGHS = json['Factory GHS'];
    powerLimit = json['Power Limit'];
    chipTempMin = json['Chip Temp Min'];
    chipTempMax = json['Chip Temp Max'];
    chipTempAvg = json['Chip Temp Avg'];
    debug = json['Debug'];
    btminerFastBoot = json['Btminer Fast Boot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Elapsed'] = this.elapsed;
    data['MHS av'] = this.mHSAv;
    data['MHS 5s'] = this.mHS5s;
    data['MHS 1m'] = this.mHS1m;
    data['MHS 5m'] = this.mHS5m;
    data['MHS 15m'] = this.mHS15m;
    data['HS RT'] = this.hSRT;
    data['Accepted'] = this.accepted;
    data['Rejected'] = this.rejected;
    data['Total MH'] = this.totalMH;
    data['Temperature'] = this.temperature;
    data['freq_avg'] = this.freqAvg;
    data['Fan Speed In'] = this.fanSpeedIn;
    data['Fan Speed Out'] = this.fanSpeedOut;
    data['Power'] = this.power;
    data['Power Rate'] = this.powerRate;
    data['Pool Rejected%'] = this.poolRejected;
    data['Pool Stale%'] = this.poolStale;
    data['Last getwork'] = this.lastGetwork;
    data['Uptime'] = this.uptime;
    data['Security Mode'] = this.securityMode;
    data['Hash Stable'] = this.hashStable;
    data['Hash Stable Cost Seconds'] = this.hashStableCostSeconds;
    data['Hash Deviation%'] = this.hashDeviation;
    data['Target Freq'] = this.targetFreq;
    data['Target MHS'] = this.targetMHS;
    data['Env Temp'] = this.envTemp;
    data['Power Mode'] = this.powerMode;
    data['Factory GHS'] = this.factoryGHS;
    data['Power Limit'] = this.powerLimit;
    data['Chip Temp Min'] = this.chipTempMin;
    data['Chip Temp Max'] = this.chipTempMax;
    data['Chip Temp Avg'] = this.chipTempAvg;
    data['Debug'] = this.debug;
    data['Btminer Fast Boot'] = this.btminerFastBoot;
    return data;
  }
}

