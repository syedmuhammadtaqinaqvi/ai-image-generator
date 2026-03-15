
import 'package:go_router/go_router.dart';
import '../../modules/home/home_screen.dart';
import '../../modules/dna_onboarding/dna_onboarding_screen.dart';
import '../../modules/dna_profile/dna_profile_screen.dart';
import '../../modules/emotion_to_image/emotion_screen.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/dna-onboarding',
        name: 'dna-onboarding',
        builder: (context, state) => const DnaOnboardingScreen(userId: 'demo_user'),
      ),
      GoRoute(
        path: '/dna-profile',
        name: 'dna-profile',
        builder: (context, state) => const DnaProfileScreen(userId: 'demo_user'),
      ),
      GoRoute(
        path: '/emotion-to-image',
        name: 'emotion-to-image',
        builder: (context, state) => const EmotionToImageScreen(userId: 'demo_user'),
      ),
    ],
  );
}
