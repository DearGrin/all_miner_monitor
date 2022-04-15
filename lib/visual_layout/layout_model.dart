class LayoutModel{
  String? tag;
  int? rigCount;
  int? rowCount;
  List<PlaceLayout>? places;
  LayoutModel({this.tag, this.rigCount, this.rowCount, this.places});
}

class PlaceLayout{
  String? ip;
  int? rigIndex;
  int? rowIndex;
  int? placeIndex;
  int? aucIndex;
  PlaceLayout({this.ip, this.rigIndex, this.rowIndex, this.placeIndex, this.aucIndex});
}