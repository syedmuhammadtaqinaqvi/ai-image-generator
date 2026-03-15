# Design Document: AURA Visual DNA Architecture Restructure

## Overview

### Purpose

This design document outlines the comprehensive architectural restructure of AURA (Your Aura, Visualized), transforming a basic Flutter image generation app into a production-grade Visual DNA platform. The restructure implements clean architecture principles, BLoC/Cubit state management, Firebase integration, and a scalable feature-based folder structure.

### Vision

AURA is a personal AI art generation platform that learns from each user's memories, emotions, and aesthetic preferences to generate completely personalized artwork. The Visual DNA engine captures and evolves user preferences over time, creating a unique artistic fingerprint that makes every generated image deeply personal.

### Design Philosophy

1. **Hero Product First**: Build core features perfectly before adding complexity
2. **Free APIs Only**: Use Pollinations.ai, Transformers.js, and client-side processing
3. **Clean Architecture**: Feature-based modules with clear layer separation
4. **BLoC/Cubit Only**: Consistent state management across all features
5. **Quality Gates**: 90% accuracy threshold for all AI-powered features
6. **Phased Implementation**: Systematic development with user collaboration

### Key Architectural Decisions

- **State Management**: BLoC/Cubit pattern exclusively (no Provider, Riverpod, or setState)
- **Dependency Injection**: get_it service locator for loose coupling
- **Routing**: go_router for declarative navigation and deep linking
- **Backend**: Firebase Cloud Functions with Admin SDK for security
- **Testing**: Dual approach with unit tests and property-based tests
- **Code Quality**: Maximum 1000 lines per file, single responsibility principle

## Architecture

### Clean Architecture Layers

The application follows clean architecture with three distinct layers:

#### 1. Presentation Layer
- **Responsibility**: UI components, BLoCs/Cubits, and user interaction
- **Dependencies**: Domain layer only
- **Components**: Screens, widgets, BLoCs, Cubits, UI state models
- **Rules**: No direct access to data sources or external frameworks

#### 2. Domain Layer
- **Responsibility**: Business logic, entities, and use cases
- **Dependencies**: None (pure Dart)
- **Components**: Entities, repositories (interfaces), use cases, business rules
- **Rules**: Framework-agnostic, testable in isolation

#### 3. Data Layer
- **Responsibility**: Data persistence, API integration, external services
- **Dependencies**: Domain layer (implements interfaces)
- **Components**: Repository implementations, data sources, API clients, DTOs
- **Rules**: Abstracts external dependencies from business logic

### Feature-Based Module Structure

Each feature is self-contained with all three architecture layers:

```
lib/
├── core/                           # Shared utilities and services
│   ├── di/                         # Dependency injection setup
│   │   └── injection.dart
│   ├── error/                      # Error handling
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   ├── network/                    # Network utilities
│   │   ├── api_client.dart
│   │   └── network_info.dart
│   ├── theme/                      # Design system
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   └── app_theme.dart
│   ├── utils/                      # Shared utilities
│   │   ├── constants.dart
│   │   ├── validators.dart
│   │   └── extensions.dart
│   └── widgets/                    # Shared UI components
│       ├── loading_indicator.dart
│       ├── error_display.dart
│       ├── custom_button.dart
│       └── custom_card.dart
│
├── features/                       # Feature modules
│   ├── authentication/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── sign_in_with_google.dart
│   │   │       ├── sign_in_with_email.dart
│   │   │       └── sign_out.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── screens/
│   │       │   ├── login_screen.dart
│   │       │   └── signup_screen.dart
│   │       └── widgets/
│   │           ├── social_login_button.dart
│   │           └── auth_form.dart
│   │
│   ├── visual_dna_engine/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── dna_local_datasource.dart
│   │   │   │   └── dna_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── dna_profile_model.dart
│   │   │   │   ├── color_preferences_model.dart
│   │   │   │   ├── style_affinity_model.dart
│   │   │   │   └── emotional_signature_model.dart
│   │   │   └── repositories/
│   │   │       └── dna_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── dna_profile.dart
│   │   │   │   ├── color_preferences.dart
│   │   │   │   ├── style_affinity.dart
│   │   │   │   └── emotional_signature.dart
│   │   │   ├── repositories/
│   │   │   │   └── dna_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_dna_profile.dart
│   │   │       ├── update_dna_profile.dart
│   │   │       └── calculate_personalization_score.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── dna_profile_cubit.dart
│   │       │   └── dna_profile_state.dart
│   │       ├── screens/
│   │       │   ├── dna_onboarding_screen.dart
│   │       │   └── dna_profile_screen.dart
│   │       └── widgets/
│   │           ├── color_preference_selector.dart
│   │           ├── style_preference_selector.dart
│   │           └── dna_visualization.dart
│   │
│   ├── emotion_to_image/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── image_generation_datasource.dart
│   │   │   │   └── emotion_analysis_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── generation_request_model.dart
│   │   │   │   └── generation_result_model.dart
│   │   │   └── repositories/
│   │   │       └── generation_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── generation_request.dart
│   │   │   │   ├── generation_result.dart
│   │   │   │   └── emotion_data.dart
│   │   │   ├── repositories/
│   │   │   │   └── generation_repository.dart
│   │   │   └── usecases/
│   │   │       ├── generate_from_emotion.dart
│   │   │       ├── analyze_emotion.dart
│   │   │       └── inject_dna_into_prompt.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── emotion_to_image_bloc.dart
│   │       │   ├── emotion_to_image_event.dart
│   │       │   └── emotion_to_image_state.dart
│   │       ├── screens/
│   │       │   └── emotion_to_image_screen.dart
│   │       └── widgets/
│   │           ├── emotion_input.dart
│   │           ├── generation_preview.dart
│   │           └── generation_history.dart
│   │
│   ├── memory_transformer/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── image_upload_datasource.dart
│   │   │   │   └── transformation_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── memory_model.dart
│   │   │   │   └── transformation_model.dart
│   │   │   └── repositories/
│   │   │       └── memory_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── memory.dart
│   │   │   │   └── transformation.dart
│   │   │   ├── repositories/
│   │   │   │   └── memory_repository.dart
│   │   │   └── usecases/
│   │   │       ├── upload_memory.dart
│   │   │       ├── transform_memory.dart
│   │   │       └── analyze_image_composition.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── memory_transformer_bloc.dart
│   │       │   ├── memory_transformer_event.dart
│   │       │   └── memory_transformer_state.dart
│   │       ├── screens/
│   │       │   └── memory_transformer_screen.dart
│   │       └── widgets/
│   │           ├── image_picker_widget.dart
│   │           ├── style_selector.dart
│   │           └── transformation_result.dart
│   │
│   ├── dream_studio/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── dream_local_datasource.dart
│   │   │   │   ├── dream_remote_datasource.dart
│   │   │   │   └── voice_recognition_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── dream_entry_model.dart
│   │   │   └── repositories/
│   │   │       └── dream_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── dream_entry.dart
│   │   │   ├── repositories/
│   │   │   │   └── dream_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_dream_entry.dart
│   │   │       ├── visualize_dream.dart
│   │   │       └── transcribe_voice.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── dream_studio_bloc.dart
│   │       │   ├── dream_studio_event.dart
│   │       │   └── dream_studio_state.dart
│   │       ├── screens/
│   │       │   ├── dream_studio_screen.dart
│   │       │   └── dream_library_screen.dart
│   │       └── widgets/
│   │           ├── voice_input_button.dart
│   │           ├── dream_description_input.dart
│   │           └── dream_card.dart
│   │
│   ├── living_art/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── evolution_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── evolution_report_model.dart
│   │   │   └── repositories/
│   │   │       └── evolution_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── evolution_report.dart
│   │   │   ├── repositories/
│   │   │   │   └── evolution_repository.dart
│   │   │   └── usecases/
│   │   │       ├── calculate_style_evolution.dart
│   │   │       └── generate_evolution_report.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── living_art_cubit.dart
│   │       │   └── living_art_state.dart
│   │       ├── screens/
│   │       │   └── evolution_report_screen.dart
│   │       └── widgets/
│   │           └── evolution_chart.dart
│   │
│   └── collaborative_universe/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── collaboration_datasource.dart
│       │   ├── models/
│       │   │   ├── collaboration_model.dart
│       │   │   └── merged_dna_model.dart
│       │   └── repositories/
│       │       └── collaboration_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── collaboration.dart
│       │   │   └── merged_dna.dart
│       │   ├── repositories/
│       │   │   └── collaboration_repository.dart
│       │   └── usecases/
│       │       ├── send_collaboration_invite.dart
│       │       ├── accept_collaboration.dart
│       │       └── merge_dna_profiles.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── collaborative_universe_bloc.dart
│           │   ├── collaborative_universe_event.dart
│           │   └── collaborative_universe_state.dart
│           ├── screens/
│           │   └── collaborative_universe_screen.dart
│           └── widgets/
│               ├── collaboration_invite.dart
│               └── merged_artwork_display.dart
│
└── main.dart                       # App entry point
```

### Backend Architecture

The backend uses Firebase Cloud Functions with Admin SDK to ensure security:

