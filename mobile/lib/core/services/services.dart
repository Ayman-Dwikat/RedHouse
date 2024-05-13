import 'package:get/get.dart';

class MyServices extends GetxService {
  Future<MyServices> init() async {
    return this;
  }
}

initialServices() async {
  await Get.putAsync(() => MyServices().init());
}
