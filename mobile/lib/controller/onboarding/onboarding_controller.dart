import 'package:client/routes.dart';
import 'package:get/get.dart';

abstract class OnBoardingController extends GetxController {
  toOnBoardingOne();
  toOnBoardingTwo();
  toOnBoardingThree();
  toOnBoardingFour();
}

class OnBoardingControllerImp extends OnBoardingController {
  @override
  toOnBoardingFour() {
    Get.toNamed(AppRoute.onBoardingFour);
  }

  @override
  toOnBoardingOne() {
    Get.offAllNamed(AppRoute.onBoardingOne);
  }

  @override
  toOnBoardingThree() {
    Get.toNamed(AppRoute.onBoardingThree);
  }

  @override
  toOnBoardingTwo() {
    Get.toNamed(AppRoute.onBoardingTwo);
  }
}
