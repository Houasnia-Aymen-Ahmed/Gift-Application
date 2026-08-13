import 'package:home_widget/home_widget.dart';
import 'database.dart';
import '../models/user_of_gift.dart';
import '../models/conversation_message.dart';
import '../constants/bottom_sheet_constants.dart';

/// Drives the home-screen widget's "which friend is shown" state.
///
/// Widget storage keys (via home_widget's local, OS-backed key/value store —
/// this is separate from Firestore and readable from a background isolate
/// without any network round-trip):
///   _pinnedFriendUid - uid of the friend currently shown on the widget
///   _friendName      - that friend's display name, cached for the widget UI
///   _textContent     - the message/gift text currently shown
class WidgetService {
  final DatabaseService _databaseService = DatabaseService();

  /// Friends eligible for widget rotation: the user's explicit picks if any
  /// exist, otherwise every current friend (so the widget isn't empty for
  /// someone who's never touched the toggle).
  List<String> eligibleFriendUids(UserOfGift user) {
    final friendUids = user.friendList.cast<String>();
    final chosen =
        user.widgetFriends.cast<String>().where(friendUids.contains).toList();
    return chosen.isNotEmpty ? chosen : friendUids;
  }

  Future<String?> getPinnedFriendUid() =>
      HomeWidget.getWidgetData<String>('_pinnedFriendUid');

  Future<void> _writeContent(
      String friendUid, String friendName, String text) async {
    await HomeWidget.saveWidgetData<String>('_pinnedFriendUid', friendUid);
    await HomeWidget.saveWidgetData<String>('_friendName', friendName);
    await HomeWidget.saveWidgetData<String>('_textContent', text);
    await HomeWidget.updateWidget(
      name: 'AppWidgetProvider',
      iOSName: 'AppWidgetProvider',
    );
  }

  String _formatMessage(ConversationMessage? message) {
    if (message == null) return '';
    if (message.kind == 'gift') {
      return '🎁 ${GiftCatalog.byId(message.text).label}';
    }
    if (message.kind == 'message') return message.text;
    return '';
  }

  /// Loads and displays a specific friend's latest message. Safe to call
  /// from a background isolate.
  Future<void> pinFriend(String friendUid) async {
    final friend = await _databaseService.getUserDataOnce(friendUid);
    if (friend == null) return;
    final latest = await _databaseService.latestMessageOnce(friendUid);
    await _writeContent(friendUid, friend.userName, _formatMessage(latest));
  }

  /// Called on every Home build. Only establishes a starting pin if none
  /// exists yet or the pinned friend fell out of the eligible list (e.g.
  /// unfriended) — does NOT follow whichever friend is on-screen, since
  /// that would fight the user's own widget navigation.
  Future<void> ensureInitialPin(UserOfGift user) async {
    final eligible = eligibleFriendUids(user);
    if (eligible.isEmpty) return;
    final current = await getPinnedFriendUid();
    if (current != null && eligible.contains(current)) return;
    await pinFriend(eligible.first);
  }

  /// Moves the pin by [direction] (+1 next, -1 prev) among the eligible
  /// friends for the signed-in [user], wrapping around at the ends.
  Future<void> cyclePin(UserOfGift user, int direction) async {
    final eligible = eligibleFriendUids(user);
    if (eligible.isEmpty) return;
    final current = await getPinnedFriendUid();
    final currentIndex = current == null ? -1 : eligible.indexOf(current);
    // Dart's `%` returns a non-negative result for a positive divisor, so
    // this wraps correctly in both directions without extra handling.
    final nextIndex = (currentIndex + direction) % eligible.length;
    await pinFriend(eligible[nextIndex]);
  }

  /// Refreshes the widget's content only if [senderUid] is the friend
  /// currently pinned — prevents an unrelated friend's message from
  /// silently overwriting whatever the user has the widget showing. Ignores
  /// whatever text arrived in the triggering push and re-reads the real
  /// latest message from Firestore, since the push payload only carries a
  /// human-readable notification string, not the raw message/gift data.
  Future<void> refreshIfPinned(String senderUid) async {
    final pinned = await getPinnedFriendUid();
    if (pinned != senderUid) return;
    await pinFriend(senderUid);
  }
}
