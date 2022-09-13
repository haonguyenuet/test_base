import 'dart:io';

enum NetworkType { none, wifi, mobile, vpn }

class ConnectionUtil {
  static Future<bool> isNetworkAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static NetworkType getNetworkType() {
    return NetworkType.wifi;
  }
}
