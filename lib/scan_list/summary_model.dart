class SummaryModel{
  int countSCRYPT;
  int countSHA256;
  double totalHashSHA256;
  double totalHashSCRYPT;
  double averageHashSCRYPT;
  double averageHashSHA256;
  int withErrors;
  int maxTemp;
  SummaryModel({this.countSCRYPT = 0, this.countSHA256 = 0, this.totalHashSHA256 = 0,
    this.totalHashSCRYPT = 0, this.averageHashSCRYPT = 0, this.averageHashSHA256 =0,
    this.withErrors = 0, this.maxTemp = 0});
  clear(){
    countSCRYPT = 0;
    countSHA256 = 0;
    totalHashSHA256 = 0;
    totalHashSCRYPT = 0;
    averageHashSCRYPT = 0;
    averageHashSHA256 = 0;
    withErrors = 0;
    maxTemp = 0;
  }
}