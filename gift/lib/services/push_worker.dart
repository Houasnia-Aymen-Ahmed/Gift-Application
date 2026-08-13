import 'dart:convert';
import 'package:http/http.dart' as http;

/// Best-effort call to the Cloudflare Worker in gift/worker/ that sends a
/// real FCM push (works even if the recipient's app is fully closed).
/// Deploy it per gift/worker/README.md, then fill in [_workerUrl] below.
/// Until then this silently no-ops — the in-app notification fallback in
/// notif.dart still covers the case where both apps are open.
class PushWorkerService {
  static const String _workerUrl = 'https://gift-notify.aymenaymen2056.workers.dev/';
  static const String _sharedSecret =
      '99f864cfae143ad934b214719b8bae5534b9a891d60bdf43a60122ef4380d2d7';

  static Future<void> notify({
    required String recipientUid,
    required String senderUid,
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
          'senderUid': senderUid,
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
