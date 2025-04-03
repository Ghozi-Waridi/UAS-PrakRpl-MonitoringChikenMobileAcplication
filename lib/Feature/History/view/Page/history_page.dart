import 'package:flutter/material.dart';
import 'package:project_uas/Feature/History/controller/History_controller.dart';

class HistoryPage extends StatelessWidget {

  HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dataList = HistoryController.to;
    return Scaffold(

      appBar: AppBar(title: Text("History Page")),
      body: Center(
        child:


        ListView.builder(
          itemCount: dataList.listAyam.length,
          itemBuilder: (context, index) {
            final data = dataList.listAyam[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: data.kategori.toLowerCase() == "hidup" ? Colors.green : Colors.red,
                ),
                child: ListTile(
                  title: Text(
                    "Id : ${data.id}",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Tanggal : ${data.tanggal}",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
