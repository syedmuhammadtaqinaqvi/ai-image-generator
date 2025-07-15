import 'package:flutter/material.dart';
import 'services/image_generation_service.dart';
import 'models/image_options.dart';
import 'models/chat_message.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_input.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Image Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const ChatImageGeneratorPage(),
    );
  }
}

class ChatImageGeneratorPage extends StatefulWidget {
  const ChatImageGeneratorPage({super.key});

  @override
  State<ChatImageGeneratorPage> createState() => _ChatImageGeneratorPageState();
}

class _ChatImageGeneratorPageState extends State<ChatImageGeneratorPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  
  // Image generation options
  ImageAspectRatio _selectedAspectRatio = ImageOptions.aspectRatios[0];
  ImageStyle _selectedStyle = ImageOptions.styles[0];

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: 'Hi! I\'m your AI image generator assistant. Describe any image you want me to create, and I\'ll generate it for you with various styles and aspect ratios! 🎨',
      type: MessageType.assistant,
      timestamp: DateTime.now(),
    );
    
    setState(() {
      _messages.add(welcomeMessage);
    });
  }

  void _handleSendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _messageController.text.trim(),
      type: MessageType.user,
      timestamp: DateTime.now(),
    );
    
    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });
    
    _messageController.clear();
    _scrollToBottom();
    
    _generateImage(userMessage.content);
  }

  Future<void> _generateImage(String prompt) async {
    // Add loading image message
    final loadingMessage = ChatMessage(
      id: '${DateTime.now().millisecondsSinceEpoch}_loading',
      content: 'Generating: $prompt',
      type: MessageType.image,
      timestamp: DateTime.now(),
      isLoading: true,
    );
    
    setState(() {
      _messages.add(loadingMessage);
    });
    
    _scrollToBottom();
    
    try {
      // Use the real API service with selected options
      final imageUrl = await ImageGenerationService.generateImage(
        prompt,
        aspectRatio: _selectedAspectRatio,
        style: _selectedStyle,
      );
      
      // Replace loading message with successful image
      final successMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Generated: $prompt',
        type: MessageType.image,
        timestamp: DateTime.now(),
        imageUrl: imageUrl,
      );
      
      setState(() {
        _messages.removeLast(); // Remove loading message
        _messages.add(successMessage);
        _isLoading = false;
      });
      
    } catch (error) {
      // Try backup API
      try {
        final backupImageUrl = await ImageGenerationService.generateImageBackup(prompt);
        
        final successMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: 'Generated: $prompt (backup service)',
          type: MessageType.image,
          timestamp: DateTime.now(),
          imageUrl: backupImageUrl,
        );
        
        setState(() {
          _messages.removeLast(); // Remove loading message
          _messages.add(successMessage);
          _isLoading = false;
        });
        
      } catch (backupError) {
        // Replace loading message with error message
        final errorMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: 'Failed to generate: $prompt',
          type: MessageType.image,
          timestamp: DateTime.now(),
          error: 'Failed to generate image. Please check your internet connection and try again.',
        );
        
        setState(() {
          _messages.removeLast(); // Remove loading message
          _messages.add(errorMessage);
          _isLoading = false;
        });
      }
    }
    
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _retryImageGeneration(String prompt) {
    _generateImage(prompt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎨 AI Image Generator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(
                  message: message,
                  onRetry: message.type == MessageType.image && message.error != null
                      ? () => _retryImageGeneration(message.content.replaceFirst('Failed to generate: ', ''))
                      : null,
                );
              },
            ),
          ),
          // Chat input
          ChatInput(
            controller: _messageController,
            onSend: _handleSendMessage,
            isLoading: _isLoading,
            selectedAspectRatio: _selectedAspectRatio,
            selectedStyle: _selectedStyle,
            onAspectRatioChanged: (aspectRatio) {
              setState(() {
                _selectedAspectRatio = aspectRatio;
              });
            },
            onStyleChanged: (style) {
              setState(() {
                _selectedStyle = style;
              });
            },
          ),
        ],
      ),
    );
  }
}

