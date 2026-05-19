import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core_export.dart';

class ImageNetwork extends StatefulWidget {
  final String? imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color? colorFilter;

  final IconData placeholderIcon;

  final double placeholderIconSize;

  final double loaderSize;

  const ImageNetwork({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.colorFilter,
    this.placeholderIcon = FontAwesomeIcons.image,
    this.placeholderIconSize = 24,
    this.loaderSize = 18,
  });

  static final Map<String, Uint8List> _cache = {};

  static void evict(String url) => _cache.remove(url);
  static void clearCache() => _cache.clear();

  @override
  State<ImageNetwork> createState() => _ImageNetworkState();
}

class _ImageNetworkState extends State<ImageNetwork> {
  late Future<Uint8List?> _imageFuture;

  @override
  void initState() {
    super.initState();
    _imageFuture = _fetchImage();
  }

  @override
  void didUpdateWidget(ImageNetwork oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _imageFuture = _fetchImage();
    }
  }

  Future<Uint8List?> _fetchImage() async {
    final url = widget.imageUrl;
    if (url == null || url.isEmpty) return null;

    final cached = ImageNetwork._cache[url];
    if (cached != null) return cached;

    try {
      final dio = Dio();
      final response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.data == null) return null;
      final bytes = Uint8List.fromList(response.data!);
      ImageNetwork._cache[url] = bytes;
      return bytes;
    } catch (e) {
      debugPrint('ImageNetwork: Failed to fetch image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      return _buildPlaceholder(c);
    }

    final cached = ImageNetwork._cache[widget.imageUrl!];
    if (cached != null) {
      return _buildImage(c, cached);
    }

    return FutureBuilder<Uint8List?>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoader(c);
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return _buildPlaceholder(c);
        }

        return _buildImage(c, snapshot.data!);
      },
    );
  }

  Widget _buildImage(AppColors c, Uint8List bytes) {
    Widget image = Image.memory(
      bytes,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      errorBuilder: (context, error, stack) {
        debugPrint('ImageNetwork: Image.memory error: $error');
        return _buildPlaceholder(c);
      },
    );

    if (widget.colorFilter != null) {
      image = ColorFiltered(
        colorFilter: ColorFilter.mode(widget.colorFilter!, BlendMode.dstATop),
        child: image,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: image,
    );
  }

  Widget _buildPlaceholder(AppColors c) {
    return Container(
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.bgElevated,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: c.borderSubtle, width: 0.5),
      ),
      child: FaIcon(
        widget.placeholderIcon,
        size: widget.placeholderIconSize,
        color: c.textMuted,
      ),
    );
  }

  Widget _buildLoader(AppColors c) {
    return Container(
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.bgElevated,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: SizedBox(
        width: widget.loaderSize,
        height: widget.loaderSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: c.accent,
        ),
      ),
    );
  }
}
