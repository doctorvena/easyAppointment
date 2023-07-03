import 'package:eprodaja_admin/models/employee_salon.dart';
import 'package:eprodaja_admin/providers/employee_salon_provider%20copy.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/user_singleton.dart';
import '../../models/search_result.dart';
import '../../widgets/master_screen.dart';
import 'add_employee_page.dart';

class EmployeeOverview extends StatefulWidget {
  const EmployeeOverview({Key? key}) : super(key: key);

  @override
  _EmployeeOverviewState createState() => _EmployeeOverviewState();
}

class _EmployeeOverviewState extends State<EmployeeOverview> {
  late SalonEmployeeProvider _salonEmployeeProvider;
  searchResult<SalonEmployee>? result;

  @override
  void initState() {
    super.initState();
    _salonEmployeeProvider = context.read<SalonEmployeeProvider>();
    fetchData();
  }

  Future<void> fetchData() async {
    var data = await _salonEmployeeProvider.get(
      filter: {'salonId': UserSingleton().loggedInUserSalon.salonId},
    );

    setState(() {
      result = data as searchResult<SalonEmployee>?;
    });
  }

  Future<void> refreshData() async {
    await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Employe',
      child: Column(
        children: [
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddUserPage(refreshData: refreshData),
                ),
              );
            },
            child: Text('Add Employe'),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: const Expanded(
                        child: const Text(
                          'Employee ID',
                          style: const TextStyle(fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: const Expanded(
                        child: const Text(
                          'User Name',
                          style: const TextStyle(fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: const Expanded(
                        child: const Text(
                          'Email',
                          style: const TextStyle(fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text('Delete'),
                    ),
                  ],
                  rows: result?.result
                          .map(
                            (SalonEmployee e) => DataRow(
                              onSelectChanged: (selected) {
                                if (selected == true) {
                                  // Handle row selection
                                }
                              },
                              cells: [
                                DataCell(Text(e.salonId.toString())),
                                DataCell(Text(e.salonEmployeeId.toString())),
                                DataCell(Text(e.employeeUserId.toString())),
                                DataCell(
                                  Row(
                                    children: [
                                      SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          deleteUser(e.employeeUserId!);
                                        },
                                        child: Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList() ??
                      [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deleteUser(int euserId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to delete this euser?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  await _salonEmployeeProvider.delete(euserId);
                  await fetchData(); // Refresh data after deletion
                } catch (e) {
                  // Handle the error
                  print('Error deleting euser: $e');
                  // Show an error message or perform any necessary error handling
                }
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
