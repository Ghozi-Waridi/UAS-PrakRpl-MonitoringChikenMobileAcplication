import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:project_uas/Feature/auth/controller/Auth_controller.dart';
import 'package:project_uas/Feature/auth/model/User.dart';
import 'package:project_uas/utils/service/Firebase_service.dart';
// import 'auth_testing.mocks.dart';
import 'package:firebase_core/firebase_core.dart';

class MockTextEditingController extends Mock implements TextEditingController {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseService extends Mock implements FirebaseService {}
class MockUser extends Mock implements User {}
class MockUserCredential extends Mock implements UserCredential {}

class MockUserModel extends Mock implements UserModel {}

class MockGet extends Mock {
  void snackbar(String title, String message, {SnackPosition? snackPosition}) {}
  void offAllNamed(String routeName) {}
}

// @GenerateMocks([FirebaseAuth, FirebaseService, User, UserCredential])
void main() async{


  late AuthController authController;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseService mockFirebaseService;
  late MockTextEditingController mockEmailController;
  late MockTextEditingController mockPasswordController;
  late MockUser mockUser;
  late MockUserModel mockUserModel;
  late MockUserCredential mockUserCredential;

  setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseService = MockFirebaseService();
    mockEmailController = MockTextEditingController();
    mockPasswordController = MockTextEditingController();
    mockUser = MockUser();
    mockUserModel = MockUserModel();
    mockUserCredential = MockUserCredential();
    Get.testMode = true;
    Get.put<MockGet>(MockGet());

    authController = AuthController(
      // auth: mockFirebaseAuth,
      // firebaseService: mockFirebaseService,
    );
    authController.emailController = mockEmailController;
    authController.passwordController = mockPasswordController;
    authController.auth = mockFirebaseAuth;
    authController.firenaseService = mockFirebaseService;

    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.email).thenReturn('ghozi@gmail.com');
  });
  tearDown(() {
    Get.reset();
  });
  group('AuthController Test', () {
    group('Login Method', () {
      test('should Login succesfully and load user data', () async {
        when(mockEmailController.text).thenReturn("ghozi@gmail.com");
        when(mockPasswordController.text).thenReturn("ghozi123");
        when(
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: "ghozi@gmail.com",
            password: "ghozi123",
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(
          mockFirebaseService.getUser("ghozi@gmail.com"),
        ).thenAnswer((_) async => mockUserModel);

        final result = await authController.login(
          "ghozi@gmail.com",
          "ghozi123",
        );

        expect(result, true);
        expect(authController.userModel.value, mockUserModel);
        expect(authController.isLoading, false);
        verify(mockFirebaseService.getUser("ghozi@gmail.com")).called(1);
      });

      test('should handle user-not-found error', () async {
        when(mockEmailController.text).thenReturn('user@gmail.com');
        when(mockPasswordController.text).thenReturn('password123');
        when(
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'user@gmail.com',
            password: 'password123',
          ),
        ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

        final result = await authController.login(
          'test@example.com',
          'password123',
        );
        expect(result, false);
        expect(authController.isLoading.value, false);
        verifyNever(mockFirebaseService.getUser("user@gmail.com"));
      });

      test("should handle wrong-password error", () async {
        when(mockEmailController.text).thenReturn("ghozi@gmail.com");
        when(mockPasswordController.text).thenReturn("salahPW");
        when(
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: "ghozi@gmail.com",
            password: "salahPw",
          ),
        ).thenThrow(FirebaseAuthException(code: "wrong-password"));

        final result = await authController.login("ghozi@gmail.com", "salahPw");

        expect(result, false);
        expect(authController.isLoading.value, false);
        verifyNever(mockFirebaseService.getUser("ghozi@gmail.com"));
      });

      test("should handle general error", () async {
        when(mockEmailController.text).thenReturn("ghozi@gmail.com");
        when(mockPasswordController.text).thenReturn("ghozi12345");
        when(
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: "ghozi@gmail.com",
            password: "ghozi12345",
          ),
        ).thenThrow(Exception("General error"));
        final result = await authController.login(
          "ghozi@gmail.com",
          "ghozi12345",
        );

        expect(result, false);
        expect(authController.isLoading, false);
        verifyNever(mockFirebaseService.getUser("ghozi@gmail.com"));
      });
    });
  });
}
