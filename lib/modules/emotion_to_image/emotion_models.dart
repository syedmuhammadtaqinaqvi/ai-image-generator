import 'package:equatable/equatable.dart';

class GenerationResult extends Equatable {
  final String id;
  final String userId;
  final String imageUrl;
  final String prompt;
  final String enhancedPrompt;
  final DateTime createdAt;
  
  const GenerationResult({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.prompt,
    required this.enhancedPrompt,
    required this.createdAt,
  });
  
  @override
  List<Object?> get props => [id, userId, imageUrl, prompt, enhancedPrompt, createdAt];
}

class EmotionData extends Equatable {
  final String primary;
  final Map<String, double> scores;
  
  const EmotionData({required this.primary, required this.scores});
  
  @override
  List<Object?> get props => [primary, scores];
}
