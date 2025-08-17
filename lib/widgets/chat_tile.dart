import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:guitara_whatsapp_task/models/chat.dart';
import 'package:guitara_whatsapp_task/theme/app_theme.dart';

class ChatTile extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const ChatTile({
    super.key,
    required this.chat,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Avatar with online indicator
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: CachedNetworkImageProvider(chat.avatarUrl),
                    child: chat.avatarUrl.isEmpty
                        ? Text(
                            chat.name[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  if (chat.isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? Colors.black : Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),

              // Chat info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: chat.unreadCount > 0
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (chat.isPinned)
                          const Icon(
                            Icons.push_pin,
                            size: 16,
                            color: Colors.grey,
                          ),
                        const SizedBox(width: 4),
                        Text(
                          timeago.format(chat.lastMessageTime),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: chat.unreadCount > 0
                                ? AppTheme.primaryGreen
                                : Colors.grey,
                            fontWeight: chat.unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (chat.unreadCount > 0) ...[
                          const Icon(
                            Icons.done_all,
                            size: 16,
                            color: AppTheme.primaryGreen,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Expanded(
                          child: Text(
                            chat.lastMessage,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: chat.unreadCount > 0
                                  ? Colors.black87
                                  : Colors.grey[600],
                              fontWeight: chat.unreadCount > 0
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (chat.unreadCount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              chat.unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
