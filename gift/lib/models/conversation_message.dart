class ConversationMessage {
  final String id;
  final String from;
  final String to;
  final String text;
  final String kind;
  final DateTime? sentAt;

  ConversationMessage({
    required this.id,
    required this.from,
    required this.to,
    required this.text,
    required this.kind,
    this.sentAt,
  });
}
