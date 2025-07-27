

import '../../../backend/model/common/common_success_model.dart';
import '../../../backend/utils/custom_loading_api.dart';
import '../../../backend/utils/custom_snackbar.dart';
import '../../../controller/navbar/dashboard_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/basic_screen_imports.dart';
import '../../../widgets/inputs/password_input_widget.dart';
import '../model/verify_pin_model.dart';
import '../service/pin_setup_service.dart';

class SetUpPinController extends GetxController {
  final dashboardController = Get.find<DashBoardController>();
  // final appSettingsController = Get.find<AppSettingsController>();
  // final RxBool pinVerification = false.obs;

  @override
  void onInit() {
    // pinVerification.value = appSettingsController.appSettingsModel.data.appSettings.user.basicSettings.pinVerification;
    super.onInit();
  }

  final pinController = TextEditingController();
  final oldPinController = TextEditingController();
  final newPinController = TextEditingController();

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late PinVerifyModel _pinVerifyModel;
  PinVerifyModel get pinVerifyModel => _pinVerifyModel;

  Future<PinVerifyModel> pinVerifyProcess(VoidCallback onSuccess) async {
    Map<String, dynamic> body = {
      "pin": pinController.text,
    };

    _isLoading.value = true;
    update();

    // calling  from api service
    await PinSetupServices.pinVerifyApi(body: body).then((value) async {
      _pinVerifyModel = value!;
      pinController.clear();
      oldPinController.clear();
      newPinController.clear();

      Get.close(1);
      onSuccess();

      CustomSnackBar.success(_pinVerifyModel.message.success.first);

      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
      Get.close(1);
      _isLoading.value = false;
    });
    update();
    return _pinVerifyModel;
  }

  ///---------

  late CommonSuccessModel _pinSetupModel;
  CommonSuccessModel get pinSetupModel => _pinSetupModel;

  Future<CommonSuccessModel> pinSetupProcess() async {
    Map<String, dynamic> body = {
      // "pin": pinController.text,
      "pin_code": pinController.text,
      // "old_pin": oldPinController.text,
      // "new_pin": newPinController.text,
    };

    _isLoading.value = true;
    update();

    // calling  from api service
    await PinSetupServices.pinSetUpApi(body: body).then((value) async {
      _pinSetupModel = value!;
      pinController.clear();
      oldPinController.clear();
      newPinController.clear();

      _isLoading.value = false;
      update();
    }).catchError((onError) {
      _isLoading.value = false;
      log.e(onError);
    });
    update();
    return _pinSetupModel;
  }

  ///---------

  late CommonSuccessModel _pinUpdateModel;
  CommonSuccessModel get pinUpdateModel => _pinUpdateModel;

  Future<CommonSuccessModel> pinUpdateProcess() async {
    Map<String, dynamic> body = {
      // "pin": pinController.text,
      // "pin_code": pinController.text,
      "old_pin": oldPinController.text,
      "new_pin": newPinController.text,
    };

    _isLoading.value = true;
    update();

    // calling  from api service
    await PinSetupServices.pinUpdateApi(body: body).then((value) async {
      _pinUpdateModel = value!;

      pinController.clear();
      oldPinController.clear();
      newPinController.clear();

      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
      _isLoading.value = false;
    });
    update();
    return _pinUpdateModel;
  }




  void showPinDialog(BuildContext context, {required VoidCallback onSuccess}) {

    debugPrint("Checking Dialog is enable : ${dashboardController.pinVerification.value}");
    if(!dashboardController.pinVerification.value){
      onSuccess();
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Get.isDarkMode ? CustomColor.blackColor : CustomColor.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    verticalSpace(Dimensions.heightSize * 1.2),

                    /// PIN Field
                    PasswordInputWidget(
                      controller: pinController,
                      hint: Strings.enterPin,
                      label: Strings.enterYourPinToContinue,
                    ),
                    verticalSpace(Dimensions.heightSize * 1.2),

                    /// Submit Button
                    Obx(() => isLoading ? CustomLoadingAPI(): SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              buttonColor: CustomColor.redColor,
                              title: Strings.cancel,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),

                          horizontalSpace(Dimensions.widthSize),
                          Expanded(
                            child: PrimaryButton(
                              title: Strings.submit,
                              onPressed: () {
                                // Navigator.pop(context);
                                pinVerifyProcess(onSuccess);
                              },
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Pin status and verification check
  void pinVerificationCheck({required VoidCallback onChecked}) {
    if(!dashboardController.pinStatus.value && dashboardController.pinVerification.value){
      Get.toNamed(Routes.pinSetupScreen);
    }else{
      debugPrint("CHECKED");
      onChecked();
    }
  }
}

