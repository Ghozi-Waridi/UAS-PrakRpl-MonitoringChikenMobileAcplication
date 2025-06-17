
import 'package:get/route_manager.dart';
import 'package:project_uas/Configs/Routes/Routes.dart';
import 'package:project_uas/Feature/Data_ayam/Page/data_ayam_page.dart';
import 'package:project_uas/Feature/History/view/Page/history_page.dart';
import 'package:project_uas/Feature/Home/view/Page/home_page.dart';
import 'package:project_uas/Feature/Informations/SubFeature/DetailInformation/Page/Detailinformation_page.dart';
import 'package:project_uas/Feature/Informations/view/Page/information_page.dart';
import 'package:project_uas/Feature/auth/view/page/Auth_page.dart';

abstract class Pages {
  static final pages = [
    GetPage(name: Routes.home, page: () => HomePage() ),
    GetPage(name: Routes.dataAyam, page: () => DataAyamPage()),
    GetPage(name: Routes.history, page: () => HistoryPage()),
    GetPage(name: Routes.information, page: () => InformationPage()),
    GetPage(name: Routes.detailInformation, page: () => Detailinformation()),
    GetPage(name: Routes.auth, page: () => AuthPage()),
  ];
}
