import 'package:flutter_bloc/flutter_bloc.dart';
import '../dna_onboarding/dna_repository.dart';
import '../dna_onboarding/dna_models.dart';
import '../../core/services/style_learning_service.dart';
import 'emotion_state.dart';
import 'emotion_service.dart';
import 'emotion_models.dart';

class EmotionToImageCubit extends Cubit<EmotionToImageState> {
  final EmotionService _emotionSvc;
  final ImageService _imageSvc;
  final DnaRepository _dnaRepo;
  final StyleLearningService _styleSvc;
  final List<GenerationResult> _history = [];
  
  EmotionToImageCubit(this._emotionSvc, this._imageSvc, this._dnaRepo, this._styleSvc) 
      : super(const EmotionToImageInitial());
  
  Future<void> generate(String userId, String emotionText) async {
    emit(const EmotionToImageGenerating());
    
    try {
      final dnaResult = await _dnaRepo.get(userId);
      final dna = dnaResult.fold((error) => DnaProfile.initial(userId), (profile) => profile);
      
      await _emotionSvc.analyze(emotionText);
      final enhancedPrompt = _enhancePrompt(emotionText, dna);
      final imageUrl = await _imageSvc.generate(enhancedPrompt);
      
      final result = GenerationResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        imageUrl: imageUrl,
        prompt: emotionText,
        enhancedPrompt: enhancedPrompt,
        createdAt: DateTime.now(),
      );
      
      _history.insert(0, result);
      emit(EmotionToImageSuccess(result, history: List.from(_history)));
    } catch (e) {
      emit(EmotionToImageError(e.toString(), lastPrompt: emotionText));
    }
  }
  
  void clearHistory() {
    _history.clear();
    emit(const EmotionToImageInitial());
  }
  
  Future<void> saveGeneration(String userId, String style) async {
    await _styleSvc.recordInteraction(userId, style, InteractionType.save);
  }
  
  Future<void> regenerate(String userId, String emotionText, String style) async {
    await _styleSvc.recordInteraction(userId, style, InteractionType.regenerate);
    await generate(userId, emotionText);
  }
  
  Future<void> deleteGeneration(String userId, String generationId, String style) async {
    await _styleSvc.recordInteraction(userId, style, InteractionType.delete);
    _history.removeWhere((item) => item.id == generationId);
    
    if (_history.isEmpty) {
      emit(const EmotionToImageInitial());
    } else {
      emit(EmotionToImageSuccess(_history.first, history: List.from(_history)));
    }
  }
  
  String _enhancePrompt(String base, DnaProfile dna) {
    final parts = <String>[base];
    
    if (dna.colors.favorites.isNotEmpty) {
      parts.add('with ${dna.colors.favorites.take(2).join(", ")} tones');
    }
    
    if (dna.styles.top.isNotEmpty) {
      parts.add('in ${dna.styles.top.first} style');
    }
    
    return parts.join(', ');
  }
}
