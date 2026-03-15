import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import 'emotion_cubit.dart';
import 'emotion_state.dart';
import 'widgets/emotion_input.dart';
import 'widgets/generation_preview.dart';
import 'widgets/generation_history.dart';

class EmotionToImageScreen extends StatelessWidget {
  final String userId;
  
  const EmotionToImageScreen({super.key, required this.userId});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EmotionToImageCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Emotion to Image')),
        body: BlocBuilder<EmotionToImageCubit, EmotionToImageState>(
          builder: (context, state) {
            if (state is EmotionToImageGenerating) {
              return const Center(child: LoadingIndicator());
            }
            
            if (state is EmotionToImageError) {
              return Column(
                children: [
                  EmotionInput(userId: userId),
                  Expanded(
                    child: Center(
                      child: ErrorDisplay(
                        message: state.message,
                        onRetry: state.lastPrompt != null
                            ? () => context.read<EmotionToImageCubit>().generate(userId, state.lastPrompt!)
                            : null,
                      ),
                    ),
                  ),
                ],
              );
            }
            
            return Column(
              children: [
                EmotionInput(userId: userId),
                if (state is EmotionToImageSuccess) ...[
                  GenerationPreview(
                    result: state.result,
                    onSave: () {
                      final cubit = context.read<EmotionToImageCubit>();
                      cubit.saveGeneration(userId, state.result.enhancedPrompt);
                    },
                    onRegenerate: () {
                      final cubit = context.read<EmotionToImageCubit>();
                      cubit.regenerate(userId, state.result.prompt, state.result.enhancedPrompt);
                    },
                  ),
                  if (state.history.isNotEmpty)
                    Expanded(
                      child: GenerationHistory(
                        history: state.history,
                        onClear: () => context.read<EmotionToImageCubit>().clearHistory(),
                      ),
                    ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
