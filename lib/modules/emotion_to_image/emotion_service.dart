import 'package:http/http.dart' as http;
import 'emotion_models.dart';

class EmotionService {
  EmotionService(http.Client client);
  
  Future<EmotionData> analyze(String text) async {
    final emotions = <String, double>{};
    final keywords = {
      'happy': ['happy', 'joy', 'cheerful'],
      'sad': ['sad', 'unhappy', 'depressed'],
      'excited': ['excited', 'thrilled'],
      'calm': ['calm', 'peaceful', 'serene'],
    };
    
    for (final entry in keywords.entries) {
      double score = 0.0;
      for (final word in entry.value) {
        if (text.toLowerCase().contains(word)) score += 0.3;
      }
      if (score > 0) emotions[entry.key] = score.clamp(0.0, 1.0);
    }
    
    final primary = emotions.isEmpty ? 'neutral' : emotions.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    return EmotionData(primary: primary, scores: emotions);
  }
}

class ImageService {
  final http.Client _client;
  static const _url = 'https://image.pollinations.ai/prompt';
  
  ImageService(this._client);
  
  Future<String> generate(String prompt) async {
    try {
      final encoded = Uri.encodeComponent(prompt);
      final seed = DateTime.now().millisecondsSinceEpoch;
      final url = '$_url/$encoded?width=512&height=512&seed=$seed&model=flux';
      
      final res = await _client.get(Uri.parse(url)).timeout(const Duration(seconds: 30));
      if (res.statusCode == 200) return url;
      throw Exception('API failed: ${res.statusCode}');
    } catch (e) {
      final fallback = 'https://dummyjson.com/image/400x400?text=${Uri.encodeComponent(prompt)}';
      return fallback;
    }
  }
}
