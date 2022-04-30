class WhatsminerErrorModel {
  String? status;
  int? when;
  int? code;
  Msg? msg;
  String? description;

  WhatsminerErrorModel(
      {this.status, this.when, this.code, this.msg, this.description});

  WhatsminerErrorModel.fromJson(Map<String, dynamic> json) {
    status = json['STATUS'];
    when = json['When'];
    code = json['Code'];
    msg = json['Msg'] != null ? new Msg.fromJson(json['Msg']) : null;
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['STATUS'] = this.status;
    data['When'] = this.when;
    data['Code'] = this.code;
    if (this.msg != null) {
      data['Msg'] = this.msg!.toJson();
    }
    data['Description'] = this.description;
    return data;
  }
}

class Msg {
  List<ErrorCode>? errorCode;

  Msg({this.errorCode});

  Msg.fromJson(Map<String, dynamic> json) {
    if (json['error_code'] != null) {
      errorCode = <ErrorCode>[];
      json['error_code'].forEach((v) {
        errorCode!.add(new ErrorCode.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.errorCode != null) {
      data['error_code'] = this.errorCode!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ErrorCode {
  String? error;
  String? value;
  ErrorCode({this.error, this.value});

  ErrorCode.fromJson(Map<String, dynamic> json) {
    error = json.keys.first;
    value = json.values.first;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['329'] = this.error;
    return data;
  }
}

