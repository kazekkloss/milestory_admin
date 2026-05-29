import 'package:flutter/material.dart';

import '../../../../core/core_export.dart';
import '../../tour_export.dart';

class TourPage extends StatefulWidget {
  final TourStatus? initialStatus;
  final UserToursArgs? userArgs;

  const TourPage({super.key, this.initialStatus, this.userArgs});

  @override
  State<TourPage> createState() => _TourPageState();
}

class _TourPageState extends State<TourPage> {
  @override
  Widget build(BuildContext context) {
    final narrow = SizeConfig.isNarrow(context);

    return GlobalErrorListener(
      child: Scaffold(
        body: AnimatedAppContainer(
          child: narrow ? _narrowLayout() : _wideLayout(),
        ),
      ),
    );
  }

  // ── Wide: list + right sidebar editor ──
  Widget _wideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            children: [
              TopTab(userArgs: widget.userArgs),
              Expanded(
                child: TourList(
                  initialStatus: widget.initialStatus,
                  userId: widget.userArgs?.guideUserId,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: SizeConfig.sidePanelWidth,
          child: TourEditor(),
        ),
      ],
    );
  }

  // ── Narrow ──
  Widget _narrowLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          TopTab(userArgs: widget.userArgs),
          TourList(initialStatus: widget.initialStatus),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: TourPreviewCard(),
          ),
        ],
      ),
    );
  }
}
