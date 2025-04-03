import 'package:firebase_database/firebase_database.dart';
import 'package:project_uas/Feature/History/model/DataAyam.dart';
import 'package:project_uas/Feature/Informations/model/DataTelur.dart';

class FirebaseService {
  final DatabaseReference refAyam = FirebaseDatabase.instance.ref("dataAyam");
  final DatabaseReference _refTelur = FirebaseDatabase.instance.ref("dataTelur");

  // ================== AYAM ==================


  Future<void> createAyam(DataAyam ayam) async {
    final snapshot = await refAyam.get();
    int nextId = 1;

    if (snapshot.exists) {
      nextId = snapshot.children.length + 1;
    }

    final customId = nextId.toString().padLeft(3, '0');
    await refAyam.child(customId).set(ayam.toJson());
  }


  Future<List<DataAyam>> getAllAyam() async {
    final snapshot = await refAyam.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return data.entries.map((entry) {
        final id = entry.key;
        final val = Map<String, dynamic>.from(entry.value);
        return DataAyam.fromJson(val, id);
      }).toList();
    }

    return [];
  }


  Future<void> updateAyam(DataAyam ayam) async {
    if (ayam.id?.isEmpty ?? true) return;
    await refAyam.child(ayam.id!).update(ayam.toJson());
  }


  Future<void> deleteAyam(String id) async {
    if (id.isEmpty) return;
    await refAyam.child(id).remove();
  }

  // ================== TELUR ==================


  Future<void> createTelur(DataTelur telur) async {
    final snapshot = await _refTelur.get();
    int nextId = 1;

    if (snapshot.exists) {
      nextId = snapshot.children.length + 1;
    }

    final customId = nextId.toString().padLeft(3, '0');
    await _refTelur.child(customId).set(telur.toJson());
  }


  Future<List<DataTelur>> getAllTelur() async {
    final snapshot = await _refTelur.get();

    if (snapshot.exists) {
      final raw = snapshot.value as Map<Object?, Object?>;
      return raw.entries.map((entry) {
        final valueMap = Map<String, dynamic>.from(entry.value as Map);
        return DataTelur.fromJson(valueMap, entry.key.toString());
      }).toList();
    }

    return [];
  }


  Future<void> updateTelur(DataTelur telur) async {
    if (telur.id?.isEmpty ?? true) return;
    await _refTelur.child(telur.id!).update(telur.toJson());
  }


  Future<void> deleteTelur(String id) async {
    if (id.isEmpty) return;
    await _refTelur.child(id).remove();
  }
}
