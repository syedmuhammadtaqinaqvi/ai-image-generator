import 'package:equatable/equatable.dart';
import 'emotion_models.dart';

abstract class EmotionToImageState extends Equatable {
  const EmotionToImageState();
  @override
  List<Object?> get props => [];
}

class EmotionToImageInitial extends EmotionToImageState {
  const EmotionToImageInitial();
}

class EmotionToImageGenerating extends EmotionToImageState {
  const EmotionToImageGenerating();
}

class EmotionToImageSuccess extends EmotionToImageState {
  final GenerationResult result;
  final List<GenerationResult> history;
  const EmotionToImageSuccess(this.result, {this.history = const []});
  @override
  List<Object?> get props => [result, history];
}

class EmotionToImageError extends EmotionToImageState {
  final String message;
  final String? lastPrompt;
  const EmotionToImageError(this.message, {this.lastPrompt});
  @override
  List<Object?> get props => [message, lastPrompt];
}
