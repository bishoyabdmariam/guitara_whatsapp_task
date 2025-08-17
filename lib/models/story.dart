enum StoryType { image, video, text }

class Story {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime timestamp;
  final StoryType type;
  final bool isViewed;
  final bool isMyStory;

  Story({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.timestamp,
    this.type = StoryType.image,
    this.isViewed = false,
    this.isMyStory = false,
  });

  Story copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? content,
    DateTime? timestamp,
    StoryType? type,
    bool? isViewed,
    bool? isMyStory,
  }) {
    return Story(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isViewed: isViewed ?? this.isViewed,
      isMyStory: isMyStory ?? this.isMyStory,
    );
  }
}
