
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:project_uas/Feature/Informations/controller/Information_controller.dart';
// import 'package:project_uas/Feature/Informations/view/Widgets/Card_menu_component.dart';
// import '../../../../Shared/ColorStyle.dart' as ColorStyle;

// class InformationPage extends StatelessWidget {
//   const InformationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = InformationController.to;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("InformationPage"),
//         backgroundColor: ColorStyle.primaryColor,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Obx(() {
//             // Mendapatkan ayam yang hidup
//             final listAyam = controller.listAyam;
//             final totalTelur = controller.totalTelurByAyam;

//             if (listAyam.isEmpty) {
//               return const Center(child: Text("Tidak ada ayam hidup."));
//             }

//             return Wrap(
//               spacing: 16,
//               runSpacing: 16,
//               children: listAyam.map((ayam) {
//                 final idAyam = ayam.id!;
//                 final jumlahTelur = totalTelur[idAyam] ?? 0;
//                 final isAfkir = controller.isAfkirMap[idAyam] ?? false;

//                 return InkWell(
//                   onTap: () {
//                     print("Afkir: ${idAyam.runtimeType}");
//                     print("Afkir: ${controller.isAfkirMap[idAyam]}");
//                     Get.toNamed("/detailInformation");
//                   },
//                   child: Container(
//                     width: MediaQuery.of(context).size.width / 2 - 24,
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.blueAccent,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: CardMenuComponent(
//                       rounded: 20,
//                       color: Colors.transparent,
//                       id_menu: idAyam,
//                       keterangan: isAfkir ? "Afkir" : "Sehat", // Status afkir atau sehat
//                       isLife: true,
//                       jumlah: jumlahTelur,
//                     ),
//                   ),
//                 );
//               }).toList(),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/Feature/Informations/controller/Information_controller.dart';
import 'package:project_uas/Feature/Informations/view/Widgets/Card_menu_component.dart';
import '../../../../Shared/ColorStyle.dart' as ColorStyle;

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  final InformationController controller = InformationController.to;
  
  @override
  void initState() {
    super.initState();
    controller.initRealtimeListeners();
  }

  @override
  void dispose() {
    controller.disposeRealtimeListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("InformationPage"),
        backgroundColor: ColorStyle.primaryColor,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final listAyam = controller.listAyam;
          final totalTelur = controller.totalTelurByAyam;
          
          if (listAyam.isEmpty) {
            return const Center(child: Text("Tidak ada ayam hidup."));
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: listAyam.map((ayam) {
                final idAyam = ayam.id!;
                print("Id Ayam Afkir : ${idAyam}");
                final jumlahTelur = totalTelur[idAyam] ?? 0;
                print("afkir View : ${controller.isAfkirMap[idAyam]}");
                final isAfkir = controller.isAfkirMap[idAyam[2]] ?? false;
                
                return InkWell(
                  onTap: () {
                    Get.toNamed("/detailInformation", arguments: idAyam);
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
                      keterangan: isAfkir ? "Afkir" : "Sehat",
                      isLife: true,
                      jumlah: jumlahTelur,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ),
    );
  }
}