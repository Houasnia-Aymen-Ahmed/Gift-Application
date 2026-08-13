const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();
const db = getFirestore();
const messaging = getMessaging();

async function getUser(uid) {
  const doc = await db.collection("UserCollection").doc(uid).get();
  return doc.exists ? doc.data() : null;
}

async function notifyUser(recipientUid, title, body, data) {
  const recipient = await getUser(recipientUid);
  if (!recipient || recipient.enableNotif === false) return;
  const token = recipient.token;
  if (!token) return;

  await messaging.send({
    token,
    notification: { title, body },
    data,
  });
}

exports.onMessageCreated = onDocumentCreated(
  "Conversations/{pairId}/messages/{messageId}",
  async (event) => {
    const message = event.data.data();
    const sender = await getUser(message.from);
    const senderName = sender?.username || "Someone";

    const isGift = message.kind === "gift";
    const body = isGift
      ? `${senderName} sent you a gift 🎁`
      : `${senderName} sent you a message 📩`;

    await notifyUser(message.to, "Gift", body, {
      type: message.kind || "message",
      message: message.text || "",
    });
  }
);

exports.onFriendRequestCreated = onDocumentCreated(
  "FriendRequests/{requestId}",
  async (event) => {
    const request = event.data.data();
    if (request.status !== "pending") return;

    const sender = await getUser(request.from);
    const senderName = sender?.username || "Someone";

    await notifyUser(
      request.to,
      "Gift",
      `${senderName} wants to be your friend 😀`,
      { type: "friend", message: "" }
    );
  }
);
