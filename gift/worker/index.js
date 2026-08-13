// Cloudflare Worker: sends a push notification for a message/gift/friend
// request, without needing Firebase Cloud Functions (which requires the
// Blaze plan). The client calls this endpoint right after writing to
// Firestore; this Worker mints its own Google OAuth token from a service
// account key and calls FCM's send API directly.
//
// Required secrets (Settings -> Variables and Secrets on this Worker):
//   GCP_CLIENT_EMAIL  - client_email field from the service account JSON
//   GCP_PRIVATE_KEY   - private_key field from the service account JSON (with the \n's, paste as-is)
//   GCP_PROJECT_ID    - the Firebase project id
//   SHARED_SECRET     - random string; must match the one compiled into the Flutter app

export default {
  async fetch(request, env) {
    if (request.method !== "POST") {
      return new Response("Method not allowed", { status: 405 });
    }

    const authHeader = request.headers.get("Authorization") || "";
    if (authHeader !== `Bearer ${env.SHARED_SECRET}`) {
      return new Response("Unauthorized", { status: 401 });
    }

    let body;
    try {
      body = await request.json();
    } catch (e) {
      return new Response("Bad request", { status: 400 });
    }

    const { recipientUid, kind, senderName } = body;
    if (!recipientUid || !kind || !senderName) {
      return new Response("Missing fields", { status: 400 });
    }

    try {
      const accessToken = await getAccessToken(env);

      const recipient = await getFirestoreDoc(env, accessToken, recipientUid);
      if (!recipient) return new Response("ok", { status: 200 });

      const enableNotif = recipient.fields?.enableNotif?.booleanValue;
      const token = recipient.fields?.token?.stringValue;
      if (enableNotif === false || !token) {
        return new Response("ok", { status: 200 });
      }

      const title = "Gift";
      const notifBody =
        kind === "gift"
          ? `${senderName} sent you a gift 🎁`
          : kind === "friend"
            ? `${senderName} wants to be your friend 😀`
            : `${senderName} sent you a message 📩`;

      await sendFcm(env, accessToken, token, title, notifBody, kind);

      return new Response("ok", { status: 200 });
    } catch (err) {
      return new Response(`Error: ${err.message}`, { status: 500 });
    }
  },
};

async function getAccessToken(env) {
  const now = Math.floor(Date.now() / 1000);
  const header = { alg: "RS256", typ: "JWT" };
  const claim = {
    iss: env.GCP_CLIENT_EMAIL,
    scope:
      "https://www.googleapis.com/auth/firebase.messaging https://www.googleapis.com/auth/datastore",
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
  };

  const base64url = (obj) =>
    btoa(JSON.stringify(obj))
      .replace(/\+/g, "-")
      .replace(/\//g, "_")
      .replace(/=+$/, "");

  const unsigned = `${base64url(header)}.${base64url(claim)}`;

  const key = await importPrivateKey(env.GCP_PRIVATE_KEY);
  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    key,
    new TextEncoder().encode(unsigned),
  );

  const sigB64 = btoa(String.fromCharCode(...new Uint8Array(signature)))
    .replace(/\+/g, "-")
    .replace(/\//g, "_")
    .replace(/=+$/, "");

  const jwt = `${unsigned}.${sigB64}`;

  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${jwt}`,
  });
  const data = await res.json();
  if (!data.access_token) {
    throw new Error("OAuth token exchange failed: " + JSON.stringify(data));
  }
  return data.access_token;
}

async function importPrivateKey(pem) {
  const pemContents = pem
    .replace("-----BEGIN PRIVATE KEY-----", "")
    .replace("-----END PRIVATE KEY-----", "")
    .replace(/\n/g, "")
    .trim();
  const binaryDer = Uint8Array.from(atob(pemContents), (c) => c.charCodeAt(0));
  return crypto.subtle.importKey(
    "pkcs8",
    binaryDer.buffer,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
}

async function getFirestoreDoc(env, accessToken, uid) {
  const url = `https://firestore.googleapis.com/v1/projects/${env.GCP_PROJECT_ID}/databases/(default)/documents/UserCollection/${uid}`;
  const res = await fetch(url, {
    headers: { Authorization: `Bearer ${accessToken}` },
  });
  if (res.status === 404) return null;
  if (!res.ok) throw new Error("Firestore read failed: " + (await res.text()));
  return res.json();
}

async function sendFcm(env, accessToken, token, title, body, kind) {
  const url = `https://fcm.googleapis.com/v1/projects/${env.GCP_PROJECT_ID}/messages:send`;
  const res = await fetch(url, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${accessToken}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      message: {
        token,
        notification: { title, body },
        data: { type: kind, message: body },
      },
    }),
  });
  if (!res.ok) {
    console.log("FCM send failed: " + (await res.text()));
  }
}
