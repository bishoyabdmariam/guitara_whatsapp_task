import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:guitara_whatsapp_task/models/story.dart';
import 'package:guitara_whatsapp_task/theme/app_theme.dart';

class StoryCircle extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;
  final double size;

  const StoryCircle({
    super.key,
    required this.story,
    required this.onTap,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            // Story circle with gradient border
            Container(
              width: size,
              height: size,
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
                  color: isDark ? Colors.black : Colors.white,
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: story.userAvatar,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: size * 0.4,
                        color: Colors.grey[600],
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: size * 0.4,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Story name
            SizedBox(
              width: size + 16,
              child: Text(
                story.userName,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyStoryCircle extends StatelessWidget {
  final VoidCallback onTap;
  final double size;

  const MyStoryCircle({super.key, required this.onTap, this.size = 60});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            // My story circle
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
                border: Border.all(color: Colors.grey[400]!, width: 2),
              ),
              child: Stack(
                children: [
                  // Profile image
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: 'https://i.pravatar.cc/150?img=10',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: size * 0.4,
                          color: Colors.grey[600],
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: size * 0.4,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),

                  // Add story icon
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? Colors.black : Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // "My Status" text
            SizedBox(
              width: size + 16,
              child: Text(
                'My Status',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
