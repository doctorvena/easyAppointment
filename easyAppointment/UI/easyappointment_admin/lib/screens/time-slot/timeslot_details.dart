// ignore_for_file: prefer_const_constructors

import 'package:eprodaja_admin/providers/timeslot_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../../models/time-slot.dart';

const List<String> hours = <String>[
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '24'
];

const List<String> minutes = <String>[
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '24',
  '25',
  '26',
  '27',
  '28',
  '29',
  '30',
  '31',
  '32',
  '33',
  '34',
  '35',
  '36',
  '37',
  '38',
  '39',
  '40',
  '41',
  '42',
  '43',
  '44',
  '45',
  '46',
  '47',
  '48',
  '49',
  '50',
  '51',
  '52',
  '53',
  '54',
  '55',
  '56',
  '57',
  '58',
  '59',
  '60'
];

class TimeSlotDetails extends StatefulWidget {
  TimeSlot? timeSlot;
  TimeSlotDetails({Key? key, this.timeSlot}) : super(key: key);

  @override
  State<TimeSlotDetails> createState() => _TimeSlotDetailsState();
}

class _TimeSlotDetailsState extends State<TimeSlotDetails> {
  final _fromKey = GlobalKey<FormBuilderState>();
  late TimeSlotProvider _timeslotprovider;
  Map<String, dynamic> _initvalue = {};
  TimeOfDay _startTime = TimeOfDay(hour: 8, minute: 30);
  TimeOfDay _endTime = TimeOfDay(hour: 8, minute: 30);

  int startHoursValue = int.parse(hours.first);
  int startMinutesValue = int.parse(minutes.first);
  int time = 0;

  late var timeOfDay;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initvalue = {
      'startTime': widget.timeSlot?.startTime,
      'endTime': widget.timeSlot?.endTime,
      'startTime': widget.timeSlot?.startTime,
    };

    _timeslotprovider = context.read<TimeSlotProvider>();

    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement initState
    super.didChangeDependencies();

    // if (widget.timeSlot != null) {
    //   setState(() {
    //     _fromKey.currentState
    //         ?.patchValue({'businessId': widget.timeSlot?.businessId});
    //   });
    // }
  }

  Future initForm() async {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 250, // Adjust the width to your desired value
        height: 250, // Adjust the height to your desired value
        child: Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  false ? Container() : _buildForm(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await _saveTimeSlot();
                      },
                      child: Text("Save"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _saveTimeSlot() async {
    try {
      _fromKey.currentState?.saveAndValidate();
      TimeOfDay duration;
      _endTime.minute == _startTime.minute && _endTime.hour == _startTime.hour
          ? (throw Exception("Duration of the time slot can't be 00:00"))
          : duration = TimeOfDay(
              hour: _endTime.minute >= _startTime.minute
                  ? _endTime.hour - _startTime.hour
                  : (_endTime.hour - _startTime.hour) - 1,
              minute: _endTime.minute >= _startTime.minute
                  ? _endTime.minute - _startTime.minute
                  : 60 - (_startTime.minute - _endTime.minute));

      var request = {
        'startTime':
            '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}:00',
        'endTime':
            '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}:00',
        'duration':
            '${duration.hour.toString().padLeft(2, '0')}:${duration.minute.toString().padLeft(2, '0')}:00',
      };
      print(request);
      await _timeslotprovider.insert(request);
    } catch (e, stackTrace) {
      // Exception or error handling code.
      // e: The caught exception or error object.
      // stackTrace: Stack trace of the error or exception.

      // Handle the exception or error here.
      print('An error occurred: $e');
      print('Stack trace: $stackTrace');
    }
    SystemNavigator.pop();
  }

  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        _startTime = value!;
      });
    });
  }

  void _showTimePickerEnd() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        _endTime = value!;
      });
    });
  }

  FormBuilder _buildForm() {
    return FormBuilder(
        key: _fromKey,
        initialValue: _initvalue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    _startTime.format(context).toString(),
                    style: TextStyle(fontSize: 40),
                  ),
                  Container(
                    child: MaterialButton(
                      onPressed: _showTimePicker,
                      child: Text(
                        "Pick Start time",
                      ),
                      textColor: Colors.white,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    _endTime.format(context).toString(),
                    style: TextStyle(fontSize: 40),
                  ),
                  Container(
                    child: MaterialButton(
                      onPressed: _showTimePickerEnd,
                      child: Text(
                        "Pick End time",
                      ),
                      textColor: Colors.white,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
