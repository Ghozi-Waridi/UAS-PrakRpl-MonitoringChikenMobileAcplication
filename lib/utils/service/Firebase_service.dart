// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project_uas/Feature/History/model/DataAyam.dart';
import 'package:project_uas/Feature/Informations/model/DataTelur.dart';
import 'package:project_uas/Feature/auth/model/User.dart';
// import 'package:project_uas/Feature/Informations/model/User.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final DatabaseReference refAyam = FirebaseDatabase.instance.ref("dataAyam");
  final DatabaseReference refTelur = FirebaseDatabase.instance.ref(
    "dataTelur",
  );
  final DatabaseReference _userRef = FirebaseDatabase.instance.ref('users');
  final FirebaseAuth auth = FirebaseAuth.instance;
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
    final snapshot = await refTelur.get();
    int nextId = 1;

    if (snapshot.exists) {
      nextId = snapshot.children.length + 1;
    }

    final customId = nextId.toString().padLeft(3, '0');
    await refTelur.child(customId).set(telur.toJson());
  }

  Future<List<DataTelur>> getAllTelur() async {
    final snapshot = await refTelur.get();

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
    await refTelur.child(telur.id!).update(telur.toJson());
  }

  Future<void> deleteTelur(String id) async {
    if (id.isEmpty) return;
    await refTelur.child(id).remove();
  }

  //=========auth=========
  User? get currentUser => auth.currentUser;

  // Get user data from Firebase Realtime Database
  Future<UserModel?> getUser(String email) async {
    try {
      String safeEmail = email.replaceAll('.', '_');
      DatabaseEvent event = await _userRef.child(safeEmail).once();
      
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        return UserModel.fromJson(Map<String, dynamic>.from(data), data['idUser']);
      }
      return null;
    } catch (e) {
      print("Error getting user data: $e");
      return null;
    }
  }  // Future<UserModel?> getUserData(String email) async {
  //   try {
  //     String safeEmail = email.replaceAll('.', '_');
  //     DatabaseEvent event = await _userRef.child(safeEmail).once();
  //     final data = event.snapshot.value as Map<dynamic, dynamic>;
  //     return UserModel.fromJson(Map<String, dynamic>.from(data), data['idUser']);   
  //   } catch (e) {
  //     print("Error getting user data: $e");
  //     return null;
  //   }
  // }
  Future<void> saveUser(String email, String password, String peran) async {
    try {
      String safeEmail = email.replaceAll('.', '_');
      int idUser = DateTime.now().millisecondsSinceEpoch;

      await _userRef.child(safeEmail).set({
        'idUser': idUser,
        'username': email,
        'password': password,
        'peran': peran,
      });
    } catch(e) {
      print("Error saving user: $e");
    }
  }
}
