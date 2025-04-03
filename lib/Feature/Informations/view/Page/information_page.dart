import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/Feature/Informations/controller/Information_controller.dart';
import 'package:project_uas/Feature/Informations/view/Widgets/Card_menu_component.dart';
import '../../../../Shared/ColorStyle.dart' as ColorStyle;

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = InformationController.to;

    return Scaffold(
      appBar: AppBar(
        title: const Text("InformationPage"),
        backgroundColor: ColorStyle.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            final listAyam =
                controller.listAyam
                    .where((ayam) => ayam.kategori.toLowerCase() == 'hidup')
                    .toList();
            final totalTelur = controller.totalTelurByAyam;

            if (listAyam.isEmpty) {
              return const Center(child: Text("Tidak ada ayam hidup."));
            }

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children:
                  listAyam.map((ayam) {
                    final idAyam = ayam.id!;
                    final jumlahTelur = totalTelur[idAyam] ?? 0;

                    return InkWell(
                      onTap: () {
                        Get.toNamed("/detailInformation");
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 24,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CardMenuComponent(
                          rounded: 20,
                          color: Colors.transparent,
                          id_menu: idAyam,
                          keterangan:
                              controller.isAfkir.value ? "Afkir" : "Sehat",
                          isLife: true,
                          jumlah: jumlahTelur,
                        ),
                      ),
                    );
                  }).toList(),
            );
          }),
        ),
      ),
    );
  }
}
