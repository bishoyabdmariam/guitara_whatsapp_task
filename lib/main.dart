import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guitara_whatsapp_task/screens/home_screen.dart';
import 'package:guitara_whatsapp_task/screens/stories_screen.dart';
import 'package:guitara_whatsapp_task/theme/app_theme.dart';
import 'package:guitara_whatsapp_task/cubits/chat_cubit.dart';
import 'package:guitara_whatsapp_task/cubits/story_cubit.dart';

void main() {
  runApp(const WhatsAppApp());
}

class WhatsAppApp extends StatelessWidget {
  const WhatsAppApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ChatCubit()),
        BlocProvider(create: (_) => StoryCubit()),
      ],
      child: MaterialApp(
        title: 'WhatsApp Clone',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [const HomeScreen(), const StoriesScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: AppTheme.primaryGreen,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.circle_outlined),
            activeIcon: Icon(Icons.circle),
            label: 'Stories',
          ),
        ],
      ),
    );
  }
}
