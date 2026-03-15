import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../dna_cubit.dart';
import '../dna_models.dart';

class EmotionSelector extends StatefulWidget {
  final String userId;
  const EmotionSelector({super.key, required this.userId});
  
  @override
  State<EmotionSelector> createState() => _EmotionSelectorState();
}

class _EmotionSelectorState extends State<EmotionSelector> {
  final _freq = <String, double>{
    'happy': 0.5,
    'sad': 0.5,
    'excited': 0.5,
    'calm': 0.5,
  };
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._freq.entries.map((e) => Column(
          children: [
            Text(e.key.toUpperCase()),
            Slider(
              value: e.value,
              onChanged: (v) => setState(() => _freq[e.key] = v),
              divisions: 10,
            ),
          ],
        )),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            final dom = _freq.entries.where((e) => e.value > 0.6).map((e) => e.key).toList();
            final prefs = EmotionPrefs(frequency: _freq, dominant: dom, updated: DateTime.now());
            context.read<DnaProfileCubit>().updateEmotions(widget.userId, prefs);
          },
          child: const Text('Complete'),
        ),
      ],
    );
  }
}
