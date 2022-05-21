class WhatsminerDevsModel {
  List<STATUS>? status;
  List<DEVS>? devs;

  WhatsminerDevsModel({this.status, this.devs});

  WhatsminerDevsModel.fromJson(Map<String, dynamic> json) {
    if (json['STATUS'] != null) {
      status = <STATUS>[];
      json['STATUS'].forEach((v) {
        status!.add(STATUS.fromJson(v));
      });
    }
    if (json['DEVS'] != null) {
      devs = <DEVS>[];
      json['DEVS'].forEach((v) {
        devs!.add(DEVS.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (status != null) {
      data['STATUS'] = status!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['STATUS'] = this.status;
    data['Msg'] = this.msg;
    return data;
  }
}

class DEVS {
  int? aSC;
  int? slot;
  String? enabled;
  String? status;
  int? temperature;
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
        this.chipVolDiff});

  DEVS.fromJson(Map<String, dynamic> json) {
    aSC = json['ASC'];
    slot = json['Slot'];
    enabled = json['Enabled'];
    status = json['Status'];
    temperature = json['Temperature'];
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

