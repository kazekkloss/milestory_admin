import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milestory_admin/features/audio/presentation/bloc/audio_bloc.dart';
import 'package:milestory_admin/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:milestory_admin/features/creator/presentation/creator_bloc/creator_bloc.dart';
import 'package:milestory_admin/features/guide_user/presentation/guide_user_bloc/guide_user_bloc.dart';
import 'package:milestory_admin/features/tour/presentation/bloc/tour_bloc.dart';

import '../../core_export.dart';

class GlobalErrorListener extends StatelessWidget {
  final Widget child;

  const GlobalErrorListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // ==================== AuthBloc ====================
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) {
            final currUiEvent = (current as dynamic).uiEvent as UiEvent?;
            return currUiEvent != null;
          },
          listener: (context, state) => _handleUiEvent(context, state),
        ),

        // ==================== CreatorBloc ====================
        BlocListener<CreatorBloc, CreatorState>(
          listenWhen: (previous, current) {
            final currUiEvent = (current as dynamic).uiEvent as UiEvent?;
            return currUiEvent != null;
          },
          listener: (context, state) => _handleUiEvent(context, state),
        ),

        // ==================== TourBloc ====================
        BlocListener<TourBloc, TourState>(
          listenWhen: (previous, current) {
            final prevUiEvent = (previous as dynamic).uiEvent as UiEvent?;
            final currUiEvent = (current as dynamic).uiEvent as UiEvent?;
            return currUiEvent != null && prevUiEvent != currUiEvent;
          },
          listener: (context, state) => _handleUiEvent(context, state),
        ),

        // ==================== GuideUserBloc ====================
        BlocListener<GuideUserBloc, GuideUserState>(
          listenWhen: (previous, current) {
            final currUiEvent = (current as dynamic).uiEvent as UiEvent?;
            return currUiEvent != null;
          },
          listener: (context, state) => _handleUiEvent(context, state),
        ),

        // ==================== AudioBloc ====================
        BlocListener<AudioBloc, AudioState>(
          listenWhen: (previous, current) {
            final currUiEvent = (current as dynamic).uiEvent as UiEvent?;
            return currUiEvent != null;
          },
          listener: (context, state) => _handleUiEvent(context, state),
        ),
      ],
      child: child,
    );
  }

  void _handleUiEvent(BuildContext context, dynamic state) {
    final UiEvent? uiEvent = (state as dynamic).uiEvent as UiEvent?;
    if (uiEvent == null) return;

    if (uiEvent.httpStatus == 401) {
      context.read<AuthBloc>().add(LogoutEvent(isLocal: true));
      return;
    }

    // Structured business errors are handled by widget-level BlocListeners
    if (uiEvent.code != null) return;

    final String message = uiEvent.message;

    final c = AppColors.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 350,
        content: Text(message, textAlign: TextAlign.center),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: uiEvent.isError ? c.error : const Color(0xFF1D9E75),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(c.radiusMd),
        ),
      ),
    );
  }
}