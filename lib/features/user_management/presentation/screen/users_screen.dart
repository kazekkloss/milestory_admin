import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milestory_admin/core/core_export.dart';
import '../bloc/users_bloc.dart';
import '../widgets/user_editor.dart';
import '../widgets/users_list.dart';
import '../widgets/users_top_tab.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final narrow = SizeConfig.isNarrow(context);

    return BlocProvider.value(
      value: context.read<UsersBloc>(),
      child: GlobalErrorListener(
        child: Scaffold(
          backgroundColor: AppColors.of(context).bg,
          body: AnimatedAppContainer(
            child: narrow ? _narrowLayout() : _wideLayout(),
          ),
        ),
      ),
    );
  }

  Widget _wideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Expanded(
          child: Column(
            children: [
              UsersTopTab(),
              Expanded(child: UsersList()),
            ],
          ),
        ),
        const SizedBox(
          width: SizeConfig.sidePanelWidth,
          child: UserEditor(),
        ),
      ],
    );
  }

  Widget _narrowLayout() {
    return const Column(
      children: [
        UsersTopTab(),
        Expanded(child: UsersList()),
      ],
    );
  }
}
