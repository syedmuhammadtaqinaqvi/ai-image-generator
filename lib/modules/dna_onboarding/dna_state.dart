import 'package:equatable/equatable.dart';
import 'dna_models.dart';

abstract class DnaProfileState extends Equatable {
  const DnaProfileState();
  @override
  List<Object?> get props => [];
}

class DnaProfileInitial extends DnaProfileState {
  const DnaProfileInitial();
}

class DnaProfileLoading extends DnaProfileState {
  const DnaProfileLoading();
}

class DnaProfileLoaded extends DnaProfileState {
  final DnaProfile profile;
  const DnaProfileLoaded(this.profile);
  @override
  List<Object?> get props => [profile];
}

class DnaProfileError extends DnaProfileState {
  final String message;
  const DnaProfileError(this.message);
  @override
  List<Object?> get props => [message];
}
