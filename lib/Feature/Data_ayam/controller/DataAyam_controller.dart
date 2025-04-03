import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/Feature/no_connection/view/Page/no_connection_page.dart';
import 'package:project_uas/utils/service/Firebase_service.dart';
import 'package:project_uas/Feature/History/model/DataAyam.dart';

class DataAyamController extends GetxController {
  static DataAyamController get to => Get.find();

  final RxInt jumlahHidup = 0.obs;
  final RxInt jumlahMati = 0.obs;
  final RxList<DataAyam> listAyam = <DataAyam>[].obs;

  final FirebaseService service = FirebaseService();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final data = await service.getAllAyam();
      listAyam.value = data;

      jumlahHidup.value = 0;
      jumlahMati.value = 0;

      for (var ayam in data) {
        if (ayam.kategori.toLowerCase() == "hidup") {
          jumlahHidup.value++;
        } else if (ayam.kategori.toLowerCase() == "mati") {
          jumlahMati.value++;
        }
      }
    } catch (e) {
      if (e is SocketException) {
        Get.to(() => const NoConnectionPage());
      } else {
        Get.snackbar("Error", e.toString());
      }
    }
  }

  Future<void> tambahAyam(DataAyam ayam) async {
    try {
      await service.createAyam(ayam);
      await loadData();
    } catch (e) {
      if (e is SocketException) {
        Get.to(() => const NoConnectionPage());
      } else {
        Get.snackbar("Error", e.toString());
      }
    }
  }

  Future<void> hapusAyam(String id) async {
    try {
      await service.deleteAyam(id);
      await loadData();
    } catch (e) {
      if (e is SocketException) {
        Get.to(() => const NoConnectionPage());
      } else {
        Get.snackbar("Error", e.toString());
      }
    }
  }

  Future<void> updateAyam(DataAyam ayam) async {
    try {
      await service.updateAyam(ayam);
      await loadData();
    } catch (e) {
      if (e is SocketException) {
        Get.to(() => const NoConnectionPage());
      } else {
        Get.snackbar("Error", e.toString());
      }
    }
  }

  Future<void> tambahAyamDenganKonfirmasi(
    BuildContext context,
    String kategori,
  ) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Ayam'),
          content: Text('Apakah kamu yakin ingin menambahkan ayam $kategori?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );

    if (konfirmasi == true) {
      await tambahAyam(
        DataAyam(
          kategori: kategori,
          tanggal: DateTime.now().toIso8601String().split("T").first,
        ),
      );
      Get.snackbar("Sukses", "Ayam $kategori ditambahkan");
    }
  }

  Future<void> inputIdDanUpdateKategori(
    BuildContext context,
    String targetKategori,
  ) async {
    final TextEditingController idController = TextEditingController();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Input ID Ayam'),
          content: TextField(
            controller: idController,
            decoration: InputDecoration(
              labelText: 'Masukkan ID ayam',
              hintText: 'Contoh: 005',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final id = idController.text.trim();

      if (id.isEmpty) {
        Get.snackbar("Gagal", "ID tidak boleh kosong");
        return;
      }

      final target = listAyam.firstWhereOrNull((e) => e.id == id);

      if (target == null) {
        Get.snackbar("Gagal", "Ayam dengan ID $id tidak ditemukan");
        return;
      }

      if (target.kategori.toLowerCase() == targetKategori.toLowerCase()) {
        Get.snackbar("Info", "Ayam ini sudah di kategori '$targetKategori'");
        return;
      }

      final updated = target.copyWith(kategori: targetKategori);
      await updateAyam(updated);

      Get.snackbar("Sukses", "Ayam ID $id telah diperbarui ke $targetKategori");
    }
  }
}
