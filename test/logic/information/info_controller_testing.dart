// import 'package:flutter_test/flutter_test.dart';
// import 'package:get/get.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:project_uas/Feature/History/model/DataAyam.dart';
// import 'package:project_uas/Feature/Informations/model/DataTelur.dart';
// import 'package:project_uas/utils/service/Firebase_service.dart';
// import 'package:project_uas/Feature/Informations/controller/InformationController.dart';
// import 'information_controller_test.mocks.dart';

// @GenerateMocks([FirebaseService])
// void main() {
//   late MockFirebaseService mockFirebaseService;
//   late InformationController controller;

//   setUp(() {
//     // Initialize mocks and controller before each test
//     mockFirebaseService = MockFirebaseService();
//     Get.reset(); // Reset GetX state
//     Get.put<FirebaseService>(mockFirebaseService); // Bind mock service
//     controller = InformationController();
//   });

//   tearDown(() {
//     Get.reset(); // Clean up after each test
//   });

//   group('InformationController Tests', () {
//     test('Initial state is loading and lists are empty', () {
//       expect(controller.isLoading.value, true);
//       expect(controller.listTelur.isEmpty, true);
//       expect(controller.listAyam.isEmpty, true);
//       expect(controller.isAfkirMap.isEmpty, true);
//       expect(controller.isAfkir.value, false);
//     });

//     test('loadAllData populates lists with data from FirebaseService', () async {
//       // Arrange
//       final mockAyamData = [
//         DataAyam(id: '1', kategori: 'Hidup', name: 'Ayam1'),
//         DataAyam(id: '2', kategori: 'Hidup', name: 'Ayam2'),
//       ];
//       final mockTelurData = [
//         DataTelur(id: '1', idAyam: '1', jumlah: 5, tanggal: '2025-05-01'),
//         DataTelur(id: '2', idAyam: '2', jumlah: 0, tanggal: '2025-05-01'),
//       ];

//       when(mockFirebaseService.getAllAyam()).thenAnswer((_) async => mockAyamData);
//       when(mockFirebaseService.getAllTelur()).thenAnswer((_) async => mockTelurData);

//       // Act
//       await controller.loadAllData();

//       // Assert
//       expect(controller.isLoading.value, false);
//       expect(controller.listAyam.length, 2);
//       expect(controller.listTelur.length, 2);
//       expect(controller.listAyam[0].id, '1');
//       expect(controller.listTelur[0].jumlah, 5);
//     });

//     test('listenToAyam updates listAyam on Firebase data change', () {
//       // Arrange
//       final mockAyamData = {
//         '1': {'id': '1', 'kategori': 'Hidup', 'name': 'Ayam1'},
//         '2': {'id': '2', 'kategori': 'Mati', 'name': 'Ayam2'},
//       };
//       final mockStream = Stream.fromIterable([
//         DatabaseEvent(const DatabaseReferenceMock(), mockAyamData),
//       ]);

//       when(mockFirebaseService.refAyam).thenReturn(DatabaseReferenceMock());
//       when(mockFirebaseService.refAyam.onValue).thenAnswer((_) => mockStream);

//       // Act
//       controller.listenToAyam();

//       // Assert
//       expect(controller.listAyam.length, 2);
//       expect(controller.listAyam[0].id, '1');
//       expect(controller.listAyam[1].kategori, 'Mati');
//       expect(controller.isLoading.value, false);
//     });

//     test('listenToTelur updates listTelur on Firebase data change', () {
//       // Arrange
//       final mockTelurData = {
//         '1': {'id': '1', 'idAyam': '1', 'jumlah': 5, 'tanggal': '2025-05-01'},
//         '2': {'id': '2', 'idAyam': '2', 'jumlah': 0, 'tanggal': '2025-05-02'},
//       };
//       final mockStream = Stream.fromIterable([
//         DatabaseEvent(const DatabaseReferenceMock(), mockTelurData),
//       ]);

//       when(mockFirebaseService.refTelur).thenReturn(DatabaseReferenceMock());
//       when(mockFirebaseService.refTelur.onValue).thenAnswer((_) => mockStream);

//       // Act
//       controller.listenToTelur();

//       // Assert
//       expect(controller.listTelur.length, 2);
//       expect(controller.listTelur[0].jumlah, 5);
//       expect(controller.listTelur[1].tanggal, '2025-05-02');
//       expect(controller.isLoading.value, false);
//     });

//     test('cekAfkir marks chicken as afkir after 15 days of no eggs', () {
//       // Arrange
//       controller.listAyam.assignAll([
//         DataAyam(id: '1', kategori: 'Hidup', name: 'Ayam1'),
//       ]);
//       final telurData = List.generate(
//         15,
//         (index) => DataTelur(
//           id: '${index + 1}',
//           idAyam: '1',
//           jumlah: 0,
//           tanggal: '2025-05-${(index + 1).toString().padLeft(2, '0')}',
//         ),
//       );
//       controller.listTelur.assignAll(telurData);

//       // Act
//       controller.cekAfkir();

//       // Assert
//       expect(controller.isAfkirMap['1'], true);
//       expect(controller.isAfkir.value, true);
//     });

//     test('totalTelurByAyam calculates total eggs per chicken', () {
//       // Arrange
//       controller.listTelur.assignAll([
//         DataTelur(id: '1', idAyam: '1', jumlah: 5, tanggal: '2025-05-01'),
//         DataTelur(id: '2', idAyam: '1', jumlah: 3, tanggal: '2025-05-02'),
//         DataTelur(id: '3', idAyam: '2', jumlah: 2, tanggal: '2025-05-01'),
//       ]);

//       // Act
//       final result = controller.totalTelurByAyam;

//       // Assert
//       expect(result['1'], 8); // 5 + 3
//       expect(result['2'], 2);
//     });

//     test('getTelurPerHariPerBulan groups eggs by month and day', () {
//       // Arrange
//       controller.listTelur.assignAll([
//         DataTelur(id: '1', idAyam: '1', jumlah: 5, tanggal: '2025-05-01'),
//         DataTelur(id: '2', idAyam: '1', jumlah: 3, tanggal: '2025-05-02'),
//         DataTelur(id: '3', idAyam: '2', jumlah: 2, tanggal: '2025-06-01'),
//       ]);

//       // Act
//       final result = controller.getTelurPerHariPerBulan();

//       // Assert
//       expect(result['2025-05']!['2025-05-01'], 5);
//       expect(result['2025-05']!['2025-05-02'], 3);
//       expect(result['2025-06']!['2025-06-01'], 2);
//       expect(result['2025-05']!['2025-05-03'], 0); // No eggs, should be 0
//     });
//   });
// }

// // Mock classes for Firebase dependencies
// class DatabaseReferenceMock extends Mock implements DatabaseReference {}

// class DatabaseEvent {
//   final DatabaseReference ref;
//   final Map<dynamic, dynamic>? snapshotValue;

//   DatabaseEvent(this.ref, this.snapshotValue);

//   Map<dynamic, dynamic>? get snapshot => snapshotValue;
// }
