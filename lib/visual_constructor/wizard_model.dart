class WizardModel{
  String? tag;
  List<WizardRig>? rigs;
  WizardModel({this.tag, this.rigs});
}
class WizardRig{
  int? id;
  String? ip;
  int? shelfCount;
  int? placePerShelf;
  bool? fromTop;
  bool? fromLeft;
  WizardRig({this.id, this.ip, this.shelfCount, this.placePerShelf, this.fromTop=true, this.fromLeft=true});
}