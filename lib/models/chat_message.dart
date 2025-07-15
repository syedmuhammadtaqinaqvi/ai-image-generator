import 'package:flutter/material.dart';

enum MessageType { user, assistant, image }

class ChatMessage {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final String? imageUrl;
  final bool isLoading;
  final String? error;

  ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.imageUrl,
    this.isLoading = false,
    this.error,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    String? imageUrl,
    bool? isLoading,
    String? error,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      imageUrl: imageUrl ?? this.imageUrl,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ChatSession {
  final List<ChatMessage> messages;
  final String sessionId;
  final DateTime createdAt;

  ChatSession({
    required this.messages,
    required this.sessionId,
    required this.createdAt,
  });

  ChatSession copyWith({
    List<ChatMessage>? messages,
    String? sessionId,
    DateTime? createdAt,
  }) {
    return ChatSession(
      messages: messages ?? this.messages,
      sessionId: sessionId ?? this.sessionId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
