import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../modules/dna_onboarding/dna_repository.dart';
import '../../modules/dna_onboarding/dna_cubit.dart';
import '../../modules/emotion_to_image/emotion_cubit.dart';
import '../../modules/emotion_to_image/emotion_service.dart';
import '../services/style_learning_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(() => http.Client());
  
  sl.registerLazySingleton(() => DnaRepository());
  sl.registerLazySingleton(() => StyleLearningService(sl()));
  sl.registerLazySingleton(() => EmotionService(sl()));
  sl.registerLazySingleton(() => ImageService(sl()));
  
  sl.registerFactory(() => DnaProfileCubit(sl()));
  sl.registerFactory(() => EmotionToImageCubit(sl(), sl(), sl(), sl()));
}
