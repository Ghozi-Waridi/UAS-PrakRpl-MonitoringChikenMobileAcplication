import 'dart:ui';

import 'package:flutter/material.dart';
class CardMenuComponent extends StatelessWidget {
  final String id_menu;
  final String keterangan;
  final bool isLife;
  final int jumlah;
  final double rounded;
  final Color color;

  const CardMenuComponent({
    super.key,
    required this.id_menu,
    required this.keterangan,
    required this.isLife,
    required this.jumlah,
    required this.rounded,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/chicken.png', height: 60, width: 60),
        const SizedBox(height: 8),
        Text(id_menu, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),

        // ✅ Perbaikan di bagian status & jumlah
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: keterangan == "Afkir" ? Colors.red : Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "$keterangan | $jumlah",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
