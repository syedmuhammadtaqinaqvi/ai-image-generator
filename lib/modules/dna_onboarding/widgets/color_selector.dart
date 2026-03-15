import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../dna_cubit.dart';
import '../dna_models.dart';

class ColorSelector extends StatefulWidget {
  final String userId;
  const ColorSelector({super.key, required this.userId});
  
  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  final _fav = <String>[];
  final _avoid = <String>[];
  
  static const _colors = [
    {'n': 'Red', 'h': '#FF0000'},
    {'n': 'Orange', 'h': '#FF6B00'},
    {'n': 'Yellow', 'h': '#FFD700'},
    {'n': 'Green', 'h': '#00FF00'},
    {'n': 'Blue', 'h': '#0000FF'},
    {'n': 'Purple', 'h': '#800080'},
    {'n': 'Pink', 'h': '#FF69B4'},
    {'n': 'Teal', 'h': '#008080'},
  ];
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Tap to favorite, long press to avoid'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _colors.map((c) {
            final h = c['h']!;
            final isFav = _fav.contains(h);
            final isAvoid = _avoid.contains(h);
            
            return GestureDetector(
              onTap: () => setState(() {
                _avoid.remove(h);
                isFav ? _fav.remove(h) : _fav.add(h);
              }),
              onLongPress: () => setState(() {
                _fav.remove(h);
                isAvoid ? _avoid.remove(h) : _avoid.add(h);
              }),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(int.parse(h.substring(1), radix: 16) + 0xFF000000),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isFav ? Colors.green : isAvoid ? Colors.red : Colors.grey,
                    width: isFav || isAvoid ? 3 : 1,
                  ),
                ),
                child: isFav ? const Icon(Icons.favorite, color: Colors.white) : null,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            final prefs = ColorPrefs(favorites: _fav, avoided: _avoid, dominant: 'neutral');
            context.read<DnaProfileCubit>().updateColors(widget.userId, prefs);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
