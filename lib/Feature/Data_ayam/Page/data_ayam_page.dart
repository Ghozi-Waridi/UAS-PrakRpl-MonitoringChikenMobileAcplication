import 'package:flutter/material.dart';
import 'package:project_uas/Constant/Contants/Image_Constant.dart';
import 'package:project_uas/Feature/Data_ayam/Widgets/Button_component.dart';
import 'package:project_uas/Feature/Data_ayam/Widgets/Info_section_component.dart';

class DataAyamPage extends StatelessWidget {
  const DataAyamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Data Ayam Page")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InfoSectionComponent(
                      image: ImageConstant().ic_sehat,
                      nama: "Hidup",
                    ),
                    InfoSectionComponent(
                      image: ImageConstant().ic_mati,
                      nama: "Mati",
                      isHidup: false,
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              ButtonComponent()
            ],
          ),

        ),
      ),
    );
  }
}








          // SizedBox(height: 20),

          // isHidup
          //     ? Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(30),
          //         color: Colors.white,
          //       ),
          //       child: Row(
          //         children: [
          //           IconButton(
          //             onPressed: () {
          //               controller.tambahAyamDenganKonfirmasi(
          //                 context,
          //                 nama.toLowerCase(),
          //               );
          //             },
          //             icon: Icon(Icons.add_circle),
          //             iconSize: 40,
          //             color: Colors.green,
          //           ),
          //           IconButton(
          //             onPressed: () {
          //               final targetKategori =
          //                   nama.toLowerCase() == 'hidup' ? 'mati' : 'hidup';
          //               controller.inputIdDanUpdateKategori(
          //                 context,
          //                 targetKategori,
          //               );
          //             },
          //             icon: Icon(Icons.remove_circle),
          //             iconSize: 40,
          //             color: Colors.red,
          //           ),
          //         ],
          //       ),
          //     )
          //     : Container(),