```
functions/
├── src/
│   ├── api/
│   │   ├── auth/
│   │   │   ├── login.ts
│   │   │   ├── register.ts
│   │   │   └── refresh-token.ts
│   │   ├── dna/
│   │   │   ├── get-profile.ts
│   │   │   ├── update-profile.ts
│   │   │   └── calculate-score.ts
│   │   ├── generation/
│   │   │   ├── generate-image.ts
│   │   │   ├── get-history.ts
│   │   │   └── save-generation.ts
│   │   ├── storage/
│   │   │   ├── upload-image.ts
│   │   │   └── get-signed-url.ts
│   │   └── admin/
│   │       ├── user-management.ts
│   │       ├── content-moderation.ts
│   │       └── analytics.ts
│   ├── middleware/
│   │   ├── auth.ts
│   │   ├── rate-limiter.ts
│   │   └── validator.ts
│   ├── services/
│   │   ├── firebase-admin.ts
│   │   ├── dna-service.ts
│   │   └── generation-service.ts
│   └── utils/
│       ├── errors.ts
│       └── logger.ts
├── package.json
└── tsconfig.json
```

## Components and Interfaces

### Core Entities

#### User Entity
```dart
class User {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final UserRole role;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  
  User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.role,
    required this.createdAt,
    this.lastLoginAt,
  });
}

enum UserRole {
  regular,
  pro,
  moderator,
  admin,
  superAdmin,
}
```

#### DNA Profile Entity
```dart
class DnaProfile {
  final String userId;
  final ColorPreferences colorPreferences;
  final StyleAffinity styleAffinity;
  final EmotionalSignature emotionalSignature;
  final double personalizationScore;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  DnaProfile({
    required this.userId,
    required this.colorPreferences,
    required this.styleAffinity,
    required this.emotionalSignature,
    required this.personalizationScore,
    required this.createdAt,
    required this.updatedAt,
  });
}
```

#### Color Preferences Entity
```dart
class ColorPreferences {
  final List<String> favoriteColors;      // Hex color codes
  final List<String> avoidedColors;       // Hex color codes
  final Map<String, double> colorAffinityScores;  // Color -> affinity (0-1)
  final String dominantColorFamily;       // warm, cool, neutral, vibrant
  
  ColorPreferences({
    required this.favoriteColors,
    required this.avoidedColors,
    required this.colorAffinityScores,
    required this.dominantColorFamily,
  });
}
```

#### Style Affinity Entity
```dart
class StyleAffinity {
  final Map<String, double> styleScores;  // Style name -> score (0-1)
  final List<String> topStyles;           // Top 3 preferred styles
  final String dominantStyle;
  final Map<String, int> styleInteractionCount;
  
  StyleAffinity({
    required this.styleScores,
    required this.topStyles,
    required this.dominantStyle,
    required this.styleInteractionCount,
  });
}
```

#### Emotional Signature Entity
```dart
class EmotionalSignature {
  final Map<String, double> emotionFrequency;  // Emotion -> frequency (0-1)
  final List<String> dominantEmotions;         // Top 3 emotions
  final Map<String, List<String>> emotionColorMapping;  // Emotion -> colors
  final DateTime lastUpdated;
  
  EmotionalSignature({
    required this.emotionFrequency,
    required this.dominantEmotions,
    required this.emotionColorMapping,
    required this.lastUpdated,
  });
}
```

#### Generation Request Entity
```dart
class GenerationRequest {
  final String userId;
  final String prompt;
  final String? emotionInput;
  final DnaProfile dnaProfile;
  final ImageAspectRatio aspectRatio;
  final ImageStyle style;
  final DateTime timestamp;
  
  GenerationRequest({
    required this.userId,
    required this.prompt,
    this.emotionInput,
    required this.dnaProfile,
    required this.aspectRatio,
    required this.style,
    required this.timestamp,
  });
}
```

#### Generation Result Entity
```dart
class GenerationResult {
  final String id;
  final String userId;
  final String imageUrl;
  final String prompt;
  final String enhancedPrompt;
  final GenerationMetadata metadata;
  final DateTime createdAt;
  
  GenerationResult({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.prompt,
    required this.enhancedPrompt,
    required this.metadata,
    required this.createdAt,
  });
}

class GenerationMetadata {
  final String apiUsed;
  final int retryCount;
  final Duration generationTime;
  final Map<String, dynamic> dnaInfluence;
  
  GenerationMetadata({
    required this.apiUsed,
    required this.retryCount,
    required this.generationTime,
    required this.dnaInfluence,
  });
}
```

### Repository Interfaces

#### Authentication Repository
```dart
abstract class AuthRepository {
  Future<User> signInWithGoogle();
  Future<User> signInWithApple();
  Future<User> signInWithEmail(String email, String password);
  Future<User> signUpWithEmail(String email, String password);
  Future<void> signOut();
  Future<User?> getCurrentUser();
  Stream<User?> get authStateChanges;
}
```

#### DNA Profile Repository
```dart
abstract class DnaRepository {
  Future<DnaProfile> getDnaProfile(String userId);
  Future<void> updateDnaProfile(DnaProfile profile);
  Future<void> updateColorPreferences(String userId, ColorPreferences prefs);
  Future<void> updateStyleAffinity(String userId, StyleAffinity affinity);
  Future<void> updateEmotionalSignature(String userId, EmotionalSignature signature);
  Future<double> calculatePersonalizationScore(String userId);
  Stream<DnaProfile> watchDnaProfile(String userId);
}
```

#### Generation Repository
```dart
abstract class GenerationRepository {
  Future<GenerationResult> generateImage(GenerationRequest request);
  Future<List<GenerationResult>> getGenerationHistory(String userId, {int limit = 20});
  Future<void> saveGeneration(GenerationResult result);
  Future<void> deleteGeneration(String generationId);
  Stream<List<GenerationResult>> watchGenerationHistory(String userId);
}
```

#### Memory Repository
```dart
abstract class MemoryRepository {
  Future<String> uploadMemory(String userId, File imageFile);
  Future<GenerationResult> transformMemory(String memoryId, String style, DnaProfile dna);
  Future<List<Memory>> getMemories(String userId);
  Future<void> deleteMemory(String memoryId);
}
```

#### Dream Repository
```dart
abstract class DreamRepository {
  Future<DreamEntry> createDreamEntry(String userId, String description);
  Future<GenerationResult> visualizeDream(String dreamId, DnaProfile dna);
  Future<List<DreamEntry>> getDreamLibrary(String userId);
  Future<void> deleteDreamEntry(String dreamId);
  Stream<List<DreamEntry>> watchDreamLibrary(String userId);
}
```

### Service Layer

#### DNA Injection Service
```dart
class DnaInjectionService {
  String injectDnaIntoPrompt(String basePrompt, DnaProfile dna) {
    // Enhances prompt with DNA preferences
    // Returns: enhanced prompt with color, style, and emotion modifiers
  }
  
  Map<String, dynamic> calculateDnaInfluence(DnaProfile dna, String prompt) {
    // Calculates how DNA influenced the generation
    // Returns: influence metrics for analytics
  }
}
```

#### Emotion Analysis Service
```dart
class EmotionAnalysisService {
  Future<EmotionData> analyzeText(String text) {
    // Uses Transformers.js for client-side emotion analysis
    // Returns: detected emotions with confidence scores
  }
  
  Future<void> updateEmotionalSignature(String userId, EmotionData emotion) {
    // Updates user's emotional signature based on new emotion data
  }
}
```

#### Color Analysis Service
```dart
class ColorAnalysisService {
  Future<List<String>> extractColorPalette(File image) {
    // Uses Vibrant.js for client-side color extraction
    // Returns: dominant colors as hex codes
  }
  
  Future<void> updateColorPreferences(String userId, List<String> colors) {
    // Updates user's color preferences based on extracted colors
  }
}
```

#### Style Learning Service
```dart
class StyleLearningService {
  Future<void> recordStyleInteraction(String userId, String style, bool positive) {
    // Records user interaction with a style (like/dislike)
  }
  
  Future<StyleAffinity> calculateStyleAffinity(String userId) {
    // Calculates updated style affinity based on interaction history
    // Returns: updated StyleAffinity entity
  }
}
```

#### Image Generation Service (Enhanced)
```dart
class ImageGenerationService {
  Future<String> generateImage(
    String prompt, {
    ImageAspectRatio? aspectRatio,
    ImageStyle? style,
    int maxRetries = 3,
  }) {
    // Primary: Pollinations.ai
    // Fallback: DummyJSON
    // Implements circuit breaker and retry logic
  }
  
  Future<bool> checkApiHealth(String apiName) {
    // Checks if API is responding
  }
}
```

#### Fallback Strategy Service
```dart
class FallbackStrategyService {
  final List<ApiProvider> _providers;
  final CircuitBreaker _circuitBreaker;
  
  Future<T> executeWithFallback<T>(
    Future<T> Function(ApiProvider) operation,
  ) {
    // Executes operation with automatic fallback
    // Uses circuit breaker to detect failures
  }
}
```

## Data Models

### Data Transfer Objects (DTOs)

