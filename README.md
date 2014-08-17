OrientDB.dart
=========

[![Build Status](https://drone.io/github.com/SoftHai/OrientDB.dart/status.png)](https://drone.io/github.com/SoftHai/OrientDB.dart/latest)

This is an Client to connect to an [OrientDB](http://www.orientechnologies.com/orientdb/) Database.

[OrientDB.dart on Dart Package Manager](http://pub.dartlang.org/packages/orientdb_dart)

Install
=========

You can get OrientDB.dart from the Dart Pub Manager.<br/>
**Get the Package**
* Add the dependancy 'orientdb_dart' to your pubspec.yaml
 * Via the DartEditor dialog
 * By adding the following to the file:
   ```
   dependencies:
       orientdb_dart: any
   ```
* Update your depandancies by running `pub install`

**Use the Package**
```dart
import 'package:orientdb_dart/orientdb_dart.dart';
```

Example
=========
This is a very early version, currently you can work with it as followed
```dart
// Creating an custom object stored in the database
class Custom extends OObject {

  String get Name => super.JSONMap["Name"];
  void set Name(String value) { super.JSONMap["Name"] = value; }

  Custom(String className) : super(className);

  Custom.FormJson(String json) : super.FormJson(json);

  Custom.FormMap(Map json) : super.FormMap(json);
}

main() {
  // Creating an http client
  var oClient = new OClient.Http("localhost", 2480, "TestGraph", "root", "root");

  // Connecting to the database
  var result = oClient.Connect();
  result.then((successful) {
    if(successful) {
      // Connecting successful
      return oClient.CommandScalar(ScriptType.SQL, "select from custom", new OCustomParser<CustomObject>(), maxResults: 20)
        .then((result) {

          // Iterate throw all returned object
          result.toList().then((list) => list.forEach((obj) {
            print(obj.Name);
          }));

          return oClient.Connection.Disconnect();
      }).catchError((ex) {
        // Handling execution error e.g. syntax error in SQL
        print(ex);
      });
    }
    else {

    }
  });
}
```

Documentation
=========


Changelog
=========


Roadmap
=========
0.1-Beta (unreleased)
 * Basic Rest HTTP protocol implementation

0.2-Beta
 * Full Rest HTTP protocol implementation
 * Parsing results (Json) to objects (OR-Mapping)
  * Mapping by name / reflections
  * Mapping by attributes
  * ?

0.3-Beta
 * Creating/updating the database schema from registered objects

0.4-Beta
 * Creating an high level query language (something like LINQ in C#)

Later
 * Implementing the Binary Protocol