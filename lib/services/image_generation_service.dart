import 'package:http/http.dart' as http;
import '../models/image_options.dart';

class ImageGenerationService {
  // Using Pollinations API - completely free, no API key required
  static const String _baseUrl = 'https://image.pollinations.ai/prompt';
  
  /// Generate an image using the Pollinations API with style and aspect ratio options
  static Future<String> generateImage(
    String prompt, {
    ImageAspectRatio? aspectRatio,
    ImageStyle? style,
  }) async {
    try {
      // Apply default values if not provided
      aspectRatio ??= ImageOptions.aspectRatios[0]; // Default to 1:1
      style ??= ImageOptions.styles[0]; // Default to No Style
      
      // Build the enhanced prompt with style
      String enhancedPrompt = prompt.trim();
      if (style.styleModifier != null && style.styleModifier!.isNotEmpty) {
        enhancedPrompt = '$enhancedPrompt, ${style.styleModifier}';
      }
      
      // Clean and encode the prompt
      final encodedPrompt = Uri.encodeComponent(enhancedPrompt);
      
      // Add parameters for better image quality
      final url = '$_baseUrl/$encodedPrompt'
          '?width=${aspectRatio.width}'
          '&height=${aspectRatio.height}'
          '&seed=${DateTime.now().millisecondsSinceEpoch}' // Random seed for variety
          '&model=${style.modelName ?? 'flux'}'; // Use specified model
      
      // Make the request
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'AI Image Generator App',
        },
      ).timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        // The API returns the image directly, so we return the URL
        return url;
      } else {
        throw Exception('Failed to generate image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error generating image: $e');
    }
  }
  
  /// Alternative: Generate image using a different free API (backup)
  static Future<String> generateImageBackup(String prompt) async {
    try {
      // Using DummyJSON for placeholder images with text
      final encodedPrompt = Uri.encodeComponent(prompt.trim());
      final url = 'https://dummyjson.com/image/400x400?text=$encodedPrompt&fontSize=16';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        return url;
      } else {
        throw Exception('Backup API failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Backup API error: $e');
    }
  }
}
