// import 'package:flutter/material.dart';
// import 'package:project_uas/Feature/History/model/DataAyam.dart';
// import 'package:project_uas/Feature/Informations/model/DataTelur.dart';
// import 'package:project_uas/utils/service/Firebase_service.dart';

// class Testcoba extends StatefulWidget {
//   @override
//   State<Testcoba> createState() => _TestcobaState();
// }

// class _TestcobaState extends State<Testcoba> {
//   final FirebaseService service = FirebaseService();
//   List<DataAyam> listAyam = [];
//   List<DataTelur> listTelur = [];

//   @override
//   void initState() {
//     super.initState();
//     loadAllData();
//   }

//   Future<void> loadAllData() async {
//     final ayam = await service.getAllAyam();
//     final telur = await service.getAllTelur();
//     setState(() {
//       listAyam = ayam;
//       listTelur = telur;
//     });
//   }

//   Future<void> addDummyData() async {
//     await service.createAyam(DataAyam(kategori: "Sehat"));
//     await service.createTelur(
//       DataTelur(idAyam: 1, jumlah: 10, tanggal: "2021-08-01"),
//     );
//     loadAllData();
//   }

//   Future<void> updateFirstTelur() async {
//     if (listTelur.isNotEmpty) {
//       final telur = listTelur.first;
//       telur.jumlah += 1;
//       await service.updateTelur(telur);
//       loadAllData();
//     }
//   }

//   Future<void> deleteFirstAyam() async {
//     if (listAyam.isNotEmpty) {
//       await service.deleteAyam(listAyam.first.id!);
//       loadAllData();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Firebase CRUD")),
//       body: Column(
//         children: [
//           ButtonBar(
//             alignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: addDummyData,
//                 child: Text("Tambah Data"),
//               ),
//               ElevatedButton(
//                 onPressed: updateFirstTelur,
//                 child: Text("Update Telur Pertama"),
//               ),
//               ElevatedButton(
//                 onPressed: deleteFirstAyam,
//                 child: Text("Hapus Ayam Pertama"),
//               ),
//             ],
//           ),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.all(8),
//               children: [
//                 Text(
//                   "Data Ayam",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: listAyam.length,
//                   itemBuilder: (context, index) {
//                     final ayam = listAyam[index];
//                     return ListTile(
//                       title: Text("Kategori: ${ayam.kategori}"),
//                       subtitle: Text("ID: ${ayam.id}"),
//                     );
//                   },
//                 ),
//                 Divider(),
//                 Text(
//                   "Data Telur",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: listTelur.length,
//                   itemBuilder: (context, index) {
//                     final telur = listTelur[index];
//                     return ListTile(
//                       title: Text("ID Ayam: ${telur.idAyam}"),
//                       subtitle: Text("Jumlah: ${telur.jumlah}"),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
