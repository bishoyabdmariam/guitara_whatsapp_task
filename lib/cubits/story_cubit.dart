import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guitara_whatsapp_task/models/story.dart';

// Events
abstract class StoryEvent {}

class LoadStories extends StoryEvent {}

class MarkStoryAsViewed extends StoryEvent {
  final String storyId;

  MarkStoryAsViewed({required this.storyId});
}

class AddStory extends StoryEvent {
  final Story story;

  AddStory({required this.story});
}

class DeleteStory extends StoryEvent {
  final String storyId;

  DeleteStory({required this.storyId});
}

// States
abstract class StoryState {}

class StoryInitial extends StoryState {}

class StoryLoading extends StoryState {}

class StoryLoaded extends StoryState {
  final List<Story> stories;

  StoryLoaded({required this.stories});
}

class StoryError extends StoryState {
  final String message;

  StoryError({required this.message});
}

// Cubit
class StoryCubit extends Cubit<StoryState> {
  StoryCubit() : super(StoryInitial()) {
    loadStories();
  }

  List<Story> _stories = [];

  void loadStories() {
    emit(StoryLoading());
    
    _stories = [
      Story(
        id: '1',
        userId: '1',
        userName: 'My Status',
        userAvatar: 'https://i.pravatar.cc/150?img=10',
        content: 'https://picsum.photos/400/600?random=1',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isMyStory: true,
      ),
      Story(
        id: '2',
        userId: '2',
        userName: 'John Doe',
        userAvatar: 'https://i.pravatar.cc/150?img=1',
        content: 'https://picsum.photos/400/600?random=2',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isViewed: false,
      ),
      Story(
        id: '3',
        userId: '3',
        userName: 'Sarah Wilson',
        userAvatar: 'https://i.pravatar.cc/150?img=2',
        content: 'https://picsum.photos/400/600?random=3',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isViewed: false,
      ),
      Story(
        id: '4',
        userId: '4',
        userName: 'Mike Johnson',
        userAvatar: 'https://i.pravatar.cc/150?img=3',
        content: 'https://picsum.photos/400/600?random=4',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        isViewed: true,
      ),
      Story(
        id: '5',
        userId: '5',
        userName: 'Emily Davis',
        userAvatar: 'https://i.pravatar.cc/150?img=4',
        content: 'https://picsum.photos/400/600?random=5',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isViewed: false,
      ),
      Story(
        id: '6',
        userId: '6',
        userName: 'David Brown',
        userAvatar: 'https://i.pravatar.cc/150?img=5',
        content: 'https://picsum.photos/400/600?random=6',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        isViewed: true,
      ),
      Story(
        id: '7',
        userId: '7',
        userName: 'Lisa Anderson',
        userAvatar: 'https://i.pravatar.cc/150?img=6',
        content: 'https://picsum.photos/400/600?random=7',
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        isViewed: false,
      ),
    ];

    emit(StoryLoaded(stories: _stories));
  }

  void markStoryAsViewed(String storyId) {
    if (state is StoryLoaded) {
      final storyIndex = _stories.indexWhere((story) => story.id == storyId);
      if (storyIndex != -1 && !_stories[storyIndex].isViewed) {
        _stories[storyIndex] = _stories[storyIndex].copyWith(isViewed: true);
        emit(StoryLoaded(stories: _stories));
      }
    }
  }

  void addStory(Story story) {
    if (state is StoryLoaded) {
      _stories.insert(0, story);
      emit(StoryLoaded(stories: _stories));
    }
  }

  void deleteStory(String storyId) {
    if (state is StoryLoaded) {
      _stories.removeWhere((story) => story.id == storyId);
      emit(StoryLoaded(stories: _stories));
    }
  }

  List<Story> getStoriesByUser(String userId) {
    return _stories.where((story) => story.userId == userId).toList();
  }

  List<Story> getUnviewedStories() {
    return _stories
        .where((story) => !story.isViewed && !story.isMyStory)
        .toList();
  }
}
