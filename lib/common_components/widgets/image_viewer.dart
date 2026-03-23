part of './index.dart';

/// ImageViewer is a widget for displaying images with customizable properties.
class ImageViewer extends StatelessWidget {
  // Width of the image container
  final double? width;
  // Height of the image container
  final double? height;
  // URL of the image to display
  final String imageUrl;
  // Border radius of the image container
  final BorderRadius? borderRadius;
  // How the image should fit inside the container
  final BoxFit? boxFit;
  // Shape of the image container
  final BoxShape? boxShape;
  // Border properties of the image container
  final BoxBorder? border;

  // Custom image provider
  final ImageProvider? imageProvider;

  // Widget shown while loading and (by default) also when failed.
  // Pass the same widget to get consistent list placeholders.
  final Widget? placeholder;

  // Widget shown when loading fails. Falls back to `placeholder` if null.
  final Widget? errorPlaceholder;

  const ImageViewer({
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius,
    this.boxFit,
    this.boxShape,
    super.key,
    this.border,
    this.imageProvider,
    this.placeholder,
    this.errorPlaceholder,
  });

  Widget _wrapWithClip(Widget child) {
    final effectiveShape = boxShape ?? BoxShape.rectangle;
    if (effectiveShape == BoxShape.circle) {
      return ClipOval(child: child);
    }
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    final Widget extendedImage = ExtendedImage(
      borderRadius: borderRadius,
      shape: boxShape,
      border: border,
      fit: boxFit,
      enableLoadState: true,
      // We render our own loading/failed widgets, so avoid built-in progress UI.
      handleLoadingProgress: false,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return placeholder;
          case LoadState.completed:
            return state.completedWidget;
          case LoadState.failed:
            return errorPlaceholder ?? placeholder;
        }
      },
      width: width?.toDouble(),
      height: height?.toDouble(),
      image: ExtendedResizeImage(
        imageProvider ??
            ExtendedNetworkImageProvider(
              imageUrl,
              cache: true,
              // For list UIs it's usually better UX to avoid spamming logs.
              printError: false,
            ),
        compressionRatio: 0.5,
        width: width?.toInt(),
        height: height?.toInt(),
      ),
    );

    return _wrapWithClip(
      Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: boxShape ?? BoxShape.rectangle,
          borderRadius: borderRadius,
        ),
        child: extendedImage,
      ),
    );
  }
}
