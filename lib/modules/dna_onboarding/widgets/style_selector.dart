import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../dna_cubit.dart';
import '../dna_models.dart';

class StyleSelector extends StatefulWidget {
  final String userId;
  const StyleSelector({super.key, required this.userId});
  
  @override
  State<StyleSelector> createState() => _StyleSelectorState();
}

class _StyleSelectorState extends State<StyleSelector> {
  final _scores = <String, double>{
    'realistic': 0.5,
    'abstract': 0.5,
    'surreal': 0.5,
    'minimalist': 0.5,
    'impressionist': 0.5,
  };
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._scores.entries.map((e) => Column(
          children: [
            Text(e.key.toUpperCase()),
            Slider(
              value: e.value,
              onChanged: (v) => setState(() => _scores[e.key] = v),
              divisions: 10,
            ),
          ],
        )),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            final top = _scores.entries.where((e) => e.value > 0.6).map((e) => e.key).toList();
            final prefs = StylePrefs(scores: _scores, top: top, dominant: top.isNotEmpty ? top.first : 'realistic');
            context.read<DnaProfileCubit>().updateStyles(widget.userId, prefs);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
