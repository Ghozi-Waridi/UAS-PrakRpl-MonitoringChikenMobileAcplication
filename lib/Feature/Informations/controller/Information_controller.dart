// import 'dart:io';

// import 'package:get/get.dart';
// import 'package:project_uas/Feature/History/model/DataAyam.dart';
// import 'package:project_uas/Feature/Informations/model/DataTelur.dart';
// import 'package:project_uas/utils/service/Firebase_service.dart';

// class InformationController extends GetxController {
//   final RxList<DataTelur> listTelur = <DataTelur>[].obs;
//   final RxList<DataAyam> listAyam = <DataAyam>[].obs;
//   final FirebaseService service = FirebaseService();
//   final RxMap<String, bool> isAfkirMap = <String, bool>{}.obs;
//   final RxBool isAfkir = false.obs;
//   static InformationController get to => Get.find();

//   @override
//   void onInit() {
//     super.onInit();
//     loadAllData();
//     listenToAyam();
//   }

//   void listenToAyam() {
//     service.refAyam.onValue.listen((event) {
//       final data = event.snapshot.value as Map<dynamic, dynamic>?;
//       if (data != null) {
//         final List<DataAyam> tempList = [];
//         data.forEach((key, value) {
//           tempList.add(
//             DataAyam.fromJson(Map<String, dynamic>.from(value), key),
//           );
//         });
//         listAyam.assignAll(tempList);
//         cekAfkir(); // Periksa status afkir setelah data ayam diperbarui
//       } else {
//         listAyam.clear();
//       }
//     });
//     update();
//   }

//   void listenToTelur() {
//     service.refTelur.onValue.listen((event) {
//       final data = event.snapshot.value as Map<dynamic, dynamic>?;
//       if (data != null) {
//         final List<DataTelur> tempList = [];
//         data.forEach((key, value) {
//           tempList.add(
//             DataTelur.fromJson(Map<String, dynamic>.from(value), key),
//           );
//         });
//         listTelur.assignAll(tempList);
//         cekAfkir(); // Periksa status afkir setelah data ayam diperbarui
//       } else {
//         listTelur.clear();
//       }
//     });
//   }

//   Future<void> loadAllData() async {
//     try {
//       final telur = await service.getAllTelur();
//       final ayam = await service.getAllAyam();

//       listTelur.assignAll(telur);
//       listAyam.assignAll(ayam);

//       cekAfkir(); // Periksa afkir setelah data telur dan ayam dimuat
//     } catch (e) {
//       if (e is SocketException) {
//         Get.snackbar("Error", "No Internet Connection");
//       } else {
//         Get.snackbar("Error", e.toString());
//       }
//     }
//     update();
//   }

//   void cekAfkir() {
//     final Map<int, List<DataTelur>> grouped = {};

//     final hidupAyam =
//         listAyam
//             .where((ayam) => ayam.kategori.toLowerCase() == 'hidup')
//             .toList();
//     print("CekAFkir Hidup ayam : $hidupAyam");
//     for (var telur in listTelur) {
//       print("CelAfkir ListTelur ${telur.jumlah}");
//       if (hidupAyam.any((ayam) => ayam.id == telur.idAyam)) {
//         grouped.putIfAbsent(int.parse(telur.idAyam!), () => []).add(telur);
//         print(" hasil Group ${grouped.length}");
//         // Groudp berhasil dan data juga sudah sesuai
//       }
//     }

//     for (var entry in grouped.entries) {
//       print("Coba${grouped.entries.toList}");
//       print("CakAfkir entry : ${entry.value}"); // 16

//       entry.value.sort(
//         (a, b) =>
//             DateTime.parse(a.tanggal!).compareTo(DateTime.parse(b.tanggal!)),
//       );

//       print("Cek Afkir ${entry.value[0].jumlah}");

//       int hariTidakTelur = 0;
//       DateTime? lastTanggal;
//       for (var data in entry.value) {
//         if (data.jumlah == 0 && data.jumlah != null) {
//           hariTidakTelur += 1;
//           lastTanggal = DateTime.parse(data.tanggal!);
//         } else {
//           hariTidakTelur = 0;
//         }
//       }

//       if (hariTidakTelur >= 10) {
//         print(
//           "Ayam ID ${entry.key}: Status Afkir - Hari Tidak Telur = $hariTidakTelur",
//         );
//         print("Afir  ${entry.key.toString()}");
//         isAfkirMap[entry.key.toString()] =
//             true; // Tandai ayam ini sebagai afkir
//         isAfkir(true);
//       } else {
//         print(
//           "Ayam ID ${entry.key}: Status Sehat - Hari Tidak Telur = $hariTidakTelur",
//         );
//         isAfkirMap[entry.key.toString()] = false;
//         isAfkir(false);
//       }
//     }
//     update();
//   }

