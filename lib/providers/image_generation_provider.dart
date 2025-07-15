import 'package:flutter/foundation.dart';

class ImageGenerationProvider with ChangeNotifier {
  String? _generatedImageUrl;
  bool _isLoading = false;
  String? _errorMessage;

  String? get generatedImageUrl => _generatedImageUrl;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> generateImage(String prompt) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // This is a placeholder for your image generation API call
      // Replace with your actual API endpoint and implementation
      await Future.delayed(Duration(seconds: 2)); // Simulating API call
      
      // For demonstration, we'll use a placeholder image
      _generatedImageUrl = 'https://via.placeholder.com/512x512?text=Generated+Image';
      
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Failed to generate image: $error';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearImage() {
    _generatedImageUrl = null;
    _errorMessage = null;
    notifyListeners();
  }
}
