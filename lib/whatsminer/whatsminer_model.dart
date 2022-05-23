class WhatsminerModel {
  List<STATUS>? status;
  List<SUMMARY>? summary;

  WhatsminerModel({this.status, this.summary});

  WhatsminerModel.fromJson(Map<String, dynamic> json) {
    if (json['STATUS'] != null) {
      status = <STATUS>[];
      json['STATUS'].forEach((v) {
        status!.add(STATUS.fromJson(v));
      });
    }
    if (json['SUMMARY'] != null) {
      summary = <SUMMARY>[];
      json['SUMMARY'].forEach((v) {
        summary!.add(SUMMARY.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (status != null) {
      data['STATUS'] = status!.map((v) => v.toJson()).toList();
    }
    if (summary != null) {
      data['SUMMARY'] = summary!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['STATUS'] = sTATUS;
    data['Msg'] = msg;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Elapsed'] = elapsed;
    data['MHS av'] = mHSAv;
    data['MHS 5s'] = mHS5s;
    data['MHS 1m'] = mHS1m;
    data['MHS 5m'] = mHS5m;
    data['MHS 15m'] = mHS15m;
    data['HS RT'] = hSRT;
    data['Accepted'] = accepted;
    data['Rejected'] = rejected;
    data['Total MH'] = totalMH;
    data['Temperature'] = temperature;
    data['freq_avg'] = freqAvg;
    data['Fan Speed In'] = fanSpeedIn;
    data['Fan Speed Out'] = fanSpeedOut;
    data['Power'] = power;
    data['Power Rate'] = powerRate;
    data['Pool Rejected%'] = poolRejected;
    data['Pool Stale%'] = poolStale;
    data['Last getwork'] = lastGetwork;
    data['Uptime'] = uptime;
    data['Security Mode'] = securityMode;
    data['Hash Stable'] = hashStable;
    data['Hash Stable Cost Seconds'] = hashStableCostSeconds;
    data['Hash Deviation%'] = hashDeviation;
    data['Target Freq'] = targetFreq;
    data['Target MHS'] = targetMHS;
    data['Env Temp'] = envTemp;
    data['Power Mode'] = powerMode;
    data['Factory GHS'] = factoryGHS;
    data['Power Limit'] = powerLimit;
    data['Chip Temp Min'] = chipTempMin;
    data['Chip Temp Max'] = chipTempMax;
    data['Chip Temp Avg'] = chipTempAvg;
    data['Debug'] = debug;
    data['Btminer Fast Boot'] = btminerFastBoot;
    return data;
  }
}

