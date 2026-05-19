import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:milestory_admin/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:milestory_admin/features/creator/presentation/creator_bloc/creator_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:milestory_admin/injection.dart' as di;

import 'core/core_export.dart';
import 'features/audio/audio_export.dart';
import 'features/guide_user/guide_user_export.dart';
import 'features/tour/tour_export.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('pl_PL', null);
    await dotenv.load(fileName: ".env");
    await di.init();

    final themeCubit = ThemeCubit();
    await themeCubit.init();

    runApp(MyApp(themeCubit: themeCubit));
  } catch (e) {
    debugPrint('Błąd podczas inicjalizacji aplikacji: $e');
  }
}

class MyApp extends StatelessWidget {
  final ThemeCubit themeCubit;
  const MyApp({super.key, required this.themeCubit});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: themeCubit),
        BlocProvider(create: (context) => GetIt.I<AuthBloc>()),
        BlocProvider(create: (context) => GetIt.I<CreatorBloc>()),
        BlocProvider(create: (context) => GetIt.I<TourBloc>()),
        BlocProvider(create: (context) => GetIt.I<GuideUserBloc>()),
        BlocProvider(create: (context) => GetIt.I<AudioBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return Builder(builder: (context) {
            return MaterialApp.router(
              theme: CustomTheme.lightTheme,
              darkTheme: CustomTheme.darkTheme,
              themeMode: themeMode,
              routerConfig: AppRouter(context: context).router,
              debugShowCheckedModeBanner: false,
            );
          });
        },
      ),
    );
  }
}
