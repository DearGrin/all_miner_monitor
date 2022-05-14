import 'package:hive/hive.dart';
part 'record_model.g.dart';

@HiveType(typeId: 9)
class RecordModel{
  @HiveField(0)
  String? date;
  @HiveField(1)
  String? comment;
  @HiveField(2)
  List<String>? tags;
  RecordModel({this.date, this.comment, this.tags});
}