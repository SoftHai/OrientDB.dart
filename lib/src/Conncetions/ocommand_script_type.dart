part of softhai.orientdb_dart;

class OCommandScriptType {
  final String _value;
  
  String get Value => this._value;
  
  const OCommandScriptType._internal(this._value);
  
  toString() => 'ScriptType.$_value';

  static const SQL = const OCommandScriptType._internal('sql');
  static const Gremlin = const OCommandScriptType._internal('gremlin');
}