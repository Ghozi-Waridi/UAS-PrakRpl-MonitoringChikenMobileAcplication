import 'dart:io';

import 'package:get/get.dart';
import 'package:project_uas/Feature/History/model/DataAyam.dart';
import 'package:project_uas/Feature/Informations/model/DataTelur.dart';
import 'package:project_uas/utils/service/Firebase_service.dart';

class InformationController extends GetxController {
  final RxList<DataTelur> listTelur = <DataTelur>[].obs;
  final RxList<DataAyam> listAyam = <DataAyam>[].obs;
  final FirebaseService service = FirebaseService();
  final RxInt jumlahTelur = 0.obs;
  final RxBool isAfkir = false.obs;
  static InformationController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    loadAllData();
    listenToAyam();
  }


  void listenToAyam() {
    service.refAyam.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final List<DataAyam> tempList = [];
        data.forEach((key, value) {
          tempList.add(DataAyam.fromJson(Map<String, dynamic>.from(value), key));
        });
        listAyam.assignAll(tempList);
      } else {
        listAyam.clear();
      }
    });
  }


/*
 * Controller Untuk bagian Informasi Telur
 */
Future<void> loadAllData() async {
    try {
      final telur = await service.getAllTelur();
      final ayam = await service.getAllAyam();

      listTelur.assignAll(telur);
      listAyam.assignAll(ayam);

    } catch (e) {
      if (e is SocketException) {
        Get.snackbar("Error", "No Internet Connection");
      } else {
        Get.snackbar("Error", e.toString());
      }
    }
  }



  Future<void> addDataTelur(DataTelur telur) async {
    try {
      await service.createTelur(telur);
      loadAllData();
    } catch (e) {
      if (e is SocketException) {
        Get.snackbar("Error", "No Internet Connection");
      } else {
        Get.snackbar("Error", e.toString());
      }
    }
  }

  Future<void> updateDataTelur(DataTelur telur) async {
    try {
      await service.updateTelur(telur);
      loadAllData();
    } catch (e) {
      if (e is SocketException) {
        Get.snackbar("Error", "No Internet Connection");
      } else {
        Get.snackbar("Error", e.toString());
      }
    }
  }

  Future<void> deleteDataTelur(String id) async {
    try {
      await service.deleteTelur(id);
      loadAllData();
    } catch (e) {
      if (e is SocketException) {
        Get.snackbar("Error", "No Internet Connection");
      } else {
        Get.snackbar("Error", e.toString());
      }
    }
  }

  void cekAfkir(){
    final Map<int, List<DataTelur>> grouped = {};

    for(var telur in listTelur){
      grouped.putIfAbsent(int.parse(telur.idAyam!), () => []).add(telur);
    }
    for(var entry in grouped.entries){
      entry.value.sort((a,b) => DateTime.parse(a.tanggal!).compareTo(DateTime.parse(b.tanggal!)));
      int hariTidakTelur = 0;
      DateTime? lastTanggal;

      for(var data in entry.value){
        final currentDate = DateTime.parse(data.tanggal!);

        if(lastTanggal != null){
            final selisih = currentDate.difference(lastTanggal).inDays;
            if(selisih > 1){
              hariTidakTelur += selisih - 1;
            }
        }
        lastTanggal = currentDate;
      }
      if(hariTidakTelur >= 15){
        print("Ayam Dengan ID ${entry.key} Afkir");
        isAfkir.value = true;
      }
    }
  }

  Map<String, Map<String, int>> getTelurPerHariPerBulan(){
    final Map<String, Map<String, int>> result = {};

    for(var telur in listTelur){

      final tanggal = DateTime.parse(telur
      .tanggal!);
      final bulan = "${tanggal.year}-${tanggal.month.toString().padLeft(2, '0')}";
      final hari = "${tanggal.year}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}";

      result.putIfAbsent(bulan, () => {});
      result[bulan]!.update(hari, (value) => value + telur.jumlah,ifAbsent: () => telur.jumlah);
    }
    return result;

  }

  Map<String, int> get getTelurByAyam{
    final Map<String, int> result = {};

    for(var telur in listTelur){
      final id = telur.idAyam;
      result.update(id!, (value) => value + telur.jumlah, ifAbsent: () => telur.jumlah );
    }
    return result;
  }

    Map<String, int> get totalTelurByAyam {
    final Map<String, int> result = {};
    for (var telur in listTelur) {
      final idAyam = telur.idAyam.toString();
      result.update(idAyam, (value) => value + telur.jumlah, ifAbsent: () => telur.jumlah);
    }
    return result;
  }

}
