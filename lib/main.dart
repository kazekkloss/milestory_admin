import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:milestory_crm/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:milestory_crm/injection.dart' as di;

import 'core/core_export.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    await di.init();
    runApp(const MyApp());
  } catch (e) {
    debugPrint('Błąd podczas inicjalizacji aplikacji: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetIt.I<AuthBloc>()),
      ],
      child: Builder(builder: (context) {
        return MaterialApp.router(
          theme: CustomTheme.theme,
          routerConfig: AppRouter(context: context).router,
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}
