part of softhai.orientdb_dart;

abstract class OBatchOperation {
  
  String Type;
  
  OBatchOperation(this.Type);
  
  Map toMap() {
    Map map = { "type": this.Type };
    
    return map;
  }
}

class OBatchUpdate extends OBatchOperation {
  
  OObject Record;
  
  OBatchUpdate(this.Record) : super("u");
  
  @override
  Map toMap() {
    var map = super.toMap();
    map["record"] = this.Record.toMap();
  }
}

class OBatchCreate extends OBatchOperation {
  
  OObject Record;
  
  OBatchCreate(this.Record) : super("c");
  
  @override
  Map toMap() {
    var map = super.toMap();
    map["record"] = this.Record.toMap();
  }
}

class OBatchDelete extends OBatchOperation {
  
  ORID RecordID;
  
  OBatchDelete(this.RecordID) : super("d");
  
  @override
  Map toMap() {
    var map = super.toMap();
    map["record"] = { "@rid": this.RecordID.toString() };
  }
}

class OBatchCommand extends OBatchOperation {
  
  OBatchScriptType Language;
  
  String Command;
  
  OBatchCommand(this.Language, this.Command) : super("cmd");
  
  @override
  Map toMap() {
    var map = super.toMap();
    map["language"] = this.Language.Value;
    map["command"] = this.Command;
  }
}

class OBatchScript extends OBatchOperation {
  
  OBatchScriptType Language;
  
  String Script;
  
  OBatchScript(this.Language, this.Script) : super("script");
  
  @override
  Map toMap() {
    var map = super.toMap();
    map["language"] = this.Language.Value;
    map["script"] = this.Script;
  }
}