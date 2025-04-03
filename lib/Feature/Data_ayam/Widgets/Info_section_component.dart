import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/Feature/Data_ayam/controller/DataAyam_controller.dart';

class InfoSectionComponent extends StatelessWidget {
  final String image;
  final String nama;
  final bool isHidup;
  final Color color;
  const InfoSectionComponent({
    super.key,
    required this.image,
    required this.nama,
    this.isHidup = true,
    this.color = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    final controller = DataAyamController.to;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 20),
      height: 300,
      width: MediaQuery.of(context).size.width / 2 - 32,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Image.asset(image, height: 80, width: 80, fit: BoxFit.cover),
          SizedBox(height: 20),
          Text(
            '$nama',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 20),

          Obx(() {
            final jumlah =
                nama.toLowerCase() == 'hidup'
                    ? controller.jumlahHidup.value
                    : controller.jumlahMati.value;

            return Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$jumlah",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            );
          }),
        ],
      ),
    );
  }
}
