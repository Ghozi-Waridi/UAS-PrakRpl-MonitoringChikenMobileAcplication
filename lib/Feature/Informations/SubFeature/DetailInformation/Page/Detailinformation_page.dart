import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/Feature/Informations/controller/Information_controller.dart';


class Detailinformation extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final controller = InformationController.to;
    final dataPerBulan = controller.getTelurPerHariPerBulan();

    final List<String> bulanKeys = dataPerBulan.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Informasi Telur")),
      body: PageView.builder(
        controller: _pageController,
        itemCount: bulanKeys.length,
        itemBuilder: (context, index) {
          final bulan = bulanKeys[index];
          final dataHari = dataPerBulan[bulan]!;

          return _buildPage(bulan: bulan, dataHari: dataHari);
        },
      ),
    );
  }

  Widget _buildPage({required String bulan, required Map<String, int> dataHari}) {
    final List<MapEntry<String, int>> hariList = dataHari.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Bulan: $bulan",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: hariList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final entry = hariList[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${DateTime.parse(entry.key).day}",
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          "${entry.value} telur",
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
