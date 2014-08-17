part of softhai.orientdb_dart;

abstract class OConnection {

  bool get IsConnected;
  
  Future Connect();
  
  Future<String> ExecuteCommand(OCommandScriptType language, String command, {int limit: 20});
  
  Future<String> ExecuteBatch(bool transaction, Iterable<OBatchOperation> operations);
  
  Future<String> GetDatabaseSchema();
  
  Future Disconnect();
}