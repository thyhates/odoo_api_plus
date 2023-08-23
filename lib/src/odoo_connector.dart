import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';
import 'odoo_response.dart';
import 'odoo_version.dart';

abstract class OdooConnector {
  late Client client;
  final String serverURL;
  final headers = <String, String>{};
  bool debugRPC;
  late OdooVersion odooVersion;
  List databases = [];
  String? sessionId;

  OdooConnector({
    required this.serverURL,
    Client? client,
    this.debugRPC = false,
    OdooVersion? odooVersion,
  }) {
    if (client == null) {
      this.client = Client();
    } else {
      this.client = client;
    }

    if (odooVersion == null) {
      this.odooVersion = OdooVersion();
    } else {
      this.odooVersion = odooVersion;
    }
  }

  void setSessionId(String sessionId) {
    this.sessionId = sessionId;
  }

  // connect to odoo and set version and databases
  Future<OdooVersion> connect() async {
    odooVersion = await getVersionInfo();
    databases = await getDatabases();
    return odooVersion;
  }

  // get version of odoo
  Future<OdooVersion> getVersionInfo() async {
    var url = createPath("/web/webclient/version_info");
    final response = await callRequest(url, createPayload({}));
    odooVersion = OdooVersion.parse(response);
    return odooVersion;
  }

  Future<List> getDatabases() async {
    if (odooVersion.major == null) {
      odooVersion = await getVersionInfo();
    }
    String url = serverURL;
    var params = {};
    if (odooVersion.major == 9) {
      url = createPath("/jsonrpc");
      params["method"] = "list";
      params["service"] = "db";
      params["args"] = [];
    } else if (odooVersion.major >= 10) {
      url = createPath("/web/database/list");
      params["context"] = {};
    } else {
      url = createPath("/web/database/get_list");
      params["context"] = {};
    }
    final response = await callRequest(url, createPayload(params));
    databases = response.getResult();
    return databases;
  }

  void setDebugRPC(bool debug) {
    debugRPC = debug;
  }

  String createPath(String path) {
    return serverURL + path;
  }

  Map createPayload(Map params) {
    return {
      "jsonrpc": "2.0",
      "method": "call",
      "params": params,
      "id": const Uuid().v1()
    };
  }

  Future<OdooResponse> callRequest(String url, Map payload) async {
    var body = json.encode(payload);
    headers["Content-type"] = "application/json";
    if (sessionId != null) {
      headers['Cookie'] = "session_id=$sessionId";
    }
    if (debugRPC) {
      debugPrint("-------------------------------------------");
      debugPrint("REQUEST: $url");
      debugPrint("PAYLOD : $payload");
      debugPrint("HEADERS: $headers");
      debugPrint("-------------------------------------------");
    }
    final response =
        await client.post(Uri.parse(url), body: body, headers: headers);
    final cookiesSessionId = _updateCookies(response);
    if (debugRPC) {
      debugPrint("============================================");
      debugPrint("STATUS_C: ${response.statusCode}");
      debugPrint("RESPONSE: ${response.body}");
      debugPrint("============================================");
    }
    return OdooResponse(
      result: json.decode(response.body),
      statusCode: response.statusCode,
      sessionId: cookiesSessionId,
    );
  }

  _updateCookies(Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      String cookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      headers['Cookie'] = cookie;
      if (index > -1) {
        return cookie.split("=")[1];
      }
    }
    return null;
  }
}