//   Map<String, int> get totalTelurByAyam {
//     final Map<String, int> result = {};
//     for (var telur in listTelur) {
//       final idAyam = telur.idAyam.toString();
//       result.update(
//         idAyam,
//         (value) => value + telur.jumlah,
//         ifAbsent: () => telur.jumlah,
//       );
//     }
//     print("Total Telur: $result"); // Debugging
//     update();
//     return result;
//   }

//   Map<String, Map<String, int>> getTelurPerHariPerBulan() {
//     final Map<String, Map<String, int>> result = {};

//     // Menyusun telur berdasarkan tanggal untuk perhitungan
//     for (var telur in listTelur) {
//       final tanggal = DateTime.parse(telur.tanggal!);
//       final bulan =
//           "${tanggal.year}-${tanggal.month.toString().padLeft(2, '0')}";
//       final hari =
//           "${tanggal.year}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}";

//       result.putIfAbsent(bulan, () => {});
//       result[bulan]!.update(
//         hari,
//         (value) => value + telur.jumlah,
//         ifAbsent: () => telur.jumlah,
//       );
//     }

//     // Menambahkan hari yang tidak bertelur dengan nilai 0
//     for (var bulan in result.keys) {
//       final bulanData = result[bulan]!;
//       final allDaysInMonth = _getAllDaysInMonth(
//         bulan,
//       ); // Ambil semua tanggal di bulan tersebut

//       for (var day in allDaysInMonth) {
//         bulanData.putIfAbsent(
//           day,
//           () => 0,
//         ); // Jika tidak ada telur pada hari tersebut, set ke 0
//       }
//     }
//     update();
//     return result;
//   }

//   List<String> _getAllDaysInMonth(String month) {
//     final date = DateTime.parse('$month-01');
//     final lastDay = DateTime(
//       date.year,
//       date.month + 1,
//       0,
//     ); // Mendapatkan hari terakhir dalam bulan

//     List<String> allDays = [];
//     for (var day = 1; day <= lastDay.day; day++) {
//       final dayString =
//           "${date.year}-${date.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
//       allDays.add(dayString);
//     }
//     update();
//     return allDays;
//   }

//   Map<String, int> get getTelurByAyam {
//     final Map<String, int> result = {};

//     for (var telur in listTelur) {
//       final id = telur.idAyam;
//       result.update(
//         id!,
//         (value) => value + telur.jumlah,
//         ifAbsent: () => telur.jumlah,
//       );
//     }
//     update();
//     return result;
//   }
// }


import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:project_uas/Feature/History/model/DataAyam.dart';
import 'package:project_uas/Feature/Informations/model/DataTelur.dart';
import 'package:project_uas/utils/service/Firebase_service.dart';
import 'package:project_uas/utils/service/Notification_Service.dart';

class InformationController extends GetxController {
  final RxList<DataTelur> listTelur = <DataTelur>[].obs;
  final RxList<DataAyam> listAyam = <DataAyam>[].obs;
  final FirebaseService service = FirebaseService();
  final RxMap<String, bool> isAfkirMap = <String, bool>{}.obs;
  final RxBool isAfkir = false.obs;
  final RxBool isLoading = true.obs;
  
