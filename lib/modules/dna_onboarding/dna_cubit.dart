import 'package:flutter_bloc/flutter_bloc.dart';
import 'dna_state.dart';
import 'dna_repository.dart';
import 'dna_models.dart';

class DnaProfileCubit extends Cubit<DnaProfileState> {
  final DnaRepository _repo;
  
  DnaProfileCubit(this._repo) : super(const DnaProfileInitial());
  
  Future<void> load(String userId) async {
    emit(const DnaProfileLoading());
    final result = await _repo.get(userId);
    result.fold(
      (error) => emit(DnaProfileError(error)),
      (profile) => emit(DnaProfileLoaded(profile)),
    );
  }
  
  Future<void> updateColors(String userId, ColorPrefs prefs) async {
    emit(const DnaProfileLoading());
    await _repo.updateColors(userId, prefs);
    await load(userId);
  }
  
  Future<void> updateStyles(String userId, StylePrefs prefs) async {
    emit(const DnaProfileLoading());
    await _repo.updateStyles(userId, prefs);
    await load(userId);
  }
  
  Future<void> updateEmotions(String userId, EmotionPrefs prefs) async {
    emit(const DnaProfileLoading());
    await _repo.updateEmotions(userId, prefs);
    await load(userId);
  }
}
