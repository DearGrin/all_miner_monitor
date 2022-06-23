class EventModel{
  String type;
  dynamic data;
  String ip;
  String rawData;
  String? tag;
  int? isolateIndex;
  EventModel(this.type, this.data, this.ip, this.rawData, {this.tag, this.isolateIndex});
}