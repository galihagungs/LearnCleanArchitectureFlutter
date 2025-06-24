import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:travel_app_clean_architecture/features/homepage/presentation/widgets/circle_loading.dart';
import 'package:travel_app_clean_architecture/features/homepage/presentation/widgets/parallax_horiz_delegate.dart';

class TopDestinationImage extends StatelessWidget {
  TopDestinationImage({super.key, required this.url});
  final String url;
  final imagekey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: ParallaxHorizDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        backgroundImageKey: imagekey,
      ),
      children: [
        ExtendedImage.network(
          url,
          key: imagekey,
          fit: BoxFit.cover,
          width: double.infinity,
          handleLoadingProgress: true,
          loadStateChanged: (state) {
            if (state.extendedImageLoadState == LoadState.failed) {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: Material(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, color: Colors.black),
                ),
              );
            }
            if (state.extendedImageLoadState == LoadState.loading) {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: Material(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[300],
                  child: CircleLoading(),
                ),
              );
            }
            return null;
          },
        ),
      ],
    );
  }
}
