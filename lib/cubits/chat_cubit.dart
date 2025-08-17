import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guitara_whatsapp_task/models/chat.dart';
import 'package:guitara_whatsapp_task/models/message.dart';

// Events
abstract class ChatEvent {}

class LoadChats extends ChatEvent {}

class SendMessage extends ChatEvent {
  final String chatId;
  final String content;

  SendMessage({required this.chatId, required this.content});
}

class MarkChatAsRead extends ChatEvent {
  final String chatId;

  MarkChatAsRead({required this.chatId});
}

class TogglePinChat extends ChatEvent {
  final String chatId;

  TogglePinChat({required this.chatId});
}

// States
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Chat> chats;
  final Map<String, List<Message>> messages;

  ChatLoaded({required this.chats, required this.messages});
}

class ChatError extends ChatState {
  final String message;

  ChatError({required this.message});
}

// Cubit
class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial()) {
    loadChats();
  }

  List<Chat> _chats = [];
  Map<String, List<Message>> _messages = {};

  void loadChats() {
    emit(ChatLoading());
    
    _chats = [
      Chat(
        id: '1',
        name: 'John Doe',
        lastMessage: 'Hey, how are you doing?',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        unreadCount: 2,
        isOnline: true,
        isPinned: true,
      ),
      Chat(
        id: '2',
        name: 'Sarah Wilson',
        lastMessage: 'The meeting is scheduled for tomorrow',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
        avatarUrl: 'https://i.pravatar.cc/150?img=2',
        unreadCount: 0,
        isOnline: false,
      ),
      Chat(
        id: '3',
        name: 'Mike Johnson',
        lastMessage: 'Thanks for the help!',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        unreadCount: 1,
        isOnline: true,
      ),
      Chat(
        id: '4',
        name: 'Emily Davis',
        lastMessage: 'Can you send me the files?',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        avatarUrl: 'https://i.pravatar.cc/150?img=4',
        unreadCount: 0,
        isOnline: false,
      ),
      Chat(
        id: '5',
        name: 'David Brown',
        lastMessage: 'Great work on the project!',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
        unreadCount: 0,
        isOnline: false,
      ),
    ];

    // Load mock messages for each chat
    for (var chat in _chats) {
      _messages[chat.id] = _generateMockMessages(chat.id);
    }

    emit(ChatLoaded(chats: _chats, messages: _messages));
  }

  List<Message> _generateMockMessages(String chatId) {
    final messages = <Message>[];
    final now = DateTime.now();

    // Add some mock messages
    messages.add(
      Message(
        id: '1',
        chatId: chatId,
        senderId: chatId,
        content: 'Hey, how are you doing?',
        timestamp: now.subtract(const Duration(minutes: 5)),
        isFromMe: false,
      ),
    );

    messages.add(
      Message(
        id: '2',
        chatId: chatId,
        senderId: 'me',
        content: 'I\'m doing great! How about you?',
        timestamp: now.subtract(const Duration(minutes: 4)),
        isFromMe: true,
      ),
    );

    messages.add(
      Message(
        id: '3',
        chatId: chatId,
        senderId: chatId,
        content: 'Pretty good! Working on some new projects.',
        timestamp: now.subtract(const Duration(minutes: 3)),
        isFromMe: false,
      ),
    );

    messages.add(
      Message(
        id: '4',
        chatId: chatId,
        senderId: 'me',
        content: 'That sounds exciting! What kind of projects?',
        timestamp: now.subtract(const Duration(minutes: 2)),
        isFromMe: true,
      ),
    );

    messages.add(
      Message(
        id: '5',
        chatId: chatId,
        senderId: chatId,
        content: 'Mostly mobile apps and web development.',
        timestamp: now.subtract(const Duration(minutes: 1)),
        isFromMe: false,
      ),
    );

    return messages;
  }

  void sendMessage(String chatId, String content) {
    if (state is ChatLoaded) {
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: chatId,
        senderId: 'me',
        content: content,
        timestamp: DateTime.now(),
        isFromMe: true,
        status: MessageStatus.sending,
      );

      if (!_messages.containsKey(chatId)) {
        _messages[chatId] = [];
      }

      _messages[chatId]!.add(newMessage);

      // Update chat's last message
      final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
      if (chatIndex != -1) {
        _chats[chatIndex] = _chats[chatIndex].copyWith(
          lastMessage: content,
          lastMessageTime: DateTime.now(),
          unreadCount: 0,
        );
      }

      emit(ChatLoaded(chats: _chats, messages: _messages));

      // Simulate message delivery
      Future.delayed(const Duration(seconds: 1), () {
        final messageIndex = _messages[chatId]!.indexWhere(
          (msg) => msg.id == newMessage.id,
        );
        if (messageIndex != -1) {
          _messages[chatId]![messageIndex] = _messages[chatId]![messageIndex]
              .copyWith(status: MessageStatus.sent);
          emit(ChatLoaded(chats: _chats, messages: _messages));
        }
      });
    }
  }

  void markChatAsRead(String chatId) {
    if (state is ChatLoaded) {
      final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
      if (chatIndex != -1 && _chats[chatIndex].unreadCount > 0) {
        _chats[chatIndex] = _chats[chatIndex].copyWith(unreadCount: 0);
        emit(ChatLoaded(chats: _chats, messages: _messages));
      }
    }
  }

  void togglePinChat(String chatId) {
    if (state is ChatLoaded) {
      final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
      if (chatIndex != -1) {
        _chats[chatIndex] = _chats[chatIndex].copyWith(
          isPinned: !_chats[chatIndex].isPinned,
        );
        emit(ChatLoaded(chats: _chats, messages: _messages));
      }
    }
  }
}
