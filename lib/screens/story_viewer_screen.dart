import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:guitara_whatsapp_task/models/story.dart';
import 'package:guitara_whatsapp_task/cubits/story_cubit.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<Story> allStories;
  final int initialPersonIndex;
  final int initialStoryIndex;

  const StoryViewerScreen({
    super.key,
    required this.allStories,
    required this.initialPersonIndex,
    required this.initialStoryIndex,
  });

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with TickerProviderStateMixin {
  late PageController _personPageController;
  late PageController _storyPageController;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  int _currentPersonIndex = 0;
  int _currentStoryIndex = 0;
  bool _isPaused = false;

  List<List<Story>> _groupedStories = [];

  @override
  void initState() {
    super.initState();
    _currentPersonIndex = widget.initialPersonIndex;
    _currentStoryIndex = widget.initialStoryIndex;

    // Group stories by user
    _groupedStories = _groupStoriesByUser(widget.allStories);

    _personPageController = PageController(initialPage: _currentPersonIndex);
    _storyPageController = PageController(initialPage: _currentStoryIndex);
    _progressController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );

    // Mark current story as viewed
    _markCurrentStoryAsViewed();

    // Start progress animation
    _startProgress();
  }

  @override
  void dispose() {
    _personPageController.dispose();
    _storyPageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  List<List<Story>> _groupStoriesByUser(List<Story> stories) {
    final Map<String, List<Story>> grouped = {};

    for (var story in stories) {
      if (!grouped.containsKey(story.userId)) {
        grouped[story.userId] = [];
      }
      grouped[story.userId]!.add(story);
    }

    // Sort stories within each user by timestamp
    for (var userStories in grouped.values) {
      userStories.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }

    return grouped.values.toList();
  }

  void _markCurrentStoryAsViewed() {
    if (_groupedStories.isNotEmpty &&
        _currentPersonIndex < _groupedStories.length &&
        _currentStoryIndex < _groupedStories[_currentPersonIndex].length) {
      final currentStory =
          _groupedStories[_currentPersonIndex][_currentStoryIndex];
      if (!currentStory.isViewed) {
        context.read<StoryCubit>().markStoryAsViewed(currentStory.id);
      }
    }
  }

  void _startProgress() {
    if (!_isPaused) {
      _progressController.forward().then((_) {
        _nextStory();
      });
    }
  }

  void _nextStory() {
    final currentPersonStories = _groupedStories[_currentPersonIndex];

    if (_currentStoryIndex < currentPersonStories.length - 1) {
      // Next story in same person
      setState(() {
        _currentStoryIndex++;
      });
      _storyPageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _resetProgress();
    } else if (_currentPersonIndex < _groupedStories.length - 1) {
      // Next person, first story
      setState(() {
        _currentPersonIndex++;
        _currentStoryIndex = 0;
      });
      _personPageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _resetProgress();
    } else {
      // End of all stories
      Navigator.of(context).pop();
    }
  }

  void _previousStory() {
    if (_currentStoryIndex > 0) {
      // Previous story in same person
      setState(() {
        _currentStoryIndex--;
      });
      _storyPageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _resetProgress();
    } else if (_currentPersonIndex > 0) {
      // Previous person, last story
      setState(() {
        _currentPersonIndex--;
        _currentStoryIndex = _groupedStories[_currentPersonIndex].length - 1;
      });
      _personPageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _resetProgress();
    } else {
      // Beginning of all stories
      Navigator.of(context).pop();
    }
  }

  void _resetProgress() {
    _progressController.reset();
    _markCurrentStoryAsViewed();
    _startProgress();
  }

  void _onTapDown(TapDownDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tapX = details.globalPosition.dx;

    if (tapX < screenWidth / 3) {
      // Left side - previous story
      _previousStory();
    } else if (tapX > screenWidth * 2 / 3) {
      // Right side - next story
      _nextStory();
    } else {
      // Center - pause/resume
      setState(() {
        _isPaused = !_isPaused;
      });
      if (_isPaused) {
        _progressController.stop();
      } else {
        _startProgress();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_groupedStories.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'No stories available',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final currentPersonStories = _groupedStories[_currentPersonIndex];
    final currentStory = currentPersonStories[_currentStoryIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: _onTapDown,
        child: Stack(
          children: [
            // Story content
            PageView.builder(
              controller: _personPageController,
              onPageChanged: (personIndex) {
                setState(() {
                  _currentPersonIndex = personIndex;
                  _currentStoryIndex = 0;
                });
                _resetProgress();
              },
              itemCount: _groupedStories.length,
              itemBuilder: (context, personIndex) {
                final personStories = _groupedStories[personIndex];
                return PageView.builder(
                  controller: personIndex == _currentPersonIndex
                      ? _storyPageController
                      : null,
                  onPageChanged: (storyIndex) {
                    setState(() {
                      _currentStoryIndex = storyIndex;
                    });
                    _resetProgress();
                  },
                  itemCount: personStories.length,
                  itemBuilder: (context, storyIndex) {
                    final story = personStories[storyIndex];
                    return _buildStoryContent(story);
                  },
                );
              },
            ),

            // Progress bars
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16,
              right: 16,
              child: Row(
                children: List.generate(
                  currentPersonStories.length,
                  (index) => Expanded(
                    child: Container(
                      height: 2,
                      margin: EdgeInsets.only(
                        right: index < currentPersonStories.length - 1 ? 4 : 0,
                      ),
                      child: AnimatedBuilder(
                        animation: index == _currentStoryIndex
                            ? _progressAnimation
                            : const AlwaysStoppedAnimation(0),
                        builder: (context, child) {
                          return LinearProgressIndicator(
                            value: index < _currentStoryIndex
                                ? 1.0
                                : index == _currentStoryIndex
                                ? _progressAnimation.value
                                : 0.0,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.3,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Header
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: CachedNetworkImageProvider(
                      currentStory.userAvatar,
                    ),
                    child: currentStory.userAvatar.isEmpty
                        ? Text(
                            currentStory.userName[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentStory.userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _formatStoryTime(currentStory.timestamp),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryContent(Story story) {
    switch (story.type) {
      case StoryType.text:
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple[400]!,
                Colors.blue[400]!,
                Colors.green[400]!,
                Colors.orange[400]!,
                Colors.red[400]!,
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                story.content,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );

      case StoryType.image:
        return CachedNetworkImage(
          imageUrl: story.content,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholder: (context, url) => Container(
            color: Colors.grey[900],
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[900],
            child: const Center(
              child: Icon(Icons.error, color: Colors.white, size: 48),
            ),
          ),
        );

      case StoryType.video:
        return Container(
          color: Colors.grey[900],
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videocam, color: Colors.white, size: 64),
                SizedBox(height: 16),
                Text(
                  'Video stories coming soon!',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        );
    }
  }

  String _formatStoryTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
