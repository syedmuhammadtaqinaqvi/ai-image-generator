import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../emotion_cubit.dart';

class EmotionInput extends StatefulWidget {
  final String userId;
  const EmotionInput({super.key, required this.userId});
  
  @override
  State<EmotionInput> createState() => _EmotionInputState();
}

class _EmotionInputState extends State<EmotionInput> {
  final _controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Describe your emotion...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: ['Happy', 'Sad', 'Excited', 'Calm'].map((e) => 
              ElevatedButton(
                onPressed: () => _controller.text = e,
                child: Text(e),
              ),
            ).toList(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<EmotionToImageCubit>().generate(widget.userId, _controller.text),
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
