A Odoo JSON-RPC Connector library for Flutter.

This package contains set of method to call Odoo API with JSON-RPC. You can call any odoo methods, controllers some of the information as below.

Version Information
Session information
Authenticate user
Database listing
Create/Update/Unlink records
Read records with fields for given ids of model
Search and read based on domain filters.
CallKW method for calling any model level methods with arguments.
Calling json controller with params.

```dart
  final client = OdooClient('http://yourdomain.com');
  client.connect().then((version) {
    debugPrint("Connected $version");
  });
```
