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
  
  Future<String> ExecuteSQLCommand_Raw(String command, {maxResults: 20}) {
    return this._connection.ExecuteCommand("sql", command, limit: maxResults);
  }
  
  Future<Map> ExecuteSQLCommand_JsonObj(String command, {maxResults: 20}) {
    return this._connection
      .ExecuteCommand("sql", command, limit: maxResults)
      .then(this._ParseJSON);
  }
  
  dynamic _ParseJSON(String json) {
    return JSON.decoder.convert(json);
  }
}
