# gift

Flutter app. See the [repo root README](../README.md) for what the app does and how it's used.

## Development setup

```
flutter pub get
flutter run
```

Requires a Firebase project with Firestore, Storage, and Cloud Messaging enabled, plus
`google-services.json` (Android) / `GoogleService-Info.plist` (iOS) and `firebase_options.dart`
for that project — these are gitignored and not included in the repo.

Firestore/Storage security rules live in `firestore.rules` and `storage.rules` at the repo
root and must be deployed with the Firebase CLI:

```
firebase deploy --only firestore:rules,storage
```

Notifications currently work as an **in-app-only fallback**: `notif.dart` listens to
Firestore directly and shows a local notification for new messages/gifts/friend requests
while this app process is alive — no delivery when the app is killed or on a friend's
other device, and no server component needed.

`functions/` contains a Cloud Function that upgrades this to real push (delivers even when
killed), triggered on the same Firestore writes. It requires the Blaze plan (pay-as-you-go,
free tier covers this app's volume, but a card must be on file — Google holds/releases a
temporary authorization to verify the card, no real charge for this app's scale). Once on
Blaze:

```
cd functions && npm install && cd ..
firebase deploy --only functions
```

No client code changes needed when you do — `notif.dart` already registers the FCM token
either way.
