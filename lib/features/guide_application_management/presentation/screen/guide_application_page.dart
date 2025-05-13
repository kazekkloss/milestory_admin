import 'package:flutter/material.dart';
import 'package:milestory_crm/core/utils/widgets/error_listener.dart';
import 'package:milestory_crm/features/guide_application_management/presentation/widgets/applications_list.dart';

import '../../guide_application_export.dart';

class GuideApplicationManagementPage extends StatefulWidget {
  const GuideApplicationManagementPage({super.key});

  @override
  State<GuideApplicationManagementPage> createState() => _GuideApplicationManagementPageState();
}

class _GuideApplicationManagementPageState extends State<GuideApplicationManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlobalErrorListener<GuideApplicationBloc, GuideApplicationState>(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  TopTab(),
                  Expanded(child: Row(children: [Expanded(flex: 2, child: GuideApplicationEditor())])),
                ],
              ),
            ),
            Expanded(flex: 1, child: GuideApplicationList()),
          ],
        ),
      ),
    );
  }
}