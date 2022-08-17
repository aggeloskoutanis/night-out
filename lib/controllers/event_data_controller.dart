import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class EventDataController extends GetxController {
  RxString eventName = ''.obs;
  RxString eventDate = ''.obs;

  setEventName(String name) {
    eventName.value = name;
  }

  setEventDate(String date) {
    eventDate.value = date;
  }
}
