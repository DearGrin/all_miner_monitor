import 'package:hive/hive.dart';
part 'table_header_model.g.dart';

@HiveType(typeId: 2)
class TableHeaderModel extends HiveObject{
  @HiveField(0)
  String? label;
  @HiveField(1)
  double? width;
  @HiveField(2)
  bool? isVisible;
  TableHeaderModel({this.label, this.width=150.0, this.isVisible=true});
}