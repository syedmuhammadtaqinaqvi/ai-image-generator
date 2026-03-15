class AppConstants {
  // App info
  static const String appName = 'AURA';
  static const String appTagline = 'Your Aura, Visualized';
  static const String appVersion = '1.0.0';
  
  // API endpoints
  static const String pollinationsBaseUrl = 'https://image.pollinations.ai/prompt';
  static const String dummyJsonBaseUrl = 'https://dummyjson.com/image';
  
  // Generation limits
  static const int freeGenerationsPerDay = 5;
  static const int proGenerationsPerDay = -1; // Unlimited
  
  // DNA profile defaults
  static const int minPhotosForOnboarding = 5;
  static const int maxPhotosForOnboarding = 20;
  static const int preferenceQuizQuestions = 20;
  
  // Accuracy thresholds
  static const double minAccuracyThreshold = 0.9;
  static const double minPersonalizationScore = 0.5;
  
  // API retry configuration
  static const int maxRetries = 3;
  static const Duration initialRetryDelay = Duration(seconds: 1);
  static const Duration maxRetryDelay = Duration(seconds: 10);
  
  // Cache configuration
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCachedGenerations = 100;
  
  // Image configuration
  static const int maxImageSizeBytes = 10 * 1024 * 1024; // 10MB
  static const double imageCompressionQuality = 0.8;
  
  // Session configuration
  static const Duration userSessionTimeout = Duration(hours: 24);
  static const Duration adminSessionTimeout = Duration(hours: 8);
}
