import 'package:hive/hive.dart';
part 'pool_model.g.dart';

@HiveType(typeId: 1)
class Pool extends HiveObject{
  @HiveField(0)
  String? addr;
  @HiveField(1)
  String? port;
  @HiveField(2)
  String? passwd;
  @HiveField(3)
  String? worker;
  Pool({this.addr, this.port,this.passwd='x', this.worker});

  factory Pool.fromString(String data){
    return Pool(

    );
  }
}