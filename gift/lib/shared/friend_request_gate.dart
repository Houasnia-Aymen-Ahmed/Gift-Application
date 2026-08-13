import 'dart:async';
import 'package:flutter/material.dart';
import '../models/friend_request.dart';
import '../services/database.dart';

class FriendRequestGate extends StatefulWidget {
  final Widget child;
  const FriendRequestGate({super.key, required this.child});

  @override
  State<FriendRequestGate> createState() => _FriendRequestGateState();
}

class _FriendRequestGateState extends State<FriendRequestGate> {
  final DatabaseService _databaseService = DatabaseService();
  final Set<String> _shownRequestIds = {};
  StreamSubscription<List<FriendRequest>>? _incomingSub;
  StreamSubscription<List<FriendRequest>>? _outgoingSub;

  @override
  void initState() {
    super.initState();
    _incomingSub =
        _databaseService.incomingFriendRequests().listen(_handleIncoming);
    _outgoingSub =
        _databaseService.acceptedOutgoingRequests().listen(_handleAccepted);
  }

  void _handleIncoming(List<FriendRequest> requests) {
    for (final request in requests) {
      if (_shownRequestIds.contains(request.id)) continue;
      _shownRequestIds.add(request.id);
      _showRequestDialog(request);
    }
  }

  void _handleAccepted(List<FriendRequest> requests) {
    for (final request in requests) {
      _databaseService.completeOutgoingFriendRequest(request);
    }
  }

  Future<void> _showRequestDialog(FriendRequest request) async {
    final sender = await _databaseService.getUserDataOnce(request.from);
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Friend Request'),
        content:
            Text('${sender?.userName ?? 'Someone'} wants to be your friend.'),
        actions: [
          TextButton(
            onPressed: () {
              _databaseService.declineFriendRequest(request.id);
              Navigator.of(context).pop();
            },
            child: const Text('Decline'),
          ),
          TextButton(
            onPressed: () {
              _databaseService.acceptFriendRequest(request);
              Navigator.of(context).pop();
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _incomingSub?.cancel();
    _outgoingSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
