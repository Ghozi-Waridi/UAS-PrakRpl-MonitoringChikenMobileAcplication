import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_uas/Feature/auth/model/User.dart';
import 'package:project_uas/utils/service/Firebase_service.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseService firenaseService = FirebaseService();

  Rx<User?> _user = Rx<User?>(null);
  Rx<bool> isLoading = false.obs;

  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  Future<void> _loadUserData(String email) async {
    try {
      isLoading(true);
      userModel.value = await firenaseService.getUser(email);
    } catch (e) {
      print("Error loading user data: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading(true);
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await _loadUserData(email);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      String message = '';

      switch (e.code) {
        case 'user-not-found':
          message = 'User tidak ditemukan.';
          break;
        case 'wrong-password':
          message = 'Password salah.';
          break;
        case 'invalid-email':
          message = 'Email tidak valid.';
          break;
        case 'user-disabled':
          message = 'Akun telah dinonaktifkan.';
          break;
        default:
          message = 'Terjadi kesalahan. Coba lagi nanti.';
      }
      Get.snackbar('Error Login', message, snackPosition: SnackPosition.BOTTOM);
      return false;
    } catch (e) {
      Get.snackbar(
        'Error Login',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan Password tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      bool success = await login(emailController.text, passwordController.text);
      if (success) {
        Get.offAllNamed('/home');
      }
    }
  }
}
