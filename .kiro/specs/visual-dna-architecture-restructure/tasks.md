# Implementation Plan: AURA Visual DNA Architecture Restructure

## Overview

This implementation plan transforms the basic Flutter image generation app into a production-grade Visual DNA platform following the "Hero Product First" approach. The plan is organized into 4 major phases with 8 systematic workflow steps per feature, ensuring quality gates are met at each stage.

**Implementation Strategy**: Build core features with free APIs first, validate accuracy (90%+ threshold), then add Firebase integration, then advanced features.

**Technology Stack**: Flutter/Dart, BLoC/Cubit state management, Firebase (Auth, Firestore, Storage, Cloud Functions), Pollinations.ai, Transformers.js, Vibrant.js, TensorFlow.js

---

## PHASE 1: FOUNDATION & HERO PRODUCT (Weeks 1-4)

### 1. Project Foundation Setup

- [x] 1.1 Create feature-based folder structure
  - Create `lib/core/` directory with subdirectories: `di/`, `error/`, `network/`, `theme/`, `utils/`, `widgets/`
  - Create `lib/features/` directory
  - Create feature modules: `authentication/`, `visual_dna_engine/`, `emotion_to_image/`
  - Each feature module should have: `data/`, `domain/`, `presentation/` subdirectories
  - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5_

- [x] 1.2 Set up dependency injection with get_it
  - Add `get_it` package to `pubspec.yaml`
  - Create `lib/core/di/injection.dart` with service locator setup
  - Register external dependencies (SharedPreferences, http.Client)
  - _Requirements: 16.1, 16.2_

- [x] 1.3 Implement core error handling infrastructure
  - Create `lib/core/error/failures.dart` with Failure classes (ServerFailure, CacheFailure, NetworkFailure, etc.)
  - Create `lib/core/error/exceptions.dart` with Exception classes
  - _Requirements: 15.2, 15.5_


- [x] 1.4 Create shared UI components and design system
  - Create `lib/core/theme/app_colors.dart` with color palette
  - Create `lib/core/theme/app_typography.dart` with text styles
  - Create `lib/core/theme/app_theme.dart` with ThemeData configuration
  - Create shared widgets: `loading_indicator.dart`, `error_display.dart`, `custom_button.dart`, `custom_card.dart`
  - _Requirements: 18.1, 18.2, 18.3, 18.4_

- [x] 1.5 Set up routing with go_router
  - Add `go_router` package to `pubspec.yaml`
  - Create `lib/core/routing/router.dart` with route configuration
  - Define routes for: home, auth (login/signup), DNA onboarding, DNA profile, emotion-to-image
  - Implement authentication-based route guards
  - _Requirements: 17.1, 17.2, 17.4, 17.5_

- [ ]* 1.6 Write unit tests for core infrastructure
  - Test error handling classes
  - Test shared utility functions
  - Test dependency injection setup
  - _Requirements: 19.1, 19.3_

### 2. Visual DNA Engine - Foundation (Local Storage)

- [x] 2.1 Implement DNA Profile domain entities
  - Create `lib/features/visual_dna_engine/domain/entities/dna_profile.dart`
  - Create `lib/features/visual_dna_engine/domain/entities/color_preferences.dart`
  - Create `lib/features/visual_dna_engine/domain/entities/style_affinity.dart`
  - Create `lib/features/visual_dna_engine/domain/entities/emotional_signature.dart`
  - _Requirements: 8.2, 8.5_

- [x] 2.2 Create DNA Profile data models with serialization
  - Create `lib/features/visual_dna_engine/data/models/dna_profile_model.dart` extending DnaProfile entity
  - Implement `fromJson()` and `toJson()` methods for all models
  - Create Hive type adapters for local storage
  - _Requirements: 8.6_

- [ ]* 2.3 Write property test for DNA Profile serialization
  - **Property 11: Data Serialization Round-Trip**
  - **Validates: Requirements 19.6**
  - Test that serializing and deserializing DNA profiles produces equivalent objects
  - Generate 100+ random DNA profiles for testing


- [x] 2.4 Implement local storage with Hive
  - Add `hive` and `hive_flutter` packages to `pubspec.yaml`
  - Create `lib/features/visual_dna_engine/data/datasources/dna_local_datasource.dart`
  - Implement methods: `getDnaProfile()`, `cacheDnaProfile()`, `updateColorPreferences()`, `updateStyleAffinity()`, `updateEmotionalSignature()`
  - Initialize Hive in main.dart
  - _Requirements: 8.6, 14.2_

- [x] 2.5 Create DNA Repository interface and implementation
  - Create `lib/features/visual_dna_engine/domain/repositories/dna_repository.dart` (abstract interface)
  - Create `lib/features/visual_dna_engine/data/repositories/dna_repository_impl.dart`
  - Implement methods: `getDnaProfile()`, `updateDnaProfile()`, `updateColorPreferences()`, `updateStyleAffinity()`, `updateEmotionalSignature()`, `calculatePersonalizationScore()`
  - Use Either<Failure, Success> pattern for error handling
  - _Requirements: 8.6, 8.7, 1.2_

- [ ]* 2.6 Write unit tests for DNA Repository
  - Test successful data retrieval from local storage
  - Test cache failures and error handling
  - Test data update operations
  - Mock local datasource with mocktail
  - _Requirements: 19.1, 19.3_

- [x] 2.7 Implement DNA Profile Cubit for state management
  - Create `lib/features/visual_dna_engine/presentation/cubit/dna_profile_cubit.dart`
  - Create `lib/features/visual_dna_engine/presentation/cubit/dna_profile_state.dart`
  - Define states: DnaProfileInitial, DnaProfileLoading, DnaProfileLoaded, DnaProfileError
  - Implement methods: `loadDnaProfile()`, `updateColorPreferences()`, `updateStyleAffinity()`, `updateEmotionalSignature()`
  - _Requirements: 3.1, 3.3, 3.4, 8.7_

- [ ]* 2.8 Write property test for state immutability
  - **Property 1: State Immutability**
  - **Validates: Requirements 3.5**
  - Test that state transitions create new state objects without modifying previous state
  - Generate 100+ random state transitions

- [x] 2.9 Register DNA dependencies in service locator
  - Register DnaLocalDataSource in `lib/core/di/injection.dart`
  - Register DnaRepository in service locator
  - Register DnaProfileCubit as factory
  - _Requirements: 16.2, 16.3_

### 3. DNA Onboarding UI Implementation


- [x] 3.1 Create DNA onboarding screen structure
  - Create `lib/features/visual_dna_engine/presentation/screens/dna_onboarding_screen.dart`
  - Implement multi-step onboarding flow (color preferences → style preferences → emotional baseline)
  - Use BlocProvider to inject DnaProfileCubit
  - Use BlocBuilder for reactive UI updates
  - _Requirements: 3.6, 3.7, 8.1_

- [x] 3.2 Build color preference selector widget
  - Create `lib/features/visual_dna_engine/presentation/widgets/color_preference_selector.dart`
  - Display color palette grid for user selection
  - Track favorite and avoided colors
  - Update DNA profile on selection
  - _Requirements: 8.2_

- [x] 3.3 Build style preference selector widget
  - Create `lib/features/visual_dna_engine/presentation/widgets/style_preference_selector.dart`
  - Display art style options (abstract, realistic, surreal, minimalist, etc.)
  - Allow multi-select for style preferences
  - Update DNA profile on selection
  - _Requirements: 8.2_

- [x] 3.4 Build emotional baseline input widget
  - Create widget for capturing initial emotional preferences
  - Use slider or rating system for emotion intensity
  - Initialize emotional signature in DNA profile
  - _Requirements: 8.2_

- [x] 3.5 Create DNA profile visualization screen
  - Create `lib/features/visual_dna_engine/presentation/screens/dna_profile_screen.dart`
  - Create `lib/features/visual_dna_engine/presentation/widgets/dna_visualization.dart`
  - Display color preferences, style affinity, emotional signature
  - Show personalization score
  - _Requirements: 8.5_

- [x] 3.6 Implement loading and error states in DNA UI
  - Display loading indicator during profile operations
  - Show error messages with retry option
  - Handle offline state gracefully
  - _Requirements: 15.1, 15.2, 15.3_

- [ ] 3.7 Checkpoint - Test DNA onboarding flow
  - Manually test complete onboarding flow
  - Verify data persistence to local storage
  - Verify DNA profile visualization displays correctly
  - Ensure all tests pass, ask the user if questions arise


### 4. DNA Injection Engine

- [x] 4.1 Implement DNA Injection Service
  - Create `lib/core/services/dna_injection_service.dart`
  - Implement `injectDnaIntoPrompt(String basePrompt, DnaProfile dna)` method
  - Enhance prompts with color preferences (e.g., "with warm tones of red and orange")
  - Enhance prompts with style preferences (e.g., "in abstract expressionist style")
  - Enhance prompts with emotional context (e.g., "evoking feelings of joy and serenity")
  - _Requirements: 9.8_

- [x] 4.2 Implement DNA influence calculation
  - Implement `calculateDnaInfluence(DnaProfile dna, String prompt)` method
  - Calculate metrics: color influence percentage, style influence percentage, emotion influence percentage
  - Return influence data for analytics and metadata
  - _Requirements: 9.8_

- [ ]* 4.3 Write unit tests for DNA Injection Service
  - Test prompt enhancement with various DNA profiles
  - Test influence calculation accuracy
  - Test edge cases (empty preferences, null values)
  - _Requirements: 19.1_

