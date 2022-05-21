import 'package:AllMinerMonitor/avalon_10xx/regexp_parser.dart' as regexp;
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

  get fullAdr => addr!=null? port!=null? addr!+':'+port! : addr! :'';

  factory Pool.fromString(String data){
    return Pool(
      addr: regexp.pool.firstMatch(data)?.group(3)??'',
      port: regexp.pool.firstMatch(data)?.group(3)?.split(':')[1]??'',
      worker: regexp.pool.firstMatch(data)?.group(5)??'',
    );
  }
}