import 'package:flutter/material.dart';

import '../../../../../core/core_export.dart';
import '../../tour_managenent_export.dart';

class TourPage extends StatefulWidget {
  const TourPage({super.key});

  @override
  State<TourPage> createState() => _TourPageState();
}

class _TourPageState extends State<TourPage> {
  @override
  Widget build(BuildContext context) {
    return const GlobalErrorListener<TourManagementBloc, TourManagementState>(
      child: Scaffold(
        body: Row(
          children: [
            Expanded(child: Column(children: [TopTab(), Expanded(child: TourList())])),
            SizedBox(width: 340, child: TourInfo()),
          ],
        ),
      ),
    );
  }
}
