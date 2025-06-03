import 'package:flutter/material.dart';

class CardMenuComponent extends StatelessWidget {
  final double rounded;
  final Color color;
  final String id_menu;
  final String keterangan;  // Status Afkir atau Sehat
  final bool isLife;
  final int jumlah;

  const CardMenuComponent({
    Key? key,
    required this.rounded,
    required this.color,
    required this.id_menu,
    required this.keterangan,
    required this.isLife,
    required this.jumlah,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(rounded),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ID Ayam: $id_menu',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
               color: keterangan == "Afkir" ? Colors.red : Colors.green,
              borderRadius: BorderRadius.circular(8)
            ),
            child: Text(
              'Status: $keterangan',  // Menampilkan status Afkir atau Sehat
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Jumlah Telur: $jumlah',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
