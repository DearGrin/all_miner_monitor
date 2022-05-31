class SummaryModel{
  int countSCRYPT;
  int countSHA256;
  double totalHashSHA256;
  double totalHashSCRYPT;
  double averageHashSCRYPT;
  double averageHashSHA256;
  int totalProgress;
  int withErrors;
  int maxTemp;
  List<String> speedErrors = [];
  List<String> fanErrors = [];
  List<String> tempErrors = [];
  List<String> hashCountErrors = [];
  List<String> chipCountErrors = [];
  List<String> chipsSErrors = [];
  SummaryModel({this.countSCRYPT = 0, this.countSHA256 = 0, this.totalHashSHA256 = 0,
    this.totalHashSCRYPT = 0, this.averageHashSCRYPT = 0, this.averageHashSHA256 =0,
    this.withErrors = 0, this.maxTemp = 0, required this.hashCountErrors, required this.chipCountErrors,
    required this.speedErrors, required this.fanErrors, required this.tempErrors, required this.chipsSErrors,
    this.totalProgress = 0});
  clear(){
    countSCRYPT = 0;
    countSHA256 = 0;
    totalHashSHA256 = 0;
    totalHashSCRYPT = 0;
    averageHashSCRYPT = 0;
    averageHashSHA256 = 0;
    withErrors = 0;
    maxTemp = 0;
    speedErrors = [];
    fanErrors = [];
    tempErrors = [];
    hashCountErrors = [];
    chipsSErrors = [];
    chipCountErrors = [];
    totalProgress = 0;
  }
}