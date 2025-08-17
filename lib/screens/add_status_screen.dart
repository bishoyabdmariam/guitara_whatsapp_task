import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guitara_whatsapp_task/cubits/story_cubit.dart';
import 'package:guitara_whatsapp_task/models/story.dart';
import 'package:guitara_whatsapp_task/theme/app_theme.dart';

class AddStatusScreen extends StatefulWidget {
  const AddStatusScreen({super.key});

  @override
  State<AddStatusScreen> createState() => _AddStatusScreenState();
}

class _AddStatusScreenState extends State<AddStatusScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isTextMode = true;
  String _selectedText = '';
  Color _selectedColor = Colors.purple;

  final List<Color> _colorOptions = [
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.pink,
    Colors.indigo,
    Colors.teal,
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addTextStatus() {
    if (_textController.text.trim().isNotEmpty) {
      final newStory = Story(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: '1', // My user ID
        userName: 'My Status',
        userAvatar: 'https://i.pravatar.cc/150?img=10',
        content: _textController.text.trim(),
        timestamp: DateTime.now(),
        type: StoryType.text,
        isMyStory: true,
      );

      context.read<StoryCubit>().addStory(newStory);
      Navigator.of(context).pop();
    }
  }

  void _addImageStatus() {
    // For demo purposes, we'll add a placeholder image
    final newStory = Story(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: '1', // My user ID
      userName: 'My Status',
      userAvatar: 'https://i.pravatar.cc/150?img=10',
      content: 'https://picsum.photos/400/600?random=${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now(),
      type: StoryType.image,
      isMyStory: true,
    );

    context.read<StoryCubit>().addStory(newStory);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Add Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _isTextMode ? _addTextStatus : _addImageStatus,
          ),
        ],
      ),
      body: Column(
        children: [
          // Mode selector
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isTextMode = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _isTextMode ? AppTheme.primaryGreen : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _isTextMode ? AppTheme.primaryGreen : Colors.grey,
                        ),
                      ),
                      child: Text(
                        'Text',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _isTextMode ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isTextMode = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_isTextMode ? AppTheme.primaryGreen : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: !_isTextMode ? AppTheme.primaryGreen : Colors.grey,
                        ),
                      ),
                      child: Text(
                        'Image',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !_isTextMode ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content area
          Expanded(
            child: _isTextMode ? _buildTextMode() : _buildImageMode(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextMode() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _selectedColor,
            _selectedColor.withValues(alpha: 0.8),
            _selectedColor.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Column(
        children: [
          // Color picker
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: _colorOptions.map((color) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == color ? Colors.white : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Text input
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: TextField(
                controller: _textController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Type your status...',
                  hintStyle: TextStyle(
                    color: Colors.white70,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedText = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageMode() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Add Photo',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap to select a photo from your gallery',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _addImageStatus,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Add Demo Image',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
