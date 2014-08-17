part of softhai.orientdb_dart;

class ORID {
  
  int _cluster = -1;
  int _id = -1;
  
  int get Cluster => this._cluster;
  int get ID => this._id;
  
  ORID(int cluster, int id) {
    this._cluster = cluster;
    this._id = id;
  }
  
  ORID.Parse(String orid) {
    if(orid != "") {
      orid = orid.replaceFirst("#", ""); // Replace starting #
      var splittedID = orid.split(":");
      
      if(splittedID.length == 2) {
        this._cluster = int.parse(splittedID[0]);
        this._id = int.parse(splittedID[1]);
      }
    }
  }
  
  ORID.Empty();
  
  static bool IsEmpty(ORID rid) {
    return rid._cluster < 0 && rid._cluster < 0;
  }
  
  @override
  String toString() {
    return "#${this._cluster}:${this._id}";
  }
  
}