- [x] 4.4 Register DNA Injection Service in dependency injection
  - Register service in `lib/core/di/injection.dart`
  - _Requirements: 16.2_

### 5. Emotion-to-Image Generation - Core Implementation

- [x] 5.1 Create Generation domain entities
  - Create `lib/features/emotion_to_image/domain/entities/generation_request.dart`
  - Create `lib/features/emotion_to_image/domain/entities/generation_result.dart`
  - Create `lib/features/emotion_to_image/domain/entities/emotion_data.dart`
  - Create `lib/features/emotion_to_image/domain/entities/generation_metadata.dart`
  - _Requirements: 9.1, 9.2_

- [x] 5.2 Migrate existing ImageGenerationService to data layer
  - Move `lib/services/image_generation_service.dart` to `lib/features/emotion_to_image/data/datasources/image_generation_datasource.dart`
  - Preserve existing Pollinations.ai integration (already working)
  - Preserve existing DummyJSON fallback (already working)
  - Preserve existing fallback strategy and circuit breaker logic
  - _Requirements: 9.4, 9.5, 9.6, 23.3_


- [x] 5.3 Integrate Transformers.js for emotion analysis
  - Add `flutter_js` or web view package for running JavaScript in Flutter
  - Create `lib/features/emotion_to_image/data/datasources/emotion_analysis_datasource.dart`
  - Integrate Transformers.js for client-side emotion detection from text
  - Implement `analyzeText(String text)` method returning emotion data with confidence scores
  - _Requirements: 9.7, 38.4_

- [x] 5.4 Create Generation Repository interface and implementation
  - Create `lib/features/emotion_to_image/domain/repositories/generation_repository.dart` (abstract)
  - Create `lib/features/emotion_to_image/data/repositories/generation_repository_impl.dart`
  - Implement methods: `generateImage()`, `getGenerationHistory()`, `saveGeneration()`, `deleteGeneration()`
  - Integrate DNA Injection Service to enhance prompts
  - Store generation history in local storage (Hive)
  - _Requirements: 9.1, 9.2, 9.8, 1.2_

- [ ]* 5.5 Write property test for API retry logic
  - **Property 7: API Retry with Exponential Backoff**
  - **Validates: Requirements 9.12, 10.12**
  - Test that failed API calls retry exactly 3 times with exponential backoff
  - Simulate API failures and verify retry behavior

- [ ]* 5.6 Write property test for API fallback mechanism
  - **Property 13: API Fallback Mechanism**
  - **Validates: Requirements 40.1**
  - Test that when primary API fails, system automatically attempts fallback API
  - Simulate primary API failures and verify fallback activation

- [x] 5.7 Implement Emotion-to-Image BLoC
  - Create `lib/features/emotion_to_image/presentation/bloc/emotion_to_image_bloc.dart`
  - Create event classes: `GenerateFromEmotionRequested`, `RetryGenerationRequested`
  - Create state classes: `EmotionToImageInitial`, `EmotionToImageGenerating`, `EmotionToImageSuccess`, `EmotionToImageError`
  - Implement event handlers with proper error handling
  - _Requirements: 3.1, 3.2, 9.9, 9.10, 9.11_

- [ ]* 5.8 Write property test for graceful error handling
  - **Property 5: Graceful Error Handling**
  - **Validates: Requirements 5.9, 15.2**
  - Test that all errors emit error states without crashing
  - Test network errors, API errors, data errors


- [x] 5.9 Register generation dependencies in service locator
  - Register ImageGenerationDataSource
  - Register EmotionAnalysisDataSource
  - Register GenerationRepository
  - Register EmotionToImageBloc as factory
  - _Requirements: 16.2_

### 6. Emotion-to-Image UI Implementation

- [x] 6.1 Create Emotion-to-Image screen
  - Create `lib/features/emotion_to_image/presentation/screens/emotion_to_image_screen.dart`
  - Use BlocProvider to inject EmotionToImageBloc
  - Use BlocBuilder for reactive UI updates
  - Display emotion input, generation preview, and history
  - _Requirements: 9.1, 3.6, 3.7_

- [x] 6.2 Build emotion input widget
  - Create `lib/features/emotion_to_image/presentation/widgets/emotion_input.dart`
  - Support text-based emotion input
  - Add quick emotion buttons (happy, sad, excited, calm, etc.)
  - Trigger generation on submit
  - _Requirements: 9.3_

- [x] 6.3 Build generation preview widget
  - Create `lib/features/emotion_to_image/presentation/widgets/generation_preview.dart`
  - Display loading state during generation
  - Show generated image with metadata
  - Add save and share buttons
  - _Requirements: 9.10, 15.1_

- [x] 6.4 Build generation history widget
  - Create `lib/features/emotion_to_image/presentation/widgets/generation_history.dart`
  - Display grid of previously generated images
  - Show prompt and timestamp for each generation
  - Support tap to view full image
  - _Requirements: 9.2_

- [x] 6.5 Implement error handling UI
  - Display error messages with retry button
  - Show API status (primary/fallback)
  - Handle offline state gracefully
  - _Requirements: 15.2, 15.3, 15.4_

- [ ] 6.6 Checkpoint - Test emotion-to-image feature
  - Test complete generation flow with various emotions
  - Verify DNA personalization is applied
  - Test error handling and retry logic
  - Verify 90%+ accuracy threshold
  - Ensure all tests pass, ask the user if questions arise


### 7. Style Learning and DNA Evolution

- [x] 7.1 Implement Style Learning Service
  - Create `lib/core/services/style_learning_service.dart`
  - Implement `recordStyleInteraction(String userId, String style, bool positive)` method
  - Implement `calculateStyleAffinity(String userId)` method
  - Update style scores based on user interactions (likes, regenerations, saves)
  - _Requirements: 8.3, 8.4_

- [x] 7.2 Add interaction tracking to generation UI
  - Track when user saves an image (positive signal)
  - Track when user regenerates (neutral/negative signal)
  - Track when user deletes (negative signal)
  - Update DNA profile based on interactions
  - _Requirements: 8.3_

- [ ]* 7.3 Write unit tests for Style Learning Service
  - Test style affinity calculation
  - Test interaction recording
  - Test DNA profile updates
  - _Requirements: 19.1_

- [x] 7.4 Register Style Learning Service in dependency injection
  - Register service in `lib/core/di/injection.dart`
  - Inject into DnaProfileCubit
  - _Requirements: 16.2_

### 8. Phase 1 Testing and Validation

- [x] 8.1 Run all automated tests
  - Run unit tests: `flutter test`
  - Verify code coverage meets 80%+ threshold
  - Fix any failing tests
  - _Requirements: 19.5, 42.3, 42.4_

- [-] 8.2 Measure feature accuracy
  - Test emotion-to-image generation with 100+ test cases
  - Measure accuracy of emotion detection
  - Measure accuracy of DNA personalization
  - Verify 90%+ accuracy threshold is met
  - Document accuracy metrics
  - _Requirements: 9.13, 39.1, 42.6, 42.7, 42.8_

- [x] 8.3 Test API resilience
  - Simulate API failures (network errors, timeouts)
  - Verify fallback strategy works correctly
  - Verify retry logic with exponential backoff
  - Verify graceful degradation
  - _Requirements: 9.12, 40.2, 40.3, 42.9, 42.10, 42.11_


- [x] 8.4 Performance testing
  - Measure app startup time (should be < 2 seconds)
  - Measure generation response time (should be < 5 seconds)
  - Profile memory usage
  - Optimize any performance bottlenecks
  - _Requirements: 21.1, 42.18, 42.19, 42.20_

- [x] 8.5 User acceptance testing
  - User performs manual testing of all features
  - User tests DNA onboarding flow
  - User tests emotion-to-image generation
  - User verifies personalization is working
  - Document user feedback
  - _Requirements: 41.32, 42.15, 42.16, 42.17_

- [x] 8.6 Fix bugs and polish UI
  - Address all issues found during testing
  - Polish animations and transitions
  - Improve error messages
  - Optimize UI responsiveness
  - _Requirements: 41.34_

- [x] 8.7 Final checkpoint - Phase 1 complete
  - All quality gates passed
  - 90%+ accuracy achieved
  - All tests passing
  - User approval obtained
  - Ready for Phase 2 (Firebase integration)

---

## PHASE 2: FIREBASE INTEGRATION (Week 5)

### 9. External Setup - Firebase Project (USER ACTION)

