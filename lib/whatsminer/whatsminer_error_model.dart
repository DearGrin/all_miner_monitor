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
    msg = json['Msg'] != null ? Msg.fromJson(json['Msg']) : null;
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['STATUS'] = status;
    data['When'] = when;
    data['Code'] = code;
    if (msg != null) {
      data['Msg'] = msg!.toJson();
    }
    data['Description'] = description;
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
        errorCode!.add(ErrorCode.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (errorCode != null) {
      data['error_code'] = errorCode!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['329'] = error;
    return data;
  }
}

