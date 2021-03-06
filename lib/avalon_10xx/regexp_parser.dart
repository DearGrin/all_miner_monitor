class RegExpHelper{
  final RegExp version = RegExp(r'(Ver\[)(.*?)(\])');
  final RegExp elapsed = RegExp(r'(Elapsed\[)(.*?)(\])');
  final RegExp dna = RegExp(r'(DNA\[)(.*?)(\])');
  final RegExp status = RegExp(r'(WORKMODE\[)(.*?)(\])');
  final RegExp workMode = RegExp(r'(SYSTEMSTATU\[Work:)(.*?)(,)');
  final RegExp netFail = RegExp(r'(NETFAIL\[)(.*?)(\])');
  final RegExp tempEnter = RegExp(r'(Temp\[)(.*?)(\])');
  final RegExp fans = RegExp(r'(Fan[0-9,R]\[)(.*?)(\])');
  final RegExp freq = RegExp(r'(Freq\[)(.*?)(\])');
  final RegExp currentSpeed = RegExp(r'(GHSmm\[)(.*?)(\])');
  final RegExp averageSpeed = RegExp(r'(GHSavg\[)(.*?)(\])');
  final RegExp powerCommunication = RegExp(r'(POW_I2C_CONN\[)(.*?)(\])');
  final RegExp ps = RegExp(r'(PS\[)(.*?)(\])');
  final RegExp tMax = RegExp(r'(TMax\[)(.*?)(\])');
  final RegExp tAvg = RegExp(r'(TAvg\[)(.*?)(\])');
  final RegExp tMaxByBoard = RegExp(r'(MTmax\[)(.*?)(\])');
  final RegExp ecmm = RegExp(r'(ECMM\[)(.*?)(\])');
  final RegExp echu = RegExp(r'(ECHU\[)(.*?)(\])');
  final RegExp hw = RegExp(r'(HW\[)(.*?)(\])');
  final RegExp dh = RegExp(r'(DH\[)(.*?)(\])');
  final RegExp hashBoardCount = RegExp(r'(SYSTEMSTATU\[Work:.*, Hash Board:)(.*?)(\])');
  final RegExp pvtT = RegExp(r'(PVT_T[0-9]\[)(.*?)(\])');
  final RegExp pvtV = RegExp(r'(PVT_V[0-9]\[)(.*?)(\])');
  final RegExp mw = RegExp(r'(MW[0-9]\[)(.*?)(\])');
}
final RegExp version = RegExp(r'(Ver\[)(.*?)(\])');
final RegExp elapsed = RegExp(r'(Elapsed\[)(.*?)(\])');
final RegExp dna = RegExp(r'(DNA\[)(.*?)(\])');
final RegExp status = RegExp(r'(WORKMODE\[)(.*?)(\])');
final RegExp workMode = RegExp(r'(SYSTEMSTATU\[Work:)(.*?)(,)');
final RegExp netFail = RegExp(r'(NETFAIL\[)(.*?)(\])');
final RegExp tempInput = RegExp(r'(Temp\[)(.*?)(\])');
final RegExp fans = RegExp(r'((Fan[0-9]\[)|(Fan\[))(.*?)(\])');
final RegExp fanR = RegExp(r'(FanR\[)(.*?)(%)');
final RegExp freq = RegExp(r'(Freq\[)(.*?)(\])');
final RegExp currentSpeed = RegExp(r'(GHSmm\[)(.*?)(\])');
final RegExp averageSpeed = RegExp(r'(GHSavg\[)(.*?)(\])');
final RegExp powerCommunication = RegExp(r'(POW_I2C_CONN\[)(.*?)(\])');
final RegExp ps = RegExp(r'(PS\[)(.*?)(\])');
final RegExp tMax = RegExp(r'(TMax\[)(.*?)(\])');
final RegExp tAvg = RegExp(r'(TAvg\[)(.*?)(\])');
final RegExp tAverage = RegExp(r'(TAverage\[)(.*?)(\])');
final RegExp tMaxByBoard = RegExp(r'(MTmax\[)(.*?)(\])');
final RegExp ecmm = RegExp(r'(ECMM\[)(.*?)(\])');
final RegExp echu = RegExp(r'(ECHU\[)(.*?)(\])');
final RegExp hw = RegExp(r'(HW\[)(.*?)(\])');
final RegExp dh = RegExp(r'(DH\[)(.*?)(%)');
final RegExp hashBoardCount = RegExp(r'(SYSTEMSTATU\[Work:.*, Hash Board:)(.*?)(\])');
final RegExp pvtT = RegExp(r'(PVT_T[0-9]\[)(.*?)(\])');
final RegExp pvtV = RegExp(r'(PVT_V[0-9]\[)(.*?)(\])');
final RegExp mw = RegExp(r'(MW[0-9]\[)(.*?)(\])');
final RegExp company = RegExp(r'(ID=)(.*?)(,)');
final RegExp aging = RegExp(r'(AG\[)(.*?)(\])');
final RegExp aucs = RegExp(r'(STATS\=[0-4])([.|\n|\W|\w]*?)(MM Count)', multiLine: true);
final RegExp singleData = RegExp(r'(ID[0-9]\=)([.|\n|\W|\w]*?)(CRC\[)');
final RegExp led = RegExp(r'(Led\[)(.*?)(\])');
final RegExp pool = RegExp(r'(POOL=[0-9],)(URL=)(.*?)(User=)(.*?)');