- [ ] 9.1 USER: Create Firebase project
  - Go to Firebase Console (https://console.firebase.google.com)
  - Create new project named "AURA Visual DNA"
  - Enable Google Analytics (optional)
  - _Requirements: 41.8_

- [ ] 9.2 USER: Add Flutter app to Firebase project
  - Add Android app with package name
  - Download `google-services.json` file
  - Add iOS app with bundle ID
  - Download `GoogleService-Info.plist` file
  - _Requirements: 41.9_

- [ ] 9.3 USER: Enable Firebase Authentication
  - Go to Authentication section in Firebase Console
  - Enable Email/Password authentication
  - Enable Google Sign-In authentication
  - Enable Apple Sign-In authentication (for iOS)
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 41.11_


- [ ] 9.4 USER: Enable Firestore Database
  - Go to Firestore Database section
  - Create database in production mode
  - Choose database location (closest to users)
  - _Requirements: 5.1, 41.10_

- [ ] 9.5 USER: Enable Firebase Storage
  - Go to Storage section
  - Enable Firebase Storage
  - Choose storage location
  - _Requirements: 6.1, 41.10_

- [ ] 9.6 USER: Provide Firebase configuration files
  - Share `google-services.json` file with developer
  - Share `GoogleService-Info.plist` file with developer
  - _Requirements: 41.9_

### 10. Firebase Configuration in Flutter App

- [ ] 10.1 Add Firebase packages to pubspec.yaml
  - Add `firebase_core`
  - Add `firebase_auth`
  - Add `cloud_firestore`
  - Add `firebase_storage`
  - Add `firebase_analytics`
  - Add `firebase_crashlytics`
  - _Requirements: 4.1, 5.1, 6.1, 22.1, 22.3_

- [ ] 10.2 Configure Firebase in Android
  - Place `google-services.json` in `android/app/` directory
  - Update `android/build.gradle` with Google services plugin
  - Update `android/app/build.gradle` with Firebase dependencies
  - _Requirements: 20.1, 20.2, 41.13_

- [ ] 10.3 Configure Firebase in iOS
  - Place `GoogleService-Info.plist` in `ios/Runner/` directory
  - Update `ios/Podfile` with Firebase pods
  - Run `pod install` in ios directory
  - _Requirements: 20.1, 20.2, 41.13_

- [ ] 10.4 Initialize Firebase in main.dart
  - Import `firebase_core`
  - Call `Firebase.initializeApp()` before runApp()
  - Handle initialization errors
  - _Requirements: 41.14, 41.15_

- [ ] 10.5 Test Firebase connection
  - Run app on Android device/emulator
  - Run app on iOS device/simulator
  - Verify Firebase initialization succeeds
  - Check Firebase Console for app connection
  - _Requirements: 41.17_


### 11. Authentication Implementation

- [ ] 11.1 Create User domain entity
  - Create `lib/features/authentication/domain/entities/user.dart`
  - Define User class with: id, email, displayName, photoUrl, role, createdAt, lastLoginAt
  - Define UserRole enum: regular, pro, moderator, admin, superAdmin
  - _Requirements: 4.1_

- [ ] 11.2 Create User data model
  - Create `lib/features/authentication/data/models/user_model.dart`
  - Implement `fromJson()`, `toJson()`, `fromFirestore()`, `toFirestore()` methods
  - _Requirements: 4.1_

- [ ]* 11.3 Write property test for User model serialization
  - **Property 11: Data Serialization Round-Trip**
  - **Validates: Requirements 19.6**
  - Test User model serialization round-trip

- [ ] 11.4 Implement Authentication Remote Data Source
  - Create `lib/features/authentication/data/datasources/auth_remote_datasource.dart`
  - Implement `signInWithGoogle()` using Firebase Auth
  - Implement `signInWithApple()` using Firebase Auth
  - Implement `signInWithEmail(email, password)` using Firebase Auth
  - Implement `signUpWithEmail(email, password)` using Firebase Auth
  - Implement `signOut()` using Firebase Auth
  - Implement `getCurrentUser()` using Firebase Auth
  - Implement `authStateChanges` stream
  - _Requirements: 4.2, 4.3, 4.4_

- [ ] 11.5 Create Authentication Repository interface and implementation
  - Create `lib/features/authentication/domain/repositories/auth_repository.dart` (abstract)
  - Create `lib/features/authentication/data/repositories/auth_repository_impl.dart`
  - Implement all authentication methods
  - Handle errors and convert to Failures
  - _Requirements: 4.7, 1.2_

- [ ]* 11.6 Write property test for authentication token storage
  - **Property 2: Authentication Token Storage**
  - **Validates: Requirements 4.5**
  - Test that successful authentication stores token securely

- [ ]* 11.7 Write property test for authentication data cleanup
  - **Property 3: Authentication Data Cleanup**
  - **Validates: Requirements 4.6**
  - Test that logout clears all authentication data


- [ ] 11.8 Implement Authentication BLoC
  - Create `lib/features/authentication/presentation/bloc/auth_bloc.dart`
  - Create event classes: `SignInWithGoogleRequested`, `SignInWithAppleRequested`, `SignInWithEmailRequested`, `SignUpWithEmailRequested`, `SignOutRequested`, `AuthStatusChecked`
  - Create state classes: `AuthInitial`, `AuthLoading`, `AuthAuthenticated`, `AuthUnauthenticated`, `AuthError`
  - Implement event handlers
  - Subscribe to auth state changes stream
  - _Requirements: 3.1, 3.2, 4.8_

- [ ]* 11.9 Write property test for loading state emission
  - **Property 10: Loading State Emission**
  - **Validates: Requirements 15.1**
  - Test that all async operations emit loading state first

- [ ] 11.10 Register authentication dependencies
  - Register FirebaseAuth instance
  - Register AuthRemoteDataSource
  - Register AuthRepository
  - Register AuthBloc as factory
  - _Requirements: 16.2_

### 12. Authentication UI Implementation

- [ ] 12.1 Create login screen
  - Create `lib/features/authentication/presentation/screens/login_screen.dart`
  - Add email/password input fields
  - Add Google Sign-In button
  - Add Apple Sign-In button (iOS only)
  - Add "Sign Up" navigation link
  - Use BlocProvider and BlocBuilder
  - _Requirements: 4.2, 4.3, 4.4_

- [ ] 12.2 Create signup screen
  - Create `lib/features/authentication/presentation/screens/signup_screen.dart`
  - Add email/password input fields with validation
  - Add password confirmation field
  - Add "Login" navigation link
  - _Requirements: 4.4_

- [ ] 12.3 Create social login button widget
  - Create `lib/features/authentication/presentation/widgets/social_login_button.dart`
  - Reusable button for Google/Apple sign-in
  - Show provider logo and text
  - _Requirements: 4.2, 4.3_

- [ ] 12.4 Create auth form widget
  - Create `lib/features/authentication/presentation/widgets/auth_form.dart`
  - Reusable form for email/password input
  - Include validation logic
  - _Requirements: 4.4_


- [ ] 12.5 Update routing with authentication guards
  - Update `lib/core/routing/router.dart`
  - Add redirect logic based on auth state
  - Redirect unauthenticated users to login
  - Redirect authenticated users away from auth screens
  - _Requirements: 17.4, 17.5_

- [ ] 12.6 Implement authentication error handling UI
  - Display error messages for failed authentication
  - Show loading indicators during auth operations
  - Handle network errors gracefully
  - _Requirements: 15.1, 15.2, 15.3_

- [ ] 12.7 Checkpoint - Test authentication flow
  - Test Google Sign-In on Android and iOS
  - Test Apple Sign-In on iOS
  - Test Email/Password sign-up and login
  - Test sign-out functionality
  - Verify route guards work correctly
  - Ensure all tests pass, ask the user if questions arise

### 13. Firestore Integration for DNA Profiles

- [ ] 13.1 Implement DNA Remote Data Source
  - Create `lib/features/visual_dna_engine/data/datasources/dna_remote_datasource.dart`
  - Implement `getDnaProfile(userId)` using Firestore
  - Implement `updateDnaProfile(profile)` using Firestore
  - Implement `updateColorPreferences(userId, prefs)` using Firestore
  - Implement `updateStyleAffinity(userId, affinity)` using Firestore
  - Implement `updateEmotionalSignature(userId, signature)` using Firestore
  - Implement `watchDnaProfile(userId)` stream using Firestore snapshots
  - _Requirements: 5.2, 5.3, 5.6, 5.7_

- [ ] 13.2 Update DNA Repository for cloud sync
  - Update `lib/features/visual_dna_engine/data/repositories/dna_repository_impl.dart`
  - Check network connectivity before operations
  - If online: use remote data source and cache locally
  - If offline: use local data source
  - Implement sync logic for offline changes
  - _Requirements: 5.1, 5.6, 14.1, 14.4, 14.5_

- [ ]* 13.3 Write property test for DNA profile sync
  - **Property 4: DNA Profile Sync**
  - **Validates: Requirements 5.6, 8.3**
  - Test that DNA modifications are persisted to data store


- [ ]* 13.4 Write property test for offline data access
  - **Property 8: Offline Data Access**
  - **Validates: Requirements 14.4**
  - Test that data requests return cached data when offline

- [ ]* 13.5 Write property test for offline sync on reconnection
  - **Property 9: Offline Sync on Reconnection**
  - **Validates: Requirements 14.5**
  - Test that offline changes sync when network is restored

- [ ] 13.6 Update DNA Profile Cubit for real-time updates
  - Update `lib/features/visual_dna_engine/presentation/cubit/dna_profile_cubit.dart`
  - Use `watchDnaProfile()` stream for real-time updates
  - Handle stream errors
  - _Requirements: 5.7_

- [ ] 13.7 Add offline indicator to DNA UI
  - Show offline badge when network unavailable
  - Indicate when data is from cache
  - Show sync status
  - _Requirements: 14.6_

- [ ] 13.8 Register network info and remote data source
  - Register NetworkInfo in dependency injection
  - Register DnaRemoteDataSource
  - Update DnaRepository registration
  - _Requirements: 16.2_

### 14. Firebase Storage Integration

- [ ] 14.1 Implement Storage Data Source
  - Create `lib/core/data/datasources/storage_datasource.dart`
  - Implement `uploadImage(File image, String path)` using Firebase Storage
  - Implement `getDownloadUrl(String path)` using Firebase Storage
  - Implement `deleteImage(String path)` using Firebase Storage
  - Implement retry logic (3 attempts) for uploads
  - _Requirements: 6.2, 6.3, 6.4, 6.6_

- [ ]* 14.2 Write property test for upload retry logic
  - **Property 6: Upload Retry Logic**
  - **Validates: Requirements 6.6**
  - Test that failed uploads retry exactly 3 times

- [ ] 14.3 Update Generation Repository for cloud storage
  - Update `lib/features/emotion_to_image/data/repositories/generation_repository_impl.dart`
  - Save generated images to Firebase Storage
  - Store generation metadata in Firestore
  - Generate secure download URLs
  - _Requirements: 6.2, 6.5_


- [ ] 14.4 Implement generation history sync
  - Store generation history in Firestore collection
  - Implement `watchGenerationHistory(userId)` stream
  - Sync local history with cloud
  - _Requirements: 5.2, 5.3_

- [ ] 14.5 Update Generation UI for cloud sync
  - Update generation history to use Firestore stream
  - Show sync status
  - Handle offline state
  - _Requirements: 14.6_

- [ ] 14.6 Register storage dependencies
  - Register FirebaseStorage instance
  - Register StorageDataSource
  - Update GenerationRepository registration
  - _Requirements: 16.2_

### 15. Backend API Setup (Firebase Cloud Functions)

- [ ] 15.1 Initialize Firebase Cloud Functions project
  - Run `firebase init functions` in project root
  - Choose TypeScript as language
  - Set up project structure: `functions/src/`
  - _Requirements: 24.7_

- [ ] 15.2 Set up Express server in Cloud Functions
  - Install express, cors, helmet packages
  - Create `functions/src/index.ts` with Express app
  - Configure CORS and security middleware
  - _Requirements: 24.7_

- [ ] 15.3 Implement authentication middleware
  - Create `functions/src/middleware/auth.ts`
  - Verify Firebase ID tokens using Admin SDK
  - Extract user ID and custom claims
  - Return 401 for invalid tokens
  - _Requirements: 24.4_

- [ ] 15.4 Implement rate limiting middleware
  - Create `functions/src/middleware/rate-limiter.ts`
  - Limit to 100 requests per minute per user
  - Return 429 for rate limit exceeded
  - _Requirements: 24.5_

- [ ] 15.5 Implement input validation middleware
  - Create `functions/src/middleware/validator.ts`
  - Use express-validator for request validation
  - Validate all request payloads
  - Return 400 for invalid input
  - _Requirements: 24.6_


- [ ] 15.6 Create API endpoints for DNA operations
  - Create `functions/src/api/dna/get-profile.ts`
  - Create `functions/src/api/dna/update-profile.ts`
  - Create `functions/src/api/dna/calculate-score.ts`
  - Use Admin SDK for Firestore operations
  - Apply authentication and rate limiting middleware
  - _Requirements: 24.2, 24.4, 24.5_

- [ ] 15.7 Create API endpoints for generation operations
  - Create `functions/src/api/generation/generate-image.ts`
  - Create `functions/src/api/generation/get-history.ts`
  - Create `functions/src/api/generation/save-generation.ts`
  - Use Admin SDK for Firestore and Storage operations
  - _Requirements: 24.2_

- [ ] 15.8 Create API endpoints for storage operations
  - Create `functions/src/api/storage/upload-image.ts`
  - Create `functions/src/api/storage/get-signed-url.ts`
  - Use Admin SDK for Storage operations
  - _Requirements: 24.2_

- [ ] 15.9 Deploy Cloud Functions
  - Run `firebase deploy --only functions`
  - Verify functions are deployed successfully
  - Test endpoints with Postman or curl
  - _Requirements: 24.7_

### 16. Firebase Security Rules

- [ ] 16.1 Create Firestore security rules
  - Create `firestore.rules` file
  - Deny all direct client read/write access
  - Allow access only from Admin SDK (backend)
  - _Requirements: 25.1, 25.2_

- [ ] 16.2 Create Storage security rules
  - Create `storage.rules` file
  - Deny all direct client uploads
  - Allow access only from Admin SDK (backend)
  - _Requirements: 25.3, 25.4_

- [ ] 16.3 Test security rules with Firebase Emulator
  - Run `firebase emulators:start`
  - Test that client SDK cannot access Firestore directly
  - Test that client SDK cannot upload to Storage directly
  - Verify backend API can access Firebase services
  - _Requirements: 25.7_

- [ ] 16.4 Deploy security rules
  - Run `firebase deploy --only firestore:rules`
  - Run `firebase deploy --only storage:rules`
  - Verify rules are active in Firebase Console
  - _Requirements: 25.1, 25.2, 25.3, 25.4_


### 17. Update Flutter App to Use Backend API

- [ ] 17.1 Create API client for backend
  - Create `lib/core/network/api_client.dart`
  - Configure base URL for Cloud Functions
  - Add authentication headers (Firebase ID token)
  - Implement error handling
  - _Requirements: 24.1_

- [ ] 17.2 Update data sources to use backend API
  - Update DnaRemoteDataSource to call backend endpoints
  - Update GenerationRepository to call backend endpoints
  - Update StorageDataSource to call backend endpoints
  - Remove direct Firebase SDK calls from data sources
  - _Requirements: 24.1, 24.8_

- [ ] 17.3 Test end-to-end flow with backend
  - Test authentication flow
  - Test DNA profile operations through backend
  - Test image generation through backend
  - Test storage operations through backend
  - Verify security rules prevent direct access
  - _Requirements: 24.8_

### 18. Phase 2 Testing and Deployment

- [ ] 18.1 Run all automated tests
  - Run unit tests
  - Run widget tests
  - Run integration tests
  - Verify code coverage
  - _Requirements: 19.1, 19.2, 19.5_

- [ ] 18.2 Test authentication flows
  - Test all sign-in methods (Google, Apple, Email)
  - Test sign-out
  - Test token refresh
  - Test authentication errors
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.6_

- [ ] 18.3 Test data synchronization
  - Test DNA profile sync across devices
  - Test generation history sync
  - Test offline-first capability
  - Test conflict resolution
  - _Requirements: 5.6, 5.7, 14.4, 14.5_

- [ ] 18.4 Test security
  - Verify client cannot access Firestore directly
  - Verify client cannot upload to Storage directly
  - Test rate limiting
  - Test input validation
  - _Requirements: 25.1, 25.2, 25.3, 25.4, 24.5, 24.6_


- [ ] 18.5 User acceptance testing
  - User tests authentication on multiple devices
  - User tests data sync across devices
  - User tests offline functionality
  - User verifies all features work with Firebase
  - _Requirements: 41.32, 42.15_

- [ ] 18.6 Deploy to staging environment
  - Configure staging Firebase project
  - Deploy backend to staging
  - Build and deploy Flutter app to staging
  - Run smoke tests
  - _Requirements: 20.1, 20.2, 20.3, 41.38_

- [ ] 18.7 Final checkpoint - Phase 2 complete
  - All Firebase services integrated
  - Authentication working
  - Cloud sync working
  - Security rules enforced
  - User approval obtained
  - Ready for Phase 3 (Advanced features)

---

## PHASE 3: ADVANCED FEATURES (Weeks 6-8)

### 19. Memory Transformer - Foundation

- [ ] 19.1 Create Memory domain entities
  - Create `lib/features/memory_transformer/domain/entities/memory.dart`
  - Create `lib/features/memory_transformer/domain/entities/transformation.dart`
  - Define Memory class with: id, userId, imageUrl, uploadedAt, colorPalette, composition
  - Define Transformation class with: id, memoryId, style, transformedImageUrl, createdAt
  - _Requirements: 10.1, 10.2_

- [ ] 19.2 Create Memory data models
  - Create `lib/features/memory_transformer/data/models/memory_model.dart`
  - Create `lib/features/memory_transformer/data/models/transformation_model.dart`
  - Implement serialization methods
  - _Requirements: 10.1_

- [ ]* 19.3 Write property test for Memory model serialization
  - **Property 11: Data Serialization Round-Trip**
  - **Validates: Requirements 19.6**
  - Test Memory and Transformation model serialization

- [ ] 19.4 Integrate Vibrant.js for color extraction
  - Add web view or JavaScript bridge package
  - Create `lib/features/memory_transformer/data/datasources/color_analysis_datasource.dart`
  - Implement `extractColorPalette(File image)` using Vibrant.js
  - Return dominant colors as hex codes
  - _Requirements: 10.3, 38.5_


- [ ] 19.5 Integrate TensorFlow.js for composition analysis
  - Create `lib/features/memory_transformer/data/datasources/composition_analysis_datasource.dart`
  - Implement `analyzeComposition(File image)` using TensorFlow.js models
  - Extract composition features (symmetry, focal points, rule of thirds)
  - _Requirements: 10.4, 38.6_

- [ ] 19.6 Implement image upload functionality
  - Create `lib/features/memory_transformer/data/datasources/image_upload_datasource.dart`
  - Implement image picker integration
  - Implement image compression
  - Upload to Firebase Storage via backend API
  - _Requirements: 10.2_

- [ ] 19.7 Implement transformation data source
  - Create `lib/features/memory_transformer/data/datasources/transformation_datasource.dart`
  - Use Pollinations.ai for image-to-image transformation (primary)
  - Use DummyJSON as fallback
  - Implement circuit breaker and retry logic
  - _Requirements: 10.7, 10.8, 10.9_

- [ ] 19.8 Create Memory Repository interface and implementation
  - Create `lib/features/memory_transformer/domain/repositories/memory_repository.dart` (abstract)
  - Create `lib/features/memory_transformer/data/repositories/memory_repository_impl.dart`
  - Implement methods: `uploadMemory()`, `transformMemory()`, `getMemories()`, `deleteMemory()`
  - Integrate color extraction and composition analysis
  - Apply DNA preferences to transformations
  - _Requirements: 10.1, 10.2, 10.5, 10.6, 1.2_

- [ ]* 19.9 Write unit tests for Memory Repository
  - Test image upload flow
  - Test transformation with DNA preferences
  - Test color extraction
  - Test composition analysis
  - Test error handling
  - _Requirements: 19.1, 19.3_

- [ ] 19.10 Implement Memory Transformer BLoC
  - Create `lib/features/memory_transformer/presentation/bloc/memory_transformer_bloc.dart`
  - Create events: `UploadMemoryRequested`, `TransformMemoryRequested`, `LoadMemoriesRequested`, `DeleteMemoryRequested`
  - Create states: `MemoryTransformerInitial`, `MemoryUploading`, `MemoryUploaded`, `MemoryTransforming`, `TransformationSuccess`, `MemoriesLoaded`, `MemoryTransformerError`
  - Implement event handlers
  - _Requirements: 3.1, 3.2, 10.10_


- [ ] 19.11 Register memory transformer dependencies
  - Register all data sources
  - Register MemoryRepository
  - Register MemoryTransformerBloc as factory
  - _Requirements: 16.2_

### 20. Memory Transformer UI Implementation

- [ ] 20.1 Create Memory Transformer screen
  - Create `lib/features/memory_transformer/presentation/screens/memory_transformer_screen.dart`
  - Use BlocProvider and BlocBuilder
  - Display upload button, style selector, transformation result
  - _Requirements: 10.1, 3.6, 3.7_

- [ ] 20.2 Build image picker widget
  - Create `lib/features/memory_transformer/presentation/widgets/image_picker_widget.dart`
  - Support camera and gallery selection
  - Show image preview after selection
  - Trigger upload on confirmation
  - _Requirements: 10.2_

- [ ] 20.3 Build style selector widget
  - Create `lib/features/memory_transformer/presentation/widgets/style_selector.dart`
  - Display available artistic styles (impressionist, watercolor, oil painting, sketch, etc.)
  - Highlight DNA-preferred styles
  - Allow style selection
  - _Requirements: 10.5, 10.6_

- [ ] 20.4 Build transformation result widget
  - Create `lib/features/memory_transformer/presentation/widgets/transformation_result.dart`
  - Display original and transformed images side-by-side
  - Show color palette extracted
  - Show composition analysis
  - Add save and share buttons
  - _Requirements: 10.3, 10.4, 10.11_

- [ ] 20.5 Implement loading and error states
  - Show upload progress indicator
  - Show transformation progress
  - Display error messages with retry
  - Handle API failures gracefully
  - _Requirements: 15.1, 15.2, 15.3_

- [ ] 20.6 Test Memory Transformer accuracy
  - Test with 100+ photos
  - Verify color extraction accuracy
  - Verify composition analysis accuracy
  - Verify transformation quality
  - Ensure 90%+ accuracy threshold
  - _Requirements: 10.13, 39.1_


- [ ] 20.7 Checkpoint - Test Memory Transformer feature
  - Test complete upload and transformation flow
  - Test multiple artistic styles
  - Test DNA personalization
  - Test error handling and fallback
  - Ensure all tests pass, ask the user if questions arise

### 21. Dream Studio - Foundation

- [ ] 21.1 Create Dream domain entities
  - Create `lib/features/dream_studio/domain/entities/dream_entry.dart`
  - Define DreamEntry class with: id, userId, description, visualizationUrl, keywords, createdAt
  - _Requirements: 11.1, 11.8_

- [ ] 21.2 Create Dream data models
  - Create `lib/features/dream_studio/data/models/dream_entry_model.dart`
  - Implement serialization methods
  - _Requirements: 11.8_

- [ ]* 21.3 Write property test for Dream model serialization
  - **Property 11: Data Serialization Round-Trip**
  - **Validates: Requirements 19.6**
  - Test DreamEntry model serialization

- [ ] 21.4 Integrate Web Speech API for voice input
  - Add speech recognition package (speech_to_text)
  - Create `lib/features/dream_studio/data/datasources/voice_recognition_datasource.dart`
  - Implement `transcribeVoice()` using Web Speech API (primary)
  - Use Google Speech-to-Text free tier as fallback (60 min/month)
  - _Requirements: 11.3, 11.4, 38.7_

- [ ] 21.5 Integrate Transformers.js for text analysis
  - Create `lib/features/dream_studio/data/datasources/text_analysis_datasource.dart`
  - Implement `extractKeywords(String text)` using Transformers.js
  - Extract key themes and emotions from dream descriptions
  - _Requirements: 11.7, 38.4_

- [ ] 21.6 Implement dream visualization data source
  - Create `lib/features/dream_studio/data/datasources/dream_visualization_datasource.dart`
  - Use Pollinations.ai for dream visualization (primary)
  - Use DummyJSON as fallback
  - Implement circuit breaker and retry logic
  - _Requirements: 11.5, 11.6, 11.12_


- [ ] 21.7 Create Dream Repository interface and implementation
  - Create `lib/features/dream_studio/domain/repositories/dream_repository.dart` (abstract)
  - Create `lib/features/dream_studio/data/repositories/dream_repository_impl.dart`
  - Implement methods: `createDreamEntry()`, `visualizeDream()`, `getDreamLibrary()`, `deleteDreamEntry()`, `watchDreamLibrary()`
  - Store dream entries in Firestore
  - Apply DNA preferences to visualizations
  - _Requirements: 11.2, 11.8, 11.9, 11.11, 1.2_

- [ ]* 21.8 Write unit tests for Dream Repository
  - Test dream entry creation
  - Test voice transcription
  - Test text analysis
  - Test dream visualization with DNA
  - Test error handling
  - _Requirements: 19.1, 19.3_

- [ ] 21.9 Implement Dream Studio BLoC
  - Create `lib/features/dream_studio/presentation/bloc/dream_studio_bloc.dart`
  - Create events: `CreateDreamEntryRequested`, `VisualizeDreamRequested`, `LoadDreamLibraryRequested`, `DeleteDreamEntryRequested`, `StartVoiceRecordingRequested`, `StopVoiceRecordingRequested`
  - Create states: `DreamStudioInitial`, `DreamStudioLoading`, `VoiceRecording`, `DreamEntryCreated`, `DreamVisualized`, `DreamLibraryLoaded`, `DreamStudioError`
  - Implement event handlers
  - _Requirements: 3.1, 3.2, 11.10_

- [ ] 21.10 Register dream studio dependencies
  - Register all data sources
  - Register DreamRepository
  - Register DreamStudioBloc as factory
  - _Requirements: 16.2_

### 22. Dream Studio UI Implementation

- [ ] 22.1 Create Dream Studio screen
  - Create `lib/features/dream_studio/presentation/screens/dream_studio_screen.dart`
  - Use BlocProvider and BlocBuilder
  - Display text input, voice button, visualization preview
  - _Requirements: 11.1, 3.6, 3.7_

- [ ] 22.2 Build voice input button widget
  - Create `lib/features/dream_studio/presentation/widgets/voice_input_button.dart`
  - Show recording animation when active
  - Display transcribed text in real-time
  - Handle voice recognition errors
  - _Requirements: 11.3_


- [ ] 22.3 Build dream description input widget
  - Create `lib/features/dream_studio/presentation/widgets/dream_description_input.dart`
  - Multi-line text input for dream descriptions
  - Character counter
  - Submit button
  - _Requirements: 11.2_

- [ ] 22.4 Create Dream Library screen
  - Create `lib/features/dream_studio/presentation/screens/dream_library_screen.dart`
  - Display grid of dream entries
  - Show thumbnail, date, and keywords
  - Support tap to view full dream
  - _Requirements: 11.11_

- [ ] 22.5 Build dream card widget
  - Create `lib/features/dream_studio/presentation/widgets/dream_card.dart`
  - Display dream visualization thumbnail
  - Show creation date and keywords
  - Add delete button
  - _Requirements: 11.11_

- [ ] 22.6 Implement loading and error states
  - Show recording indicator
  - Show visualization progress
  - Display error messages with retry
  - Handle voice recognition failures
  - _Requirements: 15.1, 15.2, 15.3_

- [ ] 22.7 Test Dream Studio accuracy
  - Test with 100+ dream descriptions
  - Verify voice transcription accuracy
  - Verify keyword extraction accuracy
  - Verify visualization quality
  - Ensure 90%+ accuracy threshold
  - _Requirements: 11.14, 39.1_

- [ ] 22.8 Checkpoint - Test Dream Studio feature
  - Test text-based dream input
  - Test voice-based dream input
  - Test dream visualization with DNA
  - Test dream library
  - Test error handling and fallback
  - Ensure all tests pass, ask the user if questions arise

### 23. Living Art Evolution

- [ ] 23.1 Create Evolution domain entities
  - Create `lib/features/living_art/domain/entities/evolution_report.dart`
  - Define EvolutionReport class with: userId, period, styleChanges, colorShifts, emotionalTrends, generatedAt
  - _Requirements: 12.1, 12.5_


- [ ] 23.2 Create Evolution data models
  - Create `lib/features/living_art/data/models/evolution_report_model.dart`
  - Implement serialization methods
  - _Requirements: 12.5_

- [ ]* 23.3 Write property test for Evolution model serialization
  - **Property 11: Data Serialization Round-Trip**
  - **Validates: Requirements 19.6**
  - Test EvolutionReport model serialization

- [ ] 23.4 Implement evolution calculation service
  - Create `lib/features/living_art/data/datasources/evolution_datasource.dart`
  - Analyze user interactions over past month
  - Calculate style evolution metrics (style preference changes, color palette shifts, emotional pattern changes)
  - Generate evolution report
  - _Requirements: 12.2, 12.3_

- [ ] 23.5 Create Evolution Repository interface and implementation
  - Create `lib/features/living_art/domain/repositories/evolution_repository.dart` (abstract)
  - Create `lib/features/living_art/data/repositories/evolution_repository_impl.dart`
  - Implement methods: `calculateStyleEvolution()`, `generateEvolutionReport()`, `getEvolutionHistory()`
  - Store evolution reports in Firestore
  - _Requirements: 12.1, 12.5, 1.2_

- [ ]* 23.6 Write unit tests for Evolution Repository
  - Test evolution calculation
  - Test report generation
  - Test DNA profile updates
  - _Requirements: 19.1_

- [ ] 23.7 Implement Living Art Cubit
  - Create `lib/features/living_art/presentation/cubit/living_art_cubit.dart`
  - Create states: `LivingArtInitial`, `LivingArtLoading`, `EvolutionReportGenerated`, `LivingArtError`
  - Implement methods: `generateEvolutionReport()`, `loadEvolutionHistory()`
  - _Requirements: 3.1, 3.3, 12.6_

- [ ] 23.8 Implement background job scheduling
  - Use workmanager package for background tasks
  - Schedule monthly evolution calculation
  - Trigger evolution report generation
  - Send notification to user when report is ready
  - _Requirements: 12.7_

- [ ] 23.9 Register living art dependencies
  - Register EvolutionDataSource
  - Register EvolutionRepository
  - Register LivingArtCubit as factory
  - _Requirements: 16.2_


### 24. Living Art UI Implementation

- [ ] 24.1 Create Evolution Report screen
  - Create `lib/features/living_art/presentation/screens/evolution_report_screen.dart`
  - Use BlocProvider and BlocBuilder
  - Display evolution metrics and visualizations
  - _Requirements: 12.5, 3.6, 3.7_

- [ ] 24.2 Build evolution chart widget
  - Create `lib/features/living_art/presentation/widgets/evolution_chart.dart`
  - Display style preference changes over time (line chart)
  - Display color palette shifts (color bars)
  - Display emotional trend analysis (radar chart)
  - Use charts_flutter or fl_chart package
  - _Requirements: 12.5_

- [ ] 24.3 Implement loading and error states
  - Show loading indicator during report generation
  - Display error messages
  - Handle missing data gracefully
  - _Requirements: 15.1, 15.2_

- [ ] 24.4 Checkpoint - Test Living Art feature
  - Test evolution calculation with sample data
  - Test report generation
  - Test background job scheduling
  - Test evolution visualization
  - Ensure all tests pass, ask the user if questions arise

### 25. Collaborative Universe

- [ ] 25.1 Create Collaboration domain entities
  - Create `lib/features/collaborative_universe/domain/entities/collaboration.dart`
  - Create `lib/features/collaborative_universe/domain/entities/merged_dna.dart`
  - Define Collaboration class with: id, initiatorId, partnerId, status, createdAt
  - Define MergedDna class with: collaborationId, mergedColorPreferences, mergedStyleAffinity, mergedEmotionalSignature
  - _Requirements: 13.1, 13.2, 13.4_

- [ ] 25.2 Create Collaboration data models
  - Create `lib/features/collaborative_universe/data/models/collaboration_model.dart`
  - Create `lib/features/collaborative_universe/data/models/merged_dna_model.dart`
  - Implement serialization methods
  - _Requirements: 13.5_

- [ ]* 25.3 Write property test for Collaboration model serialization
  - **Property 11: Data Serialization Round-Trip**
  - **Validates: Requirements 19.6**
  - Test Collaboration and MergedDna model serialization


- [ ] 25.4 Implement DNA merging algorithm
  - Create `lib/core/services/dna_merging_service.dart`
  - Implement `mergeDnaProfiles(DnaProfile profile1, DnaProfile profile2)` method
  - Merge color preferences (weighted average of favorite colors)
  - Merge style affinities (combine top styles from both profiles)
  - Merge emotional signatures (blend emotion frequencies)
  - _Requirements: 13.3, 13.4_

- [ ] 25.5 Integrate Firebase Dynamic Links
  - Add firebase_dynamic_links package
  - Create `lib/core/services/dynamic_links_service.dart`
  - Implement `createCollaborationInviteLink(String collaborationId)` method
  - Implement `handleDynamicLink(Uri link)` method
  - Handle links when app is closed, backgrounded, or active
  - _Requirements: 7.1, 7.2, 7.3, 7.4, 13.7_

- [ ] 25.6 Create Collaboration Repository interface and implementation
  - Create `lib/features/collaborative_universe/domain/repositories/collaboration_repository.dart` (abstract)
  - Create `lib/features/collaborative_universe/data/repositories/collaboration_repository_impl.dart`
  - Implement methods: `sendCollaborationInvite()`, `acceptCollaboration()`, `mergeDnaProfiles()`, `generateCollaborativeArtwork()`, `getCollaborations()`
  - Store collaboration data in Firestore
  - _Requirements: 13.2, 13.3, 13.4, 13.5, 1.2_

- [ ]* 25.7 Write unit tests for Collaboration Repository
  - Test invitation sending
  - Test invitation acceptance
  - Test DNA merging
  - Test collaborative artwork generation
  - _Requirements: 19.1_

- [ ] 25.8 Implement Collaborative Universe BLoC
  - Create `lib/features/collaborative_universe/presentation/bloc/collaborative_universe_bloc.dart`
  - Create events: `SendInviteRequested`, `AcceptInviteRequested`, `GenerateCollaborativeArtworkRequested`, `LoadCollaborationsRequested`
  - Create states: `CollaborativeUniverseInitial`, `CollaborativeUniverseLoading`, `InviteSent`, `InviteAccepted`, `CollaborativeArtworkGenerated`, `CollaborationsLoaded`, `CollaborativeUniverseError`
  - Implement event handlers
  - _Requirements: 3.1, 3.2, 13.6_

- [ ] 25.9 Register collaborative universe dependencies
  - Register DnaMergingService
  - Register DynamicLinksService
  - Register CollaborationRepository
  - Register CollaborativeUniverseBloc as factory
  - _Requirements: 16.2_


### 26. Collaborative Universe UI Implementation

- [ ] 26.1 Create Collaborative Universe screen
  - Create `lib/features/collaborative_universe/presentation/screens/collaborative_universe_screen.dart`
  - Use BlocProvider and BlocBuilder
  - Display collaboration list, invite button, merged artwork
  - _Requirements: 13.1, 3.6, 3.7_

- [ ] 26.2 Build collaboration invite widget
  - Create `lib/features/collaborative_universe/presentation/widgets/collaboration_invite.dart`
  - Display partner selection (from contacts or user search)
  - Generate and share Dynamic Link
  - Show invitation status
  - _Requirements: 13.2, 13.7_

- [ ] 26.3 Build merged artwork display widget
  - Create `lib/features/collaborative_universe/presentation/widgets/merged_artwork_display.dart`
  - Display collaborative artwork
  - Show both users' DNA influence
  - Add save and share buttons
  - _Requirements: 13.4_

- [ ] 26.4 Implement Dynamic Link handling
  - Listen for incoming Dynamic Links
  - Parse collaboration invitation links
  - Navigate to collaboration acceptance screen
  - Handle link errors
  - _Requirements: 7.3, 7.4_

- [ ] 26.5 Implement loading and error states
  - Show loading during invitation sending
  - Show loading during DNA merging
  - Display error messages
  - Handle network errors
  - _Requirements: 15.1, 15.2_

- [ ] 26.6 Checkpoint - Test Collaborative Universe feature
  - Test invitation sending and acceptance
  - Test DNA merging algorithm
  - Test collaborative artwork generation
  - Test Dynamic Links on multiple devices
  - Ensure all tests pass, ask the user if questions arise

### 27. Phase 3 Testing and Validation

- [ ] 27.1 Run all automated tests
  - Run unit tests for all new features
  - Run widget tests
  - Run integration tests
  - Verify code coverage
  - _Requirements: 19.1, 19.2, 19.5_


- [ ] 27.2 Test feature accuracy for all advanced features
  - Test Memory Transformer accuracy (90%+ threshold)
  - Test Dream Studio accuracy (90%+ threshold)
  - Test Living Art evolution accuracy
  - Test Collaborative Universe DNA merging
  - Document accuracy metrics
  - _Requirements: 10.13, 11.14, 39.1_

- [ ] 27.3 Test API resilience for all features
  - Simulate API failures for each feature
  - Verify fallback strategies work
  - Verify retry logic
  - Verify graceful degradation
  - _Requirements: 40.2, 40.3, 40.7_

- [ ] 27.4 Performance testing
  - Test image upload and transformation performance
  - Test voice recognition latency
  - Test evolution calculation performance
  - Optimize bottlenecks
  - _Requirements: 21.1, 42.18_

- [ ] 27.5 User acceptance testing
  - User tests Memory Transformer
  - User tests Dream Studio
  - User tests Living Art evolution
  - User tests Collaborative Universe
  - Document user feedback
  - _Requirements: 41.32, 42.15_

- [ ] 27.6 Fix bugs and polish
  - Address all issues found during testing
  - Polish UI/UX for all features
  - Improve error messages
  - Optimize performance
  - _Requirements: 41.34_

- [ ] 27.7 Final checkpoint - Phase 3 complete
  - All advanced features implemented
  - All accuracy thresholds met
  - All tests passing
  - User approval obtained
  - Ready for Phase 4 (Admin Panel)

---

## PHASE 4: ADMIN PANEL (Weeks 9-10)

### 28. Admin Panel Foundation

- [ ] 28.1 Choose admin panel technology stack
  - Decide: Flutter Web, React, or Vue.js
  - Set up project structure
  - Configure build tools
  - _Requirements: 36.1_


- [ ] 28.2 Set up admin panel routing
  - Configure routes: login, dashboard, users, content, analytics, system
  - Implement route guards for authentication
  - _Requirements: 36.1_

- [ ] 28.3 Create admin panel design system
  - Define color scheme
  - Define typography
  - Create reusable components (buttons, cards, tables, charts)
  - Implement responsive layout
  - _Requirements: 36.3_

### 29. Admin Authentication

- [ ] 29.1 Implement admin authentication UI
  - Create admin login screen
  - Email/password input fields
  - Two-factor authentication (2FA) input
  - _Requirements: 31.1, 31.2, 31.3_

- [ ] 29.2 Create admin authentication endpoints in backend
  - Create `functions/src/api/auth/admin-login.ts`
  - Verify user has Admin_Role or Super_Admin_Role
  - Implement 2FA verification
  - Generate admin session token
  - _Requirements: 31.4_

- [ ] 29.3 Implement admin session management
  - Store admin session token securely
  - Expire sessions after 8 hours of inactivity
  - Log all admin login attempts
  - _Requirements: 31.5, 31.6_

- [ ] 29.4 Implement password re-confirmation for sensitive actions
  - Create re-confirmation modal
  - Require password for: role changes, user deletion, content deletion
  - _Requirements: 31.7_

- [ ] 29.5 Register admin authentication in backend
  - Add admin authentication middleware
  - Protect all admin endpoints
  - _Requirements: 24.4_

### 30. Role-Based Access Control (RBAC)

- [ ] 30.1 Implement custom claims in Firebase Auth
  - Create backend function to set user roles
  - Store roles in custom claims: regular, pro, moderator, admin, superAdmin
  - _Requirements: 26.2, 26.3_


- [ ] 30.2 Implement role verification in backend
  - Create `functions/src/middleware/role-check.ts`
  - Verify user role before allowing access to protected endpoints
  - Define role permissions: regular (app features), pro (premium features), moderator (content moderation), admin (user management), superAdmin (all features + system config)
  - _Requirements: 26.1, 26.4, 26.5, 26.6, 26.7, 26.8_

- [ ] 30.3 Create audit logging system
  - Create `functions/src/services/audit-log.ts`
  - Log all admin actions with: timestamp, admin user ID, action type, affected resource, action result
  - Store audit logs in Firestore
  - Make audit logs immutable
  - _Requirements: 35.1, 35.2, 35.3, 35.6_

- [ ]* 30.4 Write property test for audit log creation
  - **Property 12: Audit Log Creation**
  - **Validates: Requirements 26.9, 27.8, 35.7**
  - Test that all admin operations create audit log entries

- [ ] 30.5 Update all admin endpoints with audit logging
  - Add audit logging to user management endpoints
  - Add audit logging to content moderation endpoints
  - Add audit logging to system configuration endpoints
  - _Requirements: 26.9, 35.7_

### 31. User Management Interface

- [ ] 31.1 Create user management screen
  - Create user list view with table
  - Display columns: email, registration date, role, DNA profile summary, usage statistics
  - Implement pagination
  - _Requirements: 27.1, 27.2_

- [ ] 31.2 Implement user search and filtering
  - Add search by email or user ID
  - Add filters: role, registration date range
  - _Requirements: 27.3, 27.4_

- [ ] 31.3 Create user detail view
  - Display full user information
  - Show DNA profile details
  - Show generation history
  - Show account status
  - _Requirements: 27.5_

- [ ] 31.4 Implement user role management
  - Add role change dropdown
  - Require password re-confirmation
  - Update user role via backend API
  - Create audit log entry
  - _Requirements: 27.6, 27.8_


- [ ] 31.5 Implement user account management
  - Add disable/enable account button
  - Require password re-confirmation
  - Update account status via backend API
  - Create audit log entry
  - _Requirements: 27.7, 27.8_

- [ ] 31.6 Create backend endpoints for user management
  - Create `functions/src/api/admin/user-management.ts`
  - Implement endpoints: listUsers, getUserDetails, updateUserRole, disableUser, enableUser
  - Use Admin SDK for Firebase Auth operations
  - Verify admin role and create audit logs
  - _Requirements: 27.1, 27.2, 27.3, 27.4, 27.5, 27.6, 27.7_

### 32. Content Moderation Interface

- [ ] 32.1 Create content moderation screen
  - Create image grid view
  - Display recently generated images
  - Implement pagination
  - _Requirements: 28.1, 28.2, 28.8_

- [ ] 32.2 Implement content filtering
  - Add filters: date range, user, flagged status, generation type
  - _Requirements: 28.3_

- [ ] 32.3 Create image detail view
  - Display full image
  - Show generation prompt
  - Show user ID and timestamp
  - Show DNA profile context
  - _Requirements: 28.4_

- [ ] 32.4 Implement content flagging
  - Add flag button with reason selection
  - Require password re-confirmation
  - Update flag status via backend API
  - Notify user and create audit log
  - _Requirements: 28.5, 28.7_

- [ ] 32.5 Implement content deletion
  - Add delete button
  - Require password re-confirmation
  - Delete image from Storage via backend API
  - Delete metadata from Firestore
  - Notify user and create audit log
  - _Requirements: 28.6, 28.7_

- [ ] 32.6 Create backend endpoints for content moderation
  - Create `functions/src/api/admin/content-moderation.ts`
  - Implement endpoints: listImages, getImageDetails, flagImage, deleteImage
  - Use Admin SDK for Firestore and Storage operations
  - Verify moderator/admin role and create audit logs
  - _Requirements: 28.1, 28.2, 28.3, 28.4, 28.5, 28.6_


### 33. Analytics Dashboard

- [ ] 33.1 Create analytics dashboard screen
  - Create dashboard layout with metric cards and charts
  - Display key metrics: total users, active users (daily/monthly), total generations, revenue
  - _Requirements: 29.1, 29.2_

- [ ] 33.2 Implement user growth charts
  - Display user growth over time (line chart)
  - Show daily, weekly, monthly views
  - _Requirements: 29.3_

- [ ] 33.3 Implement feature usage statistics
  - Display usage counts for: emotion-to-image, memory transformer, dream studio
  - Show usage trends over time
  - _Requirements: 29.4_

- [ ] 33.4 Implement art style popularity rankings
  - Display most popular art styles
  - Show style usage distribution (pie chart)
  - _Requirements: 29.5_

- [ ] 33.5 Implement user retention metrics
  - Display 1-day, 7-day, 30-day retention rates
  - Show retention cohort analysis
  - _Requirements: 29.6_

- [ ] 33.6 Implement report export
  - Add export button for CSV and PDF
  - Generate reports with current dashboard data
  - _Requirements: 29.7_

- [ ] 33.7 Implement real-time updates
  - Use Firestore listeners for real-time metric updates
  - Update dashboard automatically when data changes
  - _Requirements: 29.8, 36.4_

- [ ] 33.8 Create backend endpoints for analytics
  - Create `functions/src/api/admin/analytics.ts`
  - Implement endpoints: getMetrics, getUserGrowth, getFeatureUsage, getStylePopularity, getRetentionMetrics
  - Aggregate data from Firestore
  - Verify admin role
  - _Requirements: 29.1, 29.2, 29.3, 29.4, 29.5, 29.6_

### 34. System Monitoring Dashboard

- [ ] 34.1 Create system health dashboard screen
  - Create dashboard layout with system metrics
  - Display Firebase usage metrics: Firestore reads/writes, Storage usage, Cloud Functions invocations
  - _Requirements: 30.1, 30.2_


- [ ] 34.2 Implement cost monitoring
  - Display estimated monthly costs for Firebase services
  - Show cost breakdown by service
  - Add cost alerts for budget thresholds
  - _Requirements: 30.3_

- [ ] 34.3 Implement error log viewer
  - Display error logs from Backend API and Cloud Functions
  - Show error details: timestamp, error type, stack trace, affected user
  - Implement filtering and search
  - _Requirements: 30.4_

- [ ] 34.4 Implement API performance metrics
  - Display API response time metrics (average, p50, p95, p99)
  - Show response time trends over time
  - _Requirements: 30.5_

- [ ] 34.5 Implement rate limiting statistics
  - Display blocked requests count
  - Show top users by request count
  - _Requirements: 30.6_

- [ ] 34.6 Implement error rate alerts
  - Monitor error rate threshold
  - Display alerts when error rate exceeds threshold
  - _Requirements: 30.7_

- [ ] 34.7 Integrate Firebase Crashlytics
  - Display crash reports from mobile app
  - Show crash trends and affected users
  - _Requirements: 30.8_

- [ ] 34.8 Create backend endpoints for system monitoring
  - Create `functions/src/api/admin/system-monitoring.ts`
  - Implement endpoints: getFirebaseUsage, getCostEstimates, getErrorLogs, getApiMetrics, getRateLimitStats
  - Use Firebase Admin SDK and Cloud Monitoring API
  - Verify admin role
  - _Requirements: 30.1, 30.2, 30.3, 30.4, 30.5, 30.6_

### 35. Audit Log Viewer

- [ ] 35.1 Create audit log viewer screen
  - Create table view for audit logs
  - Display columns: timestamp, admin user, action type, affected resource, result
  - Implement pagination
  - _Requirements: 35.4_

- [ ] 35.2 Implement audit log filtering
  - Add filters: date range, admin user, action type, affected resource
  - _Requirements: 35.5_


- [ ] 35.3 Implement audit log search
  - Add search by admin user ID or affected resource ID
  - _Requirements: 35.4_

- [ ] 35.4 Create backend endpoint for audit logs
  - Create `functions/src/api/admin/audit-logs.ts`
  - Implement endpoint: getAuditLogs with filtering and pagination
  - Verify admin role
  - _Requirements: 35.4, 35.5_

### 36. Feature Flag Management

- [ ] 36.1 Set up Firebase Remote Config
  - Enable Remote Config in Firebase Console
  - Define feature flags for all features
  - _Requirements: 34.1_

- [ ] 36.2 Create feature flag management UI
  - Create feature flag list view
  - Display flag name, status, target segments
  - _Requirements: 34.4_

- [ ] 36.3 Implement feature flag toggle
  - Add enable/disable toggle for each flag
  - Update Remote Config via backend API
  - _Requirements: 34.4_

- [ ] 36.4 Implement user segment targeting
  - Add segment selection: all users, pro users, beta testers, percentage rollout
  - Configure targeting rules
  - _Requirements: 34.5, 34.6_

- [ ] 36.5 Create backend endpoints for feature flags
  - Create `functions/src/api/admin/feature-flags.ts`
  - Implement endpoints: listFlags, updateFlag, setTargeting
  - Use Firebase Admin SDK for Remote Config operations
  - Verify admin role
  - _Requirements: 34.2, 34.4_

- [ ] 36.6 Update Flutter app to use feature flags
  - Fetch feature flags on app startup
  - Check flags before displaying features
  - Cache flags locally for offline access
  - _Requirements: 34.3, 34.7, 34.8_

### 37. Admin Panel Testing and Deployment

- [ ] 37.1 Test admin authentication
  - Test admin login with 2FA
  - Test session expiration
  - Test password re-confirmation
  - _Requirements: 31.1, 31.2, 31.3, 31.5, 31.7_


- [ ] 37.2 Test RBAC system
  - Test role verification for all endpoints
  - Test custom claims storage and retrieval
  - Test audit log creation for admin actions
  - _Requirements: 26.1, 26.2, 26.3, 26.4, 26.9_

- [ ] 37.3 Test user management features
  - Test user list, search, and filtering
  - Test user detail view
  - Test role changes
  - Test account disable/enable
  - _Requirements: 27.1, 27.2, 27.3, 27.4, 27.5, 27.6, 27.7_

- [ ] 37.4 Test content moderation features
  - Test image list and filtering
  - Test image detail view
  - Test content flagging
  - Test content deletion
  - _Requirements: 28.1, 28.2, 28.3, 28.4, 28.5, 28.6_

- [ ] 37.5 Test analytics dashboard
  - Test all metrics display correctly
  - Test real-time updates
  - Test report export
  - _Requirements: 29.1, 29.2, 29.3, 29.4, 29.5, 29.6, 29.7, 29.8_

- [ ] 37.6 Test system monitoring dashboard
  - Test Firebase usage metrics
  - Test cost monitoring
  - Test error logs
  - Test API performance metrics
  - _Requirements: 30.1, 30.2, 30.3, 30.4, 30.5_

- [ ] 37.7 Test audit log viewer
  - Test audit log display
  - Test filtering and search
  - Verify logs are immutable
  - _Requirements: 35.4, 35.5, 35.6_

- [ ] 37.8 Test feature flag management
  - Test flag toggle
  - Test user segment targeting
  - Test percentage rollout
  - _Requirements: 34.3, 34.4, 34.5, 34.6_

- [ ] 37.9 Deploy admin panel
  - Build admin panel for production
  - Deploy to Firebase Hosting or separate hosting
  - Configure custom domain (optional)
  - _Requirements: 36.6_

- [ ] 37.10 Final checkpoint - Phase 4 complete
  - All admin features implemented
  - All security measures in place
  - All tests passing
  - Admin panel deployed
  - User approval obtained


---

## FINAL DEPLOYMENT AND DOCUMENTATION

### 38. Production Deployment

- [ ] 38.1 Set up production Firebase project
  - Create production Firebase project
  - Configure production environment variables
  - Set up production security rules
  - _Requirements: 20.1, 20.2_

- [ ] 38.2 Deploy backend to production
  - Deploy Cloud Functions to production
  - Verify all endpoints are working
  - Test security and rate limiting
  - _Requirements: 24.7_

- [ ] 38.3 Build Flutter app for production
  - Build Android APK/AAB
  - Build iOS IPA
  - Configure app signing
  - _Requirements: 20.1_

- [ ] 38.4 Deploy to app stores
  - Submit to Google Play Store
  - Submit to Apple App Store
  - Prepare store listings and screenshots
  - _Requirements: 41.40_

- [ ] 38.5 Set up CI/CD pipeline
  - Configure GitHub Actions or similar
  - Automate testing on push
  - Automate deployment to staging
  - Require manual approval for production deployment
  - _Requirements: 32.4, 32.5, 32.6_

- [ ] 38.6 Set up monitoring and alerts
  - Configure Firebase Crashlytics
  - Configure Firebase Performance Monitoring
  - Set up error alerts
  - Set up cost alerts
  - _Requirements: 22.3, 22.4_

### 39. Documentation

- [ ] 39.1 Write architecture documentation
  - Document overall architecture
  - Document feature module structure
  - Document clean architecture layers
  - Document state management patterns
  - _Requirements: 37.2_

- [ ] 39.2 Write feature module READMEs
  - Create README for each feature module
  - Explain feature purpose and structure
  - Document key components
  - _Requirements: 37.1_


- [ ] 39.3 Document API endpoints
  - Document all backend API endpoints
  - Include request/response examples
  - Document authentication requirements
  - Document rate limits
  - _Requirements: 37.7_

- [ ] 39.4 Write setup instructions
  - Document development environment setup
  - Document Firebase configuration steps
  - Document how to run the app locally
  - Document how to run tests
  - _Requirements: 37.5_

- [ ] 39.5 Document Firebase configuration
  - Document how to create Firebase project
  - Document how to enable services
  - Document how to configure security rules
  - Document how to deploy Cloud Functions
  - _Requirements: 37.6_

- [ ] 39.6 Document admin panel
  - Document admin panel features
  - Document user workflows
  - Document role permissions
  - _Requirements: 37.8_

- [ ] 39.7 Document Agile development process
  - Document Sprint workflow
  - Document quality gates
  - Document testing requirements
  - Document deployment process
  - _Requirements: 37.9_

- [ ] 39.8 Add code comments
  - Add documentation comments to all public APIs
  - Add comments for complex business logic
  - Ensure all classes and methods are documented
  - _Requirements: 37.3, 37.4, 33.10_

### 40. Final Quality Assurance

- [ ] 40.1 Run full test suite
  - Run all unit tests
  - Run all widget tests
  - Run all integration tests
  - Run all property-based tests
  - Verify 80%+ code coverage
  - _Requirements: 19.1, 19.2, 19.5, 42.3, 42.4, 42.5_

- [ ] 40.2 Verify all quality gates
  - Verify automated testing quality gate
  - Verify accuracy validation quality gate (90%+ for all features)
  - Verify API resilience quality gate
  - Verify error handling quality gate
  - Verify performance quality gate
  - Verify code review quality gate
  - Verify documentation quality gate
  - _Requirements: 42.1, 42.2_


- [ ] 40.3 Perform security audit
  - Verify Firebase security rules are enforced
  - Verify backend API authentication is working
  - Verify rate limiting is active
  - Verify input validation is comprehensive
  - Test for common security vulnerabilities
  - _Requirements: 25.1, 25.2, 25.3, 25.4, 24.4, 24.5, 24.6_

- [ ] 40.4 Perform performance audit
  - Measure app startup time
  - Measure feature response times
  - Profile memory usage
  - Identify and fix performance bottlenecks
  - _Requirements: 21.1, 21.2, 21.3, 21.4, 21.5, 21.6_

- [ ] 40.5 Verify code quality standards
  - Verify no files exceed 1000 lines
  - Verify only BLoC/Cubit state management is used
  - Verify single responsibility principle
  - Run static analysis (flutter analyze)
  - _Requirements: 33.1, 33.2, 33.3, 33.6, 33.7, 33.9_

- [ ] 40.6 Final user acceptance testing
  - User tests all features end-to-end
  - User tests on multiple devices
  - User tests offline functionality
  - User tests admin panel
  - User provides final approval
  - _Requirements: 41.32, 41.39, 42.15, 42.16, 42.17_

- [ ] 40.7 Create release notes
  - Document all features implemented
  - Document known issues (if any)
  - Document upgrade instructions
  - _Requirements: 37.1_

- [ ] 40.8 Final checkpoint - Project complete
  - All phases completed
  - All features implemented and tested
  - All quality gates passed
  - All documentation complete
  - Production deployment successful
  - User approval obtained
  - Ready for launch! 🚀

---

## Notes

- Tasks marked with `*` are optional testing tasks and can be skipped for faster MVP delivery
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation and user collaboration
- Property tests validate universal correctness properties across all inputs
- Unit tests validate specific examples, edge cases, and integration points
- The phased approach ensures the hero product works perfectly before adding complexity
- User actions are clearly marked (USER:) to distinguish from developer tasks
- All tasks follow the 8-phase workflow: Foundation → External Setup → Configuration → Implementation → Design → UI → Testing → Deployment

