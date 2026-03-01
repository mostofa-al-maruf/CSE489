import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageScaleScreen extends StatefulWidget {
  const ImageScaleScreen({super.key});

  @override
  State<ImageScaleScreen> createState() => _ImageScaleScreenState();
}

class _ImageScaleScreenState extends State<ImageScaleScreen> {
  final TransformationController _transformationController =
      TransformationController();
  final FocusNode _focusNode = FocusNode();

  double _currentScale = 1.0;
  static const double _minScale = 0.5;
  static const double _maxScale = 4.0;

  void _zoom(double scaleFactor) {
    final Matrix4 matrix = _transformationController.value.clone();
    final double currentScale = matrix.getMaxScaleOnAxis();

    // Clamp within limits
    final double newScale = (currentScale * scaleFactor).clamp(
      _minScale,
      _maxScale,
    );
    final double adjustedFactor = newScale / currentScale;

    matrix.scale(adjustedFactor);
    setState(() {
      _transformationController.value = matrix;
      _currentScale = newScale;
    });
  }

  void _resetZoom() {
    setState(() {
      _transformationController.value = Matrix4.identity();
      _currentScale = 1.0;
    });
  }

  // Mouse scroll wheel zoom
  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      if (event.scrollDelta.dy < 0) {
        _zoom(1.1); // Scroll up = zoom in
      } else {
        _zoom(0.9); // Scroll down = zoom out
      }
    }
  }

  // Keyboard +/- and 0 for zoom
  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (event.logicalKey == LogicalKeyboardKey.equal ||
          event.logicalKey == LogicalKeyboardKey.add ||
          event.logicalKey == LogicalKeyboardKey.numpadAdd) {
        _zoom(1.2);
      } else if (event.logicalKey == LogicalKeyboardKey.minus ||
          event.logicalKey == LogicalKeyboardKey.numpadSubtract) {
        _zoom(0.8);
      } else if (event.logicalKey == LogicalKeyboardKey.digit0 ||
          event.logicalKey == LogicalKeyboardKey.numpad0) {
        _resetZoom();
      }
    }
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header with zoom controls
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Zoom Image',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.zoom_in),
                    tooltip: 'Zoom In (+)',
                    onPressed: _currentScale < _maxScale
                        ? () => _zoom(1.2)
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.zoom_out),
                    tooltip: 'Zoom Out (-)',
                    onPressed: _currentScale > _minScale
                        ? () => _zoom(0.8)
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Reset (0)',
                    onPressed: _resetZoom,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(_currentScale * 100).toInt()}%',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Zoomable image area
            Expanded(
              child: Listener(
                onPointerSignal: _handlePointerSignal,
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  panEnabled: true,
                  boundaryMargin: const EdgeInsets.all(80),
                  minScale: _minScale,
                  maxScale: _maxScale,
                  onInteractionUpdate: (details) {
                    setState(() {
                      _currentScale = _transformationController.value
                          .getMaxScaleOnAxis();
                    });
                  },
                  child: Image.network(
                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.error, color: Colors.red, size: 50),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
