import 'package:eprodaja_admin/models/employee_salon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../app/user_singleton.dart';
import '../../providers/employee_salon_provider.dart';
import '../../providers/timeslot_provider.dart';

class AddTimeSlotPage extends StatefulWidget {
  const AddTimeSlotPage({Key? key}) : super(key: key);

  @override
  _AddTimeSlotPageState createState() => _AddTimeSlotPageState();
}

class _AddTimeSlotPageState extends State<AddTimeSlotPage> {
  late TimeSlotProvider _timeslotProvider;
  late SalonEmployeeProvider _salonEmployeeProvider;

  DateTime _selectedDate = DateTime.now();
  DateTime _endTime = DateTime.now().add(Duration(hours: 1));
  DateTime _startTime = DateTime.now();
  List<SalonEmployee> _employees = [];
  SalonEmployee? _selectedEmployee;

  @override
  void initState() {
    super.initState();
    _timeslotProvider = context.read<TimeSlotProvider>();
    _salonEmployeeProvider = context.read<SalonEmployeeProvider>();

    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    try {
      var employees = await _salonEmployeeProvider
          .get(filter: {'salonId': UserSingleton().loggedInUserSalon?.salonId});
      setState(() {
        _employees = employees.result;
      });
    } catch (e) {
      print('Error fetching employees: $e');
    }
  }

  void _addTimeSlot() async {
    int? employeeId;
    int? salonId;
    if (UserSingleton().role == 'Employee') {
      var salonEmployee = await _salonEmployeeProvider.get(
        filter: {'employeeUserId': UserSingleton().loggedInUserId},
      );
      if (salonEmployee.count > 0) {
        employeeId = salonEmployee.result[0].employeeUserId;
        salonId = salonEmployee.result[0].salonId;
      } else {
        // No salon employee found
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Attention'),
              content: Text('You need to work at a salon first!'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return; // Exit the function or perform any necessary actions
      }
    } else {
      employeeId = _selectedEmployee?.salonEmployeeId;
      // _selectedEmployee?.salonEmployeeId ?? UserSingleton().loggedInUserId;
      salonId = UserSingleton().loggedInUserSalon?.salonId;
    }
    if (employeeId != null) {
      final int duration = _endTime.difference(_startTime).inMinutes;

      final Map<String, dynamic> newTimeSlot = {
        'startTime': DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            _startTime.hour,
            _startTime.minute)),
        'endTime': DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            _endTime.hour,
            _endTime.minute)),
        'employeeId': employeeId,
        'duration': duration,
        'salonId': salonId,
        'status': 'Available'
      };

      try {
        await _timeslotProvider.insert(newTimeSlot);
        Navigator.pop(context, true);
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Error"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              )
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("First chose Employee"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Date',
                style: TextStyle(fontSize: 16),
              ),
              GestureDetector(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != _selectedDate)
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    DateFormat('yMMMd').format(_selectedDate),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Start Time',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_startTime),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      _startTime = DateTime(
                        _startTime.year,
                        _startTime.month,
                        _startTime.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    DateFormat('HH:mm').format(_startTime),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'End Time',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_endTime),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      _endTime = DateTime(
                        _endTime.year,
                        _endTime.month,
                        _endTime.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    DateFormat('HH:mm').format(_endTime),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Duration: ${_endTime.difference(_startTime).inMinutes} minutes',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              if (UserSingleton().role != 'Employee') ...[
                Text(
                  'Employees',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<SalonEmployee>(
                  value: _selectedEmployee,
                  onChanged: (SalonEmployee? newValue) {
                    setState(() {
                      _selectedEmployee = newValue;
                    });
                  },
                  items: _employees.map<DropdownMenuItem<SalonEmployee>>(
                      (SalonEmployee employee) {
                    return DropdownMenuItem<SalonEmployee>(
                      value: employee,
                      child: Text(employee.firstName.toString() +
                          " " +
                          employee.lastName.toString()),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
              ],
              ElevatedButton(
                onPressed: _addTimeSlot,
                child: Text('Add Time Slot'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
