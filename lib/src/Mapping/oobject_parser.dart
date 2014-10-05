part of softhai.orientdb_dart;

abstract class OBaseObjectParser {
  
  Stream<OObject> _Parser(String json);
  
}

class OObjectParser<T extends OObject> implements OBaseObjectParser {
  
  Stream<OObject> _Parser(String json) {
    var jsonMap = JSON.decoder.convert(json);
    
    var stream = new Stream.fromIterable(jsonMap["result"]);
    return stream.map((jsonItem) {
      var obj = reflectClass(T).newInstance(new Symbol("FormMap"), [ jsonItem ]);
      return obj.reflectee;
    });
  }
  
}