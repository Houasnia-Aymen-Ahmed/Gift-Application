# Push notifier (Cloudflare Worker)

Replaces the Firebase Cloud Function in `functions/` — same job (send a push via FCM
when a message/gift/friend request is created), but hosted on Cloudflare's free tier
instead of requiring the Blaze plan.

## Deploy (dashboard, no CLI needed)

1. Go to https://dash.cloudflare.com → **Workers & Pages** → **Create application** →
   **Create Worker**.
2. Name it `gift-notify` (this makes the URL `https://gift-notify.<your-subdomain>.workers.dev`).
   If you pick a different name, use that URL instead everywhere below.
3. Click **Deploy** to create it with the default hello-world code, then click
   **Edit code**.
4. Delete everything in the editor, paste in the full contents of `index.js` from this
   folder, click **Deploy**.
5. Go to the Worker's **Settings** tab → **Variables and Secrets** → **Add**. Add these
   four, each as type **Secret** (not plaintext variable):

   | Name | Value |
   |---|---|
   | `GCP_CLIENT_EMAIL` | `push-notifier@gift-present-app.iam.gserviceaccount.com` |
   | `GCP_PRIVATE_KEY` | the `private_key` field from `gift/secrets/gift-present-app-afa1dc3d5540.json` — open that file yourself and copy the value between the quotes, including the `\n`s, paste it exactly as one line |
   | `GCP_PROJECT_ID` | `gift-present-app` |
   | `SHARED_SECRET` | `efc68e5e2e4c3e0b5e85e3981f0df7bd109d820aeee7da6a0f3df74d84fa25e` |

6. Save. That's the whole deploy — no build step, no CLI.

## Test it

```
curl -X POST https://gift-notify.<your-subdomain>.workers.dev \
  -H "Authorization: Bearer efc68e5e2e4c3e0b5e85e3981f0df7bd109d820aeee7da6a0f3df74d84fa25e" \
  -H "Content-Type: application/json" \
  -d '{"recipientUid":"<some real uid from UserCollection>","kind":"message","senderName":"Test"}'
```

Should return `ok`. If it 500s, the error message tells you which secret is wrong.

## Known limitation vs. a real Cloud Function

This only fires when the *sender's* device is online and successfully reaches
Cloudflare at send time — same as any client-triggered call. It does **not** depend on
the recipient's app being open (unlike the in-app-only fallback this replaces) — FCM
delivers to their device even if their app is fully closed. That's the actual upgrade
this buys you for $0.

The `SHARED_SECRET` is compiled into the Flutter app, same tradeoff as any
client-embedded credential — someone who decompiles the APK could extract it and call
this endpoint directly. Low stakes for this app's scale; Firebase App Check would close
that gap properly if it ever matters.
