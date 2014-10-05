#OClient

The `OClient` is the main object of the lib.

You can create 2 types of the OClint:
* One with an Rest-Connection
* One with an Binary-Connection (**Not Implemented**)

## Creating an Instance

### Rest-Connection

To create an connection to an OrientDB instance via the REST-API you can use the following constructor:
```dart
var oClient = new OClient.Http(server, port, database, username, password)
```

* **server**: Set here the IP-Adress or the Server name where the OrientDB is hosted
* **port**: Set here the port over which the connection should be established (default: 2480)
* **database**: Set here the name of the database to which you want to connect
* **username**: Set here the username
* **password**: Set here the password of the user

### Binary-Connection

There is an empty-constructor for that but it is **not yet implemented**
```dart
var oClient = new OClient.Binary()
```

## Open an Connection

To open an connection, you have to call the function `Connect` of the OClient-Instance:
```dart
oClient.Connect().then((successful) { // your code here });
```
As result of the Connect-Function you will get an `Future<bool>` object to pogress the following actions.
The returned `bool` value gives you the information if the connection was successful (true) or not (false) established.

If the connecting was successful you can continue with sending request against the database.

## Close an Connection

After you made you requests an you don't need the database connection longer, you can close the connection by calling the `Disconnect` function:
```dart
oClient.Disconnect().then((_) { // your code here });
```

## Requesting data

The OClient gives you several ways to request data from an OrientDB:
* **Raw**: It returns the raw data received from the OrientDB (Json-String)
* **Map**: It returns a Map of the data received from the OrientDB (it simply use the `JSON.decode` from the dart framework)
* **Scalar**: It returns an Scalar value (e.g. a Count)
* **Stream**: It returns an Stream of Mapped-Objects

All functions, has at least the following parameter:
* **language**: Is an Enum of `OCommandScriptType`, where you choose the language of the command (SQL, Gremlin)
* **command**: Is the command-String in the previously defined language
* **maxResults** *(Optional)*: Is the maximum number of results (default 20)
* **fetchPlan** *(Optional)*: is the fetch plan you prefer (default *:1) [See here for details](http://www.orientechnologies.com/docs/last/orientdb.wiki/Fetching-Strategies.html)

### CommandRaw

You can use this function if you want to work with the JSON-String from the OrientDB:
```dart
Future<String> CommandRaw(language, command, {maxResults, fetchPlan})
```
As result you get the JSON-String.
You have to handle the `then` and the `catchError` case of the returning `Future` object

**Example:**
```dart
oClient.CommandRaw(OCommandScriptType.SQL, "select from v")
    .then((rawResult) {

      // Work with your result

      return oClient.Disconnect();
    }).catchError((ex) {
    // Handling execution error e.g. syntax error in SQL
    });
```

### CommandMap

You can use this function if you want to work with parsed JSON data (Map). It simply use the `JSON.decode` from the dart framework:
```dart
Future<Map> CommandMap(language, command, {maxResults, fetchPlan})
```
As result you get a Map with the parsed JSON-data.
You have to handle the `then` and the `catchError` case of the returning `Future` object

**Example:**
```dart
oClient.CommandMap(OCommandScriptType.SQL, "select from v")
    .then((mapResult) {

      // Work with your result

      return oClient.Disconnect();
    }).catchError((ex) {
    // Handling execution error e.g. syntax error in SQL
    });
```

### CommandScalar

You can use this function if your command only returns a scalar value (e.g. an count):
```dart
Future<dynamic> CommandScalar(language, command, scalarPropertyName, {maxResults, fetchPlan})
```
* **scalarPropertyName**: The name of the scalar value (you defined with an `as Name` in the SQL-Statement). <br>
 Defautlt Names:
 * **count()**: count

As result is a parsed type of the scalar property (e.g. int on an count)
You have to handle the `then` and the `catchError` case of the returning `Future` object

**Example:**
```dart
oClient.CommandMap(OCommandScriptType.SQL, "select count(*) as Count from v", "Count")
    .then((scalarResult) {

      // Work with your result

      return oClient.Disconnect();
    }).catchError((ex) {
    // Handling execution error e.g. syntax error in SQL
    });
```

### CommandStream

You can use this function if you want an stream of parsed objects:
```dart
Future<dynamic> CommandScalar(language, command, parser, {maxResults, fetchPlan})
```
* **parser**: Defines the parser, which is used to parse the JSON-String into an object

As result you get an stream of your parsed objects
You have to handle the `then` and the `catchError` case of the returning `Future` object

**Example:** <br>
First you will need an object, which represents the stored data:
```dart
class Person extends OObject {

  // Example on how to implement an property
  String get Name => super.JSONMap["Name"];
  void set Name(String value) { super.JSONMap["Name"] = value; }

  Person(String className) : super(className);

  Person.FormJson(String json) : super.FormJson(json);

  Person.FormMap(Map json) : super.FormMap(json);

}
```
Say you storing some people in you database.
* First you have to inherit from the Class `OObject`.
* All Custom properties have to be implemented as the exxample `Name` Property. As you can see, in has the data internally stored in an Map and reads / writes to this map.
* The `OObject` class defines the following properties:
 * **JSONMap**: Returns the internal Map of this object
 * **Type**: Returns the name of the internal type (OrientDB Default Property `@type`, d = document)
 * **RID**: Returns the parsed OrientDB ID as `ORID` object
 * **Version**: Returns the version of this object (OrientDB Default Property `@version`)
 * **ClassName**: Returns the name of the Class (OrientDB Default Property `@class`)
 * **FieldTypes**: Returns the content of the Field-Types property (OrientDB Default Property `@fieldTypes`)

Now you can use this class in your code:
```dart
oClient.CommandStream(OCommandScriptType.SQL, "select from v", new OObjectParser<Person>())
    .then((streamResult) {

      // Work with your result
	  streamResult.toList().then((list) => list.forEach((obj) {
        print(obj.Name);
      }));

      return oClient.Disconnect();
    }).catchError((ex) {
    // Handling execution error e.g. syntax error in SQL
    });
```
#### Custom Object Parsing

Instead of inherit from `OObject` and using the generic parser `OObjectParser` you can inplement an own parser by inheriting from the class `OBaseObjectParser`.
