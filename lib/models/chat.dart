class Chat {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String avatarUrl;
  final int unreadCount;
  final bool isOnline;
  final bool isPinned;

  Chat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.avatarUrl,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isPinned = false,
  });

  Chat copyWith({
    String? id,
    String? name,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? avatarUrl,
    int? unreadCount,
    bool? isOnline,
    bool? isPinned,
  }) {
    return Chat(
      id: id ?? this.id,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'avatarUrl': avatarUrl,
      'unreadCount': unreadCount,
      'isOnline': isOnline,
      'isPinned': isPinned,
    };
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      name: json['name'],
      lastMessage: json['lastMessage'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
      avatarUrl: json['avatarUrl'],
      unreadCount: json['unreadCount'] ?? 0,
      isOnline: json['isOnline'] ?? false,
      isPinned: json['isPinned'] ?? false,
    );
  }
}
