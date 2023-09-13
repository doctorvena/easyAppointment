import 'package:eprodaja_admin/providers/base_provider.dart';

import '../models/time-slot.dart';

class TimeSlotProvider extends BaseProvider<TimeSlot> {
  TimeSlotProvider() : super("/TimeSlots");

  @override
  TimeSlot fromJson(data) {
    return TimeSlot.fromJson(data);
  }
}
