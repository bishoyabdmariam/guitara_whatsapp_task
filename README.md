# WhatsApp Clone - Flutter App

A pixel-perfect WhatsApp-style Flutter application with production-quality code, featuring chat functionality, stories/status updates, and smooth animations.

## Features

### ✅ Implemented Features

- **Home Screen (Chat List)**
  - Display list of recent chats with avatars, names, last messages, and timestamps
  - Online status indicators
  - Unread message counters
  - Pin/unpin chat functionality
  - Smooth staggered animations

- **Chat Screen (Conversation)**
  - WhatsApp-style chat bubbles with proper alignment
  - Message timestamps and delivery status indicators
  - Animated message input with send button transitions
  - Smooth scrolling and auto-scroll to bottom
  - Message sending feedback animations

- **Stories Screen (Status)**
  - Horizontal scrollable story circles with gradient borders
  - "My Status" section with add story functionality
  - Recent updates list with proper timestamps
  - Tap-to-view story interactions
  - Viewed/unviewed story indicators

- **Design Fidelity**
  - Pixel-perfect WhatsApp UI colors and styling
  - Light and dark mode support
  - Adaptive layouts for different screen sizes
  - Proper typography and spacing

- **Animations & Microinteractions**
  - Animated transitions when opening chats (slide animation)
  - Feedback animation when sending messages (SnackBar)
  - Smooth story viewing transitions
  - Staggered list animations
  - Animated send button transitions

## Screenshots

The app features a beautiful, modern UI that closely matches WhatsApp's design:

- **Home Screen**: Clean chat list with proper avatars and message previews
- **Chat Screen**: Familiar chat interface with green message bubbles
- **Stories Screen**: Instagram-style story circles with gradient borders

## Technical Architecture

### Project Structure
```
lib/
├── main.dart                 # App entry point with navigation setup
├── models/                   # Data models
│   ├── chat.dart            # Chat model
│   ├── message.dart         # Message model
│   └── story.dart           # Story model
├── cubits/                  # State management
│   ├── chat_cubit.dart      # Chat state management
│   └── story_cubit.dart     # Story state management
├── screens/                 # Main app screens
│   ├── home_screen.dart     # Chat list screen
│   ├── chat_screen.dart     # Individual chat screen
│   └── stories_screen.dart  # Stories/status screen
├── widgets/                 # Reusable UI components
│   ├── chat_tile.dart       # Chat list item widget
│   ├── message_bubble.dart  # Message bubble widget
│   └── story_circle.dart    # Story circle widget
└── theme/                   # App theming
    └── app_theme.dart       # Theme configuration
```

### State Management
- **Cubit Pattern**: Clean and scalable state management using flutter_bloc
- **ChatCubit**: Manages chat list, messages, and chat interactions
- **StoryCubit**: Handles stories, viewing status, and story interactions

### Dependencies
- **flutter_bloc**: State management with Cubit pattern
- **flutter_staggered_animations**: Smooth list animations
- **cached_network_image**: Efficient image caching
- **timeago**: Human-readable time formatting
- **lucide_icons**: Additional icon options

## Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd guitara_whatsapp_task
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Running on Different Platforms

- **iOS**: `flutter run -d ios`
- **Android**: `flutter run -d android`
- **Web**: `flutter run -d chrome`
- **Desktop**: `flutter run -d macos` (or windows/linux)

## Design Decisions

### UI/UX Philosophy
- **Pixel-Perfect Fidelity**: Meticulously matched WhatsApp's visual design
- **Responsive Design**: Adaptive layouts for different screen sizes
- **Accessibility**: Proper contrast ratios and touch targets
- **Performance**: Optimized with cached images and efficient rendering

### Color Scheme
- **Primary Green**: `#25D366` (WhatsApp's signature color)
- **Secondary Green**: `#128C7E` (Darker green for accents)
- **Chat Bubbles**: Light green for sent, light grey for received messages
- **Dark Mode**: Proper dark theme with appropriate contrast

### Animations
- **Smooth Transitions**: 300ms slide animations for navigation
- **Staggered Lists**: Beautiful staggered animations for chat and story lists
- **Microinteractions**: Subtle feedback animations for user actions
- **Performance**: Optimized animations that don't impact app performance

## Code Quality

### Best Practices
- **Clean Architecture**: Well-structured project with clear separation of concerns
- **Reusable Components**: Modular widgets for consistency and maintainability
- **Documentation**: Comprehensive comments and clear naming conventions
- **Error Handling**: Proper error states and fallbacks

### Performance Optimizations
- **Cached Images**: Efficient image loading with caching
- **List Optimization**: Efficient ListView.builder implementations
- **Memory Management**: Proper disposal of controllers and listeners
- **State Management**: Reactive updates without unnecessary rebuilds

## Future Enhancements

### Planned Features
- **Full Story Viewer**: Full-screen story viewing with swipe navigation
- **Message Reactions**: Emoji reactions for messages
- **Voice Messages**: Audio recording and playback
- **File Sharing**: Document and media sharing capabilities
- **Group Chats**: Multi-participant chat functionality

### Technical Improvements
- **Offline Support**: Local storage and offline message queuing
- **Push Notifications**: Real-time message notifications
- **End-to-End Encryption**: Message encryption for security
- **Video Calls**: In-app video calling functionality
- **Backup & Restore**: Chat history backup and restoration

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- WhatsApp for the original design inspiration
- Flutter team for the amazing framework
- The open-source community for the excellent packages used

---

**Note**: This is a demonstration project created for educational purposes. It is not affiliated with or endorsed by WhatsApp Inc.
