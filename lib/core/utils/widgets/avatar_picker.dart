import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:milestory_admin/core/core_export.dart';

class AvatarPicker extends StatefulWidget {
  final String? savedUrl;
  final String initials;
  final double size;
  final Function(Uint8List bytes, String fileName) onPicked;
  final VoidCallback? onRemoved;

  const AvatarPicker({
    super.key,
    this.savedUrl,
    required this.initials,
    this.size = 90,
    required this.onPicked,
    this.onRemoved,
  });

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  Uint8List? _pendingBytes;
  String? _currentUrl;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.savedUrl;
  }

  @override
  void didUpdateWidget(AvatarPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.savedUrl != widget.savedUrl) {
      setState(() {
        _currentUrl = widget.savedUrl;
        _pendingBytes = null;
      });
    }
  }

  Future<void> _pick() async {
    FilePickerResult? result;
    try {
      result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );
    } catch (e) {
      debugPrint('AvatarPicker pick error: $e');
      return;
    }

    if (result == null ||
        result.files.isEmpty ||
        result.files.first.bytes == null) {
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final bytes = await compressImageForWeb(result.files.first.bytes!);
      setState(() {
        _pendingBytes = bytes;
        _currentUrl = null;
      });
      widget.onPicked(bytes, result.files.first.name);
    } catch (e) {
      debugPrint('AvatarPicker compress error: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _remove() {
    setState(() {
      if (_pendingBytes != null) {
        _pendingBytes = null;
        _currentUrl = widget.savedUrl;
      } else {
        _currentUrl = null;
      }
    });
    widget.onRemoved?.call();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final s = widget.size;
    final hasImage = _pendingBytes != null ||
        (_currentUrl != null && _currentUrl!.isNotEmpty);

    const clipRadius = BorderRadius.all(Radius.circular(55));

    Widget circle;
    if (_pendingBytes != null) {
      circle = ClipRRect(
        borderRadius: clipRadius,
        child: Image.memory(_pendingBytes!,
            width: s, height: s, fit: BoxFit.cover),
      );
    } else if (_currentUrl != null && _currentUrl!.isNotEmpty) {
      circle = ClipRRect(
        borderRadius: clipRadius,
        child: Image.network(
          _currentUrl!,
          width: s,
          height: s,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: s,
              height: s,
              child: Container(
                color: Colors.black.withValues(alpha: 0.15),
                child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            );
          },
          errorBuilder: (_, __, ___) => _initialsCircle(s, c),
        ),
      );
    } else {
      circle = _initialsCircle(s, c);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _isProcessing ? null : _pick,
          child: Stack(
            children: [
              SizedBox(width: s, height: s, child: circle),
              if (_isProcessing)
                SizedBox(
                  width: s,
                  height: s,
                  child: ClipRRect(
                    borderRadius: clipRadius,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconActionButton(
                icon: Icons.photo_camera_outlined,
                color: c.textSecondary,
                tooltip: "Wybierz zdjęcie",
                onTap: _pick,
              ),
              hasImage && widget.onRemoved != null
                  ? IconActionButton(
                      icon: FontAwesomeIcons.trashCan,
                      iconSize: 12,
                      color: c.dangerColor,
                      tooltip: "Usuń zdjęcie",
                      onTap: _remove,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _initialsCircle(double size, AppColors c) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: c.accent.withValues(alpha: 0.08),
        border: Border.all(color: c.accent.withValues(alpha: 0.2), width: 1),
      ),
      child: Center(
        child: Text(
          widget.initials,
          style: TextStyle(
            fontSize: size * 0.34,
            fontWeight: FontWeight.w500,
            color: c.accent,
          ),
        ),
      ),
    );
  }
}
