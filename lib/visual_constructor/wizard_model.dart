class WizardModel{
  String? tag;
  bool? fromTop;
  bool? fromLeft;
  List<WizardRig>? rigs;
  WizardModel({this.tag, this.rigs, this.fromTop=true, this.fromLeft=true});
}
class WizardRig{
  int? id;
  String? ip;
  int? shelfCount;
  int? placePerShelf;
  WizardRig({this.id, this.ip, this.shelfCount, this.placePerShelf});
}