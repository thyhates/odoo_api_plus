import 'odoo_response.dart';
import 'odoo_user.dart';

class AuthenticateCallback {
  final bool isSuccess;
  final OdooResponse response;
  final String newSessionId;

  AuthenticateCallback({
    this.isSuccess = false,
    required this.response,
    required this.newSessionId,
  });

  OdooUser? get user {
    return OdooUser.parse(
      response: response,
      sessionId: newSessionId,
    );
  }

  Map? get error => !isSuccess ? response.error : null;
}
