part of softhai.orientdb_dart;


class ORestConnection implements OConnection {

  http.Client _client;
  
  String _server;
  int _port;
  String _authString;
  String _database;
  
  bool get IsConnected => this._client != null;
  
  Future<bool> Connect(String server, int port, String database, String username, String password) {

    this._server = server;
    this._port = port;
    this._database = database;
    this._authString = CryptoUtils.bytesToBase64(UTF8.encode("$username:$password"));
    
    this._client = new http.Client();
    
    return this._client.get("http://${this._server}:${this._port}/connect/${this._database}", headers: this._BuildRequestHeader())
      .then((response) {
        if(response.statusCode == 204) {
          // Successful
          return true;
        }
        else if (response.statusCode == 401) {
          // Denied
          this._client.close();
          this._client = null;
          return false;
        }
    }).catchError((response) { 
      return false; 
      });
  }
  
  Future<String> ExecuteCommand(String language, String command, {int limit: 20}) {
    if(this._client != null) {
      return this._client.post("http://${this._server}:${this._port}/command/${this._database}/$language/${HTML_ESCAPE.convert(command)}/$limit", headers: this._BuildRequestHeader())
        .then((response) {
          if(response.statusCode == 200) {
            return response.body;
          }
          else {
            throw new ExecutionException("Error during executing: ${response.reasonPhrase}", response.statusCode);
          }
      });
    }
    
    throw new ConnectionException("No open connection");
  }
  
  Future<String> GetDatabaseSchema() {
    if(this._client != null) {
      return this._client.get("http://${this._server}:${this._port}/database/${this._database}", headers: this._BuildRequestHeader())
        .then((response) {
          if(response.statusCode == 200) {
            return response.body;
          }
          else {
            throw new ExecutionException("Error during executing: ${response.reasonPhrase}", response.statusCode);
          }
      });
    }
    
    throw new ConnectionException("No open connection");
  }
  
  Future Disconnect() {
    if(this._client != null) {
      return this._client.get("http://${this._server}:${this._port}/disconnect")
        .then((response) {
        // Getting always 401 Unauthorized - googled it, it looks like a feature not a bug. Ignoring return state and closing all
        this._client.close();
        this._client = null;
      });
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
}