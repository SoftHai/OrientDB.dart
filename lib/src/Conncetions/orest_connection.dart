part of softhai.orientdb_dart;


class ORestConnection implements OConnection {

  http.Client _client;
  
  String _serverAdress;
  String _authString;
  String _database;
  
  bool get IsConnected => this._client != null;
  
  ORestConnection(String server, int port, String database, String username, String password) {
    this._serverAdress = "http://${server}:${port}";
    this._database = database;
    this._authString = CryptoUtils.bytesToBase64(UTF8.encode("$username:$password"));
  }
  
  Future<bool> Connect() {
    
    if(this._client == null) {
      this._client = new http.Client();
      
      return this._client
        .get("${this._serverAdress}/connect/${this._database}", headers: this._BuildRequestHeader())
        .then(this._HandleConnectResponse)
        .catchError(this._HandleConnectError);
    }
    else {
      return new Future.value(true);
    }
  }
  
  Future<String> ExecuteCommand(OCommandScriptType language, String command, {int limit: 20}) {
    if(this._client != null) {
      
      return this._client
        .post("${this._serverAdress}/command/${this._database}/${language.Value}/${HTML_ESCAPE.convert(command)}/$limit", headers: this._BuildRequestHeader())
        .then(this._HandleExecuteCommandResponse);
    }
    
    throw new ConnectionException("No open connection");
  }
  
  Future<String> ExecuteBatch(bool transaction, Iterable<OBatchOperation> operations) {
    if(this._client != null) {
      Map bodyContent = { "transaction": transaction, operations: []};
      for(var operation in operations) {
        bodyContent["operations"].Add(operation.toMap());
      }
      
      var content = JSON.encoder.convert(bodyContent);
      
      return this._client
        .post("${this._serverAdress}/batch/${this._database}", body: content , headers: this._BuildRequestHeader())
        .then(this._HandleExecuteBatchResponse);
    }
    
    throw new ConnectionException("No open connection");
  }
  
  Future<String> GetDatabaseSchema() {
    if(this._client != null) {
      return this._client
        .get("${this._serverAdress}/database/${this._database}", headers: this._BuildRequestHeader())
        .then(this._HandleGetDatabaseSchemaResponse);
    }
    
    throw new ConnectionException("No open connection");
  }
  
  Future Disconnect() {
    if(this._client != null) {
      return this._client
        .get("${this._serverAdress}/disconnect")
        .then(this._HandleDiconnectResponse);
    }
    
    return new Future.value();
  }
  
  Map<String, String> _BuildRequestHeader() {
     var headers = new Map<String, String>();
     headers['content-type'] = "application/json";
     headers['www-authenticate'] = 'Basic realm="OrientDB db-${this._database}"';
     headers['authorization'] = "Basic ${this._authString}";
     
     return headers;
  }
  
  void _CloseConnection() {
    this._client.close();
    this._client = null;
  }
  
  bool _HandleConnectResponse(http.Response response) {
    if(response.statusCode == 204) {
      // Successful
      return true;
    }
    else if (response.statusCode == 401) {
      // Denied
      this._CloseConnection();
      return false;
    }
    else {
      // Other error happens
      this._CloseConnection();
      return false;
    }
  }
  
  bool _HandleConnectError(http.Response response) {
    this._CloseConnection();
    return false;
  }

  String _HandleExecuteCommandResponse(http.Response response) {
    if(response.statusCode == 200) {
      return response.body;
    }
    else {
      throw new ExecutionException("Error during executing: ${response.reasonPhrase} - ${response.body}", response.statusCode);
    }
  }

  String _HandleExecuteBatchResponse(http.Response response) {
    if(response.statusCode == 200) {
      return response.body;
    }
    else {
      throw new ExecutionException("Error during executing: ${response.reasonPhrase} - ${response.body}", response.statusCode);
    }
  }
  
  String _HandleGetDatabaseSchemaResponse(http.Response response) {
    if(response.statusCode == 200) {
      return response.body;
    }
    else {
      throw new ExecutionException("Error during executing: ${response.reasonPhrase}", response.statusCode);
    }
  }
  
  void _HandleDiconnectResponse(http.Response response) {
    // Getting always 401 Unauthorized - googled it, it looks like a feature not a bug. Ignoring return state and closing all
    this._CloseConnection();
  }
}