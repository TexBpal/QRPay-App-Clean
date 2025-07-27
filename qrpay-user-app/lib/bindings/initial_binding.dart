import 'package:get/get.dart';

import '../controller/navbar/dashboard_controller.dart';
import '../views/set_up_pin/controller/set_up_pin_controller.dart';

class InitialScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(DashBoardController());
        Get.put(SetUpPinController(), permanent: true);
  }
}
