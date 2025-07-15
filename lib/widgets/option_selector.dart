import 'package:flutter/material.dart';
import '../models/image_options.dart';

class AspectRatioSelector extends StatelessWidget {
  final List<ImageAspectRatio> aspectRatios;
  final ImageAspectRatio selectedAspectRatio;
  final Function(ImageAspectRatio) onAspectRatioChanged;

  const AspectRatioSelector({
    super.key,
    required this.aspectRatios,
    required this.selectedAspectRatio,
    required this.onAspectRatioChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select aspect ratio',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: aspectRatios.map((aspectRatio) {
            final isSelected = aspectRatio.name == selectedAspectRatio.name;
            return GestureDetector(
              onTap: () => onAspectRatioChanged(aspectRatio),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected 
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade400,
                        width: isSelected ? 3 : 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Container(
                        width: aspectRatio.ratio > 1 ? 35 : 20,
                        height: aspectRatio.ratio > 1 ? 20 : 35,
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade600,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    aspectRatio.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected 
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class StyleSelector extends StatelessWidget {
  final List<ImageStyle> styles;
  final ImageStyle selectedStyle;
  final Function(ImageStyle) onStyleChanged;

  const StyleSelector({
    super.key,
    required this.styles,
    required this.selectedStyle,
    required this.onStyleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select style',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: styles.map((style) {
              final isSelected = style.name == selectedStyle.name;
              return GestureDetector(
                onTap: () => onStyleChanged(style),
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected 
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade400,
                            width: isSelected ? 3 : 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade100,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: _getStyleImage(style),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        style.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected 
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _getStyleImage(ImageStyle style) {
    // Create style preview images
    return Container(
      decoration: BoxDecoration(
        gradient: _getStyleGradient(style),
      ),
      child: Center(
        child: Icon(
          _getStyleIcon(style),
          size: 32,
          color: Colors.white,
        ),
      ),
    );
  }

  LinearGradient _getStyleGradient(ImageStyle style) {
    switch (style.name) {
      case 'realistic':
        return const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'anime':
        return const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFE65100)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'van_gogh':
        return const LinearGradient(
          colors: [Color(0xFF3F51B5), Color(0xFF1A237E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case '3d':
        return const LinearGradient(
          colors: [Color(0xFF9C27B0), Color(0xFF4A148C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF607D8B), Color(0xFF263238)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  IconData _getStyleIcon(ImageStyle style) {
    switch (style.name) {
      case 'realistic':
        return Icons.photo_camera;
      case 'anime':
        return Icons.face;
      case 'van_gogh':
        return Icons.brush;
      case '3d':
        return Icons.view_in_ar;
      default:
        return Icons.image;
    }
  }
}
