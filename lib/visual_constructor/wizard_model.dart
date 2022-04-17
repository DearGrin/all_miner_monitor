class WizardModel{
  String? tag;
  bool? fromTop;
  bool? fromLeft;
  List<WizardRig>? rigs;
  WizardModel({this.tag, this.rigs, this.fromTop=true, this.fromLeft=true,});
}
class WizardRig{
  int? id;
  String? ip;
  int? shelfCount;
  int? placePerShelf;
  int? gap;
  WizardRig({this.id, this.ip, this.shelfCount, this.placePerShelf, this.gap=0});
}