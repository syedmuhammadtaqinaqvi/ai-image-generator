import 'package:flutter/material.dart';
import '../emotion_models.dart';

class GenerationPreview extends StatelessWidget {
  final GenerationResult result;
  final VoidCallback? onSave;
  final VoidCallback? onRegenerate;
  
  const GenerationPreview({
    super.key,
    required this.result,
    this.onSave,
    this.onRegenerate,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              result.imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stack) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 16),
          Text('Prompt: ${result.prompt}'),
          Text('Enhanced: ${result.enhancedPrompt}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (onSave != null)
                ElevatedButton.icon(
                  onPressed: onSave,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
              const SizedBox(width: 12),
              if (onRegenerate != null)
                OutlinedButton.icon(
                  onPressed: onRegenerate,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Regenerate'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
