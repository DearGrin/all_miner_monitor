
Future<List<String>> getIpsFromRange( List<List<String?>> scanList)async{
  List<String> _tmp = [];
  for(var range in scanList){
    List<int>? _start = range[0]?.split('.').map((e) =>
         int.tryParse(e)!).toList();
    List<int>? _end = range[1]?.split('.').map((e) =>
    int.tryParse(e)!).toList();
    while (_start![3] <= _end![3]) {
      String _ip = _start[0].toString() + '.' + _start[1].toString() + '.' +
          _start[2].toString() + '.' + _start[3].toString();

      _tmp.add(_ip);
      if (_start[3] != _end[3]) {
        _start[3]++;
      }
      else {
        if (_start[2] < _end[2]) {
          _start[3] = 1;
          _start[2] ++;
        }
        else {
          _start[3]++;
        }
      }
    }
  }
  return _tmp;
}