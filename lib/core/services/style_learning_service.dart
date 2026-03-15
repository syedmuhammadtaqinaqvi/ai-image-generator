import '../../modules/dna_onboarding/dna_repository.dart';
import '../../modules/dna_onboarding/dna_models.dart';

enum InteractionType { save, regenerate, delete }

class StyleLearningService {
  final DnaRepository _repo;
  
  StyleLearningService(this._repo);
  
  Future<void> recordInteraction(
    String userId,
    String style,
    InteractionType type,
  ) async {
    final result = await _repo.get(userId);
    
    result.fold(
      (error) => null,
      (profile) async {
        final scores = Map<String, double>.from(profile.styles.scores);
        final current = scores[style] ?? 0.5;
        
        switch (type) {
          case InteractionType.save:
            scores[style] = (current + 0.1).clamp(0.0, 1.0);
            break;
          case InteractionType.regenerate:
            scores[style] = (current - 0.05).clamp(0.0, 1.0);
            break;
          case InteractionType.delete:
            scores[style] = (current - 0.15).clamp(0.0, 1.0);
            break;
        }
        
        final sorted = scores.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        
        final updated = StylePrefs(
          scores: scores,
          top: sorted.take(3).map((e) => e.key).toList(),
          dominant: sorted.first.key,
        );
        
        await _repo.updateStyles(userId, updated);
      },
    );
  }
  
  Future<Map<String, double>> calculateAffinity(String userId) async {
    final result = await _repo.get(userId);
    return result.fold(
      (error) => {},
      (profile) => profile.styles.scores,
    );
  }
}
