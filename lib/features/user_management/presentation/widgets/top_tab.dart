import 'package:flutter/material.dart';

import '../../../../core/core_export.dart';

class TopTab extends StatefulWidget {
  const TopTab({super.key});

  @override
  State<TopTab> createState() => _TopTabState();
}

class _TopTabState extends State<TopTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Panel zarządzania użytkownikami", style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 40),
                  AppTextFormField(
                    controller: _searchController,
                    descriptionText: "wpisz nazwę",
                    hintText: "np. Kraków Rynek",
                    onChanged: (value) {
                      //context.read<SearchBloc>().add(GetRoadsEvent(title: value));
                    },
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.cancel_outlined, color: Color.fromARGB(160, 255, 255, 255)),
                      onPressed: () {
                        _searchController.clear();
                        //context.read<SearchBloc>().add(GetRoadsEvent(title: _searchController.text));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
