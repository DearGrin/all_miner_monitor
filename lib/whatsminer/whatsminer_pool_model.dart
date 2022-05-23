class WhatsminerPoollModel {
  List<STATUS>? status;
  List<POOLS>? pools;

  WhatsminerPoollModel({this.status, this.pools});

  WhatsminerPoollModel.fromJson(Map<String, dynamic> json) {
    if (json['STATUS'] != null) {
      status = <STATUS>[];
      json['STATUS'].forEach((v) {
        status!.add(STATUS.fromJson(v));
      });
    }
    if (json['POOLS'] != null) {
      pools = <POOLS>[];
      json['POOLS'].forEach((v) {
        pools!.add(POOLS.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (status != null) {
      data['STATUS'] = status!.map((v) => v.toJson()).toList();
    }
    if (pools != null) {
      data['POOLS'] = pools!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['POOL'] = pOOL;
    data['URL'] = uRL;
    data['Status'] = status;
    data['Priority'] = priority;
    data['Quota'] = quota;
    data['Long Poll'] = longPoll;
    data['Getworks'] = getworks;
    data['Accepted'] = accepted;
    data['Rejected'] = rejected;
    data['Works'] = works;
    data['Discarded'] = discarded;
    data['Stale'] = stale;
    data['Get Failures'] = getFailures;
    data['Remote Failures'] = remoteFailures;
    data['User'] = user;
    data['Last Share Time'] = lastShareTime;
    data['Diff1 Shares'] = diff1Shares;
    data['Proxy Type'] = proxyType;
    data['Proxy'] = proxy;
    data['Difficulty Accepted'] = difficultyAccepted;
    data['Difficulty Rejected'] = difficultyRejected;
    data['Difficulty Stale'] = difficultyStale;
    data['Last Share Difficulty'] = lastShareDifficulty;
    data['Work Difficulty'] = workDifficulty;
    data['Has Stratum'] = hasStratum;
    data['Stratum Active'] = stratumActive;
    data['Stratum URL'] = stratumURL;
    data['Stratum Difficulty'] = stratumDifficulty;
    data['Best Share'] = bestShare;
    data['Pool Rejected%'] = poolRejected;
    data['Pool Stale%'] = poolStale;
    data['Bad Work'] = badWork;
    data['Current Block Height'] = currentBlockHeight;
    data['Current Block Version'] = currentBlockVersion;
    return data;
  }
}

