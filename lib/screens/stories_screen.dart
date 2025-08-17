import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:guitara_whatsapp_task/cubits/story_cubit.dart';
import 'package:guitara_whatsapp_task/widgets/story_circle.dart';
import 'package:guitara_whatsapp_task/theme/app_theme.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: () {
              // TODO: Implement camera functionality
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              // TODO: Implement menu actions
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'status_privacy',
                child: Row(
                  children: [
                    Icon(Icons.privacy_tip),
                    SizedBox(width: 8),
                    Text('Status privacy'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<StoryCubit, StoryState>(
        builder: (context, state) {
          if (state is StoryLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryGreen,
              ),
            );
          }

          if (state is StoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
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
            final myStories = stories.where((story) => story.isMyStory).toList();
            final otherStories = stories
                .where((story) => !story.isMyStory)
                .toList();

            return AnimationLimiter(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  // My Status section
                  if (myStories.isNotEmpty) ...[
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
                        itemCount: myStories.length,
                        itemBuilder: (context, index) {
                          final story = myStories[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              horizontalOffset: 50.0,
                              child: FadeInAnimation(
                                child: MyStoryCircle(
                                  onTap: () {
                                    _viewStory(story);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(height: 32),
                  ],

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
                              child: _buildStoryTile(context, story, theme),
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
            child: CircularProgressIndicator(
              color: AppTheme.primaryGreen,
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // TODO: Implement add status functionality
            },
            backgroundColor: Colors.grey[300],
            foregroundColor: AppTheme.primaryGreen,
            mini: true,
            child: const Icon(Icons.edit),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              // TODO: Implement camera functionality
            },
            backgroundColor: AppTheme.primaryGreen,
            foregroundColor: Colors.white,
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryTile(BuildContext context, story, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _viewStory(story);
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

  void _viewStory(story) {
    // Mark story as viewed
    context.read<StoryCubit>().markStoryAsViewed(story.id);

    // TODO: Implement full-screen story viewer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing ${story.userName}\'s story'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
