import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'dna_models.dart';

class DnaRepository {
  static const _box = 'dna_profiles';
  
  Future<Either<String, DnaProfile>> get(String userId) async {
    try {
      final box = await Hive.openBox<Map>(_box);
      final data = box.get(userId);
      
      if (data == null) {
        final profile = DnaProfile.initial(userId);
        await box.put(userId, _toMap(profile));
        return Right(profile);
      }
      
      return Right(_fromMap(data));
    } catch (e) {
      return Left('Failed to load DNA profile: $e');
    }
  }
  
  Future<Either<String, void>> updateColors(String userId, ColorPrefs prefs) async {
    try {
      final result = await get(userId);
      return result.fold(
        (error) => Left(error),
        (profile) async {
          final updated = DnaProfile(
            userId: profile.userId,
            colors: prefs,
            styles: profile.styles,
            emotions: profile.emotions,
            score: _calcScore(prefs, profile.styles, profile.emotions),
            createdAt: profile.createdAt,
            updatedAt: DateTime.now(),
          );
          final box = await Hive.openBox<Map>(_box);
          await box.put(userId, _toMap(updated));
          return const Right(null);
        },
      );
    } catch (e) {
      return Left('Failed to update colors: $e');
    }
  }
  
  Future<Either<String, void>> updateStyles(String userId, StylePrefs prefs) async {
    try {
      final result = await get(userId);
      return result.fold(
        (error) => Left(error),
        (profile) async {
          final updated = DnaProfile(
            userId: profile.userId,
            colors: profile.colors,
            styles: prefs,
            emotions: profile.emotions,
            score: _calcScore(profile.colors, prefs, profile.emotions),
            createdAt: profile.createdAt,
            updatedAt: DateTime.now(),
          );
          final box = await Hive.openBox<Map>(_box);
          await box.put(userId, _toMap(updated));
          return const Right(null);
        },
      );
    } catch (e) {
      return Left('Failed to update styles: $e');
    }
  }
  
  Future<Either<String, void>> updateEmotions(String userId, EmotionPrefs prefs) async {
    try {
      final result = await get(userId);
      return result.fold(
        (error) => Left(error),
        (profile) async {
          final updated = DnaProfile(
            userId: profile.userId,
            colors: profile.colors,
            styles: profile.styles,
            emotions: prefs,
            score: _calcScore(profile.colors, profile.styles, prefs),
            createdAt: profile.createdAt,
            updatedAt: DateTime.now(),
          );
          final box = await Hive.openBox<Map>(_box);
          await box.put(userId, _toMap(updated));
          return const Right(null);
        },
      );
    } catch (e) {
      return Left('Failed to update emotions: $e');
    }
  }
  
  double _calcScore(ColorPrefs c, StylePrefs s, EmotionPrefs e) {
    double score = 0.0;
    if (c.favorites.isNotEmpty) score += 0.3;
    if (s.top.isNotEmpty) score += 0.3;
    if (e.dominant.isNotEmpty) score += 0.4;
    return score;
  }
  
  Map<String, dynamic> _toMap(DnaProfile p) => {
    'userId': p.userId,
    'colors': p.colors.toJson(),
    'styles': p.styles.toJson(),
    'emotions': p.emotions.toJson(),
    'score': p.score,
    'createdAt': p.createdAt.toIso8601String(),
    'updatedAt': p.updatedAt.toIso8601String(),
  };
  
  DnaProfile _fromMap(Map data) => DnaProfile(
    userId: data['userId'],
    colors: ColorPrefs.fromJson(Map<String, dynamic>.from(data['colors'])),
    styles: StylePrefs.fromJson(Map<String, dynamic>.from(data['styles'])),
    emotions: EmotionPrefs.fromJson(Map<String, dynamic>.from(data['emotions'])),
    score: data['score'],
    createdAt: DateTime.parse(data['createdAt']),
    updatedAt: DateTime.parse(data['updatedAt']),
  );
}
