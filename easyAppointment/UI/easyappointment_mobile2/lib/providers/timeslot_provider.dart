import '../models/time-slot.dart';
import 'package:easyappointment_mobile/providers/base_provider.dart';

class TimeSlotProvider extends BaseProvider<TimeSlot> {
  TimeSlotProvider() : super("/TimeSlots");

  @override
  TimeSlot fromJson(data) {
    return TimeSlot.fromJson(data);
  }
}