#### User Model
```dart
class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
    required super.role,
    required super.createdAt,
    super.lastLoginAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      role: UserRole.values.byName(json['role'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] != null 
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }
  
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson({...data, 'id': doc.id});
  }
  
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Firestore uses document ID
    return json;
  }
}
```

#### DNA Profile Model
```dart
class DnaProfileModel extends DnaProfile {
  DnaProfileModel({
    required super.userId,
    required super.colorPreferences,
    required super.styleAffinity,
    required super.emotionalSignature,
    required super.personalizationScore,
    required super.createdAt,
    required super.updatedAt,
  });
  
  factory DnaProfileModel.fromJson(Map<String, dynamic> json) {
    return DnaProfileModel(
      userId: json['userId'] as String,
      colorPreferences: ColorPreferencesModel.fromJson(
        json['colorPreferences'] as Map<String, dynamic>,
      ),
      styleAffinity: StyleAffinityModel.fromJson(
        json['styleAffinity'] as Map<String, dynamic>,
      ),
      emotionalSignature: EmotionalSignatureModel.fromJson(
        json['emotionalSignature'] as Map<String, dynamic>,
      ),
      personalizationScore: (json['personalizationScore'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'colorPreferences': (colorPreferences as ColorPreferencesModel).toJson(),
      'styleAffinity': (styleAffinity as StyleAffinityModel).toJson(),
      'emotionalSignature': (emotionalSignature as EmotionalSignatureModel).toJson(),
      'personalizationScore': personalizationScore,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
```

### Local Storage Models

For Phase 1 (offline-first), data is stored locally using Hive:

```dart
@HiveType(typeId: 0)
class DnaProfileHiveModel extends HiveObject {
  @HiveField(0)
  late String userId;
  
  @HiveField(1)
  late Map<String, dynamic> colorPreferences;
  
  @HiveField(2)
  late Map<String, dynamic> styleAffinity;
  
  @HiveField(3)
  late Map<String, dynamic> emotionalSignature;
  
  @HiveField(4)
  late double personalizationScore;
  
  @HiveField(5)
  late DateTime createdAt;
  
  @HiveField(6)
  late DateTime updatedAt;
}
```


## BLoC/Cubit State Management

### Authentication BLoC

#### States
```dart
abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
  
  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  
  @override
  List<Object> get props => [message];
}
```

#### Events
```dart
abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class SignInWithGoogleRequested extends AuthEvent {
  @override
  List<Object> get props => [];
}

class SignInWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  
  const SignInWithEmailRequested(this.email, this.password);
  
  @override
  List<Object> get props => [email, password];
}

class SignOutRequested extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AuthStatusChecked extends AuthEvent {
  @override
  List<Object> get props => [];
}
```


#### BLoC Implementation
```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authStateSubscription;
  
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<SignInWithGoogleRequested>(_onSignInWithGoogle);
    on<SignInWithEmailRequested>(_onSignInWithEmail);
    on<SignOutRequested>(_onSignOut);
    on<AuthStatusChecked>(_onAuthStatusChecked);
    
    _authStateSubscription = _authRepository.authStateChanges.listen(
      (user) {
        if (user != null) {
          add(AuthStatusChecked());
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }
  
  Future<void> _onSignInWithGoogle(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  
  // Additional event handlers...
  
  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
```


### DNA Profile Cubit

#### States
```dart
abstract class DnaProfileState extends Equatable {
  const DnaProfileState();
}

class DnaProfileInitial extends DnaProfileState {
  @override
  List<Object> get props => [];
}

class DnaProfileLoading extends DnaProfileState {
  @override
  List<Object> get props => [];
}

class DnaProfileLoaded extends DnaProfileState {
  final DnaProfile profile;
  const DnaProfileLoaded(this.profile);
  
  @override
  List<Object> get props => [profile];
}

class DnaProfileError extends DnaProfileState {
  final String message;
  const DnaProfileError(this.message);
  
  @override
  List<Object> get props => [message];
}
```

#### Cubit Implementation
```dart
class DnaProfileCubit extends Cubit<DnaProfileState> {
  final DnaRepository _dnaRepository;
  final StyleLearningService _styleLearningService;
  StreamSubscription<DnaProfile>? _dnaSubscription;
  
  DnaProfileCubit({
    required DnaRepository dnaRepository,
    required StyleLearningService styleLearningService,
  })  : _dnaRepository = dnaRepository,
        _styleLearningService = styleLearningService,
        super(DnaProfileInitial());
  
  Future<void> loadDnaProfile(String userId) async {
    emit(DnaProfileLoading());
    try {
      _dnaSubscription?.cancel();
      _dnaSubscription = _dnaRepository.watchDnaProfile(userId).listen(
        (profile) => emit(DnaProfileLoaded(profile)),
        onError: (error) => emit(DnaProfileError(error.toString())),
      );
    } catch (e) {
      emit(DnaProfileError(e.toString()));
    }
  }
  
  Future<void> updateColorPreferences(
    String userId,
    ColorPreferences prefs,
  ) async {
    try {
      await _dnaRepository.updateColorPreferences(userId, prefs);
    } catch (e) {
      emit(DnaProfileError(e.toString()));
    }
  }
  
  @override
  Future<void> close() {
    _dnaSubscription?.cancel();
    return super.close();
  }
}
```


### Emotion to Image BLoC

#### States
```dart
abstract class EmotionToImageState extends Equatable {
  const EmotionToImageState();
}

class EmotionToImageInitial extends EmotionToImageState {
  @override
  List<Object> get props => [];
}

class EmotionToImageGenerating extends EmotionToImageState {
  final String prompt;
  const EmotionToImageGenerating(this.prompt);
  
  @override
  List<Object> get props => [prompt];
}

class EmotionToImageSuccess extends EmotionToImageState {
  final GenerationResult result;
  const EmotionToImageSuccess(this.result);
  
  @override
  List<Object> get props => [result];
}

class EmotionToImageError extends EmotionToImageState {
  final String message;
  final String? prompt;
  const EmotionToImageError(this.message, {this.prompt});
  
  @override
  List<Object?> get props => [message, prompt];
}
```

#### Events
```dart
abstract class EmotionToImageEvent extends Equatable {
  const EmotionToImageEvent();
}

class GenerateFromEmotionRequested extends EmotionToImageEvent {
  final String emotionInput;
  final DnaProfile dnaProfile;
  final ImageAspectRatio aspectRatio;
  final ImageStyle style;
  
  const GenerateFromEmotionRequested({
    required this.emotionInput,
    required this.dnaProfile,
    required this.aspectRatio,
    required this.style,
  });
  
  @override
  List<Object> get props => [emotionInput, dnaProfile, aspectRatio, style];
}

class RetryGenerationRequested extends EmotionToImageEvent {
  final String prompt;
  
  const RetryGenerationRequested(this.prompt);
  
  @override
  List<Object> get props => [prompt];
}
```


## Dependency Injection Setup

### Service Locator Configuration

Using get_it for dependency injection:

```dart
final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  
  sl.registerLazySingleton(() => http.Client());
  
  // Core services
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );
  
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl()),
  );
  
  sl.registerLazySingleton<DnaLocalDataSource>(
    () => DnaLocalDataSourceImpl(sharedPreferences: sl()),
  );
  
  sl.registerLazySingleton<DnaRemoteDataSource>(
    () => DnaRemoteDataSourceImpl(firestore: sl()),
  );
  
  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  
  sl.registerLazySingleton<DnaRepository>(
    () => DnaRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  
  // Services
  sl.registerLazySingleton<ImageGenerationService>(
    () => ImageGenerationService(client: sl()),
  );
  
  sl.registerLazySingleton<DnaInjectionService>(
    () => DnaInjectionService(),
  );
  
  sl.registerLazySingleton<EmotionAnalysisService>(
    () => EmotionAnalysisService(),
  );
  
  // BLoCs and Cubits
  sl.registerFactory(
    () => AuthBloc(authRepository: sl()),
  );
  
  sl.registerFactory(
    () => DnaProfileCubit(
      dnaRepository: sl(),
      styleLearningService: sl(),
    ),
  );
  
  sl.registerFactory(
    () => EmotionToImageBloc(
      generationRepository: sl(),
      emotionAnalysisService: sl(),
      dnaInjectionService: sl(),
    ),
  );
}
```


## Routing Structure

### Route Configuration with go_router

```dart
final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final authState = context.read<AuthBloc>().state;
    final isAuthenticated = authState is AuthAuthenticated;
    final isAuthRoute = state.location.startsWith('/auth');
    
    if (!isAuthenticated && !isAuthRoute) {
      return '/auth/login';
    }
    if (isAuthenticated && isAuthRoute) {
      return '/';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/auth/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/dna/onboarding',
      builder: (context, state) => const DnaOnboardingScreen(),
    ),
    GoRoute(
      path: '/dna/profile',
      builder: (context, state) => const DnaProfileScreen(),
    ),
    GoRoute(
      path: '/emotion-to-image',
      builder: (context, state) => const EmotionToImageScreen(),
    ),
    GoRoute(
      path: '/memory-transformer',
      builder: (context, state) => const MemoryTransformerScreen(),
    ),
    GoRoute(
      path: '/dream-studio',
      builder: (context, state) => const DreamStudioScreen(),
    ),
    GoRoute(
      path: '/dream-library',
      builder: (context, state) => const DreamLibraryScreen(),
    ),
    GoRoute(
      path: '/evolution-report',
      builder: (context, state) => const EvolutionReportScreen(),
    ),
    GoRoute(
      path: '/collaborative-universe',
      builder: (context, state) => const CollaborativeUniverseScreen(),
    ),
  ],
);
```


