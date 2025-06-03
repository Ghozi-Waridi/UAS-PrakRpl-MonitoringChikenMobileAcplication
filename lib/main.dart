import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_uas/Configs/page/pages.dart';
import 'package:project_uas/Configs/Routes/Routes.dart';
import 'package:project_uas/Feature/Data_ayam/controller/DataAyam_controller.dart';
import 'package:project_uas/Feature/History/controller/History_controller.dart';
import 'package:project_uas/Feature/Informations/controller/Information_controller.dart';
import 'package:project_uas/Feature/auth/controller/Auth_controller.dart';
import 'package:project_uas/utils/service/Notification_Service.dart';
// import 'package:project_uas/Feature/auth/view/page/Auth_page.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

;
  await NotificationService().init();

  Get.put(HistoryController());
  Get.put(InformationController());
  Get.put(DataAyamController());
  Get.put(AuthController());
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'Chicken Project',
      initialRoute: Routes.auth,
      getPages: Pages.pages,

    );
    // return MaterialApp(
    //   home: AuthPage(),
    // );
  }
}
