part of softhai.orientdb_dart;

class OBatchScriptType {
  final String _value;
  
  String get Value => this._value;
  
  const OBatchScriptType._internal(this._value);
  
  toString() => 'ScriptType.$_value';

  static const SQL = const OBatchScriptType._internal('sql');
  static const Gremlin = const OBatchScriptType._internal('gremlin');
  static const JavaScript = const OBatchScriptType._internal('javascript');
}