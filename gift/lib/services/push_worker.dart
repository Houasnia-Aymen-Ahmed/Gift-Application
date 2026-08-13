import 'dart:convert';
import 'package:http/http.dart' as http;

/// Best-effort call to the Cloudflare Worker in gift/worker/ that sends a
/// real FCM push (works even if the recipient's app is fully closed).
/// Deploy it per gift/worker/README.md, then fill in [_workerUrl] below.
/// Until then this silently no-ops — the in-app notification fallback in
/// notif.dart still covers the case where both apps are open.
class PushWorkerService {
  static const String _workerUrl = ''; // e.g. https://gift-notify.<subdomain>.workers.dev
  static const String _sharedSecret =
      'efc68e5e2e4c3e0b5e85e3981f0df7bd109d820aeee7da6a0f3df74d84fa25e';

  static Future<void> notify({
    required String recipientUid,
    required String kind,
    required String senderName,
  }) async {
    if (_workerUrl.isEmpty) return;
    try {
      await http.post(
        Uri.parse(_workerUrl),
        headers: {
          'Authorization': 'Bearer $_sharedSecret',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'recipientUid': recipientUid,
          'kind': kind,
          'senderName': senderName,
        }),
      );
    } catch (_) {
      // Best-effort: a failed push call must never block or break the
      // actual Firestore write, which already happened.
    }
  }
}
