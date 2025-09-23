import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:get_it/get_it.dart';
import 'package:milestory_crm/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:milestory_crm/features/guide_application_management/presentation/guide_application_bloc/guide_application_bloc.dart';
import 'package:milestory_crm/features/user_management/users_export.dart';
import 'package:milestory_crm/injection.dart' as di;
import 'package:milestory_crm/features/tour_management/tour_managenent_export.dart';

import 'core/core_export.dart';
import 'features/creator/creator_export.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('pl_PL', null);
    await dotenv.load(fileName: ".env");
    await di.init();
    runApp(const MileStoryCrmApp());
  } catch (e) {
    debugPrint('Błąd podczas inicjalizacji aplikacji: $e');
  }
}

class MileStoryCrmApp extends StatelessWidget {
  const MileStoryCrmApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetIt.I<AuthBloc>()),
        BlocProvider(create: (context) => GetIt.I<UsersBloc>()),
        BlocProvider(create: (context) => GetIt.I<GuideApplicationBloc>()),
        BlocProvider(create: (context) => GetIt.I<GuideApplicationBloc>()),
        BlocProvider(create: (context) => GetIt.I<TourManagementBloc>()),
        BlocProvider(create: (context) => GetIt.I<CreatorBloc>()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(theme: CustomTheme.theme, routerConfig: AppRouter(context: context).router, debugShowCheckedModeBanner: false);
        },
      ),
    );
  }
}
