part of softhai.orientdb_dart;

class ExecutionException implements Exception {
  
  int StatusCode;
  String Message;
  
  ExecutionException(this.Message, this.StatusCode);
  
  String toString() {
    return this.Message;
  }
  
}