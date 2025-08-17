import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:guitara_whatsapp_task/cubits/chat_cubit.dart';
import 'package:guitara_whatsapp_task/widgets/chat_tile.dart';
import 'package:guitara_whatsapp_task/screens/chat_screen.dart';
import 'package:guitara_whatsapp_task/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('WhatsApp'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryGreen),
            );
          }

          if (state is ChatError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading chats',
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

          if (state is ChatLoaded) {
            final chats = state.chats;

            // Sort chats: pinned first, then by last message time
            final sortedChats = List.from(chats)
              ..sort((a, b) {
                if (a.isPinned && !b.isPinned) return -1;
                if (!a.isPinned && b.isPinned) return 1;
                return b.lastMessageTime.compareTo(a.lastMessageTime);
              });

            return AnimationLimiter(
              child: ListView.builder(
                itemCount: sortedChats.length,
                itemBuilder: (context, index) {
                  final chat = sortedChats[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: ChatTile(
                          chat: chat,
                          onTap: () {
                            // Animated navigation to chat screen
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        ChatScreen(chat: chat),
                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;

                                      var tween = Tween(
                                        begin: begin,
                                        end: end,
                                      ).chain(CurveTween(curve: curve));

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                transitionDuration: const Duration(
                                  milliseconds: 300,
                                ),
                              ),
                            );
                          },
                          onLongPress: () {
                            _showChatOptions(context, chat);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryGreen),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement new chat functionality
        },
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        heroTag: 'home_fab',
        child: const Icon(Icons.chat),
      ),
    );
  }

  void _showChatOptions(BuildContext context, chat) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.push_pin),
              title: Text(chat.isPinned ? 'Unpin chat' : 'Pin chat'),
              onTap: () {
                context.read<ChatCubit>().togglePinChat(chat.id);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.mark_email_read),
              title: const Text('Mark as read'),
              onTap: () {
                context.read<ChatCubit>().markChatAsRead(chat.id);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete chat'),
              onTap: () {
                // TODO: Implement delete chat functionality
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
