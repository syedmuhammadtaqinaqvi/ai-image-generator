class ImageAspectRatio {
  final String name;
  final String displayName;
  final int width;
  final int height;
  final double ratio;

  ImageAspectRatio({
    required this.name,
    required this.displayName,
    required this.width,
    required this.height,
  }) : ratio = width / height;
}

class ImageStyle {
  final String name;
  final String displayName;
  final String description;
  final String? modelName;
  final String? styleModifier;

  ImageStyle({
    required this.name,
    required this.displayName,
    required this.description,
    this.modelName,
    this.styleModifier,
  });
}

class ImageOptions {
  static List<ImageAspectRatio> aspectRatios = [
    ImageAspectRatio(name: '1:1', displayName: '1:1', width: 512, height: 512),
    ImageAspectRatio(name: '9:16', displayName: '9:16', width: 512, height: 912),
    ImageAspectRatio(name: '16:9', displayName: '16:9', width: 912, height: 512),
    ImageAspectRatio(name: '3:4', displayName: '3:4', width: 512, height: 680),
  ];

  static List<ImageStyle> styles = [
    ImageStyle(
      name: 'no_style',
      displayName: 'No Style',
      description: 'Natural, no specific style',
      modelName: 'flux',
    ),
    ImageStyle(
      name: 'realistic',
      displayName: 'Realistic',
      description: 'Photorealistic style',
      modelName: 'flux',
      styleModifier: 'photorealistic, detailed, high quality',
    ),
    ImageStyle(
      name: 'anime',
      displayName: 'Anime',
      description: 'Anime/manga style',
      modelName: 'flux',
      styleModifier: 'anime style, manga, illustration',
    ),
    ImageStyle(
      name: 'van_gogh',
      displayName: 'Van Gogh',
      description: 'Van Gogh painting style',
      modelName: 'flux',
      styleModifier: 'in the style of Van Gogh, impressionist, oil painting',
    ),
    ImageStyle(
      name: '3d',
      displayName: '3D',
      description: '3D rendered style',
      modelName: 'flux',
      styleModifier: '3D rendered, digital art, high quality 3D',
    ),
  ];
}
