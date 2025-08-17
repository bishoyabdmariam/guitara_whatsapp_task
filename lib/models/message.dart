enum MessageType { text, image, video, audio, document }

enum MessageStatus { sending, sent, delivered, read }

class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final MessageStatus status;
  final bool isFromMe;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    required this.isFromMe,
  });

  Message copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? content,
    DateTime? timestamp,
    MessageType? type,
    MessageStatus? status,
    bool? isFromMe,
  }) {
    return Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      status: status ?? this.status,
      isFromMe: isFromMe ?? this.isFromMe,
    );
  }
}
