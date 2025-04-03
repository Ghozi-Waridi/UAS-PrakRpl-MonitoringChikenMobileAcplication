import 'package:get/get.dart';

class KandangModel {
  final String idKandang;
  RxInt ayamHidup;
  RxInt ayamMati;

  KandangModel({
    required this.idKandang,
    required int hidup,
    required int mati,
  })  : ayamHidup = hidup.obs,
        ayamMati = mati.obs;
}

class KandangController extends GetxController {
  var daftarKandang = <KandangModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Dummy data awal (nanti bisa diganti dari Firebase)
    daftarKandang.addAll([
      KandangModel(idKandang: 'K1', hidup: 10, mati: 2),
      KandangModel(idKandang: 'K2', hidup: 5, mati: 1),
      KandangModel(idKandang: 'K3', hidup: 20, mati: 0),
    ]);
  }

  void tambahHidup(KandangModel kandang) {
    kandang.ayamHidup++;
    // TODO: update ke Firebase kalau perlu
  }

  void kurangHidup(KandangModel kandang) {
    if (kandang.ayamHidup > 0) kandang.ayamHidup--;
  }

  void tambahMati(KandangModel kandang) {
    kandang.ayamMati++;
  }

  void kurangMati(KandangModel kandang) {
    if (kandang.ayamMati > 0) kandang.ayamMati--;
  }
}
