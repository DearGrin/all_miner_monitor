import 'package:hive/hive.dart';
part 'constructor_model.g.dart';

@HiveType(typeId: 5)
class Layout{
@HiveField(0)
  String? tag;
@HiveField(1)
  List<Rig>? rigs;
@HiveField(2)
int? counter;
@HiveField(3)
List<String?>? ips;
  Layout({this.tag, this.rigs, this.counter, this.ips = const []});
}
@HiveType(typeId: 6)
class Rig{
  @HiveField(0)
  int id;
  @HiveField(1)
  List<Shelf>? shelves;
  Rig(this.id, {this.shelves = const []});
}
@HiveType(typeId: 7)
class Shelf{
  @HiveField(0)
  int id;
  @HiveField(1)
  List<Place>? places;
  Shelf(this.id, {this.places});
}
@HiveType(typeId: 8)
class Place{
  @HiveField(0)
  int id;
  @HiveField(1)
  String? ip;
  @HiveField(2)
  String type;
  @HiveField(3)
  int? aucN;
  Place(this.id, this.type, {this.ip, this.aucN});
}