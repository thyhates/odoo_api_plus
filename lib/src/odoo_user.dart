import 'odoo_response.dart';

class OdooUser {
  final dynamic name, sessionId, uid, database, username, companyId, partnerId;
  final dynamic lang, tz;

  OdooUser({
    this.name,
    this.sessionId,
    this.uid,
    this.database,
    this.username,
    this.companyId,
    this.partnerId,
    this.lang,
    this.tz,
  });

  static OdooUser? parse({
    required OdooResponse response,
    String? sessionId,
  }) {
    if (!response.hasError) {
      Map data = response.getResult();
      return OdooUser(
        sessionId: sessionId,
        companyId: data['company_id'],
        name: data['name'],
        uid: data['uid'],
        database: data['db'],
        lang: data['user_context']['lang'],
        partnerId: data['partner_id'],
        tz: data['user_context']['tz'],
        username: data['username'],
      );
    }
    return null;
  }

  @override
  String toString() {
    var map = {
      "name": name,
      "uid": uid,
      "partner_id": partnerId,
      "company_id": companyId,
      "username": username,
      "lang": lang,
      "timezone": tz,
      "database": database,
      "session_id": sessionId
    };
    return map.toString();
  }
}
