import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web/web.dart' as html;

import '../../../../core/core_export.dart';
import '../../audio_export.dart';

class GlobalAudioPlayer extends StatefulWidget {
  final Uint8List? audioBytes;
  final String? audioFileId;

  const GlobalAudioPlayer({
    super.key,
    this.audioBytes,
    this.audioFileId,
  });

  @override
  State<GlobalAudioPlayer> createState() => GlobalAudioPlayerState();
}

class GlobalAudioPlayerState extends State<GlobalAudioPlayer> {
  // Stałe wymiary — żeby nic nie skakało
  static const double _kHeight = 60;
  static const double _kButtonSize = 40;
  static const double _kIconSize = 40;
  static const double _kSpinnerSize = 24;

  html.HTMLAudioElement? _audio;
  late AudioBloc _audioBloc;

  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _pendingPlay = false;
  bool _sourceResolveTriggered = false;
  bool _sourceSet = false;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  String? _currentSourceUrl;

  StreamSubscription? _timeUpdateSub;
  StreamSubscription? _loadedMetadataSub;
  StreamSubscription? _endedSub;

  @override
  void initState() {
    super.initState();
    _audioBloc = context.read<AudioBloc>();
    _resetFlags();

    _audio = html.HTMLAudioElement()
      ..preload = 'none'
      ..loop = false
      ..controls = false;

    html.document.body?.append(_audio!);
    _setupListeners();
  }

  @override
  void didUpdateWidget(covariant GlobalAudioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.audioFileId != oldWidget.audioFileId ||
        widget.audioBytes?.length != oldWidget.audioBytes?.length) {
      _resetForNewAudio();
    }
  }

  void _resetFlags() {
    _sourceResolveTriggered = false;
    _sourceSet = false;
    _currentSourceUrl = null;
  }

  void _resetForNewAudio() {
    _audio?.pause();
    _audio?.removeAttribute('src');
    _resetFlags();
    _isInitialized = false;
    _isPlaying = false;
    _isLoading = false;
    _pendingPlay = false;
    _duration = Duration.zero;
    _position = Duration.zero;
  }

  void _setupListeners() {
    _loadedMetadataSub = _audio!.onLoadedMetadata.listen((_) {
      if (!mounted) return;
      setState(() {
        _duration = Duration(milliseconds: (_audio!.duration * 1000).round());
        _isInitialized = true;
        _isLoading = false;
      });

      if (_pendingPlay) {
        _audio!.play();
        setState(() {
          _isPlaying = true;
          _pendingPlay = false;
        });
      }
    });

    _timeUpdateSub = _audio!.onTimeUpdate.listen((_) {
      if (!mounted) return;
      setState(() {
        _position =
            Duration(milliseconds: (_audio!.currentTime * 1000).round());
      });
    });

    _endedSub = _audio!.onEnded.listen((_) {
      if (!mounted) return;
      setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _timeUpdateSub?.cancel();
    _loadedMetadataSub?.cancel();
    _endedSub?.cancel();

    _audio?.pause();
    _audio?.removeAttribute('src');
    _audio?.remove();
    _audio = null;

    super.dispose();
  }

  void _handlePlayPause() {
    if (widget.audioBytes == null && widget.audioFileId == null) return;
    if (_audio == null) return;

    if (_isPlaying) {
      _audio!.pause();
      setState(() => _isPlaying = false);
      return;
    }

    if (_isInitialized) {
      _audio!.play();
      setState(() => _isPlaying = true);
      return;
    }

    if (!_sourceResolveTriggered) {
      _sourceResolveTriggered = true;
      setState(() {
        _isLoading = true;
        _pendingPlay = true;
      });

      _audioBloc.add(ResolveAudioSource(
        bytes: widget.audioBytes,
        fileId: widget.audioFileId,
      ));
    }
  }

  Future<void> _updateAudioSource(Uri uri) async {
    final url = uri.toString();
    if (_sourceSet || url == _currentSourceUrl) return;

    _currentSourceUrl = url;
    _audio!.src = url;
    _audio!.load();
    _sourceSet = true;
  }

  String _formatDuration(Duration d) {
    final min = d.inMinutes.toString().padLeft(2, '0');
    final sec = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    final hasSource = widget.audioBytes != null || widget.audioFileId != null;
    final primary = Theme.of(context).colorScheme.primary;

    final timeStyle = TextStyle(
      fontSize: 12,
      fontFeatures: const [FontFeature.tabularFigures()],
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
      letterSpacing: 0.3,
    );

    return BlocConsumer<AudioBloc, AudioState>(
      listenWhen: (prev, curr) =>
          prev.sourceUri != curr.sourceUri || prev.status != curr.status,
      listener: (context, state) {
        if (state.status == AudioSourceStatus.ready &&
            state.sourceUri != null) {
          _updateAudioSource(state.sourceUri!);
        } else if (state.status == AudioSourceStatus.error) {
          setState(() => _isLoading = false);
        }
      },
      builder: (context, state) {
        return AppContainer(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: _kHeight,
          child: Row(
            children: [
              SizedBox(
                width: _kButtonSize,
                height: _kButtonSize,
                child: _buildPlayButton(hasSource, primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3,
                        activeTrackColor: hasSource
                            ? primary
                            : Colors.grey.withValues(alpha: 40),
                        inactiveTrackColor: Colors.grey.withValues(alpha: 25),
                        thumbColor: primary,
                        overlayColor: primary.withValues(alpha: 15),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                          disabledThumbRadius: 5,
                          elevation: 0,
                          pressedElevation: 0,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 14,
                        ),
                        trackShape: const RoundedRectSliderTrackShape(),
                      ),
                      child: SizedBox(
                        height: 16,
                        child: Slider(
                          value: _position.inMilliseconds
                              .toDouble()
                              .clamp(0.0, _duration.inMilliseconds.toDouble()),
                          max: _duration.inMilliseconds.toDouble() > 0
                              ? _duration.inMilliseconds.toDouble()
                              : 1.0,
                          onChanged:
                              (!_isInitialized || _duration == Duration.zero)
                                  ? null
                                  : (value) {
                                      final newPos =
                                          Duration(milliseconds: value.toInt());
                                      _audio?.currentTime =
                                          newPos.inMilliseconds / 1000;
                                      setState(() => _position = newPos);
                                    },
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(_position), style: timeStyle),
                          Text(_formatDuration(_duration), style: timeStyle),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayButton(bool hasSource, Color primary) {
    if (_isLoading) {
      return Center(
        child: SizedBox(
          width: _kSpinnerSize,
          height: _kSpinnerSize,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: primary,
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: hasSource ? _handlePlayPause : null,
        child: Center(
          child: Icon(
            _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
            size: _kIconSize,
            color: hasSource ? primary : Colors.grey.withValues(alpha: 50),
          ),
        ),
      ),
    );
  }
}
