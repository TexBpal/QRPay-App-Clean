
import '../../../backend/utils/custom_loading_api.dart';
import '../../../utils/basic_screen_imports.dart';
import '../../../widgets/appbar/appbar_widget.dart';
import '../../../widgets/inputs/password_input_widget.dart';
import '../controller/set_up_pin_controller.dart';

class PinSetupScreen extends StatelessWidget {
  PinSetupScreen({super.key});

  final controller = Get.find<SetUpPinController>();
  final passwordKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        text: Strings.pinSetup,
      ),
      body: Obx(
        () => controller.isLoading
            ? const CustomLoadingAPI()
            : _bodyWidget(context),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.marginSizeHorizontal * 0.9),
      physics: const BouncingScrollPhysics(),
      children: [
        _inputWidget(context),
        _buttonWidget(context),
      ],
    );
  }

  _inputWidget(BuildContext context) {
    return Form(
      key: passwordKey,
      child: Column(
        children: [
          verticalSpace(Dimensions.heightSize * 2),
          !controller.dashboardController.pinStatus.value
              ? Column(
                  children: [
                    PasswordInputWidget(
                      controller: controller.pinController,
                      hint: Strings.enterPin,
                      label: Strings.pinSetup,
                    ),
                    verticalSpace(Dimensions.heightSize),
                  ],
                )
              : Column(
                  children: [
                    PasswordInputWidget(
                      controller: controller.oldPinController,
                      hint: Strings.enterPin,
                      label: Strings.oldPin,
                    ),
                    verticalSpace(Dimensions.heightSize),
                    PasswordInputWidget(
                      controller: controller.newPinController,
                      hint: Strings.enterPin,
                      label: Strings.newPin,
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 2),
      child: Obx(
        () => controller.isLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                onPressed: () {
                  // controller.gotoNavigation();
                  if (passwordKey.currentState!.validate()) {
                    if (!controller.dashboardController.pinStatus.value) {
                      controller.pinSetupProcess();
                    } else {
                      controller.pinUpdateProcess();
                    }
                  }
                },
                title: controller.dashboardController.pinStatus.value
                    ? Strings.update
                    : Strings.pinSetup,
              ),
      ),
    );
  }
}
