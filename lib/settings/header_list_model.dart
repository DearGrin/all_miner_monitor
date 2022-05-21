import 'package:AllMinerMonitor/scan_list/table_header_model.dart';
import 'package:hive/hive.dart';

part 'header_list_model.g.dart';
@HiveType(typeId: 3)
class HeadersListModel extends HiveObject{
  @HiveField(0)
  List<TableHeaderModel>? headers;
  HeadersListModel({this.headers});
}