## API Integration Strategy

### Primary APIs (Free, No API Key)

#### 1. Pollinations.ai
- **Purpose**: Primary image generation
- **Cost**: Completely free, unlimited
- **API Key**: Not required
- **Status**: Already implemented
- **Usage**: Text-to-image, image-to-image transformations

#### 2. DummyJSON
- **Purpose**: Fallback for placeholder images
- **Cost**: Free
- **API Key**: Not required
- **Status**: Already implemented
- **Usage**: Backup when Pollinations.ai fails

### Client-Side Processing (Free)

#### 3. Transformers.js
- **Purpose**: Emotion analysis, text processing
- **Cost**: Free (runs in browser)
- **API Key**: Not required
- **Status**: To be implemented
- **Usage**: Sentiment analysis, emotion detection from text

#### 4. Vibrant.js
- **Purpose**: Color palette extraction
- **Cost**: Free (runs in browser)
- **API Key**: Not required
- **Status**: To be implemented
- **Usage**: Extract dominant colors from uploaded images

#### 5. TensorFlow.js
- **Purpose**: Image composition analysis
- **Cost**: Free (runs in browser)
- **API Key**: Not required
- **Status**: To be implemented
- **Usage**: Analyze image structure and composition

#### 6. Web Speech API
- **Purpose**: Voice-to-text conversion
- **Cost**: Free (built into browsers)
- **API Key**: Not required
- **Status**: To be implemented
- **Usage**: Dream description voice input

### Fallback Strategy Implementation

```dart
class ApiProvider {
  final String name;
  final Future<String> Function(String prompt) generateImage;
  final Duration timeout;
  
  ApiProvider({
    required this.name,
    required this.generateImage,
    this.timeout = const Duration(seconds: 30),
  });
}

class CircuitBreaker {
  final int failureThreshold;
  final Duration resetTimeout;
  int _failureCount = 0;
  DateTime? _lastFailureTime;
  bool _isOpen = false;
  
  CircuitBreaker({
    this.failureThreshold = 3,
    this.resetTimeout = const Duration(minutes: 1),
  });
  
  bool get isOpen => _isOpen;
  
  void recordSuccess() {
    _failureCount = 0;
    _isOpen = false;
  }
  
  void recordFailure() {
    _failureCount++;
    _lastFailureTime = DateTime.now();
    
    if (_failureCount >= failureThreshold) {
      _isOpen = true;
    }
  }
  
  bool shouldAttempt() {
    if (!_isOpen) return true;
    
    if (_lastFailureTime != null &&
        DateTime.now().difference(_lastFailureTime!) > resetTimeout) {
      _isOpen = false;
      _failureCount = 0;
      return true;
    }
    
    return false;
  }
}
```


## Phased Implementation Plan

### Phase 1: Hero Product (No Firebase) - Weeks 1-4

**Goal**: Prove the Visual DNA concept works with local storage

#### Week 1: Foundation Setup
- Create feature-based folder structure
- Set up dependency injection with get_it
- Implement core data models (User, DnaProfile, etc.)
- Set up routing with go_router
- Create shared UI components

#### Week 2: DNA Engine Core
- Implement DNA Profile entities and models
- Create local storage with Hive
- Build DNA onboarding flow UI
- Implement color preference tracking
- Implement style affinity tracking
- Create DNA profile visualization screen

#### Week 3: Emotion-to-Image Generation
- Integrate Transformers.js for emotion analysis
- Implement DNA injection service
- Enhance existing image generation with DNA
- Build emotion input UI
- Create generation history view
- Implement retry logic and fallback strategy

#### Week 4: Testing and Refinement
- Write unit tests for business logic
- Test DNA learning accuracy
- Verify 90% accuracy threshold
- Polish UI/UX
- Fix bugs and optimize performance

**Deliverables**:
- Working DNA onboarding
- Personalized image generation
- Local data persistence
- Generation history
- 90%+ accuracy on emotion-to-image


### Phase 2: Firebase Integration - Weeks 5-8

**Goal**: Add cloud sync, authentication, and multi-device support

#### Week 5: Firebase Setup
- User provides Firebase project credentials
- Configure Firebase Auth, Firestore, Storage
- Set up Firebase Cloud Functions project
- Implement backend API with Admin SDK
- Create security rules

#### Week 6: Authentication
- Implement Google Sign-In
- Implement Apple Sign-In
- Implement Email/Password auth
- Migrate local DNA data to Firestore
- Set up auth state management

#### Week 7: Cloud Sync
- Implement Firestore repositories
- Add real-time listeners for DNA updates
- Implement Firebase Storage for images
- Add offline-first capability
- Implement sync conflict resolution

#### Week 8: Testing and Deployment
- Test authentication flows
- Test data synchronization
- Verify security rules
- Deploy backend API
- Deploy to staging environment

**Deliverables**:
- Multi-device sync
- Secure authentication
- Cloud storage for images
- Backend API with security
- Offline-first capability


### Phase 3: Advanced Features - Weeks 9-16

**Goal**: Add memory transformer, dream studio, and collaborative features

#### Weeks 9-10: Memory Transformer
- Implement image upload functionality
- Integrate Vibrant.js for color extraction
- Integrate TensorFlow.js for composition analysis
- Build style selection UI
- Implement image-to-image transformation
- Test accuracy and fallback strategy

#### Weeks 11-12: Dream Studio
- Integrate Web Speech API for voice input
- Implement dream entry creation
- Build dream library UI
- Implement dream visualization
- Add dream search and filtering
- Test voice recognition accuracy

#### Weeks 13-14: Living Art Evolution
- Implement monthly evolution calculation
- Build evolution report UI
- Create evolution visualization charts
- Set up background job scheduling
- Test evolution algorithm accuracy

#### Weeks 15-16: Collaborative Universe
- Implement collaboration invitations
- Build DNA merging algorithm
- Create collaborative artwork generation
- Implement Firebase Dynamic Links
- Add social sharing features
- Final testing and polish

**Deliverables**:
- Memory transformation feature
- Dream studio with voice input
- Monthly style evolution
- Collaborative artwork
- Social sharing


## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property Reflection

After analyzing all acceptance criteria, I identified the following testable properties. Through reflection, I've eliminated redundancy by:

1. Combining audit log properties (26.9, 27.8, 35.7) into a single comprehensive property
2. Combining retry logic properties (9.12, 10.12) into a single property covering all features
3. Combining error handling properties (15.2, 5.9) into a comprehensive error handling property
4. Ensuring each property provides unique validation value

### Property 1: State Immutability

*For any* BLoC or Cubit state transition, the previous state object SHALL remain unmodified and a new state object SHALL be created.

**Validates: Requirements 3.5**

### Property 2: Authentication Token Storage

*For any* successful authentication operation (Google, Apple, Email), the authentication token SHALL be stored securely and SHALL be retrievable.

**Validates: Requirements 4.5**

### Property 3: Authentication Data Cleanup

*For any* logout operation, all authentication data (tokens, user info, cached credentials) SHALL be cleared from storage.

**Validates: Requirements 4.6**

### Property 4: DNA Profile Sync

*For any* DNA profile modification (color preferences, style affinity, emotional signature), the changes SHALL be persisted to the data store (local or Firestore).

**Validates: Requirements 5.6, 8.3**

### Property 5: Graceful Error Handling

*For any* operation that encounters an error (network, API, data), the application SHALL emit an error state with a descriptive message and SHALL NOT crash.

**Validates: Requirements 5.9, 15.2**

### Property 6: Upload Retry Logic

*For any* failed upload operation, the system SHALL retry exactly 3 times before emitting an error state.

**Validates: Requirements 6.6**

### Property 7: API Retry with Exponential Backoff

*For any* failed API call (image generation, transformation), the system SHALL retry with exponential backoff for exactly 3 attempts before failing.

**Validates: Requirements 9.12, 10.12**

### Property 8: Offline Data Access

*For any* data request when network connectivity is unavailable, the system SHALL return cached data if available, or emit an appropriate offline error state.

**Validates: Requirements 14.4**

### Property 9: Offline Sync on Reconnection

*For any* local data modifications made while offline, when network connectivity is restored, the system SHALL sync all changes to Firestore.

**Validates: Requirements 14.5**

### Property 10: Loading State Emission

*For any* asynchronous operation (authentication, generation, data fetch), the system SHALL emit a loading state before the operation completes.

**Validates: Requirements 15.1**

### Property 11: Data Serialization Round-Trip

*For any* data model (User, DnaProfile, GenerationResult, etc.), serializing to JSON and then deserializing SHALL produce an equivalent object.

**Validates: Requirements 19.6**

### Property 12: Audit Log Creation

*For any* administrative operation (user role change, content deletion, system configuration change), an audit log entry SHALL be created with timestamp, admin ID, action type, and affected resource.

