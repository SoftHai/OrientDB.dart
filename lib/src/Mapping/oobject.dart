part of softhai.orientdb_dart;

class OObject {
  
  Map _json;
  
  Map get JSONMap => this._json;
  
  String get Type => this._json["@type"];
  
  ORID get RID => this._json.containsKey("@rid") ? new ORID.Parse(this._json["@rid"]) : new ORID.Empty();
  
  int get Version => this._json.containsKey("@version") ? this._json["@version"] : -1;
  
  String get ClassName => this._json["@class"];
  
  String get FieldTypes => this._json.containsKey("@fieldTypes") ? this._json["@fieldTypes"] : "";
  
  OObject(String className) {
    this._json = { "@class": className, "@fieldTypes": "" };
  }
  
  OObject.FormJson(String json) {
    this._json = JSON.decoder.convert(json);
  }
 
  OObject.FormMap(this._json);
  
  Map toMap() {
    return this._json;
  }
}