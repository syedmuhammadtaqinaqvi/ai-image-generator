import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import '../dna_onboarding/dna_cubit.dart';
import '../dna_onboarding/dna_state.dart';
import 'widgets/dna_viz.dart';

class DnaProfileScreen extends StatelessWidget {
  final String userId;
  
  const DnaProfileScreen({super.key, required this.userId});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DnaProfileCubit>()..load(userId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Your Visual DNA')),
        body: BlocBuilder<DnaProfileCubit, DnaProfileState>(
          builder: (context, state) {
            if (state is DnaProfileLoading) return const Center(child: LoadingIndicator());
            if (state is DnaProfileError) {
              return ErrorDisplay(
                message: state.message,
                onRetry: () => context.read<DnaProfileCubit>().load(userId),
              );
            }
            if (state is DnaProfileLoaded) return DnaViz(profile: state.profile);
            return const Center(child: Text('Complete onboarding first'));
          },
        ),
      ),
    );
  }
}
