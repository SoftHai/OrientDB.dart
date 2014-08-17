part of softhai.orientdb_dart;


class OClient {

  final OConnection _connection;
  
  OConnection get Connection => this._connection;
  
  OClient._internal(this._connection);
  
  OClient.Http(String server, int port, String database, String username, String password) 
    : this._internal(new ORestConnection(server, port, database, username, password));
  
  OClient._Binary() : this._internal(null);
  
  Future<bool> Connect() {
    return this._connection.Connect();
  }
  
  Future<String> CommandRaw(OCommandScriptType language, String command, {maxResults: 20}) {
    return this._connection.ExecuteCommand(language, command, limit: maxResults);
  }
  
  Future<Map> CommandMap(OCommandScriptType language, String command, {maxResults: 20}) {
    return this._connection
      .ExecuteCommand(language, command, limit: maxResults)
      .then(this._ParseJSON);
  }
  
  Future<Stream<OObject>> CommandStream(OCommandScriptType language, String command, OObjectParser parser, {maxResults: 20}) {
    return this._connection
      .ExecuteCommand(language, command, limit: maxResults)
      .then(parser._Parser);
  }
  
  Future<dynamic> CommandScalar(OCommandScriptType language, String command, String scalarPropertyName, {maxResults: 20}) {
    return this._connection
      .ExecuteCommand(language, command, limit: maxResults)
      .then(_ParseJSON)
      .then((map) => map["result"][0][scalarPropertyName]);
  }
  
  Future<String> BatchRaw(bool transaction, Iterable<OBatchOperation> operations) {
    return this._connection.ExecuteBatch(transaction, operations);
  }
  
  dynamic _ParseJSON(String json) {
    return JSON.decoder.convert(json);
  }
}
