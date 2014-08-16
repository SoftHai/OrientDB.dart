part of softhai.orientdb_dart;

class ConnectionException implements Exception {
  
  String Message;
  
  ConnectionException(this.Message);
  
  String toString() {
    return this.Message;
  }
  
}