**Validates: Requirements 26.9, 27.8, 35.7**

### Property 13: API Fallback Mechanism

*For any* external API call, when the primary API fails, the system SHALL automatically attempt the fallback API before emitting an error state.

**Validates: Requirements 40.1**


## Error Handling

### Error Types

#### Domain Errors
```dart
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
```

#### Data Layer Exceptions
```dart
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}
```

### Error Handling Strategy

1. **Data Layer**: Throws exceptions
2. **Repository Layer**: Catches exceptions, returns Either<Failure, Success>
3. **Use Case Layer**: Propagates Either<Failure, Success>
4. **BLoC Layer**: Maps failures to error states
5. **Presentation Layer**: Displays user-friendly error messages

### Example Error Handling Flow

```dart
// Repository Implementation
class DnaRepositoryImpl implements DnaRepository {
  @override
  Future<Either<Failure, DnaProfile>> getDnaProfile(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final profile = await remoteDataSource.getDnaProfile(userId);
        await localDataSource.cacheDnaProfile(profile);
        return Right(profile);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final profile = await localDataSource.getCachedDnaProfile(userId);
        return Right(profile);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
}

// BLoC Implementation
class DnaProfileCubit extends Cubit<DnaProfileState> {
  Future<void> loadDnaProfile(String userId) async {
    emit(DnaProfileLoading());
    
    final result = await getDnaProfileUseCase(userId);
    
    result.fold(
      (failure) => emit(DnaProfileError(_mapFailureToMessage(failure))),
      (profile) => emit(DnaProfileLoaded(profile)),
    );
  }
  
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error. Please try again later.';
      case CacheFailure:
        return 'Unable to load cached data.';
      case NetworkFailure:
        return 'No internet connection. Please check your network.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}
```


## Testing Strategy

### Dual Testing Approach

The application uses a comprehensive dual testing approach:

1. **Unit Tests**: Verify specific examples, edge cases, and error conditions
2. **Property-Based Tests**: Verify universal properties across all inputs

Both approaches are complementary and necessary for comprehensive coverage. Unit tests catch concrete bugs in specific scenarios, while property-based tests verify general correctness across a wide range of inputs.

### Unit Testing

#### Focus Areas
- Specific examples that demonstrate correct behavior
- Integration points between components
- Edge cases and error conditions
- Business logic validation

#### Example Unit Tests
```dart
// Test specific authentication scenario
test('should return User when Google sign-in succeeds', () async {
  // Arrange
  when(mockFirebaseAuth.signInWithCredential(any))
      .thenAnswer((_) async => mockUserCredential);
  
  // Act
  final result = await repository.signInWithGoogle();
  
  // Assert
  expect(result, isA<User>());
  expect(result.email, 'test@example.com');
});

// Test edge case
test('should throw AuthenticationFailure when credentials are invalid', () async {
  // Arrange
  when(mockFirebaseAuth.signInWithEmailAndPassword(any, any))
      .thenThrow(FirebaseAuthException(code: 'invalid-credential'));
  
  // Act & Assert
  expect(
    () => repository.signInWithEmail('test@example.com', 'wrong'),
    throwsA(isA<AuthenticationFailure>()),
  );
});
```

### Property-Based Testing

#### Configuration
- **Library**: Use `test` package with custom property testing utilities or `fast_check` equivalent
- **Iterations**: Minimum 100 iterations per property test
- **Tagging**: Each test references its design document property

#### Property Test Structure
```dart
// Property 1: State Immutability
test('Property 1: State immutability - state transitions create new objects', () {
  // Feature: visual-dna-architecture-restructure, Property 1
  
  for (int i = 0; i < 100; i++) {
    // Generate random state
    final oldState = generateRandomDnaProfileState();
    final oldStateHashCode = oldState.hashCode;
    
    // Perform state transition
    final newState = performRandomStateTransition(oldState);
    
    // Verify old state unchanged
    expect(oldState.hashCode, equals(oldStateHashCode));
    expect(identical(oldState, newState), isFalse);
  }
});

// Property 11: Data Serialization Round-Trip
test('Property 11: Serialization round-trip preserves data', () {
  // Feature: visual-dna-architecture-restructure, Property 11
  
  for (int i = 0; i < 100; i++) {
    // Generate random DNA profile
    final original = generateRandomDnaProfile();
    
    // Serialize and deserialize
    final json = original.toJson();
    final deserialized = DnaProfile.fromJson(json);
    
    // Verify equivalence
    expect(deserialized, equals(original));
  }
});

// Property 7: API Retry with Exponential Backoff
test('Property 7: Failed API calls retry exactly 3 times with backoff', () async {
  // Feature: visual-dna-architecture-restructure, Property 7
  
  for (int i = 0; i < 100; i++) {
    // Setup failing API
    int callCount = 0;
    final mockApi = MockApiProvider();
    when(mockApi.generateImage(any)).thenAnswer((_) async {
      callCount++;
      throw Exception('API failure');
    });
    
    // Attempt generation
    try {
      await service.generateWithRetry(mockApi, 'test prompt');
    } catch (e) {
      // Expected to fail
    }
    
    // Verify exactly 3 retries (4 total attempts)
    expect(callCount, equals(4));
  }
});
```


#### Test Data Generators

```dart
// Generator for random DNA profiles
DnaProfile generateRandomDnaProfile() {
  final random = Random();
  
  return DnaProfile(
    userId: 'user_${random.nextInt(10000)}',
    colorPreferences: generateRandomColorPreferences(),
    styleAffinity: generateRandomStyleAffinity(),
    emotionalSignature: generateRandomEmotionalSignature(),
    personalizationScore: random.nextDouble(),
    createdAt: DateTime.now().subtract(Duration(days: random.nextInt(365))),
    updatedAt: DateTime.now(),
  );
}

ColorPreferences generateRandomColorPreferences() {
  final random = Random();
  final colors = ['#FF0000', '#00FF00', '#0000FF', '#FFFF00', '#FF00FF'];
  
  return ColorPreferences(
    favoriteColors: List.generate(
      random.nextInt(5) + 1,
      (_) => colors[random.nextInt(colors.length)],
    ),
    avoidedColors: List.generate(
      random.nextInt(3),
      (_) => colors[random.nextInt(colors.length)],
    ),
    colorAffinityScores: Map.fromEntries(
      colors.map((c) => MapEntry(c, random.nextDouble())),
    ),
    dominantColorFamily: ['warm', 'cool', 'neutral', 'vibrant'][random.nextInt(4)],
  );
}
```

### Test Coverage Goals

- **Business Logic**: 90%+ coverage
- **Repositories**: 85%+ coverage
- **BLoCs/Cubits**: 90%+ coverage
- **UI Widgets**: 70%+ coverage
- **Overall**: 80%+ coverage

### Testing Tools

- **Unit Testing**: `test` package
- **Widget Testing**: `flutter_test` package
- **Mocking**: `mocktail` package
- **Code Coverage**: `coverage` package
- **Integration Testing**: `integration_test` package

### Continuous Integration

```yaml
# .github/workflows/test.yml
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
      - run: flutter test --coverage --reporter=json > test-results.json
      - name: Check coverage threshold
        run: |
          COVERAGE=$(grep -o '"coverage":[0-9.]*' test-results.json | cut -d':' -f2)
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            echo "Coverage $COVERAGE% is below 80% threshold"
            exit 1
          fi
```


## Migration Strategy

### Current State Analysis

**Existing Implementation**:
- Basic Flutter app with image generation
- Provider-based state management
- Direct API calls in UI layer
- No authentication
- No data persistence
- Pollinations.ai integration (working)
- DummyJSON fallback (working)

**Files to Preserve**:
- `lib/services/image_generation_service.dart` - Core API integration
- `lib/models/image_options.dart` - Image configuration models
- `lib/models/chat_message.dart` - Message data structures
- `lib/widgets/chat_bubble.dart` - UI component
- `lib/widgets/chat_input.dart` - UI component
- `lib/widgets/option_selector.dart` - UI component

**Files to Migrate**:
- `lib/providers/image_generation_provider.dart` → Convert to BLoC
- `lib/main.dart` → Restructure with clean architecture

### Migration Phases

#### Phase 1: Foundation (Week 1)
1. Create new folder structure alongside existing code
2. Set up dependency injection
3. Implement core entities and models
4. Keep existing app running

#### Phase 2: Feature Migration (Weeks 2-3)
1. Create emotion_to_image feature module
2. Migrate ImageGenerationService to data layer
3. Create GenerationRepository
4. Implement EmotionToImageBloc
5. Build new UI screens
6. Test in parallel with old implementation

#### Phase 3: DNA Engine (Week 4)
1. Implement visual_dna_engine module
2. Add local storage with Hive
3. Create DNA onboarding flow
4. Integrate DNA with image generation
5. Test DNA learning accuracy

#### Phase 4: Cutover (End of Week 4)
1. Switch main.dart to use new architecture
2. Remove old provider-based code
3. Final testing and bug fixes
4. Deploy Phase 1 hero product

### Backward Compatibility

During migration, maintain backward compatibility by:

