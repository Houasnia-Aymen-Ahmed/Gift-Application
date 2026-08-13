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

Push notifications are sent by the Cloud Function in `functions/` (triggered on new
messages/gifts/friend requests), not from the client. Deploying it requires the project to
be on the Blaze plan:

```
cd functions && npm install && cd ..
firebase deploy --only functions
```
