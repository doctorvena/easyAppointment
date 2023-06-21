import '../models/time-slot.dart';
import 'package:eprodaja_admin/providers/base_provider.dart';

class TimeSlotProvider extends BaseProvider<TimeSlot> {
  TimeSlotProvider() : super("/TimeSlots");

  @override
  TimeSlot fromJson(data) {
    // TODO: implement fromJson
    return TimeSlot.fromJson(data);
  }
}
