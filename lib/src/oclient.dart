part of softhai.orientdb_dart;


class OClient {

  final OConnection _connection;
  
  OConnection get Connection => this._connection;
  
  OClient._internal(this._connection) {
    if(this._connection == null) {
      throw new Exception("Can't create an Client without an instance of an connection");
    }
  }
  
  OClient.Http(String server, int port, String database, String username, String password) 
    : this._internal(new ORestConnection(server, port, database, username, password));
  
  OClient._Binary() : this._internal(null);
  
  Future<bool> Connect() {
    return this._connection.Connect();
  }
  
  Future Disconnect() {
    return this._connection.Disconnect();
  }
  
  Future<String> CommandRaw(OCommandScriptType language, String command, {int maxResults: 20, String fetchPlan: "*:1"}) {
    return this._connection.ExecuteCommand(language, command, limit: maxResults, fetchPlan: fetchPlan);
  }
  
  Future<Map> CommandMap(OCommandScriptType language, String command, {int maxResults: 20, String fetchPlan: "*:1"}) {
    return this._connection
      .ExecuteCommand(language, command, limit: maxResults, fetchPlan: fetchPlan)
      .then(this._ParseJSON);
  }
  
  Future<Stream<OObject>> CommandStream(OCommandScriptType language, String command, OBaseObjectParser parser, {int maxResults: 20, String fetchPlan: "*:1"}) {
    return this._connection
      .ExecuteCommand(language, command, limit: maxResults, fetchPlan: fetchPlan)
      .then(parser._Parser);
  }
  
  Future<dynamic> CommandScalar(OCommandScriptType language, String command, String scalarPropertyName, {int maxResults: 20, String fetchPlan: "*:1"}) {
    return this._connection
      .ExecuteCommand(language, command, limit: maxResults, fetchPlan: fetchPlan)
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
