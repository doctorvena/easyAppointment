import 'package:eprodaja_admin/models/employee_salon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/user_singleton.dart';
import '../../models/search_result.dart';
import '../../providers/employee_salon_provider.dart';
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
      filter: {'salonId': UserSingleton().loggedInUserSalon?.salonId},
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
      title: 'Employee',
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEmployeePage(
                        refreshData: refreshData,
                      ),
                    ),
                  );
                },
                child: Text('Add Employee'),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Card(
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          'User Name',
                          style: TextStyle(fontStyle: FontStyle.normal),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Email',
                          style: TextStyle(fontStyle: FontStyle.normal),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'First Name',
                          style: TextStyle(fontStyle: FontStyle.normal),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Last Name',
                          style: TextStyle(fontStyle: FontStyle.normal),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Phone',
                          style: TextStyle(fontStyle: FontStyle.normal),
                        ),
                      ),
                      DataColumn(
                        label: Text('Delete'),
                      ),
                    ],
                    rows: result?.result
                            .map(
                              (SalonEmployee e) => DataRow(
                                cells: [
                                  DataCell(Text(e.username ?? '')),
                                  DataCell(Text(e.email ?? '')),
                                  DataCell(Text(e.firstName ?? '')),
                                  DataCell(Text(e.lastName ?? '')),
                                  DataCell(Text(e.phone ?? '')),
                                  DataCell(
                                    Row(
                                      children: [
                                        SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            deleteUser(e.salonEmployeeId!);
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
                Navigator.of(context).pop();
                try {
                  await _salonEmployeeProvider.delete(euserId);
                  await fetchData();
                } catch (e) {
                  print('Error deleting euser: $e');
                }
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