  static InformationController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    initRealtimeListeners();
  }
  
  @override
  void onClose() {
    disposeRealtimeListeners();
    super.onClose();
  }
  
  
  void initRealtimeListeners() {
    isLoading.value = true;
    listenToAyam();
    listenToTelur();
    loadAllData();
  }
  

  void disposeRealtimeListeners() {
    // If you have any StreamSubscription objects, cancel them here
    // This prevents memory leaks when the controller is no longer needed
  }

  void listenToAyam() {
    service.refAyam.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final List<DataAyam> tempList = [];
        data.forEach((key, value) {
          tempList.add(
            DataAyam.fromJson(Map<String, dynamic>.from(value), key),
          );
        });
        listAyam.assignAll(tempList);
        cekAfkir(); 
      } else {
        listAyam.clear();
      }
      isLoading.value = false;
    }, onError: (error) {
      print('Error reading ayam data: $error');
      isLoading.value = false;
      Get.snackbar("Error", "Failed to load chicken data");
    });
  }

  void listenToTelur() {
    service.refTelur.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final List<DataTelur> tempList = [];
        data.forEach((key, value) {
          tempList.add(
            DataTelur.fromJson(Map<String, dynamic>.from(value), key),
          );
        });
        listTelur.assignAll(tempList);
        cekAfkir(); // Check afkir status after egg data is updated
      } else {
        listTelur.clear();
      }
      isLoading.value = false;
    }, onError: (error) {
      print('Error reading telur data: $error');
      isLoading.value = false;
      Get.snackbar("Error", "Failed to load egg data");
    });
  }

  Future<void> loadAllData() async {
    isLoading.value = true;
    try {
      final telur = await service.getAllTelur();
      final ayam = await service.getAllAyam();

      listTelur.assignAll(telur);
      listAyam.assignAll(ayam);

      cekAfkir(); 
    } catch (e) {
      if (e is SocketException) {
        Get.snackbar("Error", "No Internet Connection");
      } else {
        Get.snackbar("Error", e.toString());
      }
    }
    isLoading.value = false;
  }

   void cekAfkir() async {
    final Map<int, List<DataTelur>> grouped = {};

    final hidupAyam =
        listAyam
            .where((ayam) => ayam.kategori.toLowerCase() == 'hidup')
            .toList();
    print("CekAFkir Hidup ayam : $hidupAyam");
    for (var telur in listTelur) {
      print("CelAfkir ListTelur ${telur.jumlah}");
      if (hidupAyam.any((ayam) => ayam.id == telur.idAyam)) {
        grouped.putIfAbsent(int.parse(telur.idAyam!), () => []).add(telur);
        print(" hasil Group ${grouped.length}");
        // Groudp berhasil dan data juga sudah sesuai
      }
    }

    for (var entry in grouped.entries) {
      print("Coba${grouped.entries.toList}");
      print("CakAfkir entry : ${entry.value}"); // 16

      entry.value.sort(
        (a, b) =>
            DateTime.parse(a.tanggal!).compareTo(DateTime.parse(b.tanggal!)),
      );

      print("Cek Afkir ${entry.value[0].jumlah}");

      int hariTidakTelur = 0;
      DateTime? lastTanggal;
      for (var data in entry.value) {
        if (data.jumlah == 0 && data.jumlah != null) {
          hariTidakTelur += 1;
          lastTanggal = DateTime.parse(data.tanggal!);
        } else {
          hariTidakTelur = 0;
        }
      }

      if (hariTidakTelur >= 15) {
        print(
          "Ayam ID ${entry.key}: Status Afkir - Hari Tidak Telur = $hariTidakTelur",
        );
        print("Afir  ${entry.key.toString()}");
        isAfkirMap[entry.key.toString()] =
            true; // Tandai ayam ini sebagai afkir
        isAfkir(true);
          await NotificationService().showNotification(
          id: entry.key, 
          title: 'Peringatan Afkir',
          body: 'Ayam ID ${entry.key} terdeteksi afkir! Tidak bertelur selama $hariTidakTelur hari.',
          payload: 'afkir_${entry.key}',
        );
      } else {
        print(
          "Ayam ID ${entry.key}: Status Sehat - Hari Tidak Telur = $hariTidakTelur",
        );
        isAfkirMap[entry.key.toString()] = false;
        isAfkir(false);
      }
    }
    update();

  }

  Map<String, int> get totalTelurByAyam {
    final Map<String, int> result = {};
    for (var telur in listTelur) {
      final idAyam = telur.idAyam.toString();
      result.update(
        idAyam,
        (value) => value + telur.jumlah,
        ifAbsent: () => telur.jumlah,
      );
    }
    print("Total Telur: $result"); // Debugging
    update();
    return result;
  }

  Map<String, Map<String, int>> getTelurPerHariPerBulan() {
    final Map<String, Map<String, int>> result = {};

    // Menyusun telur berdasarkan tanggal untuk perhitungan
    for (var telur in listTelur) {
      final tanggal = DateTime.parse(telur.tanggal!);
      final bulan =
          "${tanggal.year}-${tanggal.month.toString().padLeft(2, '0')}";
      final hari =
          "${tanggal.year}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}";

      result.putIfAbsent(bulan, () => {});
      result[bulan]!.update(
        hari,
        (value) => value + telur.jumlah,
        ifAbsent: () => telur.jumlah,
      );
    }

    // Menambahkan hari yang tidak bertelur dengan nilai 0
    for (var bulan in result.keys) {
      final bulanData = result[bulan]!;
      final allDaysInMonth = _getAllDaysInMonth(
        bulan,
      ); // Ambil semua tanggal di bulan tersebut

      for (var day in allDaysInMonth) {
        bulanData.putIfAbsent(
          day,
          () => 0,
        ); // Jika tidak ada telur pada hari tersebut, set ke 0
      }
    }
    update();
    return result;
  }

  List<String> _getAllDaysInMonth(String month) {
    final date = DateTime.parse('$month-01');
    final lastDay = DateTime(
      date.year,
      date.month + 1,
      0,
    ); // Mendapatkan hari terakhir dalam bulan

    List<String> allDays = [];
    for (var day = 1; day <= lastDay.day; day++) {
      final dayString =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
      allDays.add(dayString);
    }
    update();
    return allDays;
  }

  Map<String, int> get getTelurByAyam {
    final Map<String, int> result = {};

    for (var telur in listTelur) {
      final id = telur.idAyam;
      result.update(
        id!,
        (value) => value + telur.jumlah,
        ifAbsent: () => telur.jumlah,
      );
    }
    update();
    return result;
  }
}
