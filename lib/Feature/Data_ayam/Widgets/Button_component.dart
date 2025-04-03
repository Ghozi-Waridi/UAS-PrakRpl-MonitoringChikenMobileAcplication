import 'package:flutter/material.dart';
import 'package:project_uas/Feature/Data_ayam/controller/DataAyam_controller.dart';

class ButtonComponent extends StatelessWidget {
  final String nama;
  const ButtonComponent({super.key, this.nama = 'hidup'});

  @override
  Widget build(BuildContext context) {
    final controller = DataAyamController.to;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white10,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              controller.tambahAyamDenganKonfirmasi(
                context,
                nama.toLowerCase(),
              );
            },
            icon: Icon(Icons.add_circle),
            iconSize: 70,
            color: Colors.green,
          ),
          IconButton(
            onPressed: () {
              final targetKategori =
                  nama.toLowerCase() == 'hidup' ? 'mati' : 'hidup';
              controller.inputIdDanUpdateKategori(context, targetKategori);
            },
            icon: Icon(Icons.remove_circle),
            iconSize: 70,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
