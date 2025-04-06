import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:milestory_crm/features/auth/presentation/auth_bloc/auth_bloc.dart';
import '../../core_export.dart';

class GlobalErrorListener<B extends Bloc<dynamic, S>, S> extends StatelessWidget {
  final Widget child;

  const GlobalErrorListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listener: (context, state) {
        final dynamic currentState = state;
        final AppError? error = currentState.error as AppError?;
        String errorMessage = "";

        if (error != null) {
          if (error.apiError != null) {
            if (error.apiError!.code == 401) {
              //context.read<AuthBloc>().add(LogoutEvent(isLocal: true));
              return;
            }
            errorMessage = error.apiError!.message;
          } else if (error.message != null) {
            errorMessage = "${error.message}";
          } else {
            errorMessage = "An unknown error occurred";
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
          );
        }
      },
      child: child,
    );
  }
}
