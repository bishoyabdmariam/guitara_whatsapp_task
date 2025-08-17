import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:guitara_whatsapp_task/models/message.dart';
import 'package:guitara_whatsapp_task/theme/app_theme.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool showTime;

  const MessageBubble({super.key, required this.message, this.showTime = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Align(
      alignment: message.isFromMe
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: message.isFromMe ? 64 : 16,
          right: message.isFromMe ? 16 : 64,
          top: 4,
          bottom: 4,
        ),
        child: Column(
          crossAxisAlignment: message.isFromMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: message.isFromMe
                    ? (isDark
                          ? AppTheme.darkChatBubbleBlue
                          : AppTheme.chatBubbleGreen)
                    : (isDark
                          ? AppTheme.darkChatBubbleGrey
                          : AppTheme.chatBubbleGrey),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isFromMe ? 16 : 4),
                  bottomRight: Radius.circular(message.isFromMe ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: message.isFromMe
                          ? (isDark ? Colors.white : Colors.black87)
                          : (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showTime) ...[
                        Text(
                          timeago.format(message.timestamp),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: message.isFromMe
                                ? (isDark ? Colors.white70 : Colors.black54)
                                : (isDark ? Colors.white70 : Colors.black54),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      if (message.isFromMe) ...[_buildStatusIcon()],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (message.status) {
      case MessageStatus.sending:
        return const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 1,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
        );
      case MessageStatus.sent:
        return const Icon(Icons.done, size: 16, color: Colors.grey);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 16, color: Colors.grey);
      case MessageStatus.read:
        return const Icon(
          Icons.done_all,
          size: 16,
          color: AppTheme.primaryGreen,
        );
    }
  }
}
