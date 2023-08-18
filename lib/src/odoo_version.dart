import 'odoo_response.dart';

class OdooVersion {
  final String? version;
  final int? serverSerie;
  final int? protocolVersion;
  final dynamic major;
  final int? minor;
  final int? micro;
  final String? releaseLevel;
  final String? serial;
  final bool isEnterprise;

  OdooVersion({
    this.version,
    this.isEnterprise = false,
    this.major,
    this.micro,
    this.minor,
    this.protocolVersion,
    this.releaseLevel,
    this.serial,
    this.serverSerie,
  });

  static OdooVersion parse(OdooResponse response) {
    Map<String, dynamic> result = response.getResult();
    List<dynamic> versionInfo = result['server_version_info'];
    bool enterprise = false;
    if (versionInfo.length == 6) {
      enterprise = versionInfo.last == "e";
    }

    return OdooVersion(
      isEnterprise: enterprise,
      major: versionInfo[0],
      micro: versionInfo[2],
      minor: versionInfo[1],
      protocolVersion: result['protocol_version'],
      releaseLevel: versionInfo[3],
      serial: versionInfo[4],
      serverSerie: result['server_serie'],
      version: result['server_version'],
    );
  }

  @override
  String toString() {
    if (version != null) {
      return "$version (${isEnterprise ? 'Enterprise' : 'Community'})";
    }
    return "Not Connected: Please call connect() or getVersionInfo() with callback.";
  }
}
