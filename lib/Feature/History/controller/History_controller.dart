import 'dart:io';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project_uas/Feature/History/model/DataAyam.dart';
import 'package:project_uas/utils/service/Firebase_service.dart';

class HistoryController extends GetxController {
  final RxList<DataAyam> listAyam = <DataAyam>[].obs;
  final FirebaseService service = FirebaseService();
  static HistoryController get to => Get.find();

  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref().child('dataAyam');

  @override
  void onInit() {
    super.onInit();
    listenToRealtimeDatabase();
  }

  void listenToRealtimeDatabase() {
    try {
      _databaseRef.onValue.listen((DatabaseEvent event) {
        final dataMap = event.snapshot.value as Map<dynamic, dynamic>?;

        if (dataMap != null) {
          final List<DataAyam> temp = [];

          dataMap.forEach((key, value) {
            final ayam = DataAyam.fromJson(Map<String, dynamic>.from(value), key);
            temp.add(ayam);
          });

          listAyam.value = temp;
        } else {
          listAyam.clear();
        }
      });
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> addDataAyam(DataAyam ayam) async {
    try {
      await service.createAyam(ayam);
      // Tidak perlu reload manual, karena sudah pakai listener
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> updateDataAyam(DataAyam ayam) async {
    try {
      await service.updateAyam(ayam);
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> deleteDataAyam(String id) async {
    try {
      await service.deleteAyam(id);
    } catch (e) {
      handleError(e);
    }
  }

  void handleError(dynamic e) {
    if (e is SocketException) {
      Get.snackbar("Error", "No Internet Connection");
    } else {
      Get.snackbar("Error", e.toString());
    }
  }
}