1. **Dual Implementation**: Run old and new code in parallel
2. **Feature Flags**: Toggle between old and new implementations
3. **Gradual Rollout**: Migrate one feature at a time
4. **Rollback Plan**: Keep old code until new code is proven stable

### Migration Checklist

- [ ] Create feature-based folder structure
- [ ] Set up dependency injection
- [ ] Migrate data models
- [ ] Implement repositories
- [ ] Create BLoCs/Cubits
- [ ] Build new UI screens
- [ ] Write tests for new code
- [ ] Test in parallel with old code
- [ ] Switch to new implementation
- [ ] Remove old code
- [ ] Update documentation


## Security Considerations

### Firebase Security Rules

#### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Deny all direct client access
    match /{document=**} {
      allow read, write: if false;
    }
    
    // Only allow access from backend with Admin SDK
    // Backend uses service account credentials
  }
}
```

#### Storage Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Deny all direct client access
    match /{allPaths=**} {
      allow read, write: if false;
    }
    
    // Only allow access from backend with Admin SDK
  }
}
```

### Backend API Security

#### Authentication Middleware
```typescript
export const authenticateUser = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const token = req.headers.authorization?.split('Bearer ')[1];
    
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }
    
    const decodedToken = await admin.auth().verifyIdToken(token);
    req.user = decodedToken;
    next();
  } catch (error) {
    return res.status(401).json({ error: 'Invalid token' });
  }
};
```

#### Rate Limiting
```typescript
import rateLimit from 'express-rate-limit';

export const apiLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 100, // 100 requests per minute
  message: 'Too many requests, please try again later',
  standardHeaders: true,
  legacyHeaders: false,
});

export const generationLimiter = rateLimit({
  windowMs: 60 * 1000,
  max: 10, // 10 generations per minute
  message: 'Generation rate limit exceeded',
});
```

#### Input Validation
```typescript
import { body, validationResult } from 'express-validator';

export const validateGenerationRequest = [
  body('prompt').isString().trim().isLength({ min: 1, max: 500 }),
  body('userId').isString().trim(),
  body('aspectRatio').isString().isIn(['1:1', '9:16', '16:9', '3:4']),
  body('style').isString(),
  
  (req: Request, res: Response, next: NextFunction) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    next();
  },
];
```

### Data Encryption

- **At Rest**: Firebase encrypts all data at rest by default
- **In Transit**: All API calls use HTTPS/TLS
- **Sensitive Data**: Authentication tokens stored in secure storage (Keychain/Keystore)
- **Local Storage**: Hive boxes encrypted with user-specific keys

### Role-Based Access Control

```typescript
export const requireAdmin = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const user = req.user;
  
  if (!user) {
    return res.status(401).json({ error: 'Unauthorized' });
  }
  
  const customClaims = user.customClaims || {};
  const role = customClaims.role;
  
  if (role !== 'admin' && role !== 'superAdmin') {
    return res.status(403).json({ error: 'Forbidden: Admin access required' });
  }
  
  next();
};
```


## Performance Optimization

### Image Caching Strategy

```dart
class CachedImageService {
  final ImageCache _cache = ImageCache();
  
  void configureCache() {
    _cache.maximumSize = 100; // Cache up to 100 images
    _cache.maximumSizeBytes = 50 * 1024 * 1024; // 50 MB
  }
  
  Widget buildCachedImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => const LoadingIndicator(),
      errorWidget: (context, url, error) => const ErrorDisplay(),
      memCacheWidth: 800, // Resize for display
      memCacheHeight: 800,
    );
  }
}
```

### Firestore Query Optimization

```dart
class OptimizedDnaRepository {
  // Use pagination for large datasets
  Future<List<GenerationResult>> getGenerationHistory(
    String userId, {
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) async {
    Query query = _firestore
        .collection('generations')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit);
    
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => GenerationResultModel.fromFirestore(doc))
        .toList();
  }
  
  // Use composite indexes for complex queries
  Future<List<DreamEntry>> searchDreams(
    String userId,
    String searchTerm,
  ) async {
    // Firestore composite index: userId + searchTerms (array)
    final snapshot = await _firestore
        .collection('dreams')
        .where('userId', isEqualTo: userId)
        .where('searchTerms', arrayContains: searchTerm.toLowerCase())
        .limit(20)
        .get();
    
    return snapshot.docs
        .map((doc) => DreamEntryModel.fromFirestore(doc))
        .toList();
  }
}
```

### Lazy Loading

```dart
class GenerationHistoryScreen extends StatefulWidget {
  @override
  State<GenerationHistoryScreen> createState() => _GenerationHistoryScreenState();
}

class _GenerationHistoryScreenState extends State<GenerationHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Load more when 80% scrolled
      context.read<GenerationHistoryBloc>().add(LoadMoreGenerations());
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: generations.length + 1,
      itemBuilder: (context, index) {
        if (index == generations.length) {
          return const LoadingIndicator();
        }
        return GenerationCard(generation: generations[index]);
      },
    );
  }
}
```

### Background Processing

```dart
class BackgroundSyncService {
  static const String taskName = 'dna_sync';
  
  Future<void> registerBackgroundTask() async {
    await Workmanager().registerPeriodicTask(
      taskName,
      taskName,
      frequency: const Duration(hours: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
  
  Future<void> syncDnaProfile() async {
    final localProfile = await _localDataSource.getDnaProfile();
    final remoteProfile = await _remoteDataSource.getDnaProfile();
    
    if (localProfile.updatedAt.isAfter(remoteProfile.updatedAt)) {
      await _remoteDataSource.updateDnaProfile(localProfile);
    } else if (remoteProfile.updatedAt.isAfter(localProfile.updatedAt)) {
      await _localDataSource.cacheDnaProfile(remoteProfile);
    }
  }
}
```

### Memory Management

```dart
class MemoryOptimizedImageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Use builder for efficient memory usage
      itemCount: images.length,
      itemBuilder: (context, index) {
        return AutomaticKeepAliveClientMixin(
          // Keep visible items alive
          wantKeepAlive: false,
          child: ImageCard(image: images[index]),
        );
      },
      // Add cache extent for smooth scrolling
      cacheExtent: 500,
    );
  }
}
```


## Admin Panel Architecture

### Technology Stack

**Option 1: Flutter Web** (Recommended for code reuse)
- Reuse existing Flutter codebase
- Share data models and business logic
- Consistent UI/UX with mobile app
- Single codebase for all platforms

**Option 2: React/Vue.js** (Alternative for web-specific features)
- Better web performance
- Richer ecosystem of web libraries
- Separate codebase from mobile app

### Admin Panel Structure (Flutter Web)

```
lib/admin/
├── features/
│   ├── dashboard/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   └── dashboard_screen.dart
│   │   │   └── widgets/
│   │   │       ├── metric_card.dart
│   │   │       └── chart_widget.dart
│   │   └── cubit/
│   │       ├── dashboard_cubit.dart
│   │       └── dashboard_state.dart
│   │
│   ├── user_management/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── user_list_screen.dart
│   │   │   │   └── user_detail_screen.dart
│   │   │   └── widgets/
│   │   │       ├── user_table.dart
│   │   │       └── user_actions.dart
│   │   └── bloc/
│   │       ├── user_management_bloc.dart
│   │       ├── user_management_event.dart
│   │       └── user_management_state.dart
│   │
│   ├── content_moderation/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   └── moderation_screen.dart
│   │   │   └── widgets/
│   │   │       ├── content_grid.dart
│   │   │       └── moderation_actions.dart
│   │   └── bloc/
│   │       ├── moderation_bloc.dart
│   │       ├── moderation_event.dart
│   │       └── moderation_state.dart
│   │
│   └── system_monitoring/
│       ├── presentation/
│       │   ├── screens/
│       │   │   └── monitoring_screen.dart
│       │   └── widgets/
│       │       ├── health_metrics.dart
│       │       └── error_logs.dart
│       └── cubit/
│           ├── monitoring_cubit.dart
│           └── monitoring_state.dart
│
└── main_admin.dart
```

### Admin Dashboard Features

#### 1. Analytics Dashboard
```dart
class DashboardMetrics {
  final int totalUsers;
  final int activeUsersDaily;
  final int activeUsersMonthly;
  final int totalGenerations;
  final double averageGenerationsPerUser;
  final Map<String, int> featureUsage;
  final List<ChartDataPoint> userGrowth;
  final List<ChartDataPoint> generationTrend;
  
  DashboardMetrics({
    required this.totalUsers,
    required this.activeUsersDaily,
    required this.activeUsersMonthly,
    required this.totalGenerations,
    required this.averageGenerationsPerUser,
    required this.featureUsage,
    required this.userGrowth,
    required this.generationTrend,
  });
}
```

