import 'package:flutter/material.dart';
import 'package:odoo_api_plus/odoo_api_plus.dart';

main() {
  final client = OdooClient('http://yourdomain.com');
  client.connect().then((version) {
    debugPrint("Connected $version");
  });
}
