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
class Person extends OObject {

  String get Name => super.JSONMap["Name"];
  void set Name(String value) { super.JSONMap["Name"] = value; }

  Person(String className) : super(className);

  Person.FormJson(String json) : super.FormJson(json);

  Person.FormMap(Map json) : super.FormMap(json);
}

main() {
  // Creating an http client
  var oClient = new OClient.Http("localhost", 2480, "TestGraph", "root", "root");

  // Connecting to the database
  var result = oClient.Connect();
  result.then((successful) {
    if(successful) {
      // Connecting successful
      return oClient.CommandStream(OCommandScriptType.SQL, "select * from Person",
      								new OCustomParser<Person>(), maxResults: 20)
        .then((result) {

          // Iterate throw all returned object
          result.toList().then((persons) => persons.forEach((person) {
            print(person.Name);
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
See [here](/CHANGELOG.md)

Roadmap
=========
0.1 (in progress)
 * Basic Rest HTTP protocol implementation
 * Basic Mapping Support (ODM)

0.2
 * Full Rest HTTP protocol implementation
 * SQL Injection protection

0.3
 * Parsing results (Json) to objects (OD-Mapping)
  * Mapping by name / reflections
  * Mapping by attributes
  * ?

0.4
 * Creating/updating the database schema from registered objects

0.5
 * Creating an high level query language (something like LINQ in C#)

Later
 * Implementing the Binary Protocol