#### 2. User Management Interface
```dart
class UserManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: Column(
        children: [
          // Search and filters
          UserSearchBar(),
          UserFilters(),
          
          // User table
          Expanded(
            child: BlocBuilder<UserManagementBloc, UserManagementState>(
              builder: (context, state) {
                if (state is UserManagementLoaded) {
                  return DataTable(
                    columns: const [
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Role')),
                      DataColumn(label: Text('Joined')),
                      DataColumn(label: Text('Generations')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: state.users.map((user) {
                      return DataRow(cells: [
                        DataCell(Text(user.email)),
                        DataCell(Text(user.role.name)),
                        DataCell(Text(formatDate(user.createdAt))),
                        DataCell(Text('${user.generationCount}')),
                        DataCell(UserActionsMenu(user: user)),
                      ]);
                    }).toList(),
                  );
                }
                return const LoadingIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

#### 3. Content Moderation Interface
```dart
class ModerationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Content Moderation')),
      body: Column(
        children: [
          // Filters
          ModerationFilters(),
          
          // Content grid
          Expanded(
            child: BlocBuilder<ModerationBloc, ModerationState>(
              builder: (context, state) {
                if (state is ModerationLoaded) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                    ),
                    itemCount: state.content.length,
                    itemBuilder: (context, index) {
                      final item = state.content[index];
                      return ContentCard(
                        content: item,
                        onFlag: () => _flagContent(context, item),
                        onDelete: () => _deleteContent(context, item),
                      );
                    },
                  );
                }
                return const LoadingIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

### Admin API Endpoints

```typescript
// Backend API endpoints for admin panel
export const adminRoutes = {
  // Analytics
  'GET /admin/analytics/dashboard': getDashboardMetrics,
  'GET /admin/analytics/users': getUserAnalytics,
  'GET /admin/analytics/generations': getGenerationAnalytics,
  
  // User Management
  'GET /admin/users': listUsers,
  'GET /admin/users/:id': getUserDetails,
  'PUT /admin/users/:id/role': updateUserRole,
  'PUT /admin/users/:id/status': updateUserStatus,
  
  // Content Moderation
  'GET /admin/content': listContent,
  'PUT /admin/content/:id/flag': flagContent,
  'DELETE /admin/content/:id': deleteContent,
  
  // System Monitoring
  'GET /admin/system/health': getSystemHealth,
  'GET /admin/system/errors': getErrorLogs,
  'GET /admin/system/usage': getUsageMetrics,
  
  // Audit Logs
  'GET /admin/audit-logs': getAuditLogs,
};
```


## Deployment Strategy

### Environment Configuration

#### Development Environment
```dart
class DevConfig {
  static const String apiBaseUrl = 'http://localhost:5001/api';
  static const String firebaseProjectId = 'aura-dev';
  static const bool enableLogging = true;
  static const bool enableAnalytics = false;
}
```

#### Staging Environment
```dart
class StagingConfig {
  static const String apiBaseUrl = 'https://staging-api.aura.app/api';
  static const String firebaseProjectId = 'aura-staging';
  static const bool enableLogging = true;
  static const bool enableAnalytics = true;
}
```

#### Production Environment
```dart
class ProdConfig {
  static const String apiBaseUrl = 'https://api.aura.app/api';
  static const String firebaseProjectId = 'aura-prod';
  static const bool enableLogging = false;
  static const bool enableAnalytics = true;
}
```

### CI/CD Pipeline

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches:
      - main
      - staging
      - develop

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
      - name: Check coverage
        run: |
          COVERAGE=$(grep -o '"coverage":[0-9.]*' test-results.json | cut -d':' -f2)
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            exit 1
          fi

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v3
        with:
          name: android-release
          path: build/app/outputs/flutter-apk/app-release.apk

  build-ios:
    needs: test
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build ios --release --no-codesign
      - uses: actions/upload-artifact@v3
        with:
          name: ios-release
          path: build/ios/iphoneos/Runner.app

  deploy-backend:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: cd functions && npm install
      - run: cd functions && npm run build
      - uses: w9jds/firebase-action@master
        with:
          args: deploy --only functions
        env:
          FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
```

### Feature Flags

```dart
class FeatureFlags {
  static Future<Map<String, bool>> fetchFlags() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    
    await remoteConfig.fetchAndActivate();
    
    return {
      'memory_transformer_enabled': remoteConfig.getBool('memory_transformer_enabled'),
      'dream_studio_enabled': remoteConfig.getBool('dream_studio_enabled'),
      'collaborative_universe_enabled': remoteConfig.getBool('collaborative_universe_enabled'),
      'living_art_enabled': remoteConfig.getBool('living_art_enabled'),
    };
  }
}
```

### Rollback Strategy

1. **Version Tagging**: Tag each release with semantic versioning
2. **Gradual Rollout**: Deploy to 10% → 50% → 100% of users
3. **Monitoring**: Watch error rates and crash reports
4. **Quick Rollback**: Revert to previous version if issues detected
5. **Feature Flags**: Disable problematic features without redeployment


## Documentation Requirements

### Code Documentation

#### Repository Documentation
```dart
/// Repository for managing DNA profile data.
///
/// This repository abstracts the data layer and provides a clean API
/// for accessing and modifying user DNA profiles. It implements offline-first
/// architecture by caching data locally and syncing with Firestore when online.
///
/// Example usage:
/// ```dart
/// final profile = await dnaRepository.getDnaProfile(userId);
/// await dnaRepository.updateColorPreferences(userId, newPreferences);
/// ```
abstract class DnaRepository {
  /// Retrieves the DNA profile for the specified user.
  ///
  /// Returns cached data if offline, otherwise fetches from Firestore.
  /// Throws [CacheFailure] if offline and no cached data exists.
  /// Throws [ServerFailure] if online but Firestore request fails.
  Future<Either<Failure, DnaProfile>> getDnaProfile(String userId);
  
  /// Updates the DNA profile for the specified user.
  ///
  /// Updates local cache immediately and syncs to Firestore when online.
  /// Queues the update if offline and syncs when connectivity is restored.
  Future<Either<Failure, void>> updateDnaProfile(DnaProfile profile);
}
```

#### BLoC Documentation
```dart
/// BLoC for managing emotion-to-image generation.
///
/// This BLoC handles the complete flow of generating personalized artwork
/// from emotional input, including:
/// - Emotion analysis using Transformers.js
/// - DNA injection into prompts
/// - Image generation with fallback strategy
/// - Retry logic with exponential backoff
///
/// States:
/// - [EmotionToImageInitial]: Initial state
/// - [EmotionToImageGenerating]: Generation in progress
/// - [EmotionToImageSuccess]: Generation completed successfully
/// - [EmotionToImageError]: Generation failed after retries
///
/// Events:
/// - [GenerateFromEmotionRequested]: Start generation from emotion input
/// - [RetryGenerationRequested]: Retry failed generation
class EmotionToImageBloc extends Bloc<EmotionToImageEvent, EmotionToImageState> {
  // Implementation...
}
```

### Feature Module README

Each feature module should include a README.md:

```markdown
# Visual DNA Engine

## Overview
The Visual DNA Engine is the core feature that learns and tracks user preferences
to personalize artwork generation.

## Architecture
- **Domain Layer**: DnaProfile entity, DnaRepository interface
- **Data Layer**: Local (Hive) and remote (Firestore) data sources
- **Presentation Layer**: DnaProfileCubit, onboarding and profile screens

## Key Components
- `DnaProfile`: Entity representing user's aesthetic preferences
- `ColorPreferences`: Tracks favorite and avoided colors
- `StyleAffinity`: Tracks preferred art styles
- `EmotionalSignature`: Tracks emotional patterns

## Usage
```dart
// Get DNA profile
final profile = await dnaRepository.getDnaProfile(userId);

// Update color preferences
await dnaRepository.updateColorPreferences(
  userId,
  ColorPreferences(favoriteColors: ['#FF0000', '#00FF00']),
);
```

## Testing
Run tests: `flutter test test/features/visual_dna_engine`

## Dependencies
- get_it: Dependency injection
- hive: Local storage
- cloud_firestore: Remote storage
```

### API Documentation

Backend API endpoints should be documented with OpenAPI/Swagger:

```yaml
openapi: 3.0.0
info:
  title: AURA Backend API
  version: 1.0.0
  description: Backend API for AURA Visual DNA platform

paths:
  /api/dna/profile:
    get:
      summary: Get user's DNA profile
      security:
        - bearerAuth: []
      responses:
        '200':
          description: DNA profile retrieved successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/DnaProfile'
        '401':
          description: Unauthorized
        '404':
          description: Profile not found
    
    put:
      summary: Update user's DNA profile
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/DnaProfile'
      responses:
        '200':
          description: Profile updated successfully
        '400':
          description: Invalid request
        '401':
          description: Unauthorized

components:
  schemas:
    DnaProfile:
      type: object
      properties:
        userId:
          type: string
        colorPreferences:
          $ref: '#/components/schemas/ColorPreferences'
        styleAffinity:
          $ref: '#/components/schemas/StyleAffinity'
        emotionalSignature:
          $ref: '#/components/schemas/EmotionalSignature'
        personalizationScore:
          type: number
          format: double
```


## Quality Gates

### Pre-Deployment Checklist

Before any feature can be deployed to production, it must pass all quality gates:

#### Quality Gate 1: Automated Testing ✓
- [ ] All unit tests pass (100% of business logic tests)
- [ ] All widget tests pass (100% of UI component tests)
- [ ] All integration tests pass (100% of feature workflow tests)
- [ ] Code coverage ≥ 80%
- [ ] Property-based tests pass (minimum 100 iterations each)

#### Quality Gate 2: Accuracy Validation ✓
- [ ] Feature accuracy measured and documented
- [ ] Accuracy ≥ 90% threshold
- [ ] Tested with minimum 100 real-world test cases
- [ ] Edge cases identified and handled

#### Quality Gate 3: API Resilience ✓
- [ ] Fallback strategy implemented
- [ ] Circuit breaker tested with simulated failures
- [ ] Retry logic verified (3 attempts with exponential backoff)
- [ ] Graceful degradation tested

#### Quality Gate 4: Error Handling ✓
- [ ] All error scenarios have appropriate user messaging
- [ ] No crashes under any error condition
- [ ] Error handling tested with simulated failures
- [ ] Network errors handled gracefully
- [ ] API errors handled gracefully

#### Quality Gate 5: User Acceptance ✓
- [ ] User completed manual testing
- [ ] User approved feature for production
- [ ] User feedback documented and addressed
- [ ] UI/UX meets user expectations

#### Quality Gate 6: Performance ✓
- [ ] Load time < 2 seconds
- [ ] Response time < 5 seconds
- [ ] No memory leaks detected
- [ ] Performance profiled and optimized
- [ ] Image caching working correctly

#### Quality Gate 7: Code Review ✓
- [ ] Code reviewed by at least one other developer
- [ ] Follows project coding standards
- [ ] No files exceed 1000 lines
- [ ] Single responsibility principle followed
- [ ] Code review feedback addressed

#### Quality Gate 8: Documentation ✓
- [ ] Feature README updated
- [ ] API documentation updated
- [ ] Inline code comments for complex logic
- [ ] User guide updated (if applicable)
- [ ] Migration guide updated (if applicable)

### Automated Quality Gate Enforcement

```dart
// quality_gate_check.dart
class QualityGateChecker {
  Future<bool> checkAllGates() async {
    final results = await Future.wait([
      _checkTestCoverage(),
      _checkCodeQuality(),
      _checkPerformance(),
      _checkDocumentation(),
    ]);
    
    return results.every((passed) => passed);
  }
  
  Future<bool> _checkTestCoverage() async {
    final coverage = await _getCoveragePercentage();
    if (coverage < 80) {
      print('❌ Test coverage $coverage% is below 80% threshold');
      return false;
    }
    print('✓ Test coverage: $coverage%');
    return true;
  }
  
  Future<bool> _checkCodeQuality() async {
    final violations = await _runStaticAnalysis();
    if (violations.isNotEmpty) {
      print('❌ Code quality violations found:');
      for (final violation in violations) {
        print('  - $violation');
      }
      return false;
    }
    print('✓ Code quality checks passed');
    return true;
  }
}
```


## Monitoring and Analytics

### Firebase Analytics Events

```dart
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  // User events
  Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }
  
  Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }
  
  // DNA events
  Future<void> logDnaOnboardingCompleted() async {
    await _analytics.logEvent(
      name: 'dna_onboarding_completed',
      parameters: {'timestamp': DateTime.now().toIso8601String()},
    );
  }
  
  Future<void> logDnaProfileUpdated(String updateType) async {
    await _analytics.logEvent(
      name: 'dna_profile_updated',
      parameters: {'update_type': updateType},
    );
  }
  
  // Generation events
  Future<void> logImageGeneration({
    required String feature,
    required String style,
    required String aspectRatio,
    required bool success,
    required Duration duration,
  }) async {
    await _analytics.logEvent(
      name: 'image_generation',
      parameters: {
        'feature': feature,
        'style': style,
        'aspect_ratio': aspectRatio,
        'success': success,
        'duration_ms': duration.inMilliseconds,
      },
    );
  }
  
  // Feature usage
  Future<void> logFeatureUsed(String featureName) async {
    await _analytics.logEvent(
      name: 'feature_used',
      parameters: {'feature_name': featureName},
    );
  }
}
```

### Crashlytics Integration

```dart
class CrashlyticsService {
  static Future<void> initialize() async {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  
  static Future<void> logError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }
  
