import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_uas/Feature/auth/controller/Auth_controller.dart';
import 'package:project_uas/utils/service/Firebase_service.dart';
import 'package:mockito/mockito.dart';
import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_uas/Feature/auth/model/User.dart';

class MockTextEditingController extends Mock implements TextEditingController{}
class MockFirebaseAuth extends Mock implements FirebaseAuth{}
class MockFirebaseService extends Mock implements FirebaseService{}
class MockUser extends Mock implements User{}
class MockUserModel extends Mock implements UserModel{}
class MockUserCredential extends Mock implements UserCredential{}


void main(){
  MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  MockFirebaseService mockFirebaseService = MockFirebaseService();
  MockTextEditingController mockEmailController = MockTextEditingController();
  MockTextEditingController mockPasswordController = MockTextEditingController();
  MockUser mockUser = MockUser();
  MockUserModel mockUserModel = MockUserModel();
  MockUserCredential mockUserCredential = MockUserCredential();
  

    setUp(() async {
      late AuthController authController;
      late MockFirebaseAuth mockFirebaseAuth;
      late MockFirebaseService mockFirebaseService;
      late MockTextEditingController mockEmailController;
      late MockTextEditingController mockPasswordController;
      late MockUser mockUser;
      late MockUserModel mockUserModel;
    });

}

