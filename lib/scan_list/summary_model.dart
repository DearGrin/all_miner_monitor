class SummaryModel{
  int count;
  double totalHash;
  double averageHash;
  int withErrors;
  int maxTemp;
  SummaryModel({this.count = 0, this.totalHash = 0, this.averageHash = 0,
    this.withErrors = 0, this.maxTemp = 0});
  clear(){
    count = 0;
    totalHash = 0;
    averageHash = 0;
    withErrors = 0;
    maxTemp = 0;
  }
}