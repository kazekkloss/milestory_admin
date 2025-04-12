import 'package:flutter/material.dart';
import 'package:milestory_crm/features/user_management/users_export.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Lewa część ekranu (zielony container i trzy containery pod nim)
          Expanded(
            flex: 3, // 5/6 szerokości ekranu (czerwony zajmie 1/6)
            child: Column(
              children: [
                // Zielony container (niski i szeroki)
                TopTab(),
                // Trzy containery pod zielonym (rozciągają się do dołu)
                Expanded(
                  child: Row(
                    children: [
                      // Pierwszy container (np. niebieski)
                      Expanded(
                        flex: 1, // 1/3 wysokości (równe proporcje)
                        child: UsersList(),
                      ),
                      // Drugi container (np. żółty)
                      Expanded(
                        flex: 1, // 1/3 wysokości
                        child: UsersList(),
                      ),
                      // Trzeci container (np. fioletowy)
                      Expanded(
                        flex: 1, // 1/3 wysokości
                        child: UsersList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Czerwony container (wąski, po prawej stronie, od góry do dołu)
          Expanded(
            flex: 1, // 1/6 szerokości ekranu
            child: UserEditor(),
          ),
        ],
      ),
    );
  }
}
