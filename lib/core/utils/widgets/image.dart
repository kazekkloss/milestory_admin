import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../injection.dart';
import '../../core_export.dart';

class ImageNetwork extends StatelessWidget {
  final String? imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color? colorFilter;

  const ImageNetwork({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.colorFilter,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      debugPrint("ImageNetwork: Image URL is null or empty");
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          color: CustomColorScheme.customColorScheme.onPrimary,
          child: const Icon(
            Icons.image_not_supported,
            size: 50,
            color: Colors.grey,
          ),
        ),
      );
    }

    return FutureBuilder<Map<String, String>>(
      future: getIt<TokenManager>().getHeaders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: CustomColorScheme.customColorScheme.primary,
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          debugPrint("ImageNetwork: No valid token available");
          return ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              color: CustomColorScheme.customColorScheme.onPrimary,
              child: const Icon(
                Icons.lock,
                size: 50,
                color: Colors.grey,
              ),
            ),
          );
        }

        Widget image = CachedNetworkImage(
          imageUrl: imageUrl!,
          httpHeaders: snapshot.data,
          fit: fit,
          width: width,
          height: height,
          placeholder: (context, url) => Container(
            color: CustomColorScheme.customColorScheme.onPrimary,
            width: width,
            height: height,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: CustomColorScheme.customColorScheme.primary,
            ),
          ),
          errorWidget: (context, url, error) {
            debugPrint("ImageNetwork: CachedNetworkImage Error: $error");
            return Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              color: CustomColorScheme.customColorScheme.onPrimary,
              child: const Icon(
                Icons.error,
                color: Colors.red,
              ),
            );
          },
        );

        if (colorFilter != null) {
          image = ColorFiltered(
            colorFilter: ColorFilter.mode(
              colorFilter!,
              BlendMode.dstATop,
            ),
            child: image,
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: image,
        );
      },
    );
  }
}
