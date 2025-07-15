import 'package:flutter/material.dart';
import '../models/image_options.dart';
import '../widgets/option_selector.dart';

class ChatInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isLoading;
  final ImageAspectRatio selectedAspectRatio;
  final ImageStyle selectedStyle;
  final Function(ImageAspectRatio) onAspectRatioChanged;
  final Function(ImageStyle) onStyleChanged;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isLoading,
    required this.selectedAspectRatio,
    required this.selectedStyle,
    required this.onAspectRatioChanged,
    required this.onStyleChanged,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  // Removed toggle functionality - options are always visible

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Options Panel - Always visible (Compact)
          Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Aspect Ratio Selector
                AspectRatioSelector(
                  aspectRatios: ImageOptions.aspectRatios,
                  selectedAspectRatio: widget.selectedAspectRatio,
                  onAspectRatioChanged: widget.onAspectRatioChanged,
                ),
                const SizedBox(height: 8),
                // Style Selector
                StyleSelector(
                  styles: ImageOptions.styles,
                  selectedStyle: widget.selectedStyle,
                  onStyleChanged: widget.onStyleChanged,
                ),
              ],
            ),
          ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: SafeArea(
              child: Row(
                children: [
                  // Text Input
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 120),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: widget.controller,
                        enabled: !widget.isLoading,
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _handleSend(),
                        decoration: InputDecoration(
                          hintText: 'Describe the image you want to create...',
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Send Button
                  GestureDetector(
                    onTap: widget.isLoading ? null : _handleSend,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: widget.isLoading 
                            ? Theme.of(context).colorScheme.outline
                            : Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: widget.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSend() {
    if (widget.controller.text.trim().isNotEmpty && !widget.isLoading) {
      widget.onSend();
    }
  }
}