  static Future<void> setUserIdentifier(String userId) async {
    await FirebaseCrashlytics.instance.setUserIdentifier(userId);
  }
  
  static Future<void> log(String message) async {
    await FirebaseCrashlytics.instance.log(message);
  }
}
```

### Performance Monitoring

```dart
class PerformanceMonitoringService {
  final FirebasePerformance _performance = FirebasePerformance.instance;
  
  Future<void> traceImageGeneration(
    Future<String> Function() generateImage,
  ) async {
    final trace = _performance.newTrace('image_generation');
    await trace.start();
    
    try {
      final result = await generateImage();
      trace.putAttribute('success', 'true');
      return result;
    } catch (e) {
      trace.putAttribute('success', 'false');
      trace.putAttribute('error', e.toString());
      rethrow;
    } finally {
      await trace.stop();
    }
  }
  
  Future<void> traceApiCall(
    String apiName,
    Future<dynamic> Function() apiCall,
  ) async {
    final trace = _performance.newTrace('api_call_$apiName');
    await trace.start();
    
    try {
      final result = await apiCall();
      trace.putAttribute('success', 'true');
      return result;
    } catch (e) {
      trace.putAttribute('success', 'false');
      rethrow;
    } finally {
      await trace.stop();
    }
  }
}
```

### Custom Metrics Dashboard

```dart
class MetricsService {
  Future<void> recordGenerationMetrics({
    required String userId,
    required String feature,
    required bool success,
    required Duration duration,
    required int retryCount,
    required String apiUsed,
  }) async {
    await _firestore.collection('metrics').add({
      'userId': userId,
      'feature': feature,
      'success': success,
      'duration_ms': duration.inMilliseconds,
      'retry_count': retryCount,
      'api_used': apiUsed,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
  
  Future<Map<String, dynamic>> getFeatureSuccessRates() async {
    final snapshot = await _firestore
        .collection('metrics')
        .where('timestamp', isGreaterThan: DateTime.now().subtract(Duration(days: 7)))
        .get();
    
    final metrics = <String, List<bool>>{};
    
    for (final doc in snapshot.docs) {
      final feature = doc['feature'] as String;
      final success = doc['success'] as bool;
      
      metrics.putIfAbsent(feature, () => []).add(success);
    }
    
    return metrics.map((feature, successes) {
      final successRate = successes.where((s) => s).length / successes.length;
      return MapEntry(feature, successRate);
    });
  }
}
```


## Conclusion

### Summary

This design document provides a comprehensive blueprint for restructuring AURA into a production-grade Visual DNA platform. The architecture follows clean architecture principles with:

- **Feature-based modular structure** for scalability
- **BLoC/Cubit state management** for predictability
- **Offline-first architecture** for reliability
- **Free API strategy** for cost control
- **90% accuracy threshold** for quality
- **Comprehensive testing** with dual approach
- **Security-first backend** with Firebase Admin SDK
- **Phased implementation** for systematic development

### Key Architectural Strengths

1. **Separation of Concerns**: Clear boundaries between presentation, domain, and data layers
2. **Testability**: Dependency injection and repository pattern enable comprehensive testing
3. **Scalability**: Feature-based modules can be developed and deployed independently
4. **Maintainability**: Maximum 1000 lines per file, single responsibility principle
5. **Resilience**: Circuit breaker, retry logic, and fallback strategies
6. **Security**: Backend API layer prevents direct Firebase access
7. **Performance**: Caching, lazy loading, and background sync optimization

### Implementation Priorities

**Phase 1 (Weeks 1-4): Hero Product**
- Prove Visual DNA concept works
- Local storage only
- Core emotion-to-image generation
- 90%+ accuracy validation

**Phase 2 (Weeks 5-8): Firebase Integration**
- Multi-device sync
- Authentication
- Cloud storage
- Backend API security

**Phase 3 (Weeks 9-16): Advanced Features**
- Memory transformer
- Dream studio
- Living art evolution
- Collaborative universe

### Success Criteria

The restructure will be considered successful when:

1. ✓ All quality gates pass for each feature
2. ✓ 90%+ accuracy on all AI-powered features
3. ✓ 80%+ code coverage with tests
4. ✓ Zero direct Firebase access from client
5. ✓ All features work offline-first
6. ✓ Load time < 2 seconds
7. ✓ User approval on all features
8. ✓ Production deployment successful

### Next Steps

1. **User Review**: Review this design document and provide feedback
2. **Foundation Setup**: Create folder structure and core infrastructure
3. **Phase 1 Implementation**: Build hero product with DNA engine
4. **User Testing**: Validate DNA learning and accuracy
5. **Iterate**: Refine based on feedback and metrics
6. **Phase 2 & 3**: Continue with Firebase and advanced features

### Maintenance and Evolution

Post-launch, the architecture supports:

- **Feature Flags**: Enable/disable features without redeployment
- **A/B Testing**: Test variations with user segments
- **Gradual Rollouts**: Deploy to percentage of users
- **Quick Rollbacks**: Revert problematic releases
- **Continuous Monitoring**: Track metrics and errors in real-time
- **Agile Sprints**: Two-week iterations with quality gates

This architecture is designed to grow with AURA, supporting new features, scaling to millions of users, and maintaining high quality standards throughout the product lifecycle.

