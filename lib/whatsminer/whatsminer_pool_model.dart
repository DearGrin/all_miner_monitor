class WhatsminerPoollModel {
  List<STATUS>? status;
  List<POOLS>? pools;

  WhatsminerPoollModel({this.status, this.pools});

  WhatsminerPoollModel.fromJson(Map<String, dynamic> json) {
    if (json['STATUS'] != null) {
      status = <STATUS>[];
      json['STATUS'].forEach((v) {
        status!.add(new STATUS.fromJson(v));
      });
    }
    if (json['POOLS'] != null) {
      pools = <POOLS>[];
      json['POOLS'].forEach((v) {
        pools!.add(new POOLS.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['STATUS'] = this.status!.map((v) => v.toJson()).toList();
    }
    if (this.pools != null) {
      data['POOLS'] = this.pools!.map((v) => v.toJson()).toList();
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

class POOLS {
  int? pOOL;
  String? uRL;
  String? status;
  int? priority;
  int? quota;
  String? longPoll;
  int? getworks;
  int? accepted;
  int? rejected;
  int? works;
  int? discarded;
  int? stale;
  int? getFailures;
  int? remoteFailures;
  String? user;
  int? lastShareTime;
  int? diff1Shares;
  String? proxyType;
  String? proxy;
  int? difficultyAccepted;
  int? difficultyRejected;
  int? difficultyStale;
  int? lastShareDifficulty;
  int? workDifficulty;
  int? hasStratum;
  bool? stratumActive;
  String? stratumURL;
  int? stratumDifficulty;
  int? bestShare;
  int? poolRejected;
  int? poolStale;
  int? badWork;
  int? currentBlockHeight;
  int? currentBlockVersion;

  POOLS(
      {this.pOOL,
        this.uRL,
        this.status,
        this.priority,
        this.quota,
        this.longPoll,
        this.getworks,
        this.accepted,
        this.rejected,
        this.works,
        this.discarded,
        this.stale,
        this.getFailures,
        this.remoteFailures,
        this.user,
        this.lastShareTime,
        this.diff1Shares,
        this.proxyType,
        this.proxy,
        this.difficultyAccepted,
        this.difficultyRejected,
        this.difficultyStale,
        this.lastShareDifficulty,
        this.workDifficulty,
        this.hasStratum,
        this.stratumActive,
        this.stratumURL,
        this.stratumDifficulty,
        this.bestShare,
        this.poolRejected,
        this.poolStale,
        this.badWork,
        this.currentBlockHeight,
        this.currentBlockVersion});

  POOLS.fromJson(Map<String, dynamic> json) {
    pOOL = json['POOL'];
    uRL = json['URL'];
    status = json['Status'];
    priority = json['Priority'];
    quota = json['Quota'];
    longPoll = json['Long Poll'];
    getworks = json['Getworks'];
    accepted = json['Accepted'];
    rejected = json['Rejected'];
    works = json['Works'];
    discarded = json['Discarded'];
    stale = json['Stale'];
    getFailures = json['Get Failures'];
    remoteFailures = json['Remote Failures'];
    user = json['User'];
    lastShareTime = json['Last Share Time'];
    diff1Shares = json['Diff1 Shares'];
    proxyType = json['Proxy Type'];
    proxy = json['Proxy'];
    difficultyAccepted = json['Difficulty Accepted'];
    difficultyRejected = json['Difficulty Rejected'];
    difficultyStale = json['Difficulty Stale'];
    lastShareDifficulty = json['Last Share Difficulty'];
    workDifficulty = json['Work Difficulty'];
    hasStratum = json['Has Stratum'];
    stratumActive = json['Stratum Active'];
    stratumURL = json['Stratum URL'];
    stratumDifficulty = json['Stratum Difficulty'];
    bestShare = json['Best Share'];
    poolRejected = json['Pool Rejected%'];
    poolStale = json['Pool Stale%'];
    badWork = json['Bad Work'];
    currentBlockHeight = json['Current Block Height'];
    currentBlockVersion = json['Current Block Version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['POOL'] = this.pOOL;
    data['URL'] = this.uRL;
    data['Status'] = this.status;
    data['Priority'] = this.priority;
    data['Quota'] = this.quota;
    data['Long Poll'] = this.longPoll;
    data['Getworks'] = this.getworks;
    data['Accepted'] = this.accepted;
    data['Rejected'] = this.rejected;
    data['Works'] = this.works;
    data['Discarded'] = this.discarded;
    data['Stale'] = this.stale;
    data['Get Failures'] = this.getFailures;
    data['Remote Failures'] = this.remoteFailures;
    data['User'] = this.user;
    data['Last Share Time'] = this.lastShareTime;
    data['Diff1 Shares'] = this.diff1Shares;
    data['Proxy Type'] = this.proxyType;
    data['Proxy'] = this.proxy;
    data['Difficulty Accepted'] = this.difficultyAccepted;
    data['Difficulty Rejected'] = this.difficultyRejected;
    data['Difficulty Stale'] = this.difficultyStale;
    data['Last Share Difficulty'] = this.lastShareDifficulty;
    data['Work Difficulty'] = this.workDifficulty;
    data['Has Stratum'] = this.hasStratum;
    data['Stratum Active'] = this.stratumActive;
    data['Stratum URL'] = this.stratumURL;
    data['Stratum Difficulty'] = this.stratumDifficulty;
    data['Best Share'] = this.bestShare;
    data['Pool Rejected%'] = this.poolRejected;
    data['Pool Stale%'] = this.poolStale;
    data['Bad Work'] = this.badWork;
    data['Current Block Height'] = this.currentBlockHeight;
    data['Current Block Version'] = this.currentBlockVersion;
    return data;
  }
}

