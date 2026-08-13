import 'package:flutter_test/flutter_test.dart';
import 'package:gift/models/user_of_gift.dart';

void main() {
  test('UserOfGift defaults to a friendless, existing user', () {
    final user = UserOfGift();

    expect(user.friend, '');
    expect(user.friendList, isEmpty);
    expect(user.giftSent, 0);
    expect(user.giftRecieved, 0);
    expect(user.exists, isTrue);
  });

  test('UserOfGift marks itself absent when constructed as such', () {
    final missingUser = UserOfGift(exists: false);

    expect(missingUser.exists, isFalse);
  });
}
