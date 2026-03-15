import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'dna_models.g.dart';

class DnaProfile extends Equatable {
  final String userId;
  final ColorPrefs colors;
  final StylePrefs styles;
  final EmotionPrefs emotions;
  final double score;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const DnaProfile({
    required this.userId,
    required this.colors,
    required this.styles,
    required this.emotions,
    required this.score,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory DnaProfile.initial(String userId) {
    final now = DateTime.now();
    return DnaProfile(
      userId: userId,
      colors: ColorPrefs.initial(),
      styles: StylePrefs.initial(),
      emotions: EmotionPrefs.initial(),
      score: 0.0,
      createdAt: now,
      updatedAt: now,
    );
  }
  
  @override
  List<Object?> get props => [userId, colors, styles, emotions, score, createdAt, updatedAt];
}

@HiveType(typeId: 1)
class ColorPrefs extends Equatable {
  @HiveField(0)
  final List<String> favorites;
  
  @HiveField(1)
  final List<String> avoided;
  
  @HiveField(2)
  final String dominant;
  
  const ColorPrefs({
    required this.favorites,
    required this.avoided,
    required this.dominant,
  });
  
  factory ColorPrefs.initial() => const ColorPrefs(favorites: [], avoided: [], dominant: 'neutral');
  
  Map<String, dynamic> toJson() => {'favorites': favorites, 'avoided': avoided, 'dominant': dominant};
  factory ColorPrefs.fromJson(Map<String, dynamic> json) => ColorPrefs(
    favorites: List<String>.from(json['favorites'] ?? []),
    avoided: List<String>.from(json['avoided'] ?? []),
    dominant: json['dominant'] ?? 'neutral',
  );
  
  @override
  List<Object?> get props => [favorites, avoided, dominant];
}

@HiveType(typeId: 2)
class StylePrefs extends Equatable {
  @HiveField(0)
  final Map<String, double> scores;
  
  @HiveField(1)
  final List<String> top;
  
  @HiveField(2)
  final String dominant;
  
  const StylePrefs({required this.scores, required this.top, required this.dominant});
  
  factory StylePrefs.initial() => const StylePrefs(
    scores: {'realistic': 0.5, 'abstract': 0.5, 'surreal': 0.5},
    top: ['realistic'],
    dominant: 'realistic',
  );
  
  Map<String, dynamic> toJson() => {'scores': scores, 'top': top, 'dominant': dominant};
  factory StylePrefs.fromJson(Map<String, dynamic> json) => StylePrefs(
    scores: Map<String, double>.from(json['scores'] ?? {}),
    top: List<String>.from(json['top'] ?? []),
    dominant: json['dominant'] ?? 'realistic',
  );
  
  @override
  List<Object?> get props => [scores, top, dominant];
}

@HiveType(typeId: 3)
class EmotionPrefs extends Equatable {
  @HiveField(0)
  final Map<String, double> frequency;
  
  @HiveField(1)
  final List<String> dominant;
  
  @HiveField(2)
  final DateTime updated;
  
  const EmotionPrefs({required this.frequency, required this.dominant, required this.updated});
  
  factory EmotionPrefs.initial() => EmotionPrefs(
    frequency: {'happy': 0.0, 'sad': 0.0, 'calm': 0.0},
    dominant: [],
    updated: DateTime.now(),
  );
  
  Map<String, dynamic> toJson() => {
    'frequency': frequency,
    'dominant': dominant,
    'updated': updated.toIso8601String(),
  };
  
  factory EmotionPrefs.fromJson(Map<String, dynamic> json) => EmotionPrefs(
    frequency: Map<String, double>.from(json['frequency'] ?? {}),
    dominant: List<String>.from(json['dominant'] ?? []),
    updated: DateTime.parse(json['updated'] ?? DateTime.now().toIso8601String()),
  );
  
  @override
  List<Object?> get props => [frequency, dominant, updated];
}
