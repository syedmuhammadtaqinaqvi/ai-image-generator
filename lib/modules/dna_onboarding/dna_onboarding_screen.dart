import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection.dart';

import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import 'dna_cubit.dart';
import 'dna_state.dart';
import 'widgets/color_selector.dart';
import 'widgets/style_selector.dart';
import 'widgets/emotion_selector.dart';

class DnaOnboardingScreen extends StatefulWidget {
  final String userId;
  
  const DnaOnboardingScreen({super.key, required this.userId});
  
  @override
  State<DnaOnboardingScreen> createState() => _DnaOnboardingScreenState();
}

class _DnaOnboardingScreenState extends State<DnaOnboardingScreen> {
  int _step = 0;
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DnaProfileCubit>()..load(widget.userId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Your Visual DNA')),
        body: BlocBuilder<DnaProfileCubit, DnaProfileState>(
          builder: (context, state) {
            if (state is DnaProfileLoading) return const Center(child: LoadingIndicator());
            if (state is DnaProfileError) {
              return ErrorDisplay(
                message: state.message,
                onRetry: () => context.read<DnaProfileCubit>().load(widget.userId),
              );
            }
            
            return Stepper(
              currentStep: _step,
              onStepContinue: () => _step < 2 ? setState(() => _step++) : Navigator.pop(context),
              onStepCancel: () => _step > 0 ? setState(() => _step--) : null,
              steps: [
                Step(
                  title: const Text('Colors'),
                  content: ColorSelector(userId: widget.userId),
                  isActive: _step >= 0,
                ),
                Step(
                  title: const Text('Styles'),
                  content: StyleSelector(userId: widget.userId),
                  isActive: _step >= 1,
                ),
                Step(
                  title: const Text('Emotions'),
                  content: EmotionSelector(userId: widget.userId),
                  isActive: _step >= 2,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
