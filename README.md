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
  var connection = new ORestConnection();
  var result = connection.Connect("localhost", 2480, "database", "username", "password")
  .then((successful) {
    if(successful) {
      return connection.ExecuteCommand("sql", "select * from v", limit: 1).then((content) {
        // Do something with the result
        var jsonObj = JSON.decoder.convert(content);
        // close the connection
        return connection.Disconnect();
      });
    }
    else {
      // Connection was not successful
    }
  });
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