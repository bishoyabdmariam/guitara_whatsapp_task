import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:guitara_whatsapp_task/cubits/story_cubit.dart';
import 'package:guitara_whatsapp_task/widgets/story_circle.dart';
import 'package:guitara_whatsapp_task/screens/story_viewer_screen.dart';
import 'package:guitara_whatsapp_task/screens/add_status_screen.dart';
import 'package:guitara_whatsapp_task/theme/app_theme.dart';
import 'package:guitara_whatsapp_task/models/story.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Status'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: BlocBuilder<StoryCubit, StoryState>(
        builder: (context, state) {
          if (state is StoryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryGreen),
            );
          }

          if (state is StoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading stories',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is StoryLoaded) {
            final stories = state.stories;
            final myStories = stories
                .where((story) => story.isMyStory)
                .toList();
            final otherStories = stories
                .where((story) => !story.isMyStory)
                .toList();

            return AnimationLimiter(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  // My Status section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      'My Status',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: myStories.length + 1, // +1 for add status
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // Add status button
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              horizontalOffset: 50.0,
                              child: FadeInAnimation(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AddStatusScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey[300],
                                            border: Border.all(
                                              color: Colors.grey[400]!,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            size: 30,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Add Status',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          // My stories
                          final story = myStories[index - 1];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              horizontalOffset: 50.0,
                              child: FadeInAnimation(
                                child: MyStoryCircle(
                                  onTap: () {
                                    _viewStory(story, myStories, index - 1);
                                  },
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const Divider(height: 32),

                  // Recent updates section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      'Recent updates',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Stories grid
                  AnimationLimiter(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: otherStories.length,
                      itemBuilder: (context, index) {
                        final story = otherStories[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildStoryTile(
                                context,
                                story,
                                theme,
                                otherStories,
                                index,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryGreen),
          );
        },
      ),
    );
  }

  Widget _buildStoryTile(
    BuildContext context,
    Story story,
    ThemeData theme,
    List<Story> stories,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _viewStory(story, stories, index);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: Row(
              children: [
                // Story circle
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: story.isViewed
                        ? null
                        : const LinearGradient(
                            colors: [
                              AppTheme.primaryGreen,
                              AppTheme.secondaryGreen,
                              Colors.orange,
                              Colors.red,
                              Colors.purple,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    border: story.isViewed
                        ? Border.all(color: Colors.grey[400]!, width: 2)
                        : null,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                    ),
                    child: ClipOval(
                      child: Image.network(
                        story.userAvatar,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.person,
                              size: 20,
                              color: Colors.grey[600],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Story info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.userName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatStoryTime(story.timestamp),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // View indicator
                if (!story.isViewed)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
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

  void _viewStory(Story story, List<Story> stories, int index) {
    // Mark story as viewed
    context.read<StoryCubit>().markStoryAsViewed(story.id);

    // Find the person index in all stories
    final allStories = context.read<StoryCubit>().stories;
    final groupedStories = _groupStoriesByUser(allStories);

    int personIndex = 0;
    int storyIndex = 0;

    for (int i = 0; i < groupedStories.length; i++) {
      final personStories = groupedStories[i];
      for (int j = 0; j < personStories.length; j++) {
        if (personStories[j].id == story.id) {
          personIndex = i;
          storyIndex = j;
          break;
        }
      }
    }

    // Navigate to story viewer
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StoryViewerScreen(
          allStories: allStories,
          initialPersonIndex: personIndex,
          initialStoryIndex: storyIndex,
        ),
      ),
    );
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
}
