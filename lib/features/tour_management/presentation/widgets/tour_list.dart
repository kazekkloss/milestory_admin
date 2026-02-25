import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/core_export.dart';
import '../../../auth/presentation/auth_bloc/auth_bloc.dart';
import '../bloc/tour_management_bloc.dart';

class TourList extends StatefulWidget {
  const TourList({super.key});

  @override
  State<TourList> createState() => _TourListState();
}

class _TourListState extends State<TourList> {
  late TourManagementBloc _tourBloc;
  late AuthState _authState;
  int _currentPage = 1;
  TourStatus? _selectedStatus;

  @override
  void initState() {
    _authState = context.read<AuthBloc>().state;
    _tourBloc = context.read<TourManagementBloc>();
    _tourBloc.add(GetToursEvent(userId: _authState.user.id));
    super.initState();
  }

  void _applyFilter() {
    setState(() {
      _currentPage = 1;
    });
    _tourBloc.add(GetToursEvent(page: _currentPage, tourStatus: _selectedStatus, userId: _authState.user.id));
  }

  void _loadMore() {
    setState(() {
      _currentPage++;
    });
    _tourBloc.add(GetToursEvent(page: _currentPage, tourStatus: _selectedStatus, isLoadMore: true, userId: _authState.user.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TourManagementBloc, TourManagementState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
          child: AppContainer(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 20,
                    children: [
                      Row(
                        children: [
                          Text("Status trasy:   ", style: CustomTextTheme.textTheme.labelMedium!),
                          DropdownMenu<TourStatus?>(
                            initialSelection: null,
                            dropdownMenuEntries: [
                              const DropdownMenuEntry(value: null, label: "Wszystkie"),
                              ...TourStatus.values.map(
                                (status) => DropdownMenuEntry(value: status, label: TourStatusData.mapStatusEnumToString(status)),
                              ),
                            ],
                            onSelected: (value) {
                              setState(() {
                                _selectedStatus = value;
                              });
                              _applyFilter();
                            },
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _currentPage = 1;
                          });
                          _tourBloc.add(GetToursEvent(page: _currentPage, tourStatus: _selectedStatus, userId: _authState.user.id));
                        },
                        icon: const Icon(Icons.refresh, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:
                      state.getToursLoading
                          ? const Center(child: CircularProgressIndicator())
                          : state.tours.isEmpty
                          ? const Center(child: Text("Brak tras"))
                          : GridView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 0,
                              childAspectRatio: 4,
                            ),
                            itemCount: state.tours.length + 1,
                            itemBuilder: (context, index) {
                              if (index == state.tours.length) {
                                return state.tours.length % 20 == 0
                                    ? Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Container(
                                        color: CustomColorScheme.customColorScheme.onPrimary,
                                        child: Center(
                                          child: SizedBox(
                                            height: 40,
                                            width: 150,
                                            child: CustomElevatedButton(onPressed: () => _loadMore(), text: "Załaduj więcej", isLoading: false),
                                          ),
                                        ),
                                      ),
                                    )
                                    : const SizedBox.shrink();
                              }
                              final tour = state.tours[index];
                              return TourTab(tour: tour, selected: tour.id == state.selectedTour!.id);
                            },
                          ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TourTab extends StatelessWidget {
  final Tour tour;
  final bool selected;
  const TourTab({super.key, required this.tour, required this.selected});

  @override
  Widget build(BuildContext context) {
    String formattedDate = tour.createdAt != null ? DateFormat('d MMMM yyyy', 'pl_PL').format(tour.createdAt!) : 'Brak daty';

    final statusIcon = TourStatusData.mapStatusEnumToIcon(tour.status);
    final statusText = TourStatusData.mapStatusEnumToString(tour.status);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () => context.read<TourManagementBloc>().add(SelectTourEvent(tourId: tour.id!)),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? Theme.of(context).primaryColor : const Color.fromARGB(255, 49, 49, 49),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              spacing: 30,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    tour.title,
                    style: selected ? CustomTextTheme.textTheme.bodyMedium!.copyWith(color: Colors.black) : CustomTextTheme.textTheme.bodyMedium!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 5,
                      children: [
                        Text(
                          statusText,
                          style:
                              selected ? CustomTextTheme.textTheme.labelSmall!.copyWith(color: Colors.black) : CustomTextTheme.textTheme.labelSmall!,
                        ),
                        Icon(statusIcon.icon, color: selected ? Colors.black : Colors.white, size: 16),
                      ],
                    ),
                    Text(
                      formattedDate,
                      style: selected ? CustomTextTheme.textTheme.labelSmall!.copyWith(color: Colors.black) : CustomTextTheme.textTheme.labelSmall!,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
