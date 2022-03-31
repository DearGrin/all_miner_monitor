import 'package:hive/hive.dart';
part 'ip_range_model.g.dart';

@HiveType(typeId: 0)
class IpRangeModel extends HiveObject{
  @HiveField(0)
  String? rawIpRange;
  @HiveField(1)
  String? startIp;
  @HiveField(2)
  String? endIp;
  @HiveField(3)
  String? comment;
  IpRangeModel({this.rawIpRange, this.startIp, this.endIp, this.comment});

  factory IpRangeModel.fromString(String ip, String? _comment){
    String _startIp = ip.split('-')[0];
    List<String> byOktet = _startIp.split('.');
    String _endIp = '';
    if(ip.split('-')[1].contains('.'))
      {
        print(ip.split('-')[1]);
        _endIp = byOktet[0] + '.' + byOktet[1] + '.' + ip.split('-')[1];
        print(_endIp);
      }
    else{
      _endIp = byOktet[0]+'.'+byOktet[1]+'.'+byOktet[2]+'.'+ip.split('-')[1];
    }
    return IpRangeModel(
      rawIpRange: ip,
      startIp: _startIp,
      endIp: _endIp,
      comment: _comment,
    );
  }
}