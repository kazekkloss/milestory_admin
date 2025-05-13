import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/core_export.dart';
import '../../guide_application_export.dart';

class GuideApplicationList extends StatefulWidget {
  const GuideApplicationList({super.key});

  @override
  State<GuideApplicationList> createState() => _GuideApplicationListState();
}

class _GuideApplicationListState extends State<GuideApplicationList> {
  int _currentPage = 1;

  late GuideApplicationBloc _guideApplicationBloc;

  @override
  void initState() {
    _guideApplicationBloc = context.read<GuideApplicationBloc>();
    _guideApplicationBloc.add(GetGuideApplicationsEvent(page: _currentPage));
    super.initState();
  }

  void _loadMore() {
    setState(() {
      _currentPage++;
    });
    _guideApplicationBloc.add(GetGuideApplicationsEvent(page: _currentPage, isLoadMore: true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuideApplicationBloc, GuideApplicationState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: AppContainer(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _currentPage = 1;
                            });
                            _guideApplicationBloc.add(GetGuideApplicationsEvent(page: _currentPage, isLoadMore: false));
                          },
                          icon: const Icon(Icons.refresh, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        state.guideApplicationList.isEmpty
                            ? const Center(child: Text("Brak zgłoszeń"))
                            : GridView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1, // Jedna kolumna, jak w Twoim kodzie
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 0,
                                childAspectRatio: 4,
                              ),
                              itemCount: state.guideApplicationList.length + 1,
                              itemBuilder: (context, index) {
                                if (index == state.guideApplicationList.length) {
                                  return state.guideApplicationList.length % 20 == 0
                                      ? Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Container(
                                          color: CustomColorScheme.customColorScheme.onPrimary,
                                          child: Center(
                                            child: SizedBox(
                                              height: 40,
                                              width: 150,
                                              child: CustomElevatedButton(
                                                onPressed: _loadMore,
                                                text: "Załaduj więcej",
                                                isLoading: state.getApplicationsLoading,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      : const SizedBox.shrink();
                                }
                                final guideApplication = state.guideApplicationList[index];
                                return GuideApplicationTab(
                                  guideApplication: guideApplication,
                                  selected: guideApplication.id == state.selectedApplication!.id,
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class GuideApplicationTab extends StatelessWidget {
  final GuideApplication guideApplication;
  final bool selected;
  const GuideApplicationTab({super.key, required this.guideApplication, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () => context.read<GuideApplicationBloc>().add(SelectApplicationEvent(guideApplicationId: guideApplication.id)),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? Theme.of(context).primaryColor : const Color.fromARGB(255, 49, 49, 49),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  guideApplication.name!,
                  style: selected ? CustomTextTheme.textTheme.labelMedium!.copyWith(color: Colors.black) : CustomTextTheme.textTheme.labelMedium!,
                ),
                Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(guideApplication.createdAt!),
                  style: selected ? CustomTextTheme.textTheme.labelMedium!.copyWith(color: Colors.black) : CustomTextTheme.textTheme.labelMedium!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
