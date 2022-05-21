import 'package:AllMinerMonitor/avalon_10xx/avalon_error_codes.dart';

class ErrorHandler{
  final List<AvalonError> errorCodes = ErrorCodes().errorCodes;
  final List<AvalonError> psCodes = ErrorCodes().psErrorCodes;
  List<AvalonError>? getErrors(int? code){
    List<AvalonError> _tmp = [];
    int _tmpCode = code ?? 0; // TODO get exception on null and not no errors
   for(int i = 0; i <errorCodes.length; i++)
     {
       if(_tmpCode-errorCodes[i].id > 0)
         {
           _tmp.add(errorCodes[i]);
           _tmpCode -= errorCodes[i].id;
         }
       else if (_tmpCode - errorCodes[i].id == 0)
         {
           _tmp.add(errorCodes[i]);
           break;
         }
     }
   return _tmp;
  }
  List<AvalonError>? getPSErrors(int? code){
    List<AvalonError> _tmp = [];
    int _tmpCode = code ?? 0;
    for(int i = 0; i <psCodes.length; i++)
    {
      if(_tmpCode-psCodes[i].id > 0)
      {
        _tmp.add(psCodes[i]);
        _tmpCode -= psCodes[i].id;
      }
      else if (_tmpCode - psCodes[i].id == 0)
      {
        _tmp.add(psCodes[i]);
        break;
      }
    }
    return _tmp;
  }
}