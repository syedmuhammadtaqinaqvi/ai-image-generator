import 'package:flutter/material.dart';
import '../../dna_onboarding/dna_models.dart';

class DnaViz extends StatelessWidget {
  final DnaProfile profile;
  
  const DnaViz({super.key, required this.profile});
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Score: ${(profile.score * 100).toInt()}%'),
                  LinearProgressIndicator(value: profile.score),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Colors', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: profile.colors.favorites.map((h) => Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(int.parse(h.substring(1), radix: 16) + 0xFF000000),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Styles', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...profile.styles.top.map((s) => Text('• $s')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
